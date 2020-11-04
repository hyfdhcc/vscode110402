Include %sySystem

/// <b>
/// Note: The class definition classes in the %Library package have been superceded
/// by those in the %Dictionary package.</b>
/// <p>
/// 
/// This class represents a specific <i>class</i> description contained within the 
/// <i>Cach&eacute; Dictionary.</i>
/// 
/// <p>For more information on class definition classes, refer to
/// <link href=/AboutClassDefinition.html>About Class Definition Classes</link>.
Class %Library.ClassDefinition Extends %AbstractDefinition [ Not ProcedureBlock, StorageStrategy = custom, System = 2 ]
{

/// A string containing the name of the class.
Property Name As %CacheString;

/// A flag indicating whether the class is abstract (1) or not (0).
Property Abstract As %CacheString;

/// A string containing the class type.
Property ClassType As %CacheString [ InitialExpression = {$char(0)} ];

Method ClassTypeGet() As %CacheString
{
	If i%ClassType=$char(0) Quit $$ClassType^%occName($piece(..Super,","))
	Quit i%ClassType
}

/// For a datatype class, a string containing the client datatype of the class.
Property ClientDatatype As %CacheString [ InitialExpression = "VARCHAR" ];

/// A string containing the name of another class which should be 
/// compiled before this class.
Property CompileAfter As %CacheString;

/// A flag indicating whether the class is a datatype class (1) or not (0).
Property Datatype As %CacheString [ Calculated ];

/// A flag indicating whether DDL operations are allowed on the class (1) or not (0).
Property DDLAllowed As %CacheString;

/// A string containing the description of the class.
Property Description As %CacheString;

/// A flag indicating whether the class is dynamically defined (1) or not (0).
Property Dynamic As %CacheString;

/// A flag indicating whether the class is final (1) or not (0).
Property Final As %CacheString;

/// A flag indicating whether the class is hidden (1) or not (0).
Property Hidden As %CacheString;

/// A string containing a comma-delimited list of names of 
/// include (.INC) files to be used when compiling the class.
Property IncludeCode As %CacheString;

/// A string containing a comma-delimited list of names of 
/// include (.INC) files to be used when compiling any method generators for the class.
Property IncludeGenerator As %CacheString;

/// A string containing the default language for all the methods.
Property Language As %CacheString [ InitialExpression = "cache" ];

/// A flag indicating how the class keeps track of modified attributes.
Property Modified As %CacheString [ InitialExpression = 0 ];

/// This is for internal use only.
Property NoContext As %CacheString;

/// For a datatype class, a string indicating the ODBC type of the class.
Property OdbcType As %CacheString [ InitialExpression = "VARCHAR" ];

/// A string containing the name of the owner of the class.
Property Owner As %CacheString;

/// A flag indicating whether the class is persistent (1) or not (0).
Property Persistent As %CacheString [ Calculated ];

/// This is for internal use only.
Property PropertyClass As %CacheString;

Property Querytype As %CacheString [ Calculated ];

/// A flag indicating whether the class is serial (embeddable) (1) or not (0).
Property Serial As %CacheString [ Calculated ];

/// For datatype classes, a string containing the name of the SQL category 
/// associated with the data type.
Property SqlCategory As %CacheString [ InitialExpression = "STRING" ];

/// This is for internal use.
Property SqlRoutinePrefix As %CacheString;

/// A string containing a user-defined name of the ID field or null string "" if it has the default name.
Property SqlRowIdName As %CacheString;

/// A flag indicating whether the class hides its ID field to SQL (1) or not (0).
Property SqlRowIdPrivate As %CacheString;

/// A string containing an optional SQL table name. This is the name used the class 
/// is projected as an SQL table.
Property SqlTableName As %CacheString;

/// A string containing the name of the storage definition in use.
Property StorageStrategy As %CacheString;

/// A string containing a comma-delimited list of super class names.
Property Super As %CacheString;

/// A flag indicating whether the class is a system class (1) or not (0).
Property System As %CacheString [ InitialExpression = 0 ];

/// Time this class is created.
Property TimeCreated As %CacheString;

/// A flag indicating whether the class is an SQL view (1) or not (0).
Property View As %CacheString [ Calculated ];

/// The SQL statement that defines a view.
Property ViewQuery As %CacheString;

/// A collection of foreign keys belonging to the class.
/// See <CLASS>%ForeignKeyDefinition</CLASS> for details.
Property ForeignKeys As %ListOfPersistentChildObjects(CLASSNAME = 1);

/// A collection of indices belonging to the class.
/// See <CLASS>%IndexDefinition</CLASS> for details.
Property Indices As %ListOfPersistentChildObjects(CLASSNAME = 1);

/// A collection of methods belonging to the class.
/// See <CLASS>%MethodDefinition</CLASS> for details.
Property Methods As %ListOfPersistentChildObjects(CLASSNAME = 1);

/// A collection of class parameters belonging to the class.
/// See <CLASS>%ParameterDefinition</CLASS> for details.
Property Parameters As %ListOfPersistentChildObjects(CLASSNAME = 1);

/// A collection of properties belonging to the class.
/// See <CLASS>%PropertyDefinition</CLASS> for details.
Property Properties As %ListOfPersistentChildObjects(CLASSNAME = 1);

/// A collection of class queries belonging to the class.
/// See <CLASS>%QueryDefinition</CLASS> for details.
Property Queries As %ListOfPersistentChildObjects(CLASSNAME = 1);

/// A collection of storage definitions belonging to the class.
/// See <CLASS>%StorageDefinition</CLASS> for details.
Property Storages As %ListOfPersistentChildObjects(CLASSNAME = 1);

/// A collection of SQL triggers belonging to the class.
/// See <CLASS>%TriggerDefinition</CLASS> for details.
Property Triggers As %ListOfPersistentChildObjects(CLASSNAME = 1);

/// The class dictionary version of this class, when we save we always upgrade to the latest version automatically.
/// If you open an existing class we will use the version from this class
Property ClassVersion As %Integer [ InitialExpression = 23 ];

Property list As %ListOfDataTypes [ Transient ];

Method %OnNew(classname As %String) As %Status [ Private ]
{
 n ismatched $$$IsClassDefVersionMatched(ismatched) i ismatched=0 q $$$ERROR($$$ClassDictionaryVersionMismatch)
 ;
 i classname="" q $$$ERROR($$$ClassNameRequired)
 s classname=$$$NormalizeClassname(classname)
 New rc
 Set rc=$$IsClassnameValid^%occName(,classname) If $$$ISERR(rc) Quit rc
 Set rc=$$IsClassnameConflict^%occName(classname) If $$$ISERR(rc) Quit rc
 s i%Name=classname
 s i%TimeCreated=$zutil(188)
 ;
 s i%ForeignKeys=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSfkey)),classname,"%Library.ForeignKeyDefinition"))
 s i%Indices=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSindex)),classname,"%Library.IndexDefinition"))
 s i%Methods=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSmethod)),classname,"%Library.MethodDefinition"))
 s i%Parameters=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSparameter)),classname,"%Library.ParameterDefinition"))
 s i%Properties=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSproperty)),classname,"%Library.PropertyDefinition",""))
 s i%Queries=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSquery)),classname,"%Library.QueryDefinition",""))
 s i%Storages=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSstorage)),classname,"%Library.StorageDefinition"))
 s i%Triggers=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASStrigger)),classname,"%Library.TriggerDefinition"))

 q $$$OK
}

Method %LoadData(classname As %String) As %Status [ Private ]
{
 n ismatched $$$IsClassDefVersionMatched(ismatched) i ismatched=0 q $$$ERROR($$$ClassDictionaryVersionMismatch)
 ;
 s classname=$$$NormalizeClassname(classname)
 i $$$defClassDefined(classname)=0 q $$$ERROR($$$ClassDoesNotExist,classname)
 i $$$defClassVersionGet(classname)'=$$$CLASSDEFINITIONVERSION q $$$ERROR($$$OneClassDictionaryVersionMismatch,classname)
 ;
 n sc
 s i%Name=classname
 ;
 s i%ClassVersion=$$$defClassVersionGet(classname)
 s i%Abstract=$$$defClassKeyGet(classname,$$$cCLASSabstract)
 i $$$defClassKeyDefined(classname,$$$cCLASSclasstype) { s i%ClassType=$$$defClassKeyGet(classname,$$$cCLASSclasstype) } Else { s i%ClassType=$char(0) }
 s i%ClientDatatype=$$$defClassKeyGet(classname,$$$cCLASSclientdatatype)
 s i%CompileAfter=$$$defClassKeyGet(classname,$$$cCLASScompileafter)
 s i%DDLAllowed=$$$defClassKeyGet(classname,$$$cCLASSddlallowed)
 s i%Description=$$$defClassKeyGet(classname,$$$cCLASSdescription)
 s i%Dynamic=$$$defClassKeyGet(classname,$$$cCLASSdynamic)
 s i%Final=$$$defClassKeyGet(classname,$$$cCLASSfinal)
 s i%Hidden=$$$defClassKeyGet(classname,$$$cCLASShidden)
 s i%IncludeCode=$$$defClassKeyGet(classname,$$$cCLASSincludecode)
 s i%IncludeGenerator=$$$defClassKeyGet(classname,$$$cCLASSincludegenerator)
 s i%Modified=$$$defClassKeyGet(classname,$$$cCLASSmodified)
 s i%Language=$$$defClassKeyGet(classname,$$$cCLASSlanguage)
 s i%NoContext=$$$defClassKeyGet(classname,$$$cCLASSnocontext)
 s i%OdbcType=$$$defClassKeyGet(classname,$$$cCLASSodbctype)
 s i%Owner=$$$defClassKeyGet(classname,$$$cCLASSowner)
 s i%PropertyClass=$$$defClassKeyGet(classname,$$$cCLASSpropertyclass)
 s i%SqlRoutinePrefix=$$$defClassKeyGet(classname,$$$cCLASSsqlroutineprefix)
 s i%SqlCategory=$$$defClassKeyGet(classname,$$$cCLASSsqlcategory)
 s i%SqlRowIdName=$$$defClassKeyGet(classname,$$$cCLASSsqlrowidname)
 s i%SqlRowIdPrivate=$$$defClassKeyGet(classname,$$$cCLASSsqlrowidprivate)
 s i%SqlTableName=$$$defClassKeyGet(classname,$$$cCLASSsqltablename)
 s i%StorageStrategy=$$$defClassKeyGet(classname,$$$cCLASSstoragestrategy)
 s i%Super=$$$defClassKeyGet(classname,$$$cCLASSsuper)
 s i%System=$$$defClassKeyGet(classname,$$$cCLASSsystem)
 s i%TimeCreated=$$$defClassKeyGet(classname,$$$cCLASStimecreated)
 s i%ViewQuery=$$$defClassKeyGet(classname,$$$cCLASSviewquery)
 ;
 s i%ForeignKeys=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSfkey)),classname,"%Library.ForeignKeyDefinition"))
 s i%Indices=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSindex)),classname,"%Library.IndexDefinition"))
 s i%Methods=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSmethod)),classname,"%Library.MethodDefinition"))
 s i%Parameters=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSparameter)),classname,"%Library.ParameterDefinition"))
 s i%Properties=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSproperty)),classname,"%Library.PropertyDefinition",""))
 s i%Queries=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSquery)),classname,"%Library.QueryDefinition",""))
 s i%Storages=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASSstorage)),classname,"%Library.StorageDefinition"))
 s i%Triggers=$$$oidForm($lb($name($$$defClassKeyRaw(classname,$$$cCLASStrigger)),classname,"%Library.TriggerDefinition"))

 q $$$OK
}

Method %SaveData(id As %String) As %Status [ Private ]
{
 n ismatched $$$IsClassDefVersionMatched(ismatched) i ismatched=0 q $$$ERROR($$$ClassDictionaryVersionMismatch)
 ;
 i i%Name="" q $$$ERROR($$$ClassNameRequired)
 ;
 s i%Name=$$$NormalizeClassname(i%Name)
 n classname
 s classname=i%Name
 If $$CheckProtect^%occSAX(classname_".cls") q $$$ERROR($$$ItemProtect,classname_".cls")
 New rc
 Set rc=$$IsClassnameValid^%occName(,classname) If $$$ISERR(rc) Quit rc
 Set rc=$$IsClassnameConflict^%occName(classname) If $$$ISERR(rc) Quit rc
 ;
 i id="" n sc s sc=..%IdSet(classname) i $$$ISERR(sc) q sc
 ;
 #define SAVEstring(%class,%keyword,%value) if %value'=$$$tableDefaultGet($$$cROOTclass,%keyword) { $$$defClassKeySet(%class,%keyword,%value) } else { $$$defClassKeyKill(%class,%keyword) }
 #define SAVEnumber(%class,%keyword,%value) if +%value'=$$$tableDefaultGet($$$cROOTclass,%keyword) { $$$defClassKeySet(%class,%keyword,+%value) } else { $$$defClassKeyKill(%class,%keyword) }
 ;
 $$$SAVEstring(classname,$$$cCLASSname,i%Name)
 $$$SAVEnumber(classname,$$$cCLASSabstract,i%Abstract)
 $$$SAVEnumber(classname,$$$cCLASSprocedureblock,0)
 If i%ClassType'=$char(0) { $$$defClassKeySet(classname,$$$cCLASSclasstype,i%ClassType) } Else { $$$defClassKeyKill(classname,$$$cCLASSclasstype) }
 $$$SAVEstring(classname,$$$cCLASSclientdatatype,i%ClientDatatype)
 $$$SAVEstring(classname,$$$cCLASScompileafter,i%CompileAfter)
 $$$SAVEnumber(classname,$$$cCLASSddlallowed,i%DDLAllowed)
 $$$SAVEstring(classname,$$$cCLASSdescription,i%Description)
 $$$SAVEnumber(classname,$$$cCLASSdynamic,i%Dynamic)
 $$$SAVEnumber(classname,$$$cCLASSfinal,i%Final)
 $$$SAVEnumber(classname,$$$cCLASShidden,i%Hidden)
 $$$SAVEstring(classname,$$$cCLASSincludecode,i%IncludeCode)
 $$$SAVEstring(classname,$$$cCLASSincludegenerator,i%IncludeGenerator)
 $$$SAVEstring(classname,$$$cCLASSmodified,i%Language)
 $$$SAVEnumber(classname,$$$cCLASSmodified,i%Modified)
 $$$SAVEnumber(classname,$$$cCLASSnocontext,i%NoContext)
 $$$SAVEstring(classname,$$$cCLASSodbctype,i%OdbcType)
 $$$SAVEstring(classname,$$$cCLASSowner,i%Owner)
 $$$SAVEstring(classname,$$$cCLASSpropertyclass,i%PropertyClass)
 $$$SAVEstring(classname,$$$cCLASSsqlcategory,i%SqlCategory)
 $$$SAVEstring(classname,$$$cCLASSsqlroutineprefix,i%SqlRoutinePrefix)
 $$$SAVEstring(classname,$$$cCLASSsqlrowidname,i%SqlRowIdName)
 $$$SAVEnumber(classname,$$$cCLASSsqlrowidprivate,i%SqlRowIdPrivate)
 $$$SAVEstring(classname,$$$cCLASSsqltablename,i%SqlTableName)
 $$$SAVEstring(classname,$$$cCLASSstoragestrategy,i%StorageStrategy)
 $$$SAVEstring(classname,$$$cCLASSsuper,i%Super)
 $$$SAVEnumber(classname,$$$cCLASSsystem,i%System)
 $$$SAVEstring(classname,$$$cCLASStimecreated,i%TimeCreated)
 $$$SAVEstring(classname,$$$cCLASSviewquery,i%ViewQuery)
 ;
 $$$defClassKeySet(classname,$$$cCLASStimechanged,$zutil(188))
 $$$defClassVersionSet(classname,i%ClassVersion)
 Do RebuildItemIndex^%R(classname,"CLS")
 Set i%ClassVersion=$$$CLASSDEFINITIONVERSION
 Quit $$$OK
}

ClassMethod %DeleteData(id As %String, concurrency As %Integer) As %Status [ Private ]
{
 n ismatched $$$IsClassDefVersionMatched(ismatched) i ismatched=0 q $$$ERROR($$$ClassDictionaryVersionMismatch)
 ;
 i id="" q $$$ERROR($$$ClassNameRequired)
 n classname
 s classname=$$$NormalizeClassname(id)
 QUIT $$Delete^%apiOBJ(classname,"-d",,$$$GetddlNo30)
}

ClassMethod %Exists(oid As %ObjectIdentity) As %Boolean
{
 n id s id=$$$oidPrimary(oid) QUIT:id="" 0
 Set id=$$$NormalizeClassname(id)
 Quit $$$defClassDefined(id)\10
}

Method DatatypeGet() As %CacheString
{
 QUIT:i%ClassType'=$char(0) i%ClassType=$$$cCLASSCLASSTYPEDATATYPE
 Quit $$$classIsDataType($$$NormalizeClassname(i%Name))
}

Method DatatypeSet(value As %CacheString) As %Status
{
 i value s i%ClassType=$$$cCLASSCLASSTYPEDATATYPE
 i 'value,i%ClassType=$$$cCLASSCLASSTYPEDATATYPE s i%ClassType=""
 QUIT $$$OK
}

Method PersistentGet() As %CacheString
{
 QUIT i%ClassType=$$$cCLASSCLASSTYPEPERSISTENT
 Quit $$$classIsPersistent($$$NormalizeClassname(i%Name))
}

Method PersistentSet(value As %CacheString) As %Status
{
 i value s i%ClassType=$$$cCLASSCLASSTYPEPERSISTENT
 i 'value,i%ClassType=$$$cCLASSCLASSTYPEPERSISTENT s i%ClassType=""
 QUIT $$$OK
}

Method QuerytypeGet() As %CacheString
{
 QUIT:i%ClassType'=$char(0) i%ClassType=$$$cCLASSCLASSTYPEQUERYTYPE
 Quit $$$getClassType($$$NormalizeClassname(i%Name))=$$$cCLASSCLASSTYPEQUERYTYPE
}

Method QuerytypeSet(value As %CacheString) As %Status
{
 i value s i%ClassType=$$$cCLASSCLASSTYPEQUERYTYPE
 i 'value,i%ClassType=$$$cCLASSCLASSTYPEQUERYTYPE s i%ClassType=""
 QUIT $$$OK
}

Method SerialGet() As %CacheString
{
 QUIT:i%ClassType'=$char(0) i%ClassType=$$$cCLASSCLASSTYPESERIAL
 Quit $$$classIsSerial($$$NormalizeClassname(i%Name))
}

Method SerialSet(value As %CacheString) As %Status
{
 i value s i%ClassType=$$$cCLASSCLASSTYPESERIAL
 i 'value,i%ClassType=$$$cCLASSCLASSTYPESERIAL s i%ClassType=""
 QUIT $$$OK
}

Method ViewGet() As %CacheString
{
 QUIT:i%ClassType'=$char(0) i%ClassType=$$$cCLASSCLASSTYPEVIEW
 Quit $$$getClassType($$$NormalizeClassname(i%Name))=$$$cCLASSCLASSTYPEVIEW
}

Method ViewSet(value As %CacheString) As %Status
{
 i value s i%ClassType=$$$cCLASSCLASSTYPEVIEW
 i 'value,i%ClassType=$$$cCLASSCLASSTYPEVIEW s i%ClassType=""
 QUIT $$$OK
}

Method GetClassLocalList() As %ListOfDataTypes
{
 n class,list,data
 i ..list=$$$NULLOREF s ..list=##class(%ListOfDataTypes).%New()
 Set list=..list
 d list.Clear()
 If $Get(^rINDEXCLASS)="" Do RebuildIndex^%R()
 s class="" f  s class=$o(^rINDEXCLASS(class),1,data) q:class=""  d list.Insert($List(data,2))
 q list
}

Method GetClassFullList(flag As %String = "") As %ListOfDataTypes
{
 n classlist,class
 d GetClassFullList^%occLibrary(.classlist,flag)
 i ..list=$$$NULLOREF s ..list=##class(%ListOfDataTypes).%New()
 d ..list.Clear()
 s class="" f  s class=$o(classlist(class)) q:class=""  d ..list.Insert(class)
 q ..list
}

Method CompileClasses(classlist As %String, flag As %String) As %ListOfDataTypes
{
 n error,i
 d CompileList^%apiOBJ(classlist,.flag,.error)
 i ..list=$$$NULLOREF s ..list=##class(%ListOfDataTypes).%New()
 d ..list.Clear()
 f i=1:1:error d ..list.Insert(error(i))
 q ..list
}

Method CompileAllClasses(flag As %String) As %ListOfDataTypes
{
 n error,i
 d CompileAll^%apiOBJ(.flag,.error)
 i ..list=$$$NULLOREF s ..list=##class(%ListOfDataTypes).%New()
 d ..list.Clear()
 f i=1:1:error d ..list.Insert(error(i))
 q ..list
}

ClassMethod ExportCPP(classname As %String, dir As %String) As %Status
{
 q $$ExportCPPList^%apiOBJ(classname,dir,"-d")
}

ClassMethod ExportODL(classname As %String, file As %String) As %Status
{
 q $$ExportODLList^%apiOBJ(classname,file,"-d")
}

ClassMethod ExportJava(classes As %String, dir As %String) As %Status
{
 q $$ExportJavaList^%apiOBJ(classes,dir,"-d")
}

ClassMethod Export(classes As %String, type As %String, ByRef objs As %ArrayOfObjects) As %Status
{
 New %sc,i,stream
 Set %sc=$$$ERR($$$NotImplemented),err=""
 Set objs=##class(%ArrayOfObjects).%New()
 If (type="odl") Do
 . Set stream=##class(%FileCharacterStream).%New()
 . Do stream.Write("")
 . If type="odl" Set %sc=..ExportODL(classes,stream.Filename)
 . If $$$ISOK(%sc) Do objs.SetAt(stream,stream.Filename)
 Else  If (type="cpp")!(type="java") Do
 . ; !!!TODO!!!

 #; Clean up and exit on error
 If $$$ISERR(%sc) Do  Quit %sc
 . Set i="" For  Set i=objs.Next(i) Quit:i=""  Do objs.RemoveAt(i)
 . Set objs=""

 #; Rewind all of the streams
 Set i="" For  Set i=objs.Next(i) Quit:i=""  Set stream=objs.GetAt(i) Do stream.Rewind()

 Quit $$$OK
}

/// The <b>ClassInfo</b> query provides a summary of information about classes contained in the 
/// <i>Cach&eacute Dictionary</i>.
Query ClassInfo(initvalue As %String, mapped As %Boolean = 1) As %Query(CONTAINID = 1, ROWSPEC = "Name:%String:ClassName,Super:%String,Hidden:%Boolean,Datatype:%Boolean,System:%Integer,Final:%Boolean,Persistent:%Boolean,Serial:%Boolean,TimeChanged,SqlTableName,Abstract:%Boolean")
{
}

ClassMethod ClassInfoExecute(ByRef QHandle As %Binary, initvalue As %String, mapped As %Boolean = 1) As %Status [ ProcedureBlock = 1 ]
{
	If 'mapped,$extract($namespace)'="^" {
		Set dest=$$GetGlobalSourceDatabase^%SYS.SECURITY($name(^oddDEF))
	} Else {
		Set dest=$namespace
	}
	Set QHandle=$lb(initvalue,dest)
	Quit $$$OK
}

/// <b>Fetch</b> returns the next row in the query.
ClassMethod ClassInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ CodeMode = expression ]
{
..ClassInfoFetchRows(.QHandle,1,.Row,,.AtEnd)
}

/// <b>RoutineListFetchRows</b> returns the next <var>FetchCount</var> rows in the query.
ClassMethod ClassInfoFetchRows(ByRef QHandle As %Binary, FetchCount As %Integer = 0, ByRef RowSet As %List, ByRef ReturnCount As %Integer, ByRef AtEnd As %Integer) As %Status [ ProcedureBlock = 1 ]
{
	Set RowSet="",position=$listget(QHandle),ns=$listget(QHandle,2)
	If '$get(FetchCount) Set FetchCount=10000
	If $get(AtEnd) Set position="" Quit $$$OK
	Set name=$zcvt(position,"U"),AtEnd=0
	For no=1:1:FetchCount {
		Set name=$order(^|ns|rINDEXCLASS(name),1,data)
		If name="" Set AtEnd=1,QHandle="" Quit
		Set time=$listget(data) If time'="" Set time=$zdth(time,3)
		Set classtype=$$ClassType^%occName($list(data,2))
		Set RowSet=RowSet_$lb($list(data,2),$lg(data,7),''$lg(data,4),classtype=$$$cCLASSCLASSTYPEDATATYPE,''$lg(data,3),''$lg(data,9),classtype=$$$cCLASSCLASSTYPEPERSISTENT,classtype=$$$cCLASSCLASSTYPESERIAL,time,$lg(data,8),$lg(data,10))
		If $length(RowSet)>20000 Quit
	}
	If $get(AtEnd) Set ReturnCount=no-1 Quit $$$OK
	Set QHandle=$listbuild(name,ns),ReturnCount=no
	Quit $$$OK
}

ClassMethod ClassInfoClose(QHandle As %Binary) As %Status
{
	Quit $$$OK
}

/// The <b>SubclassOf</b> query produces a list of classes that are subclasses of the
/// <var>super</var> class starting the search at <var>initval</var>. For example this
/// allows you to find all the subclasses of %CSP.Page very easily.
Query SubclassOf(super As %String, initval As %String = "") As %Query(CONTAINID = 1, ROWSPEC = "Name:%String:ClassName")
{
}

ClassMethod SubclassOfExecute(ByRef QHandle As %Binary, super As %String, initval As %String = "") As %Status
{
	New class,answer,idx,data
	Set idx=$increment($$$ISCQUERYTEMP)
	#; Make sure this is cleaned up if the process crashes
	Set super=$$$NormalizeClassname(super)
	Set $$$ISCQUERYTEMP(idx,super)=1
	Set class=$order(^rINDEXCLASS($zconvert(initval,"u")),1,data)
	While class'="" {
	Do check($list(data,2))
	Set class=$order(^rINDEXCLASS(class),1,data)
	}
	Kill $$$ISCQUERYTEMP(idx,super)
	Set QHandle=$listbuild(idx,initval)
	Quit $$$OK
check(class) 	If class="" Quit 0
	If $data($$$ISCQUERYTEMP(idx,class)) Quit ^(class)
	#; Set the node to 0 here so if we detect a loop then we report it is not a subclass
	Set $$$ISCQUERYTEMP(idx,class)=0
	New thissuper,no,item,return
	Set return=0
	Set thissuper=$listget($get(^rINDEXCLASS($zconvert(class,"U"))),7)
	For no=1:1:$length(thissuper,",") {
		Set item=$zstrip($piece(thissuper,",",no),"<>W")
		If item'="" Do NormalizeClassnameByDef^%occName(.item,item,class) If $$check(item) Set return=1 Quit
	}
	Set $$$ISCQUERYTEMP(idx,class)=return
	Quit return
}

ClassMethod SubclassOfClose(QHandle As %Binary) As %Status
{
	If $listget(QHandle)'="" {
		Kill $$$ISCQUERYTEMP($list(QHandle))
	}
	Quit $$$OK
}

/// <b>Fetch</b> returns the next row in the query.
ClassMethod SubclassOfFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ CodeMode = expression ]
{
..SubclassOfFetchRows(.QHandle,1,.Row,,.AtEnd)
}

/// <b>SubclassOfFetchRows</b> returns the next <var>FetchCount</var> rows in the query.
ClassMethod SubclassOfFetchRows(ByRef QHandle As %Binary, FetchCount As %Integer = 0, ByRef RowSet As %List, ByRef ReturnCount As %Integer, ByRef AtEnd As %Integer) As %Status
{
	New dir,idx,no,number,class,val
	If QHandle="" Set AtEnd=1 Quit $$$OK
	If FetchCount=0 Set FetchCount=2000
	Set RowSet="",number=0
	Set class=$listget(QHandle,2),idx=$listget(QHandle)
	Set class=$order($$$ISCQUERYTEMP(idx,class),1,val)
	While class'="" {
		If val {
			Set RowSet=RowSet_$listbuild(class),number=number+1
			If number=FetchCount||($length(RowSet)>20000) Quit
		}
		Set class=$order($$$ISCQUERYTEMP(idx,class),1,val)
	}
	#; Check if we are done
	If class="" Set AtEnd=1,QHandle="" Kill $$$ISCQUERYTEMP(idx) Quit $$$OK
	Set ReturnCount=number
	Set QHandle=$ListBuild(idx,class)
	Quit $$$OK
}

ClassMethod CacheSQLInstalled() As %Integer [ CodeMode = expression ]
{
$$$ISOK($$CacheSQLInstalled^%ocsSQLRTDict())
}

// %ClassDefinition itself doesn't nest TranstateState

Method GetTransientState() As %String [ CodeMode = generator ]
{
	n prop,runtimetype
	s %code=0
	$$$GENERATE(" n state,oid s state=""""")
	s prop="" f  s prop=$$$comMemberNext(%class,$$$cCLASSproperty,prop) q:prop=""  d
	. i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcalculated) q
	. i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPtransient) q
	. $$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,prop,$$$cPROPruntimetype)
	. i $$$classIsDataType(runtimetype) $$$GENERATE(" s state=state_..lb(i%"_prop_")") q
	$$$GENERATE(" QUIT state")
	QUIT $$$OK
}

Method SetTransientState(state) [ CodeMode = generator ]
{
	n prop,count,runtimetype
	s %code=0,count=0
	$$$GENERATE(" n oref")
	s prop="" f  s prop=$$$comMemberNext(%class,$$$cCLASSproperty,prop) q:prop=""  d
	. i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcalculated) q
	. i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPtransient) q
	. $$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,prop,$$$cPROPruntimetype)
	. i $$$classIsDataType(runtimetype) s count=count+1 $$$GENERATE(" s i%"_prop_"=..li(state,"_count_")") q
	$$$GENERATE(" QUIT")
	QUIT $$$OK
}

ClassMethod PublishUserClasses() As %Status
{
	i '$$$isWINDOWS Quit $$$OK
	Quit ##class(%Documatic).PublishUserClasses()
}

ClassMethod PublishUserClass(classname As %String) As %Status
{
	i '$$$isWINDOWS Quit $$$OK
	Quit ##class(%Documatic).PublishUserClass(.classname)
}

ClassMethod UpdateUserIndex() As %Status
{
	i '$$$isWINDOWS Quit $$$OK
	Quit ##class(%Documatic).UpdateUserIndex()
}

ClassMethod CurrentNameSpace() As %String
{
	Quit $zu(5)
}

Storage custom
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^%Library.ClassDefinitionS</StreamLocation>
<Type>%CustomStorage</Type>
}

}
