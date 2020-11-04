/// This datatype represents an integer value.
/// Note: this is really a string used to hold a numeric value.
Class %ZEN.Datatype.integer Extends datatype [ ClientDataType = INTEGER, System = 3 ]
{

Parameter XMLPROJECTION = "attribute";

Parameter MAXLEN;

/// The maximum allowed logical value for the data type.
Parameter MAXVAL As INTEGER;

/// The minimum allowed logical value for the data type.
Parameter MINVAL As INTEGER;

}
