/// This class is used by methods in %SYS.PTools.SQLUtilites to temporarily store the results of different Options.
/// 
/// The data must be generated by running one of the class methods:  IndexUsage, TableScans, TempIndices or IndexJoins
/// 
/// the data in this table is deleted when GatherStats is run
Class %SYS.PTools.SQLUtilResults Extends %Persistent [ System = 4 ]
{

/// this property can have 4 different values:  IndexUsage, TableScans, TempIndices, or IndexJoins
Property OptionName As %String(VALUELIST = ",IU,TS,TI,JI,");

Property Counter As %Integer [ InitialExpression = {$I(^%sqlcq($NAMESPACE,"PTools","Utils","Results","D"))} ];

Index Master On (OptionName, Counter) [ IdKey ];

Property SchemaName As %String;

Property TableName As %String;

Property IndexName As %String;

// $LISTBUILD of the Properties that will make up the Subscripts of the Temp Index

// Every Index you can define will have ID as the final subscript.

Property IndexFields As list Of %String;

// used by both IndexUsaage and TempIndices class methods

// Number of times the index was used in the sql.

Property UsageCount As %Integer;

// $LISTBUILD of the Properties that will be the data node of the Temp Index

// The extra data is stored as part of the index to avoid reading from the Data Map.

Property DataValues As list Of %String;

// Reference to the %SYS.PTools.SQLUtilities class

// When set you can use this to look at the query that is related to the row.

// Set in the TableScan Class method.

// Use the pointer to get the SQLText, Run ShowPlan and find the Table Scan based on ModuleName

Property SQLPointer As %SYS.PTools.SQLUtilities;

// Set by the TableScan class method

// The Number of Rows in the Table Based on TuneTable Data

Property ExtentSize As %Integer;

Property MapType As %String;

Property BlockCount As %Integer;

// Set by the TableScan class method

// Name of the Module from TuneTable output that is doing the Table Scan

Property ModuleName As %String;

// Set by JoinIndex

// Flag has 4 values:

// 0 - No index to support the JOIN

// 1 - There is an index to support the join but it is not an exact match, the first index field is not part of the join.

// 2 - There is an index to support the join but it is not an exact match, the first index field is part of the join.

// 3 - Index fully supports the join, this is not included in the table as there is nothing to improve.

Property JoinIndexFlag As %Integer;

Storage Default
{
<CounterLocation>^%sqlcq($NAMESPACE,"PTools","Utils","Results","C")</CounterLocation>
<Data name="SQLUtilResultsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchemaName</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
<Value name="4">
<Value>IndexName</Value>
</Value>
<Value name="5">
<Value>TempIndex</Value>
</Value>
<Value name="6">
<Value>UsageCount</Value>
</Value>
<Value name="7">
<Value>DataValues</Value>
</Value>
<Value name="8">
<Value>IndexFields</Value>
</Value>
<Value name="9">
<Value>SQLPointer</Value>
</Value>
<Value name="10">
<Value>ExtentSize</Value>
</Value>
<Value name="11">
<Value>ModuleName</Value>
</Value>
<Value name="12">
<Value>JoinIndexFlag</Value>
</Value>
<Value name="13">
<Value>MapType</Value>
</Value>
<Value name="14">
<Value>BlockCount</Value>
</Value>
</Data>
<DataLocation>^%sqlcq($NAMESPACE,"PTools","Utils","Results","D")</DataLocation>
<DefaultData>SQLUtilResultsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%sqlcq($NAMESPACE,"PTools","Utils","Results","D")</IdLocation>
<IndexLocation>^%sqlcq($NAMESPACE,"PTools","Utils","Results","I")</IndexLocation>
<StreamLocation>^%sqlcq($NAMESPACE,"PTools","Utils","Results","S")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
