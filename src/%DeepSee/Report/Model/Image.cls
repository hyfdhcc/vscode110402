Class %DeepSee.Report.Model.Image Extends Element [ System = 4 ]
{

Parameter XMLNAME = "img";

/// Specifies the source of the image. 
/// 
/// If the src attribute begins with an exclamation point, it is interpreted 
/// as an XPath expression just as in the field attribute of the &lt;item&gt; tag.
/// This allows you to dynamically generate URLs within the XML data, and then
/// use these customized URLs as the image source.  Note: when using ! to dynamically
/// get the image URL, it must be an absolute URL or it will not appear in the PDF
/// report.
Property src As %ZEN.Datatype.uri [ Required ];

/// Specifies the height of the image.
Property height As %ZEN.Datatype.length;

/// Specifies the width of the image.
Property width As %ZEN.Datatype.length;

/// Specifies the height of the image.
Property contentHeight As %ZEN.Datatype.length;

/// Specifies the width of the image.
Property contentWidth As %ZEN.Datatype.length;

}
