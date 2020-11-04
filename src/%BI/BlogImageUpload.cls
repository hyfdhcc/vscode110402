Class %BI.BlogImageUpload Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property UpFile As %FileBinaryStream;

/*
ClassMethod setSession(argObj)
{
    s %session.Data("argObj") = argObj
    w "alert("_argObj_");"
}
*/
Storage Default
{
<Data name="BlogImageUploadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UpFile</Value>
</Value>
</Data>
<DataLocation>^BI.BlogImageUploadD</DataLocation>
<DefaultData>BlogImageUploadDefaultData</DefaultData>
<IdLocation>^BI.BlogImageUploadD</IdLocation>
<IndexLocation>^BI.BlogImageUploadI</IndexLocation>
<StreamLocation>^BI.BlogImageUploadS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
