/// This class is used by the DeepSee Report Generator.<br/>
/// It represents a group within a report.
Class %DeepSee.Report.Model.Group Extends %DeepSee.Report.Model.Element [ System = 4 ]
{

Parameter XMLNAME = "group";

Property xpath As %String(MAXLEN = "", XMLPROJECTION = "none");

/// Specifies which type of group this is, e.g. "header", "group".
Property category As %String(MAXLEN = 255, XMLPROJECTION = "attribute");

/// Specifies the index number of this group within its category.
Property index As %Integer(XMLPROJECTION = "attribute");

/// Name of the breaking field for this group.
Property breakOnField As %String(MAXLEN = 255, XMLPROJECTION = "attribute");

/// Set of elements within this group.
Property elements As list Of Element(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

/// Specifies the index number of this group within its category.
Property hasSQL As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

/// Specifies whether group appears in display
Property display As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 1 ];

}
