Include (%syConfig, %syEMS)

/// This class contains helper functions for the various System Management server functions.
Class Config.Map Extends %SYSTEM.Help [ Abstract, Final, System = 4 ]
{

/// Main routine to import a [Map.*] section.<br>
/// Called from Config.CPF.Read().<br>
ClassMethod Create(Namespace As %String, Name As %String, ByRef Properties As %String, CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) [ Internal ]
{
}

/// No default section in a CPF file.<br>
ClassMethod Default(CPFFile As %String, Platform As %String) As %Status [ Internal ]
{
}

/// Move all the mappings from the config database into the ^CONFIG global for all namespaces.<br>
/// Parameters:<br>
/// <b>Namespace</b> - ignored, used as a placeholder.<br>
ClassMethod MoveToActive(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Write all the mappings for all namespaces to the CPFFile.<br>
/// This method assumes that the CPF file has been opened and USED.<br>
/// Parameters:<br>
/// <b>CPFFile</b> - Name of the CPF file to write to.<br>
ClassMethod WriteSection(CPFFile As %String) As %Status [ Internal ]
{
}

}
