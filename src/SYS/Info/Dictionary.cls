Class SYS.Info.Dictionary Extends %RegisteredObject
{

Property Items As %String [ MultiDimensional ];

/// This method is called by the Enumerator to Set the items data
Method SetItem(pKey As %String, pValue)
{
}

/// This method simply walks the contained items and writes them to the current device
Method OutputToDevice()
{
}

}
