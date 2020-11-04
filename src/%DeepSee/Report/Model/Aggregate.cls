Class %DeepSee.Report.Model.Aggregate Extends Stylable [ System = 4 ]
{

Parameter XMLNAME = "aggregate";

/// Type of aggregate to calculate.
Property type As %ZEN.Datatype.string(MAXLEN = 50, VALUELIST = ",COUNT,SUM,AVG,MIN,MAX,CUSTOM,CLASS");

Property class As %ZEN.Datatype.className;

Property format As %ZEN.Datatype.string;

/// Name used for the XML representation of this node.<br>
/// If a value is not supplied, "item" is used.<br>
/// This must contain a valid identifier value.
Property name As %ZEN.Datatype.name [ InitialExpression = "item", Required ];

/// Name of field (column) in the base query for this report that will
/// supply the value for this item.
/// If this starts with "!" then this is expression that evaluates to field name
Property field As %ZEN.Datatype.classMember(MEMBERTYPE = "SQLCOLUMN");

/// Name of fields (columns) in the base query for this report that will
/// supply the values for this item.
Property fields As %ZEN.Datatype.string;

/// Only accumulate if accumif is true
Property accumIf As %ZEN.Datatype.string;

/// caption used in table
Property caption As %String(XMLPROJECTION = "attribute");

}
