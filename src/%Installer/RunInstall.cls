/// This activity runs another installer as a "sub" installer sequence
Class %Installer.RunInstall Extends %Installer.Activity [ ServerOnly = 1, System = 3 ]
{

/// Class name
Property Class As %String(MAXLEN = 128) [ Required ];

/// Method name
Property Method As %String(MAXLEN = 128) [ Required ];

/// Generate code for this document.
Method %OnGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	// Make sure this is run from the initial namespace
	Do pCode.WriteLine(..%Indent()_"Do tInstaller.PushNS(tInitialNS)")
	Do pCode.WriteLine(..%Indent()_"Do $classmethod($$$EVAL("_..Class_"),$$$EVAL("_..Method_"),.pVars,pLogLevel,tInstaller)")
	Do pCode.WriteLine(..%Indent()_"Do tInstaller.PopNS()")

	Quit $$$OK
}

}
