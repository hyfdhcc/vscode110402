/// This is a "Security" activity within a Manifest document
Class %Installer.Security Extends %Installer.Sequence [ ServerOnly = 1, System = 3 ]
{

/// Generate code for this document.
Method %OnBeforeGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	Quit $$$OK
}

/// Generate code for this document.
Method %OnAfterGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	Quit $$$OK
}

}
