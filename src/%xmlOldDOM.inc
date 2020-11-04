ROUTINE %xmlOldDOM [Type=INC]

#;
#;	xmlOldDocRef(documentId)
#;		Define reference to documentr node in one place
#;		This macro is only for use within this include file
#define xmlOldDocRef(%documentId) @(%documentId)@(

#;
#;	xmlOldDocumentNode(documentId)
#;		Return the top node for this document -- purpose is so that DocumentId may be changed later.
#define xmlOldDocumentNode(%documentId) %documentId

#;
#;	xmlOldDocumentId(document)
#;		Return the DocumentId for this Document
#define xmlOldDocumentId(%document) $select(%document.HandlerType=$$$IntHandler:"^",1:"")_%document.GlobalName_"("_%document.Tree_")"

#;	XML DOM 
#;	General arguments:
#;		documentId - opaque document identifier
#;		nodeId - node within the document
 
#; Special node for user/application use
#define xmlOldUserNodeName(%documentId) $Name($$$xmlOldDocRef(%documentId)0,"U"))

#;
#;	xmlOldGetDocumentElement(documentId)
#;		Return nodeId of the top element of the document.
#define xmlOldGetDocumentElement(%documentId) $get($$$xmlOldDocRef(%documentId)0,"e"),1)
 
#;
#;	xmlOldSetDocumentElement(documentId)
#;		Set the top element of the document.
#define xmlOldSetDocumentElement(%documentId) Set $$$xmlOldDocRef(%documentId)0,"e")=1,$$$xmlOldDocRef(%documentId)0,"c",1)="e"
 
#;	xmlOldGetNodeValue(documentId,nodeId)
#;		Return value of the node: Local name for elements or text for character node.
#define xmlOldGetNodeValue(%documentId,%nodeId) $$$xmlOldDocRef(%documentId)%nodeId)
 
#;	xmlOldGetNodeType(documentId,nodeId)
#;		Return type of the node: ELELEMENTNODE, TEXTNODE, WHITESPACENODE.
#define xmlOldGetNodeType(%documentId,%nodeId) $listget($get($$$xmlOldDocRef(%documentId)%nodeId,0)),1)
#define xmlOldELEMENTNODE    "e"
#define xmlOldTEXTNODE       "c"
#define xmlOldWHITESPACENODE "w"
 
#;	xmlOldSetNodeType(documentId,nodeId,type)
#;		Set type of the node: ELELEMENTNODE, TEXTNODE, WHITESPACENODE.
#define xmlOldSetNodeType(%documentId,%nodeId,%type) Set $list($$$xmlOldDocRef(%documentId)%nodeId,0),1)=%type
 
#;	xmlOldGetSkipFlag(documentId,nodeId)
#;		Return skip flag for the node.
#;		Internal only -- used for canonicalization
#define xmlOldGetSkipFlag(%documentId,%nodeId) $get($$$xmlOldDocRef(%documentId)%nodeId,1))
 
#;	xmlOldSetSkipFlag(documentId,nodeId,flag)
#;		Set skip flag for the node.
#;		Internal only -- used for canonicalization
#define xmlOldSetSkipFlag(%documentId,%nodeId,%flag) If %flag { Set $$$xmlOldDocRef(%documentId)%nodeId,1)=1 } Else { Kill $$$xmlOldDocRef(%documentId)%nodeId,1) }
 
#;	xmlOldParentNode(documentId,nodeId)
#;		Return nodeId of this node's parent.
#define xmlOldParentNode(%documentId,%nodeId) $listget($get($$$xmlOldDocRef(%documentId)%nodeId,0)),2)
 
#;	xmlOldSetParentNode(documentId,nodeId,parent)
#;		Set parent of this node.
#define xmlOldSetParentNode(%documentId,%nodeId,%parent) Set $list($$$xmlOldDocRef(%documentId)%nodeId,0),2)=%parent
 
#;
#;	xmlOldHasChildNodes(documentId,nodeId)
#;		Return non-zero (true) if this node has any child nodes.
#define xmlOldHasChildNodes(%documentId,%nodeId) ($data($$$xmlOldDocRef(%documentId)%nodeId,"c"))'=0)
 
#;	xmlOldGetFirstChild(documentId,nodeId)
#;		Return nodeId of this node's first child node.
#define xmlOldGetFirstChild(%documentId,%nodeId) $order($$$xmlOldDocRef(%documentId)%nodeId,"c",""))
 
#;	xmlOldGetLastChild(documentId,nodeId)
#;		Return nodeId of this node's last child node.
#define xmlOldGetLastChild(%documentId,%nodeId) $order($$$xmlOldDocRef(%documentId)%nodeId,"c",""),-1)
 
#;	xmlOldGetPreviousChild(documentId,nodeId,childId)
#;		Return nodeId of the previous sibling of node childId with parent nodeId.
#;		This may be more efficient than xmlOldGetPreviousSibling, since parent specified.
#define xmlOldGetPreviousChild(%documentId,%nodeId,%childId) $order($$$xmlOldDocRef(%documentId)%nodeId,"c",%childId),-1)
 
#;	xmlOldGetNextChild(documentId,nodeId,childId)
#;		Return nodeId of the next sibling of node childId with parent nodeId.
#;		This may be more efficient than xmlOldGetNextSibling, since parent specified.
#define xmlOldGetNextChild(%documentId,%nodeId,%childId) $order($$$xmlOldDocRef(%documentId)%nodeId,"c",%childId))
 
#;  xmlOldRemoveChild(documentId,nodeId,childId)
#;		Remove the specified child node.
#define xmlOldRemoveChild(%documentId,%nodeId,%childId) Kill $$$xmlOldDocRef(%documentId)%nodeId,"c",%childId),$$$xmlOldDocRef(%documentId)%childId)
 
#;	xmlOldGetPreviousSibling(documentId,nodeId)
#;		Return nodeId of the previous sibling of this node.
#define xmlOldGetPreviousSibling(%documentId,%nodeId) $order($$$xmlOldDocRef(%documentId)$$$xmlOldParentNode(%documentId,%nodeId),"c",%nodeId),-1)
 
#;	xmlOldGetNextSibling(documentId,nodeId)
#;		Return nodeId of the next sibling of this node.
#define xmlOldGetNextSibling(%documentId,%nodeId) $order($$$xmlOldDocRef(%documentId)$$$xmlOldParentNode(%documentId,%nodeId),"c",%nodeId))
 
#;	xmlOldNextChildElement(documentId,nodeId,childId)
#;		nodeId is variable that is set to the next non-whitespace child node.
#define xmlOldNextChildElement(%documentId,%nodeId,%childId) For  { Set %childId=$order($$$xmlOldDocRef(%documentId)%nodeId,"c",%childId)) If (%childId="")||($$$xmlOldGetNodeType(%documentId,%childId)'="w") Quit }
 
#;	xmlOldFirstChildElement(documentId,nodeId,childId)
#;		nodeId is variable that is set to the first non-whitespace child node.
#define xmlOldFirstChildElement(%documentId,%nodeId,%childId) Set %childId="" For  { Set %childId=$order($$$xmlOldDocRef(%documentId)%nodeId,"c",%childId)) If (%childId="")||($$$xmlOldGetNodeType(%documentId,%childId)'="w") Quit }
 
#;	xmlOldPreviousChildElement(documentId,nodeId,childId)
#;		Ichildd is variable that is set to the previous non-whitespace child node.
#define xmlOldPreviousChildElement(%documentId,%nodeId,%childId) For  Set %childId=$order($$$xmlOldDocRef(%documentId)%nodeId,"c",%childId),-1) If (%childId="")||($$$xmlOldGetNodeType(%documentId,%childId)'="w") Quit
 
#;	xmlOldLastChildElement(documentId,nodeId,childId)
#;		childId is variable that is set to the last non-whitespace child node.
#define xmlOldLastChildElement(%documentId,%nodeId,%childId) Set %childId="" For  { Set %childId=$order($$$xmlOldDocRef(%documentId)%nodeId,"c",%childId),-1) If (%childId="")||($$$xmlOldGetNodeType(%documentId,%childId)'="w") Quit }

#;	xmlOldInsertChild(documentId,childId,parentId,type)
#;		Insert a child node (id=childId) of parent (id=parentId) with type
#define xmlOldInsertChild(%documentId,%childId,%parentId,%type) Set $$$xmlOldDocRef(%documentId)%childId,0)=$lb(%type,%parentId),$$$xmlOldDocRef(%documentId)%parentId,"c",%childId)=%type
 
#;	xmlOldGetData(documentId,nodeId)
#;		Return text for character node.
#define xmlOldGetData(%documentId,%nodeId) $$$xmlOldDocRef(%documentId)%nodeId)
 
#;
#;	xmlOldSetData(documentId,nodeId,text)
#;		Set text for character node.
#define xmlOldSetData(%documentId,%nodeId,%text) Set $$$xmlOldDocRef(%documentId)%nodeId)=%text
 
#;
#;	xmlOldGetLocalName(documentId,nodeId)
#;		Return local name for element node.
#define xmlOldGetLocalName(%documentId,%nodeId) $$$xmlOldDocRef(%documentId)%nodeId)
 
#;
#;	xmlOldSetLocalName(documentId,nodeId,name)
#;		Set local name for element node.
#define xmlOldSetLocalName(%documentId,%nodeId,%name) Set $$$xmlOldDocRef(%documentId)%nodeId)=%name
 
#;
#;	xmlOldGetQName(documentId,nodeId)
#;		Return qname for element node.
#define xmlOldGetQName(%documentId,%nodeId) $select($listget($get($$$xmlOldDocRef(%documentId)%nodeId,0)),4)="":$$$xmlOldDocRef(%documentId)%nodeId),1:$list($$$xmlOldDocRef(%documentId)%nodeId,0),4))
 
#;
#;	xmlOldSetQName(documentId,nodeId,name)
#;		Set Qname for element node.
#define xmlOldSetQName(%documentId,%nodeId,%name) Set $list($$$xmlOldDocRef(%documentId)%nodeId,0),4)=%name
 
#;
#;	xmlOldGetElementLocation(documentId,nodeId)
#;		Return location for element node as $lb(line,column).
#define xmlOldGetElementLocation(%documentId,%nodeId) $lb($listget($get($$$xmlOldDocRef(%documentId)%nodeId,0)),5),$listget($get($$$xmlOldDocRef(%documentId)%nodeId,0)),6))
 
#;
#;	xmlOldGetNamespaceIndex(documentId,nodeId)
#;		Return XML namespace index into namespace table for this element
#define xmlOldGetNamespaceIndex(%documentId,%nodeId) $listget($get($$$xmlOldDocRef(%documentId)%nodeId,0)),3)
#;	Index for "http://www.w3.org/2001/xmlOldSchema-instance" namespace
#define xmlOldXSINAMESPACEINDEX 1
 
#;
#;	xmlOldSetNamespaceIndex(documentId,nodeId,index)
#;		Set XML namespace index into namespace table for this element
#define xmlOldSetNamespaceIndex(%documentId,%nodeId,%index) Set $list($$$xmlOldDocRef(%documentId)%nodeId,0),3)=%index
#;
#;	xmlOldGetNamespaceURI(documentId,nodeId)
#;		Return XML namespace for this element
#define xmlOldGetNamespaceURI(%documentId,%nodeId) $select($listget($get($$$xmlOldDocRef(%documentId)%nodeId,0)),3)="":"",1:$get($$$xmlOldDocRef(%documentId)"ns#",$list($$$xmlOldDocRef(%documentId)%nodeId,0),3))))
 
#;
#;	xmlOldIsNil(documentId,nodeId)
#;		Return 1 if xsi:nil or xsi:null specified as true or 1.
#define xmlOldIsNil(%documentId,%nodeId) +$listget($get($$$xmlOldDocRef(%documentId)%nodeId,0)),7,0)
 
#;
#;	xmlOldSetNil(documentId,nodeId,value)
#;		Set to 1 if xsi:nil or xsi:null specified as true or 1.
#define xmlOldSetNil(%documentId,%nodeId,%value) Set $list($$$xmlOldDocRef(%documentId)%nodeId,0),7)=%value
 
#;
#;	xmlOldGetNumberAttributes(documentId,nodeId)
#;		Return number of attributes for this element.
#define xmlOldGetNumberAttributes(%documentId,%nodeId) ##class(%xmlOld.ImportHandler).GetNumberAttributes(%documentId,%nodeId)
 
#;
#;	xmlOldAttributeDefined(documentId,nodeId,attributeName)
#;		Return non-zero (true) if attribute named attributeName exists for this element.
#define xmlOldAttributeDefined(%documentId,%nodeId,%attributeName) $data($$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName))
 
#;
#;	xmlOldGetAttribute(documentId,nodeId,attributeName)
#;		Return value of attribute named attributeName for this element.
#define xmlOldGetAttribute(%documentId,%nodeId,%attributeName) $get($$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName))
 
#;
#;	xmlOldSetAttribute(documentId,nodeId,attributeName,value)
#;		Set value of attribute named attributeName for this element.
#define xmlOldSetAttribute(%documentId,%nodeId,%attributeName,%value) Set $$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName)=%value
 
#;
#;	xmlOldRemoveAttribute(documentId,nodeId,attributeName)
#;		Remove attribute named attributeName for this element.
#define xmlOldRemoveAttribute(%documentId,%nodeId,%attributeName) If (%attributeName'="")&&$data($$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName)) Kill $$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName),$$$xmlOldDocRef(%documentId)%nodeId,"q",%attributeName)
 
#;
#;	xmlOldFirstAttributeName(documentId,nodeId)
#;		Return attribute name for first attribute for this element.
#define xmlOldFirstAttributeName(%documentId,%nodeId) $order($$$xmlOldDocRef(%documentId)%nodeId,"a",""))
 
#;
#;	xmlOldLasttAttributeName(documentId,nodeId)
#;		Return attribute name for last attribute for this element.
#define xmlOldLastAttributeName(%documentId,%nodeId) $order($$$xmlOldDocRef(%documentId)%nodeId,"a",""),-1)
 
#;
#;	xmlOldNextAttributeName(documentId,nodeId,attributeName)
#;		Return attribute name for attribute after attributeName for this element.
#define xmlOldNextAttributeName(%documentId,%nodeId,%attributeName) $order($$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName))
 
#;
#;	xmlOldPreviousAttributeName(documentId,nodeId,attributeName)
#;		Return attribute name for attribute before attributeName for this element.
#define xmlOldPreviousAttributeName(%documentId,%nodeId,%attributeName) $order($$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName),-1)
 
#;
#;	xmlOldGetAttrQName(documentId,nodeId,attributeName)
#;		Return QName of attribute named attributeName for this element.
#define xmlOldGetAttrQName(%documentId,%nodeId,%attributeName) $get($$$xmlOldDocRef(%documentId)%nodeId,"q",%attributeName),$select($$$xmlOldAttributeDefined(%documentId,%nodeId,%attributeName):%attributeName,1:""))
 
#;
#;	xmlOldGetAttrNamespaceIndex(documentId,nodeId,attributeName)
#;		Return namespace index into namespace table from QName of attribute named attributeName for this element.
#define xmlOldGetAttrNamespaceIndex(%documentId,%nodeId,%attributeName) $get($$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName,"u"))
 
#;
#;	xmlOldSetAttrNamespaceIndex(documentId,nodeId,attributeName,index)
#;		Set namespace index into namespace table from QName of attribute named attributeName for this element.
#define xmlOldSetAttrNamespaceIndex(%documentId,%nodeId,%attributeName,%index) Set $$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName,"u")=%index
 
#;
#;	xmlOldGetAttrNamespaceURI(documentId,nodeId,attributeName)
#;		Return namespace URI from QName of attribute named attributeName for this element.
#define xmlOldGetAttrNamespaceURI(%documentId,%nodeId,%attributeName) $select($get($$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName,"u"))="":"",1:$get($$$xmlOldDocRef(%documentId)"ns#",$$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName,"u"))))
 
#;
#;	xmlOldGetAttrValueNsIndex(documentId,nodeId,attributeName)
#;		Return namespace index into namespace table corresponding to the prefix when the attribute value is of the form "prefix:value".
#define xmlOldGetAttrValueNsIndex(%documentId,%nodeId,%attributeName) $get($$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName,"v"))
 
#;
#;	xmlOldSetAttrValueNsIndex(documentId,nodeId,attributeName,index)
#;		Set namespace index into namespace table corresponding to the prefix when the attribute value is of the form "prefix:value".
#define xmlOldSetAttrValueNsIndex(%documentId,%nodeId,%attributeName,%index) Set $$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName,"v")=%index
 
#;
#;	xmlOldGetAttrValueNsURI(documentId,nodeId,attributeName)
#;		Return namespace URI corresponding to the prefix when the attribute value is of the form "prefix:value".
#define xmlOldGetAttrValueNsURI(%documentId,%nodeId,%attributeName) $select($get($$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName,"v"))="":"",1:$get($$$xmlOldDocRef(%documentId)"ns#",$$$xmlOldDocRef(%documentId)%nodeId,"a",%attributeName,"v"))))
 
#;
#;	xmlOldIndexToNamespace(documentId,nsIndex)
#;		Return XML namespace URI for nsIndex into document's namespace table.
#define xmlOldIndexToNamespace(%documentId,%nsIndex) $get($$$xmlOldDocRef(%documentId)"ns#",%nsIndex))
 
#;
#;	xmlOldNamespaceToIndex(documentId,nsURI)
#;		Return XML nsIndex into document's namespace table for namespace URI.
#define xmlOldNamespaceToIndex(%documentId,%nsURI) $get($$$xmlOldDocRef(%documentId)"ns",%nsURI))
 
#;
#;	xmlOldCountNamespace(documentId)
#;		Return number of namepsaces in document's namespace table.
#define xmlOldCountNamespace(%documentId) +$get($$$xmlOldDocRef(%documentId)"ns"))
 
#;
#;	xmlOldInsertNamespace(documentId,nsURI)
#;		Insert a namespace into document's namespace table for namespace URI and return the index.
#define xmlOldInsertNamespace(%documentId,%nsURI) Set $$$xmlOldDocRef(%documentId)"ns",%nsURI)=$increment($$$xmlOldDocRef(%documentId)"ns")),$$$xmlOldDocRef(%documentId)"ns#",$$$xmlOldDocRef(%documentId)"ns"))=%nsURI
 
#;
#;	xmlOldGetNodeById(documentId,id)
#;		Return nodeId for node with id attribute = %id.
#define xmlOldGetNodeById(%documentId,%id) $get($$$xmlOldDocRef(%documentId)"id",%id))
 
#;
#;	xmlOldSetNodeById(documentId,id,nodeid)
#;		Save nodeId for node with id attribute = %id.
#define xmlOldSetNodeById(%documentId,%id,%nodeid) Set $$$xmlOldDocRef(%documentId)"id",%id)=%nodeid
 
#;
#;	xmlOldGetNumberFatalErrors(documentId)
#;		Return the number of fatal errors from the parsing of the XML.
#define xmlOldGetNumberFatalErrors(%documentId) $order($$$xmlOldDocRef(%documentId)"fatalerror",""),-1)
 
#;
#;	xmlOldGetFatalError(documentId,index)
#;		Return the fatal error for 1-based index.
#define xmlOldGetFatalError(%documentId,%index) $get($$$xmlOldDocRef(%documentId)"fatalerror",%index))
 
#;
#;	xmlOldGetNumberErrors(documentId)
#;		Return the number of errors from the parsing of the XML.
#define xmlOldGetNumberErrors(%documentId) $order($$$xmlOldDocRef(%documentId)"error",""),-1)
 
#;
#;	xmlOldGetError(documentId,index)
#;		Return the error for 1-based index.
#define xmlOldGetError(%documentId,%index) $get($$$xmlOldDocRef(%documentId)"error",%index))
 
#;
#;	xmlOldGetNumberWarnings(documentId)
#;		Return the number of warnings from the parsing of the XML.
#define xmlOldGetNumberWarnings(%documentId) $order($$$xmlOldDocRef(%documentId)"warning",""),-1)
 
#;
#;	xmlOldGetWarning(documentId,index)
#;		Return the warning for 1-based index.
#define xmlOldGetWarning(%documentId,%index) $get($$$xmlOldDocRef(%documentId)"warning",%index))
 
#;
#;	xmlOldGetVersion(documentId)
#;		Return the version of this DOM
#define xmlOldGetVersion(%documentId) $get($$$xmlOldDocRef(%documentId)"v"))
 
 