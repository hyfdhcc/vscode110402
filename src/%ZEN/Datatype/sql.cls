/// This is a string containing an SQL statement.
Class %ZEN.Datatype.sql Extends datatype [ System = 3 ]
{

Parameter XMLPROJECTION = "attribute";

/// Make sure client does not see SQL queries
Parameter ZENENCRYPT = 1;

Parameter MAXLEN = 32000;

}
