Include (%syConfig, %syMirror, %syDatabase, %syJrninc, %syINET)

/// This class allows you to modify and view the [MirrorAsyncMemberSources] section of the CPF file through
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
/// </pre>
Class Config.MirrorAsyncMemberSources Extends (%Persistent, Config.CommonMultipleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// Server name is always capitalized.<br>
Parameter CAPITALNAME = 1;

Parameter EMSSERVICE [ Internal ] = "Mirror";

Property AgentAddress As Config.Host [ Required ];

Property AgentPort As %Integer [ Required ];

Property AsyncMemberType As %Integer(MAXVAL = 1, MINVAL = 0) [ InitialExpression = 0, Required ];

Property InstanceDirectory As %SysPath;

/// Force the name to be uppercase.<br>
Method NameSet(Val) As %Status [ Internal ]
{
}

/// Called by the Create method during import from a CPF file.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal ]
{
}

/// Delete a section instance from a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Name</b> - Name of the instance to delete.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file.<br>
/// <b>Flags</b> - Bit string of options to perform. See the <METHOD>Create</METHOD> method for values.<br>
/// <br>
/// Return values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Delete(Name As %String, ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}, Clean As %Integer = 1) As %Status
{
}

/// Load the MirrorAsyncMemberSources info.<br>
/// ^SYS("MIRRORSET") is killed in Mirror^STU. Here if we find ^SYS("MIRRORSET")=0^<xxx>
/// then MirrorMember.Load() configured this node as a failover node and we need to 
/// abort if its also configured as a reporting node.
/// <br>
/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// If a delete operation, then Obj is the NAME of the item which was deleted
/// since the oject itself has already been deleted.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
/// 2 - Delete<br>
/// 4 - Special value called by Start^MIRRORMGR to load mirror set cofiguration.
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
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

/// List MirrorAsyncMemberSources in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of MirrorAsyncMemberSources names<br>
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
Query List(Names As %String, CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Name:%String,AgentAddress:%String,AgentPort:%Integer,InstanceDirectory:%String,AsyncMemberType:%Integer") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

Storage Default
{
<Data name="MirrorAsyncMemberSourcesDefaultData">
<Value name="1">
<Value>Comments</Value>
</Value>
<Value name="2">
<Value>AgentAddress</Value>
</Value>
<Value name="3">
<Value>AgentPort</Value>
</Value>
<Value name="4">
<Value>AsyncMemberType</Value>
</Value>
<Value name="5">
<Value>InstanceDirectory</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>MirrorAsyncMemberSourcesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
