Class %DeepSee.Report.Model.BlockContainer Extends Stylable [ System = 4 ]
{

Parameter XMLNAME = "block-container";

Property backgroundImage As %ZEN.Datatype.string(XMLNAME = "background-image", XMLPROJECTION = "ATTRIBUTE");

/// Set of elements within this group.
Property elements As list Of Element(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

}
