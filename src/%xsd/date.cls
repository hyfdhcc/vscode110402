/// This data type represents a date in the format <code>YYYY-MM-DD</code>. 
/// Internally, this is stored in Cach&eacute; $H format.
Class %xsd.date Extends %Date [ Not ProcedureBlock, System = 2 ]
{

/// Declares the XSD type used when projecting XML schemas.
Parameter XSDTYPE = "date";

}
