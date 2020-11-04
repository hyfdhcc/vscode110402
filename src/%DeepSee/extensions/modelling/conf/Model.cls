Class %DeepSee.extensions.modelling.conf.Model Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

Property name As %String(XMLPROJECTION = "ATTRIBUTE");

Property args As %Integer(XMLPROJECTION = "ATTRIBUTE");

Property Operations As array Of Operation(XMLKEYNAME = "order");

}
