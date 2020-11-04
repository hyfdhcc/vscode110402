/// This data data type represents a URI
/// Internally, this is stored as a string.
Class %xsd.anyURI Extends %String [ Not ProcedureBlock, System = 2 ]
{

/// Declares the XSD type used when projecting XML schemas.
Parameter XSDTYPE = "anyURI";

/// There is no length restriction for URI.
Parameter MAXLEN As INTEGER;

/// Always escape inline
Parameter CONTENT = "escape";

}
