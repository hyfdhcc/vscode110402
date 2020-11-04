Class %ZEN.Mojo.abstractPageOverride Extends %ZEN.Component.abstractPage
{

/// Validate user pages
Parameter VALIDATEXML = 0;

/// User pages do not have an XML representation
Parameter XMLINCLUDEINGROUP = 0;

/// Internal parameter.
/// There is nothing to queue up for page classes.
Parameter POSTCOMPILEACTIONS;

/// Reset XMLNAME parameter.
Parameter XMLNAME;

/* as pages do not have a direct XML representation, we will
 short-circuit the various XML methods */
/// Suppress normal XML meta data
Parameter XMLNOMETADATA [ Internal ] = 1;

/// Local override.
/// Suppress normal XML meta data.
ClassMethod %XMLGenerate() [ CodeMode = generator, Internal ]
{
	Set ^oddCOM(%class,$$$cCLASSxmldata,"m")=0
}

/// Local override.
Method XMLImport(top As %String, format As %String, namespace As %String, handler As %XML.Document, node As %Integer, ByRef idlist) As %Status [ Internal, ProcedureBlock = 0 ]
{
	Quit ##super(top,format,namespace,handler,node,.idlist)
}

/// Local override.
Method XMLImportInternal() As %Status [ Internal, ProcedureBlock = 0 ]
{
	Quit ##super()
}

/// Local override.
Method XMLImportAttributes() As %Status [ Internal, Private, ProcedureBlock = 0 ]
{
	Quit ##super()
}

/// Local override.
Method XMLExport(top As %String = "", format As %String = "", namespaces As %XML.Namespaces = "", attrs = "", createId As %String = "", typeAttr As %String = "", ByRef oreflist, ByRef idlist, initialIndent As %String = "", local As %Boolean = 0) As %Status [ ProcedureBlock = 0 ]
{
 	Quit ##super(top,format,namespaces,attrs,createId,typeAttr,.orefList,.idList,initialIndent,local)
}

/// Local override.
Method XMLExportInternal() As %Status [ Internal, ProcedureBlock = 0 ]
{
	Quit ##super()
}

/// Local override.
Method XMLExportToString(ByRef export As %String, top As %String, format As %String, namespaces As %XML.Namespaces, attrs, createId As %String, typeAttr As %String, ByRef oreflist, ByRef idlist, initialIndent As %String) As %Status
{
	Quit ##super(.export,top,format,namespaces,attrs,createId,typeAttr,.oreflist,.idlist,initialIndent)
}

/// Local override.
Method XMLExportToStream(ByRef export As %Stream.Object, top As %String, format As %String, namespaces As %XML.Namespaces, attrs, createId As %String, typeAttr As %String, ByRef oreflist, ByRef idlist, initialIndent As %String) As %Status
{
	Quit ##super(.export,top,format,namespaces,attrs,createId,typeAttr,.oreflist,.idlist,initialIndent)
}

/// Local override.
ClassMethod XMLDTD(top As %String, format As %String, input As %Boolean, ByRef dtdlist) As %Status
{
	Quit ##super(.top,.format,.input,.dtdlist)
}

/// Local override.
ClassMethod XMLSchema(top As %String, format As %String, namespacePrefix As %String = "", input As %Boolean, refOnly As %Boolean, ByRef schema) As %Status
{
	Quit ##super(.top,.format,.namespacePrefix,.input,.refOnly,.schemas)
}

/// Local override.
ClassMethod XMLGetSchemaImports(ByRef imports, ByRef classes) As %Status [ Internal ]
{
	Quit ##super(.imports,.classes)
}

/* Dispatch to super class method to keep page classes smaller */
Method %GenerateCode(pCode As %CharacterStream, pLocalize As %Boolean, ByRef pURIList, pCollection As %String, pLevel As %Integer = 1, pMode As %String = "page", pKey As %String = "", pParentVar As %String = "unknown") [ Final, Internal ]
{
	Do ##super(pCode,pLocalize,.pURIList,pCollection,pLevel,pMode,pKey,pParentVar)
}

Method %AddComponent(pComponent As %ZEN.Component.object) As %Status [ Final ]
{
	Quit ##super(pComponent)
}

Method %RemoveComponent(pComponent As %ZEN.Component.object) As %Status [ Final ]
{
	Quit ##super(pComponent)
}

Method %AddImportedComponents(pImportList As %String) As %Status [ Final ]
{
	Quit ##super(pImportList)
}

Method %ReallyAddChild(pComponent As %ZEN.Component.object, pSibling As %ZEN.Component.object = "", pBefore As %Boolean = 0) As %Status [ Final, Internal, PlaceAfter = %AddChild ]
{
	Quit ##super(pComponent,pSibling,pBefore)
}

/// Remove child component <var>pComponent</var> from this group.
/// Returns true if the component was found and removed.
Method %RemoveChild(pComponent As %ZEN.Component.object) As %Boolean
{
	Quit ##super(pComponent)
}

/// Remove all children from this group.
Method %RemoveChildren(pDynamicOnly As %Boolean = 0) [ Final ]
{
	Do ##super(pDynamicOnly)
}

Method %GetChildIndex(pChild As %ZEN.Component.component) As %Integer
{
	Quit ##super(pChild)
}

Method ReallyRefreshContents() [ Final, Internal, ZenMethod ]
{
	Do ##super()
}

/// Local override.
Method %DrawJSResources() As %Status [ Final, Private ]
{
 	Quit ##super()
}

/// Local override.
Method %GetJSResources(ByRef pResources As %String) As %Status [ Final, Private ]
{
 	Quit ##super(.pResources)
}

/// Does the actual work of laying out the children of this group.
/// <var>pTuple</var> indicates the current tuple number in the
/// case of a repeatingGroup.
Method %LayoutChildren(pTuple As %Integer = "") [ Final, Private ]
{
	//Set ^SAM = ^SAM_" Using custom override "

	Set $ZT = "Trap"
	#; dispatch to Layout Manager to provide HTML layout
	#; if a *built-in* method; dispatch directly
	If (..layout = "vertical") {
		Do ##class(%ZEN.LayoutManager).vertical($this,pTuple)
	}
	ElseIf (..layout = "horizontal") {
		Do ##class(%ZEN.LayoutManager).horizontal($this,pTuple)
	}
	ElseIf ((..layout = "")||(..layout = "none")) {
		#; no layout
		Do ##class(%ZEN.LayoutManager).default($this,pTuple)
	}
	Else {
		#; dispatch to "%ZEN.LayoutManager:method"
		Set tLayoutClass = "%ZEN.LayoutManager"
		Set tLayoutMethod = ..layout
		Do $zobjclassmethod(tLayoutClass,tLayoutMethod,$this,pTuple)
	}
Done
	Quit
Trap
	Set $ZT=""
	Set tSC = $$$ERROR($$$GeneralError,$ZE)
	Do ##class(%ZEN.Utils).%DisplayErrorHTML($this,tSC)
	Goto Done
}

}
