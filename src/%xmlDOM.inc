ROUTINE %xmlDOM [Type=INC]
#;	Two sets of macros are defined.
#;		The macros in the original set are prefixed by xml.  
#;		New more efficient macros are prefixed by xmla.
#;      The xml macros with xmla replacements are deprecated.
#;
 
#;  Internal only macros
#include %xmlDOMInternal

#;
#;	xmlDocumentNode(documentId)
#;		Return the top database node for this document -- purpose is so that DocumentId may be changed later.
#define xmlDocumentNode(%documentId) %documentId

#;
#;	xmlDocumentId(document)
#;		Return the DocumentId for this Document
#define xmlDocumentId(%document) $$$xmliDocId(%document)

#;	XML DOM 
#;	General arguments:
#;		documentId - opaque document identifier
#;		nodeId - node within the document
#;  The documentId and nodeId arguments are used in most macros.
#;  This detail should not be taken advantage of in writing code.  Arguments should not be opaque.
#;      documentId - global or local base for storage of DOM
#;      nodeId - "<CLparent>,<CLoffset>" which will be separated by $piece
#;         CLparent is the node subscript for parent's child list for the element containing the id
#;         CLoffset is the 1-based offset including base) into the childlist node for the id element's descriptor.
#;         A nodeId value cannot be depended on when the document is being updated as the
#;             nodeId is very position dependent.  
#;
#;  A nodeId value cannot be depended on when the document is being updated as the
#;     nodeId is very position dependent.  
#;  An elementId is an update invariant id for an element node.
#;  These macros convert nodeId to elmentId and vice-versa.
#;  xmlaNodeIdToElementId(documentId,nodeId)
#;      returns an elementId
#;  xmlaElementIdToNodeId(documentId,elementId)
#;      returns an nodeId
#;  
#define xmlaNodeIdToElementId(%documentId,%nodeId) $$$xmliGetChildList(%documentId,%nodeId)
#define xmlaElementIdToNodeId(%documentId,%elementId) $$$xmliMakeNodeId(%documentId,$$$xmliCLparent(%documentId,$$$xmliCLNode(%documentId,%elementId)),$$$xmliCLoffset(%documentId,$$$xmliCLNode(%documentId,%elementId)))
 
#;
#;	xmlGetDocumentElement(documentId)
#;		Return nodeId of the root element of the document.
#;      Macro should have been called xmlGetRootElement, but is not changed here for compatibility
#define xmlGetDocumentElement(%documentId) $$$xmliMakeNodeId(%documentId,0,$$$xmliCLBase)
 
#;
#;	xmlaGetDocumentNode(documentId)
#;		Return nodeId of the top node of the document.
#define xmlaGetDocumentNode(%documentId) $$$xmliMakeNodeId(%documentId,0,0)
 
#;
#; Special node for user/application use
#define xmlUserNodeName(%documentId) $Name($$$xmliDocRef(%documentId)"U"))

#;
#;	xmlaGetNodeType(documentId,descriptor)
#;	xmlGetNodeType(documentId,nodeId)
#;		Return type of the node: ELEMENTNODE, TEXTNODE, WHITESPACENODE.
#define xmlaGetNodeType(%documentId,%descriptor) $$$xmliDescType(%documentId,%descriptor)
#define xmlGetNodeType(%documentId,%nodeId) $$$xmlaGetNodeType(%documentId,$$$xmliGetDescriptor(%documentId,%nodeId))
#;
#define xmlELEMENTNODE    0
#define xmlTEXTNODE       1
#define xmlWHITESPACENODE 2
#;  xmlRAWTEXTNODE is text which is already XML escaped.  For internal use only.
#define xmlRAWTEXTNODE    4
#;  xmliNEXTNODE is for internal use only.
#define xmliNEXTNODE      3
 
#;
#;	xmlSetNodeType(documentId,nodeId,type)
#;		Set type of the node: ELELEMENTNODE, TEXTNODE, WHITESPACENODE.
#define xmlSetNodeType(%documentId,%nodeId,%type) $$$xmliReplaceDescriptor(%documentId,%nodeId,$zboolean($$$xmliGetDescriptor(%documentId,%nodeId),15,2)+%type)
 
#;
#;	xmlaGetSkipFlag(documentId,childlist)
#;	xmlGetSkipFlag(documentId,nodeId)
#;		Return skip flag for the node.
#;		Internal only -- used for canonicalization
#define xmlaGetSkipFlag(%documentId,%childlist) $zboolean(+$$$xmliCLflags(%documentId,%childlist),+2,1)
#define xmlGetSkipFlag(%documentId,%nodeId) $$$xmlaGetSkipFlag(%documentId,$$$xmliChildListNode(%documentId,%nodeId))
 
#;
#;	xmlSetSkipFlag(documentId,nodeId,flag)
#;		Set skip flag for the node.
#;		Internal only -- used for canonicalization
#define xmlSetSkipFlag(%documentId,%nodeId,%flag) $$$xmliSetCLflags(%documentId,$$$xmliGetChildList(%documentId,%nodeId),$zboolean(+$$$xmliCLflags(%documentId,$$$xmliChildListNode(%documentId,%nodeId)),+2,$select(%flag:7,1:2)))

#;
#;  xmlaIsTop(documentId,nodeId)
#;      Returns true (1) if top node == parent of root element
#define xmlaIsTop(%documentId,%nodeId) ($$$xmliNodeIdCLoffset(%nodeId)<=0)

#;
#;	xmlaGetParentNodeWithChildlist(documentId,nodeId,parentId,parentChildlist,parentDescriptor)
#;		Return nodeId of this element node's parent.
#;		In addition the parent's childlist and descriptor is returned, 
#;		  since the childlist depends on nodeId if it is to be the childlist containing nodeId.
#;      If nodeId is document root element, xmlaPaentNode returns special node for xmlaIsTop
#;	xmlaParentNode(documentId,childlist)
#;		Return nodeId of this element node's parent.
#;      If nodeId is document root element, xmlaPaentNode returns special node for xmlaIsTop
#;	xmlParentNode(documentId,nodeId)
#;		Return nodeId of this element node's parent.
#;      If nodeId is document root element, xmlParentNode returns 0, xmlaPaentNode returns special node for xmlaIsTop
#define xmlaGetParentNodeWithChildlist(%documentId,%nodeId,%parentId,%parentChildlist,%parentDescriptor) Set %parentChildlist=$$$xmliCLNode(%documentId,$$$xmliNodeIdCLparent(%nodeId)),%parentId=$$$xmliMakeNodeId(%documentId,$$$xmliCLparent(%documentId,$$$xmliCLNode(%documentId,$$$xmliNodeIdCLparent(%nodeId))),$$$xmliCLoffset(%documentId,$$$xmliCLNode(%documentId,$$$xmliNodeIdCLparent(%nodeId)))),%parentDescriptor=$$$xmliGetDescriptor(%documentId,%parentId)
#define xmlaParentNode(%documentId,%nodeId) $$$xmliMakeNodeId(%documentId,$$$xmliCLparent(%documentId,$$$xmliCLNode(%documentId,$$$xmliNodeIdCLparent(%nodeId))),$$$xmliCLoffset(%documentId,$$$xmliCLNode(%documentId,$$$xmliNodeIdCLparent(%nodeId))))
#define xmlParentNode(%documentId,%nodeId) $select($$$xmliNodeIdCLparent(%nodeId)<=0:0,1:$$$xmlaParentNode(%documentId,%nodeId))
 
#;
#;	xmlSetParentNode(documentId,nodeId,parent)
#;		Set parent of this node.
#define xmlSetParentNode(%documentId,%nodeId,%parent) Set $extract($$$xmliCLNode(%documentId,$$$xmliNodeIdCLparent(%nodeId)),1,8)=$zlchar($$$xmliNodeIdCLparent(%parent))_$zlchar($$$xmliNodeIdCLoffset(%parent))
 
#;
#;	xmlaHasChildNodes(documentId,childlist)
#;	xmlHasChildNodes(documentId,nodeId)
#;		Return non-zero (true) if this node has any child nodes.
#define xmlaHasChildNodes(%documentId,%childlist) ($length(%childlist)>($$$xmliCLelementOffset(%documentId,%childlist)+$$$xmliDescriptorSize))
#define xmlHasChildNodes(%documentId,%nodeId) $$$xmlaHasChildNodes(%documentId,$$$xmliChildListNode(%documentId,%nodeId))
 
#;
#;  xmlaGetChildListFromDescriptor(documentId,descriptor,childlist) -- Internal only
#;  xmlaGetChildList(documentId,nodeId,childlist,descriptor) -- Internal only
#;      Return descriptor and childlist associated with node specified by nodeId 
#define xmlaGetChildListFromDescriptor(%documentId,%descriptor,%childlist) Set %childlist=$$$xmliCLNode(%documentId,$$$xmliDescValue(%documentId,%descriptor))
#define xmlaGetChildList(%documentId,%nodeId,%childlist,%descriptor) Set %descriptor=$$$xmliGetDescriptor(%documentId,%nodeId) $$$xmlaGetChildListFromDescriptor(%documentId,%descriptor,%childlist)
 
#;
#;	xmlaFirstChild(documentId,parent,parentChildlist,childId,descriptor)
#;		Return first child from parentChildlist where parentChildlist must be the first childlist of parent node;
#;         NOT extended childlist.
#;      Set childId to nodeId of the child.
#;      Set descriptor to the descriptor of the child.
#;      Return "" for no valid child.
#define xmlaFirstChild(%documentId,%parent,%parentChildlist,%childId,%descriptor) Set %descriptor=$$$xmliGetDescriptor1(%documentId,%parentChildlist,$$$xmliCLelementOffset(%documentId,%parentChildlist)) Set %childId=$$$xmliMakeNodeId(%documentId,$$$xmliDescValue(%documentId,$$$xmliGetDescriptor(%documentId,%parent)),$$$xmliCLelementOffset(%documentId,%parentChildlist)) If $$$xmliDescType(%documentId,%descriptor)=$$$xmliNEXTNODE { Set %childId="" }
 
#;
#;	xmlaNextChild(documentId,parent,parentChildlist,childId,descriptor)
#;		Return next child from parentChildlist where parentChildlist must contain childId.
#;      Set childId to nodeId of the child.
#;      Set descriptor to the descriptor of the child.
#;      If needed updated, parentChildlist to next extended childlist.
#;      Return "" for no valid child.
#define xmlaNextChild(%documentId,%parent,%parentChildlist,%childId,%descriptor) Set %descriptor=$$$xmliNodeIdCLoffset(%childId)+$$$xmliDescriptorSize Set %childId=$$$xmliMakeNodeId(%documentId,$$$xmliNodeIdCLparent(%childId),%descriptor) Set %descriptor=$$$xmliGetDescriptor1(%documentId,%parentChildlist,%descriptor) If $$$xmliDescType(%documentId,%descriptor)=$$$xmliNEXTNODE { If $$$xmliDescValue(%documentId,%descriptor)'=0 { Set %childId=##class(%XML.ImportHandler).NextChild(%documentId,%parent,.%parentChildlist,%childId,.%descriptor) } Else {Set %childId="" }}
 
#;
#;	xmlaFirstChildElement(documentId,parent,parentChildlist,childId,descriptor)
#;		Return first non-whitespace child from parentChildlist where parentChildlist must be the first childlist of parent node;
#;         NOT extended childlist.
#;      Set childId to nodeId of the child.
#;      Set descriptor to the descriptor of the child.
#;      Return "" for no valid child.
#define xmlaFirstChildElement(%documentId,%parent,%parentChildlist,%childId,%descriptor) $$$xmlaFirstChild(%documentId,%parent,%parentChildlist,%childId,%descriptor) For { Quit:%childId=""  Quit:$$$xmlaGetNodeType(%documentId,%descriptor)'=$$$xmlWHITESPACENODE  $$$xmlaNextChild(%documentId,%parent,%parentChildlist,%childId,%descriptor) }
 
#;
#;	xmlaNextChildElement(documentId,parent,parentChildlist,childId,descriptor)
#;		Return next non-whitespace child from parentChildlist where parentChildlist must contain childId.
#;      Set childId to nodeId of the child.
#;      Set descriptor to the descriptor of the child.
#;      If needed updated, parentChildlist to next extended childlist.
#;      Return "" for no valid child.
#define xmlaNextChildElement(%documentId,%parent,%parentChildlist,%childId,%descriptor) For  { $$$xmlaNextChild(%documentId,%parent,%parentChildlist,%childId,%descriptor) Quit:%childId=""  Quit:$$$xmlaGetNodeType(%documentId,%descriptor)'=$$$xmlWHITESPACENODE  }
 
#;
#;	xmlGetFirstChild(documentId,nodeId)
#;		Return nodeId of this node's first child node.
#;      Return "" for no valid child.
#define xmlGetFirstChild(%documentId,%nodeId) ##class(%XML.ImportHandler).GetNextChild(%documentId,%nodeId,"")
 
#;
#;	xmlGetLastChild(documentId,nodeId)
#;		Return nodeId of this node's last child node.
#;      Return "" for no valid child.
#define xmlGetLastChild(%documentId,%nodeId) ##class(%XML.ImportHandler).GetPreviousChild(%documentId,%nodeId,"")
 
#;
#;	xmlGetPreviousChild(documentId,nodeId,childId)
#;		Return nodeId of the previous sibling of node childId with parent nodeId.
#;      Return "" for no valid child.
#define xmlGetPreviousChild(%documentId,%nodeId,%childId) ##class(%XML.ImportHandler).GetPreviousChild(%documentId,%nodeId,%childId)
 
#;
#;	xmlGetNextChild(documentId,nodeId,childId)
#;		Return nodeId of the next sibling of node childId with parent nodeId.
#;      Return "" for no valid child.
#define xmlGetNextChild(%documentId,%nodeId,%childId) ##class(%XML.ImportHandler).GetNextChild(%documentId,%nodeId,%childId)
 
#;
#;	xmlGetPreviousSibling(documentId,nodeId)
#;		Return nodeId of the previous sibling of this node.
#;      Return "" for no valid child.
#define xmlGetPreviousSibling(%documentId,%nodeId) $$$xmlGetPreviousChild(%documentId,$$$xmlParentNode(%documentId,%nodeId),%nodeId)
 
#;
#;	xmlGetNextSibling(documentId,nodeId)
#;		Return nodeId of the next sibling of this node.
#;      Return "" for no valid child.
#define xmlGetNextSibling(%documentId,%nodeId) $$$xmlGetNextChild(%documentId,$$$xmlParentNode(%documentId,%nodeId),%nodeId)
 
#;
#;	xmlNextChildElement(documentId,nodeId,childId)
#;		nodeId is variable that is set to the next non-whitespace child node.
#;      Return "" for no valid child.
#define xmlNextChildElement(%documentId,%nodeId,%childId) For  { Set %childId=$$$xmlGetNextChild(%documentId,%nodeId,%childId) Quit:%childId=""  Quit:$$$xmlGetNodeType(%documentId,%childId)'=$$$xmlWHITESPACENODE  }
 
#;
#;	xmlFirstChildElement(documentId,nodeId,childId)
#;		nodeId is variable that is set to the first non-whitespace child node.
#;      Return "" for no valid child.
#define xmlFirstChildElement(%documentId,%nodeId,%childId) Set %childId=$$$xmlGetFirstChild(%documentId,%nodeId) For { Quit:%childId=""  Quit:$$$xmlGetNodeType(%documentId,%childId)'=$$$xmlWHITESPACENODE  Set %childId=$$$xmlGetNextChild(%documentId,%nodeId,%childId) }
 
#;
#;	xmlPreviousChildElement(documentId,nodeId,childId)
#;		childId is variable that is set to the previous non-whitespace child node.
#;      Return "" for no valid child.
#define xmlPreviousChildElement(%documentId,%nodeId,%childId) For  { Set %childId=$$$xmlGetPreviousChild(%documentId,%nodeId,%childId) Quit:%childId=""  Quit:$$$xmlGetNodeType(%documentId,%childId)'=$$$xmlWHITESPACENODE  }
 
#;
#;	xmlLastChildElement(documentId,nodeId,childId)
#;		childId is variable that is set to the last non-whitespace child node.
#;      Return "" for no valid child.
#define xmlLastChildElement(%documentId,%nodeId,%childId) Set %childId=$$$xmlGetLastChild(%documentId,%nodeId) For  { Quit:%childId=""  Quit:$$$xmlGetNodeType(%documentId,%childId)'=$$$xmlWHITESPACENODE  Set %childId=$$$xmlGetPreviousChild(%documentId,%nodeId,%childId) }
 
#;
#;	xmlaGetData(documentId,descriptor)
#;	xmlGetData(documentId,nodeId)
#;		Return text for character node.
#define xmlaGetData(%documentId,%descriptor) $$$xmliDocRef(%documentId)"d",$$$xmliDescValue(%documentId,%descriptor))
#define xmlGetData(%documentId,%nodeId) $$$xmlaGetData(%documentId,$$$xmliGetDescriptor(%documentId,%nodeId))
 
#;
#;	xmlSetData(documentId,nodeId,text)
#;		Set text for character node.
#define xmlSetData(%documentId,%nodeId,%text) $$$xmliReplaceDescriptor(%documentId,%nodeId,$zlchar(16*##class(%XML.ImportHandler).GetNameIndex(%documentId,%text)+$$$xmlTEXTNODE))
 
#;
#;	xmlaGetLocalName(documentId,childlist)
#;	xmlGetLocalName(documentId,nodeId)
#;		Return local name for element node.
#define xmlaGetLocalName(%documentId,%childlist) $$$xmliDocRef(%documentId)"d",$$$xmliCLname(%documentId,%childlist))
#define xmlGetLocalName(%documentId,%nodeId) $$$xmlaGetLocalName(%documentId,$$$xmliChildListNode(%documentId,%nodeId))
 
#;
#;	xmlGetNodeValue(documentId,nodeId)
#;		Return value of the node: Local name for elements or text for character node.
#define xmlGetNodeValue(%documentId,%nodeId) $select($$$xmlGetNodeType(%documentId,%nodeId)=$$$xmlELEMENTNODE:$$$xmlGetLocalName(%documentId,%nodeId),1:$$$xmlGetData(%documentId,%nodeId))
 
#;
#;	xmlSetLocalName(documentId,nodeId,name)
#;		Set local name for element node.
#define xmlSetLocalName(%documentId,%nodeId,%name) $$$xmliSetCLname(%documentId,$$$xmliGetChildList(%documentId,%nodeId),##class(%XML.ImportHandler).GetNameIndex(%documentId,%name))
 
#;
#;	xmlaGetQName(documentId,childlist)
#;	xmlGetQName(documentId,nodeId)
#;		Return qname for element node.
#define xmlaGetQName(%documentId,%childlist) $get($$$xmliDocRef(%documentId)"d",$$$xmliCLprefix(%documentId,%childlist)))_$$$xmlaGetLocalName(%documentId,%childlist)
#define xmlGetQName(%documentId,%nodeId) $$$xmlaGetQName(%documentId,$$$xmliChildListNode(%documentId,%nodeId))
 
#;
#;	xmlSetQName(documentId,nodeId,name)
#;		Set Qname for element node.
#define xmlSetQName(%documentId,%nodeId,%name) $$$xmliSetCLprefix(%documentId,$$$xmliGetChildList(%documentId,%nodeId),$select($length(%name,":")'=2:0,1:##class(%XML.ImportHandler).GetNameIndex(%documentId,$piece(%name,":",1)_":"))) $$$xmlSetLocalName(%documentId,%nodeId,$select($length(%name,":")'=2:%name,1:$piece(%name,":",2)))
 
#;
#;	xmlaGetElementLocation(documentId,childlist)
#;	xmlGetElementLocation(documentId,nodeId)
#;		Return location for element node as $lb(line,column).
#define xmlaGetElementLocation(%documentId,%childlist) $lb($$$xmliCLline(%documentId,%childlist),$$$xmliCLcolumn(%documentId,%childlist))
#define xmlGetElementLocation(%documentId,%nodeId) $$$xmlaGetElementLocation(%documentId,$$$xmliChildListNode(%documentId,%nodeId))
 
#;
#;	xmlaGetNamespaceIndex(documentId,childlist)
#;	xmlGetNamespaceIndex(documentId,nodeId)
#;		Return XML namespace index into namespace table for this element
#;      xmlGetNamespaceIndex returns "" for no namespace
#;      xmlaGetNamespaceIndex returns 0 for no namespace
#define xmlaGetNamespaceIndex(%documentId,%childlist) $$$xmliCLURI(%documentId,%childlist)
#define xmlGetNamespaceIndex(%documentId,%nodeId) $case($$$xmlaGetNamespaceIndex(%documentId,$$$xmliChildListNode(%documentId,%nodeId)),0:"",:$$$xmlaGetNamespaceIndex(%documentId,$$$xmliChildListNode(%documentId,%nodeId)))
#;	Index for "http://www.w3.org/2001/XMLSchema-instance" namespace
#define xmlXSINAMESPACEINDEX 1
 
#;
#;	xmlSetNamespaceIndex(documentId,nodeId,index)
#;		Set XML namespace index into namespace table for this element
#define xmlSetNamespaceIndex(%documentId,%nodeId,%index) $$$xmliSetCLURI(%documentId,$$$xmliGetChildList(%documentId,%nodeId),%index)

#;
#;	xmlGetNamespaceURI(documentId,childlist)
#;	xmlGetNamespaceURI(documentId,nodeId)
#;		Return XML namespace for this element
#define xmlaGetNamespaceURI(%documentId,%childlist) $get($$$xmliDocRef(%documentId)"n",$$$xmlaGetNamespaceIndex(%documentId,%childlist)))
#define xmlGetNamespaceURI(%documentId,%nodeId) $$$xmlaGetNamespaceURI(%documentId,$$$xmliChildListNode(%documentId,%nodeId))
 
#;
#;	xmlaIsNil(documentId,childlist)
#;	xmlIsNil(documentId,nodeId)
#;		Return 1 if xsi:nil or xsi:null specified as true or 1.
#define xmlaIsNil(%documentId,%childlist) $zboolean(+$$$xmliCLflags(%documentId,%childlist),+1,1)
#define xmlIsNil(%documentId,%nodeId) $$$xmlaIsNil(%documentId,$$$xmliChildListNode(%documentId,%nodeId))
 
#;
#;	xmlSetNil(documentId,nodeId,value)
#;		Set to 1 if xsi:nil or xsi:null specified as true or 1.
#define xmlSetNil(%documentId,%nodeId,%flag) $$$xmliSetCLflags(%documentId,$$$xmliGetChildList(%documentId,%nodeId),$zboolean(+$$$xmliCLflags(%documentId,$$$xmliChildListNode(%documentId,%nodeId)),+1,$select(%flag:7,1:2)))
 
#;
#;	xmlaGetNumberAttributes(documentId,childlist)
#;	xmlGetNumberAttributes(documentId,nodeId)
#;		Return number of attributes for this element.
#define xmlaGetNumberAttributes(%documentId,%childlist) (($$$xmliCLelementOffset(%documentId,%childlist)-$$$xmliCLBase)\$$$xmliAttributeSize)
#define xmlGetNumberAttributes(%documentId,%nodeId) $$$xmlaGetNumberAttributes(%documentId,$$$xmliChildListNode(%documentId,%nodeId))
 
#;
#;	xmlaForEachAttribute(documentId,childlist,offset,attribute)
#;		Loop over each attribute for this element.
#;      The attribute argument will be set to the current attribute as needed by the $$$xmlaGetAttr macros.
#define xmlaForEachAttribute(%documentId,%childlist,%offset,%attribute) Set %offset=$$$xmliCLBase While %offset<$$$xmliCLelementOffset(%documentId,%childlist) { Set %attribute=$extract(%childlist,%offset,%offset+$$$xmliAttributeSize1)
 
#;
#;	xmlaEndForEachAttribute(documentId,childlist,offset,attribute)
#;		End of loop over each attribute for this elment.
#define xmlaEndForEachAttribute(%documentId,%childlist,%offset,%attribute) Set %offset=%offset+$$$xmliAttributeSize }
 
#;
#;	xmlaGetAttributeNameIndex(documentId,attribute)
#;	xmlaGetAttributeName(documentId,attribute)
#;		Return name of attribute.  Input is internal attribute format.
#define xmlaGetAttributeNameIndex(%documentId,%attribute) $zlascii(%attribute,1)
#define xmlaGetAttributeName(%documentId,%attribute) $$$xmliDocRef(%documentId)"d",$zlascii(%attribute,1))
 
#;
#;	xmlAttributeDefined(documentId,nodeId,attributeName)
#;		Return non-zero (true) if attribute named attributeName exists for this element.
#define xmlAttributeDefined(%documentId,%nodeId,%attributeName) ($$$xmliGetAttributeByName(%documentId,%nodeId,%attributeName)'="")
 
#;
#;	xmlaGetAttribute(documentId,attribute)
#;		Return value of attribute named attributeName for this element.  Input is internal attribute format.
#;	xmlGetAttribute(documentId,nodeId,attributeName)
#;		Return value of attribute named attributeName for this element.
#define xmlaGetAttribute(%documentId,%attribute) $get($$$xmliDocRef(%documentId)"d",$zlascii(%attribute,13)))
#define xmlGetAttribute(%documentId,%nodeId,%attributeName) $$$xmlaGetAttribute(%documentId,$$$xmliGetAttributeByName(%documentId,%nodeId,%attributeName))
 
#;
#;	xmlSetAttribute(documentId,nodeId,attributeName,value)
#;		Set value of attribute named attributeName for this element.
#define xmlSetAttribute(%documentId,%nodeId,%attributeName,%value) Do ##class(%XML.ImportHandler).SetAttribute(%documentId,.%nodeId,%attributeName,$zlchar(##class(%XML.ImportHandler).GetNameIndex(%documentId,%value)),13,16)
 
#;
#;	xmlRemoveAttribute(documentId,nodeId,attributeName)
#;		Remove attribute named attributeName for this element.
#;	xmlRemoveAttributeNS(documentId,nodeId,attributeName,namespace)
#;		Remove attribute named attributeName for this element in specified namespace.
#define xmlRemoveAttribute(%documentId,%nodeId,%attributeName) Do ##class(%XML.ImportHandler).RemoveAttribute(%documentId,.%nodeId,%attributeName)
#define xmlRemoveAttributeNS(%documentId,%nodeId,%attributeName,%namespace) Do ##class(%XML.ImportHandler).RemoveAttribute(%documentId,.%nodeId,%attributeName,%namespace)
 
#;
#;	xmlFirstAttributeName(documentId,nodeId)
#;		Return attribute name for first attribute for this element.
#define xmlFirstAttributeName(%documentId,%nodeId) $select(($get($$$xmliDocRef(%documentId)"a"))=%nodeId)||##class(%XML.ImportHandler).GetAttributeMap(%documentId,%nodeId):$order($$$xmliDocRef(%documentId)"a","")),1:"")
 
#;
#;	xmlLastAttributeName(documentId,nodeId)
#;		Return attribute name for last attribute for this element.
#define xmlLastAttributeName(%documentId,%nodeId) $select(($get($$$xmliDocRef(%documentId)"a"))=%nodeId)||##class(%XML.ImportHandler).GetAttributeMap(%documentId,%nodeId):$order($$$xmliDocRef(%documentId)"a",""),-1),1:"")
 
#;
#;	xmlNextAttributeName(documentId,nodeId,attributeName)
#;		Return attribute name for attribute after attributeName for this element.
#define xmlNextAttributeName(%documentId,%nodeId,%attributeName) $select(($get($$$xmliDocRef(%documentId)"a"))=%nodeId)||##class(%XML.ImportHandler).GetAttributeMap(%documentId,%nodeId):$order($$$xmliDocRef(%documentId)"a",%attributeName)),1:"")
 
#;
#;	xmlPreviousAttributeName(documentId,nodeId,attributeName)
#;		Return attribute name for attribute before attributeName for this element.
#define xmlPreviousAttributeName(%documentId,%nodeId,%attributeName) $select(($get($$$xmliDocRef(%documentId)"a"))=%nodeId)||##class(%XML.ImportHandler).GetAttributeMap(%documentId,%nodeId):$order($$$xmliDocRef(%documentId)"a",%attributeName),-1),1:"")
 
#;
#;	xmlaGetAttributeQName(documentId,attribute)
#;		Return QName of attribute.  Input is internal attribute format.
#;	xmlGetAttrQName(documentId,nodeId,attributeName)
#;		Return QName of attribute named attributeName for this element.
#define xmlaGetAttributeQName(%documentId,%attribute) $get($$$xmliDocRef(%documentId)"d",$zlascii(%attribute,5)))_$get($$$xmliDocRef(%documentId)"d",$zlascii(%attribute,1)))
#define xmlGetAttrQName(%documentId,%nodeId,%attributeName) $$$xmlaGetAttributeQName(%documentId,$$$xmliGetAttributeByName(%documentId,%nodeId,%attributeName))
 
#;
#;	xmlaGetAttrNamespaceIndex(documentId,attribute)
#;		Return namespace index into namespace table from QName of attribute.  Input is internal attribute format.
#;      xmlGetAttrNamespaceIndex returns <= 0 for no namespace
#;	xmlGetAttrNamespaceIndex(documentId,nodeId,attributeName)
#;		Return namespace index into namespace table from QName of attribute named attributeName for this element.
#;      xmlGetAttrNamespaceIndex returns 0 for no namespace
#define xmlaGetAttrNamespaceIndex(%documentId,%attribute) $zwascii(%attribute,9)
#define xmlGetAttrNamespaceIndex(%documentId,%nodeId,%attributeName) $replace($$$xmlaGetAttrNamespaceIndex(%documentId,$$$xmliGetAttributeByName(%documentId,%nodeId,%attributeName)),-1,0)
 
#;
#;	xmlSetAttrNamespaceIndex(documentId,nodeId,attributeName,index)
#;		Set namespace index into namespace table from QName of attribute named attributeName for this element.
#define xmlSetAttrNamespaceIndex(%documentId,%nodeId,%attributeName,%index) Do ##class(%XML.ImportHandler).SetAttribute(%documentId,.%nodeId,%attributeName,$zwchar(%index),9,10)
 
#;
#;	xmlaGetAttrNamespaceURI(documentId,attribute)
#;		Return namespace URI from QName of attribute.  Input is internal attribute format.
#;	xmlGetAttrNamespaceURI(documentId,nodeId,attributeName)
#;		Return namespace URI from QName of attribute named attributeName for this element.
#define xmlaGetAttrNamespaceURI(%documentId,%attribute) $get($$$xmliDocRef(%documentId)"n",$$$xmlaGetAttrNamespaceIndex(%documentId,%attribute)))
#define xmlGetAttrNamespaceURI(%documentId,%nodeId,%attributeName) $$$xmlaGetAttrNamespaceURI(%documentId,$$$xmliGetAttributeByName(%documentId,%nodeId,%attributeName))
 
#;
#;	xmlaGetAttrValueNsIndex(documentId,attribute)
#;		Return namespace index into namespace table corresponding to the prefix when the attribute value is of the form "prefix:value".
#;      Input is internal attribute format.
#;      xmlaGetAttrValueNsIndex returns <= 0 for no namespace
#;	xmlGetAttrValueNsIndex(documentId,nodeId,attributeName)
#;		Return namespace index into namespace table corresponding to the prefix when the attribute value is of the form "prefix:value".
#;      xmlGetAttrValueNsIndex returns 0 for no namespace
#define xmlaGetAttrValueNsIndex(%documentId,%attribute) $zwascii(%attribute,11)
#define xmlGetAttrValueNsIndex(%documentId,%nodeId,%attributeName)  $replace($$$xmlaGetAttrValueNsIndex(%documentId,$$$xmliGetAttributeByName(%documentId,%nodeId,%attributeName)),-1,0)
 
#;
#;	xmlSetAttrValueNsIndex(documentId,nodeId,attributeName,index)
#;		Set namespace index into namespace table corresponding to the prefix when the attribute value is of the form "prefix:value".
#define xmlSetAttrValueNsIndex(%documentId,%nodeId,%attributeName,%index) Do ##class(%XML.ImportHandler).SetAttribute(%documentId,.%nodeId,%attributeName,$zwchar(%index),11,12)
 
#;
#;	xmlaGetAttrValueNsURI(documentId,attribute)
#;      Input is internal attribute format.
#;		Return namespace URI corresponding to the prefix when the attribute value is of the form "prefix:value".
#;	xmlGetAttrValueNsURI(documentId,nodeId,attributeName)
#;		Return namespace URI corresponding to the prefix when the attribute value is of the form "prefix:value".
#define xmlaGetAttrValueNsURI(%documentId,%attribute) $get($$$xmliDocRef(%documentId)"n",$$$xmlaGetAttrValueNsIndex(%documentId,%attribute)))
#define xmlGetAttrValueNsURI(%documentId,%nodeId,%attributeName) $$$xmlaGetAttrValueNsURI(%documentId,$$$xmliGetAttributeByName(%documentId,%nodeId,%attributeName))
 
#;
#;	xmlIndexToNamespace(documentId,nsIndex)
#;		Return XML namespace URI for nsIndex into document's namespace table.
#define xmlIndexToNamespace(%documentId,%nsIndex) $get($$$xmliDocRef(%documentId)"n",%nsIndex))
 
#;
#;	xmlNamespaceToIndex(documentId,nsURI)
#;		Return XML nsIndex into document's namespace table for namespace URI.
#define xmlNamespaceToIndex(%documentId,%nsURI) $get($$$xmliDocRef(%documentId)"N",%nsURI))
 
#;
#;	xmlCountNamespace(documentId)
#;		Return number of namepsaces in document's namespace table.
#define xmlCountNamespace(%documentId) +$get($$$xmliDocRef(%documentId)"n"))
 
#;
#;	xmlInsertNamespace(documentId,nsURI)
#;		Insert a namespace into document's namespace table for namespace URI and return the index.
#define xmlInsertNamespace(%documentId,%nsURI) Set $$$xmliDocRef(%documentId)"N",%nsURI)=$increment($$$xmliDocRef(%documentId)"n")),$$$xmliDocRef(%documentId)"n",$$$xmliDocRef(%documentId)"n"))=%nsURI
 
#;
#;	xmlIndexToName(documentId,index)
#;		Return XML name for index into document's name dictionary.
#define xmlIndexToName(%documentId,%index) $get($$$xmliDocRef(%documentId)"d",%index))
 
#;
#;	xmlGetNodeById(documentId,id)
#;		Return nodeId for node with id attribute = %id.
#define xmlGetNodeById(%documentId,%id) $select($get($$$xmliGetId(%documentId,%id))="":"",1:$$$xmliMakeNodeId(%documentId,$$$xmliNodeIdCLparent($$$xmliGetId(%documentId,%id)),$$$xmliNodeIdCLoffset($$$xmliGetId(%documentId,%id))))
 
#;
#;	xmlSetNodeById(documentId,id,nodeid)
#;		Save nodeId for node with id attribute = %id.
#define xmlSetNodeById(%documentId,%id,%nodeId) Set $$$xmliDocRef(%documentId)"i",%id)=$$$xmliNodeIdCLparent(%nodeId)_","_$$$xmliNodeIdCLoffset(%nodeId)
 
#;
#;	xmlGetNumberFatalErrors(documentId)
#;		Return the number of fatal errors from the parsing of the XML.
#define xmlGetNumberFatalErrors(%documentId) $order($$$xmliDocRef(%documentId)"fatalerror",""),-1)
 
#;
#;	xmlGetFatalError(documentId,index)
#;		Return the fatal error for 1-based index.
#define xmlGetFatalError(%documentId,%index) $get($$$xmliDocRef(%documentId)"fatalerror",%index))
 
#;
#;	xmlGetNumberErrors(documentId)
#;		Return the number of errors from the parsing of the XML.
#define xmlGetNumberErrors(%documentId) $order($$$xmliDocRef(%documentId)"error",""),-1)
 
#;
#;	xmlGetError(documentId,index)
#;		Return the error for 1-based index.
#define xmlGetError(%documentId,%index) $get($$$xmliDocRef(%documentId)"error",%index))
 
#;
#;	xmlGetNumberWarnings(documentId)
#;		Return the number of warnings from the parsing of the XML.
#define xmlGetNumberWarnings(%documentId) $order($$$xmliDocRef(%documentId)"warning",""),-1)
 
#;
#;	xmlGetWarning(documentId,index)
#;		Return the warning for 1-based index.
#define xmlGetWarning(%documentId,%index) $get($$$xmliDocRef(%documentId)"warning",%index))
 
#;
#;	xmlGetVersion(documentId)
#;		Return the version of this DOM
#define xmlGetVersion(%documentId) $get($$$xmliDocRef(%documentId)"v"))
 
 