/// This class is used by the DeepSee Report Generator.<br/>
/// It represents a table used in the Report Display
Class %DeepSee.Report.Model.Table Extends %DeepSee.Report.Model.Stylable [ System = 4 ]
{

Parameter XMLNAME = "table";

/// Set of elements within this table.
Property orient As %String(XMLPROJECTION = "attribute") [ InitialExpression = "col" ];

Property groupOverride As %String(XMLNAME = "group-override", XMLPROJECTION = "attribute");

Property elements As list Of Element(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

}
