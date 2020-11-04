Class %BI.KPI Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index KPINameIdx On KPIName [ Unique ];

Index DM On DataMart As Exact;

Index Folder On Folder As Exact;

Property KPIName As %String(MAXLEN = 2000, TRUNCATE = 1);

Property KPIMaximum As %String;

Property KPIMinimum As %String;

Property DataMart As %String(TRUNCATE = 1);

Property Variable As %String(MAXLEN = 20000, TRUNCATE = 1);

Property Formula As %String(MAXLEN = 20000, TRUNCATE = 1);

Property IsActive As %Boolean;

Property KPIQuery As %String(MAXLEN = 20000, TRUNCATE = 1);

Property Metrics As %String(MAXLEN = 200, TRUNCATE = 1);

Property RangeKPIDR As %String(MAXLEN = 10, TRUNCATE = 1);

Property StaticDays As %Numeric;

Property RangeKPIDRName As %String(TRUNCATE = 1) [ Calculated ];

Method RangeKPIDRNameGet() As %String
{
 i ..RangeKPIDR="" q ""
 quit $LG($G(^BI.KPID(..RangeKPIDR)),1)
}

Property MetricName As %String(TRUNCATE = 1) [ Calculated, SqlComputeCode = { set {MetricName}=##class(%BI.KPI).GetMetricName({Metrics})}, SqlComputed ];

Property DataMartName As %String(TRUNCATE = 1) [ Calculated, SqlComputeCode = { set {DataMartName}=##class(%BI.KPI).GetDataMartName({DataMart})}, SqlComputed ];

Property FolderName As %String(TRUNCATE = 1) [ Calculated ];

Property Folder As %String(TRUNCATE = 1);

Property RangeDisplay As array Of %BI.RangeDisplay;

Property KPIChild As array Of %BI.KPIList;

Method FolderNameGet() As %String
{
 if ..Folder="" q ""
 quit $LG($G(^BI.FolderD(..Folder)),2)
}

ClassMethod GetDataMartName(dmid As %String) As %String
{
 if dmid="" q ""
 quit $P($G(^SYS("BI","DM","Data",dmid)),$C(3),1)
}

Method KPIValue() As %String
{
 quit $$KPI^%bi.SMr.KPI3(..%Id())
}

Method MetricNameGet() As %String
{
 quit (..GetMetricName(..Metrics))
}

ClassMethod GetMetricName(MetricID As %String) As %String
{
 i MetricID="" q ""
 i $E(MetricID,1)="*" q $E(MetricID,2,9999)
 quit $P($G(^SYS("BI","DM","Data",+MetricID,"Metric",$P(MetricID,"||",2))),$C(3),1)
}

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,KPIName,DataMartName,Folder,DataMart
FROM KPI
Order by DataMart
}

Query ListAll2() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,KPIName,DataMartName,Folder,DataMart
FROM KPI
Order by KPIName
}

Query byFolder(folderId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,KPIName,DataMartName,DataMart,Formula,KPIQuery,Metrics FROM KPI
 WHERE (Folder = :folderId)
 ORDER BY KPIName
}

Storage Default
{
<Data name="Formula">
<Attribute>Formula</Attribute>
<Structure>node</Structure>
<Subscript>"F"</Subscript>
</Data>
<Data name="KPIChild">
<Attribute>KPIChild</Attribute>
<Structure>subnode</Structure>
<Subscript>"C"</Subscript>
</Data>
<Data name="KPIClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="KPIDefaultData">
<Value name="1">
<Value>KPIName</Value>
</Value>
<Value name="2">
<Value>DataMart</Value>
</Value>
<Value name="3">
<Value>IsActive</Value>
</Value>
<Value name="4">
<Value>KPIQuery</Value>
</Value>
<Value name="5">
<Value>Metrics</Value>
</Value>
<Value name="6">
<Value>RangeKPIDR</Value>
</Value>
<Value name="7">
<Value>Variable</Value>
</Value>
<Value name="8">
<Value>KPIMaximum</Value>
</Value>
<Value name="9">
<Value>KPIMinimum</Value>
</Value>
<Value name="10">
<Value>Folder</Value>
</Value>
<Value name="11">
<Value>StaticDays</Value>
</Value>
</Data>
<Data name="RangeDisplay">
<Attribute>RangeDisplay</Attribute>
<Structure>subnode</Structure>
<Subscript>"R"</Subscript>
</Data>
<DataLocation>^BI.KPID</DataLocation>
<DefaultData>KPIDefaultData</DefaultData>
<IdLocation>^BI.KPID</IdLocation>
<IndexLocation>^BI.KPII</IndexLocation>
<StreamLocation>^BI.KPIS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
