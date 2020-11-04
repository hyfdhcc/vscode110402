Class %DeepSee.Report.Model.Chart.Axis Extends %DeepSee.Report.Model.Node [ System = 4 ]
{

Parameter XMLNAME = "axis";

/// Minimum value along this axis.<br>
/// If this is missing (""), then the value will be automatically calculated.
Property minValue As %ZEN.Datatype.float;

/// Maximum value along this axis.<br>
/// If this is missing (""), then the value will be automatically calculated.
Property maxValue As %ZEN.Datatype.float;

/// When minValue is automatically calculated this displacement is added to minValue
Property minValueDisplacement As %ZEN.Datatype.float;

/// When minValue is automatically calculated this displacement is added to minValue
Property maxValueDisplacement As %ZEN.Datatype.float;

/// Optional title to display along this axis.
Property title As %ZEN.Datatype.string;

/// Base value for this axis. For charts with filled regions
/// (such as bar or area plots), this specifies where the base
/// of the filled region should be plotted.<br>
/// If this is missing (""), then the base value will be the bottom of the plot area.
Property baseValue As %ZEN.Datatype.float;

/// Major units along this axis. This specifies how major gridlines will be spaced along this axis.<br>
/// If this is missing (""), then the value will be automatically calculated.
Property majorUnits As %ZEN.Datatype.float(MINVAL = 0);

/// Minor units along this axis. This specifies how minor gridlines will be spaced along this axis.<br>
/// If this is missing (""), then the value will be automatically calculated.
Property minorUnits As %ZEN.Datatype.float(MINVAL = 0);

/// Label units along this axis. This specifies how labels will be spaced along this axis.<br>
/// If this is missing (""), then the value will be automatically calculated.
Property labelUnits As %ZEN.Datatype.float(MINVAL = 0);

/// Number of degrees that labels for this axis should be rotated.
Property labelAngle As %ZEN.Datatype.float [ InitialExpression = 0 ];

/// Specifies whether gridlines should be displayed for each major unit.
Property majorGridLines As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// Specifies whether gridlines should be displayed for each minor unit.
Property minorGridLines As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// Optional: style used for labels along this axis.
Property labelStyle As %ZEN.Datatype.style;

/// textAnchor value
Property textAnchor As %ZEN.Datatype.string [ InitialExpression = "middle" ];

/// Optional: comma-delimited list of label values of category axes.
/// If left blank, the category number is used.
Property labelValues As %ZEN.Datatype.csv;

/// Optional: Group used to get label values of category axes.
/// If left blank, the category number is used.
Property labelGroup As %ZEN.Datatype.string;

/// Optional: Value used to get label values of category axes from Group.
/// If left blank, the category number is used.
Property labelValue As %ZEN.Datatype.string;

/// Optional: style used for major grid lines along this axis.
Property majorGridStyle As %ZEN.Datatype.style;

/// Optional: style used for minor grid lines along this axis.
Property minorGridStyle As %ZEN.Datatype.style;

Property labelDisplacement As %ZEN.Datatype.float;

Storage Default
{
<Data name="AxisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>minValue</Value>
</Value>
<Value name="3">
<Value>maxValue</Value>
</Value>
<Value name="4">
<Value>minValueDisplacement</Value>
</Value>
<Value name="5">
<Value>maxValueDisplacement</Value>
</Value>
<Value name="6">
<Value>title</Value>
</Value>
<Value name="7">
<Value>baseValue</Value>
</Value>
<Value name="8">
<Value>majorUnits</Value>
</Value>
<Value name="9">
<Value>minorUnits</Value>
</Value>
<Value name="10">
<Value>labelUnits</Value>
</Value>
<Value name="11">
<Value>labelAngle</Value>
</Value>
<Value name="12">
<Value>majorGridLines</Value>
</Value>
<Value name="13">
<Value>minorGridLines</Value>
</Value>
<Value name="14">
<Value>labelStyle</Value>
</Value>
<Value name="15">
<Value>textAnchor</Value>
</Value>
<Value name="16">
<Value>labelValues</Value>
</Value>
<Value name="17">
<Value>labelGroup</Value>
</Value>
<Value name="18">
<Value>labelValue</Value>
</Value>
<Value name="19">
<Value>majorGridStyle</Value>
</Value>
<Value name="20">
<Value>minorGridStyle</Value>
</Value>
<Value name="21">
<Value>labelDisplacement</Value>
</Value>
</Data>
<DataLocation>^%DeepSee.Report.ModelAA47.AxisD</DataLocation>
<DefaultData>AxisDefaultData</DefaultData>
<IdLocation>^%DeepSee.Report.ModelAA47.AxisD</IdLocation>
<IndexLocation>^%DeepSee.Report.ModelAA47.AxisI</IndexLocation>
<StreamLocation>^%DeepSee.Report.ModelAA47.AxisS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
