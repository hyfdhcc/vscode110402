Class %BI.swDashBoardLibTable Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/*
		Author : Steven :P
		Purpose: Dashboard Object - properties. Instantiable from caller
		Note   : This table holds all database fields for storing dashboard data
		Created: 31.05.2005
		Updated: 01.06.2005 Steven
*/
Property TopCood As %String(TRUNCATE = 1);

Property LeftCood As %String(TRUNCATE = 1);

Property Height As %String(TRUNCATE = 1);

Property Width As %String(TRUNCATE = 1);

Property ControlID As %String(TRUNCATE = 1);

Property ControlType As %String(TRUNCATE = 1);

Property DisplayType As %String(TRUNCATE = 1);

Property Tooltips As %String(TRUNCATE = 1);

Property BoardName As %String(TRUNCATE = 1);

Property RefreshTrigger As %String(TRUNCATE = 1);

Property FilterObject As %String(TRUNCATE = 1);

Property PostAction As %String(TRUNCATE = 1);

Property MixStr As %String(TRUNCATE = 1);

Property MixStr2 As %String(TRUNCATE = 1);

Property DetailField As %String(TRUNCATE = 1);

Property DefaultVal As %String(TRUNCATE = 1);

Property Caption As %String(TRUNCATE = 1);

//Name of the Tab - Use as listing title

Property KPI As %String(TRUNCATE = 1);

Property TheSchema As %String(TRUNCATE = 1);

Property KPIFilter As %String(TRUNCATE = 1);

Property SchemaName As %String(TRUNCATE = 1);

Property Dimension As %String(TRUNCATE = 1);

Property OutputVariable As %String(TRUNCATE = 1);

Property AllowMultiSet As %String(TRUNCATE = 1);

Property ImageID As %String(TRUNCATE = 1);

Property Condition As %String(TRUNCATE = 1);

Property TmpPic As %String(TRUNCATE = 1);

Property ImageID2 As %String(TRUNCATE = 1);

Property OnStartup As %String(TRUNCATE = 1);

Property TmpPic2 As %String(TRUNCATE = 1);

Property SecurityLevel As %String(TRUNCATE = 1);

Property SecurityInquiry As %String(TRUNCATE = 1);

Storage Default
{
<Data name="swDashBoardLibTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BoardName</Value>
</Value>
<Value name="3">
<Value>SchemaName</Value>
</Value>
<Value name="4">
<Value>TmpPic</Value>
</Value>
<Value name="5">
<Value>TmpPic2</Value>
</Value>
<Value name="6">
<Value>TheSchema</Value>
</Value>
</Data>
<Data name="swDashBoardLibTableState">
<Subscript>"%BI.swDashBoardLibTable"</Subscript>
<Value name="1">
<Value>AllowMultiSet</Value>
</Value>
<Value name="2">
<Value>Caption</Value>
</Value>
<Value name="3">
<Value>Condition</Value>
</Value>
<Value name="4">
<Value>ControlID</Value>
</Value>
<Value name="5">
<Value>ControlType</Value>
</Value>
<Value name="6">
<Value>DefaultVal</Value>
</Value>
<Value name="7">
<Value>DetailField</Value>
</Value>
<Value name="8">
<Value>Dimension</Value>
</Value>
<Value name="9">
<Value>DisplayType</Value>
</Value>
<Value name="10">
<Value>FilterObject</Value>
</Value>
<Value name="11">
<Value>Height</Value>
</Value>
<Value name="12">
<Value>ImageID</Value>
</Value>
<Value name="13">
<Value>ImageID2</Value>
</Value>
<Value name="14">
<Value>KPI</Value>
</Value>
<Value name="15">
<Value>KPIFilter</Value>
</Value>
<Value name="16">
<Value>LeftCood</Value>
</Value>
<Value name="17">
<Value>MixStr</Value>
</Value>
<Value name="18">
<Value>MixStr2</Value>
</Value>
<Value name="19">
<Value>OnStartup</Value>
</Value>
<Value name="20">
<Value>OutputVariable</Value>
</Value>
<Value name="21">
<Value>PostAction</Value>
</Value>
<Value name="22">
<Value>RefreshTrigger</Value>
</Value>
<Value name="23">
<Value>Schema</Value>
</Value>
<Value name="24">
<Value>SecurityInquiry</Value>
</Value>
<Value name="25">
<Value>SecurityLevel</Value>
</Value>
<Value name="26">
<Value>Tooltips</Value>
</Value>
<Value name="27">
<Value>TopCood</Value>
</Value>
<Value name="28">
<Value>Width</Value>
</Value>
</Data>
<DataLocation>^BI.swDashBoardLibTableD</DataLocation>
<DefaultData>swDashBoardLibTableDefaultData</DefaultData>
<IdLocation>^BI.swDashBoardLibTableD</IdLocation>
<IndexLocation>^BI.swDashBoardLibTableI</IndexLocation>
<State>swDashBoardLibTableState</State>
<StreamLocation>^BI.swDashBoardLibTableS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
