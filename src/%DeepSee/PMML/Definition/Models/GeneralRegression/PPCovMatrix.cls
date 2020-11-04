Class %DeepSee.PMML.Definition.Models.GeneralRegression.PPCovMatrix Extends node [ System = 3 ]
{

Property type As %DeepSee.PMML.Datatype.String(VALUELIST = ",model,robust", XMLPROJECTION = "ATTRIBUTE");

Property Cells As list Of PPCovCell(XMLNAME = "PPCovCell", XMLPROJECTION = "ELEMENT");

}
