Include (%syConfig, ISCFILEDIR)

/// This class allows you to modify and view the [Journal] section of the CPF file through
/// programatic APIs. While properties are usually modified through the System Management
/// portal, there may be some occasion where modifying them through the API's is best
/// for your system. In all the Config methods, if you do not specify the CPFFile parameter,
/// the currently active CPF file is used. If you wish to modify a CPF file which is not
/// the currently active one, then specify the CPFFile you wish to modify in the method call.<br>
/// The Flags parameter does not normally need to be specified; the defaults are usually
/// sufficient for most cases.<br>
/// You can use the provided API's (Get/Modify) to modify the properties by passing 
/// in the correct parameters.<br>
/// <br>
/// NOTE: You cannot use object syntax to directly modify the [Journal] parameters. You MUST
/// use the API's found in this class.
/// <br>
/// <br>
/// EXAMPLE:<br>
/// <br>
/// <pre>
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.Journal).Get(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties
/// Properties("AlternateDirectory")="C:\Cache\Mgr\Journal\"
/// Properties("BackupsBeforePurge")=2
/// Properties("CurrentDirectory")="C:\Cache\Mgr\Journal\"
/// Properties("DaysBeforePurge")=2
/// Properties("FileSizeLimit")=2048
/// Properties("FreezeOnError")=0
/// Properties("JournalFilePrefix")=""
/// Properties("JournalcspSession")=1
/// %SYS>s Properties("FileSizeLimit")=1024
/// %SYS>s Status=##Class(Config.Journal).Modify(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.Journal Extends (%Persistent, Config.CommonSingleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// Setting this flag keeps the journal updates outside of a transaction
/// When %Save() is called in the API's.<br>
Parameter NOTRANSACTIONS = 1;

/// Alternate journal directory.<br>
Property AlternateDirectory As %SysPath(MAXLEN = 256);

Method AlternateDirectorySet(Directory As %SysPath) As %Status [ Internal ]
{
}

/// Number of backups before the journal files are automatically purged.<br>
Property BackupsBeforePurge As %Integer(MAXVAL = 10, MINVAL = 0) [ InitialExpression = 2, Required ];

/// Primary journal directory.<br>
Property CurrentDirectory As %SysPath(MAXLEN = 256);

Method CurrentDirectorySet(Directory As %SysPath) As %Status [ Internal ]
{
}

/// Number of days before the journal files are purged.<br>
Property DaysBeforePurge As %Integer(MAXVAL = 100, MINVAL = 0) [ InitialExpression = 2, Required ];

/// Maximum size of each journal file in MB.<br>
Property FileSizeLimit As %Integer(MAXVAL = 4079, MINVAL = 0) [ InitialExpression = 1024, Required ];

/// Freeze the system if there is an error writing to the journal.<br>
/// If this option is set to true (1), as soon as the error occurs all global activities 
/// that are normally journaled are blocked, which causes other jobs to block. 
/// The typical outcome is that the system goes into a hang state until the journaling problem is 
/// resolved, and then resumes running. While Caché is hanging, the administrator can take 
/// corrective measures, such as freeing up space on a disk that is full, switching the journal 
/// to a new disk, etc. This option has the advantage that once the problem is fixed and 
/// Caché resumes running, no journal information has been lost. 
/// It has the disadvantage that the system is less available while the problem is being solved.<br>
/// If this option is set to false (0), when a journaling error occurs journaling is 
/// entirely disabled, while the system continues running as normal. 
/// The system sends a console message to alert the administrator, who can fix the problem and then
/// run ^JRNSWTCH at the console to restart journaling. 
Property FreezeOnError As Security.Datatype.BooleanYN [ InitialExpression = 0, Required ];

/// %cspSession global will be mapped to CACHETEMP and not journaled.<br>
Property JournalcspSession As Security.Datatype.BooleanYN [ InitialExpression = 0, Required ];

/// Prefixes journal file names with this string.<br>
/// May be used to distinguish journal files from different instances in the same directory.<br>
Property JournalFilePrefix As %String(MAXLEN = 64, MINLEN = 0);

ClassMethod IsJrnDirValid(Directory As %String, Prefix As %String) As %Status [ Internal ]
{
}

/// Validate the journal file prefix name.<br>
ClassMethod JournalFilePrefixIsValid(Val As %String) As %Status [ Internal ]
{
}

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Load the parameters into ^CONFIG() as activate.<br>
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

ClassMethod Verify(Directory As %String, Prefix As %String) As %Status [ Internal ]
{
}

/// Called from %Save().<br>
Method %OnValidateObject() As %Status [ Internal ]
{
}

Storage Default
{
<Data name="JournalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AlternateDirectory</Value>
</Value>
<Value name="3">
<Value>BackupsBeforePurge</Value>
</Value>
<Value name="4">
<Value>CurrentDirectory</Value>
</Value>
<Value name="5">
<Value>DaysBeforePurge</Value>
</Value>
<Value name="6">
<Value>FileSizeLimit</Value>
</Value>
<Value name="7">
<Value>FreezeOnError</Value>
</Value>
<Value name="8">
<Value>JournalcspSession</Value>
</Value>
<Value name="9">
<Value>JournalFilePrefix</Value>
</Value>
<Value name="10">
<Value>Comments</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>configDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
