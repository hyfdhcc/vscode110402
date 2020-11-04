Class %BI.BlogPost Extends (%Persistent, %BI.Adaptor, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Category As %String(TRUNCATE = 1);

Property SubCategory As %String(TRUNCATE = 1);

Property Title As %String(MAXLEN = 250, TRUNCATE = 1);

Property DateTime As %String(MAXLEN = 100, TRUNCATE = 1);

Property PostMessage As %String(MAXLEN = 25000, TRUNCATE = 1);

Property PostUser As %String(MAXLEN = 250, TRUNCATE = 1);

Relationship Blog As %BI.Blog [ Cardinality = parent, Inverse = Post ];

Relationship Comment As %BI.BlogComment [ Cardinality = children, Inverse = Post ];

Query ListAll() As %SQLQuery
{
SELECT Category FROM BlogPost
}

Query ByBlogId(BlogID) As %SQLQuery
{
SELECT ID,PostUser,DateTime,Title,PostMessage,Category FROM BlogPost WHERE Blog->ID=:BlogID
}

Storage Default
{
<Data name="BlogPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Category</Value>
</Value>
<Value name="3">
<Value>DateTime</Value>
</Value>
<Value name="4">
<Value>Post</Value>
</Value>
<Value name="5">
<Value>PostUser</Value>
</Value>
<Value name="6">
<Value>SubCategory</Value>
</Value>
<Value name="7">
<Value>Title</Value>
</Value>
<Value name="8">
<Value>PostMessage</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("P")</DataLocation>
<DefaultData>BlogPostDefaultData</DefaultData>
<IdLocation>^BI.BlogPostD</IdLocation>
<IndexLocation>^BI.BlogPostI</IndexLocation>
<StreamLocation>^BI.BlogPostS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
