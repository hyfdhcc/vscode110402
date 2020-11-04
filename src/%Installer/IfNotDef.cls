/// This is a "IfNotDef" activity within a Manifest document
Class %Installer.IfNotDef Extends %Installer.Sequence [ ServerOnly = 1, System = 3 ]
{

/// Condition
Property Var As %String [ Required ];

/// Generate code for this document.
Method %OnBeforeGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	Do pCode.WriteLine(..%Indent()_"If ('tInstaller.IsVariableDefined($$$EVAL("_..Var_"))) {")
	Quit $$$OK
}

Method %OnAfterGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %XGEN.AbstractDocument) As %Status [ Internal ]
{
	Do pCode.WriteLine(..%Indent()_"}")
	Quit $$$OK
}

}
