Class %DeepSee.PMML.Definition.Segmentation Extends extendableNode [ System = 3 ]
{

Property Extension As list Of %DeepSee.PMML.Definition.Extension(XMLPROJECTION = "ELEMENT");

Property Segments As list Of Segment(XMLNAME = "Segment", XMLPROJECTION = "ELEMENT");

Property multipleModelMethod As %String(VALUELIST = ",majorityVote,weightedMajorityVote,average,weightedAverage,median,max,sum,selectFirst,selectAll,modelChain", XMLPROJECTION = "ATTRIBUTE") [ Required ];

}
