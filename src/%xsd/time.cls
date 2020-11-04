/// This data type represents a time value.
/// Internally, this is stored as the number of seconds past midnight.
Class %xsd.time Extends %Time [ Not ProcedureBlock, System = 2 ]
{

/// Declares the XSD type used when projecting XML schemas.
Parameter XSDTYPE = "time";

}
