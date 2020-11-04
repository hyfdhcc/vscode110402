/// A list of string objects. Allows longer strings than ListOfDataTypes
Class %EM.DataList Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// The list of data strings
Property Data As list Of %String(MAXLEN = "");

}
