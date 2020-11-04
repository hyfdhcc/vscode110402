Include (%systemInclude, %syConfig)

IncludeGenerator %systemInclude

/// This class contains methods which are common (inherited) by classes which
/// manipulate namespace mappings in the CPF file.<br>
Class Config.GenericMapMethods Extends Config.CommonMethods [ LegacyInstanceContext, System = 4 ]
{

/// This parameter governs how the class creates audit records.<br>
/// <b>Value = 0</b> - Class contains a single entry (SQL, Net, etc.)<br>
/// <b>Value = 1</b> - Class contains multiple entries (Databases, Namespaces, etc.)<br>
/// <b>Value = 2</b> - Class deals with mappings (MapGlobals, MapRoutines, MapPackages.)<br>
Parameter SECTIONTYPE = 3;

/// Determines if the Name specified in the index should be capitalized.<br>
Parameter CAPITALNAME = 0;

/// Create a mapping in the CPF file.<br>
/// Parameters:<br>
/// <b>Namespace</b> - Namespace to create mapping for.<br>
/// <b>Name</b> - Name of the mapping.<br>
/// <b>Properties</b> - Array of properties used to create the mapping. See the subclass
/// for a list of valid properties.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file.<br>
/// <b>Flags</b> - Bit string of flags which governs how the mappings are added.<br>
/// <b>Bit $$$CPFSave</b> - Save the Mappings to the CPF object.<br>
/// <b>Bit $$$CPFWrite</b> - Write the CPF object to the CPF file.<br>
/// <b>Bit $$$CPFActivate</b> - Activate the Mappings on the system if the CPF file is the current active file.<br>
/// By default, all these bits are set, and you should normally not pass this parameter. 
/// If you are modifying a CPF file which is not the active CPF file, Bit $$$CPFActivate is ignored.<br>
/// If you have a batch of updates to do to the same namespace,
/// then you should pass only Bit $$$CPFSave for each call. Then when creating the last one, don't pass this parameter
/// (default=All bits). This will cause all the previous additions to be written to the CPF file and activated
/// all at once.<br>
/// If you want to update several different namespaces at the same time you should use the following
/// mechanism:<br>
/// 1) Pass the flag $$$CPFSave on all the calls to update the object 
/// (without writing to the CPF or activating it.) 
/// You could also pass the Write to CPF flag here if you want all your changes written out
/// to the CPF immediately.<br>
/// 2) When you are finished with your updates, call Config.CPF.Write() to write out your changes
/// to the CPF file (if you didn't pass the write to cpf flag in step #1)<br>
/// 3) Now Call Config.CPF.Activate() to load and activate all the new mappings.<br>
/// Return values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Create(ID As %String, Name As %String, ByRef Properties As %String, ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate})
{
}

/// No default mapping section in a CPF file.<br>
ClassMethod Default(CPFFile As %String, Platform As %String) As %Status [ Internal ]
{
}

/// Delete a mapping from a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Namespace</b> - Namespace to delete the mapping from.<br>
/// <b>Name</b> - Name of the mapping to delete.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file.<br>
/// <b>Flags</b> - Bit string of options to perform. See the <METHOD>Create</METHOD> method for values.<br>
/// <br>
/// Return values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Delete(ID As %String, Name As %String, ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %Status
{
}

/// Checks for the existence of a mapping in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Namespace</b> - Namespace of the mapping.<br>
/// <b>Name</b> - Name of the mapping to check existence of.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file.<br>
/// <b>Flags</b> - Bit string of options to perform if the object is later saved with the %Save() method.
/// See the <METHOD>Create</METHOD> method for values.<br>
/// <br>
/// Return values:<br>
/// If Value of the method = 0 (Mapping does not exist, or some error occured)<br>
/// <b>Obj</b> = Null<br>
/// <b>Status</b> = Mapping "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (Mapping exists)<br>
/// <b>Obj</b> = Object handle to Mapping<br>
/// <b>CPFFile</b> = Name of the CPF file the properties were retrieved from.<br>
/// <b>Status</b> = MapGlobal "x" already exists<br>
/// <br>
ClassMethod Exists(ID, Name As %String, ByRef Obj As %ObjectHandle, ByRef Status As %Status, ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %Boolean
{
}

/// Get a mapping's properties from a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>ID</b> - ID of the mapping.<br>
/// <b>Name</b> - Name of the instance within the mapping to retrieve.<br>
/// <b>CPFFile</b> - Name of the CPF file to use, Default=current active CPF file.<br>
/// <br>
/// Return values:<br>
/// <b>Properties (byref)</b> - List of the properties in Properties(Name)=Value format. See the subclass
/// for a list of valid properties.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the properties were retrieved from.<br>
ClassMethod Get(ID As %String, Name As %String, ByRef Properties As %String, ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %Status
{
}

/// Returns the properties from a instance of a mapping section from a CPF file by value in $list format<br>
/// <br>
/// Parameters:<br>
/// <b>ID</b> - Instance ID for the mapping.<br>
/// <b>Name</b> - Name of the instance within the mapping ID to retrieve.<br>
/// <b>CPFFile</b> - Name of the CPF file to use, Default=current active CPF file.<br>
/// <br>
/// Return value:
/// <br>&nbsp&nbsp&nbsp&nbsp&nbsp
///      $lb(%Status,Result)
/// <br>&nbsp&nbsp&nbsp&nbsp&nbsp
///      where Result=$LB($LB(property name,value),...) for each property in the instance of the section
/// <br>
ClassMethod GetList(ID As %String, Name As %String, ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %Status
{
}

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
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Modify a mapping in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Namespace</b> - Namespace of the mapping.<br>
/// <b>Name</b> - Name of the mapping to modify.<br>
/// <b>Properties (byref)</b> - List of the properties to modify in Properties(Name)=Value format.  See the subclass
/// for a list of valid properties. If a specific property is not passed in the
/// properties array, the value is not modified.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file.<br>
/// <b>Flags</b> - Bit string of options to perform. See the <METHOD>Create</METHOD> method for values.<br>
/// <br>
/// <br>
/// Return values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Modify(ID As %String, Name As %String, ByRef Properties As %String, ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %Status
{
}

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// If a delete operation, then Obj is the NAME of the item which was deleted
/// since the oject itself has already been deleted.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Insert<br>
/// 1 - Modify<br>
/// 2 - Delete<br>
ClassMethod MoveToActive(Obj As %ObjectHandle = "", Flags As %Integer = 0) As %Status [ Internal ]
{
}

/// Open an instance of a mapping object in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Name</b> - Name of the mapping to open<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file.<br>
/// <b>Flags</b> - Bit string of options to perform if the object is later saved with the %Save() method.
/// See the <METHOD>Create</METHOD> method for values.<br>
/// <br>
/// Return Values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the object was opened in.<br>
ClassMethod Open(ID As %String, Name As %String, ByRef CPFFile As %String = "", concurrency As %Integer = -1, ByRef Status As %Status, Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %ObjectHandle
{
}

/// Write a section to the CPF file from the Config database for s single namespace.<br>
/// This method assumes that the CPF file has been opened, and USED.<br>
/// <br>
/// Parameters:<br>
/// <b>Namespace</b> - Namespace of the mapping.<br>
/// <b>CommentNext</b> by ref - Array of comments to be written out before the next section is written.<br> 
/// <b>CPFFile</b> - Name of the CPF file being written.<br>
ClassMethod WriteSectionID(ID As %String, ByRef CommentNext As %String, CPFFile As %String) As %Status [ Internal ]
{
}

/// Set the Section header of the index to the class name.<br>
Method %OnNew(initvalue As %CacheString) As %Status [ Internal, Private ]
{
}

}
