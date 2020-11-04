Class %DeepSee.PMML.Definition.Models.Clustering.Cluster Extends node [ System = 3 ]
{

Property KohonenMap As KohonenMap(XMLPROJECTION = "ELEMENT");

Property Coordinates As %DeepSee.PMML.Definition.Util.AbstractArray(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

Property Partition As %DeepSee.PMML.Definition.Util.Partition(XMLPROJECTION = "ELEMENT");

Property Covariances As %DeepSee.PMML.Definition.Util.Matrix(XMLPROJECTION = "WRAPPED");

Property id As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE");

Property name As %DeepSee.PMML.Datatype.String(XMLPROJECTION = "ATTRIBUTE");

Property size As %DeepSee.PMML.Datatype.IntNumber(MINVAL = 0, XMLPROJECTION = "ATTRIBUTE");

}
