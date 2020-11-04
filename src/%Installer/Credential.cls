/// This is a "Credential" activity within a Manifest document
Class %Installer.Credential Extends %Installer.Activity [ ServerOnly = 1, System = 3 ]
{

/// Credential name
Property Target As %String(MAXLEN = 128, XMLNAME = "Name") [ Required ];

/// Username
Property Username As %String(MAXLEN = 128) [ Required ];

/// Password
Property Password As %String(MAXLEN = 128);

/// Overwrite flag
Property Overwrite As %String;

/// Generate code for this document.
Method %OnGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	Do pCode.WriteLine(..%Indent(-1)_"Set tCredentials($$$EVAL("_..Target_"))=$LB($$$EVAL("_..Username_"),$$$EVAL("_..Password_"),+$$$EVAL("_..Overwrite_"))")
	Quit $$$OK
}

}
