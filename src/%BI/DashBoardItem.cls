Class %BI.DashBoardItem Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property DashBoard As %String(TRUNCATE = 1);

Property DashBoardName As %String(TRUNCATE = 1) [ Calculated ];

Method DashBoardNameGet() As %String
{
 if ..DashBoard="" q ""
 quit $LG($G(^BI.DashBoardD(..DashBoard)),1)
}

Storage Default
{
<Data name="DashBoardItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DashBoard</Value>
</Value>
</Data>
<DataLocation>^BI.DashBoardItemD</DataLocation>
<DefaultData>DashBoardItemDefaultData</DefaultData>
<IdLocation>^BI.DashBoardItemD</IdLocation>
<IndexLocation>^BI.DashBoardItemI</IndexLocation>
<StreamLocation>^BI.DashBoardItemS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
