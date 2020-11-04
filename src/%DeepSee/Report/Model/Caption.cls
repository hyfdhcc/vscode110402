Class %DeepSee.Report.Model.Caption Extends Item [ System = 4 ]
{

Parameter XMLNAME = "caption";

Property tagBegin As %String [ InitialExpression = "<caption" ];

Property tagEnd As %String [ InitialExpression = "</caption>" ];

Property elements As list Of Element(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

}
