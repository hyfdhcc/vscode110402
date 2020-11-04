/// This is a string containing the name of a global:
/// ^abc
Class %ZEN.Datatype.glvn Extends datatype [ System = 3 ]
{

Parameter XMLPROJECTION = "attribute";

/// Make sure client does not see global names.
Parameter ZENENCRYPT = 1;

Parameter MAXLEN = 255;

}
