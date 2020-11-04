Include (%systemInclude, %syConfig)

IncludeGenerator %systemInclude

/// This class contains methods which are inherited by other config classes.
Class Config.CommonSingleMethods Extends Config.CommonMethods [ System = 4 ]
{

/// List of properties which are in the class but not in the CPF file.<br>
/// These are properties which are combined with other properties to create
/// a property in the CPF file. This will be overridden in classes which require it.<br>
Parameter PROPERTIESNOTINCPF [ Internal ];

/// List of properties which may or may not be in the CPF file.<br>
/// They have a corresponding %Boolean
/// property to determine if they are in the file or not. For example, the property
/// "Asyncwij" will have a %Boolean "AsyncwijPresent" property associated with it.<br>
/// This will be overridden in classes which require it.<br>
Parameter PROPERTIESMAYBEINCPF [ Internal ];

/// List of properties in the CPF file which are constructed from multiple different 
/// properties in this class.<br>
/// This will be overridden in classes which require it.<br>
Parameter PROPERTIESCOMBINEDINCPF [ Internal ];

/// This parameter governs how the class creates audit records.<br>
/// <b>Value = 0</b> - Class contains a single entry (SQL, Net, etc.)<br>
/// <b>Value = 1</b> - Class contains multiple entries (Databases, Namespaces, etc.)<br>
/// <b>Value = 2</b> - Class deals with mappings (MapGlobals, MapRoutines, MapPackages, MapShards.)<br>
Parameter SECTIONTYPE [ Internal ] = 0;

Parameter NOTRANSACTIONS [ Internal ] = 0;

/// Create a section in a CPF file.<br>
/// <br>
/// This is used internally, and should only be called from the 
/// <CLASS>Config.CPF.<METHOD>Read</METHOD></CLASS> method.
/// Parameters:<br>
/// <b>Properties (byref)</b> - List of the properties to add in Properties(Name)=Value format.<br>
/// See the subclass for a list of valid properties.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <b>Flags</b> - Bit string of options to perform.<br>
/// See the <METHOD>Open</METHOD> method for values.<br>
/// <br>
/// Return values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Create(ByRef Properties As %String, CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %Status [ Internal ]
{
}

/// Stub called during create, individual classes may override this.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, ByRef Props As %String) [ Internal ]
{
}

/// Get a sections properties from a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <br>
/// Return values:<br>
/// <b>Properties (byref)</b> - List of the properties in Properties(Name)=Value format. 
/// See the subclass for a list of valid properties.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Get(ByRef Properties As %String, ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %Status
{
}

/// Returns the properties from a section in a CPF file by value in $list format<br>
/// <br>
/// Parameters:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <br>
/// Return value:
/// <br>&nbsp&nbsp&nbsp&nbsp&nbsp
///      $lb(%Status,Result)
/// <br>&nbsp&nbsp&nbsp&nbsp&nbsp
///      where Result=$LB($LB(property name,value),...) for each property in the section
/// <br>
ClassMethod GetList(ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %Status
{
}

/// Get a sections properties from a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Config</b> - Object handle to config section<br>
/// <br>
/// Return values:<br>
/// <b>Properties (byref)</b> - List of the properties in Properties(Name)=Value format. 
/// See the subclass for a list of valid properties.<br>
ClassMethod GetProperties(Obj As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Modify a sections properties in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Properties (byref)</b> - List of the properties to modify in Properties(Name)=Value format.
/// See the subclass for a list of valid properties. If a specific property is not passed in the
/// properties array, the value is not modified.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <b>Flags</b> - Bit string of options to perform if the object is later saved with the %Save() method.
/// See the <METHOD>Open</METHOD> method for values.<br>
/// <br>
/// Return values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Modify(ByRef Properties As %String, ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %Status
{
}

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// If a delete operation, then Obj is the NAME of the item which was deleted
/// since the oject itself has already been deleted.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
/// 2 - Delete<br>
ClassMethod MoveToActive(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Open an instance of an section object in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
/// <b>Flags</b> - (From %syConfig.inc) Bit string of options to perform if the object is later saved with the %Save() method.<br>
/// <var>Bit $$$CPFSave</var> - Save - Save data to config database.<br>
/// <var>Bit $$$CPFWrite</var> - Write - Write config database to CPF file.<br>
/// <var>Bit $$$CPFActivate</var> - Activate - Copy changes to ^CONFIG global, and make active on system.<br>
/// By default, all these bits are set, and you should normally not pass this parameter. 
/// If you are modifying a CPF file which is not the active CPF file, Bit $$$CPFActivate is ignored.<br>
/// <br>
/// <br>
/// Return Values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Open(ByRef CPFFile As %String = "", concurrency As %Integer = -1, ByRef Status As %Status, Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %ObjectHandle
{
}

/// Validate properties in passed array.<br>
/// Validate an array of properties passed in to determine if they are really properties of
/// the class. A property will match if it is spelled correctly. Case does not have to match.
/// After the property is validated as being a member of this class, the data value of the property
/// is evaluated to make sure it passes the data constraints of the property.
/// Parameters:<br>
/// <b>Properties (byref)</b> - List of the properties to add in Properties(Name)=Value format.
/// Properties(Name,"Line")=CPFLineNumber should be set to the line number in the CPF file if
/// being read in (internal use only.)<br>
/// See the list of properties for more information.<br>
/// <b>DontValidateProperties</b> - Comma separated list of properties not to validate.<br>
/// <b>Flags</b> - Bit string of options to perform.<br>
/// <var>Bit 0</var> - All properties must be specified in the array.<br> 
ClassMethod Validate(ByRef Properties As %String, DontValidateProperties As %String = "", MayBePresent As %String = "", Flags = 0) As %Status [ Internal ]
{
}

/// Write a section to the CPF file from the Config database.<br>
/// This method assumes that the CPF file has been opened, and USED.<br>
/// <br>
/// Parameters:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file. The file must have a .CPF file extension if specified.<br>
ClassMethod WriteSection(CPFFile As %String) As %Status [ Internal ]
{
}

/// Callback method executed during a delete.<br>
/// For this type of CPF section, we don't allow it to be deleted.
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal, Private ]
{
}

/// This callback method is executed when a %New() on the object is done.<br>
Method %OnNew(initvalue As %CacheString) As %Status [ Internal, Private ]
{
}

}
