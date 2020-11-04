/// This is used to represent a server-side class name.
Class %ZEN.Datatype.className Extends datatype [ System = 3 ]
{

Parameter XMLPROJECTION = "attribute";

/// If defined, indicates that this should be a subclass of the given class.
Parameter SUBCLASSOF As STRING;

Parameter MAXLEN = 250;

}
