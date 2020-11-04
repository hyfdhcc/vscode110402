Class %DeepSee.Report.Model.Summary Extends Item [ System = 4 ]
{

Parameter XMLNAME = "summary";

Property tagBegin As %String [ InitialExpression = "<summary" ];

Property tagEnd As %String [ InitialExpression = "</summary>" ];

Property elements As list Of Element(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

}
