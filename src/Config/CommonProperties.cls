/// This class contains properties which are included by classes which
/// manipulate sections in the CPF file.<br>
Class Config.CommonProperties [ System = 4 ]
{

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// Embedded comments in the CPF file.<br>
Property Comments As list Of CommentList;

/// CPF file which the object maps to.<br>
Property CPFFile As %String(MAXLEN = 255, MINLEN = 1) [ InitialExpression = {$p($zu(86),"*")}, Transient ];

/// When the CPF file gets set, convert the file to an internal name, and store it as
/// part of the index.<br>
/// Basically, this strips off the directory specification and the .CPF file extension, and
/// uses the resulting name as part of the index. On windows and VMS, the name is uppercased,
/// on unix it is not. For example:<br><br>
/// c:\abc\cache.cpf ---> CACHE<br>
/// /abc/cache.cpf ---> cache<br>
/// dka100:[abc]cache.cpf---> CACHE<br>
/// NOTE: This is the same code which exists in Config.CommonMapProperties<br>
Method CPFFileSet(Val) As %Status [ Internal ]
{
}

/// Internal name of the CPF file.<br>
/// This property should not be set directly. It is updated when the CPFFile property is set.<br>
/// When the CPFFile property is set, the CPFFile name dictates what is set here as follows:<br>
/// c:\abc\cache.cpf ---> CACHE<br>
/// /abc/cache.cpf ---> cache<br>
/// dka100:[abc]cache.cpf---> CACHE<br>
Property CPFName As %String(MAXLEN = 255, MINLEN = 1) [ InitialExpression = {##Class(Config.CPF).GetName($p($zu(86),"*"))}, Internal, Required ];

/// Flags governing how the object is processed when %Save() is called.<br>
/// For normal operations, all bits should be set.<br>
/// <b>Bit $$$CPFSave</b> - Save object to disk.<br>
/// <b>Bit $$$CPFWrite</b> - Write CPF file from object.<br>
/// <b>Bit $$$CPFActivate</b> - Activate object into memory if CPFFile is the same as what is currently active.<br>
/// <b>Bit $$$CPFAvoidBackupDB</b> - Don't Add/Remove the Database to Backup DB list.<br>
Property Flags As %Integer [ InitialExpression = 7, Transient ];

/// Name of the object instance.<br>
Property Name As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Set to the name of the class.<br>
Property SectionHeader As %String(MAXLEN = 255, MINLEN = 1) [ Internal, Required ];

}
