Class %BI.Roles Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Description As %String(MAXLEN = 60, TRUNCATE = 1);

Property ParentRole As %BI.Roles;

Property LicMax As %String;

Property MinDrl As %String;

Property MdLog As %String;

Index Desc On Description [ Unique ];

Query AllRoles() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Description,ParentRole,LicMax,MinDrl FROM %BI.Roles ORDER BY Description
}

Query RolesByPar(id) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Description,ParentRole,LicMax,MinDrl FROM %BI.Roles
WHERE (ParentRole = :id)
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="RolesDefaultData">
<Value name="1">
<Value>Description</Value>
</Value>
<Value name="2">
<Value>ParentRole</Value>
</Value>
<Value name="3">
<Value>LicMax</Value>
</Value>
<Value name="4">
<Value>MinDrl</Value>
</Value>
<Value name="5">
<Value>MdLog</Value>
</Value>
<Value name="6">
<Value>ChildRole</Value>
</Value>
</Data>
<DataLocation>^BI.RolesD</DataLocation>
<DefaultData>RolesDefaultData</DefaultData>
<IdLocation>^BI.RolesD</IdLocation>
<IndexLocation>^BI.RolesI</IndexLocation>
<StreamLocation>^BI.RolesS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
