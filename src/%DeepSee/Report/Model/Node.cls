/// This class is used by the DeepSee Report Generator.<br/>
/// It is the base class for the various report model classes.
Class %DeepSee.Report.Model.Node Extends (%RegisteredObject, %XML.Adaptor) [ Abstract, Inheritance = right, System = 4 ]
{

Parameter XMLIGNORENULL = 1;

/// Name of this item.
Property name As %String(MAXLEN = 255, XMLPROJECTION = "attribute");

}
