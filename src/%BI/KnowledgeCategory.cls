Class %BI.KnowledgeCategory Extends (%Persistent, %BI.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property CategoryConsultant As %String(TRUNCATE = 1);

Property CategoryDescription As %String(MAXLEN = 200, TRUNCATE = 1);

Property CategoryTitle As %String(TRUNCATE = 1);

Relationship KnowledgeThread As %BI.KnowledgeThread [ Cardinality = children, Inverse = KnowledgeCategory ];

Property ParentCategory As %String(TRUNCATE = 1);

Property LastPostedDt As %String(TRUNCATE = 1);

Property ThreadOrderBy As %String(TRUNCATE = 1);

Property ThreadOrdering As %String(TRUNCATE = 1);

Property PostOrdering As %String(TRUNCATE = 1);

Property ShowPostTitle As %Boolean;

Property ThreadOrder As array Of %String(TRUNCATE = 1);

Property HelpDesk As %Boolean;

Property ACL As %String(MAXLEN = 10000);

Property SubModule As %String(MAXLEN = 10000);

Property PreModule As %String(MAXLEN = 10000);

/*Index CategoryIndexTitle On ParentCategory As Exact [ Data = CategoryTitle ];
*/
Query CountSubCat(ID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT Count(%ID) AS subcatcnt FROM KnowledgeCategory
 WHERE (ParentCategory = :ID)
}

Query CountNullCat(ID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT Count(%ID) AS nullcatcnt FROM KnowledgeCategory
 WHERE (ParentCategory is NULL)
}

Query GetSubCat(ID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID as ID FROM KnowledgeCategory
 WHERE (ParentCategory = :ID) ORDER BY CategoryTitle
}

Query GetCatConsultant(number As %Integer) As %SQLQuery
{
SELECT CategoryConsultant FROM KnowledgeCategory
WHERE %ID = :number
}

Query NavDownCategories(number As %String) As %SQLQuery
{
SELECT %ID,CategoryTitle,CategoryDescription,CategoryConsultant,HelpDesk FROM %BI.KnowledgeCategory
 WHERE ParentCategory = :number ORDER BY CategoryTitle
}

Query NavDownNullCategories() As %SQLQuery
{
SELECT %ID,CategoryTitle,CategoryDescription,CategoryConsultant,HelpDesk FROM %BI.KnowledgeCategory
 WHERE ParentCategory is NULL ORDER BY CategoryTitle
}

Query GetCatIdByName(name As %String) As %SQLQuery
{
SELECT %Id FROM %BI.KnowledgeCategory
 WHERE CategoryTitle = :name
}

Storage Default
{
<Data name="KnowledgeCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryTitle</Value>
</Value>
<Value name="3">
<Value>ParentCategory</Value>
</Value>
<Value name="4">
<Value>CategoryConsultant</Value>
</Value>
<Value name="5">
<Value>CategoryDescription</Value>
</Value>
<Value name="6">
<Value>LastPostedDt</Value>
</Value>
<Value name="7">
<Value>PostOrdering</Value>
</Value>
<Value name="8">
<Value>ThreadOrderBy</Value>
</Value>
<Value name="9">
<Value>ThreadOrdering</Value>
</Value>
<Value name="10">
<Value>HelpDesk</Value>
</Value>
<Value name="11">
<Value>ShowPostTitle</Value>
</Value>
<Value name="12">
<Value>ACL</Value>
</Value>
<Value name="13">
<Value>SubModule</Value>
</Value>
<Value name="14">
<Value>PreModule</Value>
</Value>
</Data>
<Data name="ThreadOrder">
<Attribute>ThreadOrder</Attribute>
<Structure>subnode</Structure>
<Subscript>"ThreadOrder"</Subscript>
</Data>
<DataLocation>^BI.KnowledgeCategoryD</DataLocation>
<DefaultData>KnowledgeCategoryDefaultData</DefaultData>
<IdLocation>^BI.KnowledgeCategoryD</IdLocation>
<IndexLocation>^BI.KnowledgeCategoryI</IndexLocation>
<StreamLocation>^BI.KnowledgeCategoryS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
