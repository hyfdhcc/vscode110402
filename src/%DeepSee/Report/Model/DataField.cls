/// This class is used by the DeepSee Report Generator.<br/>
/// It represents a data field within a report.
Class %DeepSee.Report.Model.DataField Extends %DeepSee.Report.Model.Node [ System = 4 ]
{

Parameter XMLNAME = "dataField";

/// Name of property in data source that supplies the value for this field.
Property sourceProperty As %String(MAXLEN = 255, XMLPROJECTION = "attribute");

}
