Include (%systemInclude, %syConfig)

IncludeGenerator %systemInclude

Class Provider.CommonMethods Extends %Persistent [ System = 4 ]
{

/// Determines if the Name specified in the index should be capitalized.<br>
Parameter CAPITALNAME = 0;

/// This parameter governs how the class creates audit records.<br>
/// <b>Value = 0</b> - Class contains a single entry (SQL, Net, etc.)<br>
/// <b>Value = 1</b> - Class contains multiple entries (Databases, Namespaces, etc.)<br>
/// <b>Value = 2</b> - Class deals with mappings (MapGlobals, MapRoutines, MapPackages.)<br>
Parameter SECTIONTYPE = 1;

/// Create a section instance in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Name</b> - Name of the instance to create.<br>
/// <b>Properties (byref)</b> - List of the properties to add in Properties(Name)=Value format.
/// See the subclass for a list of valid properties.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <b>Flags</b> - (From %syConfig.inc) Bit string of options to perform.<br>
/// <var>Bit $$$CPFSave</var> - Save data to config database.<br>
/// <var>Bit $$$CPFWrite</var> - Write config database to CPF file.<br>
/// <var>Bit $$$CPFActivate</var> - Copy changes to ^CONFIG global, and make active on system.<br>
/// By default, all these bits are set, and you should normally not pass this parameter. 
/// If you are modifying a CPF file which is not the active CPF file, Bit $$$CPFActivate is ignored.<br>
/// If you have a batch of updates to do (like adding several devices, databases, or namespaces),
/// then you should pass only Bit $$$CPFSave for each call. Then when creating the last one, don't pass any
/// bits. This will cause all the previous additions to be written to the CPF file and activated
/// all at once.<br>
/// <br>
/// Return values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Create(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Stub called during create, individual classes may override this.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal, Private ]
{
}

/// Delete a section instance from a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Name</b> - Name of the instance to delete.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <b>Flags</b> - Bit string of options to perform. See the <METHOD>Create</METHOD> method for values.<br>
/// <br>
/// Return values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Delete(Name As %String) As %Status
{
}

/// Exists.<br>
/// This method checks for the existence of a section instance in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Name</b> - Name of the instance to check existence of.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <b>Flags</b> - Bit string of options to perform if the object is later saved with the %Save() method.
/// See the <METHOD>Create</METHOD> method for values.<br>
/// <br>
/// Return values:<br>
/// If Value of the method = 0 (Instance does not exist, or some error occured)<br>
/// <b>Obj</b> = Null<br>
/// <b>Status</b> = Instance "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (Instance exists)<br>
/// <b>Obj</b> = Object handle to Instance<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
/// <b>Status</b> = Instance "x" already exists<br>
ClassMethod Exists(Name As %String, ByRef Obj As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// Get a section instances properties from a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Name</b> - Name of the instance to get.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <br>
/// Return values:<br>
/// <b>Properties (byref)</b> - List of the properties in Properties(Name)=Value format. See the subclass for a list of valid properties.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Get(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Returns the properties from a section instance in a CPF file by value in $list format<br>
/// <br>
/// Parameters:<br>
/// <b>Name</b> - Name of the instance to get.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <br>
/// Return value:
/// <br>&nbsp&nbsp&nbsp&nbsp&nbsp
///      $lb(%Status,Result)
/// <br>&nbsp&nbsp&nbsp&nbsp&nbsp
///      where Result=$LB($LB(property name,value),...) for each property in the instance of the section
/// <br>
ClassMethod GetList(Name As %String, ByRef PropertyList As %List) As %Status
{
}

/// Returns a comma separated list of properties in the class.<br>
/// This is used internally by some of the API's.
/// Parameters:<br>
/// <b>IgnoreProperties</b> - Comma separated list of properties NOT to return<br>
/// <b>Properties</b> by ref - Comma separated list of properties for the class, with IgnoreProperties removed<br>
ClassMethod GetClassProperties(IgnoreProperties As %String = "", ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Get a sections properties from a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Obj</b> - Object handle to a section in the CPF object<br>
/// <br>
/// Return values:<br>
/// <b>Properties (byref)</b> - See the subclass for more information on 
/// the array of Properties returned.<br>
ClassMethod GetProperties(Obj As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Modify a section instance in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Name</b> - Name of the instance to modify.<br>
/// <b>Properties (byref)</b> - List of the properties to modify in Properties(Name)=Value format. See the subclass for a list of valid properties. 
/// If a specific property is not passed in the properties array, the value is not modified.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <b>Flags</b> - Bit string of options to perform. See the <METHOD>Create</METHOD> method for values.<br>
/// <br>
/// Return values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Modify(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Open a section instance object in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Name</b> - Name of the instance to open<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <br>
/// Return Values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Open(Name As %String, concurrency As %Integer = -1, ByRef Status As %Status) As %ObjectHandle
{
}

/// Move Validate to a common method
ClassMethod ValidateCM(Name As %String) As %Status [ Internal ]
{
}

ClassMethod ValidateAllCM() As %Status [ Internal ]
{
}

/// Callback called when a new instance is instantiated<br>
Method %OnNew(initvalue As %CacheString) As %Status [ Internal, Private ]
{
}

/// Callback which happens during the %Save operation, after the object globals
/// have been updated. <br> 
/// We are still in a transaction here. Returning a failure code
/// will cause the transaction to be rolled back. 
Method %OnAfterSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// Callback which happens during the %Save operation, before the object globals
/// have been updated.<br>
/// Returning a failure code causes the %Save() operation to fail. 
/// We are not in a transaction here.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// This callback is called as part of the Delete operation.<br>
/// It is called after the transaction is already committed.
ClassMethod %OnAfterDelete(oid As %ObjectIdentity) As %Status [ Internal, Private ]
{
}

/// This callback is called before the transaction is committed.<br>
/// Any error here will cause the transaction to be rolled back.
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal, Private ]
{
}

/// Stub method, may be overwritten by the infividual class.
ClassMethod %OnDeleteCallBack(Obj As %ObjectHandle) As %Status [ Internal, Private ]
{
}

/// Stub method, may be overwritten by the individual class.
ClassMethod %OnAfterSaveCallBack(insert As %Integer, Obj As %ObjectHandle) As %Status [ Internal, Private ]
{
}

/// Stub method, may be overwritten by the individual class.
ClassMethod %OnBeforeSaveCallBack(insert As %Integer, Obj As %ObjectHandle) As %Status [ Internal, Private ]
{
}

Storage Default
{
<Data name="CommonMethodsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Provider.CommonMethodsD</DataLocation>
<DefaultData>CommonMethodsDefaultData</DefaultData>
<IdLocation>^Provider.CommonMethodsD</IdLocation>
<IndexLocation>^Provider.CommonMethodsI</IndexLocation>
<StreamLocation>^Provider.CommonMethodsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
