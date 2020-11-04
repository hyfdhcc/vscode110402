Include (%syConfig, SHDW)

/// This class allows you to modify and view the [Shadows] section of the CPF file through
/// programatic APIs. While properties are usually modified through the System Management
/// portal, there may be some occasion where modifying them through the API's is best
/// for your system. In all the Config methods, if you do not specify the CPFFile parameter,
/// the currently active CPF file is used. If you wish to modify a CPF file which is not
/// the currently active one, then specify the CPFFile you wish to modify in the method call.<br>
/// The Flags parameter does not normally need to be specified; the defaults are usually
/// sufficient for most cases.<br>
/// You can use either the provided API's (Create/Get/Modify/Delete) to modify the properties by passing 
/// in the correct parameters, or use Object sytax to open and directly manipulate the config
/// objects (Open() and Exists()). Most objects created here need only to specify the Name of the object, 
/// and 1 or 2 properties since the the defaults are what are commonly used for most cases.
/// <br>
/// <br>
/// EXAMPLE:<br>
/// <br>
/// <pre>
/// ; Use class methods to create an instance
/// %SYS>s Name="ABC"
/// %SYS>s Properties("Enabled")=0
/// %SYS>s Properties("Address")="127.0.0.1|56775"
/// %SYS>s Status=##Class(Config.Shadows).Create(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.Shadows).Get(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties
/// Properties("Enabled")=0
/// %SYS>s Properties("Enabled")=1
/// %SYS>s Status=##Class(Config.Shadows).Modify(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.Shadows).Open(Name)
/// ; We could have used i ##Class(Config.Shadows).Exists(Name,.Obj) instead of Open()
/// %SYS>w Obj.Enabled
/// 1
/// %SYS>s Obj.Enabled=0
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now delete the object we just created
/// %SYS>s Status=##Class(Config.Shadows).Delete(Name)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.Shadows Extends (%Persistent, Config.CommonMultipleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

Parameter CAPITALNAME = 0;

Parameter EMSSERVICE [ Internal ] = "Namespace";

/// IP Address to connect to.<br>
Property Address As %NetworkAddress [ Required ];

Property DaysBeforePurge As %Integer(MAXVAL = 10000, MINVAL = 0) [ InitialExpression = 0, Required ];

/// If true, updates that the shadow applies to the shadow databases are NOT
/// journaled, regardless of the journal settings on the databases. By default,
/// this is false, that is, shadow updates are journaled.
Property DisableJournalUpdates As %Boolean [ InitialExpression = 0, Required ];

/// Specifies whether the shadow should be running or stopped.<br>
/// 0 - Stopped<br>
/// 1 - Running<br>
Property Enabled As Security.Datatype.BooleanYN [ InitialExpression = 0, Required ];

Property FilterRoutine As %String(MAXLEN = 64);

/// Directory where the shadow journal files reside.<br>
Property JournalDirectory As %SysPath [ InitialExpression = "shadow", Required ];

/// Maximum number of errors to retain.<br>
Property MaxErrors As %Integer(MAXVAL = 20000, MINVAL = 10) [ InitialExpression = 10, Required ];

/// SSL configuration to use on the shadow connection.<br>
Property SSLConfig As %String;

/// Called by the Create method during import from a CPF file.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal ]
{
}

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from Activate().<br>
/// If a delete operation, then Obj is the shadow of the item which was deleted
/// since the oject itself has already been deleted.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
/// 2 - Delete<br>
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Move the CPF data into the active config global. This also check if any shadow is added/removed/updated in CPF file since last shutdown.<br>
/// <br>
/// Parameters:<br>
ClassMethod MoveToActive(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Rename a shadow to new Shadow including mappings, and activate them.<br>
/// Parameters:<br>
/// <b>OldShadow</b> - Shadow to rename.<br>
/// <b>NewShadow</b> - New Shadow to copy to.<br>
/// <b>CPFFile</b> - Name of the CPF file to copy mappings in, "" = active CPF file.<br>
ClassMethod Rename(OldShadow, NewShadow, CPFFile As %String = "", Flags As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod Suspend(Obj As %ObjectHandle) As %Status [ Internal ]
{
}

ClassMethod %OnBeforeSaveCallBack(insert As %Integer, Obj As %ObjectHandle) As %Status [ Internal, Private ]
{
}

/// Called from  %Delete().<br>
/// Any error returned here will keep the object from being deleted.<br>
ClassMethod %OnDeleteCallBack(Obj As %ObjectHandle) As %Status [ Internal ]
{
}

/// This is called from %Save().<br>
/// Any error returned from this will cause the object to not be saved.<br>
Method %OnValidateObject() As %Status [ Internal ]
{
}

/// List Shadows in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of Shadow names<br>
/// <var>"*"</var> - All records match<br>
/// <var>"String,String1"</var> - Any records matching one of these elements<br>
/// <var>"String*"</var> - Any record starting with "String"<br>
/// <var>"String,String1*,String2"</var> - Any record mathing one of these elements, or starting with "String1"<br>
/// <b>CPFFile</b> - Name of the CPF file to use. A null string means use the active CPF file.<br>
/// <b>Flags</b> - Currently ignored.<br>
/// <b>Format</b> <br>
/// <var>0</var> - Standard report list format<br>
/// <var>1</var> - ^CONFIG global format<br>
/// <var>2</var> - CPF file format format<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Name:%String,Address:%String,Enabled:%Integer,JournalDirectory:%SysPath,DaysBeforePurge:%Integer,SSLConfig:%String,FilterRoutine:%String,MaxErrors:%Integer") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

/// Called from %OnBeforeSave. Provides a way for a specific class to override the 
/// EMS.Restricted() check when the Instance is managed. Used when a few properties in
/// a class (like Config.SQL.JDBCGatewayPort) are not managed by EMS.
Method EMSAllowEdit(insert As %Boolean) As %Boolean [ Internal ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

/// Returns info about source databases
Query SourceDatabases(ShadowID As %String) As %Query(ROWSPEC = "Directory:%String,Mount State:%String")
{
}

ClassMethod SourceDatabasesExecute(ByRef qHandle As %Binary, ShadowID As %String) As %Status
{
}

ClassMethod SourceDatabasesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
}

ClassMethod SourceDatabasesClose(ByRef qHandle As %Binary) As %Status
{
}

Storage Default
{
<Data name="ShadowsDefaultData">
<Value name="1">
<Value>Comments</Value>
</Value>
<Value name="2">
<Value>Address</Value>
</Value>
<Value name="3">
<Value>DaysBeforePurge</Value>
</Value>
<Value name="4">
<Value>DisableJournalUpdates</Value>
</Value>
<Value name="5">
<Value>Enabled</Value>
</Value>
<Value name="6">
<Value>FilterRoutine</Value>
</Value>
<Value name="7">
<Value>JournalDirectory</Value>
</Value>
<Value name="8">
<Value>MaxErrors</Value>
</Value>
<Value name="9">
<Value>SSLConfig</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>ShadowsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
