/// Font & Color Setting for Grid
Class %BI.WebGridFS Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index UID On UserID As Exact;

Property UserID As %Integer;

Property Name As %String(MAXLEN = 255, TRUNCATE = 1);

Property TopLeft As %String(TRUNCATE = 1);

Property TopRight As %String(TRUNCATE = 1);

Property BottomLeft As %String(TRUNCATE = 1);

Property BottomRight As %String(TRUNCATE = 1);

Property Border As %String(TRUNCATE = 1);

ClassMethod saveData(saveType, tid, fcSetting, sName)
{
	d saveData^%bi.SWr.WebGridFS(saveType,tid,fcSetting,sName)
}

ClassMethod loadSetting(tid)
{
	d loadSetting^%bi.SWr.WebGridFS(tid)
}

ClassMethod loadSampleList(tid)
{
	d loadSampleList^%bi.SWr.WebGridFS(tid)
}

ClassMethod delColorSample(tid)
{
	d delColorSample^%bi.SWr.WebGridFS(tid)
}

ClassMethod saveColorSample(tid)
{
	d saveColorSample^%bi.SWr.WebGridFS(tid)
}

ClassMethod saveToPivot(tid)
{
	d saveToPivot^%bi.SWr.WebGridFS(tid)
}

Storage Default
{
<Data name="WebGridFSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TopLeft</Value>
</Value>
<Value name="3">
<Value>Border</Value>
</Value>
<Value name="4">
<Value>BottomLeft</Value>
</Value>
<Value name="5">
<Value>BottomRight</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>TopRight</Value>
</Value>
<Value name="8">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^BI.WebGridFSD</DataLocation>
<DefaultData>WebGridFSDefaultData</DefaultData>
<IdLocation>^BI.WebGridFSD</IdLocation>
<IndexLocation>^BI.WebGridFSI</IndexLocation>
<StreamLocation>^BI.WebGridFSS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
