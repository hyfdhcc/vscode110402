Class %DeepSee.Report.Model.Chart.BarChart Extends Chart [ System = 4 ]
{

Parameter XMLNAME = "barChart";

/// If true, this is a <i>stacked</i> bar chart. That is,
/// data series are plotted on top of one another.<br>
/// If false, then data series are plotted side-by-side.<br>
/// Note that negative values are ignored in stacked charts.<br>
/// <span style='font-weight:bold'>NOT CURRENTLY IMPLEMENTED</span>
Property chartStacked As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// If true, pivot this chart: display categories vertically
/// and values horizontally.
Property chartPivot As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

Property tagBegin As %String [ InitialExpression = "<barChart" ];

Property tagEnd As %String [ InitialExpression = "</barChart>" ];

}
