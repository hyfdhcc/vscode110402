Include (%syConfig, %syAudit, %sySystem, %syEMS, %occErrors, %ems)

IncludeGenerator %systemInclude

/// This class contains methods which are common (inherited) by classes which
/// manipulate sections in the CPF file.<br>
Class Config.CommonMethods Extends (%Library.RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// This parameter governs how the class creates audit records.<br>
/// <b>Value = 0</b> - Class contains a single entry (SQL, Net, etc.)<br>
/// <b>Value = 1</b> - Class contains multiple entries (Databases, Namespaces, etc.)<br>
/// <b>Value = 2</b> - Class deals with mappings (MapGlobals, MapRoutines, MapPackages, MapShards.)<br>
Parameter SECTIONTYPE = 0;

Parameter EMSSERVICE [ Internal ] = "Config";

/// Activate sections of the CPF file.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the activation. If "", 
/// then load everything, only called from STU.<br>
/// If a delete operation, then Obj is the NAME of the item which was deleted
/// since the oject itself has already been deleted.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Insert<br>
/// 1 - Modify<br>
/// 2 - Delete<br>
ClassMethod Activate(Obj As %ObjectHandle = "", Flags As %Integer = 0) As %Status [ Internal ]
{
}

/// Retrieves comments from the object and places them in an array.<br>
Method DecodeComments(ByRef Comments As %String) As %Status [ Internal ]
{
}

/// No default section in a CPF file.<br>
ClassMethod Default(CPFFile As %String, Platform As %String) As %Status [ Internal ]
{
}

/// Takes comments from the array, and places them into the object.<br>
Method EncodeComments(ByRef Properties As %String) As %Status [ Internal ]
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

/// Move the CPF data into the active config global.<br>
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
ClassMethod MoveToActive(Obj As %ObjectHandle, Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Parse a line from the CPF file and return the data line without the comment.<br>
/// Parameters:<br>
/// <b>Data</b> by ref - All data from a line in the CPF file after the "=" sign.<br>
/// Return values:<br>
/// <b>Data</b> - Data from the CPf file with any trailing comment stripped off.<br>
/// <b>Comment</b> - Trailing comment from the data line.<br>
/// <br>"Data #; comment" should return Data="Data" and Comment=" #; comment
/// <br>"Data // comment # 1" should return Data="Data" and Comment=" // comment # 1"<br>
ClassMethod ParseComment(Section As %String, Name As %String, ByRef Data As %String, ByRef Comment As %String) As %Status [ Internal ]
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

/// Extent query used by EMS. Default Extent doesn't work for CONFIG, so this replaces it.
Query Extent() As %Query(ROWSPEC = "ID:%String") [ Internal ]
{
}

ClassMethod ExtentExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod ExtentClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ExtentExecute ]
{
}

ClassMethod ExtentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ExtentExecute ]
{
}

/// Called from %OnBeforeSave. Provides a way for a specific class to override the 
/// EMS.Restricted() check when the Instance is managed. Used when a few properties in
/// a class (like Config.SQL.JDBCGatewayPort) are not managed by EMS.
Method EMSAllowEdit(insert As %Boolean) As %Boolean [ Internal ]
{
}

}
