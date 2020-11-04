Class %BI.KnowledgeThreadPost Extends (%Persistent, %BI.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property AttachmentIndex As array Of %String(TRUNCATE = 1);

Relationship KnowledgeThread As %BI.KnowledgeThread [ Cardinality = parent, Inverse = KnowledgeThreadPost ];

Property LastEditDt As %String(TRUNCATE = 1);

Property PostDt As %String(TRUNCATE = 1);

Property PostMessage As %String(MAXLEN = 5000, TRUNCATE = 1);

Property PostTitle As %String(MAXLEN = 1000, TRUNCATE = 1);

Property PostUsername As %String(TRUNCATE = 1);

Property Type As %String(TRUNCATE = 1);

Property PriorityChanged As %String(MAXLEN = 5000);

/*Index KnowledgeThreadIndex On KnowledgeThread As Exact [ Data = (PostTitle, PostUsername) ];
*/
Storage Default
{
<Data name="AttachmentIndex">
<Attribute>AttachmentIndex</Attribute>
<Structure>subnode</Structure>
<Subscript>"AttachmentIndex"</Subscript>
</Data>
<Data name="KnowledgeThreadPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PostDt</Value>
</Value>
<Value name="3">
<Value>PostMessage</Value>
</Value>
<Value name="4">
<Value>PostTitle</Value>
</Value>
<Value name="5">
<Value>PostUser</Value>
</Value>
<Value name="6">
<Value>ChildPost</Value>
</Value>
<Value name="7">
<Value>ParentPost</Value>
</Value>
<Value name="8">
<Value>PostUsername</Value>
</Value>
<Value name="9">
<Value>PostViewCtr</Value>
</Value>
<Value name="10">
<Value>ThreadID</Value>
</Value>
<Value name="11">
<Value>PostRepliesCtr</Value>
</Value>
<Value name="12">
<Value>LastEditDt</Value>
</Value>
<Value name="13">
<Value>UpFile</Value>
</Value>
<Value name="14">
<Value>UpFile2</Value>
</Value>
<Value name="15">
<Value>UpFile3</Value>
</Value>
<Value name="16">
<Value>PriorityChanged</Value>
</Value>
<Value name="17">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("KnowledgeThreadPost")</DataLocation>
<DefaultData>KnowledgeThreadPostDefaultData</DefaultData>
<IdLocation>^BI.KnowledgeThreadC("KnowledgeThreadPost")</IdLocation>
<IndexLocation>^BI.KnowledgeThreadPostI</IndexLocation>
<StreamLocation>^BI.KnowledgeThreadPostS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
