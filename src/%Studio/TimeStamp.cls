/// Datatype for <class>%Studio.Project</class> property LastModified which is needed in order
/// to be backward compatible with older XML exports of %Studio.Project before we switched to
/// using the built in XML support for the import/export of these objects.
Class %Studio.TimeStamp Extends %TimeStamp [ System = 3 ]
{

/// Declares the XSD type used when projecting XML Schemas.
Parameter XSDTYPE = "string";

/// Converts the SOAP encoded input dateTime value into a Cache %TimeStamp value.
ClassMethod XSDToLogical(%val As %String) As %Studio.TimeStamp
{
	Quit %val
}

/// Converts the Cache %TimeStamp value to the canonical SOAP encoded value.
ClassMethod LogicalToXSD(%val As %Studio.TimeStamp) As %String
{
	Quit %val
}

}
