/// Property superclass used to define parameters available to
/// %ZEN Report.Display.node subclasses
Class %ZEN.Report.Display.displayParameters [ System = 4 ]
{

/// If true, this indicates that the associated property can contain
/// a #()# expression that will be evaluated by the property's component.
/// For Zen Reports we will allow expressions for any property of a display node.
Parameter ZENEXPRESSION As BOOLEAN = 1;

}
