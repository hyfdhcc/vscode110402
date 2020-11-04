/// This is a "LoadPage" activity within a Manifest document
Class %Installer.LoadPage Extends %Installer.Activity [ ServerOnly = 1, System = 3 ]
{

/// Page name
Property Target As %String(MAXLEN = 1024, XMLNAME = "Name");

/// Directory
Property Dir As %String(MAXLEN = 1024);

/// Flags value
Property Flags As %String [ InitialExpression = "ck" ];

/// Ignore errors flag
Property IgnoreErrors As %String [ InitialExpression = "0" ];

/// Generate code for this document.
Method %OnGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	Do pCode.WriteLine(..%Indent()_"Do tInstaller.LoadPage(tNSName,$$$EVAL("_..Target_"),$$$EVAL("_..Dir_"),$$$EVAL("_..Flags_"),$$$EVAL("_..IgnoreErrors_"))")
	Quit $$$OK
}

}
