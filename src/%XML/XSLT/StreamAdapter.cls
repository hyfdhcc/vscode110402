Include %occSAX

/// This class is used to adapt a cache stream into stream that can be
/// readily consumed by the XSLT processor parser
Class %XML.XSLT.StreamAdapter Extends %RegisteredObject [ System = 3 ]
{

/// This holds the stream object passed to the class constructor
Property Stream As %RegisteredObject;

/// This holds the prefix which has to be logically prepended to the XML stream
Property Prefix As %String;

/// This holds Flags
Property Flags As %Integer;

Method %OnNew(initvalue As %CacheString) As %Status [ Private ]
{
	
	Set ..Stream=initvalue, i%Flags=$$$CacheIsUnicode
	If '..Stream.IsCharacter() Set i%Flags=i%Flags+2 Quit	
	Quit $$$OK
}

Method Read(ByRef pLen) As %String
{
	Quit ..Stream.Read(.pLen)
}

}
