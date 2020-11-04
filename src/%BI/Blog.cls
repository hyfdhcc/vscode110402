Class %BI.Blog Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Folder As %String(TRUNCATE = 1);

Property Owner As %String(TRUNCATE = 1);

Relationship Post As %BI.BlogPost [ Cardinality = children, Inverse = Blog ];

Property Title As %String(MAXLEN = 250, TRUNCATE = 1);

Property Users As array Of %String(TRUNCATE = 1);

Query BlogAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Title,Folder FROM Blog
}

Query ByTitle(Title) As %SQLQuery
{
SELECT Title FROM Blog
 WHERE (Title = :Title)
 ORDER BY Title
}

Query BlogFolder(folder) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Title FROM Blog
where (Folder = :folder)
ORDER BY Title
}

Storage Default
{
<Data name="BlogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Folder</Value>
</Value>
<Value name="3">
<Value>Owner</Value>
</Value>
<Value name="4">
<Value>Title</Value>
</Value>
</Data>
<Data name="Users">
<Attribute>Users</Attribute>
<Structure>subnode</Structure>
<Subscript>"Users"</Subscript>
</Data>
<DataLocation>^BI.BlogD</DataLocation>
<DefaultData>BlogDefaultData</DefaultData>
<IdLocation>^BI.BlogD</IdLocation>
<IndexLocation>^BI.BlogI</IndexLocation>
<StreamLocation>^BI.BlogS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
