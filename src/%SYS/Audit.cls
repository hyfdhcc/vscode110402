Include (%syAudit, %syJrninc, %syEMS)

/// The Cache auditing system allows the user to capture events
/// which occur on the system, and log them to an audit file.
/// <br><br>
/// When running SQL queries on the audit log, it is helpful to use the UTCTimestamp
/// in the WHERE clause to speed up the query, and minimize the amount of data
/// which is returned. For example: <br><br>
/// 
/// 	SELECT SystemID,AuditIndex,UTCTimeStamp,EventSource,EventType,Event,Pid,CSPSessionID,Username,Description<br>
/// 	FROM Audit<br>
/// 	WHERE UTCTimeStamp BETWEEN :UTCBeginDateTime AND :UTCEndDateTime<br>
/// 	ORDER BY UTCTimeStamp DESC, SystemID DESC, AuditIndex DESC)<br>
/// 	<br>
/// 	The UTCTimeStamp is the UTC time in ODBC format. To convert a local $H time to this format use
/// 	the following:<br><br>
/// 	s x=##Class(%SYS.Audit).ConvertLocalHToUTC($H)
/// 	<br>
/// 	The UTCTimeStamp which is returned as part of the record, can be converted to local time
/// 	with the following:<br><br>
/// 	s x=##Class(%SYS.Audit).ConvertUTCToLocal(UTCTimeStamp)<br>
/// 	
Class %SYS.Audit Extends (%Persistent, %SYSTEM.Help, %XML.Adaptor) [ Inheritance = right, StorageStrategy = Audit, System = 4 ]
{

/*
---------------------Documentation------------------------------------
STC2399 03/31/15 Steve Clay, Update SQL error trapping in %SYS.AUDIT
STC2329 09/04/14 Steve Clay, Add Authentication method to audit record
STC2260 11/21/13 Steve Clay, Remove routine location for system audit data
STC2194 03/12/13 Steve Clay, Add JobNumber property to %SYS.Audit
STC2185 02/22/13 Steve Clay, Display implied namespaces correctly in some utilities 
STC2003 10/18/11 Steve Clay, Audit record for EMS server has detailed server name
STC1888 01/07/11 Steve Clay, Update %SYS.Audit for to encode badly formed usernames for XML import
STC1852 10/27/10 Steve Clay, Add OSUsername to Audit records
STC1787 04/14/10 Steve Clay, Remove $zu(82) calls from SYS.Audit.WriteToAuditFiles()
STC1558 03/06/09 Steve Clay, Allow queries on %SYS.Audit to be run from other namespaces 
STC1529 02/27/09 Steve Clay Macros to Save and Restore Namespace 
STC1539 02/11/09 Steve Clay, Do not journal audit file conversion 
STC1458 09/29/08 Steve Clay, Add Date index to audit record 
STC1258 09/19/07 Steve Clay, Add JobId to Audit records 
STC1212 04/26/07 Steve Clay, Audit Database must have max size = 0
STC1188 03/08/07 Steve Clay, Add Index to Audit sort order to handle same time events
STC1175 03/02/07 Steve Clay, Audit setting of switches
STC1165 02/07/07 Steve Clay, Allow export of audit data with CTRL characters in it
STC1151 01/15/07 Steve Clay, New Sort and selection option for audit reports
STC1138 12/22/06 Steve Clay, Remove system name from audit sort order
STC1047 08/15/06 Steve Clay, Audit data should be of type %String not %Binary
STC1007 06/09/06 Steve Clay, Expose some security API's 
STC997 05/10/06 Steve Clay, Allow audit file to be encrypted 
STC963 01/23/06 Steve Clay, Localize audit messages
STC961 01/20/06 Steve Clay, Fix dates for audit events
STC959  1/17/06 Steve Clay, Set locale localization correctly for auditing
STC946 11/10/05 Steve Clay, Fix illegal value in utc time
STC945 11/09/05 Steve Clay, Set WDSTOP on Audit failure
STC921  09/23/05 Steve Clay, Update audit class documentation
STC914  09/12/05 Steve Clay, Fix inconsistencies between portal and ^SECURITY
RJW1156 07/22/05 Ron Watt, Decision to journal should be based on database attribute.
STC881  7/10/05 Steve Clay, Always create Audit database with %DB_CACHEAUDIT resource
STC872  7/01/05 Steve Clay, Add field for CSP Session ID to Audit record
RJW1142 6/06/05 Ron Watt, Fix SYS.Shadowing.Shadow).InitializeDatabaseRedirection() when Audit disabled
STC829 05/09/05 Steve Clay, Fix up audit length fields
LFT1419 3/02/05 Laura Tillem, add MAXLEN 128 for string properties
LFT1413 2/22/05 Laura Tillem, SYS.Global -> %GlobalEdit
STC731 12/27/04 Steve Clay, Turn off transactions when writing audit header 
RJW981 11/16/04	Ron Watt, Apply audit header from default database.
RJW966 10/27/04 Ron Watt, Insure audit header is written before export.
PWC923 11/03/04 Peter Cudhea, Created %Library.Function, %Library.Utility,
                and %Sys.System classes.
STC666 10/29/04 Steve Clay, CACHESYS/CACHELIB split
LFT1316 10/21/4 Laura Tillem, reorg $SYSTEM -> SYS
STC658 10/07/04 Steve Clay, Straighten out %All useage 
SAP240 10/06/04 Steve Pettibone, clean up index, header format
STC636 09/23/04 Steve Clay, Improve queries for export 
PWC914 09/23/04 Peter Cudhea, Add Namespace to audit record and reorder fields
STC634 09/20/04 Steve Clay, Update queries
STC633 09/17/04 Steve Clay, Add lost event count to audit record
STC632 09/16/04 Steve Clay, Fix undefined error in audit delete, localize
RJW949 09/16/04	Ron Watt, %System.Security.Audit Export/Import
STC624 09/07/04 Steve Clay, Audit Copy/Delete/Erase
STC621 08/31/04 Steve Clay, Call event initialization
STC616 08/26/04 Steve Clay, Map audit globals
STC610 08/18/04 Steve Clay, Update security classes to meet spec
STC601  6/30/04 Steve Clay, Change order of audit field display, rewrite queries
PWC797  1/07/04 Peter Cudhea-Pierce, Audit records include system name,
			Add some audit queries.
PWC795 12/23/03 Peter Cudhea-Pierce, Audit Generation now done in C Code
			Major rewrite.
STC464 08/04/03 Steve Clay, Ongoing security changes
STC433 02/14/02 Steve Clay, re-add Initialize method
STC429 02/03/03 Steve Clay, Remove Initialize method
STC427 01/31/03 Steve Clay, Fix setting of OPTION ON flag
STC426 01/28/03 Steve Clay, Don't call function to set event flags
				if the flag did not change. Also add ZAUDIT as well
				as %ZAUDIT
STCxxx  12/07/02 Steve Clay, Initial version
-------------------End Documentation----------------------------------
*/
Index IDKEY On (UTCTimeStamp, SystemID, AuditIndex) [ IdKey, Internal, Unique ];

Property AuditIndex As %BigInt;

/// Authentication method process used.
Property Authentication As Security.Datatype.Authentication;

/// Executable name on the client machine.
Property ClientExecutableName As %String(MAXLEN = 128);

/// IP address of the client.
Property ClientIPAddress As %String(MAXLEN = 128);

/// Session ID of the process if a CSP process.
Property CSPSessionID As %String(MAXLEN = 16);

/// Description of the audit event.<br>
/// Control characters less than $c(32) are not allowed in this data except
/// for CR,LF, and tab.
Property Description As %SYS.AuditString(MAXLEN = 128);

ClassMethod DescriptionLogicalToDisplay(Description As %String) As %String [ Internal ]
{
 i $e(Description,1,2)="@@" {
	 q "^^"_$e(Description,3,*)
 } else {
	q Description
 }
}

/// Name of the audit event.
Property Event As %String(MAXLEN = 64);

/// EventData -- arbitrary data associated with this event.<br>
/// Control characters less than $c(32) are not allowed in this data except
/// for CR,LF, and tab.
Property EventData As %SYS.AuditString(MAXLEN = 16384);

ClassMethod EventDataLogicalToDisplay(EventData As %String) As %String [ Internal ]
{
 i $e(EventData,1,2)="@@" {
	 q "^^"_$e(EventData,3,*)
 } else {
	q EventData
 }
}

/// Event Source (system events all have "%System" here).
Property EventSource As %String(MAXLEN = 64);

/// EventType.
Property EventType As %String(MAXLEN = 64);

/// Group of the audit event.
Property GroupName As %String(MAXLEN = 64);

/// Job ID
Property JobId As %String(MAXLEN = 16);

/// Job Number
Property JobNumber As %Integer [ Calculated, SqlComputeCode = { set {*}=$zb({JobId},65535,1)}, SqlComputed, SqlFieldName = JobNumber ];

/// Namespace process was executing in.
Property Namespace As %String(MAXLEN = 128);

ClassMethod NamespaceLogicalToDisplay(Namespace As %String) As %String [ Internal ]
{
 q $tr(Namespace,"@","^")
}

/// Operating system username of process.<br>
/// Username given to the process by the operating system when the process
/// is created. When displayed, it is truncated to 16 characters. Note that the real O/S
/// username is only returned when connecting to UNIX or VMS systems; For Windows, it 
/// will return the O/S username for a console process, but for telnet it will return
/// the $USERNAME of the process. For client connections, it contains the O/S username
/// of the client.
Property OSUsername As %String(MAXLEN = 16);

/// Process ID.<br>
/// Note that on VMS system, the Hex pid is stored internally as a decimal value, i.e. $zh(pid).
Property Pid As %String(MAXLEN = 16);

/// $ROLES value that was active when the audit event occurred.
Property Roles As %String(MAXLEN = 512);

/// Routine running including DB and System.
Property RoutineSpec As %String(MAXLEN = 128);

/// Any %Status variable passed into the call.
Property Status As %Status [ InitialExpression = 1 ];

/// SystemName:ConfigurationName of where the event was generated.<br>
/// This is useful when merging separate audit streams from different systems.
Property SystemID As %String(MAXLEN = 128);

/// User info field
Property UserInfo As %String(MAXLEN = 64);

/// Username from $Username that was active when audit event occurred.
Property Username As %SYS.AuditString(MAXLEN = 128);

/// UTC $ZTIMESTAMP value when the audit event occurred.
Property UTCTimeStamp As %String(MAXLEN = 64);

/// Apply the audit header to the audit file.<br>
ClassMethod ApplyAuditHeader() As %Status [ Internal ]
{
#; This function reads any audit records which got written to the header, and applies them
#; to the audit file. This requires the %All role.
 s $zt="ReadAuditHeaderE"
 $$$AddAllRoleTemporary ;[Verified STC 10/07/04]
#;Get the header
 l +$$$CacheAuditHeader
 s Header=$g($$$CacheAuditHeader)
#;If the header does not exist, create it, leave room for the $list overhead
 i Header="" s ($$$CacheAuditHeader,Header)=$lb($j("",$$$AuditHeaderSize-4))
#;Nothing to do
 i $ll(Header)=1 g ReadAuditHeaderEnd
#;Peel the padding
 s Header=$li(Header,1,$ll(Header)-1)
#;For each audit record (15 fields) set it into the audit database.
#;Note that if we get an error (e.g. filefull) its ok, they'll just
#;get written later, the next time this is called
 s count = $ll(Header)
 For j=1:1:count {
	s rec=$li(Header,1)
#;Get the indexes
 	s UTCTimeStamp=$li(rec,15)
 	s System=$li(rec,13)
 	s Index=$li(rec,1)
#;Set the record into the audit file
 	s $$$CacheAuditGbl(UTCTimeStamp,System,Index)=$li(rec,1,$ll(rec))
	$$$IncAuditWrittenCount($li(rec,7)_"/"_$li(rec,8)_"/"_$li(rec,5))
#;Remove record from the header, re-pad, and set it back in
 	s Header=$li(Header,2,$ll(Header))
 	f i=($$$AuditHeaderSize-$l(Header)):-1:1 q:$l(Header_$lb($j("",i)))<=$$$AuditHeaderSize
 	s $$$CacheAuditHeader=Header_$lb($j("",i))
 	i $$$JRNSTATUS f i=1:1:10 q:$$$JRNFLUSHBUF  H 1
 }
ReadAuditHeaderEnd
 l -$$$CacheAuditHeader
 q $$$OK
ReadAuditHeaderE s $zt=""
 l -$$$CacheAuditHeader
 q $$$OK
}

/// Determine if any records in the audit header are prior to EndDateTime.
ClassMethod CheckHeader(EndDateTime As %String) As %Integer [ Internal, Private ]
{
 #;Get the current header
  s Header=$g($$$CacheAuditHeader,$lb(""))
 #;Peel off the padding
  s Header=$li(Header,1,$ll(Header)-1)
 #;No records, return 0
  i $ll(Header)=0 q 0
  i '$l(EndDateTime) q 1
  i $p(EndDateTime,",",2)=0 s EndDateTime=+UTCEndDateTime_","_86399.999
  s UTCEndDateTime=..ConvertLocalHToUTC(EndDateTime)
  s n=0
  f i=1:1:$ll(Header) s UTCTimeStamp=$li($li(Header,i),15) i UTCEndDateTime]UTCTimeStamp s n=1 q
  q n
}

/// Convert from ^CacheAuditD(System,ID) to ^CacheAuditD(UTCTimeStamp,System,ID). <br>
/// The format changed between 2008.2 and 2009.1.<br>
/// Parameters:<br>
/// Count (byref) - Returned count of number of audit records converted.<br>
/// Force - 0/1 - Force reading and converting of all audit records even if 
/// version already = 2009.1.<br>
/// Note: This function automatically will get called on audit databases when they are
/// referenced the first time after an upgrade to 2009.1 or later. However, if data from
/// older systems (pre-2009.1) are merged into the system without using one of the audit
/// utilities, then the data being imported may not be indexed correctly for the system
/// to see it. If this is the case, call the Convert method in that namespace, and pass the
/// Force parameter = 1.<br>
ClassMethod Convert(ByRef Count As %Integer, Force As %Integer = 1) As %Status
{
 s $zt="Error"
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
 $$$AddAllRoleTemporary
 k Count
 s Count=0
 i $d(^CacheAuditD)=0 {
	s ^CacheAuditV=2009.1
	q $$$OK
 }
 i (Force=0),($g(^CacheAuditV)=2009.1) q $$$OK
 l +^CacheAuditD
#;Do not journal the audit conversion
 s Journal=$$CURRENT^%SYS.NOJRN
 i Journal d DISABLE^%SYS.NOJRN
 i (Force=0),($g(^CacheAuditV)=2009.1) g Exit
 $$$InfoMsg("Converting audit records to current format in namespace "_$zu(5))
#;Start with most recent audit records
 s Node=$q(^CacheAuditD(""),-1,Record)
 while Node'="" {
	i $ql(Node)=2 {
		s ^CacheAuditD($li(Record,15),$qs(Node,1),$qs(Node,2))=Record
		k @Node
		s Count=Count+1
	}
	s Node=$q(@Node,-1,Record)
 }
 s ^CacheAuditV=2009.1
 $$$InfoMsg(Count_" Audit records successfully converted")
Exit
 i Journal d ENABLE^%SYS.NOJRN
 l -^CacheAuditD
 q $$$OK
Error s $zt=""
 i +$g(Journal) d ENABLE^%SYS.NOJRN
 l -^CacheAuditD
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Convert the local $H time to an ODBC format string in UTC.<br>
/// When using SQL, use this function to convert a local time in $h to UTC time to
/// use in your SELECT statement.<br>
ClassMethod ConvertLocalHToUTC(LocalH As %String) As %String
{
 	q $zdatetime($ZU(193,LocalH,1),3,,3)
}

/// Convert a UTCTimeStamp in ODBC format to Local Time in ODBC format.<br>
ClassMethod ConvertUTCHToLocal(UTC As %String) As %String
{
 	q $zdatetime($zu(193,UTC,0),3,,3)
}

ClassMethod ConvertUTCToLocal(UTC As %String) As %String [ Internal ]
{
 	q $zdatetime($zu(193,$zdatetimeH(UTC,3),0),3,,3)
}

/// Copy matching audit records to a defined namespace.<br>
/// Parameters:<br>
/// BeginDateTime - $zdatetime($H,3) value of the first audit record to copy, "" = first record<br>
/// EndDateTime - $zdatetime($H,3) value of the Last audit record to copy, "" = Last record<br>
/// The following parameters may be specified as a comma separated list as follows:<br>
/// "*" - All records match<br>
/// "String,String1" - Any records matching one of these elements<br>
/// "String*" - Any record starting with "String"<br>
/// "String,String1*,String2" - Any record mathing one of these elements, or starting with "String1"<br>
/// Note that these are all case insensitive matches<br>
/// EventSources - Comma separated list of valid event sources<br>
/// EventTypes - Comma separated list of valid event types<br>
/// Events - Comma separated list of event names<br>
/// Usernames - Comma separated list of user names<br>
/// SystemIDs - Comma separated list of System:Config names<br> 
/// Namespace - Valid namespace to copy audit records to<br>
/// Flags - Bit 0 - Delete audit record after copy<br>
/// Return values:<br>
/// NumCopied (byref) - Number of audit records copied<br>
ClassMethod Copy(ByRef NumCopied As %Integer, Namespace As %String, Flags As %Integer = 0, BeginDateTime As %String = "", EndDateTime As %String = "", EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*", Usernames As %String = "*", SystemIDs As %String = "*") As %Status
{
 s $zt="Error"
 s NumCopied=0
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
#;namespace is the same
 i $zu(5)=$zcvt(Namespace,"U") q $$$OK
#;Make sure the audit database is in the right format
 s Status=..Convert(,0)
 i '$$$ISOK(Status) q Status
 s Status=$$ConvertDestination(Namespace)
 i '$$$ISOK(Status) q
#;Write 2 audit records in case the first one is deleted in the copy
 s CRLF=$c(13)_$c(10),String="",Pad=$j("",20)
 i Flags=0 {
 	s String=String_$$$GetMsg($$$AuditMsg,"CopyAuditData")_CRLF
 } else {
 	s String=String_$$$GetMsg($$$AuditMsg,"CopyAndDeleteAuditData")_CRLF
 }
 s String=String_$e($$$GetMsg($$$AuditMsg,"BeginDateC")_Pad,1,$l(Pad))
 i BeginDateTime="" {
 	s Node=$q(^$$$AuditDataName(""))
 	i Node="" {
		s BDateTime=$zdatetime($h,3)
	} else {
 		s BDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Beginning",BDateTime)
 } else {
	s String=String_BeginDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EndDateC")_Pad,1,$l(Pad))
 i EndDateTime="" {
	s Node=$q(^$$$AuditDataName(""),-1)
	i Node="" {
		s EDateTime=$h
	} else {
		s EDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Ending",EDateTime)
 } else {
	s String=String_EndDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventSourcesC")_Pad,1,$l(Pad))_EventSources_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventTypesC")_Pad,1,$l(Pad))_EventTypes_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventsC")_Pad,1,$l(Pad))_Events_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"UsernamesC")_Pad,1,$l(Pad))_Usernames_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"SystemIDsC")_Pad,1,$l(Pad))_SystemIDs_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"NamespaceC")_Pad,1,$l(Pad))_Namespace_CRLF
 Do ..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,String,$Case(Flags,0:$$$GetMsg($$$AuditMsg,"CopyAuditData"),1:$$$GetMsg($$$AuditMsg,"CopyAndDeleteAuditData")))
 $$$AddAllRoleTemporary ;[Verified STC 10/07/04]
 l +$$$CacheAuditGbl
 i ..CheckHeader(EndDateTime) s sc=$$$ERROR($$$AuditHeaderUnwritten) g Cleanup
 Set Rset = ##class(%ResultSet).%New("%SYS.Audit:List")
 i '$IsObject(Rset) q %objlasterror
 n %NoAuditList s %NoAuditList=1
 d Rset.Execute(BeginDateTime,EndDateTime,EventSources,EventTypes,Events,Usernames,SystemIDs)
 While Rset.Next() {
	s UTCTimeStamp=Rset.Data("UTCTimeStamp"),SystemID=Rset.Data("SystemID"),AuditIndex=Rset.Data("AuditIndex")
	s ^|Namespace|$$$AuditDataName(UTCTimeStamp,SystemID,AuditIndex)=^$$$AuditDataName(UTCTimeStamp,SystemID,AuditIndex)
 	i Flags=1 k ^$$$AuditDataName(UTCTimeStamp,SystemID,AuditIndex)
	s NumCopied=NumCopied+1
 }
 s ^|Namespace|CacheAuditV=2009.1
 s String=""
 i Flags=0 {
 	s String=String_$$$FormatMsg($$$AuditMsg,"CopyNumAuditRecordsC",NumCopied)_CRLF
 } else {
 	s String=String_$$$FormatMsg($$$AuditMsg,"CopyAndDeleteNumAuditRecordsC",NumCopied)_CRLF
 }
 s String=String_$e($$$GetMsg($$$AuditMsg,"BeginDateC")_Pad,1,$l(Pad))
 i BeginDateTime="" {
	s String=String_$$$FormatMsg($$$AuditMsg,"Beginning",BDateTime)
 } else {
	s String=String_BeginDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EndDateC")_Pad,1,$l(Pad))
 i EndDateTime="" {
	s String=String_$$$FormatMsg($$$AuditMsg,"Ending",EDateTime)
 } else {
	s String=String_EndDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventSourcesC")_Pad,1,$l(Pad))_EventSources_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventTypesC")_Pad,1,$l(Pad))_EventTypes_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventsC")_Pad,1,$l(Pad))_Events_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"UsernamesC")_Pad,1,$l(Pad))_Usernames_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"SystemIDsC")_Pad,1,$l(Pad))_SystemIDs_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"NamespaceC")_Pad,1,$l(Pad))_Namespace_CRLF
 Do ..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,String,$Case(Flags,0:$$$GetMsg($$$AuditMsg,"CopyAuditData"),1:$$$GetMsg($$$AuditMsg,"CopyAndDeleteAuditData")))
Cleanup
 l -$$$CacheAuditGbl
 q $$$OK
Error s $zt=""
 l -$$$CacheAuditGbl
 Quit $$$ERROR($$$CacheError,$ze)
 
ConvertDestination(Namespace)
 s $zt="Error1"
 n $namespace
 d $zu(5,Namespace)
 s Status=..Convert(,0)
 q Status
Error1 s $zt=""
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Creates the audit globals with the correct collation.
ClassMethod CreateGlobals(Directory As %String) As %Status [ Internal ]
{
 s $zt="Error"
#;First set the resource of the audit database
 $$$AddAllRoleTemporary ;[Verified STC 10/07/04]
#;And set the global attributes for each of the audit globals
 f i=$$$AuditDataNameStr,$$$AuditHeaderNameStr {
 	s Global=##Class(%GlobalEdit).Open(i,Directory,,,.Status)
 	i '$$$ISOK(Status) {
 		s Global=##Class(%GlobalEdit).%New(Directory)
 		s Global.Name=i
 	}
 	s Global.Collation=5
 	s Global.IsKeep=1
 	s Status=Global.%Save()
 	i '$$$ISOK(Status) q
 }
 q Status
Error s $zt=""
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Delete matching audit records.<br>
/// Parameters:<br>
/// BeginDateTime - $zdatetime($H,3) value of the first audit record to delete, 
/// use "" to begin with the first record<br>
/// EndDateTime - $zdatetime($H,3) value of the Last audit record to delete. 
/// Audit records will be deleted up through, but not including, this value. Use "" to delete through last record<br>
/// The following parameters may be specified as a comma separated list as follows:<br>
/// "*" - All records match<br>
/// "String,String1" - Any records matching one of these elements<br>
/// "String*" - Any record starting with "String"<br>
/// "String,String1*,String2" - Any record mathing one of these elements, or starting with "String1"<br>
/// Note that these are all case insensitive matches<br>
/// EventSources - Comma separated list of valid event sources<br>
/// EventTypes - Comma separated list of valid event types<br>
/// Events - Comma separated list of event names<br>
/// Usernames - Comma separated list of user names<br>
/// SystemIDs - Comma separated list of System:Config names<br> 
/// Return values:<br>
/// NumDeleted (byref) - Number of audit records deleted<br>
ClassMethod Delete(ByRef NumDeleted As %Integer, BeginDateTime As %String = "", EndDateTime As %String = "", EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*", Usernames As %String = "*", SystemIDs As %String = "*") As %Status
{
 s $zt="Error"
 s NumDeleted=0
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
#;Make sure the audit database is in the right format
 s Status=..Convert(,0)
 i '$$$ISOK(Status) q Status
#;Write 2 audit records in case the first one is deleted in the copy
 s CRLF=$c(13)_$c(10),String="",Pad=$j("",20)
 s String=String_$$$GetMsg($$$AuditMsg,"DeleteAuditRecordsC")_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"BeginDateC")_Pad,1,$l(Pad))
 i BeginDateTime="" {
 	s Node=$q(^$$$AuditDataName(""))
 	i Node="" {
		s BDateTime=$zdatetime($h,3)
	} else {
 		s BDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Beginning",BDateTime)
 } else {
	s String=String_BeginDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EndDateC")_Pad,1,$l(Pad))
 i EndDateTime="" {
	s Node=$q(^$$$AuditDataName(""),-1)
	i Node="" {
		s EDateTime=$h
	} else {
		s EDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Ending",EDateTime)
 } else {
	s String=String_EndDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventSourcesC")_Pad,1,$l(Pad))_EventSources_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventTypesC")_Pad,1,$l(Pad))_EventTypes_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventsC")_Pad,1,$l(Pad))_Events_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"UsernamesC")_Pad,1,$l(Pad))_Usernames_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"SystemIDsC")_Pad,1,$l(Pad))_SystemIDs_CRLF
 Do ..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,String,$$$GetMsg($$$AuditMsg,"DeleteAuditData"))
 $$$AddAllRoleTemporary ;[Verified STC 10/07/04]
 l +$$$CacheAuditGbl
 Set Rset = ##class(%ResultSet).%New("%SYS.Audit:List")
 i '$IsObject(Rset) q %objlasterror
 n %NoAuditList s %NoAuditList=1
 d Rset.Execute(BeginDateTime,EndDateTime,EventSources,EventTypes,Events,Usernames,SystemIDs)
 While Rset.Next() {
	s UTCTimeStamp=Rset.Data("UTCTimeStamp"),SystemID=Rset.Data("SystemID"),AuditIndex=Rset.Data("AuditIndex")
 	k ^$$$AuditDataName(UTCTimeStamp,SystemID,AuditIndex)
	s NumDeleted=NumDeleted+1
 }
 s String=""
 s String=String_$$$FormatMsg($$$AuditMsg,"DeleteNumAuditRecordsC",NumDeleted)_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"BeginDateC")_Pad,1,$l(Pad))
 i BeginDateTime="" {
	s String=String_$$$FormatMsg($$$AuditMsg,"Beginning",BDateTime)
 } else {
	s String=String_BeginDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EndDateC")_Pad,1,$l(Pad))
 i EndDateTime="" {
	s String=String_$$$FormatMsg($$$AuditMsg,"Ending",EDateTime)
 } else {
	s String=String_EndDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventSourcesC")_Pad,1,$l(Pad))_EventSources_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventTypesC")_Pad,1,$l(Pad))_EventTypes_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventsC")_Pad,1,$l(Pad))_Events_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"UsernamesC")_Pad,1,$l(Pad))_Usernames_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"SystemIDsC")_Pad,1,$l(Pad))_SystemIDs_CRLF
 Do ..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,String,$$$GetMsg($$$AuditMsg,"DeleteAuditData"))
Cleanup
 l -$$$CacheAuditGbl
 q $$$OK
Error s $zt=""
 l -$$$CacheAuditGbl
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Create an EMS record.<br>
ClassMethod EMSCreateRecord(Source As %String, Type As %String, Name As %String, EventData As %String, Description As %String, instanceName As %String = "", groupName As %String = "", Status As %Status = 1) As %String [ Internal ]
{
	Set $zt="Error"
	
	#;If you add or delete a field here, make sure the Write() method is updated with the new offsets
	Quit $lb(
		0,				;AuditIndex, gets filled in later
		$zu(67,13,$j),	;ClientExecutableName
		$zu(67,15,$j),	;Client IP Address
		Description,	;Description
		Name,			;Event
		EventData,		;EventData
		Source,			;EventSource
		Type,			;EventType
		$znspace,		;Namespace
		+$j,			;Pid (make sure we take off the nodename if 3652:NODE)
		$roles,			;Roles
		"",				;RoutineSpec
		instanceName,	;SystemID
		$username,		;Username
		$zdatetime($ztimestamp,3,,3),		;UTCTimeStamp
		$zu(67,14,$j),	;CSP Session ID
		$zu(67,20,$j),	;User Info
		+$zu(61,30,$zu(61)), ;JobId
		groupName,		;Group
		Status,
		$zu(67,11,$j),	;O/S Username
		$System.Security.Users.GetSecurityLevel()  ; Authentication level
		) 
		
Error s $zt=""
	$$$BACKETN
	Quit ""  ; Note that $ZE will be set with the error which the Write() method can use.
}

/// Write an EMS record to the Audit file.<br>
ClassMethod EMSWrite(EventSource As %String, EventType As %String, Event As %String, EventData As %String, Description As %String, instanceName As %String = "", groupName As %String = "", Status As %Status = 1) As %Status [ Internal ]
{
	Set $zt="Error"
	Set AuditRecord=..EMSCreateRecord(EventSource, EventType, Event, EventData, Description, instanceName, groupName, Status)
	If AuditRecord="" Quit $$$ERROR($$$CacheError,$ze) ;Error is stashed in $ze
	Quit ..EMSWriteRecord(AuditRecord,0)
Error Set $zt=""
	$$$BACKETN
	Quit $$$ERROR($$$CacheError,$ze)
}

/// Write an EMS record to the Audit file.<br>
/// Flags<br>
/// Bit 0 - Use timestamp from audit record<br>
/// Bit 1 - Write Cache audit record in both ^CacheAuditD and ^EMSAuditD global. ^EMSAuditD
/// eventually will get poted to the EMS server audit file.<br>
ClassMethod EMSWriteRecord(AuditRecord As %List, Flags As %Integer = 0) As %Status [ Internal ]
{
 s $zt="Error"
#;We need %All to continue since the audit file is protected
 q:'$$$AuditingIsOn $$$OK
 $$$AddAllRoleTemporary ;[Verified STC 10/13/2010]
#;If bit 0 is set, use the timestamp from the audit record. This is an audit record which
#;was previously cached on the client, and is now being written to the EMS server. Note 
#;that the client time may not be in sync with the server time.
#;If bit 0 is not set, the record has successfully come over from the client, and the timestamp
#;used should be the the one from the server.
 i $zb(Flags,1,1) {
	s TimeStamp=$li(AuditRecord,15)
 } else {
	s TimeStamp=$zdatetime($ztimestamp,3,,3)
 	s $li(AuditRecord,15)=TimeStamp
 }
 s AuditIndex=$increment($$$CacheAuditGbl)
 s $li(AuditRecord,1)=AuditIndex
#;Turn off transactions for this Audit record
 s InTransaction=$zu(139,1)
 s $$$CacheAuditGbl(TimeStamp,$li(AuditRecord,13),AuditIndex)=AuditRecord
#;Now if Bit 1 is set, this means we could not post the record to the EMS server.
#;We have just written it to the local audit file. We do this so that if there is something
#;wrong here, we can get a report of it through the audit utilities on the client. 
#;Now we are now going to write it to a temporary global for later posting to the EMS server.
#;Lock the global here so it doesn't get deleted out from under us in the PostAudit method.
 i $zb(Flags,2,1) {
 	l +$$$EMSAuditGbl#"S"
 	s Locked=1
	s AuditIndex=$increment($$$EMSAuditGbl)
 	s $li(AuditRecord,1)=AuditIndex
	s $$$EMSAuditGbl(TimeStamp,$li(AuditRecord,13),AuditIndex)=AuditRecord
 	l -$$$EMSAuditGbl#"S"
 	k Locked
 }
 d $zu(139,InTransaction)
#;Flush the journal buffer ^^^Not sure if I need this, it may slow things down.
 ;i $$$JRNSTATUS f i=1:1:5 q:$$$JRNFLUSHBUF  H 1
 q $$$OK
Error s $zt=""
 i $d(Locked) l -$$$EMSAuditGbl#"S"
 i $d(InTransaction) d $zu(139,InTransaction)
 $$$BACKETN
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Erase the audit file.<br>
/// Flags:
///  0 - Erase all contents<br>
///  1 - Erase and create new audit file<br>
///  2 - Erase and create new audit file, treat as encryption state changed<br>
/// Note that bit 1 infers that ALL data in the audit database will be deleted, not just Audit data<br>
ClassMethod Erase(Flags As %Integer = 0) As %Status
{
 s $zt="Error"
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
 $$$AddAllRoleTemporary ;[Verified STC 10/07/04]
 i '##Class(Security.System).Exists($$$SystemSecurityName,.System,.Status) q Status
 l +$$$CacheAuditGbl
 s Node=$q(^$$$AuditDataName(""))
 i Node="" {
	 s BeginTime=$zdatetime($h,3)
	 s EndTime=BeginTime
 } else {
 	s BeginTime=..ConvertUTCToLocal($li(@Node,15))
 	s EndTime=..ConvertUTCToLocal($li(@$q(^$$$AuditDataName(""),-1),15))
 }
 i Flags = 0 {
	k ^$$$AuditDataName
	k ^$$$AuditHeaderName
	s Status=..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,$$$FormatMsg($$$AuditMsg,"ErasedAuditFromTo",BeginTime,EndTime),$$$GetMsg($$$AuditMsg,"EraseAuditData"))
 	s Status=$$$OK
 } else {
 	s AuditDatabase=$$$GetAuditDatabase
#;If auditing is turned off, get the name of the database where we would audit to if it were on
 	i AuditDatabase="" {
		s AuditDatabase=$p($g(^SYS("GREDIR","DSLOC","master",$p($zu(86),"*",2),"CACHEAUDIT")),$c(1),1)
		i AuditDatabase="" s AuditDatabase=##Class(%File).SubDirectoryName($ZU(12),"cacheaudit")
 	}
#; Set switch 10 to prohibit writes to the audit db, wait 10 seconds for quiesce
 	i $$%swset^SWSET(10,1) s SWSET=1
	s Quiesce=$$TQUIGLO^SWSET(0)
 	i 'Quiesce s Status=$$$ERROR($$$AuditUnableToQuiesce) g Cleanup
#; Now try to dismount it for 20 seconds
 	f i=1:1:20 s Status=$zu(3,AuditDatabase) q:Status>0  h 1
#;Let write daemon close it
 	h 1
	i Status<=0 s Status=$$$ERROR($$$UnexpectedError,Status) g Cleanup
#;Now delete it
	S Status=##Class(%Library.File).Delete(AuditDatabase_"CACHE.DAT")
	i '$$$ISOK(Status) {
#;Remount it on failure
		d $zu(17,AuditDatabase)
		g Cleanup
	}
#;Now create a new database
	s EncKeyID=$System.Security.System.GetDBEncKeyID()
	i (EncKeyID'=""),System.AuditEncrypt {
		s Status=##class(SYS.Database).CreateDatabase(AuditDatabase,,,1,$$$DBCACHEAUDITResourceName)
	} else {
		s Status=##class(SYS.Database).CreateDatabase(AuditDatabase,,,,$$$DBCACHEAUDITResourceName)
	}
	i '$$$ISOK(Status) g Cleanup
#;Set the resource and create the default globals with the correct collation
	s Status=..CreateGlobals(AuditDatabase)
#;And audit the event
	i Flags=1 {
		s Status=..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,$$$FormatMsg($$$AuditMsg,"ErasedAuditFromTo",BeginTime,EndTime),$$$GetMsg($$$AuditMsg,"EraseAuditData"))
	} else {
		s Status=..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,$$$FormatMsg($$$AuditMsg,"ErasedAuditFromToEncrypt",BeginTime,EndTime),$$$GetMsg($$$AuditMsg,"EraseAuditData"))
	}
	s Status=$$$OK
 }
Cleanup
 i $d(SWSET),$$%swset^SWSET(10,0)
 l -$$$CacheAuditGbl
 q Status
Error s $zt=""
 s ze=$ze
 i $d(SWSET),$$%swset^SWSET(10,0)
 l
 Quit $$$ERROR($$$CacheError,ze)
}

/// Audit record exists.<br>
/// This method checks for the existence of an Audit record in the security database.<br>
/// Parameters:<br>
/// UTCTimeStamp - UTC timestamp of the audit record<br>
/// SystemID - System ID of the audit event, usually NODE:CFGNAME<br>
/// AuditIndex - Index number of the audit record<br>
/// Return values:<br>
/// If Value of the method = 0 (Audit record does not exist, or some error occured)<br>
/// Audit = Null<br>
/// Status = Audit "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (Audit record exists)<br>
/// Audit = Object handle to Audit record<br>
ClassMethod Exists(UTCTimeStamp As %String = "", SystemID As %String = "", AuditIndex As %Integer = 0, ByRef Audit As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
 s $zt="Error"
 s Audit=""
 s Audit=..%OpenId(UTCTimeStamp_"||"_SystemID_"||"_AuditIndex,,.Status)
 i $$$ISOK(Status) q 1
 i $p($SYSTEM.Status.GetErrorCodes(Status),",")=$$$ERRORCODE($$$LoadObjectNotFound) s Status=$$$ERROR($$$AuditDoesNotExist,UTCTimeStamp_"||"_SystemID_"||"_AuditIndex)
 q 0
Error s $zt=""
 s Status=$$$ERROR($$$CacheError,$ze)
 q 0
}

/// Export matching records to an xml file.<br>
/// Parameters:<br>
/// FileName - Valid filename to copy audit records to<br>
/// Flags - Bit 0 - Delete audit record after export<br>
/// BeginDateTime - $zdatetime($H,3) value of the first audit record to copy, "" = first record<br>
/// EndDateTime - $zdatetime($H,3) value of the Last audit record to copy, "" = Last record<br>
/// The following parameters may be specified as a comma separated list as follows:<br>
/// "*" - All records match<br>
/// "String,String1" - Any records matching one of these elements<br>
/// "String*" - Any record starting with "String"<br>
/// "String,String1*,String2" - Any record mathing one of these elements, or starting with "String1"<br>
/// Note that these are all case insensitive matches<br>
/// EventSources - Comma separated list of valid event sources<br>
/// EventTypes - Comma separated list of valid event types<br>
/// Events - Comma separated list of event names<br>
/// Usernames - Comma separated list of user names<br>
/// SystemIDs - Comma separated list of System:Config names<br> 
/// Username - Comma separated list of user names to copy, "*" = All<br>
/// Return values:<br>
/// NumCopied (byref) - Number of audit records exported.<br>
/// Note: Two audit record will get written out when this is called in case the first one
/// is deleted as part of the export operation.<br>
ClassMethod Export(FileName As %String, ByRef NumExported As %Integer, Flags As %Integer = 0, BeginDateTime As %String = "", EndDateTime As %String = "", EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*", Usernames As %String = "*", SystemIDs As %String = "*") As %Status
{
 s $zt="Error"
 s NumExported=0
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
#;Make sure the audit database is in the right format
 s Status=..Convert(,0)
 i '$$$ISOK(Status) q Status
#;Write 2 audit records in case the first one is deleted in the copy
 s CRLF=$c(13,10),String="",Pad=$j("",20)
 i Flags=0 {
 	s String=String_$$$GetMsg($$$AuditMsg,"ExportAuditRecordsC")_CRLF
 } else {
 	s String=String_$$$GetMsg($$$AuditMsg,"ExportAndDeleteAuditRecordsC")_CRLF
 }
 s String=String_$e($$$GetMsg($$$AuditMsg,"BeginDateC")_Pad,1,$l(Pad))
 i BeginDateTime="" {
 	s Node=$q(^$$$AuditDataName(""))
 	i Node="" {
		s BDateTime=$zdatetime($h,3)
	} else {
 		s BDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Beginning",BDateTime)
 } else {
	s String=String_BeginDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EndDateC")_Pad,1,$l(Pad))
 i EndDateTime="" {
	s Node=$q(^$$$AuditDataName(""),-1)
	i Node="" {
		s EDateTime=$h
	} else {
		s EDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Ending",EDateTime)
 } else {
	s String=String_EndDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventSourcesC")_Pad,1,$l(Pad))_EventSources_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventTypesC")_Pad,1,$l(Pad))_EventTypes_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventsC")_Pad,1,$l(Pad))_Events_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"UsernamesC")_Pad,1,$l(Pad))_Usernames_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"SystemIDsC")_Pad,1,$l(Pad))_SystemIDs_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"FileNameC")_Pad,1,$l(Pad))_FileName_CRLF
 Do ..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,String,$Case(Flags,0:$$$GetMsg($$$AuditMsg,"ExportAuditData"),1:$$$GetMsg($$$AuditMsg,"ExportAndDeleteAuditData")))
 $$$AddAllRoleTemporary ;[Verified STC 10/07/04]
 l +$$$CacheAuditGbl
 i ..CheckHeader(EndDateTime) s sc=$$$ERROR($$$AuditHeaderUnwritten) g Cleanup
 #; From now on must exit through Cleanup
 s Rset=##class(%ResultSet).%New("%SYS.Audit:List")
 #; Create and initialize an %XML.Writer object
 Set writer=##class(%XML.Writer).%New()
 s sc=writer.OutputToFile(FileName)
     If $$$ISERR(sc) goto Cleanup
 s writer.Charset="UTF-8"
 s writer.Indent=1
 s sc=writer.RootElement("AuditExport") ;won't work without this
 i $$$ISERR(sc) goto Cleanup
 n %NoAuditList s %NoAuditList=1
 d Rset.Execute(BeginDateTime,EndDateTime,EventSources,EventTypes,Events,Usernames,SystemIDs)
 While Rset.Next() {
	s UTCTimeStamp=Rset.Data("UTCTimeStamp"),SystemID=Rset.Data("SystemID"),AuditIndex=Rset.Data("AuditIndex")
	s oref=..%OpenId(UTCTimeStamp_"||"_SystemID_"||"_AuditIndex)
	#;Perform the export using the object Id.
    set sc=writer.Object(oref)
    If $$$ISERR(sc) goto Cleanup 
    i Flags=1 k ^$$$AuditDataName(UTCTimeStamp,SystemID,AuditIndex)
	s NumExported=NumExported+1
 }
 s sc=writer.EndRootElement()
 i $$$ISERR(sc) goto Cleanup
 s sc=writer.EndDocument()
 i Flags=0 {
 	s String=String_$$$FormatMsg($$$AuditMsg,"ExportNumAuditRecordsC",NumExported)_CRLF
 } else {
 	s String=String_$$$FormatMsg($$$AuditMsg,"ExportAndDeleteNumAuditRecordsC",NumExported)_CRLF
 }
 s String=String_$e($$$GetMsg($$$AuditMsg,"BeginDateC")_Pad,1,$l(Pad))
 i BeginDateTime="" {
	s String=String_$$$FormatMsg($$$AuditMsg,"Beginning",BDateTime)
 } else {
	s String=String_BeginDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EndDateC")_Pad,1,$l(Pad))
 i EndDateTime="" {
	s String=String_$$$FormatMsg($$$AuditMsg,"Ending",EDateTime)
 } else {
	s String=String_EndDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventSourcesC")_Pad,1,$l(Pad))_EventSources_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventTypesC")_Pad,1,$l(Pad))_EventTypes_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventsC")_Pad,1,$l(Pad))_Events_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"UsernamesC")_Pad,1,$l(Pad))_Usernames_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"SystemIDsC")_Pad,1,$l(Pad))_SystemIDs_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"FileNameC")_Pad,1,$l(Pad))_FileName_CRLF
 Do ..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,String,$Case(Flags,0:$$$GetMsg($$$AuditMsg,"ExportAuditData"),1:$$$GetMsg($$$AuditMsg,"ExportAndDeleteAuditData")))
Cleanup
 l -$$$CacheAuditGbl
 i $d(sc),'$$$ISOK(sc) q sc
 q $$$OK
Error s $zt=""
 l -$$$CacheAuditGbl
 i $d(writer) d writer.EndDocument()
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Get the Audit properties.<br>
/// Parameters:<br>
/// SystemID - System ID of the audit event, usually NODE:CFGNAME<br>
/// AuditIndex - Index number of the audit record<br>
/// Return values:<br>
/// Properties - Array of properties<br>
/// s Properties("AuditIndex")<br>
/// s Properties("ClientExecutableName")<br>
/// s Properties("ClientIPAddress")<br>
/// s Properties("CSPSessionID")<br>
/// s Properties("Description")<br>
/// Properties("Event")<br>
/// Properties("EventData")<br>
/// Properties("EventSource")<br>
/// Properties("EventType")<br>
/// Properties("JobId")<br>
/// Properties("Namespace")<br>
/// Properties("Pid")<br>
/// Properties("Roles")<br>
/// Properties("RoutineSpec")<br>
/// Properties("SystemID")<br>
/// Properties("Username")<br>
/// Properties("UTCTimeStamp")<br>
ClassMethod Get(UTCTimeStamp As %String, SystemID As %String, AuditIndex As %Integer, ByRef Properties As %String) As %Status
{
 s $zt="Error"
 k Properties
 i '..Exists(UTCTimeStamp,SystemID,AuditIndex,.Audit,.Status) q Status
 s Status=..GetProperties(Audit,.Properties)
 q Status
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

/// Get audit database (directory) using $$$GetAuditDatabase or the name of the database
/// where we would audit to if it were turned on.  Code copied from ..Erase() for use by
/// shadowing.
ClassMethod GetAuditDatabase() As %String [ Internal ]
{
 s AuditDatabase=$$$GetAuditDatabase
 #;If auditing is turned off, get the name of the database where we would audit to if it were on
 i AuditDatabase="" {
	s AuditDatabase=$p($g(^SYS("GREDIR","DSLOC","master",$p($zu(86),"*",2),"CACHEAUDIT")),$c(1),1)
	i AuditDatabase="" s AuditDatabase=##Class(%File).SubDirectoryName($ZU(12),"cacheaudit")
 }
 Quit AuditDatabase
}

/// Get the Audit properties.<br>
/// Parameters:<br>
/// Audit - Object handle to an audit record
/// Properties
/// Get the Audit properties.<br>
ClassMethod GetProperties(Audit As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
 s $zt="Error"
 k Properties
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
 s Properties("AuditIndex")=Audit.AuditIndex
 s Properties("Authentication")=Audit.Authentication
 s Properties("ClientExecutableName")=Audit.ClientExecutableName
 s Properties("ClientIPAddress")=Audit.ClientIPAddress
 s Properties("CSPSessionID")=Audit.CSPSessionID
 s Properties("Description")=Audit.Description
 s Properties("Event")=Audit.Event
 s Properties("EventData")=Audit.EventData
 s Properties("EventSource")=Audit.EventSource
 s Properties("EventType")=Audit.EventType
 s Properties("JobId")=Audit.JobId
 s Properties("Namespace")=Audit.Namespace
 s Properties("Pid")=Audit.Pid
 s Properties("Roles")=Audit.Roles
 s Properties("RoutineSpec")=Audit.RoutineSpec
 s Properties("SystemID")=Audit.SystemID
 s Properties("Username")=Audit.Username
 s Properties("UTCTimeStamp")=Audit.UTCTimeStamp
 q $$$OK
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

/// Import audit records from an xml file.<br>
/// Parameters:<br>
/// FileName - Valid filename to import audit records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String, ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
 s $zt="Error"
 s NumImported=0
 s NumSkipped=0
 i $zu(5)="%SYS" q $$$ERROR($$$NoPctSysAuditImport,$zu(5))
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
 $$$AddAllRoleTemporary ;[Verified STC 10/07/04]
 TSTART
 #; Create and initialize an %XML.Reader object
 s reader=##class(%XML.Reader).%New()
 s sc=reader.OpenFile(FileName)
 i $$$ISERR(sc) goto Cleanup
 Do reader.Correlate("Audit","%SYS.Audit")
 While reader.Next(.audit,,.sc) {
	i $$$ISERR(sc) goto Cleanup 
	i $zb(Flags,1,1) {
		s NumImported=NumImported+1
		Continue
	}
	#;The reader.Next() performed the import, obtaining the object Id into "audit".
    s tf=..Exists(audit.UTCTimeStamp,audit.SystemID,audit.AuditIndex,,.sc)
    i 'tf s sc=audit.%Save() i $$$ISERR(sc) goto Cleanup
    i tf {
	   #; set up properties and call Modify to update existing resource
	   s sc=..GetProperties(audit,.p)
	   i $$$ISERR(sc) goto Cleanup
	   s sc=..Modify(audit.UTCTimeStamp,audit.SystemID,audit.AuditIndex,.p)
	   k audit
       i $$$ISERR(sc) goto Cleanup
    }
    i '$$$ISERR(sc) s NumImported=NumImported+1
 }
 i $$$ISERR(sc) goto Cleanup 
 TCOMMIT
 s CRLF=$c(13)_$c(10),String="",Pad=$j("",20)
 s String=String_$$$GetMsg($$$AuditMsg,"ImportAuditRecordsC")_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"ImportFileC")_Pad,1,$l(Pad))_FileName_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"TargetNamespaceC")_Pad,1,$l(Pad))_$zu(5)_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"RecordsImportedC")_Pad,1,$l(Pad))_NumImported_CRLF
 Do ..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,String,$$$GetMsg($$$AuditMsg,"ImportAuditData"))
 q $$$OK
Cleanup
 i $d(sc),'$$$ISOK(sc) TROLLBACK  s NumImported=0 q sc
 q $$$OK
Error s $zt="Error1"
 s ze=$ze
 TROLLBACK
 s NumImported=0
 Quit $$$ERROR($$$CacheError,ze)
Error1 s $zt=""
 Quit $SYSTEM.Status.AppendStatus($$$ERROR($$$CacheError,ze),$$$ERROR($$$CacheError,$ze))
}

/// Modify an Audit record's properties.<br>
/// Modifies an Audit records properties from the security database.<br>
/// Parameters:<br>
/// UTCTimeStamp - UTC timestamp of the audit record<br>
/// SystemID - System ID of the audit event, usually NODE:CFGNAME<br>
/// AuditIndex - Index number of the audit record<br>
/// See the Get() method for a description of the Properties parameter.<br>
/// If a specific property is not passed in the properties array, 
/// the value is not modified.<br>
ClassMethod Modify(UTCTimeStamp As %String, SystemID As %String, AuditIndex As %Integer, ByRef Properties As %String) As %Status
{
 s $zt="Error"
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
 i '..Exists(UTCTimeStamp,SystemID,AuditIndex,.Audit,.Status) q Status
 i $d(Properties("AuditIndex")),(Properties("AuditIndex")'=Audit.AuditIndex) s Audit.AuditIndex=Properties("AuditIndex")
 i $d(Properties("Authentication")),(Properties("Authentication")'=Audit.Authentication) s Audit.Authentication=Properties("Authentication")
 i $d(Properties("ClientExecutableName")),(Properties("ClientExecutableName")'=Audit.ClientExecutableName) s Audit.ClientExecutableName=Properties("ClientExecutableName")
 i $d(Properties("ClientIPAddress")),(Properties("ClientIPAddress")'=Audit.ClientIPAddress) s Audit.ClientIPAddress=Properties("ClientIPAddress")
 i $d(Properties("CSPSessionID")),(Properties("CSPSessionID")'=Audit.CSPSessionID) s Audit.CSPSessionID=Properties("CSPSessionID")
 i $d(Properties("Description")),(Properties("Description")'=Audit.Description) s Audit.Description=Properties("Description")
 i $d(Properties("Event")),(Properties("Event")'=Audit.Event) s Audit.Event=Properties("Event")
 i $d(Properties("EventData")),(Properties("EventData")'=Audit.EventData) s Audit.EventData=Properties("EventData")
 i $d(Properties("EventSource")),(Properties("EventSource")'=Audit.EventSource) s Audit.EventSource=Properties("EventSource")
 i $d(Properties("EventType")),(Properties("EventType")'=Audit.EventType) s Audit.EventType=Properties("EventType")
 i $d(Properties("JobId")),(Properties("JobId")'=Audit.JobId) s Audit.JobId=Properties("JobId")
 i $d(Properties("Namespace")),(Properties("Namespace")'=Audit.Namespace) s Audit.Namespace=Properties("Namespace")
 i $d(Properties("Pid")),(Properties("Pid")'=Audit.Pid) s Audit.Pid=Properties("Pid")
 i $d(Properties("Roles")),(Properties("Roles")'=Audit.Roles) s Audit.Roles=Properties("Roles")
 i $d(Properties("RoutineSpec")),(Properties("RoutineSpec")'=Audit.RoutineSpec) s Audit.RoutineSpec=Properties("RoutineSpec")
 i $d(Properties("SystemID")),(Properties("SystemID")'=Audit.SystemID) s Audit.SystemID=Properties("SystemID")
 i $d(Properties("Username")),(Properties("Username")'=Audit.Username) s Audit.Username=Properties("Username")
 i $d(Properties("UTCTimeStamp")),(Properties("UTCTimeStamp")'=Audit.UTCTimeStamp) s Audit.UTCTimeStamp=Properties("UTCTimeStamp")
 s Status=Audit.%Save()
 q Status
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

/// Stops auditing.<br>
/// Called when the system audit parameters change, and at shutdown.
/// Do not call directly to stop auditing.
ClassMethod Stop() As %Status [ Internal ]
{
 s $zt="Error"
#;When $SYSTEM.Security.Audit gets called to write an audit record, the first thing the method
#;does is check to see if auditing is enabled. If not, the method exits with a status 
#;of 0 (event not audited.)
#;
#;The method then checks if the audit write error count is 0. If it is 0, then it tries to
#;write the audit record to the audit database. If the write fails (e.g. FILEFULL), the
#;audit write error count is incremented by one, and the FILEFULL error is generated.
#;
#;If the audit write error count is not 0 (there were previous FILEFULL errors by other
#;processes) the process will first try to write an audit record with the following information
#;  $SYSTEM.Security.Audit($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,"","Audit error: 35 events not logged")
#;If the write is not successfull, the error count is incremented by one, and the FILEFULL
#;error is generated.
#;If the write is successfull (i.e. some action was taken to increase the size of the audit file),
#;the audit write error count is zeroed, and the real audit record is written out.
#;
#;In the case here, where auditing is being stopped, if we get a filefull, we write this
#;info into the audit header. When auditing is started back up again, the audit header is read,
#;the audit record is regenerated, then the audit header is cleared.
#;
#;#;We need %Admin Secure:U privilege to do anything with auditing
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
 s Status=..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,$$$FormatMsg($$$AuditMsg,"AuditingStoppedTo",$$$GetAuditDatabase),$$$GetMsg($$$AuditMsg,"AuditingStopped"))
 i '$$$ISOK(Status) {
	#; Need function to clear the number of errors^^^
	s Count=$$$GetAuditState
	s Description=$$$FormatMsg($$$AuditMsg,"AuditingStoppedError",$p(Count,",",1),$zdatetime($h,3))
	s String=Description_$c(13,10)_$$$FormatMsg($$$AuditMsg,"AuditError",$SYSTEM.Status.GetErrorText(Status))
	s Status=..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,String,Description)
 }
 s Status=$$$StopAuditing
 i 'Status q $$$ERROR($$$AuditNotStopped,$$$GetAuditDatabase)
 q $$$OK
Error s $zt=""
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Start/Stop/Switch the Audit file based on the contents of the audit configuration.<br>
/// Called only when the audit parameters are changed in the
/// Security.System class.
ClassMethod UpdateAuditFile() As %Status [ Internal ]
{
 s $zt="Error"
#;We need %Admin Secure:U privilege to do anything with auditing
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
 s System=##Class(Security.System).%OpenId($$$SystemSecurityName,,.Status)
 i '$$$ISOK(Status) q Status
#;See if we are currently auditing. If the Audit database is "" we are not.
 s OldAuditDatabase=$$$GetAuditDatabase
 i 'System.AuditEnabled {
#;If we were auditing, the system flag turning off auditing got set. So stop it.
	i OldAuditDatabase'="" {
		s Status=..Stop()
		i '$$$ISOK(Status) q Status
 	} else {
		d ##Class(%SYS.System).WriteToConsoleLog("Auditing is disabled")
#;auditing may be off, but we are still tracking the events in memory
		s Status=##Class(Security.Events).Start()
 		i '$$$ISOK(Status) q Status
	}
	q $$$OK
 }
#;If here we are either starting auditing, or switching the audit database.
#;Get the system defined audit database. If for some reason it is "",
#;then put it in the mgr\cacheaudit directory
 s AuditDatabase=$p($g(^SYS("GREDIR","DSLOC","master",$p($zu(86),"*",2),"CACHEAUDIT")),$c(1),1)
 i AuditDatabase="" s AuditDatabase=##Class(%File).SubDirectoryName($ZU(12),"cacheaudit")
#;We shouldn't be called if what we switch to is the same as what currently is
 i AuditDatabase=OldAuditDatabase q $$$OK
#;Make sure we set the max size of the audit database to 0. The only way to recover
#;from a cache audit db getting a filefull error is to delete it.
 s AuditDB=##Class(SYS.Database).%OpenId(AuditDatabase)
 i $isobject(AuditDB) {
	 if AuditDB.MaxSize'=0 {
	 	 s AuditDB.MaxSize=0
		 s Status=AuditDB.%Save()
	 }
	 k AuditDB
 }
 i OldAuditDatabase'="" {
#;If here, we are going to switch to a new audit database. Apply any
#;audit header, then audit the switch in the old database
	s String=$$$FormatMsg($$$AuditMsg,"AuditDatabaseSwitchedTo",AuditDatabase)
	s String=String_$c(13,10)_$$$FormatMsg($$$AuditMsg,"AuditDatabaseSwitchedFrom",OldAuditDatabase)
	s Status=..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,String,$$$GetMsg($$$AuditMsg,"AuditDatabaseSwitched"))
#;Switch it
 	s Status=$$$SwitchAuditDatabase(AuditDatabase)
	i 'Status {
 		s Status=..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,"",$$$FormatMsg($$$AuditMsg,"AuditDatabaseNotSwitched"))
		q $$$ERROR($$$AuditDatabaseNotAvailable,AuditDatabase)
 	}
 } else {
#;If here we are going to start auditing
 	s Status=$$$StartAuditing(AuditDatabase)
 	i 'Status {
	 	d ##Class(%SYS.System).WriteToConsoleLog("Unable to start auditing to "_AuditDatabase)
 		q $$$ERROR($$$AuditUnableToStart,AuditDatabase)
 	}
	d $$$SetAuditFlags(System.AuditFlags)
 }
 s Status=..CreateGlobals(AuditDatabase)
#;Now that we switched or started, we need to see if there was a leftover 
#;header to write in the new audit database (which could have been previously used.) 
#;This will also create the header if one doesn't exist
 i OldAuditDatabase'="" {
	s String=$$$FormatMsg($$$AuditMsg,"AuditDatabaseSwitchedFrom",OldAuditDatabase)
	s String=String_$c(13,10)_$$$FormatMsg($$$AuditMsg,"AuditDatabaseSwitchedTo",AuditDatabase)
 	s Status=..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,String,$$$GetMsg($$$AuditMsg,"AuditDatabaseSwitched"))
 } else {
	d $$$Initialize
	s Status=..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditChange,$$$FormatMsg($$$AuditMsg,"AuditingStartedTo",AuditDatabase),$$$GetMsg($$$AuditMsg,"AuditingStarted"))
 }
#;Now make sure all the events are set correctly, this gets them into the audit log.
 s Status=##Class(Security.Events).Start()
 i '$$$ISOK(Status) q Status
 d $$$Initialize
 q $$$OK
Error s $zt=""
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Write a record to the audit file.<br>
ClassMethod WriteToAuditFile(Source As %String, Type As %String, Name As %String, EventData As %String, Description As %String) As %Status [ Internal ]
{
#;This function is only used internally by the audit and security system.
#;This function will write an event to the audit file. It uses the system method
#;$SYSTEM.Security.Audit to perform the write. If an error is returned (e.g. FILEFULL),
#;then the event is written to the Audit header so it can be updated into the 
#;audit file at a later point in time. To write directly to the header, the %All role is granted.
#;The audit header is a fixed size of 32500 bytes. It is created when the audit file
#;is initialized for the first time. It is primarily used to hold audit records which could
#;not be written to the file (e.g. filefull) while auditing was being stopped, 
#;started, or switched, or other security information was being changed. 
#;The header is a list of lists, each $list string is an audit record. The internal format is as follows:
#;
#;List 1 - Contents of audit record 1
#;List 2 - Contents of audit record 2
#;...
#;Last element - padding required to pad to 32500
#;
#;Note that we could conceivably fail to write the audit record if the number of audit
#;records in the header grows beyond the capacity of the header (roughly 300 records). We
#;would return an error status to the caller in this case.
#;We need %Admin Secure:U privilege to do anything with auditing since
#;this should only be called from system methods.
 s $zt="Error"
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
 $$$AddAllRoleTemporary ;[Verified STC 10/13/2010]
#;See if auditing is on for the system, and for the event itself. If not, just return success.
#;Increment the total in any case.
 $$$IncAuditTotalCount(Source_"/"_Type_"/"_Name)
 q:'$$$AuditingIsOn $$$OK
 i '$$$EventAuditIsOn(Source,Type,Name) q $$$OK
 s AuditRecord=""
 s TimeStamp=$zdatetime($ztimestamp,3,,3)
 s AuditIndex=$increment($$$CacheAuditGbl)
 s SystemID=$zu(110)_":"_$p($zu(86),"*",2)	;SystemID
#;Stuff which calls this entry point are system routines we provide. We really don't need (or even want)
#;to report the actual location of the audit. If in the future we want to report it, we can undef this.
#if 0
 s CallDB=$zu(96,27)
 s Routine=$p($stack($stack-1,"PLACE")," ")_" |"""_"^"_$li(CallDB,3)_"^"_$li(CallDB,2)_""""_"|"
#else
 s Routine=""
#endif
 s AuditRecord=$lb(
 		AuditIndex,		;AuditIndex
		$zu(67,13,$j),	;ClientExecutableName
		$zu(67,15,$j),	;Client IP Address
		Description,	;Description
		Name,			;Event
		EventData,		;EventData
		Source,			;EventSource
		Type,			;EventType
		$znspace,		;Namespace
		$p($j,":"),		;Pid (make sure we take off the nodename if 3652:NODE)
		$roles,			;Roles
		Routine,		;RoutineSpec
		SystemID,		;SystemID
		$username,		;Username
		TimeStamp,		;UTCTimeStamp
		$zu(67,14,$j), 	;CSP Session ID
		$zu(67,20,$j), 	;User Info
		+$zu(61,30,$zu(61)), ;JobId
		$zu(203,4),		;Group
		1,				;Status
		$zu(67,11,$j),	;O/S username
		$System.Security.Users.GetSecurityLevel()  ; Authentication level
		)
#;Turn off transactions for this Audit record
 s InTransaction=$zu(139,1)
 s $$$CacheAuditGbl(TimeStamp,SystemID,AuditIndex)=AuditRecord
 d $zu(139,InTransaction)
 $$$IncAuditWrittenCount(Source_"/"_Type_"/"_Name)
#;make sure the journal buffer is set to disk.
 i $$$JRNSTATUS f i=1:1:5 q:$$$JRNFLUSHBUF  H 1
#;Since we had a successfull write, see if we need to apply a header
 d ..ApplyAuditHeader()
 q $$$OK
Error s $zt=""
 i $d(InTransaction) d $zu(139,InTransaction)
 q ..WriteToAuditFileGlobal(Source,Type,Name,EventData,Description,$g(AuditRecord))
}

/// Write a record to the audit file global.<br>
ClassMethod WriteToAuditFileGlobal(Source As %String, Type As %String, Name As %String, EventData As %String, Description As %String, AuditRecord As %String = "") As %Status [ Internal ]
{
 s $zt="Error"
#;If here, we got some sort of error writing to the audit file (e.g. FILEFULL)
#;We need %All to continue since the audit file is protected
 $$$AddAllRoleTemporary ;[Verified STC 10/07/04]
#;Turn off transactions for this audit record
 s InTransaction=$zu(139,1)
 l +$$$CacheAuditHeader
#;Get the current header
 s Header=$g($$$CacheAuditHeader,$lb(""))
#;Peel off the padding
 s Header=$li(Header,1,$ll(Header)-1)
#;Now add in the entire audit record. Note that if the format changes, we need to change
#;this also. Audit records are just concatenated with each other, 15 fields to a record
#;SAP240+
 i $g(AuditRecord)="" {
 	s TimeStamp=$zdatetime($ztimestamp,3,,3)
 	s SystemID=$zu(110)_":"_$p($zu(86),"*",2)
 	s AuditIndex=$increment($$$CacheAuditGbl)
 	s AuditRecord = $lb(
 	AuditIndex,		;AuditIndex
 	$zu(67,13,$j),	;ClientExecutableName
 	$zu(67,15,$j),	;Startup IP Address
 	Description,	;Description
 	Name,			;Event
 	EventData,		;EventData
 	Source,			;EventSource
 	Type,			;EventType
 	$znspace,		;Namespace
 	$p($j,":"),		;Pid (make sure we take off the nodename if 3652:NODE)
 	$roles,			;Roles
 	"",				;RoutineSpec - Can't get this now
 	SystemID,		;SystemID
 	$username,		;Username
 	TimeStamp,		;UTCTimeStamp
 	$zu(67,14,$j), 	;CSP Session ID
 	$zu(67,20,$j), 	;User Info
 	+$zu(61,30,$zu(61)), ;JobId
 	$zu(203,4),		;Group
 	1,				;Status
 	$zu(67,11,$j),	;O/S Username
	$System.Security.Users.GetSecurityLevel()  ; Authentication level
	)	
 }
#;Insert into the Header
 s $li(Header,$ll(Header)+1) = AuditRecord
#;SAP240-
#;Pad it back out
 f i=($$$AuditHeaderSize-$l(Header)):-1:1 q:$l(Header_$lb($j("",i)))<=$$$AuditHeaderSize
 s $$$CacheAuditHeader=Header_$lb($j("",i))
 l -$$$CacheAuditHeader
 d $zu(139,InTransaction)
#;Flush the journal buffer
 i $$$JRNSTATUS f i=1:1:5 q:$$$JRNFLUSHBUF  H 1
 q $$$OK
Error s $zt=""
 i $d(InTransaction) d $zu(139,InTransaction)
 $$$IncAuditFailuresCount(Source_"/"_Type_"/"_Name)
 l -$$$CacheAuditHeader
 Quit $$$ERROR($$$CacheError,$ze)
}

/// List all audit records, brief display, reverse order. <br>
/// Parameters:
/// BeginDateTime - $zdatetime($H,3) value of the first audit record, "" = first record<br>
/// EndDateTime - $zdatetime($H,3) value of the last audit record, "" = Last record<br>
/// The following parameters may be specified as a comma separated list as follows:<br>
/// "*" - All records match<br>
/// "String,String1" - Any records matching one of these elements<br>
/// "String*" - Any record starting with "String"<br>
/// "String,String1*,String2" - Any record mathing one of these elements, or starting with "String1"<br>
/// Note that these are all case insensitive matches<br>
/// EventSources - Comma separated list of valid event sources<br>
/// EventTypes - Comma separated list of valid event types<br>
/// Events - Comma separated list of event names<br>
/// Usernames - Comma separated list of user names<br>
/// SystemIDs - Comma separated list of System:Config names<br> 
/// Pids - Comma separated list of Pids,VMS systems passed in Hex<br>
/// Groups - Comma separated list of Groups (currently unused)<br>
/// Authentication - Comma separated list of authentication types<br>
Query List(BeginDateTime As %String, EndDateTime As %String, EventSources As %String, EventTypes As %String, Events As %String, Usernames As %String, SystemIDs As %String, Pids As %String, Groups As %String, Authentications As Security.Datatype.Authentication) As %Query(ROWSPEC = "SystemID:%String,AuditIndex:%String,TimeStamp:%String,EventSource:%String,EventType:%String,Event:%String,Pid:%String,SessionID:%String,Username:%String,Description:%String,UTCTimeStamp:%String,Group:%String,JobNumber:%String,Authentication:%String") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, BeginDateTime As %String = "", EndDateTime As %String = "", EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*", Usernames As %String = "*", SystemIDs As %String = "*", Pids As %String = "*", Groups As %String = "*", Authentications As Security.Datatype.Authentication = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
#;Make sure the audit database is in the right format
 s Status=..Convert(,0)
 i '$$$ISOK(Status) q Status
 d ..ApplyAuditHeader()
#; Don't audit if the flag was passed in. if we request to not audit, make sure we have %All
 i '($d(%NoAuditList)&&($roles[$$$pAllRoleName)) {
	s CRLF=$c(13)_$c(10),String="",Pad=$j("",20)
	s String=String_$e($$$GetMsg($$$AuditMsg,"QueryNameC")_Pad,1,$l(Pad))_"List"_CRLF
 	s String=String_$e($$$GetMsg($$$AuditMsg,"BeginDateC")_Pad,1,$l(Pad))
 	i BeginDateTime="" {
 		s Node=$q(^$$$AuditDataName(""))
 		i Node="" {
			s BDateTime=$zdatetime($h,3)
		} else {
 			s BDateTime=..ConvertUTCToLocal($li(@Node,15))
		}
		s String=String_$$$FormatMsg($$$AuditMsg,"Beginning",BDateTime)
 	} else {
		s String=String_BeginDateTime
	}
 	s String=String_CRLF
 	s String=String_$e($$$GetMsg($$$AuditMsg,"EndDateC")_Pad,1,$l(Pad))
 	i EndDateTime="" {
		s Node=$q(^$$$AuditDataName(""),-1)
		i Node="" {
			s EDateTime=$zdateTime($h,3)
		} else {
			s EDateTime=..ConvertUTCToLocal($li(@Node,15))
		}
		s String=String_$$$FormatMsg($$$AuditMsg,"Ending",EDateTime)
 	} else {
		s String=String_EndDateTime
 	}
 	s String=String_CRLF
	s String=String_$e($$$GetMsg($$$AuditMsg,"EventSourcesC")_Pad,1,$l(Pad))_EventSources_CRLF
	s String=String_$e($$$GetMsg($$$AuditMsg,"EventTypesC")_Pad,1,$l(Pad))_EventTypes_CRLF
	s String=String_$e($$$GetMsg($$$AuditMsg,"EventsC")_Pad,1,$l(Pad))_Events_CRLF
	s String=String_$e($$$GetMsg($$$AuditMsg,"UsernamesC")_Pad,1,$l(Pad))_Usernames_CRLF
	s String=String_$e($$$GetMsg($$$AuditMsg,"SystemIDsC")_Pad,1,$l(Pad))_SystemIDs_CRLF
	s String=String_$e($$$GetMsg($$$AuditMsg,"PidsC")_Pad,1,$l(Pad))_Pids_CRLF
	s String=String_$e($$$GetMsg($$$AuditMsg,"GroupsC")_Pad,1,$l(Pad))_Groups_CRLF
	s String=String_$e($$$GetMsg($$$AuditMsg,"AuthenticationC")_Pad,1,$l(Pad))_Authentications_CRLF
	Do ..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditReport,String,$$$GetMsg($$$AuditMsg,"ListQuery"))
 }
 i EndDateTime="" {
	s UTCEndDateTime=..ConvertLocalHToUTC($p($H,",",1)_","_$p($h,",",2)_".999")
 } else {
	s UTCEndDateTime=$zdatetimeh(EndDateTime,$s(EndDateTime["-":3,1:-1),,,6)
	i $p(UTCEndDateTime,",",2)=0 s UTCEndDateTime=+UTCEndDateTime_","_86399.999
	s UTCEndDateTime=..ConvertLocalHToUTC(UTCEndDateTime)
 }
 i BeginDateTime="" {
#;47117 is earliest UTC date allowed. To prevent an Illegal value error
#;for GMT+x time zones, we set it to 47118
	s UTCBeginDateTime=..ConvertLocalHToUTC("47118,0")
 } else {
	s UTCBeginDateTime=$zdatetimeh(BeginDateTime,$s(BeginDateTime["-":3,1:-1),,,6)
	s UTCBeginDateTime=..ConvertLocalHToUTC(UTCBeginDateTime)
 }
#;On VMS, Pids are passed in as HEX, stored as decimal in the audit log
 i (Pids'="*"),$$$ISVMS f i=1:1:$l(Pids,",") s $p(Pids,",",i)=$zhex($p(Pids,",",i))
 i Authentications'="*" {
	 s InternalAuthentications=$$AuthenticationDisplayToLogical^%SYS.SECURITY(Authentications)
 } else {
	 s InternalAuthentications=Authentications
 }
 &SQL(DECLARE ListCursor CURSOR for 
	SELECT SystemID,AuditIndex,UTCTimeStamp,EventSource,EventType,Event,Pid,CSPSessionID,Username,Description,GroupName,JobNumber,Authentication
	FROM Audit
	WHERE UTCTimeStamp BETWEEN :UTCBeginDateTime AND :UTCEndDateTime
		AND ($$CheckName(:Usernames,Username)=1)
		AND	($$CheckName(:Events,Event)=1)
		AND	($$CheckName(:EventTypes,EventType)=1)
		AND ($$CheckName(:EventSources,EventSource)=1)
		AND	($$CheckName(:SystemIDs,SystemID)=1)
		AND	($$CheckName(:Pids,Pid)=1)
		AND	($$CheckName(:Groups,GroupName)=1)
 		AND ($$CheckAuthentication(:InternalAuthentications,Authentication)=1)
	ORDER BY UTCTimeStamp DESC, SystemID DESC, AuditIndex DESC)
 &SQL(OPEN ListCursor)

 Quit $$$OK
$$$CheckName()
$$$CheckAuthentication()
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
 &SQL(FETCH ListCursor
	INTO :SystemID,:AuditIndex,:UTCTimeStamp,:EventSource,:EventType,:Event,:Pid,:CSPSessionID,:Username,:Description,:GroupName,:JobNumber,:Authentication)
 if SQLCODE<0 q $$$ERROR($$$SQLError,SQLCODE,$g(%msg)) 
 If SQLCODE=100 {
	Set Row="",AtEnd=1
 } Else {
	Set Row=$LB(SystemID,AuditIndex,..ConvertUTCToLocal(UTCTimeStamp),EventSource,EventType,Event,$case($$$ISVMS,0:Pid,1:$ZHEX(+Pid)),CSPSessionID,Username,..DescriptionLogicalToDisplay(Description),UTCTimeStamp,GroupName,JobNumber,$$AuthenticationLogicalToDisplay^%SYS.SECURITY(Authentication))
	Set AtEnd=0
 }
 Quit $$$OK
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
 &SQL(CLOSE ListCursor)
 Quit $$$OK
}

/// List audit records ordered by Username.  
/// Parameters:
/// BeginDateTime - $zdatetime($H,3) value of the first audit record, "" = first record<br>
/// EndDateTime - $zdatetime($H,3) value of the Last audit record, "" = Last record<br>
/// The following parameters may be specified as a comma separated list as follows:<br>
/// "*" - All records match<br>
/// "String,String1" - Any records matching one of these elements<br>
/// "String*" - Any record starting with "String"<br>
/// "String,String1*,String2" - Any record mathing one of these elements, or starting with "String1"<br>
/// Note that these are all case insensitive matches<br>
/// EventSources - Comma separated list of valid event sources<br>
/// EventTypes - Comma separated list of valid event types<br>
/// Events - Comma separated list of event names<br>
/// Usernames - Comma separated list of user names<br>
/// SystemIDs - Comma separated list of System:Config names<br> 
Query ListByUser(BeginDateTime As %String, EndDateTime As %String, EventSources As %String, EventTypes As %String, Events As %String, Usernames As %String, SystemIDs As %String, Pids As %String, Groups As %String, Authentications As Security.Datatype.Authentication) As %Query(ROWSPEC = "SystemID:%String,AuditIndex:%String,TimeStamp:%String,EventSource:%String,EventType:%String,Event:%String,Pid:%String,SessionID:%String,Username:%String,Description:%String,UTCTimeStamp:%String,Group:%String,JobNumber:%String,Authentication:%String") [ SqlProc ]
{
}

ClassMethod ListByUserExecute(ByRef qHandle As %Binary, BeginDateTime As %String = "", EndDateTime As %String = "", EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*", Usernames As %String = "*", SystemIDs As %String = "*", Pids As %String = "*", Groups As %String = "*", Authentications As Security.Datatype.Authentication = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
#;Make sure the audit database is in the right format
 s Status=..Convert(,0)
 i '$$$ISOK(Status) q Status
 d ..ApplyAuditHeader()
 s CRLF=$c(13)_$c(10),String="",Pad=$j("",20)
 s String=String_$e($$$GetMsg($$$AuditMsg,"QueryNameC")_Pad,1,$l(Pad))_"ListByUser"_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"BeginDateC")_Pad,1,$l(Pad))
 i BeginDateTime="" {
 	s Node=$q(^$$$AuditDataName(""))
 	i Node="" {
		s BDateTime=$zdatetime($h,3)
	} else {
 		s BDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Beginning",BDateTime)
 } else {
	s String=String_BeginDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EndDateC")_Pad,1,$l(Pad))
 i EndDateTime="" {
	s Node=$q(^$$$AuditDataName(""),-1)
	i Node="" {
		s EDateTime=$zdatetime($h,3)
	} else {
		s EDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Ending",EDateTime)
 } else {
	s String=String_EndDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventSourcesC")_Pad,1,$l(Pad))_EventSources_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventTypesC")_Pad,1,$l(Pad))_EventTypes_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventsC")_Pad,1,$l(Pad))_Events_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"UsernamesC")_Pad,1,$l(Pad))_Usernames_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"SystemIDsC")_Pad,1,$l(Pad))_SystemIDs_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"PidsC")_Pad,1,$l(Pad))_Pids_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"GroupsC")_Pad,1,$l(Pad))_Pids_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"AuthenticationC")_Pad,1,$l(Pad))_Authentications_CRLF
 Do ..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditReport,String,$$$GetMsg($$$AuditMsg,"ListByUserQuery"))
 i EndDateTime="" {
	s UTCEndDateTime=..ConvertLocalHToUTC($p($H,",",1)_","_$p($h,",",2)_".999")
 } else {
	s UTCEndDateTime=$zdatetimeh(EndDateTime,$s(EndDateTime["-":3,1:-1),,,6)
	i $p(UTCEndDateTime,",",2)=0 s UTCEndDateTime=+UTCEndDateTime_","_86399.999
	s UTCEndDateTime=..ConvertLocalHToUTC(UTCEndDateTime)
 }
 i BeginDateTime="" {
	s UTCBeginDateTime=..ConvertLocalHToUTC("47118,0")
 } else {
	s UTCBeginDateTime=$zdatetimeh(BeginDateTime,$s(BeginDateTime["-":3,1:-1),,,6)
	s UTCBeginDateTime=..ConvertLocalHToUTC(UTCBeginDateTime)
 }
#;On VMS, Pids are passed in as HEX, stored as decimal in the audit log
 i (Pids'="*"),$$$ISVMS f i=1:1:$l(Pids,",") s $p(Pids,",",i)=$zhex($p(Pids,",",i))
 i Authentications'="*" {
	 s InternalAuthentications=$$AuthenticationDisplayToLogical^%SYS.SECURITY(Authentications)
 } else {
	 s InternalAuthentications=Authentications
 }
 &SQL(DECLARE ListByUserCursor CURSOR for 
	SELECT SystemID,AuditIndex,UTCTimeStamp,EventSource,EventType,Event,Pid,CSPSessionID,Username,Description,GroupName,JobNumber,Authentication
	FROM Audit
	WHERE UTCTimeStamp BETWEEN :UTCBeginDateTime AND :UTCEndDateTime
		AND ($$CheckName1(:Usernames,Username)=1)
		AND	($$CheckName1(:Events,Event)=1)
		AND	($$CheckName1(:EventTypes,EventType)=1)
		AND ($$CheckName1(:EventSources,EventSource)=1)
		AND	($$CheckName1(:SystemIDs,SystemID)=1)
		AND	($$CheckName1(:Pids,Pid)=1)
		AND	($$CheckName1(:Groups,GroupName)=1)
 		AND ($$CheckAuthentication(:InternalAuthentications,Authentication)=1)
	ORDER BY Username DESC,UTCTimeStamp DESC, AuditIndex DESC)
 &SQL(OPEN ListByUserCursor)
 Quit $$$OK
$$$CheckName(1)
$$$CheckAuthentication(1)
}

ClassMethod ListByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListByUserExecute ]
{
 &SQL(FETCH ListByUserCursor
	INTO :SystemID,:AuditIndex,:UTCTimeStamp,:EventSource,:EventType,:Event,:Pid,:CSPSessionID,:Username,:Description,:GroupName,:JobNumber,:Authentication)
 if SQLCODE<0 q $$$ERROR($$$SQLError,SQLCODE,$g(%msg)) 
 If SQLCODE=100 {
	Set Row="",AtEnd=1
 } Else {
	Set Row=$LB(SystemID,AuditIndex,..ConvertUTCToLocal(UTCTimeStamp),EventSource,EventType,Event,$case($$$ISVMS,0:Pid,1:$ZHEX(+Pid)),CSPSessionID,Username,..DescriptionLogicalToDisplay(Description),UTCTimeStamp,GroupName,JobNumber,$$AuthenticationLogicalToDisplay^%SYS.SECURITY(Authentication))
	Set AtEnd=0
 }
 Quit $$$OK
}

ClassMethod ListByUserClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListByUserExecute ]
{
 &SQL(CLOSE ListByUserCursor)
 Quit $$$OK
}

/// List audit records ordered by Event Source, Event Type, and Event.<br>
/// Parameters:<br>
/// BeginDateTime - $zdatetime($H,3) value of the first audit record, "" = first record<br>
/// EndDateTime - $zdatetime($H,3) value of the Last audit record, "" = Last record<br>
/// The following parameters may be specified as a comma separated list as follows:<br>
/// "*" - All records match<br>
/// "String,String1" - Any records matching one of these elements<br>
/// "String*" - Any record starting with "String"<br>
/// "String,String1*,String2" - Any record mathing one of these elements, or starting with "String1"<br>
/// Note that these are all case insensitive matches<br>
/// EventSources - Comma separated list of valid event sources<br>
/// EventTypes - Comma separated list of valid event types<br>
/// Events - Comma separated list of event names<br>
/// Usernames - Comma separated list of user names<br>
/// SystemIDs - Comma separated list of System:Config names<br> 
Query ListByEvent(BeginDateTime As %String, EndDateTime As %String, EventSources As %String, EventTypes As %String, Events As %String, Usernames As %String, SystemIDs As %String, Pids As %String, Groups As %String, Authentications As Security.Datatype.Authentication) As %Query(ROWSPEC = "SystemID:%String,AuditIndex:%String,TimeStamp:%String,EventSource:%String,EventType:%String,Event:%String,Pid:%String,SessionID:%String,Username:%String,Description:%String,UTCTimeStamp:%String,Group:%String,JobNumber:%String,Authentication:%String") [ SqlProc ]
{
}

ClassMethod ListByEventExecute(ByRef qHandle As %Binary, BeginDateTime As %String = "", EndDateTime As %String = "", EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*", Usernames As %String = "*", SystemIDs As %String = "*", Pids As %String = "*", Groups As %String = "*", Authentications As Security.Datatype.Authentication = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
#;Make sure the audit database is in the right format
 s Status=..Convert(,0)
 i '$$$ISOK(Status) q Status
 d ..ApplyAuditHeader()
 s CRLF=$c(13)_$c(10),String="",Pad=$j("",20)
 s String=String_$e($$$GetMsg($$$AuditMsg,"QueryNameC")_Pad,1,$l(Pad))_"ListByEvent"_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"BeginDateC")_Pad,1,$l(Pad))
 i BeginDateTime="" {
 	s Node=$q(^$$$AuditDataName(""))
 	i Node="" {
		s BDateTime=$zdatetime($h,3)
	} else {
 		s BDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Beginning",BDateTime)
 } else {
	s String=String_BeginDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EndDateC")_Pad,1,$l(Pad))
 i EndDateTime="" {
	s Node=$q(^$$$AuditDataName(""),-1)
	i Node="" {
		s EDateTime=$zdatetime($h,3)
	} else {
		s EDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Ending",EDateTime)
 } else {
	s String=String_EndDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventSourcesC")_Pad,1,$l(Pad))_EventSources_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventTypesC")_Pad,1,$l(Pad))_EventTypes_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventsC")_Pad,1,$l(Pad))_Events_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"UsernamesC")_Pad,1,$l(Pad))_Usernames_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"SystemIDsC")_Pad,1,$l(Pad))_SystemIDs_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"PidsC")_Pad,1,$l(Pad))_Pids_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"GroupsC")_Pad,1,$l(Pad))_Groups_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"AuthenticationC")_Pad,1,$l(Pad))_Authentications_CRLF
 Do ..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditReport,String,$$$GetMsg($$$AuditMsg,"ListByEventQuery"))
 i EndDateTime="" {
	s UTCEndDateTime=..ConvertLocalHToUTC($p($H,",",1)_","_$p($h,",",2)_".999")
 } else {
	s UTCEndDateTime=$zdatetimeh(EndDateTime,$s(EndDateTime["-":3,1:-1),,,6)
	i $p(UTCEndDateTime,",",2)=0 s UTCEndDateTime=+UTCEndDateTime_","_86399.999
	s UTCEndDateTime=..ConvertLocalHToUTC(UTCEndDateTime)
 }
 i BeginDateTime="" {
	s UTCBeginDateTime=..ConvertLocalHToUTC("47118,0")
 } else {
	s UTCBeginDateTime=$zdatetimeh(BeginDateTime,$s(BeginDateTime["-":3,1:-1),,,6)
	s UTCBeginDateTime=..ConvertLocalHToUTC(UTCBeginDateTime)
 }
#;On VMS, Pids are passed in as HEX, stored as decimal in the audit log
 i (Pids'="*"),$$$ISVMS f i=1:1:$l(Pids,",") s $p(Pids,",",i)=$zhex($p(Pids,",",i))
 i Authentications'="*" {
	 s InternalAuthentications=$$AuthenticationDisplayToLogical^%SYS.SECURITY(Authentications)
 } else {
	 s InternalAuthentications=Authentications
 }
 &SQL(DECLARE ListByEventCursor CURSOR for 
	SELECT SystemID,AuditIndex,UTCTimeStamp,EventSource,EventType,Event,Pid,CSPSessionID,Username,Description,GroupName,JobNumber,Authentication
	FROM Audit
	WHERE UTCTimeStamp BETWEEN :UTCBeginDateTime AND :UTCEndDateTime
		AND ($$CheckName2(:Usernames,Username)=1)
		AND	($$CheckName2(:Events,Event)=1)
		AND	($$CheckName2(:EventTypes,EventType)=1)
		AND ($$CheckName2(:EventSources,EventSource)=1)
		AND	($$CheckName2(:SystemIDs,SystemID)=1)
		AND	($$CheckName2(:Pids,Pid)=1)
		AND	($$CheckName2(:Groups,GroupName)=1)
 		AND ($$CheckAuthentication(:InternalAuthentications,Authentication)=1)
	ORDER BY EventSource,EventType,Event DESC, UTCTimeStamp DESC, AuditIndex DESC)
 &SQL(OPEN ListByEventCursor)
 Quit $$$OK
$$$CheckName(2)
$$$CheckAuthentication(2)
}

ClassMethod ListByEventFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListByEventExecute ]
{
 &SQL(FETCH ListByEventCursor
	INTO :SystemID,:AuditIndex,:UTCTimeStamp,:EventSource,:EventType,:Event,:Pid,:CSPSessionID,:Username,:Description,:GroupName,:JobNumber,:Authentication)
 if SQLCODE<0 q $$$ERROR($$$SQLError,SQLCODE,$g(%msg)) 
 If SQLCODE=100 {
	Set Row="",AtEnd=1
 } Else {
	Set Row=$LB(SystemID,AuditIndex,..ConvertUTCToLocal(UTCTimeStamp),EventSource,EventType,Event,$case($$$ISVMS,0:Pid,1:$ZHEX(+Pid)),CSPSessionID,Username,..DescriptionLogicalToDisplay(Description),UTCTimeStamp,GroupName,JobNumber,$$AuthenticationLogicalToDisplay^%SYS.SECURITY(Authentication))
	Set AtEnd=0
 }
 Quit $$$OK
}

ClassMethod ListByEventClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListByEventExecute ]
{
 &SQL(CLOSE ListByEventCursor)
 Quit $$$OK
}

/// List audit records ordered by Pid.<br>
/// Parameters:<br>
/// BeginDateTime - $zdatetime($H,3) value of the first audit record, "" = first record<br>
/// EndDateTime - $zdatetime($H,3) value of the Last audit record, "" = Last record<br>
/// The following parameters may be specified as a comma separated list as follows:<br>
/// "*" - All records match<br>
/// "String,String1" - Any records matching one of these elements<br>
/// "String*" - Any record starting with "String"<br>
/// "String,String1*,String2" - Any record mathing one of these elements, or starting with "String1"<br>
/// Note that these are all case insensitive matches<br>
/// EventSources - Comma separated list of valid event sources<br>
/// EventTypes - Comma separated list of valid event types<br>
/// Events - Comma separated list of event names<br>
/// Usernames - Comma separated list of user names<br>
/// SystemIDs - Comma separated list of System:Config names<br> 
Query ListByPid(BeginDateTime As %String, EndDateTime As %String, EventSources As %String, EventTypes As %String, Events As %String, Usernames As %String, SystemIDs As %String, Pids As %String, Groups As %String, Authentications As Security.Datatype.Authentication) As %Query(ROWSPEC = "SystemID:%String,AuditIndex:%String,TimeStamp:%String,EventSource:%String,EventType:%String,Event:%String,Pid:%String,SessionID:%String,Username:%String,Description:%String,UTCTimeStamp:%String,Group:%String,JobNumber:%String,Authentication:%String") [ SqlProc ]
{
}

ClassMethod ListByPidExecute(ByRef qHandle As %Binary, BeginDateTime As %String = "", EndDateTime As %String = "", EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*", Usernames As %String = "*", SystemIDs As %String = "*", Pids As %String = "*", Groups As %String = "*", Authentications As Security.Datatype.Authentication = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
#;Make sure the audit database is in the right format
 s Status=..Convert(,0)
 i '$$$ISOK(Status) q Status
 d ..ApplyAuditHeader()
 s CRLF=$c(13)_$c(10),String="",Pad=$j("",20)
 s String=String_$e($$$GetMsg($$$AuditMsg,"QueryNameC")_Pad,1,$l(Pad))_"ListByPid"_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"BeginDateC")_Pad,1,$l(Pad))
 i BeginDateTime="" {
 	s Node=$q(^$$$AuditDataName(""))
 	i Node="" {
		s BDateTime=$zdatetime($h,3)
	} else {
 		s BDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Beginning",BDateTime)
 } else {
	s String=String_BeginDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EndDateC")_Pad,1,$l(Pad))
 i EndDateTime="" {
	s Node=$q(^$$$AuditDataName(""),-1)
	i Node="" {
		s EDateTime=$zdatetime($h,3)
	} else {
		s EDateTime=..ConvertUTCToLocal($li(@Node,15))
	}
	s String=String_$$$FormatMsg($$$AuditMsg,"Ending",EDateTime)
 } else {
	s String=String_EndDateTime
 }
 s String=String_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventSourcesC")_Pad,1,$l(Pad))_EventSources_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventTypesC")_Pad,1,$l(Pad))_EventTypes_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"EventsC")_Pad,1,$l(Pad))_Events_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"UsernamesC")_Pad,1,$l(Pad))_Usernames_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"SystemIDsC")_Pad,1,$l(Pad))_SystemIDs_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"PidsC")_Pad,1,$l(Pad))_Pids_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"GroupsC")_Pad,1,$l(Pad))_Groups_CRLF
 s String=String_$e($$$GetMsg($$$AuditMsg,"AuthenticationC")_Pad,1,$l(Pad))_Authentications_CRLF
 Do ..WriteToAuditFile($$$SourceSystem,$$$TypeSecurity,$$$NameAuditReport,String,$$$GetMsg($$$AuditMsg,"ListByPidQuery"))
 i EndDateTime="" {
	s UTCEndDateTime=..ConvertLocalHToUTC($p($H,",",1)_","_$p($h,",",2)_".999")
 } else {
	s UTCEndDateTime=$zdatetimeh(EndDateTime,$s(EndDateTime["-":3,1:-1),,,6)
	i $p(UTCEndDateTime,",",2)=0 s UTCEndDateTime=+UTCEndDateTime_","_86399.999
	s UTCEndDateTime=..ConvertLocalHToUTC(UTCEndDateTime)
 }
 i BeginDateTime="" {
	s UTCBeginDateTime=..ConvertLocalHToUTC("47118,0")
 } else {
	s UTCBeginDateTime=$zdatetimeh(BeginDateTime,$s(BeginDateTime["-":3,1:-1),,,6)
	s UTCBeginDateTime=..ConvertLocalHToUTC(UTCBeginDateTime)
 }
#;On VMS, Pids are passed in as HEX, stored as decimal in the audit log
 i (Pids'="*"),$$$ISVMS f i=1:1:$l(Pids,",") s $p(Pids,",",i)=$zhex($p(Pids,",",i))
 i Authentications'="*" {
	 s InternalAuthentications=$$AuthenticationDisplayToLogical^%SYS.SECURITY(Authentications)
 } else {
	 s InternalAuthentications=Authentications
 }
 &SQL(DECLARE ListByPidCursor CURSOR for 
	SELECT SystemID,AuditIndex,UTCTimeStamp,EventSource,EventType,Event,Pid,CSPSessionID,Username,Description,GroupName,JobNumber,Authentication
	FROM Audit
	WHERE UTCTimeStamp BETWEEN :UTCBeginDateTime AND :UTCEndDateTime
		AND ($$CheckName3(:Usernames,Username)=1)
		AND	($$CheckName3(:Events,Event)=1)
		AND	($$CheckName3(:EventTypes,EventType)=1)
		AND ($$CheckName3(:EventSources,EventSource)=1)
		AND	($$CheckName3(:SystemIDs,SystemID)=1)
		AND	($$CheckName3(:Pids,Pid)=1)
		AND	($$CheckName3(:Groups,GroupName)=1)
 		AND ($$CheckAuthentication(:InternalAuthentications,Authentication)=1)
	ORDER BY +Pid,CSPSessionID,UTCTimeStamp DESC, AuditIndex DESC)
 &SQL(OPEN ListByPidCursor)
 Quit $$$OK
$$$CheckName(3)
$$$CheckAuthentication(3)
}

ClassMethod ListByPidFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListByPidExecute ]
{
 &SQL(FETCH ListByPidCursor
	INTO :SystemID,:AuditIndex,:UTCTimeStamp,:EventSource,:EventType,:Event,:Pid,:CSPSessionID,:Username,:Description,:GroupName,:JobNumber,:Authentication)
 if SQLCODE<0 q $$$ERROR($$$SQLError,SQLCODE,$g(%msg)) 
 If SQLCODE=100 {
	Set Row="",AtEnd=1
 } Else {
	Set Row=$LB(SystemID,AuditIndex,..ConvertUTCToLocal(UTCTimeStamp),EventSource,EventType,Event,$case($$$ISVMS,0:Pid,1:$ZHEX(+Pid)),CSPSessionID,Username,..DescriptionLogicalToDisplay(Description),UTCTimeStamp,GroupName,JobNumber,$$AuthenticationLogicalToDisplay^%SYS.SECURITY(Authentication))
	Set AtEnd=0
 }
 Quit $$$OK
}

ClassMethod ListByPidClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListByPidExecute ]
{
 &SQL(CLOSE ListByPidCursor)
 Quit $$$OK
}

/// Open an Audit Log item, given its ID information (UTC date, system ID, and audit index).  
ClassMethod OpenAuditItem(UTCTimeStamp As %String, SystemID As %String, AuditIndex As %BigInt) As %SYS.Audit [ CodeMode = expression ]
{
..%OpenId(UTCTimeStamp_"||"_SystemID_"||"_AuditIndex)
}

Method %OnOpen() As %Status [ Private, ServerOnly = 1 ]
{
 s $zt="Error"
 s ..Namespace=..NamespaceLogicalToDisplay(..Namespace)
 s ..Description=..DescriptionLogicalToDisplay(..Description)
 s ..EventData=..EventDataLogicalToDisplay(..EventData)
 q $$$OK
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

Storage Audit
{
<Data name="AuditDefaultData">
<Value name="1">
<Value>AuditIndex</Value>
</Value>
<Value name="2">
<Value>ClientExecutableName</Value>
</Value>
<Value name="3">
<Value>ClientIPAddress</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Event</Value>
</Value>
<Value name="6">
<Value>EventData</Value>
</Value>
<Value name="7">
<Value>EventSource</Value>
</Value>
<Value name="8">
<Value>EventType</Value>
</Value>
<Value name="9">
<Value>Namespace</Value>
</Value>
<Value name="10">
<Value>Pid</Value>
</Value>
<Value name="11">
<Value>Roles</Value>
</Value>
<Value name="12">
<Value>RoutineSpec</Value>
</Value>
<Value name="13">
<Value>SystemID</Value>
</Value>
<Value name="14">
<Value>Username</Value>
</Value>
<Value name="15">
<Value>UTCTimeStamp</Value>
</Value>
<Value name="16">
<Value>CSPSessionID</Value>
</Value>
<Value name="17">
<Value>UserInfo</Value>
</Value>
<Value name="18">
<Value>JobId</Value>
</Value>
<Value name="19">
<Value>GroupName</Value>
</Value>
<Value name="20">
<Value>Status</Value>
</Value>
<Value name="21">
<Value>OSUsername</Value>
</Value>
<Value name="22">
<Value>Authentication</Value>
</Value>
<Value name="23">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CacheAuditD</DataLocation>
<DefaultData>AuditDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CacheAuditD</IdLocation>
<IndexLocation>^CacheAuditI</IndexLocation>
<StreamLocation>^CacheAuditS</StreamLocation>
<Type>%CacheStorage</Type>
}

}
