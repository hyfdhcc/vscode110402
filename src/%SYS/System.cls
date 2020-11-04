Include %sySystem

/// The <class>%SYS.System</class> class provides an interface for managing
/// Cach&eacute; utility functions.<br>
/// <p>You can call help to get a list of all entrypoints:<br>
/// <p>
/// Do $system.Util.Help()
Class %SYS.System Extends %SYSTEM.Help [ Abstract, System = 4 ]
{

/*
---------------------Documentation------------------------------------
STC2269 02/25/14 Steve Clay, Fix %SYS.System.GetNodeName(1) to not uppercase node name
CDS1688 03/30/10 Chuck Sorenson, add method for mv.log message
STC1640 07/16/09 Steve Clay, Add new methods to %SYS.System class
STC988  05/04/06 Steve Clay, Improve performance of retrieving the temp dir
LRS969  09/12/05 Lee smith, revised $$$ERROR codes
LFT1345 12/02/4, Laura Tillem, switch to %SYS for TempDirectory
SAP269 11/17/04, Steve Pettibone, document switches
CFL1114 07/30/04, Carlos Lopes, enhance Replace method
GK333  07/29/04, Garen Kotikian, add Cache instance GUID. 
SML471 07/09/04, Simon Li, Move CleanDeadJob metheod to here.
CFL1098 07/06/04, Carlos Lopes, add Replace method
LFT1235 6/04/04, Laura Tillem, add TempDirectory
SAP177	5/11/04, Steve Pettibone, modify setbatch to SetBatch, change logic
SAP176	5/11/04, Steve Pettibone, document methods and return codes
SAP168	5/10/04, Steve Pettibone, add severity to WriteToConsoleLog
HYY883 03/04/04, Huayong Yang, add APIs for setting/clearing switches
LRS714 08/20/03, Lee Smith, implement NullDevice method
STC464 08/05/03, Steve Clay, Add WriteToConsoleLog
LRS671 03/25/03, Lee Smith, implement GetEnviron method
LRS626 08/30/02, Lee Smith, initial version with InstallDirectory,
                 ManagerDirectory, and BinaryDirectory methods
-------------------End Documentation----------------------------------
*/
/// Returns the location of the Temp directory, where temporary files are kept.
ClassMethod TempDirectory() As %String
{
 q $g($$$SYSTempDir)
}

/// State of a switch: 0 (clear) or 1 (set) or -1,Detail (error)
/// 
ClassMethod GetSwitchState(switch As %Integer) As %Status [ Internal ]
{
	q $$%swstat^|"%SYS"|SWSET(switch,1)
}

/// System Switches<br>
/// Switches are used to inhibit certain kinds of processing while utilities
/// such as Backups are being run.<br>
/// Switches 8 & 9 may be of use for specialized customer applications:<br>
/// Switch 8 - Inhibits responding to net requests<br>
/// Switch 9 - Inhibits new network signons<br>
/// The remaining switches are used to quiesce the system or provide a static environment
/// for doing backups or examining the system<br>
/// Switches 10, 12 and 13 are normally set the user is running backups<br>
/// Switch 14 may be used to maintain application consistency or block contention<br>
/// Switch 10 - Inhibits all global access except for the calling job<br>
/// This switch is used with backups to coordinate with Transaction Processing.
/// Use of this switch makes sure there are no transactions open when you clear
/// the journal after you complete your backup.
/// Switch 12 - Inhibit attempts to sign on
/// Switch 13 - Inhibit sets, kills, and zsaves
/// Switch 14 - Inhibit access to globals and routines
/// <br>
/// The following system functions for manipulating switches are provided:<br>
/// Toggle a switch (from set to clear or clear to set) on local system<br>
/// Set a switch on local system (error if switch is already set)<br>
/// Clear a switch on local system (error if switch is already clear)<br>
/// 
/// Toggle a switch (from set to clear or clear to set) on local system
ClassMethod ToggleSwitch(switch As %Integer, NewState As %Integer) As %Status
{
	s OldState='NewState
	s rc=..GetSwitchState(switch)
	i +rc'=OldState q $$$ERROR($$$UnexpectedError,$s(rc<0:rc,1:$$$Text("Already","%Utility")))
	s rc=$$%swset^|"%SYS"|SWSET(switch,NewState,1)	
	i +rc'=1 q $$$ERROR($$$UnexpectedError,rc)
	q $$$OK
}

/// Set a switch on local system (error if switch is already set)
ClassMethod SetSwitch(switch As %Integer) As %Status
{
	q ..ToggleSwitch(switch,1)
}

/// Clear a switch on local system (error if switch is already clear)
ClassMethod ClearSwitch(switch As %Integer) As %Status
{
	q ..ToggleSwitch(switch,0)
}

/// Returns instance GUID.
/// <br>
/// An instance GUID is a 16 byte (128 bit) globally unique identifier, assigned per instance of Cache installation. 
ClassMethod InstanceGUID() As %String
{
	s ns="^^"_$zu(12)
	if ('$d(^[ns]SYS("INSTANCEGUID"))) Set ^[ns]SYS("INSTANCEGUID")=$system.Util.CreateGUID()
	Q ^[ns]SYS("INSTANCEGUID")
}

/// Returns instance name.<br>
ClassMethod GetInstanceName() As %String
{
 q $p($zu(86),"*",2)
}

/// Returns the active CPF file name.<br>
ClassMethod GetCPFFileName() As %String
{
 q $p($zu(86),"*",1)
}

/// Returns NodeName:InstanceName.<br>
/// This method returns the Node name of the system followed by a ":" followed by
/// the Instance name. This name will be unique among Cache Instances in your network.<br>
/// Parameters:<br>
/// Flag = 0 (default) - Node name is the capitalized FQDN of the node, which will include 
/// the domain name.<br>
/// For example:<br><br>
/// CACHENODE.INTERNAL.COM:101U<br><br>
/// Flag = 1 - Node name does not contain the domain name.<br>
/// For example:<br><br>
/// CACHENODE:101U<br>
ClassMethod GetUniqueInstanceName(Flag As %Integer = 0) As %String
{
 s $zt="Error"
 i Flag=0 s Node=$p($zu(54,13,$zu(110)),",",2)
 i $g(Node)="" s Node=$zu(110)
 q $zcvt(Node,"U")_":"_$p($zu(86),"*",2)
Error s $zt=""
 q $zcvt($zu(110),"U")_":"_$p($zu(86),"*",2)
}

/// Returns the node name of the machine you are running on.<br>
/// Parameters:<br>
/// Flag = 0 (default) - Node name is the capitalized FQDN of the node, which will include 
/// the domain name.<br>
/// For example:<br><br>
/// CACHENODE.INTERNAL.COM<br><br>
/// Flag = 1 - Node name of the machine as defined in the O/S.<br>
/// For example:<br><br>
/// CacheNode<br>
ClassMethod GetNodeName(Flag As %Integer = 0) As %String
{
 s $zt="Error"
 i Flag=0 {
	s Node=$p($zu(54,13,$zu(110)),",",2)
	i $g(Node)="" s Node=$zu(110)
	q $zcvt(Node,"U")
 }
 q $zu(110)
Error s $zt=""
 i Flag=0 q $zcvt($zu(110),"U")
 q $zu(110)
}

/// Returns the total amount of MBs used by global cache.
ClassMethod GetGlobalCache() As %Integer [ Internal ]
{
 s $zt="Error"
 Set n=$listtostring($System.Util.GlobalBuffers())
 Set blksize=1 
 For i=1:1:6 Set blksize=blksize*2,$p(n,",",i)=$p(n,",",i)*blksize\1024
 s tot=0 f i=1:1:$l(n,",") s tot=tot+$p(n,",",i) 
 q tot
Error Set $zt="" Quit 0
}

/// Returns the total amount of MBs used as routine cache.
ClassMethod GetRoutineCache() As %Integer [ Internal ]
{
 Set $zt="undefrtn"
 Set rb=$System.Util.RoutineBuffers()
 If rb'["," Quit rb\1024\1024
 Set tot=0
 For i=1:1:$Length(rb,",") Set tot=tot+$p(rb,",",i)
 Quit tot
undefrtn ;
 Quit ""
}

/// Write a message to the cconsole.log file.
/// <br>
/// Flag = 1 - write it to the operator console as well<br>
/// Severity - severity of condition<br>
/// Severity = 0 (Information), 1 (Warning), 2 (Severe), 3 (Fatal)
ClassMethod WriteToConsoleLog(Message As %String, Flag As %Integer = 0, Severity As %Integer = 0) As %Status
{
 i Flag>1 s Flag=1
 i Flag<0 s Flag=0
 i Severity<0 s Severity=0
 i Severity>4 s Severity=4
 d $zu(9,"",Message,Flag,Severity)
 q $$$OK
}

/// Write a message to the mv.log file.
/// <br>Severity = 0 (Information), 1 (Warning), 2 (Severe), 3 (Fatal)
ClassMethod WriteToMVLog(Message As %String, Severity As %Integer = 0) As %Status
{
 s:Severity<0 Severity=0 s:Severity>3 Severity=3
 d $zu(9,"",Message,$$$MVMSG,Severity)
 q $$$OK
}

/// Get the DefaultSignatureHash property from Security.System
ClassMethod GetDefaultSignatureHash(defaultSignatureHash As %String) As %Status
{
	Set $zt="GetDefaultSignatureHashError"
	Set defaultSignatureHash=""
	$$$AddAllRoleTemporary
	New $namespace
	Set $namespace="%SYS"

	Set system=##class(Security.System).%OpenId($$$SystemSecurityName,,.sc)
	If $$$ISOK(sc) {
		Set defaultSignatureHash=system.DefaultSignatureHash
	}
	Quit sc

GetDefaultSignatureHashError Set $zt=""
	Quit $$$ERROR($$$CacheError,$ze)
}

}
