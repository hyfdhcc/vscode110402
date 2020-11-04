Class %BI.Measure Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index CatName On (ClassName As Exact, CatName As Exact);

Index ClassProp On (ClassName As Exact, PropName As Exact);

Property AdditionalCondition As %String(TRUNCATE = 1);

Property CatName As %String(TRUNCATE = 1);

Property ClassName As %String(TRUNCATE = 1);

Property ComplexCode As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Definition As %String(MAXLEN = 5000, TRUNCATE = 1);

// new adding property from transformation nb: measure1.MAC also change

Property TranslationType As %String(MAXLEN = 5000, TRUNCATE = 1);

Property IsActive As %Boolean;

Property ListingField As %Boolean;

Property DimensionField As %Boolean;

Property LinkField As %String(TRUNCATE = 1);

Property NullField As %String(TRUNCATE = 1);

Property NullPointer As %String(TRUNCATE = 1);

Property FieldShortCutAccess As %String(MAXLEN = 20000, TRUNCATE = 1);

Property MTranslation As %String(MAXLEN = 20000, TRUNCATE = 1);

Property ChildLoop As %String(MAXLEN = 10000, TRUNCATE = 1);

Property ChildFetch As %String(MAXLEN = 10000, TRUNCATE = 1);

Property ChildClose As %String(MAXLEN = 10000, TRUNCATE = 1);

Property ChildInit As %String(MAXLEN = 10000, TRUNCATE = 1);

Property PropName As %String(MAXLEN = 10000, TRUNCATE = 1);

Property StartClass As %String(TRUNCATE = 1);

Property Ranges As %String(MAXLEN = 10000, TRUNCATE = 1);

Property SelectiveRebuild As %Boolean;

Property LinkTo As %String(MAXLEN = 10000);

Property RangeSuffix As %String;

Property DimPreScrpt As %String;

Property DimPostScrpt As %String;

Property DimSQL As %String;

Property DimCntNode As %Integer;

Query ListByClass(class As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,CatName FROM Measure 
 WHERE (ClassName = :class) ORDER BY CatName
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="MeasureDefaultData">
<Value name="1">
<Value>FieldShortCutAccess</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>CatName</Value>
</Value>
<Value name="4">
<Value>StartClass</Value>
</Value>
<Value name="5">
<Value>PropName</Value>
</Value>
<Value name="6">
<Value>LinkField</Value>
</Value>
<Value name="7">
<Value>Definition</Value>
</Value>
<Value name="8">
<Value>NullField</Value>
</Value>
<Value name="9">
<Value>NullPointer</Value>
</Value>
<Value name="10">
<Value>IsActive</Value>
</Value>
<Value name="11">
<Value>AdditionalCondition</Value>
</Value>
<Value name="12">
<Value>ComplexCode</Value>
</Value>
<Value name="13">
<Value>MTranslation</Value>
</Value>
<Value name="14">
<Value>ChildLoop</Value>
</Value>
<Value name="15">
<Value>DimensionField</Value>
</Value>
<Value name="16">
<Value>Ranges</Value>
</Value>
<Value name="17">
<Value>ListingField</Value>
</Value>
<Value name="18">
<Value>ChildFetch</Value>
</Value>
<Value name="19">
<Value>ChildClose</Value>
</Value>
<Value name="20">
<Value>TranslationType</Value>
</Value>
<Value name="21">
<Value>SelectiveRebuild</Value>
</Value>
<Value name="22">
<Value>ChildInit</Value>
</Value>
<Value name="23">
<Value>LinkTo</Value>
</Value>
<Value name="24">
<Value>RangeSuffix</Value>
</Value>
<Value name="25">
<Value>DimPostScrpt</Value>
</Value>
<Value name="26">
<Value>DimPreScrpt</Value>
</Value>
<Value name="27">
<Value>DimSQL</Value>
</Value>
<Value name="28">
<Value>DimCntNode</Value>
</Value>
</Data>
<DataLocation>^BI.MeasureD</DataLocation>
<DefaultData>MeasureDefaultData</DefaultData>
<IdLocation>^BI.MeasureD</IdLocation>
<IndexLocation>^BI.MeasureI</IndexLocation>
<StreamLocation>^BI.MeasureS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
