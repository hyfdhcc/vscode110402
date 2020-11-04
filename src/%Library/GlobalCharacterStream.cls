/// Deprecated in favor of <class>%Stream.GlobalCharacter</class>.
/// Stream class that stores character data in global nodes.
Class %Library.GlobalCharacterStream Extends (%CharacterStream, %GlobalStreamAdaptor) [ Inheritance = right, MemberSuper = %Library.CacheStreamLegacy, StorageStrategy = Custom, System = 2 ]
{

Storage Custom
{
<StreamLocation>^%Library.GlobalCharacterStreamS</StreamLocation>
<Type>%CompleteCustomStorage</Type>
}

}
