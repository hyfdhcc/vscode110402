Class %BI.WebMainTable [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod Save(type, code, data)
{
	d Save^%bi.SWrCE.MapTable(type,code,data)
}

ClassMethod Delete(type, code, id)
{
	d Delete^%bi.SWrCE.MapTable(type,code,id)
}

ClassMethod Update(type, code, data, oldCode)
{
	d Update^%bi.SWrCE.MapTable(type,code,data,oldCode)
}

ClassMethod LoadTables(type)
{
	d LoadTables^%bi.SWrCE.MapTable(type)
}

ClassMethod Warn(type)
{
	d Warn^%bi.SWrCE.MapTable(type)
}

ClassMethod CleanQuote(str) As %String
{
	d CleanQuote^%bi.SWrCE.MapTable(str)
}

Storage Default
{
<Data name="WebMainTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^BI.WebMainTableD</DataLocation>
<DefaultData>WebMainTableDefaultData</DefaultData>
<IdLocation>^BI.WebMainTableD</IdLocation>
<IndexLocation>^BI.WebMainTableI</IndexLocation>
<StreamLocation>^BI.WebMainTableS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
