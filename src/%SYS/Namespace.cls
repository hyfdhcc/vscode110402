Include (%sySystem, %syDatabase)

Class %SYS.Namespace Extends %Persistent [ Abstract, System = 4 ]
{

/*
---------------------Documentation------------------------------------
RJF244   1/17/16 Ray Fucillo, optimize GetRoutineDest to use $zu(90,22)
STC2307 07/29/14 Steve Clay, Add SYS.Namespace:GetNSInfo() method
STC2255 10/23/13 Steve Clay, Remove GXLATE include file from %SYS.Namespace class
STC2165 01/10/13 Steve Clay, Update documentation in %SYS.Namespace:List() query 
SML1565	10/17/12 Simon Li, Protect namespace table scanning without lock command.
SOH341   6/22/12 Steven Hobbs, ListAll uses ^ with remote namespaces and
				deletes %CACHELIB
SML1511  5/30/12 Simon Li, Add GetPackageDest() method in %SYS.Namespace class.
SOH325   3/30/12 Steven Hobbs, Add ListAll method
SML1265 12/01/10 Simon Li, Replace ^CacheTemp with private global in system query codes.
SML1198 03/05/10 Simon Li, Fix GetGlobalDest() with single level subscript.
STC1674 09/22/09 Steve Clay, Update error trapping in %SYS.Namespace.Enabled method
SML1068 09/25/08 Simon Li, Support multi-level subscript for %SYS.Namespace.GetGlobalDest().
STC1425 07/26/08 Steve Clay, Enabled now handles databases not mounted at startup.
STC1094 10/28/05 Steve Clay, Update GetGlobalDest and GetRoutineDest
CFL1375 8/22/05 Carlos Lopes, fix GetGlobalDest and GetRoutineDest
CFL1345 7/05/05 Carlos Lopes, add GetRoutineDest and GetGlobalDest methods
SML592  6/07/05 Simon Li, Use DEFAULTFETCH macro for default fetch routine to
                initialize Row to null string.
RJW1088 04/06/05 Ron Watt, Rational Rose can't connect to Cache
STC747  01/12/05, Steve Clay, add parameter to %SYS.NAMESPACE
CFL1221 01/01/05 Carlos Lopes, reuse code in List^%SYS.NAMESPACE
LFT1360 12/17/04 Laura Tillem, check for status containing "Mounted"
LFT1320 11/02/4, Laura Tillem, %SYS.GLO
LFT1316 10/21/04, Laura Tillem, reorg
CFL1117 08/03/04, Carlos Lopes, fix Enabled method (LFT1271)
CFL1076 06/16/04, Carlos Lopes, add DontConnect parameter to List query
CFL1073 06/04/04, Carlos Lopes, add Remote parameter to List query
CFL1070 06/03/04, Carlos Lopes, return Status in List query
CFL1069 05/31/04, Carlos Lopes, add Enabled method and some doc
CFL1068 05/28/04, Carlos Lopes, fix some bugs in the List query
CFL1065 05/26/04, Carlos Lopes, add List query
-------------------End Documentation----------------------------------
*/
/// Returns True if a namespace is enabled, that is, if its default directory is 
/// reachable.<br>
/// This method will implicitly mount a database which has not yet been accessed 
/// by the system. If the database has been explicitly dismounted, or is not mountable, 
/// then the method will return false.
ClassMethod Enabled(NamespaceName As %String) As %Boolean [ Internal ]
{
	Try {
		s Namespace=$zcvt(NamespaceName,"U")
		s Sys=$$defsys^%SYS.GLO(Namespace)
		s Dir=$$defdir^%SYS.GLO(Namespace)
		i $d(^|"^"_Sys_"^"_Dir|X)
		s Status=1
	} Catch {
		s Status=0
	}
	q Status
}

ClassMethod Exists(NamespaceName As %String) As %Boolean [ CodeMode = expression ]
{
$zu(90,10,NamespaceName)
}

/// Return information about a namespaces default global database.<br>
/// Parameters:<br>
/// Namespace - Namespace to obtain information about. Can be either a real namespace
///             or an implied namespace.<br>
/// DontConnect - If the namespace's default database is a remote database mounted across ECP,
/// then if set to 1, and the remote database is not mounted, we will not try to mount it (default = 0).<br><br>
/// 
/// Return Values:<br>
/// Returns an array of information about the default database.<br>
/// Info("System") - name of system default global directory resides on.<br>
/// Info("Directory") - Name of default global directory.<br>
/// Info("Resource") - Name of resource attached to the directory.<br>
/// Info("ReadOnly") - 0/1 is the database mounted read only.<br>
/// Info("Status") - 1 = Success, %Status if any kind of error.<br><br>
/// 	
/// If an implied namespace is passed in, ^SERVER^DIR, and the SERVER is the local
/// system, then the database is treated as a local database, and Info("System") will
/// be returned as "".
/// 	
ClassMethod GetNSInfo(Namespace, Info, DontConnect = 0)
{
 d GetNSInfo^%SYS.NAMESPACE(Namespace,.Info,DontConnect)
 q
}

/// Returns the system^directory where ^[Namespace]Global(Subscript) is mapped to.
/// If Subscript is missing, it returns the location for ^[Namespace]Global.
/// If Global is missing, it returns the default global location for Namespace.<br>
/// This API support multi-level subscripts mapping, for example, pass "abc",1,2 in Subscript will check
/// the destination of Global("abc",1,2).<br>
/// If the system is the same as the local system, then system is set to "".
ClassMethod GetGlobalDest(Namespace As %String = {$zu(5)}, Global As %String = "^", Subscript As %String = "") As %String
{
	i Namespace="" s Namespace=$zu(5)
#;SML1068 ; to support multi-level subscript, we should not put quote around the input.
#;SML1197 ; we need to check whether we need to put '"' around the Subscript argument.
	s:Subscript'="" Subscript=$$QuoteSub(Subscript)
	s Dest=$$getdest^%SYS.GXLINF1(Namespace,Global,Subscript)
	i $p(Dest,"^",1)=$zu(63,4,0) s $p(Dest,"^",1)=""
	q Dest
#;SML1197+ ; Put '"' around the subscript if it is not valid for getdest^%SYS.GXLINF1
QuoteSub(sub)
	s $zt="err"
	s vnam="x("_sub_")",ql=$ql(vnam)
	#; No error, don't need to add '"' around it.
	quit sub
err quit """"_sub_""""
#;SML1197-
}

/// Returns the system^directory where Routine is mapped to in this Namespace.
/// If Routine is missing, it returns the default routine location for Namespace.
/// The allowed types are: INC, INT, MAC and OBJ.
/// If the system is the same as the local system, then system is set to "".
ClassMethod GetRoutineDest(Namespace As %String = {$zu(5)}, Routine As %String = "", Type As %String = "INT") As %String
{
#;RJF244+
	#; We convert ^ to @ if this is an implied namespace to be compatible with
	#; GetGlobalDest() and the pre-RJF244 behavior of GetRoutineDest().  If the
	#; implied namespace hasn't been set up by ZN yet, these methods will
	#; return null (this isn't the best definition but it's been this way and
	#; we don't really want to set up the namespace here).
	i Namespace="" {
		s nsp=$zu(5)
	} else {
		s nsp=Namespace
	}
	i $e(nsp)="^" { s nsp=$tr(nsp,"^","@") }
	Set Global=$s(Type="MAC":"rMAC",Type="OBJ":"rOBJ",Type="INC":"rINC",1:"ROUTINE")
	#; return null for namespace that doesn't exist
	return:'$zu(90,10,nsp) ""
	return:Routine="" $piece($zu(90,22,nsp,Global),"^",2,3)
	return $piece($zu(90,22,nsp,Global,Routine),"^",2,3)
#;RJF244-
}

/// Returns the system^directory where Package is mapped to in this Namespace.
/// If Package is missing, it returns the default package location for Namespace.
/// If the system is the same as the local system, then system is set to "".
ClassMethod GetPackageDest(Namespace As %String = "", Package As %String = "") As %String
{
	i Package'=""&&($e(Package,*)'=".") s Package=Package_"."
	quit ..GetRoutineDest(Namespace,Package)
}

/// The <b>ListAll</b> method quickly returns a list of all the
/// namespaces in the current process.
/// The parameter <b>array</b> is a local array
/// name passed by reference.  On return from <b>ListAll</b>, the subscripts
/// of the <b>array</b> parameter will be the namespace names of
/// the current process.  Each subscripted entry in <b>array</b>
/// will contain the empty string.
/// When <b>ConvertImplicit</b> is true, it will convert the '@' in implicit namespace to '^'.
/// The default value of <b>ConvertImplicit</b> is true when it is not specified.
/// <p>
/// Each explicit namespace is returned using the local namespace name as
/// the subscript string.
/// Each implicit namespace is returned using a subscript string that contains a
/// caret ^, followed by the system name, followed by another caret ^,
/// followed by the name of directory containing the database file.  If
/// the implicit namespace is local then the system name is the empty string
/// and the subscript string starts with two adjacent carets ^^.
/// 
ClassMethod ListAll(Output array, ConvertImplicit As %Boolean = 1) As %Status
{
	Kill array
	#;SML1565+
	s nsversion=$zu(90,20,1)
	s nsplist=$zu(90,28,0,0,nsversion)
	s lastp=$p(nsplist,",",$l(nsplist,","))
	s startidx=$s(nsplist]"":$s(lastp?1N.N:+lastp,1:0),1:0)
	while (nsplist=-1 || startidx) {
		if nsplist=-1 {
			#; The nsversion must be changed need to re-scan the namespace table.
			s startidx=0,nsversion=$zu(90,20,1)
			k array
		} else {
			#; Setup the array from the retrieved list.
			f i=1:1:$l(nsplist,",") s array($p(nsplist,",",i))=""
		}
		s nsplist=$zu(90,28,0,startidx,nsversion)
		s lastp=$p(nsplist,",",$l(nsplist,","))
		s startidx=$s(nsplist]"":$s(lastp?1N.N:+lastp,1:0),1:0)
	}
	#; Setup the array from the retrieved list.
	i nsplist]"" f i=1:1:$l(nsplist,",") s array($p(nsplist,",",i))=""
	#;SML1565-
	Kill array("%CACHELIB")
	#;SML1565
	Quit:'ConvertImplicit $$$OK
	#; Convert @ in implicit namespaces to ^
	Set I="@"
	For {
	  Set I=$Order(array(I))
	  Quit:$E(I)'="@"
	  Kill array(I)
	  Set R=$P(I,"@",2)
	  Set array("^"_R_"^"_$E(I,$L(R)+3,*))=""
	}
	Quit $$$OK
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
	Set Index=$p(qHandle,"^",1)
	Kill $$$ISCQUERYTEMP(Index)
	Quit $$$OK
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Remote As %Boolean = 0, DontConnect As %Boolean = 0) As %Status [ Internal ]
{
	Set Index=$i($$$ISCQUERYTEMP)
	;
	Do List^%SYS.NAMESPACE(.NspLst,4, Remote,DontConnect)
	Set ns=""
	For {
		Set ns=$o(NspLst(ns)) If ns="" Set qHandle=Index_"^" Quit
		Set $$$ISCQUERYTEMP(Index,ns)=$ListBuild(ns)_NspLst(ns)
	}
	Quit $$$OK
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
 	$$$DEFAULTFETCHPPG
	Quit $$$OK
}

/// Returns a list of namespaces defined on the system.<br>
/// Parameters:<br>
/// Remote - 0/1 whether to return any remotely mapped namespaces or not.<br>
/// DontConnect - 0/1 whether to connect to remote system or not if a connection
/// has not been made yet.<br>
/// Return values:<br>
/// Status - (0/1) Whether the namespace is available or not.<br>
/// If the Status returned is 1, the default global database for the namespace is 
/// either mounted, or not mounted yet. If 0, then the database has been dismounted.<br>
/// Remote -  (0/1) Whether the namespace is mapped to a remote ECP system.<br>
Query List(Remote As %Boolean, DontConnect As %Boolean) As %Query(ROWSPEC = "Nsp:%String,Status:%String,Remote:%Boolean") [ SqlProc ]
{
}

Storage Default
{
<Data name="NamespaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^SYS.NamespaceD</DataLocation>
<DefaultData>NamespaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.NamespaceD</IdLocation>
<IndexLocation>^SYS.NamespaceI</IndexLocation>
<StreamLocation>^SYS.NamespaceS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
