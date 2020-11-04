Class %DeepSee.Report.Model.Parameter Extends Element [ System = 4 ]
{

Parameter XMLNAME = "parameter";

/// Literal value used for a parameter value.<br>
/// This is used if <property>field</property> is not defined.
Property value As %ZEN.Datatype.string;

/// Name of field (column) in the current query that will
/// supply the value for this item.
Property field As %ZEN.Datatype.classMember(MEMBERTYPE = "SQLCOLUMN");

/// Optional ObjectScript expression that can either be applied
/// to the value of this item (supplied as <var>%val</var>), or to provide an
/// arbitrary value for this item.<br>
/// For example:<br>
/// expression="%val*2"<br>
/// expression="..ReportProp"<br>
Property expression As %ZEN.Datatype.expression;

}
