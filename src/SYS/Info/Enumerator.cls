/// This class is used to handle the results of the enumeration of various entities
/// defined within the provider framework such as 'Info Providers','Installations' and 'Applications'
Class SYS.Info.Enumerator Extends %RegisteredObject
{

/// List of objects to which new instances will be appended
Property EnumeratedObjects As list Of SYS.Info.Dictionary;

/// Current object
Property CurrentObject As %CacheObject [ Private ];

/// This method is called when information about an instance of a specific type
/// is about to begin
Method BeginEnum()
{
}

/// This method is called when information about an instance of a specific type has
/// ended
Method EndEnum()
{
}

/// This method is called to provide information in key/value pair format pertaining
/// to the current instance of the type being enumerated
Method SetItem(pKey As %String, pValue As %String)
{
}

}
