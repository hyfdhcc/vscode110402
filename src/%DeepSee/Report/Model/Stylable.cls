Class %DeepSee.Report.Model.Stylable Extends Element [ Abstract, System = 4 ]
{

/// CSS Style to apply to this element.
Property style As %String(MAXLEN = 1000, XMLPROJECTION = "attribute");

/// CSS Style to apply to this element uniquely when generating HTML
Property htmlstyle As %String(MAXLEN = 1000, XMLPROJECTION = "attribute");

/// CSS Style to apply to this element uniquely when generating XSLFO
Property xslfostyle As %String(MAXLEN = 1000, XMLPROJECTION = "attribute");

/// CSS class to apply to this element
Property class As %String(MAXLEN = 1000, XMLPROJECTION = "attribute");

}
