/// This class is the interface class for xDBC STRUCT objects. Values are expected to be orefs.
Class %Library.IStruct Extends %SerialObject [ ClientDataType = HANDLE, ClientName = SerialObject, OdbcType = STRUCT, System = 2 ]
{

Storage Default
{
<StreamLocation>^%Library.IStructS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
