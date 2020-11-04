/// This is a "Default" activity within a Manifest document
Class %Installer.Default Extends %Installer.Var [ ServerOnly = 1, System = 3 ]
{

/// Variable name to define
Property Target As %String(MAXLEN = 128, XMLNAME = "Name") [ Required ];

/// Variable value if not already defined
Property Value As %String(MAXLEN = 32000);

/// Directory property (if the value is a filename)
Property Dir As %String(MAXLEN = 1024);

/// Generate code for this document.
Method %OnGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	Do pCode.WriteLine(..%Indent()_"If 'tInstaller.IsVariableDefined($$$EVAL("_..Target_")) {")
	If ..Dir'="" {
		Do pCode.WriteLine(..%Indent(1)_"Do tInstaller.SetVariable($$$EVAL("_..Target_"),##class(%File).NormalizeDirectory($$$EVAL("_..Dir_")))")
	} Else {
		Do pCode.WriteLine(..%Indent(1)_"Do tInstaller.SetVariable($$$EVAL("_..Target_"),$$$EVAL("_..Value_"))")
	}
	Do pCode.WriteLine(..%Indent()_"}")
	Quit $$$OK
}

}
