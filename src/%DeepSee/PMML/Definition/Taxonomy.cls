Class %DeepSee.PMML.Definition.Taxonomy Extends extendableNode [ System = 3 ]
{

Property name As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property ChildParents As list Of TaxonomyChildParent(XMLNAME = "ChildParent", XMLPROJECTION = "ELEMENT");

}
