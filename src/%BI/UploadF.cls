Class %BI.UploadF Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

//Property UpFile As %Library.FileBinaryStream;

//Property UpFile As %Stream(LOCATION = "d:\web\UploadF\", STORAGE = "FILE") [ Collection = binarystream ];

Property UpFile As %FileBinaryStream(LOCATION = "d:\web\UploadF\");

ClassMethod GetDaInfo(sRtn)
{
	s DName=$p(sRtn,$C(2),3)
	s DFold=$p(sRtn,$C(2),2)
	//s ^AlanChk("DName")=DName
	//s ^AlanChk("DFold")=DFold
	s DName=$p(DName,"|",2)
	w "DFolder="_DFold_";"
	w "DName="_##class(%CSP.Page).QuoteJS(DName)_";"
}

Storage Default
{
<Data name="UploadFDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UpFile</Value>
</Value>
</Data>
<DataLocation>^BI.UploadFD</DataLocation>
<DefaultData>UploadFDefaultData</DefaultData>
<IdLocation>^BI.UploadFD</IdLocation>
<IndexLocation>^BI.UploadFI</IndexLocation>
<StreamLocation>^BI.UploadFS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
