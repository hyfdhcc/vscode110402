Class %BI.KnowledgeAttachment Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property UpFile As %FileBinaryStream;

Storage Default
{
<Data name="KnowledgeAttachmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UpFile</Value>
</Value>
</Data>
<DataLocation>^BI.KnowledgeAttachmentD</DataLocation>
<DefaultData>KnowledgeAttachmentDefaultData</DefaultData>
<IdLocation>^BI.KnowledgeAttachmentD</IdLocation>
<IndexLocation>^BI.KnowledgeAttachmentI</IndexLocation>
<StreamLocation>^BI.KnowledgeAttachmentS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
