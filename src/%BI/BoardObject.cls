Class %BI.BoardObject Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property AllowMultiSelect As %Boolean;

Property OnStartup As %Boolean;

Property Caption As %String(MAXLEN = 25000, TRUNCATE = 1);

/* KPI Overide Setting */
Property KPI As %String(MAXLEN = 25000, TRUNCATE = 1);

Property KPIFilter As %String(MAXLEN = 25000, TRUNCATE = 1);

Property Condition As %String(MAXLEN = 25000, TRUNCATE = 1);

Property ImageID As %String(TRUNCATE = 1);

Property CustomCode As %String(MAXLEN = 25000, TRUNCATE = 1);

Property ImageName As %String(TRUNCATE = 1) [ Calculated ];

Method ImageNameGet() As %String
{
 quit $LG($G(^BI.ImageListD(+..ImageID)),1)
}

Property ImageID2 As %String(TRUNCATE = 1);

Property ImageID3 As %String(TRUNCATE = 1);

Property ImageName2 As %String(TRUNCATE = 1) [ Calculated ];

Method ImageName2Get() As %String
{
 quit $LG($G(^BI.ImageListD(+..ImageID2)),1)
}

Property DefaultVal As %String(MAXLEN = 20000, TRUNCATE = 1);

Property eDefaultVal As %String(TRUNCATE = 1) [ Calculated ];

Method eDefaultValGet() As %String
{
 if $E(..DefaultVal,1,2)="$$" q $$RUN^%bi.SMr.MinerUtils1(..DefaultVal,..DefaultVal)
 if $E(..DefaultVal,1,2)'="##" q ..DefaultVal
 s xVal=$E(..DefaultVal,3,999999)
 quit $$RUN^%bi.SMr.MinerUtils1(xVal,xVal)
}

Property DetailField As %String(TRUNCATE = 1);

Property ControlID As %String(TRUNCATE = 1);

Property ControlName As %String(TRUNCATE = 1) [ Calculated ];

Property ControlType As %Integer;

Property DataClass As %String(TRUNCATE = 1) [ Calculated ];

Property RefreshTrigger As %String(MAXLEN = 25000, TRUNCATE = 1);

Property SecurityLevel As %String(TRUNCATE = 1);

Property SecurityInquiry As %String(TRUNCATE = 1);

/* Store who refresh me */
Property FilterObject As %String(MAXLEN = 25000, TRUNCATE = 1);

/* Filtering object ID */
Property Dimension As %String(TRUNCATE = 1);

Property DisplayType As %Integer;

Property Height As %String;

Property ItemPicture As %GlobalBinaryStream;

Property ItemPicture2 As %GlobalBinaryStream;

Property ItemPicture3 As %GlobalBinaryStream;

Property LeftCord As %Integer;

Property MixStr As %String(MAXLEN = 20000, TRUNCATE = 1);

Property MixStr2 As %String(MAXLEN = 20000, TRUNCATE = 1);

Property MixStr3 As %String(MAXLEN = 20000, TRUNCATE = 1);

Property OutputVariable As %String(TRUNCATE = 1);

Property PostAction As %String(MAXLEN = 25000, TRUNCATE = 1);

Property Schema As %String(TRUNCATE = 1);

Property SchemaName As %String(TRUNCATE = 1) [ Calculated ];

Property ToolTips As %String(MAXLEN = 20000, TRUNCATE = 1);

Property TopCord As %Integer;

Property Width As %String;

Property Param As array Of %String(MAXLEN = 99999, TRUNCATE = 1);

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

Method DataClassGet() As %String
{
 quit (..GetDataClass(..Schema))
}

Method GetDataClass(dmid As %String) As %String
{
 i dmid="" q ""
 quit $$GetClass^%bi.SMr.DataMart1(dmid)
}

Method GetSchemaName(dmid As %String) As %String
{
 i dmid="" q ""
 quit $P($G(^SYS("BI","DM","Data",dmid)),$C(3),1)
}

Method SchemaNameGet() As %String
{
 quit (..GetSchemaName(..Schema))
}

Storage Default
{
<Data name="BoardObjectState">
<Attribute>listnode</Attribute>
<Subscript>"%BI.BoardObject"</Subscript>
<Value name="1">
<Value>ControlType</Value>
</Value>
<Value name="2">
<Value>Height</Value>
</Value>
<Value name="3">
<Value>LeftCord</Value>
</Value>
<Value name="4">
<Value>ToolTips</Value>
</Value>
<Value name="5">
<Value>TopCord</Value>
</Value>
<Value name="6">
<Value>Width</Value>
</Value>
<Value name="7">
<Value>Caption</Value>
</Value>
<Value name="8">
<Value>ControlID</Value>
</Value>
<Value name="9">
<Value>DisplayType</Value>
</Value>
<Value name="10">
<Value>MixStr</Value>
</Value>
<Value name="11">
<Value>ItemPicture</Value>
</Value>
<Value name="12">
<Value>OutputVariable</Value>
</Value>
<Value name="13">
<Value>Schema</Value>
</Value>
<Value name="14">
<Value>PostAction</Value>
</Value>
<Value name="15">
<Value>AllowMultiSelect</Value>
</Value>
<Value name="16">
<Value>Condition</Value>
</Value>
<Value name="17">
<Value>RefreshTrigger</Value>
</Value>
<Value name="18">
<Value>Dimension</Value>
</Value>
<Value name="19">
<Value>FilterObject</Value>
</Value>
<Value name="20">
<Value>DefaultVal</Value>
</Value>
<Value name="21">
<Value>KPI</Value>
</Value>
<Value name="22">
<Value>MixStr2</Value>
</Value>
<Value name="23">
<Value>DetailField</Value>
</Value>
<Value name="24">
<Value>SecurityLevel</Value>
</Value>
<Value name="25">
<Value>SecurityInquiry</Value>
</Value>
<Value name="26">
<Value>ImageID</Value>
</Value>
<Value name="27">
<Value>ImageID2</Value>
</Value>
<Value name="28">
<Value>ItemPicture2</Value>
</Value>
<Value name="29">
<Value>KPIFilter</Value>
</Value>
<Value name="30">
<Value>OnStartup</Value>
</Value>
<Value name="31">
<Value>CustomCode</Value>
</Value>
<Value name="32">
<Value>MixStr3</Value>
</Value>
<Value name="33">
<Value>ItemPicture3</Value>
</Value>
<Value name="34">
<Value>ImageID3</Value>
</Value>
<Value name="35">
<Value>Param</Value>
</Value>
<Value name="36">
<Value>SortOrder</Value>
</Value>
</Data>
<State>BoardObjectState</State>
<StreamLocation>^BI.BoardObjectS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
