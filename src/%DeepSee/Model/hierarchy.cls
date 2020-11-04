/// Meta-data for a hierarchy within a DeepSee cube.
/// 
Class %DeepSee.Model.hierarchy Extends %DeepSee.Model.node [ System = 4 ]
{

/// Dimension that this hierarchy belongs to.
Relationship dimension As %DeepSee.Model.dimension(XMLPROJECTION = "none") [ Cardinality = one, Inverse = hierarchies ];

/// Set of levels defined for this hierarchy.<br/>
Relationship levels As %DeepSee.Model.level(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = hierarchy ];

// WAL172

Property additionalDescription As %DeepSee.Datatype.string;

/// If true, this hierarchy is hidden. That is, it will not be listed among the
/// cube's members within the various DeepSee utilities.<br/>
/// It can still be used within MDX queries and expressions.
Property hidden As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

}
