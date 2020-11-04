Class %BI.ListField Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index CatName On (ClassName As Exact, CatName As Exact);

Index ClassProp On (ClassName As Exact, PropName As Exact);

Property AdditionalCondition As %String(TRUNCATE = 1);

Property CatName As %String(TRUNCATE = 1);

Property ClassName As %String(TRUNCATE = 1);

Property ComplexCode As %String(MAXLEN = 10000, TRUNCATE = 1);

Property DefParam As %String(TRUNCATE = 1);

Property StringConversion As %String(TRUNCATE = 1);

Property Definition As %String(MAXLEN = 5000, TRUNCATE = 1);

Property FieldShortCutAccess As %String(MAXLEN = 20000, TRUNCATE = 1);

Property IsActive As %Boolean;

Property LinkField As %String(TRUNCATE = 1);

Property MTranslation As %String(MAXLEN = 20000, TRUNCATE = 1);

Property NullField As %String(TRUNCATE = 1);

Property NullPointer As %String(TRUNCATE = 1);

Property PropName As %String(MAXLEN = 10000, TRUNCATE = 1);

Property Ranges As %String(MAXLEN = 10000, TRUNCATE = 1);

Property StartClass As %String(TRUNCATE = 1);

// change Property UseExternalValue As %Boolean; value to transformation type

Property TranslationType As %String(MAXLEN = 5000, TRUNCATE = 1);

Property AddFType As %String(TRUNCATE = 1);

Query ListByClass(cls As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,CatName FROM ListField
 WHERE (ClassName = :cls) ORDER BY CatName
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
<Value>TranslationType</Value>
</Value>
<Value name="15">
<Value>DefParam</Value>
</Value>
<Value name="16">
<Value>Ranges</Value>
</Value>
<Value name="17">
<Value>StringConversion</Value>
</Value>
<Value name="18">
<Value>DateType</Value>
</Value>
<Value name="19">
<Value>AddFType</Value>
</Value>
</Data>
<DataLocation>^BI.ListFieldD</DataLocation>
<DefaultData>MeasureDefaultData</DefaultData>
<IdLocation>^BI.ListFieldD</IdLocation>
<IndexLocation>^BI.ListFieldI</IndexLocation>
<StreamLocation>^BI.ListFieldS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
