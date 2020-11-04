/// This datatype represents a numeric value.
/// Note: this is really a string used to hold a numeric value.
Class %ZEN.Datatype.float Extends datatype [ ClientDataType = DOUBLE, System = 3 ]
{

Parameter XMLPROJECTION = "attribute";

Parameter MAXLEN;

/// The maximum allowed logical value for the data type.
Parameter MAXVAL;

/// The minimum allowed logical value for the data type.
Parameter MINVAL;

}
