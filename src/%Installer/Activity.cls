/// This is the base class for activities within the document.
Class %Installer.Activity Extends %XGEN.AbstractNode [ Abstract, ServerOnly = 1, System = 3 ]
{

Parameter NAMESPACE = "INSTALLER";

Parameter XGENDOCUMENT = "%Installer.Manifest";

///  Reduces the amount of generated code
Parameter XMLFORMAT = "literal";

}
