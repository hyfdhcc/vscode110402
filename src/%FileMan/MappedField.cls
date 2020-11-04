/// This class stored information about the mapping of a FileMan field to a property
Class %FileMan.MappedField Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdPrivate, System = 4 ]
{

/// The FileMan Field name
Property FMFieldName As %CacheString [ Required ];

/// The FileMan Field number
Property FieldNumber As %CacheString [ Required ];

/// The Property name the field maps to
Property PropertyName As %CacheString [ Required ];

/// The Sql Field name the field maps to
Property SqlFieldName As %CacheString [ Required ];

/// Datatype the field mapped to
Property Datatype As %CacheString [ Required ];

Index IDKeyIndex On FieldNumber [ IdKey, PrimaryKey, Unique ];

Relationship MappedFilePackage As %FileMan.MappedFilePackage [ Cardinality = parent, Inverse = MappedFields ];

Storage Default
{
<Data name="MappedFieldDefaultData">
<Value name="1">
<Value>FMFieldName</Value>
</Value>
<Value name="2">
<Value>PropertyName</Value>
</Value>
<Value name="3">
<Value>SqlFieldName</Value>
</Value>
<Value name="4">
<Value>Datatype</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("f")</DataLocation>
<DefaultData>MappedFieldDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^oddFMD("f")</IdLocation>
<IndexLocation>^oddFMDI</IndexLocation>
<StreamLocation>^oddFMDS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
