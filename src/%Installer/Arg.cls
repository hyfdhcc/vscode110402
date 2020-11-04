/// This is a "Arg" activity within a Manifest document
Class %Installer.Arg Extends %Installer.Activity [ ServerOnly = 1, System = 3 ]
{

/// Argument Value
Property Value As %String(MAXLEN = 32000);

}
