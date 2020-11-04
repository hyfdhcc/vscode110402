/// This datatype represents a string value.
Class %ZEN.Datatype.string Extends datatype [ System = 3 ]
{

Parameter XMLPROJECTION = "attribute";

Parameter MAXLEN = 250;

/// Define this here to allow overrides in special cases.
Parameter ZENSETTING As BOOLEAN = 1;

}
