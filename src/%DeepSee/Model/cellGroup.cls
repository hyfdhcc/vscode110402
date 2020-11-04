/// Represents a grouping within a Cell Cache definition.
Class %DeepSee.Model.cellGroup Extends cellCacheNode [ System = 3 ]
{

Parameter XMLNAME = "group";

/// Cell Cache that this group belongs to.
Relationship cellCache As %DeepSee.Model.cellCache(XMLPROJECTION = "none") [ Cardinality = one, Inverse = cellGroups ];

/// Set of items defined for this group.<br/>
Relationship items As %DeepSee.Model.cellCacheItem(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = group ];

}
