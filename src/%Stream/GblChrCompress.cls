/// Stream class that stores character data in compressed global nodes
Class %Stream.GblChrCompress Extends GlobalCharacter [ System = 2 ]
{

ClassMethod %LogicalToStorage(val As %String) As %String [ Private ]
{
	Quit $System.Util.Compress(val)
}

ClassMethod %StorageToLogical(val As %String) As %String [ Private ]
{
	Quit $System.Util.Decompress(val)
}

}
