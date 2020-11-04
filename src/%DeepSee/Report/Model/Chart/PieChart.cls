Class %DeepSee.Report.Model.Chart.PieChart Extends Chart [ System = 4 ]
{

/// Optional: comma-delimited list of label values of each slice.
/// If left blank, the series number is used.
Property labelValues As %ZEN.Datatype.csv;

Property tagBegin As %String [ InitialExpression = "<pieChart" ];

Property tagEnd As %String [ InitialExpression = "</pieChart>" ];

}
