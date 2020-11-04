/// Meta-data object that represents a calculated member within a DeepSee cube.<br/>
/// At query processing time, references to a calculated member are replaced with the
/// <property>valueExpression</property> that defines the member.
Class %DeepSee.Model.calculatedMember Extends %DeepSee.Model.node [ System = 3 ]
{

/// Cube that this calculated member belongs to.
Relationship cube As %DeepSee.Model.cube(XMLPROJECTION = "none") [ Cardinality = one, Inverse = calculatedMembers ];

/// Name of the dimension this calculated member belongs to.
/// This does not have to be an existing dimension.
Property dimension As %DeepSee.Datatype.entityName(XMLPROJECTION = "attribute");

/// MDX expression that defines the value of this calculated member.
Property valueExpression As %DeepSee.Datatype.string(MAXLEN = 32000, XMLPROJECTION = "attribute");

/// Optional format string to apply to this member.
Property formatString As %DeepSee.Datatype.string(MAXLEN = 100, XMLPROJECTION = "attribute");

/// Optional. Units applied to this member (if it is a measure).<br/>
/// This is not currently used.
Property units As %DeepSee.Datatype.string(XMLPROJECTION = "attribute");

/// If true, this calculatedMember is hidden. That is, it will not be listed among the
/// cube's members within the various DeepSee utilities.<br/>
/// It can still be used within MDX queries and expressions.
Property hidden As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

// WAL172

Property additionalDescription As %DeepSee.Datatype.string;

// WAL190

Property listingFilter As %DeepSee.Datatype.string(XMLPROJECTION = "attribute");

/// Test if this member's definition is valid.
Method %Validate() As %Status
{
	Set tSC = $$$OK
	If (..dimension="") {
		Set tSC = $$$ERROR($$$GeneralError,"Calculated member must define a dimension name: " _ ..name)
	}

	If (..valueExpression="") {
		Set tSC = $$$ERROR($$$GeneralError,"Calculated member must define a valueExpression: " _ ..name)
	}

	Quit tSC
}

}
