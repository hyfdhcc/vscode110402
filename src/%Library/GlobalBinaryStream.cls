/// Deprecated in favor of <class>%Stream.GlobalBinary</class>.
/// Stream class that stores binary data in global nodes.
/// Note that on a unicode Cache although you can write unicode data into this class and read
/// it back out this is not a supported use of this class and the Size property would be incorrect
/// in this case as it would be the size in characters rather than the size in bytes.
Class %Library.GlobalBinaryStream Extends (%BinaryStream, %GlobalStreamAdaptor) [ Inheritance = right, MemberSuper = %Library.CacheStreamLegacy, StorageStrategy = Custom, System = 2 ]
{

Storage Custom
{
<StreamLocation>^%Library.GlobalBinaryStreamS</StreamLocation>
<Type>%CompleteCustomStorage</Type>
}

}
