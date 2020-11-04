Class %DeepSee.Report.Model.Template Extends Element [ System = 4 ]
{

Parameter XMLNAME = "template";

/// the xpath on which template will match
Property match As %String(XMLPROJECTION = "attribute");

/// Set of elements within this div.
Property elements As list Of Element(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

}
