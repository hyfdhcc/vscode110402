/// This is a "Setting" activity within a Manifest document
Class %Installer.Setting Extends %Installer.Activity [ ServerOnly = 1, System = 3 ]
{

/// Item name
Property Item As %String(MAXLEN = 128) [ Required ];

/// Target name
Property Target As %String(MAXLEN = 128, VALUELIST = ",Item,Host,Adapter") [ Required ];

/// Setting name
Property Setting As %String(MAXLEN = 128) [ Required ];

/// Variable value
Property Value As %String(MAXLEN = 32000) [ Required ];

/// Generate code for this document.
Method %OnGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	Do pCode.WriteLine(..%Indent(-1)_"Set tSettings($$$EVAL("_..Item_"),$$$EVAL("_..Target_"),$$$EVAL("_..Setting_")) = $$$EVAL("_..Value_")")
	Quit $$$OK
}

}
