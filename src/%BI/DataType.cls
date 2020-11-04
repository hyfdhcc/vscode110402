Class %BI.DataType Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property DecPoint As %SmallInt;

Property Rounding As %Boolean;

Property TypeName As %String(TRUNCATE = 1);

Index Name On TypeName As Exact;

Property BaseType As %String(TRUNCATE = 1);

Property Delimiter As %String(TRUNCATE = 1);

Property MinChar As %String(TRUNCATE = 1);

Property Day As %Boolean;

Property TextConversion As %Integer;

Property Wk As %Boolean;

Property DOW As %Boolean;

Property Mth As %Boolean;

Property Qtr As %Boolean;

Property Yr As %Boolean;

Property Per As %Boolean;

Property TS As %Boolean;

Property HrRng As %Boolean;

Property StartFinPeriod As %String(TRUNCATE = 1);

Property CustomDimension As %String(MAXLEN = 30000, TRUNCATE = 1);

Property MBitMap As array Of %BI.BitMapType;

Property NullField As %String(TRUNCATE = 1);

Property NullPointer As %String(TRUNCATE = 1);

Property ExcludedWords As %String(MAXLEN = 30000, TRUNCATE = 1);

Property UseExternalValue As %Boolean;

Property initialization As %String(TRUNCATE = 1);

Property MthWeek As %Boolean;

Property childFunc As %Integer;

Property coltseq As %Integer;

//new development

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,TypeName
FROM %BI.DataType
}

Storage Default
{
<Data name="Bitmap">
<Attribute>MBitmap</Attribute>
<Structure>node</Structure>
<Subscript>"B"</Subscript>
</Data>
<Data name="Class">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"C"</Subscript>
</Data>
<Data name="CustomDim">
<Attribute>CustomDimension</Attribute>
<Structure>node</Structure>
<Subscript>"D"</Subscript>
</Data>
<Data name="DataTypeDefaultData">
<Value name="1">
<Value>BaseType</Value>
</Value>
<Value name="2">
<Value>DecPoint</Value>
</Value>
<Value name="3">
<Value>Rounding</Value>
</Value>
<Value name="4">
<Value>TypeName</Value>
</Value>
<Value name="5">
<Value>DOW</Value>
</Value>
<Value name="6">
<Value>Day</Value>
</Value>
<Value name="7">
<Value>Wk</Value>
</Value>
<Value name="8">
<Value>Mth</Value>
</Value>
<Value name="9">
<Value>Qtr</Value>
</Value>
<Value name="10">
<Value>Per</Value>
</Value>
<Value name="11">
<Value>Yr</Value>
</Value>
<Value name="12">
<Value>TextConversion</Value>
</Value>
<Value name="13">
<Value>Delimiter</Value>
</Value>
<Value name="14">
<Value>MinChar</Value>
</Value>
<Value name="15">
<Value>CustomDateTag</Value>
</Value>
<Value name="16">
<Value>CustomDateMethod</Value>
</Value>
<Value name="17">
<Value>NullField</Value>
</Value>
<Value name="18">
<Value>NullPointer</Value>
</Value>
<Value name="19">
<Value>UseExternalValue</Value>
</Value>
<Value name="20">
<Value>initialization</Value>
</Value>
<Value name="21">
<Value>StartFinPeriod</Value>
</Value>
<Value name="22">
<Value>ExcludedWords</Value>
</Value>
<Value name="23">
<Value>MthWeek</Value>
</Value>
<Value name="24">
<Value>childFunc</Value>
</Value>
<Value name="25">
<Value>coltseq</Value>
</Value>
<Value name="26">
<Value>HrRng</Value>
</Value>
<Value name="27">
<Value>TS</Value>
</Value>
</Data>
<Data name="MBitMap">
<Attribute>MBitMap</Attribute>
<Structure>subnode</Structure>
<Subscript>"MBitMap"</Subscript>
</Data>
<DataLocation>^BI.DataTypeD</DataLocation>
<DefaultData>DataTypeDefaultData</DefaultData>
<IdLocation>^BI.DataTypeD</IdLocation>
<IndexLocation>^BI.DataTypeI</IndexLocation>
<StreamLocation>^BI.DataTypeS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
