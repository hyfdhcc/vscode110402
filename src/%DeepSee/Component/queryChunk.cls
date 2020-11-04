/// Breaks representation of query string into pieces to avoid MAXSTRING and client side errors
Class %DeepSee.Component.queryChunk Extends %ZEN.Component.object
{

/// This is the XML namespace for this component.
Parameter NAMESPACE = "http://www.intersystems.com/deepsee";

/// Name of the calculated member.
Property chunkText As %ZEN.Datatype.string(XMLPROJECTION = "none", ZENENCRYPT = 1, ZENSETTING = 0);

}
