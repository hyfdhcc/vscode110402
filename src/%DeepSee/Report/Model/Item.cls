/// This class is used by the DeepSee Report Generator.<br/>
/// It represents an item used in the Report Display, most commonly associated with tables.
Class %DeepSee.Report.Model.Item Extends %DeepSee.Report.Model.Stylable [ System = 4 ]
{

Parameter XMLNAME = "item";

Property tagBegin As %String [ InitialExpression = "<item" ];

Property tagEnd As %String [ InitialExpression = "</item>" ];

/// Name of the field supplying data for this item.
Property field As %String(MAXLEN = 255, XMLPROJECTION = "attribute");

/// literal for display
Property value As %String(XMLPROJECTION = "attribute");

/// caption used in table
Property caption As %String(XMLPROJECTION = "attribute");

/// if visible="false" then not included in display but included in Report Definition generated XML
Property visible As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 1 ];

/// <p>If the special attribute is specified, the <item> renders a
/// pre-definied piece of dynamic data.  Possible values are 
/// currently: </p>
/// <ul>
/// <li>number : gives the record number within the group.</li>
/// <li>page-number : inserts the page number within a PDF report.  Is rendered as '##' in HTML.</li>
/// <li>page-count : inserts the number of pages within a PDF report.  It is rendered as '##' in HTML.</li>
/// <li>page-number-of : inserts the page number in the form '2 of 18'.  It is rendered as '## of ##' in HTML.</li>
/// <li>page-number-/ : inserts the page number in the form '2/18'.  It is rendered as '##/##' in HTML.</li>
/// </ul>
Property special As %String(XMLPROJECTION = "attribute");

/// Set of captions, summaries within this item
Property elements As list Of Element(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE");

}
