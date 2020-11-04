/// Stream class that stores binary data in global nodes.
/// Note that on a unicode Cache although you can write unicode data into this class and read
/// it back out this is not a supported use of this class and the Size property would be incorrect
/// in this case as it would be the size in characters rather than the size in bytes.
Class %Stream.GlobalBinary Extends %Stream.GlobalCharacter [ ClientDataType = BINARYSTREAM, OdbcType = LONGVARBINARY, System = 2 ]
{

Storage Default
{
<Data name="GlobalBinaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^%Stream.GlobalBinaryD</DataLocation>
<DefaultData>GlobalBinaryDefaultData</DefaultData>
<IdLocation>^%Stream.GlobalBinaryD</IdLocation>
<IndexLocation>^%Stream.GlobalBinaryI</IndexLocation>
<StreamLocation>^%Stream.GlobalBinaryS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
