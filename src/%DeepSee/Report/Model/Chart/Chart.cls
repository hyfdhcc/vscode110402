Class %DeepSee.Report.Model.Chart.Chart Extends %DeepSee.Report.Model.Element [ System = 4 ]
{

/// Default value for the plotToEdge property.
Parameter DEFAULTPLOTTOEDGE As BOOLEAN = 1;

/// Default value for the markersVisible property.
Parameter DEFAULTMARKERSVISIBLE As BOOLEAN = 0;

/// Do not worry about preserving the aspect ratio.
Parameter DEFAULTASPECT = "none";

/// Default viewBoxWidth of this component.
/// This is set to 100 to provide a fixed coordinate system for meters.
Parameter DEFAULTVIEWBOXWIDTH = 100;

/// Default viewBoxHeight of this component.
/// This is set to 100 to provide a fixed coordinate system for meters.
Parameter DEFAULTVIEWBOXHEIGHT = 100;

/// Optional: style used for chart background panel.
Property backgroundStyle As %ZEN.Datatype.style;

/// Optional: style used for chart plot area panel.
Property plotAreaStyle As %ZEN.Datatype.style;

/// Title to display for chart.
Property title As %ZEN.Datatype.string;

/// Optional: style used for title text.
Property titleStyle As %ZEN.Datatype.style;

/// If this chart has a title, x-position (within the chart coordinate space) of the title.
Property titleX As %ZEN.Datatype.float [ InitialExpression = 50 ];

/// If this chart has a legend, y-position (within the chart coordinate space) of the title.
Property titleY As %ZEN.Datatype.float [ InitialExpression = 5 ];

/// Comma-delimited list of fields to acquire data from. If <property>dataGroup</property>
/// is provided, only the first data field is used.
Property dataFields As %ZEN.Datatype.csv;

/// Number of data series to display on this chart.<br>
/// If "", then this is computed automatically from the chart's data source.
Property seriesCount As %ZEN.Datatype.string;

/// Number of items within each data series to display on this chart.<br>
/// If "", then this is computed automatically from the chart's data source. 
Property seriesSize As %ZEN.Datatype.string;

/// Comma-delimited list of CSS color values used for data series. The colors can
/// be acquired dynamically by using the form "!fieldname".
Property seriesColors As %ZEN.Datatype.csv [ InitialExpression = "blue,red,green,yellow,orange,plum,purple" ];

/// Comma-delimited list of names used to label each data series in the legend box.  The
/// series names can be acquired dynamically by beginning them with a "!".  If 
/// <property>seriesGroup</property> is provided, only the first series name field is
/// considered.
Property seriesNames As %ZEN.Datatype.csv;

/// Specifies the group the group that corresponds to the list of series for the chart.
Property seriesGroup As %ZEN.Datatype.string;

/// Specifies the group the group that corresponds to the data elements for the chart.
Property dataGroup As %ZEN.Datatype.string;

/// Comma-delimited list of marker shapes used for data series markers.
/// Possible values are 'up','down','square','circle'.<br>
/// This only applies to charts that support markers.
Property markerShapes As %ZEN.Datatype.csv [ InitialExpression = "circle,up,down,square" ];

/// Scaling applied to chart markers:
/// A value of 1.0 (or '') will display markers with their default size.
/// This only applies to charts that support markers.
Property markerScale As %ZEN.Datatype.float [ InitialExpression = 1 ];

/// Optional: default style applied to all grid line elements for this chart.<br>
/// If defined, this style overrides any styles define in the CSS style
/// definition for the page, but is in turn overridden by any styles defined
/// by a specific axis element.
Property gridStyle As %ZEN.Datatype.style;

/// Height of the chart within the report.
Property height As %ZEN.Datatype.length;

/// Height of the chart within the report.
Property width As %ZEN.Datatype.length;

/// Optional: default style applied to all grid label elements for this chart.
/// If defined, this style overrides any styles define in the CSS style
/// definition for the page, but is in turn overridden by any styles defined
/// by a specific axis element.
Property labelStyle As %ZEN.Datatype.style;

/// If true, display a legend for this chart.
Property legendVisible As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// If this chart has a legend, x-position (within the chart coordinate space) of legend box.
Property legendX As %ZEN.Datatype.float [ InitialExpression = 0 ];

/// If this chart has a legend, y-position (within the chart coordinate space) of legend box.
Property legendY As %ZEN.Datatype.float [ InitialExpression = 0 ];

/// If this chart has a legend, width (within the chart coordinate space) of legend box.
/// If not specified a default width will be used.
Property legendWidth As %ZEN.Datatype.float;

/// If this chart has a legend, height (within the chart coordinate space) of legend box.
/// If not specified a default height (based on number of data series) will be used.
Property legendHeight As %ZEN.Datatype.float;

/// Optional: style used for background of the legend box.
Property legendStyle As %ZEN.Datatype.style;

/// Optional: style used for text within the legend box.
Property legendLabelStyle As %ZEN.Datatype.style;

/// Margin (within the chart coordinate space) from top edge of chart to top edge of grid (plot area).
Property marginTop As %ZEN.Datatype.float [ InitialExpression = 6 ];

/// Margin (within the chart coordinate space) from bottom edge of chart to bottom edge of grid (plot area).
Property marginBottom As %ZEN.Datatype.float [ InitialExpression = 10 ];

/// Margin (within the chart coordinate space) from left edge of chart to left edge of grid (plot area).
Property marginLeft As %ZEN.Datatype.float [ InitialExpression = 10 ];

/// Margin (within the chart coordinate space) from right edge of chart to right edge of grid (plot area).
Property marginRight As %ZEN.Datatype.float [ InitialExpression = 2 ];

/// Specifies whether markers should be displayed for the data
/// points within the line chart.<br>
/// This only appies to charts that display markers.
Property markersVisible As %ZEN.Datatype.boolean [ InitialExpression = {..#DEFAULTMARKERSVISIBLE} ];

/// Specifies how values should be plotted along a category axis.
/// If true, plot the first and last values on the edges of the plotArea
/// (as in a line chart). If false, plot values in the centers of each
/// unit (as in a bar chart).<br>
/// This is specified by subclasses.
Property plotToEdge As %ZEN.Datatype.boolean [ InitialExpression = {..#DEFAULTPLOTTOEDGE} ];

/// If defined, then a colored band (specified by <property>bandUpperStyle</property>)
/// is displayed on the plot area covering the range greater than this value;
Property bandUpper As %ZEN.Datatype.float;

/// If defined, then a colored band (specified by <property>bandLowerStyle</property>)
/// is displayed on the plot area covering the range lower than this value;
Property bandLower As %ZEN.Datatype.float;

/// Optional: style used for upper band on plot area.
Property bandUpperStyle As %ZEN.Datatype.style;

/// Optional: style used for upper band on plot area.
Property bandLowerStyle As %ZEN.Datatype.style;

/// Optional: default style applied to svg elements used for plotting
/// data by this chart (such as the line in a line chart).
Property plotStyle As %ZEN.Datatype.style;

/// Optional: style used for series markers.
Property markerStyle As %ZEN.Datatype.style;

/// Every child must be an <class>axis</class>.
Property children As list Of Axis(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

}
