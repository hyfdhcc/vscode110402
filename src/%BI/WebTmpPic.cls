Class %BI.WebTmpPic Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property ThePicture As %GlobalBinaryStream;

Storage Default
{
<Data name="WebTmpPicDefaultData">
<Value name="1">
<Value>ThePicture</Value>
</Value>
<Value name="2">
<Value>str1</Value>
</Value>
<Value name="3">
<Value>str2</Value>
</Value>
<Value name="4">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^BI.WebTmpPicD</DataLocation>
<DefaultData>WebTmpPicDefaultData</DefaultData>
<IdLocation>^BI.WebTmpPicD</IdLocation>
<IndexLocation>^BI.WebTmpPicI</IndexLocation>
<StreamLocation>^BI.WebTmpPicS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

Storage NewStorage1
{
<Type>%CacheStorage</Type>
}

}
