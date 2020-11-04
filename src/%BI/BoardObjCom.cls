Class %BI.BoardObjCom Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/*
	Author : Daniel :P
	Purpose: Dashboard Object - properties. Instantiable from caller
	Note   : This table holds all database fields for storing dashboard data
	Created: 12.07.2005
	Updated: 12.07.2005 Daniel
*/
Property TopCood As %String(TRUNCATE = 1);

Property LeftCood As %String(TRUNCATE = 1);

Property Height As %String(TRUNCATE = 1);

Property Width As %String(TRUNCATE = 1);

Property ControlID As %String(TRUNCATE = 1);

Property ControlType As %String(TRUNCATE = 1);

Property DisplayType As %String(TRUNCATE = 1);

Property Tooltips As %String(MAXLEN = 20000, TRUNCATE = 1);

Property BoardName As %String(TRUNCATE = 1);

Property RefreshTrigger As %String(MAXLEN = 25000, TRUNCATE = 1);

Property FilterObject As %String(MAXLEN = 25000, TRUNCATE = 1);

Property PostAction As %String(MAXLEN = 25000, TRUNCATE = 1);

Property MixStr As %String(MAXLEN = 20000, TRUNCATE = 1);

Property MixStr2 As %String(MAXLEN = 20000, TRUNCATE = 1);

Property MixStr3 As %String(MAXLEN = 20000, TRUNCATE = 1);

Property DetailField As %String(TRUNCATE = 1);

Property DefaultVal As %String(MAXLEN = 20000, TRUNCATE = 1);

Property Caption As %String(MAXLEN = 25000, TRUNCATE = 1);

//Name of the Tab - Use as listing title

Property KPI As %String(MAXLEN = 25000, TRUNCATE = 1);

Property TheSchema As %String(TRUNCATE = 1);

Property KPIFilter As %String(MAXLEN = 25000, TRUNCATE = 1);

Property SchemaName As %String(TRUNCATE = 1);

Property Dimension As %String(TRUNCATE = 1);

Property OutputVariable As %String(TRUNCATE = 1);

Property AllowMultiSet As %String(TRUNCATE = 1);

Property ImageID As %String(TRUNCATE = 1);

Property Condition As %String(MAXLEN = 25000, TRUNCATE = 1);

Property TmpPic As %String(TRUNCATE = 1);

Property ImageID2 As %String(TRUNCATE = 1);

Property ImageID3 As %String(TRUNCATE = 1);

Property OnStartup As %String(TRUNCATE = 1);

Property TmpPic2 As %String(TRUNCATE = 1);

Property TmpPic3 As %String(TRUNCATE = 1);

Property SecurityLevel As %String(TRUNCATE = 1);

Property SecurityInquiry As %String(TRUNCATE = 1);

Property ItemPicture As %GlobalBinaryStream;

Property ItemPicture2 As %GlobalBinaryStream;

Property ItemPicture3 As %GlobalBinaryStream;

Property CustomCode As %String(MAXLEN = 25000, TRUNCATE = 1);

Property dashboardOrigin As %String(TRUNCATE = 1);

Property isGroup As %String(TRUNCATE = 1);

Property groupTop As %String(TRUNCATE = 1);

Property groupLeft As %String(TRUNCATE = 1);

Property groupWidth As %String(TRUNCATE = 1);

Property groupHeight As %String(TRUNCATE = 1);

Property groupItems As array Of %BI.BoardObjCom;

Method ControlNameGet() As %String
{
 if ..ControlID="" quit ""
 if ..ControlType="" quit ""
 if ..ControlType=1 quit $LG($G(^BI.PivotTableD(+..ControlID)),1)
 if ..ControlType=2 quit $LG($G(^BI.KPID(+..ControlID)),1)
 if ..ControlType=3 quit $LG($G(^BI.MapD(+..ControlID)),1)
 if ..ControlType=16 quit $LG($G(^BI.DetailListD(+..ControlID)),1)
 quit ""
}

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,ControlType,Caption,ImageID,ControlID,dashboardOrigin
FROM %BI.BoardObjCom
}

Storage Default
{
<Data name="BoardObjComDefaultData">
<Value name="1">
<Value>ControlID</Value>
</Value>
<Value name="2">
<Value>ControlType</Value>
</Value>
<Value name="3">
<Value>DisplayType</Value>
</Value>
<Value name="4">
<Value>TopCood</Value>
</Value>
<Value name="5">
<Value>LeftCood</Value>
</Value>
<Value name="6">
<Value>Height</Value>
</Value>
<Value name="7">
<Value>Width</Value>
</Value>
<Value name="8">
<Value>Tooltips</Value>
</Value>
<Value name="9">
<Value>BoardName</Value>
</Value>
<Value name="10">
<Value>RefreshTrigger</Value>
</Value>
<Value name="11">
<Value>FilterObject</Value>
</Value>
<Value name="12">
<Value>PostAction</Value>
</Value>
<Value name="13">
<Value>MixStr</Value>
</Value>
<Value name="14">
<Value>MixStr2</Value>
</Value>
<Value name="15">
<Value>DetailField</Value>
</Value>
<Value name="16">
<Value>DefaultVal</Value>
</Value>
<Value name="17">
<Value>Caption</Value>
</Value>
<Value name="18">
<Value>KPI</Value>
</Value>
<Value name="19">
<Value>TheSchema</Value>
</Value>
<Value name="20">
<Value>KPIFilter</Value>
</Value>
<Value name="21">
<Value>SchemaName</Value>
</Value>
<Value name="22">
<Value>Dimension</Value>
</Value>
<Value name="23">
<Value>OutputVariable</Value>
</Value>
<Value name="24">
<Value>AllowMultiSet</Value>
</Value>
<Value name="25">
<Value>ImageID</Value>
</Value>
<Value name="26">
<Value>Condition</Value>
</Value>
<Value name="27">
<Value>TmpPic</Value>
</Value>
<Value name="28">
<Value>ImageID2</Value>
</Value>
<Value name="29">
<Value>OnStartup</Value>
</Value>
<Value name="30">
<Value>TmpPic2</Value>
</Value>
<Value name="31">
<Value>SecurityLevel</Value>
</Value>
<Value name="32">
<Value>SecurityInquiry</Value>
</Value>
<Value name="33">
<Value>CustomCode</Value>
</Value>
<Value name="34">
<Value>MixStr3</Value>
</Value>
<Value name="35">
<Value>ImageID3</Value>
</Value>
<Value name="36">
<Value>TmpPic3</Value>
</Value>
<Value name="37">
<Value>ItemPicture</Value>
</Value>
<Value name="38">
<Value>ItemPicture2</Value>
</Value>
<Value name="39">
<Value>ItemPicture3</Value>
</Value>
<Value name="40">
<Value>dashboardOrigin</Value>
</Value>
<Value name="41">
<Value>isGroup</Value>
</Value>
<Value name="42">
<Value>groupLeft</Value>
</Value>
<Value name="43">
<Value>groupTop</Value>
</Value>
<Value name="44">
<Value>groupHeight</Value>
</Value>
<Value name="45">
<Value>groupWidth</Value>
</Value>
</Data>
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="groupItems">
<Attribute>groupItems</Attribute>
<Structure>subnode</Structure>
<Subscript>"groupItems"</Subscript>
</Data>
<DataLocation>^BI.BoardObjComD</DataLocation>
<DefaultData>BoardObjComDefaultData</DefaultData>
<IdLocation>^BI.BoardObjComD</IdLocation>
<IndexLocation>^BI.BoardObjComI</IndexLocation>
<StreamLocation>^BI.BoardObjComS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
