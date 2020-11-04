Include %sySystem

Class Provider.Instances Extends (%Persistent, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index MachineNameInstanceNameLowerCaseIndex On (MachineNameLowerCase, InstanceNameLowerCase) [ IdKey, Unique ];

Property CacheGroup As %String [ InitialExpression = "cacheusr" ];

Property CacheUser As %String [ InitialExpression = "cacheusr" ];

Property CachePassword As %String [ InitialExpression = "SYS" ];

/// Enter a description <br>
Property Description As %String(MAXLEN = 256, MINLEN = 0);

Property Directory As %SysPath;

/// Readable version of Status property.
Property Error As %String(MAXLEN = 255);

Property InstanceName As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// 0 - Not installed
/// 1 - Installed
Property Installed As %Boolean [ InitialExpression = 0 ];

Property InstanceNameLowerCase As %String(MAXLEN = 64, MINLEN = 1, XMLPROJECTION = "NONE") [ ReadOnly, Required ];

Property LastInstall As %String(MAXLEN = 64, MINLEN = 0);

Property LastInstallTime As %String(MAXLEN = 64) [ ReadOnly ];

Property LastInstallUsername As %String(MAXLEN = 64) [ ReadOnly ];

Property MachineName As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

Property MachineNameLowerCase As %String(MAXLEN = 64, MINLEN = 1, XMLPROJECTION = "NONE") [ ReadOnly, Required ];

Property ManagerGroup As %String [ InitialExpression = "root" ];

Property SecurityType As %String [ InitialExpression = "Minimal" ];

Property State As %String [ InitialExpression = "Uninstalled" ];

Property Status As %Status [ InitialExpression = {$$$OK} ];

Property Unicode As %Boolean [ InitialExpression = 1 ];

ClassMethod Test(Num As %Integer = 5) As %Status [ Internal ]
{
}

ClassMethod Create(MachineName As %String, InstanceName As %String, ByRef Properties As %String) As %Status
{
}

ClassMethod Remove(MachineName As %String, InstanceName As %String) As %Status
{
}

ClassMethod Delete(MachineName As %String, InstanceName As %String) As %Status
{
}

/// Instance exists.<br>
/// This method checks for the existence of an Event in the security database.<br>
/// Parameters:<br>
/// Source - Source of the Event. This may also contain an entire Event 
/// specificationin the format Source/Type/Name. If this is the case the Type
/// and Name parameters are ignored.<br>
/// Type - Type of the Event<br>
/// Name - Name of the Event<br>
/// Return values:<br>
/// If Value of the method = 0 (Event does not exist, or some error occured)<br>
/// Event = Null<br>
/// Status = Event "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (Event exists)<br>
/// Event = Object handle to Event<br>
/// Status = $$$OK<br>
ClassMethod Exists(MachineName As %String, InstanceName As %String, ByRef Instance As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

ClassMethod Get(MachineName As %String, InstanceName As %String, ByRef Properties As %String) As %Status
{
}

/// Get an Instance properties.<br>
/// Gets an Instance properties from the security database.<br>
/// Parameters:<br>
/// Event - Object handle to an Instance record<br>
/// Return values:<br>
/// Properties - See the Get method for more information on properties returned
ClassMethod GetProperties(Instance As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
}

ClassMethod Modify(MachineName As %String, InstanceName As %String, ByRef Properties As %String) As %Status
{
}

ClassMethod Install(MachineName As %String, InstanceName As %String) As %Status
{
}

Method Validate() As %Status [ Internal ]
{
}

/// Called from %Save().<br>
/// Verify that the property values are ok.<br>
Method %OnValidateObject() As %Status [ Internal ]
{
}

/// List Instances.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of Device names<br>
/// <var>"*"</var> - All records match<br>
/// <var>"String,String1"</var> - Any records matching one of these elements<br>
/// <var>"String*"</var> - Any record starting with "String"<br>
/// <var>"String,String1*,String2"</var> - Any record mathing one of these elements, or starting with "String1"<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String) As %Query(ROWSPEC = "MachineName:%String,InstanceName:%String,Directory:%String,Description:%String,LastInstall:%String,LastInstallTime:%String,LastInstallUsername:%String,State:%String,Status:%String,Error:%String,CacheGroup:%String,CacheUser:%String,ManagerGroup:%String,SecurityType:%String,Unicode:%Boolean") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, MachineNames As %String = "*", InstanceNames As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
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
<Data name="InstancesDefaultData">
<Value name="1">
<Value>CacheGroup</Value>
</Value>
<Value name="2">
<Value>CachePassword</Value>
</Value>
<Value name="3">
<Value>CacheUser</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Directory</Value>
</Value>
<Value name="6">
<Value>Error</Value>
</Value>
<Value name="7">
<Value>Installed</Value>
</Value>
<Value name="8">
<Value>InstanceName</Value>
</Value>
<Value name="9">
<Value>LastInstall</Value>
</Value>
<Value name="10">
<Value>LastInstallTime</Value>
</Value>
<Value name="11">
<Value>LastInstallUsername</Value>
</Value>
<Value name="12">
<Value>MachineName</Value>
</Value>
<Value name="13">
<Value>ManagerGroup</Value>
</Value>
<Value name="14">
<Value>SecurityType</Value>
</Value>
<Value name="15">
<Value>State</Value>
</Value>
<Value name="16">
<Value>Status</Value>
</Value>
<Value name="17">
<Value>Unicode</Value>
</Value>
</Data>
<DataLocation>^Provider("InstancesD")</DataLocation>
<DefaultData>MachinesDefaultData</DefaultData>
<IdLocation>^Provider("InstancesD")</IdLocation>
<IndexLocation>^Provider("InstancesI")</IndexLocation>
<StreamLocation>^Provider("InstancesS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
