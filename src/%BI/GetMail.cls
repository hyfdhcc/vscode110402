Class %BI.GetMail Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

//Property UpFile As %Library.FileBinaryStream;

Property UpFile As %FileBinaryStream(LOCATION = "d:\web\Upload\");

Storage Default
{
<Data name="GetMailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UpFile</Value>
</Value>
</Data>
<DataLocation>^BI.GetMailD</DataLocation>
<DefaultData>GetMailDefaultData</DefaultData>
<IdLocation>^BI.GetMailD</IdLocation>
<IndexLocation>^BI.GetMailI</IndexLocation>
<StreamLocation>^BI.GetMailS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
