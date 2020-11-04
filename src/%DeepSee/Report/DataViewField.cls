/// This class represents a field within a DeepSee DataView.<br/>
Class %DeepSee.Report.DataViewField Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, System = 3 ]
{

Index ID On name [ IdKey ];

/// Logical name of this field.
Property name As %String(MAXLEN = 250, XMLPROJECTION = "attribute");

/// Display name for this field.
Property caption As %String(MAXLEN = 250, XMLPROJECTION = "attribute");

/// Name of the property within the source class that supplies data for this field.
Property sourceProperty As %String(MAXLEN = 255, XMLPROJECTION = "attribute");

/// Data view this field belongs to.
Relationship dataView As DataView(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = parent, Inverse = fields ];

Storage Default
{
<Data name="DataViewFieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>caption</Value>
</Value>
<Value name="3">
<Value>sourceProperty</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("fields")</DataLocation>
<DefaultData>DataViewFieldDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DeepSee.Report.DataViewC("fields")</IdLocation>
<IndexLocation>^DeepSee.Report.DataViewFieldI</IndexLocation>
<StreamLocation>^DeepSee.Report.DataViewFieldS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
