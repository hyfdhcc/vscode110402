Class %BI.DetailListFields Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Width As %Numeric;

Property FieldList As %String(TRUNCATE = 1);

Property Caption As %String(TRUNCATE = 1);

Property Type As %String(TRUNCATE = 1);

Property FieldName As %String(TRUNCATE = 1) [ Calculated ];

Property DLOption As %String(TRUNCATE = 1);

//added by ALan 16/8/05

Property DLGrand As %String(TRUNCATE = 1);

//added by ALan 16/8/05

Property DLPage As %String(TRUNCATE = 1);

//added by ALan 16/8/05

Property DLOption2 As %String(TRUNCATE = 1);

//added by ALan 16/8/05

Property DLSortType As %String;

Property DLSortOrder As %String;

Method FieldNameGet() As %String
{
	//original
	//quit $LG($G(^BI.ListFieldD(..FieldList)),3)
	
	//get value from dimension
 	//quit $LG($G(^BI.ListFieldD(..FieldList)),3)
  	i (..Type = "D") {
 		quit $LG($G(^BI.MeasureD(..FieldList)),3)
 	}
 	else  { 	
 		
 		quit $LG($G(^BI.ListFieldD(..FieldList)),3)
 	}
 	
 	// quit $LG($G(^BI.MeasureD(..FieldList)),3)
}

Storage Default
{
<Data name="DetailListFieldsState">
<Subscript>"%BI.DetailListFields"</Subscript>
<Value name="1">
<Value>Caption</Value>
</Value>
<Value name="2">
<Value>FieldList</Value>
</Value>
<Value name="3">
<Value>Width</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>DLGrand</Value>
</Value>
<Value name="6">
<Value>DLOption</Value>
</Value>
<Value name="7">
<Value>DLPage</Value>
</Value>
<Value name="8">
<Value>DLOption2</Value>
</Value>
<Value name="9">
<Value>DLSortOrder</Value>
</Value>
<Value name="10">
<Value>DLSortType</Value>
</Value>
</Data>
<State>DetailListFieldsState</State>
<StreamLocation>^BI.DetailListFieldsS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
