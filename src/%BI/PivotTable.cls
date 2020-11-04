Class %BI.PivotTable Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index Folder On Folder As Exact;

Index MOLAP On MOLAPClass As Exact;

Property ChartAttrib As %Library.Stream;

Property ColMeasure As %String(MAXLEN = 32000, TRUNCATE = 1);

Property DataMart As %String(MAXLEN = 2000, TRUNCATE = 1);

Property SyncOption As %Integer;

Property RowCustomGroup As %String(MAXLEN = 32000, TRUNCATE = 1);

Property ColCustomGroup As %String(MAXLEN = 32000, TRUNCATE = 1);

Property RankRemain As %String(MAXLEN = 2000, TRUNCATE = 1);

Property ChartFormat As %String(MAXLEN = 32000, TRUNCATE = 1);

Property HideColumns As %String(MAXLEN = 32000, TRUNCATE = 1);

Property HideRows As %String(MAXLEN = 32000, TRUNCATE = 1);

Property DataMartName As %String(TRUNCATE = 1) [ Calculated, SqlComputeCode = { set {DataMartName}=##class(%BI.PivotTable).GetDataMartName({DataMart})
}, SqlComputed ];

Property EffQuery As %String(TRUNCATE = 1) [ Calculated, SqlComputeCode = { set {EffQuery}=##class(%BI.PivotTable).GetEffQuery({DataMart},{TableQuery})
}, SqlComputed ];

Property Folder As %String(TRUNCATE = 1);

Property MOLAPClass As %String(TRUNCATE = 1);

Property MOLAPColumn As %String(TRUNCATE = 1);

Property FolderName As %String(TRUNCATE = 1) [ Calculated ];

Property MetricStr As %String(TRUNCATE = 1) [ Calculated, SqlComputeCode = { set {MetricStr}=##class(%BI.PivotTable).GetMetricStr({DataMart},{Metrics})
}, SqlComputed ];

Property Metrics As %String(MAXLEN = 32000, TRUNCATE = 1);

Property ObjectOwner As %BI.Users;

Property PivotName As %String(MAXLEN = 300, TRUNCATE = 1) [ Required ];

Property PivotNotes As %String(MAXLEN = 32000, TRUNCATE = 0);

Property QueryCom As %String(MAXLEN = 2000, TRUNCATE = 1);

Property QueryVariable As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Ranking As %String(MAXLEN = 2000, TRUNCATE = 1);

Property RowAggregateOption As %Integer;

Property RowMeasure As %String(MAXLEN = 32000, TRUNCATE = 1);

Property ShowColumnAvg As %Boolean;

Property ShowColumnTotal As %Boolean;

Property RecreateMOLAPClass As %Boolean;

Property StaticReport As %Boolean;

Property SuppressNullRows As %Boolean;

Property TableClass As %String(TRUNCATE = 1) [ Calculated, SqlComputeCode = { set {TableClass}=##class(%BI.PivotTable).GetTableClass({DataMart})
}, SqlComputed ];

Property TableQuery As %String(MAXLEN = 32000, TRUNCATE = 1);

Property SQLClause As %String(MAXLEN = 32000, TRUNCATE = 1);

Property LinkReport As %String(MAXLEN = 32000, TRUNCATE = 1);

Property UnionReport As %String(MAXLEN = 32000, TRUNCATE = 1);

Property DrillDownReport As %String(MAXLEN = 32000, TRUNCATE = 1);

Property NestedReport As %String(MAXLEN = 32000, TRUNCATE = 1);

Property PivotClass As %String(TRUNCATE = 1);

Property PivotCat As %String(TRUNCATE = 1);

Property ExcelLayout As %String(TRUNCATE = 1);

Property ExcelDrillDownInfo As %String(TRUNCATE = 1);

Property ExcelFilterInfo As %String(TRUNCATE = 1);

Index SYNC On (PivotClass As Exact, SyncOption As Exact) [ Data = MOLAPClass ];

// Same as Table Class, but stored value

Method %OnAfterSave(insert As %Boolean) As %Status [ Final ]
{
 set Id=..%Id()
 
 K ^BI.PivotTableD(Id,"SS") 
 K ^BI.PivotTableD(Id,"SH") 
 K ^BI.PivotTableD(Id,"SD") 
 quit 1
}

Method EffQueryGet() As %String
{
 quit (..GetEffQuery(..DataMart,..TableQuery))
}

Method FolderNameGet() As %String
{
 if ..Folder="" q ""
 quit $LG($G(^BI.FolderD(..Folder)),2)
}

ClassMethod GetDataMartName(dmid As %String) As %String
{
 quit $P($G(^SYS("BI","DM","Data",+dmid)),$C(3),1)
}

ClassMethod GetEffQuery(dmid As %String, tabquery As %String) As %String
{
 ;n (dmid,tabquery)

 s qy=$$GetQuery^%bi.SMr.DataMart1(dmid)
 i qy="" quit tabquery
 i tabquery="" quit qy
 i qy[" OR " s qy="["_qy_"]"	
 i tabquery[" OR " s tabquery="["_tabquery_"]"

 quit qy_" AND "_tabquery
}

ClassMethod GetMetricStr(dmid As %String, iMetric As %String) As %String
{
 ;n (dmid,iMetric)
 i iMetric="" q ""
 d Load^%bi.SMr.Metric1(dmid)
 q:'$D(PLIST) ""
 f i=1:1:PLIST s itm=$P(PLIST(i),$C(3),2) i itm'="" s MLIST(itm)=$P(PLIST(i),$C(3),1)_$C(3)_$P(PLIST(i),$C(3),3,5)
 s oMetric=""
 s MLIST("Count")="Count"
 f i=1:1:$L(iMetric,$C(2)) d
 . s itm=$P(iMetric,$C(2),i) q:itm=""
 . q:'$D(MLIST(itm))
 . i oMetric'="" s oMetric=oMetric_$C(2)
 . i itm="Count" s oMetric=oMetric_itm_$C(4)_0 q
 . s oMetric=oMetric_itm_$C(4)_MLIST(itm)
 quit oMetric
}

ClassMethod GetTableClass(dmid As %String) As %String
{
 ;n (dmid)
 quit $$GetClass^%bi.SMr.DataMart1(dmid)
}

Method MetricStrGet() As %String
{
 quit (..GetMetricStr(..DataMart,..Metrics))
}

Method TableClassGet() As %String
{
 quit (..GetTableClass(..DataMart))
}

Query FolderAll(iFolder As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,PivotName
FROM %BI.PivotTable
WHERE Folder=:iFolder
ORDER BY PivotName
}

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,PivotName,DataMartName,Folder,PivotNotes
FROM %BI.PivotTable ORDER BY PivotName
}

Query ByTableClass(Class As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,PivotName
FROM %BI.PivotTable
WHERE TableClass=:Class
}

Storage Default
{
<Data name="ChartAttribute">
<Attribute>ChartAttrib</Attribute>
<Structure>node</Structure>
<Subscript>"A"</Subscript>
</Data>
<Data name="ChartFormat">
<Attribute>ChartFormat</Attribute>
<Structure>node</Structure>
<Subscript>"F"</Subscript>
</Data>
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="ColumnMeasureData">
<Attribute>ColMeasure</Attribute>
<Structure>node</Structure>
<Subscript>"C"</Subscript>
</Data>
<Data name="MetricsData">
<Attribute>Metrics</Attribute>
<Structure>node</Structure>
<Subscript>"M"</Subscript>
</Data>
<Data name="PivotNoteData">
<Attribute>PivotNotes</Attribute>
<Structure>node</Structure>
<Subscript>"N"</Subscript>
</Data>
<Data name="PivotTableDefaultData">
<Attribute>listnode</Attribute>
<Value name="1">
<Value>PivotName</Value>
</Value>
<Value name="2">
<Value>DataMart</Value>
</Value>
<Value name="3">
<Value>QueryCom</Value>
</Value>
<Value name="4">
<Value>QueryVariable</Value>
</Value>
<Value name="5">
<Value>Ranking</Value>
</Value>
<Value name="6">
<Value>RowAggregateOption</Value>
</Value>
<Value name="7">
<Value>ShowColumnAvg</Value>
</Value>
<Value name="8">
<Value>ShowColumnTotal</Value>
</Value>
<Value name="9">
<Value>SuppressNullRows</Value>
</Value>
<Value name="10">
<Value>TableQuery</Value>
</Value>
<Value name="11">
<Value>StaticReport</Value>
</Value>
<Value name="12">
<Value>ObjectOwner</Value>
</Value>
<Value name="13">
<Value>Folder</Value>
</Value>
<Value name="14">
<Value>RankRemain</Value>
</Value>
<Value name="15">
<Value>LinkReport</Value>
</Value>
<Value name="16">
<Value>HideColumns</Value>
</Value>
<Value name="17">
<Value>DrillDownReport</Value>
</Value>
<Value name="18">
<Value>MOLAPClass</Value>
</Value>
<Value name="19">
<Value>SyncOption</Value>
</Value>
<Value name="20">
<Value>PivotClass</Value>
</Value>
<Value name="21">
<Value>MOLAPColumn</Value>
</Value>
<Value name="22">
<Value>RecreateMOLAPClass</Value>
</Value>
<Value name="23">
<Value>UnionReport</Value>
</Value>
<Value name="24">
<Value>ColCustomGroup</Value>
</Value>
<Value name="25">
<Value>RowCustomGroup</Value>
</Value>
<Value name="26">
<Value>PivotThread</Value>
</Value>
<Value name="27">
<Value>PivotCat</Value>
</Value>
<Value name="28">
<Value>NestedReport</Value>
</Value>
<Value name="29">
<Value>HideRows</Value>
</Value>
<Value name="30">
<Value>ExcelLayout</Value>
</Value>
<Value name="31">
<Value>ExcelDrillDownInfo</Value>
</Value>
<Value name="32">
<Value>ExcelFilterInfo</Value>
</Value>
</Data>
<Data name="RowMeasureData">
<Attribute>RowMeasure</Attribute>
<Structure>node</Structure>
<Subscript>"R"</Subscript>
</Data>
<Data name="SQLClause">
<Attribute>SQLClause</Attribute>
<Structure>node</Structure>
<Subscript>"S"</Subscript>
</Data>
<DataLocation>^BI.PivotTableD</DataLocation>
<DefaultData>PivotTableDefaultData</DefaultData>
<IdLocation>^BI.PivotTableD</IdLocation>
<IndexLocation>^BI.PivotTableI</IndexLocation>
<StreamLocation>^BI.PivotTableS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
