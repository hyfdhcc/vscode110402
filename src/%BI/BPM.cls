Class %BI.BPM Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index BPMNameIdx On BPMName [ Unique ];

Index Folder On Folder As Exact;

Property BPMName As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Folder As %String(MAXLEN = 2000, TRUNCATE = 1);

Property FolderName As %String(TRUNCATE = 1) [ Calculated, SqlComputeCode = { set {FolderName}=##class(%BI.BPM).GetFolderName({Folder})}, SqlComputed ];

Property KPI As array Of %BI.BPMKPI;

Property BSCategory As %String(MAXLEN = 800, TRUNCATE = 1);

ClassMethod GetFolderName(FolderID As %String) As %String
{
 if FolderID="" q ""
 quit $LG($G(^BI.FolderD(FolderID)),2)
}

Method FolderNameGet() As %String
{
 if ..Folder="" q ""
 quit $LG($G(^BI.FolderD(..Folder)),2)
}

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,BPMName,Folder,FolderName
FROM BPM
}

Storage Default
{
<Data name="BPMDefaultData">
<Value name="1">
<Value>Folder</Value>
</Value>
<Value name="2">
<Value>BPMName</Value>
</Value>
<Value name="3">
<Value>BSCategory</Value>
</Value>
</Data>
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="KPI">
<Attribute>KPI</Attribute>
<Structure>subnode</Structure>
<Subscript>"KPI"</Subscript>
</Data>
<DataLocation>^BI.BPMD</DataLocation>
<DefaultData>BPMDefaultData</DefaultData>
<IdLocation>^BI.BPMD</IdLocation>
<IndexLocation>^BI.BPMI</IndexLocation>
<StreamLocation>^BI.BPMS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
