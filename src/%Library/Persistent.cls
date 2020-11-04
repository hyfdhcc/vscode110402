/// The <CLASS>%Persistent</CLASS> class provides the basic mechanism by 
/// which objects are stored to and retrieved from a database. 
Class %Library.Persistent Extends %SwizzleObject [ Abstract, ClassType = persistent, NoExtent, PropertyClass = %Library.PersistentProperty, System = 2 ]
{

/// <p>If a persistent class uses %Library.CacheStorage then the <var>DEFAULTGLOBAL</var> parameter is used as the
/// default global root for the values of the storage keywords COUNTERLOCATION, DATALOCATION, IDLOCATION,
/// INDEXLOCATION and STREAMLOCATION in the active storage definition. <var>DEFAULTGLOBAL</var> is only used
/// to generate location keyword values that are not already defined. The location value is constructed by adding
/// a location type to the end of <var>DEFAULTGLOBAL</var>. For example, if <var>DEFAULTGLOBAL</var> = "^GL.Account"
/// the compiler will generate <var>DATALOCATION</var> = ^GL.AccountD.</p>
/// <br>
/// The location types are:
/// <table>
/// <tr><th align="left">Location</th><th align="left">Type</th>
/// <tr><td>COUNTERLOCATION</td><td align="center">C</td></tr>
/// <tr><td>DATALOCATION</td><td align="center">D</td></tr>
/// <tr><td>IDLOCATION</td><td align="center">D</td></tr>
/// <tr><td>INDEXLOCATION</td><td align="center">I</td></tr>
/// <tr><td>STREAMLOCATION</td><td align="center">S</td></tr>
/// </table>
Parameter DEFAULTGLOBAL As STRING;

/// If the <var>DSTIME</var> parameter is set to AUTO then the most recent filing operation in the current DSTIME value 
/// for each object will be recorded in a global, ^OBJ.DSTIME: 
/// <br>
/// 	^OBJ.DSTIME(<var>ExtentName</var>,<var>DSTIME</var>,<var>objectID</var>) = <var>filing operation</var> 
/// <br>
/// For DSTIME=AUTO the DSTIME value is recorded in ^OBJ.DSTIME and is set by the consumer of DSTIME data.
/// <br>
/// Refer to %DeepSee documentation for more information on how DSTIME is used by %DeepSee. 
/// <br>
/// The filing operations are:
/// <table>
/// <tr><th align="left">Code</th><th align="left">Operation</th>
/// <tr><td>0</td><td align="center">Update</td></tr>
/// <tr><td>1</td><td align="center">Insert</td></tr>
/// <tr><td>2</td><td align="center">Delete</td></tr>
/// </table>
/// <br>
/// If the <var>DSTIME</var> parameter is set to MANUAL then the user is responsible for journaling object filing operations.
Parameter DSTIME As STRING [ Constraint = ",AUTO,MANUAL", Flags = ENUM ];

/// DSINTERVAL is the number of seconds between one DSTIME value and the next. The DSTIME value for DSINTERVAL > 0 is computed from $ZTIMESTAMP
/// and is the number of seconds from day 0, time 0 to the nearest interval, rounded down. Using an interval has the effect of grouping
/// all DSTIME entries for the class in some number of seconds.
Parameter DSINTERVAL As INTEGER;

/// The <var>EXTENTQUERYSPEC</var> parameter defines the properties to be retrieved in 
/// addition to the IDKEY value for the built-in <b>Extent</b> query.
/// <p>Persistent classes should define a value of for <var>EXTENTQUERYSPEC</var> if they 
/// wish to include additional properties in their built-in <b>Extent</b> query.
/// <p>For example:
/// <EXAMPLE LANGUAGE=NONE>
/// parameter EXTENTQUERYSPEC &#123 default = "Name,SSN,Age"; &#125
/// </EXAMPLE>
Parameter EXTENTQUERYSPEC As ROWSPEC [ Flags = LIST ];

/// The <var>EXTENTSIZE</var> parameter is used to inform the <i>Cach&eacute; SQL Query Optimizer</i> 
/// of the approximate number of instances in the extent containing instances of this class.
/// 
/// <p>For example, a class that expects to have about 1,000,000 instances should define:
/// <EXAMPLE LANGUAGE=NONE>
/// parameter EXTENTSIZE &#123 default = 1000000; &#125
/// </EXAMPLE>
Parameter EXTENTSIZE As INTEGER = 100000;

/// If this parameter is set to 1 then a GUID will be assigned (to the %GUID property) to each new object.
/// When the object is saved for the first time this GUID value will be recorded in a namespace
/// index which will allow GUID to be resolved to OIDs.
Parameter GUIDENABLED = 0;

/// The <var>IDENTIFIEDBY</var> parameter can optionally be set to the name 
/// of a required property whose type is a reference to another class (not a literal). 
/// This property's IDKEY is then used as the prefix for the IDKEY of this class.
Parameter IDENTIFIEDBY;

/// The <var>MANAGEDEXTENT</var> parameter can be set to 0 (zero) to cause the Extent Manager
/// to ignore this class. If set to 1 then the Extent Manager will register globals used by
/// the class and detect collisions. Unmanaged extents (MANAGEDEXTENT = 0) are not checked.
/// Currently, only classes using default storage (%Library.CacheStorage) can be managed.
Parameter MANAGEDEXTENT As INTEGER [ Constraint = "0,1", Flags = ENUM ] = 1;

/// READONLY = 1 means that objects can be created, opened but not saved or deleted.
/// Tables are projected to SQL as READONLY.
Parameter READONLY = 0;

/// ROWLEVELSECURITY = 1 | &lt;property&gt; means that row level security is active and the list
/// of users/roles for a given instance/row is contained in a generated property. If
/// the value of this parameter is a valid property name then that property will be
/// used as the reader list and only generated if not already defined.
Parameter ROWLEVELSECURITY;

/// SQLPREVENTFULLSCAN = 1 means an attempt to prepare a query that will result in a full scan 
/// of the data map will result in an error.  This applies only to queries that result in a 
/// master map scan (not indexes), with no subscript-limiting conditions on %ID or any of its components, 
/// including queries with aggregates, and including UPDATE/DELETE.
Parameter SQLPREVENTFULLSCAN = 0;

/// VERSIONPROPERTY = &lt;property&gt; means that the &lt;property&gt; in memory will be compared to
/// the &lt;property&gt; on disk during an update. If different a concurrency conflict
/// error will be reported and the save will fail.
Parameter VERSIONPROPERTY As STRING;

/// VERSIONCLIENTNAME can be set to a valid CLIENTNAME (see property CLIENTNAME) value. This
/// value will be used for client projections of the %Version property.
Parameter VERSIONCLIENTNAME;

/// <p>%Concurrency holds the value of the concurrency setting for this object.
/// </p>
/// 	<TABLE cols=2 border=1>
/// 	<TR>
/// 		<TD valign="top">0:</TD><TD CLASS=Term valign="top">None</TD>
/// 			<TD valign="top">
/// 			Suppress all concurrency controls for this object. No locks are used.
/// 			</TD>
/// 		</TR>
/// 		<TR>
/// 			<TD valign="top">1:</TD><TD CLASS=Term valign="top">Atomic Read</TD>
/// 			<TD valign="top">
/// 				When an object is loaded, <b>%LoadData</B>  will read the entire object from disk without the possibility
/// 			that another process will write any data to this object before the read operation is
/// 			complete. If necessary, Cache will acquire a shared lock on the object to guarantee an atomic read.
/// 			Any locks acquired during the read operation are released after the read operation is completed.
/// 				No locks are acquired for a new object.
/// 			<b>%SaveData</B> will acquire an exclusive lock during the course of the save.
/// 			</TD>
/// 		</TR>
/// 		<TR>
/// 			<TD valign="top">2:</TD><TD CLASS=Term valign="top">Shared</TD>
/// 			<TD valign="top">
/// 				When an object is loaded, <b>%LoadData</B> will acquire a shared lock on the object and read the entire object from disk.
/// 			The lock is released after the read operation is completed.
/// 				No locks are acquired for a new object.
/// 			<b>%SaveData</B> will acquire an exclusive lock during the course of the save.
/// 			</TD>
/// 		</TR>
/// 		<TR>
/// 			<TD valign="top">3:</TD><TD CLASS=Term valign="top">Shared/Retained</TD>
/// 			<TD valign="top">
/// 			When an object is loaded, <b>%LoadData</B> will acquire a shared lock for the object.
/// 			The lock is released when the object is destructed (removed from memory).<br>
/// 				No locks are initially acquired for a new object.
/// 			<b>%SaveData</B> will acquire an exclusive lock during the course of the save.
/// 			<b>%SaveData</B> will also acquire a shared lock when saving a new object. This lock is retained
/// 				until the object is destructed (removed from memory).
/// 			</TD>
/// 		</TR>
/// 		<TR>
/// 			<TD valign="top">4:</TD><TD CLASS=Term valign="top">Exclusive</TD>
/// 			<TD valign="top">
/// 			When an object is loaded, <b>%LoadData</B> will acquire an exclusive lock for the object.
/// 			The lock is released when the object is destructed (removed from memory).<br>
/// 			<b>%SaveData</B> will acquire an exclusive lock when saving a new object. This lock is retained
/// 				until the object is destructed (removed from memory).
/// 		</TD>
/// 	</TR>
/// </table>
/// 	<p>The only difference between Shared (2) and Atomic Read (1) settings is that Shared concurrency
/// 	triggers a shared lock to always be acquired during read while Atomic Read will only acquire a
/// 	shared lock when required to ensure an atomic read.</p>
Property %Concurrency As %CacheString [ Final, InitialExpression = {$zu(115,10)}, Internal, Transient ];

Method %ConcurrencySet(val As %CacheString) As %Status [ Internal, Private ]
{
	Set i%%Concurrency=val
	Quit $$$OK
}

/// Deletes the stored version of the object with OID <var>oid</var> from the database. 
/// It does not remove any in-memory versions of the object that may be present.
/// 
/// Refer to <LINK href=/AboutConcurrency.html>About Concurrency</LINK> for more details 
/// on the optional <var>concurrency</var> argument.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
/// 
/// <p>Internally, <METHOD>%Delete</METHOD> initiates a transaction and then invokes the storage 
/// interface method <METHOD>%DeleteData</METHOD>. If <METHOD>%DeleteData</METHOD> succeeds, the 
/// transaction is committed, otherwise it is rolled back. 
ClassMethod %Delete(oid As %ObjectIdentity = "", concurrency As %Integer = -1) As %Status [ CodeMode = generator, Final, GenerateAfter = (%OnDelete, %OnJournalObject), ServerOnly = 0 ]
{
	s %code=0
	Set connection=$$$comMemberKeyGet(%class,$$$cCLASSparameter,"CONNECTION",$$$cPARAMdefault)
	$$$comMemberKeyGetLvar(objectjournal,%class,$$$cCLASSparameter,"OBJJOURNAL",$$$cPARAMdefault)
	$$$comMemberKeyGetLvar(tDSTIME,%class,$$$cCLASSparameter,"DSTIME",$$$cPARAMdefault)
	if ($$$ucase(tDSTIME) = "AUTO") {
		$$$comMemberKeyGetLvar(tDSINTERVAL,%class,$$$cCLASSparameter,"DSINTERVAL",$$$cPARAMdefault)
		if tDSINTERVAL '> 0 { set tDSTIME = 1 } else { set tDSTIME = 2 }
	}
	else { set tDSTIME = 0 }
		#; 'filter' will be true if object journal filtering is true. If so, then the object being deleted must be instantiated and $$$txJournalObjectDelete called instead of $$$txJournalDelete
	$$$comMemberKeyGetLvar(filter,%class,$$$cCLASSmethod,"%OnJournalObject",$$$cMETHrunnable)
	Set storageclass = ""
	if objectjournal + tDSTIME {
		$$$comClassKeyGetLvar(storagename,%class,$$$cCLASSstoragestrategy)
		If storagename '= "" $$$comMemberKeyGetLvar(storageclass,%class,$$$cCLASSstorage,storagename,$$$cSDEFtype)
		if storageclass = "%Library.CacheSQLStorage" { set tDSTIME = 0 }
	}
		#; Build a list of existent dependent items, such as streams (for now, that is all...)...
	Set property = $$$comMemberNext(%class,$$$cCLASSproperty,"")
	While property '= "" {
		if $$$comMemberKeyGet(%class,$$$cCLASSproperty,property,$$$cPROPrelationship) {
			$$$comMemberKeyGetLvar(cardinality,%class,$$$cCLASSproperty,property,$$$cPROPcardinality)
			if (cardinality = $$$cPROPCARDINALITYCHILDREN) || (cardinality = $$$cPROPCARDINALITYMANY) { set ondelete(property)=$lb($$$comMemberKeyGet(%class,$$$cCLASSproperty,property,$$$cPROPtype),$$$comMemberKeyGet(%class,$$$cCLASSproperty,property,$$$cPROPinverse)) }
		} Else {
			If $$$comMemberKeyGet(%class,$$$cCLASSproperty,property,$$$cPROPstorable) {
				$$$comMemberKeyGetLvar(proptype,%class,$$$cCLASSproperty,property,$$$cPROPtype)
				Set propclasstype = $$$getClassType(proptype)
				$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,property,$$$cPROPcollection)
				If propclasstype = $$$cCLASSCLASSTYPESTREAM { if connection = "" { Set stream(property) = collection, stream(property,1) = $$$QN(proptype) } }
				ElseIf (propclasstype = $$$cCLASSCLASSTYPESERIAL) && ($$$comMemberKeyGet(proptype,$$$cCLASSmethod,"%Delete",$$$cMETHrunnable)) { Set serial(property) = collection, serial(property,1) = $$$QN(proptype) }
			}
		}
		Set property = $$$comMemberNext(%class,$$$cCLASSproperty,property)
	}
		#; Generate the method...
	$$$GENERATE("	Quit:oid="""" $$$ERROR($$$NullOid,$classname()) Set id=$$$oidPrimary(oid) Quit:id="""" $$$ERROR($$$NullId,$classname()) set traninit=0")
	$$$GENERATE("	set $ZTRAP=""%DeleteERR""")
	$$$GENERATE("	If concurrency = -1 Set concurrency="_%parameter("DEFAULTCONCURRENCY"))
	$$$GENERATE("	If (concurrency > 4) || (concurrency < 0) || (concurrency '= (concurrency\1)) Quit $$$ERROR($$$ConcurrencyValueInvalid)")
		#; get class name
	$$$GENERATE("	Set class=$$$oidClassName(oid)")
		#; if class name is not present in oid, we must call the class method %OnDetermineClass
	$$$GENERATE("	If class="""" { Set sc=..%OnDetermineClass(oid,.class) Quit:$$$ISERR(sc) sc Set oid=$$$oidInsertClassName(oid,class) } Else { Set class=$$$NormalizeClassname(class) }")
		#; See if we are the correct class. If not, dispatch polymorphically to correct %Delete()
	$$$GENERATE("	If $classname()'=class Quit $classmethod(class,""%Delete"",oid,concurrency)")
	#; If TP is turned on start a transaction...
	If 'objectjournal {	$$$GENERATE("	If $$$txNOTINTRAN { Set traninit=1 $$$txBeginTran }") }
	Else {	$$$GENERATE("	If $$$txNOTINTRAN { Set traninit=1 $$$txBeginTranJrn }") }
	#; ##BEGINEVENT: DELETEDATA
	#; TODO: INSERT EVENT PROCESSING HERE
		#; find out if there is a %OnDelete method. If there is, call it
	If $$$comMemberKeyGet(%class,$$$cCLASSmethod,"%OnDelete",$$$cMETHrunnable) {
		$$$GENERATE("	Set sc=..%OnDelete(oid) g:$$$ISERR(sc) %DeleteEnd")
	}
		#; Generate relationship referential actions
	Set relationship = $Order(ondelete(""))
	While relationship '= "" {
		Set rclass=$li(ondelete(relationship)),rinverse=$li(ondelete(relationship),2),rclass=$$$QN(rclass)
		$$$GENERATE("	Set sc=##class("_rclass_")."_$$$QN(rinverse_"OnDelete")_"(id,concurrency) Goto:$$$ISERR(sc) %DeleteEnd" )
		Set relationship = $Order(ondelete(relationship))
	}
	$$$comMemberKeyGetLvar(guid,%class,$$$cCLASSparameter,"GUIDENABLED",$$$cPARAMdefault)
	If guid { $$$GENERATE("	Set guid = $get(^OBJ.GUID(1,oid))") }
		#; Check for actions that require swizzling. If any, swizzle and then perform the actions
	If ($Data(serial)) || ($Data(stream)) || (((filter) || (objectjournal = 2)) && (storageclass '= "%Library.CacheSQLStorage")) {
			#; Open the object being deleted:
		$$$GENERATE("	Set oref=..%Open(oid,concurrency) If oref=$$$NULLOREF Set sc=$$$ERROR($$$DeleteObjectNotFound,$classname(),$$$oidPrimary(oid)) Goto %DeleteEnd")
			#; Delete streams
		If $data(stream) {
			Set property = $Order(stream(""))
			While property '= "" {
				Set qproperty=$$$QN(property)
				if stream(property) = "" { $$$GENERATE("	Set stream=oref."_qproperty_"GetObject() If stream'="""" set ^||%isc.strd($i(^||%isc.strd))=$lb(stream,"_stream(property,1)_")") }
				ElseIf stream(property) = $$$cPROPCOLLECTIONLIST { $$$GENERATE("	Set key="""" For ptr=1:1 Set value=oref."_qproperty_".GetObjectNext(.key) Quit:key=""""  i value'="""" set ^||%isc.strd($i(^||%isc.strd))=$lb(value,"_stream(property,1)_")")
				} ElseIf stream(property) = $$$cPROPCOLLECTIONARRAY { $$$GENERATE("	Set key="""" For  Set value=oref."_qproperty_".GetObjectNext(.key) Quit:key=""""  i value'="""" set ^||%isc.strd($i(^||%isc.strd))=$lb(value,"_stream(property,1)_")") }
				Set property = $Order(stream(property))
			}
		}
		If $Data(serial) {
			Set property = $Order(serial(""))
			While property '= "" {
				Set qproperty=$$$QN(property)
				If serial(property) = "" { $$$GENERATE("	Set sc = ##class("_serial(property,1)_").%Delete(oref."_qproperty_"GetObject(0),concurrency) Goto:$$$ISERR(sc) %DeleteEnd") }
				ElseIf serial(property) = $$$cPROPCOLLECTIONLIST { $$$GENERATE("	Set key="""" For ptr=1:1 Set value=oref."_qproperty_".GetObjectNext(.key) Quit:key=""""  Set sc = ##class("_serial(property,1)_").%Delete(value,concurrency) Goto:$$$ISERR(sc) %DeleteEnd") }
				ElseIf serial(property) = $$$cPROPCOLLECTIONARRAY { $$$GENERATE("	Set key="""" For  Set value=oref."_qproperty_".GetObjectNext(.key) Quit:key=""""  Set sc = ##class("_serial(property,1)_").%Delete(value,concurrency) Goto:$$$ISERR(sc) %DeleteEnd") }
				Set property = $Order(serial(property))
			}
		}
			#; Journal the delete if journaling turned on and it isn't already journalled by SQL trigger:
		If (objectjournal) && (storageclass '= "%Library.CacheSQLStorage") {
			if objectjournal < 3 { $$$GENERATE("	$$$txJournalObjectDelete($classname(),jid,id," _ $Select('guid:"""""",1:"guid") _ ",oref,iJrnPtr)") }
			else { $$$GENERATE("	$$$txJournal($classname(),jid,id,2)") }
		}
		$$$GENERATE("	Set oref=$$$NULLOREF")
	}

		// This is where the old relationship referential action of NOACTION was generated!!

	$$$GENERATE("	$$$ActiveOidSearch(oid,oref) If $isobject(oref)=1 Do oref.%DeleteOID()")
	$$$GENERATE("	Set sc=..%DeleteData(id,concurrency)")
	If (objectjournal) && ('filter) && ( storageclass '= "%Library.CacheSQLStorage" ) {
		if objectjournal = 1 { $$$GENERATE("	If $$$ISOK(sc) { $$$txJournalDelete($classname(),jid,id," _ $Select('guid:"""""",1:"guid") _ ") }") }
		elseif objectjournal = 3 { $$$GENERATE("	If $$$ISOK(sc) { $$$txJournal($classname(),jid,id,2) }") }
	}
		#; find out if there is a %OnDelete method. If there is, call it
	If $$$comMemberKeyGet(%class,$$$cCLASSmethod,"%OnAfterDelete",$$$cMETHrunnable) { $$$GENERATE("	if $$$ISOK(sc) { set sc=..%OnAfterDelete(oid) }") }
		#; Generate the streams that were queued up before %DeleteData
	if $Data(stream) {
		$$$GENERATE($Char(9)_"if $$$ISOK(sc) {")
		$$$GENERATE($Char(9,9)_"set tPtr = """" For { set tPtr=$order(^||%isc.strd(tPtr),1,tStreamData) Quit:tPtr=""""  Set stream=$li(tStreamData,1),cls=$li(tStreamData,2),sc=$classmethod(cls,""%Delete"",stream,concurrency) If $$$ISERR(sc) Quit }")
		$$$GENERATE($Char(9,9)_"Kill ^||%isc.strd")
		$$$GENERATE($Char(9)_"}")
	}
	if tDSTIME = 1 { $$$GENERATE($Char(9)_"$$$DSTIME($classname(),id,2)") }
	elseif tDSTIME = 2 { $$$GENERATE($Char(9)_"$$$DSTIMEH($classname(),id,2,"_$Select(tDSINTERVAL:tDSINTERVAL,1:1)_",tDST,tDSS)") }
	#; ##ENDEVENT: DELETEDATA
	If objectjournal { $$$GENERATE("%DeleteEnd"_$select($Data(stream):" if $$$ISERR(sc) { kill ^||%isc.strd }",1:"")_" If traninit { If $$$ISOK(sc) { $$$txCommitJrn } Else { $$$txRollbackJrn(sc) } }") }
	Else { $$$GENERATE("%DeleteEnd"_$select($Data(stream):" if $$$ISERR(sc) { kill ^||%isc.strd }",1:"")_" If traninit { If $$$ISOK(sc) { $$$txCommit } Else { $$$txRollback(sc) } }") }
	$$$GENERATE("	Quit sc")
	$$$GENERATE("%DeleteERR	Set $ZTrap="""", sc=$$$ERROR($$$CacheError,$ZE) goto %DeleteEnd")
	QUIT $$$OK
}

/// Internal method to remove a previously assigned oid only to be used when deleting an object that is also in memory.
Method %DeleteOID() As %Status [ Internal, Private ]
{
	If ..%Concurrency>2 Set sc=..%ReleaseLock($select(..%Concurrency=3:"s",1:"e"))
	Set oid=i%"%%OID"
	$$$txUnAssignOIDSaveModState($this,oid) Do $system.CLS.SetModified(1) Set i%"%%OID"="" $$$ActiveOidRemove(oid,oref)
	Quit $$$OK
}

/// Deletes the stored version of the object with ID <var>id</var> from the database. 
/// 
/// <p><METHOD>%DeleteId</METHOD> is identical in operation to the <METHOD>%Delete</METHOD> method except 
/// that it uses an Id value instead of an OID value to find an object.
/// 
/// Refer to <LINK href=../docbook/AboutConcurrency.html>About Concurrency</LINK> for more details 
/// on the optional <var>concurrency</var> argument.
ClassMethod %DeleteId(id As %String, concurrency As %Integer = -1) As %Status [ CodeMode = expression, Final, ServerOnly = 0 ]
{
..%Delete($$$oidForm(id),.concurrency)
}

/// Delete all instances of this class from its extent. On exit <var>instancecount</var> 
/// contains the original number of instances while <var>deletecount</var> contains 
/// the number of instances actually deleted.
/// 
/// <p>Internally, <METHOD>%DeleteExtent</METHOD> iterates over the set of instances in the 
/// collection and invokes the <METHOD>%Delete</METHOD> method.
/// 
/// Refer to <LINK href=/AboutConcurrency.html>About Concurrency</LINK> for more details 
/// on the optional <var>concurrency</var> argument.
/// 
/// The option <var>pInitializeExtent</var> argument allows the user to override the default behavior
/// of calling <method>%KillExtent</method> when all instances are successfully deleted. <method>%KillExtent</method>
/// is called by default when the extent is empty so that empty globals can be killed. If <method>%KillExtent</method>
/// is not called then some empty globals can remain as well as the ID counter if it exists. The default value for <var>pInitializeExtent</var>
/// is 1. Unless the caller specifies a false value for <var>pInitializeExtent</var> the globals used by the extent will be killed. In some
/// cases, the globals used by the extent are not used exclusively by the extent. In those cases it is possible that some globals will still be defined
/// even when pInitializeExtent is true.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
ClassMethod %DeleteExtent(concurrency As %Integer = -1, ByRef deletecount, ByRef instancecount, pInitializeExtent As %Integer = 1, Output errorLog As %Status) As %Status [ ServerOnly = 0 ]
{
	Set deletecount=0,instancecount=0,errorLog = $$$OK
	If $system.CLS.IsMthd("ExtentExecute") {
		Set sc=..ExtentExecute(.qh) If $$$ISERR(sc) Quit sc
	} Else {
		Quit $$$OK
	}
	For  Set sc=..ExtentFetch(.qh,.row,.atend) Quit:$select(row="":1,$$$ISERR(sc):1,1:0)  Set id=$listget(row) If id'="" Set sc=..%Delete($listbuild(id),concurrency) Set instancecount=instancecount+1 set:$$$ISERR(sc) errorLog=$$$ADDSC(errorLog,sc) Set:$$$ISOK(sc) deletecount=deletecount+1 Quit:atend
	Do ..ExtentClose(qh)
	If instancecount = deletecount { if pInitializeExtent { do ..%KillExtent(0) } set sc = $$$OK } else { set sc = $$$ERROR($$$DeleteExtentObjectsRemain,$$$objClass) }
	Quit sc
}

/// Changes the concurrency level of an instance in memory to a lower level 
/// by changing the lock type specified in the <METHOD>%Open</METHOD> method for the object's 
/// instance. Fails if it cannot lower the concurrency level.
/// 
/// Refer to <LINK href=/AboutConcurrency.html>About Concurrency</LINK> for more details 
/// on the <var>concurrency</var> argument.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method %DowngradeConcurrency(concurrency As %Integer(MINVAL=0,MAXVAL=4) = 0) As %Status [ Final, Internal, ServerOnly = 0 ]
{
	If (concurrency > 4) || (concurrency < 0) || (concurrency '= (concurrency\1)) Quit $$$ERROR($$$ConcurrencyValueInvalid)
	Set current=..%Concurrency
	#; If the requested setting is greater or equal to the current setting, then do nothing
	If concurrency'<current Quit $$$OK
	#; Locks are not retained for any setting less than 3 and if the old and new
	#; setting are the same, nothing is to done except update the concurrency setting
	If current<3 Set modstate=$system.CLS.GetModifiedBits(),..%Concurrency=concurrency Do $system.CLS.SetModifiedBits(modstate) Quit $$$OK
	#; Get the new lock if needed
	If concurrency>2 Set sc=..%AcquireLock($select(concurrency=3:"s",1:"e")) Quit:$$$ISERR(sc) sc
	#; the following line releases the old lock which we know must be there
	#; because we process and quit above for current<3
	Do ..%ReleaseLock($select(current=3:"s",1:"e"))
	#; Update the concurrency setting:
	Set modstate=$system.CLS.GetModifiedBits(),..%Concurrency=concurrency Do $system.CLS.SetModifiedBits(modstate)
	Quit $$$OK
}

/// Returns a %Status value
ClassMethod %ExecuteBeforeTriggers(%oper, pOid As %Library.ObjectIdentity = "", ByRef pNew As %String(MAXLEN=""), ByRef pOld As %Library.Binary) As %Status [ CodeMode = generator, Internal, ServerOnly = 1 ]
{
	if ($$$comMemberNext(%class,$$$cCLASStrigger,"") '= "") && ($$$getClassType(%class) = $$$cCLASSCLASSTYPEPERSISTENT ) && ( '$$$comClassKeyGet(%class,$$$cCLASSnoextent) ) {
		$$$tMetadataUses("PrecompileTriggerCode^%occTrigger(%class)")
		merge %code = $$$tMetadata("c","%ExecuteBeforeTriggers")
	}
	quit $$$OK
}

/// Returns a %Status value
ClassMethod %ExecuteAfterTriggers(%oper, pOid As %Library.ObjectIdentity = "", ByRef pNew As %String(MAXLEN=""), ByRef pOld As %Library.Binary) As %Status [ CodeMode = generator, Internal, ServerOnly = 1 ]
{
	if ($$$comMemberNext(%class,$$$cCLASStrigger,"") '= "") && ($$$getClassType(%class) = $$$cCLASSCLASSTYPEPERSISTENT ) && ( '$$$comClassKeyGet(%class,$$$cCLASSnoextent) ) {
		$$$tMetadataUses("PrecompileTriggerCode^%occTrigger(%class)")
		merge %code = $$$tMetadata("c","%ExecuteAfterTriggers")
	}
	quit $$$OK
}

/// Returns the persistent object Id, if there is one, of this object. 
/// <p>Returns a null string if there is no object Id.
Method %Id() As %String [ CodeMode = expression, Final, ServerOnly = 0 ]
{
$$$idCurrent
}

/// Assigns a persistent object Id value for this object. 
/// This method fails if the object already has an Id value assigned to it.
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method %IdSet(id As %String) As %Status [ Final, Internal, Private, ServerOnly = 1 ]
{
 	Set class=$classname(),class=$$$DenormalizeClassname(class),oid=$$$oidCompose(id,class)
	#; Check for previously assigned OID
	If i%"%%OID"'="",i%"%%OID"'=oid Quit $$$ERROR($$$OidPreviouslyAssigned,$classname(),id)
	#; store oid and allow lookup based on oid
	Set i%"%%OID"=oid $$$ActiveOidInsert(oid,$this)
	Quit $$$OK
}

/*
 Returns the OID of this object. The force parameter determines additional actions.
 force = 0 - return the OID as is currently exists, nothing else.
         1 - perform a %Save(0) and return the OID
         2 - perform a %Save(1) and return the OID
*/
/// <METHOD>%GetSwizzleObject</METHOD> is used to obtain a state of the object that can 
/// later be used to restore the object. In the case of a persistent object, it returns the OID.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method %GetSwizzleObject(force As %Integer = 0, ByRef oid As %ObjectIdentity) As %Status [ Final, ServerOnly = 1 ]
{
	Set oid="" If force=0 Set oid=i%"%%OID" Quit $$$OK
	If force=2 Set sc=..%Save(1) Set:$$$ISOK(sc) oid=i%"%%OID" Quit sc
	Set oid=i%"%%OID" Quit:oid'="" $$$OK
	Set sc=..%Save(0) Set:$$$ISOK(sc) oid=i%"%%OID"
	Quit sc
}

/// Returns the OID of this object.
Method %Oid() As %ObjectIdentity [ CodeMode = expression, Final, ServerOnly = 0 ]
{
i%"%%OID"
}

/// %ComposeOid()
/// 
/// 		This class method accepts an ID and returns a fully qualified OID, containing the most specific type class of the object identified by the
/// 		<var>id</var> argument. If default storage is used then the %%CLASSNAME value is used to determine the most specific type class, otherwise call
/// 		%OnDetermineClass to determine the most specific type class. If neither case is true then the current class is
/// 		used. If there is a problem determining the most specific type class then null ("") is returned.
ClassMethod %ComposeOid(id As %String(MAXLEN="")) [ CodeMode = generator ]
{
	if ($$$getClassType(%class) '= $$$cCLASSCLASSTYPEPERSISTENT) || ($$$comClassKeyGet(%class,$$$cCLASSnoextent)) { kill %code quit $$$OK }
	set tRoot = $$$EXTrootclass($$$pEXT,%class), package = $$$ClassPackageName(%class), tCLASSNAMEGet = $Get($$$EXTPROPondisk($$$pEXT,%class,"%%CLASSNAME"))
	If tRoot && ($$$comClassKeyGet(%class,$$$cCLASSfinal)) { $$$GENERATE("	Quit $$$oidCompose(id,$classname())") Quit $$$OK }
	if tCLASSNAMEGet '= "" {
		If tRoot { Set tRootpackage = package,tRootclass = %class }
		Else {
			Set tRootclass = $$$EXTroot($$$pEXT,%class)
			While (tRootclass '= "") && ('$$$EXTrootclass($$$pEXT,tRootclass)) {
				Set tRootclass = $Get($$$EXTroot($$$pEXT,tRootclass))
			}
				If tRootclass '= "" { Set tRootpackage = $$$ClassPackageName(tRootclass) }
		}
		$$$GENERATE("	set tCLASSNAME = "_tCLASSNAMEGet)
		if tRoot {
			$$$GENERATE("	if tCLASSNAME="""" { quit $$$oidCompose(id,"""_tRootclass_""") }")
		} else {
			$$$GENERATE("	Set tClass=$classname(),tClass=$select(($extract(tClass,1,5)=""User."")&&($length(tClass,""."")=2):$piece(tClass,""."",2),1:tClass)")
			$$$GENERATE("	if tCLASSNAME'[($extract(tCLASSNAME)_tClass_$extract(tCLASSNAME)) Quit """"")
		}
		$$$GENERATE("	set tClass=$piece(tCLASSNAME,$extract(tCLASSNAME),*-1)")
		$$$GENERATE("	set:tClass'[""."" tClass=""User.""_tClass")
		$$$GENERATE("	quit $$$oidCompose(id,tClass)")
	} else {
		$$$GENERATE("	set tSC = ..%OnDetermineClass(id,.tClass)")
		$$$GENERATE("	quit $Select($$$ISOK(tSC):$$$oidCompose(id,tClass),1:"""")")
	}
	QUIT $$$OK
}

/// Loads an object from the database into memory and returns an OREF referring to the object. 
/// <var>oid</var> is the OID value of the object to load. If <var>oid</var> is a partially-formed OID, 
/// that is it does not include a class name, then <METHOD>%Open</METHOD> does the following: 
/// a) calls the method, <METHOD>%OnDetermineClass</METHOD>, 
/// to determine the class name, otherwise b) it assumes the class name is 
/// the same as the object class on which <METHOD>%Open</METHOD> was called.
/// <p>If a version of the specified object is already in memory, then <METHOD>%Open</METHOD> increments 
/// the object's reference count and returns the OREF value referring to this version.
/// <METHOD>%Open</METHOD> also has an optional concurrency argument which specifies the concurrency setting 
/// for this object (and sets the value of the <var>%Concurrency</var> attribute). If the 
/// <var>concurrency</var> argument is omitted then the system default value (1: <i>Atomic</i>) is used.
/// 
/// Refer to <LINK href=/AboutConcurrency.html>About Concurrency</LINK> for more details 
/// on the optional <var>concurrency</var> argument.
/// 
/// <p><METHOD>%Open</METHOD> returns an OREF value that refers to the in-memory object instance or 
/// a null reference ($$$NULLOREF) if it cannot find or otherwise load the object.
ClassMethod %Open(oid As %ObjectIdentity, concurrency As %Integer = -1, ByRef sc As %Status = {$$$OK}) As %ObjectHandle [ Final, ServerOnly = 0 ]
{
	#; if not passed an initial state, quit with error
	If $$$oidPrimary($g(oid))="" Set sc = $$$ERROR($$$NullOid,$classname()) Quit $$$NULLOREF
	If concurrency = -1 Set concurrency=$select(..#DEFAULTCONCURRENCY="$zu(115,10)":$zu(115,10),1:$xecute("Quit "_..#DEFAULTCONCURRENCY))
	If (concurrency > 4) || (concurrency < 0) || (concurrency '= (concurrency\1)) Set sc = $$$ERROR($$$ConcurrencyValueInvalid) Quit $$$NULLOREF
	Set $Ztrap = "Catch"
	Set class=$$$oidClassName(oid)
	#; if class name is not present in oid, we must call the class method %OnDetermineClass
	If class="" {
		Set sc=..%OnDetermineClass(oid,.class) If $$$ISERR(sc) Goto exit
		Set oid=$$$oidInsertClassName(oid,class)
	} Else {
		Set class=$$$NormalizeClassname(class)
	}
	#; see if we should reuse an existing object
	$$$ActiveOidSearch(oid,oref)
	If $isobject(oref)=1 { If concurrency>oref.%Concurrency { If (oref.%Concurrency<3) && (concurrency > 2) { Set reload = 1 } Else { Set reload = 0 } Set sc=oref.%UpgradeConcurrency(concurrency) If (reload) && ($$$ISOK(sc)) { Set sc=oref.%Reload() } If $$$ISERR(sc) { Quit $$$NULLOREF } } Else { Set sc = $$$OK } Quit oref }
	Set oref=$$$CreateObject(class) If oref=$$$NULLOREF Set sc = $$$ERROR($$$AbstractClassNotInstantiable,class) Quit oref
	Set sc=oref.%LoadInit(oid,concurrency) If $$$ISERR(sc) Quit $$$NULLOREF
	Set sc=oref.%LoadData($$$oidPrimary(oid)) If $$$ISERR(sc) Quit $$$NULLOREF
	#; set object as not modified
	Do $system.CLS.SetModified(oref,0)
	#; find out if there is a %OnOpen method. If there is a %OnOpen, call it
	If $system.CLS.IsMthd(oref,"%OnOpen") Set sc=oref.%OnOpen() If $$$ISERR(sc) Quit $$$NULLOREF
	Quit oref
Catch	Set $ZTrap = ""
	If '$$$ISOK($Get(sc)) { Quit $$$NULLOREF }
	Set sc = $Select($Extract($ZE,1,9)="<PROTECT>":$$$ERROR($$$InsufficientPrivilegeObjectAccess,$get(class,$classname())_"::%Open"),1:$$$ERROR($$$CacheError,$ZE))
exit	Quit $$$NULLOREF
}

/// Return true if pOID is a null object and false if the object is not null
ClassMethod %ObjectIsNull(pOID As %ObjectIdentity) As %Boolean
{
	If $isobject(pOID)=1 Set pOID=pOID."%%OID"
	if pOID = $$$NULLOID quit 1
	set class = $$$oidClassName(pOID)
	if class = "" { do ..%OnDetermineClass(pOID,.class) }
	if class '= "" {
		set class=$$$NormalizeClassname(class) if $classname()'=class quit $classmethod(class,"%ObjectIsNull",pOID)
	}
	quit $$$oidPrimary(pOID)=""
}

Method %LoadInit(oid As %ObjectIdentity = "", concurrency As %Integer = "", reset As %Boolean = 0) As %Status [ CodeMode = generator, Final, Internal, Private ]
{
	#; We should be somewhat stable now, set the %Concurrency attribute...
	$$$GENERATE("	If concurrency'="""" Set i%%Concurrency=concurrency")
	Set ivar="" For {
		Set ivar=$$$comMemberNext(%class,$$$cCLASSinstancevar,ivar) Quit:ivar=""
		Set qivar=$$$QN(ivar)
		If $$$comMemberKeyGet(%class,$$$cCLASSproperty,ivar,$$$cPROPmultidimensional) Set kill($i(kill))="i%"_$$$QN(ivar) Continue
		If $$$comMemberKeyGet(%class,$$$cCLASSproperty,ivar,$$$cPROPtransient),ivar'="%Concurrency",ivar'="%%OID" {
			Set set($i(set))="i%"_qivar_"="_$$$comMemberKeyGet(%class,$$$cCLASSinstancevar,ivar,$$$cIVARinitialexpression)
		}
		$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,ivar,$$$cPROPcollection)
		$$$comMemberKeyGetLvar(relationship,%class,$$$cCLASSproperty,ivar,$$$cPROPrelationship)
		If 'relationship,collection=$$$cPROPCOLLECTIONARRAY||(collection=$$$cPROPCOLLECTIONLIST) {
			Set kill($i(kill))="r%"_qivar,set($i(set))="i%"_qivar_"="""""
		}
		$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,ivar,$$$cPROPruntimetype) 
		If $$$classIsDataType(runtimetype) Continue
		Set kill($i(kill))="i%"_qivar,set($i(set))="r%"_qivar_"="""""
	}
	If $get(kill) {
		$$$GENERATE("	If reset {")
		Set kills=""
		For i=1:1:kill {
			Set kills=kills_kill(i)_","
			If i#10=0 $$$GENERATE("		Kill "_$extract(kills,1,*-1)) Set kills=""
		}
		If kills'="" $$$GENERATE("		Kill "_$extract(kills,1,*-1))
		$$$GENERATE("	}")
	}
	Set sets=""
	For i=1:1:$get(set) {
		Set sets=sets_set(i)_","
		If i#10=0 $$$GENERATE("	Set "_$extract(sets,1,*-1)) Set sets=""
	}
	If sets'="" $$$GENERATE("	Set "_$extract(sets,1,*-1))
	$$$GENERATE("	If 'reset { Set i%""%%OID""=oid If oid'="""" { $$$ActiveOidInsert(oid,$this) } }")
	$$$GENERATE("	Quit $$$OK")
	QUIT $$$OK
}

/// Loads an object from the database into memory and returns an OREF referring to the object. 
/// <var>id</var> is the Id (not a full OID) value of the object to load.
/// 
/// <p><METHOD>%OpenId</METHOD> is identical in operation to the <METHOD>%Open</METHOD> method except 
/// that it uses an Id value instead of an OID value to find an object instance.
/// 
/// Refer to <LINK href=/AboutConcurrency.html>About Concurrency</LINK> for more details 
/// on the optional <var>concurrency</var> argument.
/// 
/// <p><METHOD>%OpenId</METHOD> returns an OREF value that refers to the in-memory object instance or 
/// a null reference ($$$NULLOREF) if it cannot find or otherwise load the object.
ClassMethod %OpenId(id As %String = "", concurrency As %Integer = -1, ByRef sc As %Status = {$$$OK}) As %ObjectHandle [ CodeMode = expression, Final, ServerOnly = 0 ]
{
..%Open($$$oidForm(id),.concurrency,.sc)
}

/// <p>%Reload is an instance method that re-reads an object from disk into the 
/// current instance. Calling %Reload is similar to calling <METHOD>%Close</METHOD> and then 
/// <METHOD>%Open</METHOD>, but it uses the same OREF. %Open is not called and no %Open callbacks
/// are called.</p>
/// <p>After %Reload is called, there are no swizzled references for the object, 
/// and <METHOD>%IsModified</METHOD> returns 0.
/// </p>
/// <p>%Reload performs the following steps. First, all swizzled objects for the 
/// instance are unswizzled. Then the object is reloaded from disk, using the 
/// <METHOD>%Id</METHOD> of the current object. Finally, the modified bit for each property is 
/// cleared.
/// <p>
Method %Reload() As %Status [ ServerOnly = 0 ]
{
	If $$$idCurrent="" Quit $$$ERROR($$$NullOid,$classname())
	Set cur=..%Concurrency,i%%Concurrency=0
	Set sc=..%LoadInit(,,1) If $$$ISERR(sc) Quit sc
	Set sc=..%LoadData($$$idCurrent) Set i%%Concurrency=cur If $$$ISERR(sc) quit sc
	if $system.CLS.IsMthd($this,"%OnReload") Set sc=..%OnReload() If $$$ISERR(sc) quit sc
	#; set object as not modified
	Do $system.CLS.SetModified(0)
	Quit $$$OK
}

/*
 This method restores the modified information, from an array subscripted by oref, releases any owned locks and
 invokes a user-supplied method, %OnRollBack() if it exists.
*/
/// This method is called by <METHOD>%Save</METHOD> when a transaction is rolled back. 
/// It will invoke a user-supplied <METHOD>%OnRollBack</METHOD> method if it exists.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method %RollBack() As %Status [ ServerOnly = 1 ]
{
	If $data($$$txOIDASSIGNED(+$this)) Set oid=i%"%%OID" If oid'="" $$$ActiveOidRemove(oid,$this) Set i%"%%OID"=""
	If $data($$$txOIDUNASSIGNED(+$this),oid) If oid'="" Set i%"%%OID"=oid $$$ActiveOidInsert(oid,$this)
	If $data($$$txMODIFIED($this)) Do $system.CLS.SetModifiedBits($$$txMODIFIED($this))
	#; if a %OnRollBack() method exists, return with it's value......
	If $system.CLS.IsMthd("%OnRollBack") Quit ..%OnRollBack()
	QUIT $$$OK
}

/// Stores an in-memory version of an object to disk. If the object was stored 
/// previously (and thus, already has an OID), <METHOD>%Save</METHOD> updates the on-disk version. 
/// Otherwise, <METHOD>%Save</METHOD> assigns a new OID to the object and saves it.
/// 
/// <p>The <var>related</var> argument specifies how <METHOD>%Save</METHOD> handles references to other objects. 
/// It can take the following values:
/// <table cols=2>
/// <tr>
/// <td width="33%" valign="top">0: <i>Shallow Save</i></td>
/// <td valign="top">
/// If this object has been modified then save it. Only save related objects if they have never been saved (do not have an OID value) and must be 
/// saved in order to serialize this object's property values.
/// </td>
/// </tr>
/// 
/// <tr>
/// <td width="33%" valign="top">1: <i>Deep Save</i></td>
/// <td valign="top">
/// Save this object and all "related" objects that have been edited. In this case, 
/// "related" means any in-memory objects it refers to, and any in-memory objects 
/// they in turn refer to, and so on. However, only objects that have been changed 
/// (<METHOD>%IsModified</METHOD> returns true) will actually be saved to the database, including 
/// the object upon which <METHOD>%Save</METHOD> was initially called.
/// </td>
/// </tr>
/// </table>
/// 
/// <p><METHOD>%Save</METHOD> automatically detects and handles circular references between objects. 
/// For example, <METHOD>%Save</METHOD> will detect if object A refers to object B and object B likewise refers to object A.
/// In this case it will avoid falling into an infinite, recursive loop.
/// 
/// <p>Note that either reference attribute, A to B or B to A, can be specified as a required attribute but not both of them.
/// If both reference attributes are required then <METHOD>%Save</METHOD> will fail.
/// 
/// <p>By default <METHOD>%Save</METHOD> automatically manages transactions. You can enable and disable 
/// automatic transaction support using the <code>$$SetTransactionMode^%apiOBJ()</code> routine.
/// 
/// <p>When <METHOD>%Save</METHOD> saves an object to the database, it initiates one transaction 
/// (by calling TSTART) for the entire set of saves, including the original object 
/// and any related objects. If the save operation is successful, <METHOD>%Save</METHOD> will issue a 
/// TCOMMIT command to commit the transaction and write the data to the database.
/// If <METHOD>%Save</METHOD> encounters a problem when saving the original object or any of its 
/// related objects, it rolls back the entire transaction and performs the following actions:
/// <ul>
/// <li>It issues a TROLLBACK command to rollback any changes to the database that may 
/// have occurred. (In the case of the <CLASS>%CacheStorage</CLASS> class, changes to the on-disk 
/// counter value, used to determine the next available object id number, are not rolled back.)</li>
/// <li>It restores the in-memory state of all the objects involved in the transaction to 
/// their pre-transaction state. This includes restoring any modified flags, and 
/// restoring to null ("") any OID values that have been assigned during the course of 
/// the transaction. Additional property values changed during the course of the 
/// transaction are not restored, however.</li>
/// <li>It calls the <METHOD>%RollBack</METHOD> method on each object involved with the transaction. 
/// The order in which the <METHOD>%RollBack</METHOD> methods are called is undefined. <METHOD>%RollBack</METHOD> will 
/// call a user-written <METHOD>%OnRollback</METHOD> method if it is present.</li>
/// </ul>
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method %Save(related As %Integer = 1) As %Status [ CodeMode = generator, Final, GenerateAfter = (%OnBeforeSave, %OnAfterSave), ServerOnly = 0 ]
{
	Set %code=0
	If $$$getClassType(%class)'=$$$cCLASSCLASSTYPEPERSISTENT Quit $$$OK
	$$$comMemberKeyGetLvar(objectjournal,%class,$$$cCLASSparameter,"OBJJOURNAL",$$$cPARAMdefault)
	$$$comMemberKeyGetLvar(tDSTIME,%class,$$$cCLASSparameter,"DSTIME",$$$cPARAMdefault)
	if ($$$ucase(tDSTIME) = "AUTO") {
		$$$comMemberKeyGetLvar(tDSINTERVAL,%class,$$$cCLASSparameter,"DSINTERVAL",$$$cPARAMdefault)
		if tDSINTERVAL '> 0 { set tDSTIME = 1 } else { set tDSTIME = 2 }
	}
	else { set tDSTIME = 0 }
	#; Look to see if we need to construct a save set
	If ($$$comMemberKeyGet(%class,$$$cCLASSmethod,"%OnAddToSaveSet",$$$cMETHrunnable)) || (objectjournal) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"GUIDENABLED",$$$cPARAMdefault) {
		Set simple=0
	} Else {
		#; Look to see this this is a 'literal' object with no references to other objects
		Set prop = $$$comMemberNext(%class,$$$cCLASSproperty,""), simple = 1
		While prop '= "" {
			$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,prop,$$$cPROPruntimetype)
				#; do nothing if property is a datatype or isn't storable
			If ($$$getClassType(runtimetype) '= $$$cCLASSCLASSTYPEDATATYPE) && ('$$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcalculated)) && ('$$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPmultidimensional)) Set simple=0 Quit
			Set prop = $$$comMemberNext(%class,$$$cCLASSproperty,prop)
		}
	}
		#; Initialize the transaction state
		#; This method is a transaction itself and isn't called recursively. Therefore, the
		#; SaveSet state variable - %objTX - is new'ed here.
	$$$GENERATE("	Set $ZTrap=""%SaveERR""")
	$$$GENERATE("	New %objTX Set sc=$$$OK,traninit=0 If '$data(%objTX2) New %objTX2 Set %objTX2=1")
		#; If already in %Save, just build a shallow graph and serialize the object
		#; %TStart - Start a transaction if one doesn't exist and $zu(115,9) is on
		#; %TInclude - include this oref in the current transaction...
	$$$GENERATE("	If $$$txNOTINTRAN { Set traninit=1 $$$txBeginTran"_$select(objectjournal:"Jrn",1:"")_" }")
	If simple {
		Set runtimeclasstype=$$$getClassType(%class)
		#; If we call %OnBeforeSave/%OnAfterSave we need part of save set created if we are also persistent
		set onAfter = $$$comMemberKeyGet(%class,$$$cCLASSmethod,"%OnAfterSave",$$$cMETHrunnable), onBefore = $$$comMemberKeyGet(%class,$$$cCLASSmethod,"%OnBeforeSave",$$$cMETHrunnable), tTriggered = 0
		if (runtimeclasstype=$$$cCLASSCLASSTYPEPERSISTENT) && '(onAfter + onBefore) {
			set prop = $$$comMemberNext(%class,$$$cCLASSproperty,"")
			While prop '= "" {
				if $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPsqlcomputed) {
					if $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPsqlcomputeonchange) [ "%%" { set tTriggered = 1 quit }
				}
				Set prop = $$$comMemberNext(%class,$$$cCLASSproperty,prop)
			}
		}
		if (onBefore) || (onAfter) || (tTriggered) || (tDSTIME) {
			If runtimeclasstype=$$$cCLASSCLASSTYPEPERSISTENT {
				$$$GENERATE("	Set %objTX(1,+$this,1)=i%""%%OID"",%objTX(1,+$this)=$this,%objTX(1,+$this,4)=$select(%objTX(1,+$this,1)="""":1,..%ExistsId($$$oidPrimary(%objTX(1,+$this,1))):0,1:1)")
			}
		}
		If runtimeclasstype=$$$cCLASSCLASSTYPEPERSISTENT {
			$$$GENERATE("	If ..%ObjectModified() Set sc=..%SerializeObject(i%""%%OID"") If $$$ISERR(sc) $$$txRemoveObject($this) ZTrap ""SG""")
		} ElseIf runtimeclasstype=$$$cCLASSCLASSTYPESERIAL {
			$$$GENERATE("	If ..%ObjectModified() Set sc=..%SerializeObject("""") If $$$ISERR(sc) $$$txRemoveObject($this) ZTrap ""SG""")
		} Else {
			$$$GENERATE("	Set sc=..%SerializeObject("""") If $$$ISERR(sc) $$$txRemoveObject($this) ZTrap ""SG""")
		}
	} Else {
		$$$GENERATE("	If $get(%objTX2(+$this)) Set sc=..%BuildObjectGraph(1) Quit:$$$ISERR(sc) sc Set intRef=+$this,objValue=$get(%objTX(1,intRef,1)),sc=..%SerializeObject(.objValue,1) Set:$$$ISOK(sc) %objTX(1,intRef,1)=objValue Quit sc")
		$$$GENERATE("	Set sc=..%BuildObjectGraph(related+2) If $$$ISERR(sc) ZTrap ""SG""")
			#; At this point, %objTX(2) contains a list of all objects that need to be saved
		$$$GENERATE("	If '$data(%objTX(2)) s sc=$$$OK GoTo %SaveCOMMIT")
			#; First, examine the objects designated to be saved to see if any have zero predecessors
		$$$GENERATE("	Set %objTX(3)=0,intRef="""" For  Set intRef=$order(%objTX(2,intRef)) Quit:intRef=""""  If '$data(%objTX(1,intRef,2)) Set %objTX(3,$increment(%objTX(3)))=%objTX(1,intRef) Kill %objTX(2,intRef)")
			#; Process the AOV. Calls to %SerializeObject here are complete serializations. If one fails, the TX needs to fail
		$$$GENERATE("	For ptr=1:1 Quit:ptr>%objTX(3)  Set objRef=%objTX(3,ptr),objValue=$get(%objTX(1,+objRef,1)),sc=objRef.%SerializeObject(.objValue) Do  Set %objTX(1,+objRef,1)=objValue Kill %objTX(1,+objRef,3) Do $system.CLS.SetModified(objRef,0)")
		$$$GENERATE("	. If $$$ISERR(sc) $$$txRemoveObject(objRef) ZTrap ""SG""")
			#; Process the mod bits for potential tx rollback
		$$$GENERATE("	. $$$txSaveModState(objRef)")
			#; visit the successors
		$$$GENERATE("	. Set intSucc="""" For  Set intSucc=$order(%objTX(1,+objRef,3,intSucc)) Quit:intSucc=""""  Kill %objTX(1,+objRef,3,intSucc),%objTX(1,intSucc,2,+objRef) If '$data(%objTX(1,intSucc,2)) Set %objTX(3,$increment(%objTX(3)))=%objTX(1,intSucc) Kill %objTX(2,intSucc)")
			#; If any objects are remaining in the graph then do a 'partial serialization' of the persistent objects that are
			#; designated as 'predecessors'. Any objects remaining in the graph following partial serialization represent unresolvable cycles. 
		$$$GENERATE("	Kill %objTX(3) Set %objTX(3)=0 For  Set pserial=0 Do  Quit:'pserial")
		$$$GENERATE("	. Set intRef="""" For  Set intRef=$order(%objTX(2,intRef)) Quit:intRef=""""  Set intPred="""" For  Set intPred=$order(%objTX(1,intRef,2,intPred)) Quit:intPred=""""  If $get(%objTX(1,intPred,6))=1 Set objValue=$get(%objTX(1,intPred,1)),sc=(%objTX(1,intPred)).%SerializeObject(.objValue,1) s:$$$ISERR(sc) %objTX(2,intPred,1)=sc If $$$ISOK(sc) Set pserial=1,%objTX(1,intPred,1)=objValue Do")
			#; Visit the successors of this 'forced' ID assignment. If all predecessors are visited then add to the stack
		$$$GENERATE("	. . Set intSucc="""" For  Set intSucc=$order(%objTX(1,intPred,3,intSucc)) Quit:intSucc=""""  Kill %objTX(1,intPred,3,intSucc),%objTX(1,intSucc,2,intPred) If '$data(%objTX(1,intSucc,2)) Set %objTX(3,$i(%objTX(3)))=%objTX(1,intSucc) Kill %objTX(2,intSucc)")
			#; Again, process the AOV. Calls to %SerializeObject here are complete serializations. If one fails, the TX needs to fail
		$$$GENERATE("	. . For ptr=1:1 Quit:ptr>%objTX(3)  Set objSerialize=%objTX(3,ptr),objValue=$get(%objTX(1,+objSerialize,1)),sc=objSerialize.%SerializeObject(.objValue) Do  Set %objTX(1,+objSerialize,1)=objValue Kill %objTX(1,+objSerialize,3) Do $system.CLS.SetModified(objSerialize,0)")
		$$$GENERATE("	. . . If $$$ISERR(sc) $$$txRemoveObject(objSerialize) ZTrap ""SG""")
			#; Process the mod bits for potential tx rollback
		$$$GENERATE("	. . . $$$txSaveModState(objSerialize)")
			#; visit the successors
		$$$GENERATE("	. . . Set intSucc="""" For  Set intSucc=$order(%objTX(1,+objSerialize,3,intSucc)) Quit:intSucc=""""  Kill %objTX(1,+objSerialize,3,intSucc),%objTX(1,intSucc,2,+objSerialize) If '$data(%objTX(1,intSucc,2)) Set %objTX(3,$i(%objTX(3)))=%objTX(1,intSucc) Kill %objTX(2,intSucc)")
		$$$GENERATE("	. . Kill %objTX(3) Set %objTX(3)=0")

		$$$GENERATE("	If $data(%objTX(2))>2 {")
		$$$GENERATE("		Set sc=$$$ERROR($$$SaveCyclicDependancy,$classname())")
		$$$GENERATE("		set intRef="""" for  set intRef=$order(%objTX(2,intRef)) quit:intRef=""""  if $$$ISERR($Get(%objTX(2,intRef,1),1)) set sc=$$$EMBEDSC(sc,%objTX(2,intRef,1))")
		$$$GENERATE("	 	ZTrap ""SG""")
		$$$GENERATE("	}")
	}
	$$$GENERATE("	Set cmd="""" For  Set cmd=$order(%objTX(9,cmd)) Quit:cmd=""""  Xecute cmd")
		#; Commit the transaction and cleanup
	$$$GENERATE("%SaveCOMMIT	If traninit { $$$txCommit"_$select(objectjournal:"Jrn",1:"")_" }")
	$$$GENERATE("	Do $system.CLS.SetModified(0) Quit sc")
	$$$GENERATE("%SaveERR	Set $ZTrap="""" If $extract($zerror,1,5)'=""<ZSG>"" Set sc=$$$ERROR($$$CacheError,$ZE)")
	$$$GENERATE($Char(9)_"If $get(traninit) { $$$txRollback"_$select(objectjournal:"Jrn",1:"")_"(sc) }")
	$$$GENERATE("	Quit sc")
	QUIT $$$OK
}

/// Elevates the concurrency level of an instance in memory to a higher level 
/// by changing the lock type specified in the <METHOD>%Open</METHOD> method for the object's 
/// instance. Fails if it cannot elevate the concurrency level.
/// 
/// Refer to <LINK href=/AboutConcurrency.html>About Concurrency</LINK> for more details 
/// on the <var>concurrency</var> argument.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method %UpgradeConcurrency(concurrency As %Integer(MINVAL=0,MAXVAL=4) = 0) As %Status [ Final, Internal, ServerOnly = 0 ]
{
	If (concurrency > 4) || (concurrency < 0) || (concurrency '= (concurrency\1)) Quit $$$ERROR($$$ConcurrencyValueInvalid)
	#; Locks are not retained for any setting
	#; less than 3 and if the old and new
	#; setting are the same, nothing is to done!
	Set current=..%Concurrency
	Quit:concurrency'>current $$$OK
	If concurrency<3 Set modstate=$system.CLS.GetModifiedBits(),..%Concurrency=concurrency Do $system.CLS.SetModifiedBits(modstate) Quit $$$OK
	#; Get the new lock
	Set sc=..%AcquireLock($select(concurrency=3:"s",1:"e")) Quit:$$$ISERR(sc) sc
	#; the following line releases the old lock
	#; which must be a shared lock as that is the
	#; only possible condition.
	If current=3 Do ..%ReleaseLock("s")
	#; Update the concurrency setting:
	Set modstate=$system.CLS.GetModifiedBits(),..%Concurrency=concurrency Do $system.CLS.SetModifiedBits(modstate)
	Quit $$$OK
}

/// Acquires a lock for the current instance.
/// 
/// <p>The <var>locktype</var> argument specifies the type of lock to acquire.
/// It can take the following values:
/// <table cols=2>
/// <tr>
/// <td width="33%" valign="top">"e": <i>Exclusive</i></td>
/// <td valign="top">
/// An exclusive lock will prevent any other process from acquiring any type of lock
/// on this object.
/// </td>
/// </tr>
/// 
/// <tr>
/// <td width="33%" valign="top">"s": <i>Shared</i></td>
/// <td valign="top">
/// A shared lock will allow other processes to acquire shared locks but will
/// prevent other processes from acquiring an exclusive lock.
/// </td>
/// </tr>
/// </table>
/// 
/// Fails if the locktype parameter is not one of the values described above.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method %AcquireLock(locktype As %String = "") As %Status [ CodeMode = expression, Private, ServerOnly = 1 ]
{
..%LockId($$$idCurrent,$s($e(locktype)="s":1,1:0))
}

/// Releases a lock for the current instance.
/// 
/// <p>The <var>locktype</var> argument specifies the type of lock to release.
/// It can take the following values:
/// <table cols=2>
/// <tr>
/// <td width="33%" valign="top">"e": <i>Exclusive</i></td>
/// <td valign="top">
/// An exclusive lock will prevent any other process from acquiring any type of lock
/// on this object.
/// </td>
/// </tr>
/// 
/// <tr>
/// <td width="33%" valign="top">"s": <i>Shared</i></td>
/// <td valign="top">
/// A shared lock will allow other processes to acquire shared locks but will
/// prevent other processes from acquiring an exclusive lock.
/// </td>
/// </tr>
/// </table>
/// 
/// Fails if the locktype parameter is not one of the values described above.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method %ReleaseLock(locktype As %String = "") As %Status [ CodeMode = expression, Private, ServerOnly = 1 ]
{
..%UnlockId($$$idCurrent,$s($e(locktype)="s":1,1:0),$s($e(locktype,2)="i":1,1:0))
}

/// %LockExtent acquires a lock on the entire extent of the class. If <var>shared</var> is true then a shared lock
/// is acquired, otherwise an exclusive lock is acquired. If the requested lock cannot be acquired then a failure
/// %Status value is returned. The default implementation returns an error indicating that the method is not implemented.
/// This method is automatically generated for persistent classes using <class>%Library.CacheStorage</class> and
/// <class>%Library.CacheSQLStorage</class>.
ClassMethod %LockExtent(shared As %Boolean = 0) As %Status [ PlaceAfter = %LockId, ServerOnly = 1 ]
{
	QUIT $$$ERROR($$$MethodNotImplemented,"%Persistent::%LockExtent")
}

/// %UnlockExtent releases a lock on the entire extent of the class. If <var>shared</var> is true then a shared lock
/// is acquired, otherwise an exclusive lock is acquired. If the requested lock cannot be acquired then a failure
/// %Status value is returned. The default implementation returns an error indicating that the method is not implemented.
/// This method is automatically generated for persistent classes using <class>%Library.CacheStorage</class> and
/// <class>%Library.CacheSQLStorage</class>.
ClassMethod %UnlockExtent(shared As %Boolean = 0, immediate As %Boolean = 0) As %Status [ PlaceAfter = %LockExtent, ServerOnly = 1 ]
{
	QUIT $$$ERROR($$$MethodNotImplemented,"%Persistent::%UnlockExtent")
}

/// Obtain an exclusive or shared lock on the object identified by <var>id</var>. The type
/// of lock obtained is determined by <var>shared</var>. This method is normally generated by
/// the storage class for persistent classes using <class>%Library.CacheStorage</class> or <class>%Library.CacheSQLStorage</class>.
ClassMethod %LockId(id As %String, shared As %Boolean = 0, timeout As %Integer) As %Status [ ServerOnly = 1 ]
{
	Set sc=..%OnDetermineClass($$$oidForm(id),.class) If $$$ISERR(sc) Quit sc
	If class'="",class'=$classname() Quit $classmethod(class,"%LockId",id,shared,.timeout)
	QUIT $$$ERROR($$$MethodNotImplemented,$classname()_"::%LockId")
}

/// Release an exclusive or shared lock on the object identified by <var>id</var>. The type
/// of lock released is determined by <var>shared</var>. If this method is not overridden
/// then the default implementation returns an error. This method is normally generated by
/// the storage class for persistent classes using <class>%Library.CacheStorage</class> or <class>%Library.CacheSQLStorage</class>.
ClassMethod %UnlockId(id As %String, shared As %Boolean = 0, immediate As %Boolean = 0) As %Status [ ServerOnly = 1 ]
{
	Set sc=..%OnDetermineClass($$$oidForm(id),.class) If $$$ISERR(sc) Quit sc
	If class'="",class'=$classname() Quit $classmethod(class,"%UnlockId",id,shared)
	QUIT $$$ERROR($$$MethodNotImplemented,$classname()_"::%UnlockId")
}

/// This method acquires a lock on the object identified by 'id'. If the number of locks
/// already taken out for this extent is greater than the configured maximum then the lock
/// will be escalated to an extent-level lock. If the lock is successfully obtained a 1 will
/// be returned, 2 will be returned if the lock was escalated to an extent-level lock. A zero, '0',
/// is returned if the method failed to obtain a lock.
ClassMethod %GetLock(id As %String, shared As %Boolean = 0) As %Integer [ ServerOnly = 1 ]
{
	Set sc=..%OnDetermineClass($$$oidForm(id),.class) If $$$ISERR(sc) Quit 0
	If class'="",class'=$classname() Quit $classmethod(class,"%GetLock",id,shared)
	If $tlevel,$increment(%0CacheLock($classname()))>$zutil(115,6) { If $$$ISOK(..%LockExtent(shared)) { Quit 2 } Else { Quit 0 } } Quit:$$$ISOK(..%LockId(id,shared)) 1
	Quit 0
}

/// <p>Builds entries for each index specified in the <var>idxlist</var> argument.
/// If <var>pIndexList</var> is empty then all indices that originate in the class are rebuilt. If no indexes 
/// are specified in <var>pIndexList</var> or there are other bitmap indexes specified in <var>pIndexList</var> 
/// and there is a bitmap extent index defined for the class and there are currently no entries in the bitmap extent index 
/// then it will be implicitly included in <var>pIndexList</var>. If there is an ID range specified in
/// <var>pStartID</var>-<var>pEndID</var> and there are either no indexes specified in <var>pIndexList</var>
/// or if indexes are specified then at least one of them is a bitmap index
/// then the bitmap extent index will be implicitly included in <var>pIndexList</var>. If the bitmap 
/// extent index is included then the bitmap extent index for each subextent is also built. </p>
/// 
/// <p>If <var>pAutoPurge</var> is true then the indices contained in <var>pIndexList</var> will be
/// purged before they are built as long as no range is specified, if a range is specified we will
/// skip any purge. The default is TRUE (1).</p>
/// 
/// <p>If <var>pLockFlag</var> is one (1) then an extent lock will be acquired before the indices
/// are built. If the lock cannot be acquired then an error is returned. The lock is released
/// after the index build is completed. If it is two (2) then a lock is acquired prior to filing 
/// indexes for that instance and it is released as soon the indexes for that instance are filed. 
/// If it is zero (0) then no locks are used while filing the indexes. If it is three (3) then it
/// an shared extent lock will be acquired before the indices are build.</p>
/// 
/// <p>If <var>pJournalFlag</var> is false then journaling is disabled for the processes used to build the 
/// indexes. If this flag is true then the journal status is not altered during BuildIndices(). 
/// The default value of this argument is 1 (TRUE). </p> 
/// 
/// <p><var>pStartID</var> and <var>pEndID</var> define a range of IDs for which indexes will be built. 
/// The range is inclusive. If the starting ID is not passed a non-null value then the range begins at the 
/// first ID defined in the extent. If the ending ID is not passed a non-null value then the range ends at the 
/// last ID defined in the extent. </p>
/// 
/// <p>If <var>pIgnoreIndexList</var> is defined, it should be a $listbuild of index names that should not be built.
/// This argument allows you to build all indices except those defined in <var>pIgnoreIndexList</var>.
/// The default value of this argument is "", which means all indices, or all indices specified in <var>pIndexList</var>, will be built. </p> 
/// 
/// <p>If <method>%OnBeforeBuildIndices</method> is implemented and is runnable then it will be called
/// just prior to purging and building any index structures. Refer to <method>%OnBeforeBuildIndices</method>
/// for more information.</p>
/// 
/// <p>If <method>%OnAfterBuildIndices</method> is implemented and is runnable then it will be called
/// after all index structures have been built completely. Refer to <method>%OnAfterBuildIndices</method>
/// for more information.</p>
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
/// This method is normally generated by the storage class for persistent classes using
/// <class>%Library.CacheStorage</class> or <class>%Library.CacheSQLStorage</class>.</p>
/// 
/// <p>If your index is corrupt running this function will not fix the corruption unless you rebuild the entire index
/// and purge the existing indexes. If you have inserted some new items but have deferred building the index for these
/// new items then you can run %BuildIndices on this range oif IDs to add the index entries for these new items.</p>
ClassMethod %BuildIndices(pIndexList As %CacheString = "", pAutoPurge As %Integer = 1, pLockFlag As %Integer = 0, pJournalFlag As %Integer = 1, pStartID As %CacheString = "", pEndID As %CacheString = "", pIgnoreIndexList As %CacheString = "") As %Status [ ProcedureBlock = 1, ServerOnly = 0 ]
{
	QUIT $$$ERROR($$$MethodNotImplemented,"%Persistent::%BuildIndices")
}

/// On return, <var>bmeName</var> contains the name of the bitmap extent index for this class.
/// <p>Returns <CLASS>%Boolean</CLASS> TRUE is the bitmap extent has been built, FALSE if not.
ClassMethod %BMEBuilt(ByRef bmeName As %String) As %Boolean [ CodeMode = expression, Internal, ServerOnly = 1 ]
{
1
}

/// <p>
/// This method will loop over each object in the extent of the current class and invoke <method>%CheckConstraints</method>. 
/// If only selected constraints are to be checked then <var>pConstraintList</var> can be passed as a $list of the 
/// names of the constraints to be checked. All constraint failures are included in the returned %Status value, subject 
/// to the maximum <class>%Status</class> size. In addition, the output parameter <var>pErrorLog</var> contains up to 1,000 entries 
/// containing the object ID and the values of all properties that are referenced by constraints defined for the current class. 
/// The error log also adds the %Status value returned by %CheckConstraints() as the last $list element.
/// </p>
/// <p>
/// <pre>
/// SAMPLES>set status = ##class(Sample.Person).%CheckConstraintsForExtent(,,.errorlog)
/// 
/// SAMPLES>do $system.OBJ.DisplayError(status)                                       
/// 
/// ERROR #5808: Key not unique: Sample.Person.SSNKey
/// ERROR #5808: Key not unique: Sample.Person.SSNKey
/// SAMPLES>zw errorlog
/// errorlog=2
/// errorlog(1)=$lb(1,"798-92-1974","0 "_$lb($lb(5808,"Sample.Person.SSNKey",,,,,,,,"%CheckConstraints+7^Sample.Person.1:SAMPLES"))/* ERROR #5808: Key not unique: Sample.Person.SSNKey [%CheckConstraints+7^Sample.Person.1:SAMPLES] */)
/// errorlog(2)=$lb(100,"798-92-1974","0 "_$lb($lb(5808,"Sample.Person.SSNKey",,,,,,,,"%CheckConstraints+7^Sample.Person.1:SAMPLES"))/* ERROR #5808: Key not unique: Sample.Person.SSNKey [%CheckConstraints+7^Sample.Person.1:SAMPLES] */)
/// </pre>
/// </p>
/// <p>
/// <table border=1>
/// 	<tr>
/// 		<th colspan=3>
/// 			Parameters
/// 		</th>
/// 	</tr>
/// 	<tr>
/// 		<th>Name</th>
/// 		<th>Direction</th>
/// 		<th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>pConstraintList</td>
/// 		<td>Input</td>
/// 		<td>A $list of constraints to be checked. If null then all constraints defined for the most specific type class 
/// 			of each object will be checked. 
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>pCheckDisabled</td>
/// 		<td>Input</td>
/// 		<td>If this value is passed as a true value (1) then %CheckConstraints will also check any constraints that are 
/// 			defined as %NOCHECK. 
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>pErrorLog</td>
/// 		<td>Output</td>
/// 		<td>
/// 			This is an array of up to 1,000 entries containing error information reported by <method>%CheckConstraints</method>.
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>Return</td>
/// 		<td>
/// 			%Status return value. This value contains %Status values for each constraint that failed. If no errors are 
/// 			reported then %Status will be $$$OK. 
/// 		</td>
/// 	</tr>
/// </table>
/// </p>
ClassMethod %CheckConstraintsForExtent(pConstraintList As %String(MAXLEN="") = "", pCheckDisabled As %Integer = 0, Output pErrorLog As %String(MAXLEN="")) As %Status [ CodeMode = generator, ServerOnly = 1 ]
{
	try {
		kill %code
		if ($$$getClassType(%class) = $$$cCLASSCLASSTYPEPERSISTENT) && ('$$$comClassKeyGet(%class,$$$cCLASSnoextent)) {
			do generateCheckExtent^%occConstraint(%class,.%code)
		}
		set tStatus = $$$OK
	}
	catch tException {
		set tStatus = tException.AsStatus()
	}
	QUIT tStatus
}

/// <p>
/// This method checks the constraints defined in the current class for one object, identified by <var>pID</var>. 
/// If only selected constraints are to be checked then <var>pConstraintList</var> can be passed as a $list of the 
/// names of the constraints to be checked. If any constraint fails then the failure status will be included in the 
/// returned %Status value. In addition, the output parameter <var>pErrorInfo</var> will contain the object ID and 
/// the values of all properties that are referenced by constraints defined for the current class. 
/// </p>
/// <p>
/// If the current class is not the most specific type class (MSTC) of the object identified by <var>pID</var>, then this method 
/// will dispatch to the object's most specific type class. Note that if you do not pass a constraint list then all 
/// constraints present for the MSTC are checked, which may include others in addition to those present for the current class. 
/// </p>
/// <p>
/// <pre>
/// SAMPLES>set status = ##class(Sample.Person).%CheckConstraints(1,,,.errorinfo)
/// 
/// SAMPLES>do $system.OBJ.DisplayError(status)                                 
/// 
/// ERROR #5808: Key not unique: Sample.Person.SSNKey
/// SAMPLES>zw errorinfo                                                        
/// errorinfo=$lb(1,"798-92-1974")
/// </pre>
/// </p>
/// <p>
/// <table border=1>
/// 	<tr>
/// 		<th colspan=3>
/// 			Parameters
/// 		</th>
/// 	</tr>
/// 	<tr>
/// 		<th>Name</th>
/// 		<th>Direction</th>
/// 		<th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>pID</td>
/// 		<td>Input</td>
/// 		<td>The ID of the object to be checked.</td>
/// 	</tr>
/// 	<tr>
/// 		<td>pConstraintList</td>
/// 		<td>Input</td>
/// 		<td>A $list of constraints to be checked. If null then all constraints defined for this class will be checked. 
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>pCheckDisabled</td>
/// 		<td>Input</td>
/// 		<td>If this value is passed as a true value (1) then %CheckConstraints will also check any constraints that are 
/// 			defined as %NOCHECK. 
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>pErrorInfo</td>
/// 		<td>Output</td>
/// 		<td>
/// 			If an error is reported then <var>pErrorInfo</var> will contain the object's ID and all property values 
/// 			that are referenced by constraints defined for this class. 
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>Return</td>
/// 		<td>
/// 			%Status return value. This value contains %Status values for each constraint that failed. If no errors are 
/// 			reported then %Status will be $$$OK. 
/// 		</td>
/// 	</tr>
/// </table>
/// </p>
ClassMethod %CheckConstraints(pID As %String(MAXLEN=""), pConstraintList As %List = "", pCheckDisabled As %Integer = 0, Output pErrorInfo As %List) As %Status [ CodeMode = generator, ServerOnly = 1 ]
{
	try {
		kill %code
		if ($$$getClassType(%class) = $$$cCLASSCLASSTYPEPERSISTENT) && ('$$$comClassKeyGet(%class,$$$cCLASSnoextent)) {
			do generateCheckConstraints^%occConstraint(%class,.%code)
		}
		set tStatus = $$$OK
	}
	catch tException {
		set tStatus = tException.AsStatus()
	}
	QUIT tStatus
}

/// Checks to see if the object identified by the OID <var>oid</var> exists in the extent.
/// 
/// <p>Returns <CLASS>%Boolean</CLASS> TRUE if it exists, FALSE if it does not.
ClassMethod %Exists(oid As %ObjectIdentity) As %Boolean [ CodeMode = generator, ServerOnly = 0 ]
{
	If $$$getClassType(%class) '= $$$cCLASSCLASSTYPEPERSISTENT {
		$$$GENERATE("	Set classname = $$$oidClassName(oid) If classname="""" Quit 0")
		$$$GENERATE("	Set $ZTrap = ""CatchExistsError""")
		$$$GENERATE("	If classname '= $classname() Quit $classmethod(classname,""%Exists"",oid)")
		$$$GENERATE("	Quit $isobject(..%Open(oid,0))=1")
		$$$GENERATE("CatchExistsError	Set $ZTrap = """"")
		$$$GENERATE("	Quit 0")
	} Else {
		Set %codemode=$$$cMETHCODEMODEEXPRESSION
		Set %code="$isobject(..%Open(oid,0))=1"
	}
	Quit $$$OK
}

/// Checks to see if the object identified by the ID <var>id</var> exists in the extent.
/// 
/// <p>Returns <CLASS>%Boolean</CLASS> TRUE is it exists, FALSE if it does not.
ClassMethod %ExistsId(id As %String) As %Boolean [ ServerOnly = 0 ]
{
	Quit ..%Exists($listbuild(id))
}

/// %1Check()
/// 	This is a method that corresponds the the '%1' key (a convention introduced in the SQL filer).
/// 	The '%1' key is a synonym for the %Id() value. The general description of &lt;candidatekey&gt;Check()
/// 
/// &lt;key&gt;Check()
/// 	This method checks for the existence of the key and locks the object associated with that key.
/// 		The lock is released but will be retained for the duration of the transaction.
/// 
/// 	The optional lockonly parameter is used by callers wishing only to validate the key. If lockonly is true
/// 		then success is returned if the key does not exists. If the key exists then an attempt is made to
/// 		lock the corresponding object. That status from the lock call is then returned.
/// 
/// 		If lockonly is false then an error is returned if the key does not exist. If the key does exist then
/// 		the corresponding object is locked and released. If the lock cannot be acquired then an error is returned.
/// 		Otherwise the key is checked for existence again and an error is returned if it doesn't exist.
ClassMethod %1Check(id As %String = "", lockonly As %Boolean = 0, concurrency As %Integer = -1) As %Status [ Internal, ServerOnly = 1 ]
{
	Set exists=..%ExistsId(id)
	Quit:'exists $select('lockonly:$$$ERROR($$$KeyNotFound,$classname(),id),1:$$$OK)
	set:concurrency=-1 concurrency=$select(..#DEFAULTCONCURRENCY="$zu(115,10)":$zu(115,10),1:$xecute("q "_..#DEFAULTCONCURRENCY))
	if concurrency { set status=..%LockId(id,1) Quit:$$$ISERR(status) status }
	If 'lockonly { set exists=..%ExistsId(id) if concurrency { do ..%UnlockId(id,1,0) } Quit $select('exists:$$$ERROR($$$KeyNotFound,$classname(),id),1:$$$OK)}
	if concurrency Do ..%UnlockId(id,1,0)
	Quit $$$OK
}

/// Files each index for the object identified by <var>id</var>. <var>pIndexHandle</var> is for internal use only.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
/// This method is normally generated by the storage class for persistent classes using
/// <class>%Library.CacheStorage</class> or <class>%Library.CacheSQLStorage</class>.
ClassMethod %FileIndices(id As %String(MAXLEN=""), ByRef pIndexHandle As %Binary) As %Status [ Internal, ServerOnly = 1 ]
{
	QUIT $$$ERROR($$$MethodNotImplemented,"%Persistent::%FileIndices")
}

/// This method returns the GUID assigned to &lt;oid&gt;. This method is only runnable if the GUIDENABLED parameter is TRUE.
/// This method will dispatch polymorphically and will determine the most-specific-type class if the oid does not contain that information.
/// If pDeepSearch is true and no GUID is found for the object then a deep search of the GUID registry will be performed, starting with the
/// current class. This is useful if the most specific type class cannot be determined, such as in the case of an object that has been deleted.
ClassMethod %GUID(oid As %ObjectIdentity, pDeepSearch As %Integer = 0) As %String [ ServerOnly = 1 ]
{
	If $$$oidPrimary($Get(oid)) = "" Quit ""
	#; Optimize for the full-oid,no polymorphic case:
	If $classname()=$$$oidClassName(oid) Quit $Get(^OBJ.GUID(1,oid))
	Set class=$$$oidClassName(oid)
	#; if class name is not present in oid, we must call the class method %OnDetermineClass
	If class="" { Set sc=..%OnDetermineClass(oid,.class) if $$$ISOK(sc) { set oid=$$$oidInsertClassName(oid,class) } elseif pDeepSearch { quit ##class(%Library.GUID).%FindGUID($classname(),$$$oidPrimary(oid)) } else { quit "" } } Else { set class=$$$NormalizeClassname(class) }
	#; See if we are the correct class. If not, dispatch polymorphically to correct %GUID()
	If $classname()'=class Quit $classmethod(class,"%GUID",oid,pDeepSearch)
	If 'pDeepSearch { Quit $Get(^OBJ.GUID(1,oid)) } else { set tGUID = $Get(^OBJ.GUID(1,oid)) if tGUID'="" { quit tGUID } else { quit ##class(%Library.GUID).%FindGUID($classname(),$$$oidPrimary(oid)) } }
}

ClassMethod %GUIDSet(oid As %ObjectIdentity, guid As %String = "") As %String [ ServerOnly = 1 ]
{
	If '..#GUIDENABLED Quit ""
	If $$$oidPrimary($Get(oid)) = "" Quit ""
	#; Optimize for the full-oid,no polymorphic case:
	If ($classname()=$$$oidClassName(oid)) && ($Data(^OBJ.GUID(1,oid),guid)) Quit guid
	Set class=$$$oidClassName(oid)
	#; if class name is not present in oid, we must call the class method %OnDetermineClass
	If class="" { Set sc=..%OnDetermineClass(oid,.class) Quit:$$$ISERR(sc) "" Set oid=$$$oidInsertClassName(oid,class) } Else { Set class=$$$NormalizeClassname(class) }
	#; See if we are the correct class. If not, dispatch polymorphically to correct %GUID()
	If $classname()'=class Quit $classmethod(class,"%GUIDSet",oid,guid)
	#; If guid already assigned to this oid just return it
	If $Data(^OBJ.GUID(1,oid),guid) Quit guid
	If ($Get(guid) = "") { Set guid = $System.Util.CreateGUID()}
	If '$Data(^OBJ.GUID(0,guid)) { Set ^OBJ.GUID(0,guid)=oid,^OBJ.GUID(1,oid)=guid } Else { Set guid = "" }
	Quit guid
}

/// %KillExtent performs a physical kill of the extent. No constraints are enforced. This method should not be
/// used in place of %DeleteExtent. Only physical storage occupied by this extent will be killed. If this extent
/// is a subextent of another class then no data is killed. Indexes that originate with this extent will be killed.
/// %KillExtent will be called on any subextents and on any child extents (the extent of the type class of a
/// relationship whose cardinality = children is a 'child' extent) of this extent.
/// 
/// This method is not meant for production applications. It is meant to be a development utility to quickly clear
/// extent physical data. Also this will not remove stream data associated with these instances.
ClassMethod %KillExtent(pDirect As %Integer = 1) As %Status [ CodeMode = generator, ServerOnly = 0 ]
{
	if $$$comMemberKeyGet(%class,$$$cCLASSparameter,"READONLY",$$$cPARAMdefault) $$$GENERATE(" QUIT $$$ERROR($$$ClassIsReadOnly,$classname())") QUIT $$$OK
		#; 1. Invoke %KillExtent in all child extents.
	set tProperty = $$$comMemberNext(%class,$$$cCLASSproperty,"")
	while tProperty '= "" {
		if ($$$comMemberKeyGet(%class,$$$cCLASSproperty,tProperty,$$$cPROPrelationship)) && ($$$comMemberKeyGet(%class,$$$cCLASSproperty,tProperty,$$$cPROPcardinality) = $$$cPROPCARDINALITYCHILDREN) {
			set tChildType = $$$comMemberKeyGet(%class,$$$cCLASSproperty,tProperty,$$$cPROPtype)
				// Only invoke %KillExtent on the child if the CHILDREN relationship originates in this class
				// or this class is the root class of the concrete extent.
			if ($$$getClassType(tChildType) = $$$cCLASSCLASSTYPEPERSISTENT) && (($Get($$$EXTrootclass($$$pEXT,%class))) || ($$$comMemberKeyGet(%class,$$$cCLASSproperty,tProperty,$$$cXXXXorigin) = %class)) { $$$GENERATE($Char(9)_"if ($$$comMemberKeyGet("""_tChildType_""",$$$cCLASSmethod,""%KillExtent"",$$$cMETHrunnable)) && ($Data(^rOBJ($$$nameClassRoutineNameGet("""_tChildType_""",0)))) { set sc=##class("_tChildType_").%KillExtent() }") }
		}
		set tProperty = $$$comMemberNext(%class,$$$cCLASSproperty,tProperty)
	}
		#; 2. Invoke %KillExtent in all subextents. While this doesn't delete any data it does delete the indices
	$$$GENERATE("	set subextent=$order($$$EXTSUBEXTENT($$$pEXT,$classname(),"""")) While subextent'="""" { if ($$$comMemberKeyGet(subextent,$$$cCLASSmethod,""%KillExtent"",$$$cMETHrunnable)) && ($Data(^rOBJ($$$nameClassRoutineNameGet(subextent,0)))) { Set sc=$classmethod(subextent,""%KillExtent"") If $$$ISERR(sc) { Goto Exit } } Set subextent=$order($$$EXTSUBEXTENT($$$pEXT,$classname(),subextent)) }")
		#; 3. Delete all indices originating in this class
	$$$GENERATE("	set sc=..%PurgeIndices()")
		#; 4. Invoke the storage method, %KillExtentData
	$$$GENERATE("	If $$$ISOK(sc) { Set sc=..%KillExtentData() }")
		// if DSTIME is auto then kill the DSTIME index for this class
	$$$comMemberKeyGetLvar(tDSTIME,%class,$$$cCLASSparameter,"DSTIME",$$$cPARAMdefault)
	if ($$$ucase(tDSTIME) = "AUTO") || ($$$ucase(tDSTIME) = "TIME") {
		$$$GENERATE($Char(9)_"if pDirect { kill ^OBJ.DSTIME($classname()) }")
	}
	$$$GENERATE("Exit	Quit sc")
	QUIT $$$OK
}

/// Files the indices for all objects whose ID is in the range defined by <var>pStartId</var> and <var>pEndId</var>.
/// If <var>pEndId</var> is null then it defaults to <var>pStartId</var>. If <var>pStartId</var> is null then the
/// range is empty and no filing will occur.
/// 
/// If <var>lockExtent</var> is true then an extent lock will be acquired before the indices
/// are built. If the lock cannot be acquired then an error is returned. The lock is released
/// after the index filing is completed.
/// 
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
ClassMethod %SaveIndices(pStartId As %String(MAXLEN="") = "", pEndId As %String(MAXLEN="") = "", lockExtent As %Boolean = 0) As %Status [ Internal, ServerOnly = 0 ]
{
	QUIT $$$ERROR($$$MethodNotImplemented,"%Persistent::%SaveIndices")
}

ClassMethod %AddJrnObjToSyncSet(objSS As %SYNC.SyncSet, fileop As %Integer = 0, oid As %ObjectIdentity, ByRef object As %String, changed As %List = "", guid As %String = "", originSystem As %String = "", originNS As %String = "") As %Integer [ Internal, ServerOnly = 1 ]
{
	If '..#OBJJOURNAL Quit ""
	Set objRef = ..%LoadFromMemory($$$oidPrimary(oid),.object)
	If $isobject(objRef)=0 { set objRef = ..%Open(oid) }
	Quit $Select($isobject(objRef)=1:..%AddToSyncSet(objSS, objRef, fileop, oid, changed, guid, originSystem, originNS),1:"")
}

/// Internal helper method for <method>%BuildIndicies</method>
ClassMethod %BuildIndexInternal(pLockFlag, pAutoPurge, pStartID, pEndID, pIndexList, pBuildFlags, pGLVN, pBMEIndexPtr, pJournalFlag, pCompositeKey) As %Status [ Internal, Private ]
{
	Set sc=$$$OK,class=$classname()
	Try {
		If pLockFlag=1||(pLockFlag=3) {
			$$$THROWONERROR(sc,..%LockExtent($s(pLockFlag=1:0,1:1)))
			Set tLocked=1
		}
		If $system.CLS.IsMthd("%OnBeforeBuildIndices") {
			$$$THROWONERROR(sc,..%OnBeforeBuildIndices(.pIndexList))
			if ($listlength(pIndexList)=1)&&($listget(pIndexList,1)="") {
				If $Get(tLocked) {
					Do ..%UnlockExtent($s(pLockFlag=1:0,1:1))
				}
				RETURN $$$OK
			}
		}
		If pAutoPurge,pStartID="",pEndID="" {
			Set sc=..%PurgeIndices(.pIndexList)
			If $$$ISERR(sc) Goto exit
		}
		If pBMEIndexPtr,$ascii($get(pBuildFlags(class)),pBMEIndexPtr)=2 Set $extract(pBuildFlags(class),pBMEIndexPtr)=$c('..%BMEBuilt())
		
		Set splits=$system.Util.NumberOfCPUs()
		If splits>$get(^%SYS("Compiler","MaxIndexWorkers"),12) Set splits=$get(^%SYS("Compiler","MaxIndexWorkers"),12)
		Set oldsubnode=pStartID,split=""
		If splits>1 {
			Set splitlist=$$SplitSize^%GSIZE(pGLVN,"N",splits,$select(pCompositeKey:$piece(pStartID,"||"),1:pStartID),$select(pCompositeKey:$piece(pEndID,"||"),1:pEndID))
			Set status=$listget(splitlist,1)
			If status=1 {
				Set split=$listget(splitlist,2)
				#; If the split point is also the start point remove it to avoid potential issue where same node is processed twice
				If pStartID'="",$listget(split)=pStartID Set split=$list(split,2,*)
			}
		}
		Set numbersplits=$listlength(split)+1
		Set queue = $SYSTEM.WorkMgr.Initialize("/multicompile=1/journal="_pJournalFlag,.sc,numbersplits)
		If $$$ISERR(sc) Goto exit
		Kill ^CacheTempIndexBuild($job)
		Set ptr=0
		While $listnext(split,ptr,subnode) {
			Set sc=queue.Queue("##class("_class_").%BuildIndicesSegment",oldsubnode,subnode,.pBuildFlags,pLockFlag,$select(pStartID'=""&&(oldsubnode=pStartID):1,1:0),$job)
			If $$$ISERR(sc) Goto exit
			Set oldsubnode=subnode
		}
		#; Queue the last range
		Set sc=queue.Queue("##class("_class_").%BuildIndicesSegment",oldsubnode,pEndID,.pBuildFlags,pLockFlag,$select(pStartID'=""&&(oldsubnode=pStartID):1,1:0),$job)		
		If $$$ISOK(sc) Set sc=queue.WaitForComplete()
		If $$$ISERR(sc) Goto exit
		
			// Cascade the BME build to subextents
		If pBMEIndexPtr,$Ascii(pBuildFlags(class),pBMEIndexPtr) {
			Set subextent=""
			For {
				Set subextent=$o($$$EXTSUBEXTENT($$$pEXT,class,subextent))
				Quit:subextent=""
				Set tSubBuilt=$classmethod(subextent,"%BMEBuilt",.subbme)
				If pStartID="",pEndID="",'tSubBuilt {
					Set sc=$classmethod(subextent,"%BuildIndices",$listbuild(subbme),pAutoPurge,pLockFlag,pJournalFlag,.pStartID,.pEndID)
					If $$$ISERR(sc) Goto exit
				}
			}
		}

		If $system.CLS.IsMthd("%OnAfterBuildIndices") {
			Set sc=..%OnAfterBuildIndices(.pIndexList)
			If $$$ISERR(sc) Goto exit
		}
	} Catch tException {
		Set sc=tException.AsStatus()
	}
exit	If $Get(tLocked) {
		Do ..%UnlockExtent($s(pLockFlag=1:0,1:1))
	}
	Set i=""
	For {
		Set i=$order(^CacheTempIndexBuild($job,i),1,val) Quit:i=""
		If val'=0 Do $system.Event.Delete($name(^CacheTempIndexBuild($job,i)))
	}
	Kill ^CacheTempIndexBuild($job)
	Quit sc
}

/// This method is normally generated by the storage class for persistent classes using
/// <class>%Library.CacheStorage</class> or <class>%Library.CacheSQLStorage</class>. Persistent
/// classes using some other storage class, such as <class>%Library.CustomStorage</class> must override this
/// method.
ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	QUIT $$$ERROR($$$MethodNotImplemented,"%Persistent::%DeleteData")
}

/// %KillExtentData() - kills extent data in storage. This method is
/// implemented by the storage class.
ClassMethod %KillExtentData() As %Status [ Private, ServerOnly = 1 ]
{
	QUIT $$$ERROR($$$MethodNotImplemented,"%Persistent::%KillExtentData")
}

/// %LoadData() - loads an object from storage. This method is
/// implemented by the storage class.
Method %LoadData(id As %String) As %Status [ Private, ServerOnly = 1 ]
{
	QUIT $$$ERROR($$$MethodNotImplemented,"%Persistent::%LoadData")
}

/// <p>Deletes all entries from each index specified in the <var>idxlist</var> argument.
/// If <var>idxlist</var> is empty then all indices that originate
/// in the class are purged. The index definition remains intact.</p>
/// 
/// <p>If <var>pIgnoreIndexList</var> is defined, it should be a $listbuild of index names that should not be purged.
/// This argument allows you to purge all indices except those defined in <var>pIgnoreIndexList</var>.
/// The default value of this argument is "", which means all indices, or all indices specified in <var>pIndexList</var>, will be purged. </p> 
/// 
/// <p>If <method>%OnBeforePurgeIndices</method> is implemented and is runnable then it will be called
/// just after acquiring the extent lock, if one is requested, and just prior to performing the
/// the purge. If <method>%OnBeforePurgeIndices</method> returns an error status
/// then %PurgeIndices will exit immediately, no indices will be purged and that error status
/// will be returned to the caller of %PurgeIndices.</p>
/// 
/// <p>If <method>%OnAfterPurgeIndices</method> is implemented and is runnable then it will be called
/// just prior to releasing the extent lock, if one is requested. All index structures have been purged
/// prior to calling <method>%OnAfterPurgeIndices</method>. If <method>%OnAfterPurgeIndices</method> returns
/// and error status then that status will be returned to the caller of %PurgeIndices but all structures will
/// still have been purged.
/// </p>
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
/// This method is normally generated by the storage class for persistent classes using
/// <class>%Library.CacheStorage</class> or <class>%Library.CacheSQLStorage</class>. Persistent
/// classes using some other storage class, such as <class>%Library.CustomStorage</class> must override this
/// method.</p>
ClassMethod %PurgeIndices(idxlist As %List = "", lockExtent As %Boolean = 0, pIgnoreIndexList As %CacheString = "") As %Status [ ServerOnly = 1 ]
{
	QUIT $$$ERROR($$$MethodNotImplemented,"%Persistent::%PurgeIndices")
}

/// %SaveData() - saves an object to disk, checks uniqueness and referential
/// integrity constraints, and maintains index structures. This method is
/// implemented by the storage class.
Method %SaveData(id As %String) As %Status [ Private, ServerOnly = 1 ]
{
	QUIT $$$ERROR($$$MethodNotImplemented,"%Persistent::%SaveData")
}

/// %SaveDirect() - saves an object to disk, checks uniqueness and referential
/// integrity constraints, and maintains index structures. The state of the object
/// is passed to this method in three arguments.
/// <var>id</var> contains the ID value if the object has been previously saved.
/// <var>idList</var> is a $list value containing the IDKEY components. If the class is a child
/// class (contains a relationship with CARDINALITY = PARENT) then the first value in the list is the parent reference.
/// If the ID is system assigned the next value (or only value if the class is not a child class) is the system assigned ID value.
/// If the ID is based on a user-defined IDKEY then there is a $list element corresponding to each property in the same order as
/// defined in the IDKEY index.
/// <br>
/// <var>data</var> is a structure that mirrors the disk structure of the object. The root value (unsubscripted) contains the properties stored in the
/// data node from the storage definition with a null subscript. Additional entries in the <var>data</var> structure correspond to any additional data nodes
/// defined in the storage definition.
/// <br>
/// This method is not commonly called directly.
/// <br>
/// This method is implemented by the storage class.
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
ClassMethod %SaveDirect(ByRef id As %String = "", idList As %List = "", ByRef data As %Binary, concurrency As %Integer = -1) As %Status [ ServerOnly = 1 ]
{
	QUIT $$$ERROR($$$MethodNotImplemented,"%Persistent::%SaveDirect")
}

/// Executes a $SortBegin for the base global reference of each index specified in the <var>idxlist</var> argument.
/// If <var>idxlist</var> is empty then a $SortBegin is executed for all indices that originate
/// in the class.
/// 
/// <p>The <var>excludeunique</var> argument, if TRUE, causes any index defined as UNIQUE or PRIMARY KEY to be ignored.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
ClassMethod %SortBegin(idxlist As %List = "", excludeunique As %Integer = 0) As %Status [ CodeMode = expression, ServerOnly = 1 ]
{
$$$OK
}

/// Executes a $SortEnd for the base global reference of each index specified in the <var>idxlist</var> argument.
/// If <var>idxlist</var> is empty then a $SortBegin is executed for all indices that originate
/// in the class.
/// 
/// <p>The <var>commit</var> argument, if FALSE, causes the data to be discarded. Otherwise, all data placed in
/// the global since the $SortBegin is committed.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
ClassMethod %SortEnd(idxlist As %List = "", commit As %Integer = 1) As %Status [ CodeMode = expression, ServerOnly = 1 ]
{
$$$OK
}

/// <p>This is a system provided query that returns a row for each instance within this extent. The first column of the row is the
/// object ID. Additional columns can be included in the select list by adding the desired columns to the <parameter>EXTENTQUERYSPEC</parameter> parameter.</p>
/// <p>
/// The Extent query default implementation is generated by <class>%Library.ExtentSQLQuery</class>. That class
/// supports the <var>COMPILEMODE</var> parameter with possible values of IMMEDIATE and DYNAMIC. If DYNAMIC is specified
/// then the SQL statement used to implement the query will be generated as a dynamic SQL statement. If IMMEDIATE is specified
/// then the statement is generated as an embedded SQL statement.</p>
/// <br><p>This query can be overridden by a subclass so long as two requirements are met. The list of columns must include %ID as the first column and
/// it must return a row corresponding to each instance/row in the extent.</p>
Query Extent() As %ExtentSQLQuery(CONTAINID = 1) [ SqlProc ]
{
}

/// <p>
/// This callback method is invoked by the <METHOD>%BuildIndices</METHOD> method. 
/// </p>
/// <p>
/// It is called prior to modifying any index structures. If an extent lock is requested by the 
/// %BuildIndices caller then %OnBeforeBuildIndices is called after the extent lock is acquired. 
/// <P>If this method returns an error then %BuildIndices will exit immediately without 
/// purging and building any index structures, returning the error to the caller of %BuildIndices. 
/// </p>
/// <p>
/// <table border=1>
/// <tr>
/// 	<th colspan=3>Parameters</th>
/// </tr>
/// <tr>
/// <th>
/// Name
/// </th>
/// <th>
/// Type
/// </th>
/// <th>
/// Description
/// </th>
/// </tr>
/// <tr>
/// 		<td>indexlist</td>
/// 		<td>Input/output</td>
/// 		<td>
/// 			A $list value containing the names of the indexes to be built. This parameter is 
/// 			passed by reference. If the implementation of %OnBeforeBuildIndices alters this value 
/// 			then %BuildIndices will honor those changes.
/// 		</td>
/// </tr>
/// </table>
/// </p>
ClassMethod %OnBeforeBuildIndices(ByRef indexlist As %String(MAXLEN="") = "") As %Status [ Abstract, Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%BuildIndices</METHOD> method after all work is completed.
/// <P>If this method returns an error then %BuildIndices will return that error but all normal processing is
/// completed. This call occurs just prior to releasing the extent lock if one was requested by the %BuildIndices caller.
/// All index structures have been built and SortEnd executed.</p>
ClassMethod %OnAfterBuildIndices(indexlist As %String(MAXLEN="") = "") As %Status [ Abstract, Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being deleted.
/// 
/// <P>If this method returns an error then the object will not be deleted.
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Abstract, Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> has been deleted.
/// The callback occurs immediately after %DeleteData has been called. If %DeleteData returns
/// an error then %OnAfterDelete is not called.
/// 
/// <P>If %OnAfterDelete returns an error (%Status) then the transaction is rolled back.
ClassMethod %OnAfterDelete(oid As %ObjectIdentity) As %Status [ Abstract, Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Abstract, Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnAfterSave(insert As %Boolean) As %Status [ Abstract, Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Open</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being opened.
/// 
/// <P>If this method returns an error then the object will not be opened.
Method %OnOpen() As %Status [ Abstract, Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

/// <p>
/// This callback method is invoked by the <METHOD>%PurgeIndices</METHOD> method. 
/// </p>
/// <p>
/// If this method returns an error then %PurgeIndices will exit immediately without
/// purging any index structures, returning the error to the caller of %PurgeIndices.
/// </p>
/// <p>
/// <table border=1>
/// <tr>
/// <th colspan=3>Parameters</th>
/// </tr>
/// <tr>
/// <th>
/// Name
/// </th>
/// <th>
/// Type
/// </th>
/// <th>
/// Description
/// </th>
/// </tr>
/// <tr>
/// 		<td>indexlist</td>
/// 		<td>Input/output</td>
/// 		<td>
/// 			A $list value containing the names of the indexes to be built. This parameter is 
/// 			passed by reference. If the implementation of %OnBeforePurgeIndices alters this value 
/// 			then %PurgeIndices will honor those changes.
/// 		</td>
/// </tr>
/// </table>
/// </p>
ClassMethod %OnBeforePurgeIndices(ByRef indexlist As %String(MAXLEN="") = "") As %Status [ Abstract, Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%PurgeIndices</METHOD> method after all work is completed.
/// <P>If this method returns an error then %PurgeIndices will return that error but all normal processing is
/// completed. This call occurs just prior to releasing the extent lock.</p>
ClassMethod %OnAfterPurgeIndices(indexlist As %String(MAXLEN="") = "") As %Status [ Abstract, Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Reload</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> was reloaded.
/// <method>%Reload</method> is invoked by %Open when the object identified by the OID 
/// is already in memory. 
/// <br>
/// <P>If this method returns an error then the object will not be opened.
Method %OnReload() As %Status [ Abstract, Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that a save transaction is being rolled back.
/// 
/// <P>If this method returns an error then the rollback operation will be aborted.
Method %OnRollBack() As %Status [ Abstract, Private, ServerOnly = 1 ]
{
	Quit $$$OK
}

ClassMethod %OnDetermineClass(oid As %ObjectIdentity, ByRef class As %String) As %Status [ ServerOnly = 1 ]
{
	Set class=$classname()
	Quit $$$OK
}

Trigger %OBJJRNIU [ CodeMode = generator, Event = INSERT/UPDATE, Foreach = row, Order = 2, Time = AFTER ]
{
	if ($$$getClassType(%class) '= $$$cCLASSCLASSTYPEPERSISTENT) || ($$$comClassKeyGet(%class,$$$cCLASSnoextent)) { kill %code quit $$$OK }
	set journal = $$$comMemberKeyGet(%class,$$$cCLASSparameter,"OBJJOURNAL",$$$cPARAMdefault)
	set guid = $$$comMemberKeyGet(%class,$$$cCLASSparameter,"GUIDENABLED",$$$cPARAMdefault)
	if journal {
		if journal < 3 {
			$$$GENERATE($Char(9)_"if %oper=""INSERT"" { n %e,iJrnPtr,jid,oref s i=$o(%d("""")) while i'="""" { set $e(%e,i)=$c(1),i=$o(%d(i)) } Set oref=##class({%%CLASSNAME}).%OpenId({%%ID}) $$$txJournalSQLSave({%%CLASSNAMEQ},jid,{%%ID},1"_$select('guid:",""""",1:",##class({%%CLASSNAME}).%GUID($$$oidCompose({%%ID},{%%CLASSNAMEQ}))")_",oref,iJrnPtr) }")
			$$$GENERATE($Char(9)_"elseif %oper=""UPDATE"" { n iJrnPtr,jid,oref set oref=##class({%%CLASSNAME}).%OpenId({%%ID}) $$$txJournalSQLSave($classname(oref),jid,{%%ID},0"_$select('guid:",""""",1:",oref.%GUID($$$oidCompose({%%ID},$classname(oref)))")_",oref,iJrnPtr) }")
		}
		else {
			$$$GENERATE($Char(9)_"if %oper=""INSERT"" { n jid $$$txJournal({%%CLASSNAMEQ},jid,{%%ID},1)")
			$$$GENERATE($Char(9)_"elseif %oper=""UPDATE"" { n jid $$$txJournal({%%CLASSNAMEQ},jid,{%%ID},0)")
		}
	}
	quit $$$OK
}

Trigger %OBJJRND [ CodeMode = generator, Event = DELETE, Foreach = row, Order = 1 ]
{
	if ($$$getClassType(%class) '= $$$cCLASSCLASSTYPEPERSISTENT) || ($$$comClassKeyGet(%class,$$$cCLASSnoextent)) { kill %code quit $$$OK }
	set journal = $$$comMemberKeyGet(%class,$$$cCLASSparameter,"OBJJOURNAL",$$$cPARAMdefault)
	set guid = $$$comMemberKeyGet(%class,$$$cCLASSparameter,"GUIDENABLED",$$$cPARAMdefault)
	if journal {
		if journal < 3 {
			$$$GENERATE($Char(9)_"n iJrnPtr,jid,oref Set oref=##class({%%CLASSNAME}).%OpenId({%%ID}) $$$txJournalSQLDelete($classname(oref),jid,{%%ID}"_$select('guid:",""""",1:",oref.%GUID($$$oidCompose({%%ID},$classname(oref)))")_",oref,iJrnPtr)")
		}
		else {
			$$$GENERATE($Char(9)_"n jid $$$txJournal({%%CLASSNAMEQ},jid,{%%ID},2)")
		}
	}
	quit $$$OK
}

Trigger %OBJGUID [ CodeMode = generator, Event = INSERT, Foreach = row, Order = 1, Time = AFTER ]
{
	if ($$$getClassType(%class) '= $$$cCLASSCLASSTYPEPERSISTENT) || ($$$comClassKeyGet(%class,$$$cCLASSnoextent)) { kill %code quit $$$OK }
	set guid = $$$comMemberKeyGet(%class,$$$cCLASSparameter,"GUIDENABLED",$$$cPARAMdefault)
		// For GUIDENABLED classes this trigger assigns a GUID to inserted rows.
	if guid {
		$$$GENERATE($Char(9)_"if '$a(%check,6) { do ##class({%%CLASSNAME}).%GUIDSet($$$oidCompose({%%ID},{%%CLASSNAMEQ}),{%GUID}) }")
	}
	quit $$$OK
}

}
