Class %BI.UserRole Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index Role On (Roles As Exact, Users As Exact);

Property Roles As %BI.Roles;

Relationship Users As %BI.Users [ Cardinality = parent, Inverse = UserRole ];

Query AllUserRole(UserRow As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Roles
FROM %BI.UserRole
WHERE Users=:UserRow
}

Query AllRoleUser(RoleRow As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Users->FullName
FROM %BI.UserRole
WHERE Roles=:RoleRow
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="UserRoleDefaultData">
<Value name="1">
<Value>Roles</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("UserRole")</DataLocation>
<DefaultData>UserRoleDefaultData</DefaultData>
<IdLocation>^BI.UsersC("UserRole")</IdLocation>
<IndexLocation>^BI.UserRoleI</IndexLocation>
<StreamLocation>^BI.UserRoleS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
