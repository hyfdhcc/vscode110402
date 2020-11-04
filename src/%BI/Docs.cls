Class %BI.Docs Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property DocType As %String(DISPLAYLIST = ",Dimension,Computation,Measure,Subject,Pivot Table,Report", TRUNCATE = 1, VALUELIST = ",D,C,M,S,P,R");

Property DocName As %String(MAXLEN = 5000, TRUNCATE = 1);

Property ClassName As %String(MAXLEN = 5000, TRUNCATE = 1);

Property URL As %String(MAXLEN = 5000, TRUNCATE = 1);

//new add in 3/5/05

Property DocLanguage As %String(MAXLEN = 5000, TRUNCATE = 1);

Property DisplayType As %String(DISPLAYLIST = ",HTML,Text", TRUNCATE = 1, VALUELIST = ",H,T");

Property Content As %String(MAXLEN = 32000, TRUNCATE = 1);

Index MainIdx On (ClassName, DocType, DocName, DocLanguage, Ico);

Property DocId As %String(TRUNCATE = 1);

Property Ico As %String(TRUNCATE = 1);

Query ListAll() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,DocType,DocName,ClassName,DocLanguage
FROM %BI.Docs
}

Query ListAllByLanguage(DocLanguage As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,DocType,DocName,ClassName
FROM %BI.Docs
WHERE DocLanguage=:DocLanguage
}

Query BySALangType(Cls As %String, Doc As %String, Lang As %String, Type As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT DocId
FROM %BI.Docs
WHERE ClassName=:Cls AND DocName=:Doc AND DocType=:Type
}

/* ORIGINALLY: WHERE ClassName=:Cls AND DocName=:Doc AND DocLanguage=:Lang AND DocType=:Type */

/* the portion 'DocLanguage=:Lang' is temporarily taken out until the language translation is included */

/* this comment was typed by Chun Eng on 05 Sept 2005 */
Storage Default
{
<Data name="DocsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>Content</Value>
</Value>
<Value name="4">
<Value>DisplayType</Value>
</Value>
<Value name="5">
<Value>DocName</Value>
</Value>
<Value name="6">
<Value>DocType</Value>
</Value>
<Value name="7">
<Value>URL</Value>
</Value>
<Value name="8">
<Value>Language</Value>
</Value>
<Value name="9">
<Value>DocLanguage</Value>
</Value>
<Value name="10">
<Value>DocId</Value>
</Value>
<Value name="11">
<Value>Ico</Value>
</Value>
</Data>
<DataLocation>^BI.DocsD</DataLocation>
<DefaultData>DocsDefaultData</DefaultData>
<IdLocation>^BI.DocsD</IdLocation>
<IndexLocation>^BI.DocsI</IndexLocation>
<StreamLocation>^BI.DocsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
