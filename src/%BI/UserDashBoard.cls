Class %BI.UserDashBoard Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property SeqOrder As %Integer;

Index DashBoard On (DashBoard, Users);

Property BoardCaption;

Property DashBoard As %BI.DashBoard;

Property ShowOnDeskTop As %Boolean;

Property ShowOnLibrary As %Boolean;

Relationship Users As %BI.Users [ Cardinality = parent, Inverse = UserDashBoard ];

Query AllUserBoard(UserRow As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,DashBoard->ID,DashBoard->Caption,ShowOnDeskTop,ShowOnLibrary,BoardCaption
FROM %BI.UserDashBoard
WHERE Users=:UserRow
Order by SeqOrder
}

Query BoardNoSort(UserRow As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID
FROM %BI.UserDashBoard
WHERE Users=:UserRow
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="UserDashBoardDefaultData">
<Attribute>listnode</Attribute>
<Value name="1">
<Value>DashBoard</Value>
</Value>
<Value name="2">
<Value>BoardCaption</Value>
</Value>
<Value name="3">
<Value>ShowOnDeskTop</Value>
</Value>
<Value name="4">
<Value>ShowOnLibrary</Value>
</Value>
<Value name="5">
<Value>SeqOrder</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("UserDashBoard")</DataLocation>
<DefaultData>UserDashBoardDefaultData</DefaultData>
<IdLocation>^BI.UsersC("UserDashBoard")</IdLocation>
<IndexLocation>^BI.UserDashBoardI</IndexLocation>
<StreamLocation>^BI.UserDashBoardS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
