Class %DeepSee.Report.Model.Chart.LineChart Extends Chart [ System = 4 ]
{

Parameter XMLNAME = "lineChart";

/// Default value for plotToEdge property.
Parameter DEFAULTPLOTTOEDGE = 1;

/// Specifies whether the area under the line is filled (as
/// in an area chart) or not filled (as in a line chart).
Property chartFilled As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// If true, this is a <i>stacked</i> line chart. That is,
/// data series are plotted above one another.<br>
/// Note that negative values are ignored in stacked charts.
Property chartStacked As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// If true, pivot this chart: display categories vertically
/// and values horizontally.
Property chartPivot As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

Property tagBegin As %String [ InitialExpression = "<lineChart" ];

Property tagEnd As %String [ InitialExpression = "</lineChart>" ];

}
