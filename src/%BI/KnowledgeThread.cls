Class %BI.KnowledgeThread Extends (%Persistent, %BI.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Description As %String(MAXLEN = 1000, TRUNCATE = 1);

Relationship KnowledgeThreadPost As %BI.KnowledgeThreadPost [ Cardinality = children, Inverse = KnowledgeThread ];

Relationship KnowledgeCategory As %BI.KnowledgeCategory [ Cardinality = parent, Inverse = KnowledgeThread ];

Property PostViewCtr As %String(TRUNCATE = 1);

Property PostRepliesCtr As %String(TRUNCATE = 1);

Property ThreadDt As %String(TRUNCATE = 1);

Property Title As %String(MAXLEN = 1000, TRUNCATE = 1);

Property TitleMessage As %String(MAXLEN = 5000, TRUNCATE = 1);

Property ThreadUserName As %String(TRUNCATE = 1);

Property LastEditDt As %String(TRUNCATE = 1);

Property AttachmentIndex As array Of %String(TRUNCATE = 1);

Property ThreadPostDt As %String(TRUNCATE = 1);

Property Status As %String;

Property Priority As %String;

Property DateCreate As %Date;

Property DateClose As %Date;

Property EditArea As %String;

Property LastPersonPost As %String;

Property SubModule As %String;

Property Type As %String;

Property Mail As %String(MAXLEN = 5000);

Property ConsultingAdvisor As %String;

Property ContactPerson As %String;

/*Index ThreadInfo On KnowledgeCategory [ Data = (ThreadDt, PostRepliesCtr, PostViewCtr) ];
*/
Storage Default
{
<Data name="AttachmentIndex">
<Attribute>AttachmentIndex</Attribute>
<Structure>subnode</Structure>
<Subscript>"AttachmentIndex"</Subscript>
</Data>
<Data name="KnowledgeThreadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PostRepliesCtr</Value>
</Value>
<Value name="3">
<Value>PostViewCtr</Value>
</Value>
<Value name="4">
<Value>ThreadDt</Value>
</Value>
<Value name="5">
<Value>PostMessage</Value>
</Value>
<Value name="6">
<Value>PostTitle</Value>
</Value>
<Value name="7">
<Value>PostUsername</Value>
</Value>
<Value name="8">
<Value>Title</Value>
</Value>
<Value name="9">
<Value>Description</Value>
</Value>
<Value name="10">
<Value>ThreadUserName</Value>
</Value>
<Value name="11">
<Value>TitleMessage</Value>
</Value>
<Value name="12">
<Value>LastEditDt</Value>
</Value>
<Value name="13">
<Value>ThreadPostDt</Value>
</Value>
<Value name="14">
<Value>Priority</Value>
</Value>
<Value name="15">
<Value>Status</Value>
</Value>
<Value name="16">
<Value>DateClose</Value>
</Value>
<Value name="17">
<Value>DateCreate</Value>
</Value>
<Value name="18">
<Value>ShowPostTitle</Value>
</Value>
<Value name="19">
<Value>EditArea</Value>
</Value>
<Value name="20">
<Value>LastPersonPost</Value>
</Value>
<Value name="21">
<Value>SubModule</Value>
</Value>
<Value name="22">
<Value>Type</Value>
</Value>
<Value name="23">
<Value>Mail</Value>
</Value>
<Value name="24">
<Value>ConsultingAdvisor</Value>
</Value>
<Value name="25">
<Value>ContactPerson</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("KnowledgeThread")</DataLocation>
<DefaultData>KnowledgeThreadDefaultData</DefaultData>
<IdLocation>^BI.KnowledgeCategoryC("KnowledgeThread")</IdLocation>
<IndexLocation>^BI.KnowledgeThreadI</IndexLocation>
<StreamLocation>^BI.KnowledgeThreadS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
