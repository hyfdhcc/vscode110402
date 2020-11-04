/// The base class is for nodes that use their content.  Such
/// nodes are not aware of any tags they contain.
Class %ZEN.Report.Display.contentNode Extends node [ Abstract, System = 4 ]
{

/// Content for this node.
Property content As %ZEN.Datatype.caption(MAXLEN = "", XMLPROJECTION = "content");

Property parent As %ZEN.Report.Display.node(XMLPROJECTION = "NONE");

Property xpath As %String(XMLPROJECTION = "NONE");

}
