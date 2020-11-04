/// This is used to represent an id assigned to a component.
Class %ZEN.Datatype.id Extends datatype [ System = 3 ]
{

Parameter XMLPROJECTION = "attribute";

Parameter MAXLEN = 255;

/// If defined, this is the type of component that this id
/// refers to.
Parameter COMPONENTTYPE As STRING;

}
