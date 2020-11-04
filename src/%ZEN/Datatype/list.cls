/// This is a specialized datatype. On the server
/// this represents a set of items as a piece-delimited string.
/// On the client this is converted to a JavaScript array.
Class %ZEN.Datatype.list Extends datatype [ System = 3 ]
{

/// Delimiter character used for server-side representation.
/// Default is $C(5).
Parameter DELIMITER;

Parameter XMLPROJECTION = "attribute";

Parameter MAXLEN;

}
