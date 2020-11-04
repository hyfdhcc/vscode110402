/// Meta-data for a member property within a dimension level within a DeepSee cube.<br/>
Class %DeepSee.Model.property Extends (%DeepSee.Model.node, %DeepSee.Model.source) [ System = 3 ]
{

/// If true, this property is hidden. That is, it will not be listed among the
/// level's properties within the various DeepSee utilities.<br/>
/// It can still be used within MDX queries and expressions.
Property hidden As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

/// If specified, then use this property to sort members of the current level.<br/>
/// The value can be "asc" for ascending order, "desc" for descending order,
/// "asc numeric" for ascending numeric order, or "desc numeric" for descending numeric order.<br/>
/// If more than one property specifies sorting, then members are sorted using a combination
/// of properties. The sorting is applied in the order in which the properties are
/// listed in the level definition.
Property sort As %DeepSee.Datatype.string(VALUELIST = ",asc,desc,asc numeric,desc numeric", XMLPROJECTION = "attribute");

/// If true, then this property is used to supply the display name for members
/// of this level.<br/>
/// Only one property for a given level can set this property.
Property isName As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

/// Optional. If true, then this property is used to supply an alternate descriptive name for members
/// of this level.<br/>
/// Only one property for a given level can set this property.
Property isDescription As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

/// If true, then the value of this property is not stored within a dimension
/// table. Instead its value is retrieved from the data source when a query
/// is executed.
Property isReference As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

/// If true, then use the display (external) value of the field (if applicable) in the source
/// table when fetching data for this property.<br/>
/// This is only applied for properties that specify a <property>sourceProperty</property>.
Property useDisplayValue As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

/// Optional format string to apply to this property.
Property formatString As %DeepSee.Datatype.string(MAXLEN = 100, XMLPROJECTION = "attribute");

// WAL172

Property additionalDescription As %DeepSee.Datatype.string;

}
