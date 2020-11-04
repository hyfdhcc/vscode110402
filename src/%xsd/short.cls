/// This data type represents a small integer value.
Class %xsd.short Extends %Integer [ Not ProcedureBlock, System = 2 ]
{

/// The maximum allowed logical value for the data type.
Parameter MAXVAL = 32767;

/// The minimum allowed logical value for the data type.
Parameter MINVAL = -32768;

/// Declares the XSD type used when projecting XML schemas.
Parameter XSDTYPE = "short";

}
