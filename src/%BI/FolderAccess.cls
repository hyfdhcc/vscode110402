Class %BI.FolderAccess Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property FolderID As %String(TRUNCATE = 1);

Property AccessRight As %String(TRUNCATE = 1);

Property FolderName As %String(TRUNCATE = 1) [ Calculated ];

Method FolderNameGet() As %String
{
 if ..FolderID="" q ""
 quit $LG($G(^BI.FolderD(..FolderID)),2)
}

Storage Default
{
<Data name="FolderAccessState">
<Subscript>"%BI.FolderAccess"</Subscript>
<Value name="1">
<Value>AccessRight</Value>
</Value>
<Value name="2">
<Value>FolderID</Value>
</Value>
</Data>
<State>FolderAccessState</State>
<StreamLocation>^BI.FolderAccessS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
