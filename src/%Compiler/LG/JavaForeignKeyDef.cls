Class %Compiler.LG.JavaForeignKeyDef Extends %SerialObject [ System = 4 ]
{

Property Description As %CacheString;

Property Internal As %Boolean [ InitialExpression = 0 ];

Property Name As %Dictionary.CacheIdentifier;

Property OnDelete As %CacheString [ InitialExpression = "noaction" ];

Property OnUpdate As %CacheString [ InitialExpression = "noaction" ];

Property Properties As %CacheString;

Property ReferencedClass As %Dictionary.CacheClassname;

Property ReferencedKey As %CacheString;

Property SequenceNumber As %Integer [ InitialExpression = 0 ];

Property SqlName As %CacheString;

Property PropertiesList As list Of %CacheString;

Storage Default
{
<Data name="JavaForeignKeyDefDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Internal</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>OnDelete</Value>
</Value>
<Value name="6">
<Value>OnUpdate</Value>
</Value>
<Value name="7">
<Value>Properties</Value>
</Value>
<Value name="8">
<Value>ReferencedClass</Value>
</Value>
<Value name="9">
<Value>ReferencedKey</Value>
</Value>
<Value name="10">
<Value>SequenceNumber</Value>
</Value>
<Value name="11">
<Value>SqlName</Value>
</Value>
</Data>
<Data name="JavaForeignKeyDefState">
<Value name="1">
<Value>Description</Value>
</Value>
<Value name="2">
<Value>Internal</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>OnDelete</Value>
</Value>
<Value name="5">
<Value>OnUpdate</Value>
</Value>
<Value name="6">
<Value>Properties</Value>
</Value>
<Value name="7">
<Value>ReferencedClass</Value>
</Value>
<Value name="8">
<Value>ReferencedKey</Value>
</Value>
<Value name="9">
<Value>SequenceNumber</Value>
</Value>
<Value name="10">
<Value>SqlName</Value>
</Value>
<Value name="11">
<Value>PropertiesList</Value>
</Value>
</Data>
<DataLocation>^%Compiler.LG.JavaForeignK684D</DataLocation>
<DefaultData>JavaForeignKeyDefDefaultData</DefaultData>
<IdLocation>^%Compiler.LG.JavaForeignK684D</IdLocation>
<IndexLocation>^%Compiler.LG.JavaForeignK684I</IndexLocation>
<State>JavaForeignKeyDefState</State>
<StreamLocation>^%Compiler.LG.JavaForeignK684S</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
