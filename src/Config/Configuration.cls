Include (%occErrors, %sySystem)

/// This class and all its methods are deprecated. See the remaining  
/// Config classes to manipulate individual sections in the cache.cpf file.
/// 
Class Config.Configuration Extends %SYSTEM.Help [ Abstract, System = 4 ]
{

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.CPF.Activate() method instead.<br>
ClassMethod Activate() As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
ClassMethod StartupConfiguration() As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Databases.Create() method instead.<br>
ClassMethod AddDatabase(Name As DBName, Directory As %String, Server As %String = "", MountAtStartup As %Boolean = 0, ClusterMountMode As %Boolean = 0, MountRequired As %Boolean = 0) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.ECPServers.Create() method instead.<br>
ClassMethod AddDataServer(Name As %String, Address As %String = "", Port As %Integer = 1972, IsMirrorConnection As %Boolean = 0) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Devices.Create() method instead.<br>
ClassMethod AddDevice(Name As %String, PhysicalDevice As %String = "", Type As %String = "", SubType As %String = "", Prompt As %String = "", OpenParameters As %String = "", AlternateDevice As %String = "", Description As %String = "", Alias As %String = "") As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.MapGlobals.Create() method instead.<br>
ClassMethod AddGlobalMapping(Namespace As NSName, Global As %String, Subscript As %String = "", DataLocation As %String, LockLocation As %String = "", Collation As %Integer = 5, SLMLocation As %String = "") As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.CPF.Activate() method instead.<br>
/// This method currently performs no action, and returns 1 as its status.<br>
/// CPF activation methods only work with the CPF file which was originally activated 
/// starting with version 2009.1. Changes can be made to the activated CPF file, and then 
/// activated by the Config.CPF.Activate() method. You cannot import a differently 
/// named CPF file and activate it. The naming of which CPF file to use only happens at 
/// system startup. An alternate method to activate a different CPF file is to
/// to copy the entire file which you want to activate into the one which is 
/// currently activated, and then call Config.CPF.Activate().
/// For example if dka100:[cache]cache.cpf is active:<br><br>
/// s x=##Class(%Library.File).CopyFile("dka100:[cache]cache.cpf_backup","dka100:[cache]cache.cpf")<br>
/// s x=##Class(Config.CPF).Activate()<br>
ClassMethod CPFImport(CPFFile As %String = "") As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Namespaces.Create() method instead.<br>
ClassMethod AddNamespace(Name As NSName, Globals As DBName, Routines As DBName, SysGlobals As DBName = "CACHESYS", SysRoutines As DBName = "CACHESYS", Library As DBName = "CACHELIB", TempGlobals As DBName = "CACHETEMP", Description As %String = "") As %Status
{
}

/// Internal method.
/// Performs some cross checks. For instance, if JoinCluster is set, the ECP service
/// must be on and the PIJ directory must be non empty.
/// 
Method ValidateCfg() As %Status [ Internal ]
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Databases.Create(), and SYS.Database.CreateDatabase() instead.<br>
ClassMethod CreateDatabase(Name As DBName, Directory As %String, Size As %Integer = 1, BlockSize As %Integer = 8192, MountAtStartup As %Boolean = 0, ClusterMountMode As %Boolean = 0, MountRequired As %Boolean = 0, EncryptedDB As %Boolean = 0, Resource As %String = "%DB_%DEFAULT", GlobalJournalState As %Integer) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
ClassMethod AllSignOnsStatus(ByRef CurValue As %Boolean, NewValue As %Boolean) As %Status [ Internal ]
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
ClassMethod DatabaseRWStatus(ByRef CurValue As %Boolean, NewValue As %Boolean) As %Status [ Internal ]
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
ClassMethod TelnetSignOnsStatus(ByRef CurValue As %Boolean, NewValue As %Boolean) As %Status [ Internal ]
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Databases.Delete() and SYS.Databases.DeleteDatabase() methods instead.<br>
ClassMethod DeleteDatabase(Name As DBName) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.ECPServers.Get() method instead.<br>
ClassMethod GetDataServer(Name As %String = "", ByRef Address As %String, ByRef Port As %Integer) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Databases.Get() method instead.<br>
ClassMethod GetDatabase(Name As DBName, ByRef Directory As %String, ByRef Server As %String, ByRef MountAtStartup As %Boolean, ByRef ClusterMountMode As %Boolean, ByRef MountRequired As %Boolean) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Devices.Get() method instead.<br>
ClassMethod GetDevice(Name As %String, ByRef PhysicalDevice As %String, ByRef Type As %String, ByRef SubType As %String, ByRef Prompt As %String, ByRef OpenParameters As %String, ByRef AlternateDevice As %String, ByRef Description As %String, ByRef Alias As %String) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.MapGlobals.Get() method instead.<br>
ClassMethod GetGlobalMapping(Namespace As NSName, Global As %String, Subscript As %String, ByRef Database As %String, ByRef LockDatabase As %String, ByRef Collation As %Integer, ByRef SLMLocation As %String) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Namespaces.Get() method instead.<br>
ClassMethod GetNamespace(Name As NSName, ByRef Globals As DBName, ByRef Routines As DBName, ByRef SysGlobals As DBName, ByRef SysRoutines As DBName, ByRef Library As DBName, ByRef TempGlobals As DBName) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
ClassMethod GetServerPlatform() As %String [ Internal ]
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.ECPServers.Modify() method instead.<br>
ClassMethod ModifyDataServer(Name As %String, Address As %String, Port As %Integer) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Databases.Modify() method instead.<br>
ClassMethod ModifyDatabase(Name As DBName, Directory As %String, Server As %String, MountAtStartup As %Boolean, ClusterMountMode As %Boolean, MountRequired As %Boolean) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Devices.Modfy() method instead.<br>
ClassMethod ModifyDevice(Name As %String, PhysicalDevice As %String, Type As %String, SubType As %String, Prompt As %String, OpenParameters As %String, AlternateDevice As %String, Description As %String, Alias As %String) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.MapGlobals.Modify() method instead.<br>
ClassMethod ModifyGlobalMapping(Namespace As NSName, Global As %String, Subscript As %String, DataLocation As %String, LockLocation As %String, Collation As %Integer, SLMLocation As %String) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Namespaces.Modify() method instead.<br>
ClassMethod ModifyNamespace(Name As NSName, Globals As DBName, Routines As DBName, SysGlobals As DBName, SysRoutines As DBName, Library As DBName, TempGlobals As DBName) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.ECPServers.Delete() method instead.<br>
ClassMethod RemoveDataServer(Name As %String) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Databases.Delete() method instead.<br>
ClassMethod RemoveDatabase(Name As DBName) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Devices.Delete() method instead.<br>
ClassMethod RemoveDevice(Name As %String) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.MapGlobals.Delete() method instead.<br>
ClassMethod RemoveGlobalMapping(Namespace As NSName, Global As %String, Subscript As %String) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.Namespaces.Delete() method instead.<br>
ClassMethod RemoveNamespace(Name As NSName) As %Status
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
ClassMethod RenameDatabase(OldName As DBName = "", NewName As DBName = "") As %Status [ Internal ]
{
}

/// This method is DEPRECATED and will be removed in a future version.<br>
/// Use Config.WinStartup class instead.<br>
ClassMethod StartOnBoot(Arg1 As %Boolean = 1) As %Status [ Internal ]
{
}

}
