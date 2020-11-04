ROUTINE %xmlDOMInternal [Type=INC]
#;   Internal only macros for use in implementing %xmlDOM.
#;
#;   These macros should not be directly used by customer code
#;

#;
#;	xmliDocRef(documentId) -- Internal only
#;		Define reference to document node in one place
#;		This macro is only for use within this include file
#define xmliDocRef(%documentId) @(%documentId)@(
#define xmliDocGlobal(%documentId) @%documentId
#define xmliDocId2(%global,%tree) %global_"("_%tree_")"
#define xmliDocId(%document) %document.DOMName_"("_%document.Tree_")"
 
#;
#;  Node base offsets -- Internal only
#;      Length of base data before child list in element node  -- Internal only
#define xmliCLBase              29
#;      Maximum length of character node data
#define xmliMaxCharacterNode 32767
#;      Length of each descriptor: attribute, element or character
#define xmliAttributeSize       16
#define xmliAttributeSize1      15
#define xmliDescriptorSize       4
#define xmliDescriptorSize1      3
#;      Maximum length of element descriptor
#define xmliCLMaxNode        32764
 
#;
#;  Create new nodes.  Create a new node and return the node id in nodeId argument
#;      xmliNewCLNode(%documentId,parent,offset,name,numAttrs,flags,URI,qname,line,column) -- Internal only
#;      xmliNewElementDescriptor(documentId,childlist) -- Internal only
#;      xmliNewCharacterDescriptor(documentId,text) -- Internal only
#define xmliNewCLNode(%documentId,%parent,%offset,%name,%numAttrs,%flags,%URI,%qname,%line,%column) $zlchar(%parent,%offset,##class(%XML.ImportHandler).GetNameIndex(%documentId,%name),$select($length(%qname,":")'=2:0,1:16*##class(%XML.ImportHandler).GetNameIndex(%documentId,$piece(%qname,":",1)_":"))+%flags)_$zwchar(%numAttrs*$$$xmliAttributeSize+$$$xmliCLBase,##class(%XML.ImportHandler).GetNamespaceIndex(%documentId,%URI))_$zlchar(%line,%column)
#define xmliNewElementDescriptor(%documentId,%childlist) 16*%childlist
#define xmliNewCharacterDescriptor(%documentId,%text) 16*##class(%XML.ImportHandler).GetNameIndex(%documentId,%text)+$select($tr(%text,$c(9,10,13,32,160),"")="":$$$xmlWHITESPACENODE,1:$$$xmlTEXTNODE)
#define xmliNewRawCharacterDescriptor(%documentId,%text) 16*##class(%XML.ImportHandler).GetNameIndex(%documentId,%text)+$$$xmlRAWTEXTNODE
#define xmliNewNextDescriptor(%documentId,%next) 16*%next+$$$xmliNEXTNODE
 
#;
#;  xmliCLNode(documentId,CLid) -- Internal only
#;  xmliCLDesc(documentId,CLid,offset)
#define xmliCLNode(%documentId,%CLid) $$$xmliDocRef(%documentId)%CLid)
#define xmliCLDesc(%documentId,%CLid,%offset) $zlascii($$$xmliCLNode(%documentId,%CLid),%offset)

#;
#;  xmliGetDescriptor(documentId,nodeId)
#;  xmliGetDescriptor1(documentId,childlist,offset)
#;  xmliGetDescriptor2(documentId,parent,offset)
#define xmliGetDescriptor(%documentId,%nodeId) $zlascii($$$xmliCLNode(%documentId,$$$xmliNodeIdCLparent(%nodeId)),$$$xmliNodeIdCLoffset(%nodeId))
#define xmliGetDescriptor1(%documentId,%childlist,%offset) $zlascii(%childlist,%offset)
#define xmliGetDescriptor2(%documentId,%parent,%offset) $$$xmliGetDescriptor1(%documentId,$$$xmliCLNode(%documentId,%parent),%offset)
 
#;
#;  xmliReplaceDescriptor(documentId,nodeId,descriptor)
#;  xmliReplaceDescriptor2(documentId,parent,offset,descriptor)
#;      Replace descriptor
#define xmliReplaceDescriptor(%documentId,%nodeId,%descriptor) Set $extract($$$xmliCLNode(%documentId,$$$xmliNodeIdCLparent(%nodeId)),$$$xmliNodeIdCLoffset(%nodeId),$$$xmliNodeIdCLoffset(%nodeId)+$$$xmliDescriptorSize1)=$zlchar(%descriptor)
#define xmliReplaceDescriptor2(%documentId,%parent,%offset,%descriptor) Set $extract($$$xmliCLNode(%documentId,%parent),%offset,%offset+$$$xmliDescriptorSize1)=$zlchar(desc)
 
#;
#;  xmliMakeNodeId(documentId,parent,offset) -- Internal only
#;      Return the new id in nodeId argument.
#;
#define xmliMakeNodeId(%documentId,%CLparent,%CLoffset) %CLparent_","_%CLoffset
 
 
#;  xmliNodeIdCLparent(nodeId) -- Internal only
#;  xmliNodeIdCLoffset(nodeId) -- Internal only
#;
#define xmliNodeIdCLparent(%nodeId) $piece(%nodeId,",",1)
#define xmliNodeIdCLoffset(%nodeId) $piece(%nodeId,",",2)
 
#;  xmliDescValue(documentId,desc) -- Internal only
#;  xmliDescType(documentId,desc) -- Internal only
#define xmliDescValue(%documentId,%desc) (%desc\16)
#define xmliDescType(%documentId,%desc) (%desc#16)
 
#;
#;  xmliGetChildList(documentId,nodeId) -- Internal only
#;      Return subscript of child list for this element node
#;  xmliChildListNode(documentId,nodeId) -- Internal only
#;      Return child list for this element node
#define xmliGetChildList(%documentId,%nodeId) $$$xmliDescValue(%documentId,$$$xmliGetDescriptor(%documentId,%nodeId))
#define xmliChildListNode(%documentId,%nodeId) $$$xmliCLNode(%documentId,$$$xmliGetChildList(%documentId,%nodeId))
 
#;
#;	xmliSetDocumentNode(documentId) -- Internal only
#;		Set the top node of the document.
#define xmliSetDocumentNode(%documentId) Set $$$xmliCLNode(%documentId,0)=$$$xmliNewCLNode(%documentId,0,0,"",0,0,"","",0,0)_$zlchar($$$xmliNewNextDescriptor(%documentId,0))
 
#;
#;  Retrieve fields of child list node base
#;      xmliCLparent(documentId,childlist) -- Internal only
#;      xmliCLoffset(documentId,childlist) -- Internal only
#;      xmliCLname(documentId,childlist) -- Internal only
#;      xmliCLprefix(documentId,childlist) -- Internal only
#;      xmliCLflags(documentId,childlist) -- Internal only
#;      xmliCLelementOffset(documentId,childlist) -- Internal only
#;      xmliCLURI(documentId,childlist) -- Internal only
#;      xmliCLline(documentId,childlist) -- Internal only
#;      xmliCLcolumn(documentId,childlist) -- Internal only
#;      xmliCLnext(documentId,childlist) -- Internal only
#;           childlist is the actual subscript of the child list node 
#define xmliCLparent(%documentId,%childlist) $zlascii(%childlist,1)
#define xmliCLoffset(%documentId,%childlist) $zlascii(%childlist,5)
#define xmliCLname(%documentId,%childlist) $zlascii(%childlist,9)
#define xmliCLprefix(%documentId,%childlist) ($zlascii(%childlist,13)\16)
#define xmliCLflags(%documentId,%childlist) ($zlascii(%childlist,13)#16)
#define xmliCLelementOffset(%documentId,%childlist) $zwascii(%childlist,17)
#define xmliCLURI(%documentId,%childlist) $zwascii(%childlist,19)
#define xmliCLline(%documentId,%childlist) $zlascii(%childlist,21)
#define xmliCLcolumn(%documentId,%childlist) $zlascii(%childlist,25)
#define xmliCLnext(%documentId,%childlist) ($zlascii(%childlist,$length(%childlist)-$$$xmliDescriptorSize1)\16)
 
#;
#;  Set fields of child list node base.  Fields are set in the actual global node.
#;      xmliSetCLparent(documentId,CLid,value) -- Internal only
#;      xmliSetCLoffset(documentId,CLid,value) -- Internal only
#;      xmliSetCLname(documentId,CLid,value) -- Internal only
#;      xmliSetCLprefix(documentId,CLid,value) -- Internal only
#;      xmliSetCLflags(documentId,CLid,value) -- Internal only
#;      xmliSetCLelementOffset(documentId,CLid,value) -- Internal only
#;      xmliSetCLURI(documentId,CLid,value) -- Internal only
#;      xmliSetCLline(documentId,CLid,value) -- Internal only
#;      xmliSetCLcolumn(documentId,CLid,value) -- Internal only
#;      xmliSetCLnext(documentId,CLid,value) -- Internal only
#;           CLid is the actual subscript of the child list node 
#define xmliSetCLparent(%documentId,%CLid,%value) Set $extract($$$xmliCLNode(%documentId,%CLid),1,4)=$zlchar(%value)
#define xmliSetCLoffset(%documentId,%CLid,%value) Set $extract($$$xmliCLNode(%documentId,%CLid),5,8)=$zlchar(%value)
#define xmliSetCLname(%documentId,%CLid,%value) Set $extract($$$xmliCLNode(%documentId,%CLid),9,12)=$zlchar(%value)
#define xmliSetCLprefix(%documentId,%CLid,%value) Set $extract($$$xmliCLNode(%documentId,%CLid),13,16)=$zlchar(16*%value+$$$xmliCLflags(%documentId,$$$xmliCLNode(%documentId,%CLid)))
#define xmliSetCLflags(%documentId,%CLid,%value) Set $extract($$$xmliCLNode(%documentId,%CLid),13,16)=$zlchar(16*$$$xmliCLprefix(%documentId,$$$xmliCLNode(%documentId,%CLid))+%value)
#define xmliSetCLelementOffset(%documentId,%CLid,%value) Set $extract($$$xmliCLNode(%documentId,%CLid),17,18)=$zwchar(%value)
#define xmliSetCLURI(%documentId,%CLid,%value) Set $extract($$$xmliCLNode(%documentId,%CLid),19,20)=$zwchar(%value)
#define xmliSetCLline(%documentId,%CLid,%value) Set $extract($$$xmliCLNode(%documentId,%CLid),21,24)=$zlchar(%value)
#define xmliSetCLcolumn(%documentId,%CLid,%value) Set $extract($$$xmliCLNode(%documentId,%CLid),25,28)=$zlchar(%value)
#define xmliSetCLnext(%documentId,%CLid,%value) Set $$$xmliCLNode(%documentId,%CLid)=$$$xmliCLNode(%documentId,%CLid)_$zlchar($$$xmliNewNextDescriptor(%documentId,%value))
#define xmliUpdateCLnext(%documentId,%CLid,%value) Set $extract($$$xmliCLNode(%documentId,%CLid),$length($$$xmliCLNode(%documentId,%CLid))-$$$xmliDescriptorSize1,$length($$$xmliCLNode(%documentId,%CLid)))=$zlchar($$$xmliNewNextDescriptor(%documentId,%value))

#; Internal macro to define node ordering for XML VDoc
#;   $$$xmliChildOrder for two children of the same parent (responsibility of caller to ensure this condition)
#;   would return =0 if =, >0 if childId1>childId2 and <0 otherwise.
#;   This macro would be guaranteed for XML DOM structure that is created by %XML.ImportHandler/%XML.Reader.
#define xmliChildOrder(%documentId,%parentId,%childId1,%childId2) ($$$xmliNodeIdCLoffset(%childId1)-$$$xmliNodeIdCLoffset(%childId2))
 
#;
#;	xmliNumberChildNodes(documentId,childlist)
#;		Return the number of nodes in this child list.
#define xmliNumberChildNodes(%documentId,%childlist) (($length(%childlist)-$$$xmliCLelementOffset(%documentId,%childlist)-$$$xmliDescriptorSize1)\$$$xmliDescriptorSize)
 
#;
#;	xmliSetElementLocation(documentId,nodeId,line,column) -- Internal only
#;		Set location for element node.
#define xmliSetElementLocation(%documentId,%nodeId,%line,%column) $$$xmliSetCLline(%documentId,$$$xmliGetChildList(%documentId,%nodeId),%line) $$$xmliSetCLcolumn(%documentId,$$$xmliGetChildList(%documentId,%nodeId),%column)
 
#;
#;  xmliNewAttributee(documentId,name,qname,URI,valueURI,value) -- Internal only
#;  xmliEmptyAttribute -- Internal only
#;
#define xmliNewAttribute(%documentId,%name,%qname,%URI,%valueURI,%value) $zlchar(##class(%XML.ImportHandler).GetNameIndex(%documentId,%name))_$select($length(%qname,":")'=2:$zlchar(0),1:$zlchar(##class(%XML.ImportHandler).GetNameIndex(%documentId,$piece(%qname,":",1)_":")))_$select(%URI="":$zwchar(0),1:$zwchar(##class(%XML.ImportHandler).GetNamespaceIndex(%documentId,%URI)))_$select(%valueURI="":$zwchar(0),1:$zwchar(##class(%XML.ImportHandler).GetNamespaceIndex(%documentId,%valueURI)))_$select(%value="":$zlchar(0),1:$zlchar(##class(%XML.ImportHandler).GetNameIndex(%documentId,%value)))
#define xmliEmptyAttribute $zlchar(0,0)_$zwchar(0,0)_$zlchar(0)
 
#;
#;  xmliAttributeMap(documentId) and xmliAttributeMapNode(documentId,name) -- Internal only
#;      Internal node references
#define xmliAttributeMap(%documentId) $$$xmliDocRef(%documentId)"a")
#define xmliAttributeMapNode(%documentId,%name) $$$xmliDocRef(%documentId)"a",%name)
 
#;
#;	xmliGetAttributeByName(documentId,nodeId,name) -- Internal only
#;		Return internal format of attribute based on attribute name.
#define xmliGetAttributeByName(%documentId,%nodeId,%attributeName) $select(($get($$$xmliDocRef(%documentId)"a"))=%nodeId)||##class(%XML.ImportHandler).GetAttributeMap(%documentId,%nodeId):$get($$$xmliDocRef(%documentId)"a",%attributeName)),1:"")
 
#;
#;	xmliNameToIndex(documentId,name) -- Internal only
#;		Return index into document's names dictionary.
#define xmliNameToIndex(%documentId,%name) $select($length(%name)<=100:$get($$$xmliDocRef(%documentId)"D",%name)),1:"")
 
#;
#;	xmliCountName(documentId) -- Internal only
#;		Return number of names in document's name dictionary.
#define xmliCountName(%documentId) +$get($$$xmliDocRef(%documentId)"d"))
 
#;
#;	xmliInsertName(documentId,name) -- Internal only
#;		Insert a name into document's name dictionary and return the index.
#define xmliInsertName(%documentId,%name) Set $$$xmliDocRef(%documentId)"d",$increment($$$xmliDocRef(%documentId)"d")))=%name If $length(%name)<128 Set $$$xmliDocRef(%documentId)"D",%name)=$$$xmliDocRef(%documentId)"d")
 
#;
#;	xmliGetId(documentId,id)
#;		Return nodeId for node with id attribute = %id.
#define xmliGetId(%documentId,%id) $$$xmliDocRef(%documentId)"i",%id)
 