Class %BI.Map Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property DefaultDisplayMode As %Numeric;

Property KPI As array Of %BI.MapKPI;

Property MapHeight As %String(TRUNCATE = 1);

Property MapIsNull As %Boolean [ Calculated, SqlComputeCode = { set {MapIsNull}=##class(%BI.Map).GetMapIsNull({ID})
}, SqlComputed ];

Property MapName As %String(TRUNCATE = 1) [ Required ];

Property MapPicture As %GlobalBinaryStream;

Property MapWidth As %String(TRUNCATE = 1);

Property ObjectOwner As %BI.Users;

ClassMethod GetMapIsNull(MapRow As %String) As %Boolean
{
 //n (MapRow)
 quit ##class(%BI.Map).%OpenId(MapRow).MapPicture.IsNull()
}

Method MapIsNullGet() As %Boolean
{
 quit ..MapPicture.IsNull()
}

Query AllMap() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,MapName,MapWidth,MapHeight,MapIsNull
FROM Map
}

Query ListAll(iUser As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT ID,MapName
FROM Map
WHERE ObjectOwner=:iUser
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"C"</Subscript>
</Data>
<Data name="KPI">
<Attribute>KPI</Attribute>
<Structure>subnode</Structure>
<Subscript>"K"</Subscript>
<Value name="1">
<Value>KPI1</Value>
</Value>
<Value name="2">
<Value>KPI2</Value>
</Value>
<Value name="3">
<Value>KPI3</Value>
</Value>
<Value name="4">
<Value>KPI4</Value>
</Value>
<Value name="5">
<Value>KPI5</Value>
</Value>
<Value name="6">
<Value>KPI6</Value>
</Value>
<Value name="7">
<Value>KPI7</Value>
</Value>
<Value name="8">
<Value>KPI8</Value>
</Value>
<Value name="9">
<Value>KPI9</Value>
</Value>
<Value name="10">
<Value>KPI10</Value>
</Value>
<Value name="11">
<Value>KPI11</Value>
</Value>
<Value name="12">
<Value>KPI12</Value>
</Value>
<Value name="13">
<Value>KPI13</Value>
</Value>
<Value name="14">
<Value>KPI14</Value>
</Value>
<Value name="15">
<Value>KPI15</Value>
</Value>
<Value name="16">
<Value>KPI16</Value>
</Value>
<Value name="17">
<Value>KPI17</Value>
</Value>
<Value name="18">
<Value>KPI18</Value>
</Value>
<Value name="19">
<Value>KPI19</Value>
</Value>
<Value name="20">
<Value>KPI20</Value>
</Value>
<Value name="21">
<Value>KPI21</Value>
</Value>
<Value name="22">
<Value>KPI22</Value>
</Value>
<Value name="23">
<Value>KPI23</Value>
</Value>
<Value name="24">
<Value>KPI24</Value>
</Value>
<Value name="25">
<Value>KPI25</Value>
</Value>
<Value name="26">
<Value>KPI26</Value>
</Value>
<Value name="27">
<Value>KPI27</Value>
</Value>
<Value name="28">
<Value>KPI28</Value>
</Value>
<Value name="29">
<Value>KPI29</Value>
</Value>
<Value name="30">
<Value>KPI30</Value>
</Value>
<Value name="31">
<Value>KPI31</Value>
</Value>
<Value name="32">
<Value>KPI32</Value>
</Value>
<Value name="33">
<Value>KPI33</Value>
</Value>
<Value name="34">
<Value>KPI34</Value>
</Value>
<Value name="35">
<Value>KPI35</Value>
</Value>
<Value name="36">
<Value>KPI36</Value>
</Value>
<Value name="37">
<Value>KPI37</Value>
</Value>
<Value name="38">
<Value>KPI38</Value>
</Value>
<Value name="39">
<Value>KPI39</Value>
</Value>
<Value name="40">
<Value>KPI40</Value>
</Value>
</Data>
<Data name="MapDefaultData">
<Value name="1">
<Value>MapName</Value>
</Value>
<Value name="2">
<Value>MapHeight</Value>
</Value>
<Value name="3">
<Value>MapWidth</Value>
</Value>
<Value name="4">
<Value>DefaultDisplayMode</Value>
</Value>
<Value name="5">
<Value>ObjectOwner</Value>
</Value>
</Data>
<Data name="Picture">
<Attribute>MapPicture</Attribute>
<Structure>node</Structure>
<Subscript>"P"</Subscript>
</Data>
<DataLocation>^BI.MapD</DataLocation>
<DefaultData>MapDefaultData</DefaultData>
<IdLocation>^BI.MapD</IdLocation>
<IndexLocation>^BI.MapI</IndexLocation>
<StreamLocation>^BI.MapS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
