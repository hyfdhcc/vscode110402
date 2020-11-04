Class %BI.BlogComment Extends (%Persistent, %BI.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property DateTime As %String(TRUNCATE = 1);

Property PostMessage As %String(MAXLEN = 25000, TRUNCATE = 1);

Property UserName As %String(TRUNCATE = 1);

Relationship Post As %BI.BlogPost [ Cardinality = parent, Inverse = Comment ];

Query ByBlogPostId(blogPostId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,DateTime,PostMessage,UserName,COUNT(*) AS TotalRow FROM BlogComment
 WHERE Post->ID = :blogPostId
}

Query CommentQuery() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,DateTime,PostMessage,UserName FROM BlogComment
}

Storage Default
{
<Data name="BlogCommentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateTime</Value>
</Value>
<Value name="3">
<Value>PostMessage</Value>
</Value>
<Value name="4">
<Value>UserName</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("C")</DataLocation>
<DefaultData>BlogCommentDefaultData</DefaultData>
<IdLocation>^BI.BlogCommentD</IdLocation>
<IndexLocation>^BI.BlogCommentI</IndexLocation>
<StreamLocation>^BI.BlogCommentS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
