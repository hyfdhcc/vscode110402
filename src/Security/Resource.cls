Include (%sySecurity, %syAudit, %occSystemMessages)

Class Security.Resource Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, System = 4 ]
{

/// Name of the resource.
Property Name As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Permission attached to the resource.<br>
/// Bit 0 - Read<br>
/// Bit 1 - Write<br>
/// Bit 2 - Use<br>
Property Permission As Security.Datatype.Permission [ Required ];

Relationship TheRole As Security.Roles [ Cardinality = parent, Internal, Inverse = Resources ];

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private, ProcedureBlock = 1 ]
{
}

Storage Default
{
<Data name="ResourceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Permission</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Resources")</DataLocation>
<DefaultData>ResourceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","RolesC","Resources")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ResourceI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ResourceS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
