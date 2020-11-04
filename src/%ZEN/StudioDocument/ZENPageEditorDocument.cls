/// Studio Document class for Zen Page Editor.<br>
/// This document class applies to Zen page classes:
/// It allows the user to view a visual representation of 
/// a Zen page class.
Class %ZEN.StudioDocument.ZENPageEditorDocument Extends %ZEN.StudioDocument.AbstractDocument [ System = 4 ]
{

Parameter DOMAIN = "%ZEN";

Parameter DESCRIPTION = "Zen Page Editor";

Parameter EDITORURL = "%25ZEN.StudioDocument.ZENPageEditor.cls";

Projection RegisterExtension As %Projection.StudioDocument(DocumentExtension = "zen", DocumentNew = 0, DocumentType = "xedit");

Parameter EXTENSION = ".zen";

/// If set, name of superclass used for documents of this type.<br>
Parameter DOCUMENTCLASS = "%ZEN.Component.page";

/// Returns true if this document type is enabled, and false to disable it
ClassMethod IsEnabled() As %Boolean
{
	#; this is an experimental feature and is off by default
	Quit +$G(^%ISC.ZEN("ZENPageEditor"))
}

}
