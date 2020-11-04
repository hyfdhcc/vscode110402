/// This is a "else" activity within a Manifest document
Class %Installer.Else Extends %Installer.Activity [ ServerOnly = 1, System = 3 ]
{

/// Generate code for this document.
Method %OnGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	Do pCode.WriteLine(..%Indent(-1)_"} Else {")
	Quit $$$OK
}

}
