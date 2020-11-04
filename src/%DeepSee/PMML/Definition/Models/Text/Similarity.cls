Class %DeepSee.PMML.Definition.Models.Text.Similarity Extends %DeepSee.PMML.Definition.node [ System = 3 ]
{

Parameter XMLNAME = "TextModelSimilarity";

Property Extension As list Of %DeepSee.PMML.Definition.Extension(XMLPROJECTION = "ELEMENT");

Property similarityType As %DeepSee.PMML.Datatype.String(VALUELIST = ",euclidian,cosine", XMLPROJECTION = "ATTRIBUTE") [ Required ];

}
