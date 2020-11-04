ROUTINE %occCPT [Type=INC]


#; ----- this is for developer use, for the early stages of debugging new parse-tree generators
#;#define AUTOTYPEINDEX
#; -----



#; CPT shell configuration
#define ISHPT(%lang) (((%lang)="COS") && ($$$GETCONFIG((%lang),"HPT")'=0))

#; parse tree
 
/// parse tree global
#define CPTG ^||%isc.cpt

/// tree for the given tree index
/// %tree            - tree index
#define CPT(%tree) ^||%isc.cpt(%tree)

/// index of most-recently-created tree ("" if none)
#define CPTLASTTREE $Order(^||%isc.cpt(""),-1)

/// next available index in tree
#define CPTNEXTTREE ($$$CPTLASTTREE+1)

/// language of the given tree
/// %tree            - tree index
#define CPTLANG(%tree) $List(^||%isc.cpt(%tree),4)
  
/// count of nodes for the given tree index
/// %tree            - tree index
#define CPTNODECOUNT(%tree) $List(^||%isc.cpt(%tree),3)

/// node for the given tree, node indices
/// %tree            - tree index
/// %node            - node index
#define CPTNODE(%tree,%node) ^||%isc.cpt(%tree,%node)
 
/// node type for the given tree, node indices
/// %tree            - tree index
/// %node            - node index
#define CPTNODETYPE(%tree,%node) $List(^||%isc.cpt(%tree,%node))
 
/// parent node for the given tree, node indices
/// %tree            - tree index
/// %node            - node index
#define CPTNODEPARENTNODE(%tree,%node) $List(^||%isc.cpt(%tree,%node),2)
#; - this may give a <NULL VALUE> error if the tree is incompletely-constructed

/// parent node for the given tree, node indices
/// %tree            - tree index
/// %node            - node index
#define CPTNODEPARENTNODEGET(%tree,%node) $ListGet(^||%isc.cpt(%tree,%node),2)
#; - the $ListGet avoids problems when listing incompletely-constructed trees

/// parent node's child index for the given tree, node indices
/// %tree            - tree index
/// %node            - node index
#define CPTNODEPARENTCHILD(%tree,%node) $List(^||%isc.cpt(%tree,%node),3)
#; - you can use this to set the parentchild
 
/// parent node's child index for the given tree, node indices
/// %tree            - tree index
/// %node            - node index
#define CPTNODEPARENTCHILDGET(%tree,%node) +$ListGet(^||%isc.cpt(%tree,%node),3)
#; - you can't use this to set the parentchild but it's better for getting: the +$ListGet makes it return 0 for the root node

/// count of annotations for the given node (some may be absent)
/// %tree            - tree index
/// %node            - node index
#define CPTNODEANNCOUNT(%tree,%node) ^||%isc.cpt(%tree,%node,"a")

/// annotations root for the given node (suitable for killing)
/// %tree            - tree index
/// %node            - node index
#define CPTNODEANNROOT(%tree,%node) ^||%isc.cpt(%tree,%node,"a")

/// annotation for the given tree, node, annotation indices
/// %tree            - tree index
/// %node            - node index
/// %ann             - annotation index
/// - guaranteed to be a glvn node
#define CPTNODEANN(%tree,%node,%ann) ^||%isc.cpt(%tree,%node,"a",%ann)
 
/// count of children for the given node (some may be absent)
/// %tree            - tree index
/// %node            - node index
#define CPTNODECHILDCOUNT(%tree,%node) ^||%isc.cpt(%tree,%node,"c")

/// child for the given tree, node, child indices
/// %tree            - tree index
/// %node            - node index
/// %child           - child index
/// - guaranteed to be a glvn node
#define CPTNODECHILD(%tree,%node,%child) ^||%isc.cpt(%tree,%node,"c",%child)
 
/// source extent for the given tree, node indices (endpoints ARE included)
/// %tree            - tree index
/// %node            - node index
#define CPTNODESRCEXT(%tree,%node) ^||%isc.cpt(%tree,%node,"s")
  
/// gloss zone for the given subtree given by tree, node indices (this will only be present in edited nodes)
/// %tree            - tree index
/// %node            - node index
#define CPTNODEGLOSSZONE(%tree,%node) ^||%isc.cpt(%tree,%node,"gz")
  
/// map record for the given tree, node indices
/// %tree            - tree index
/// %node            - node index
#define CPTNODEMAP(%tree,%node) ^||%isc.cpt(%tree,%node,"m")
 
 
#; source

/// source global
#define CPTSG ^||%isc.cpt.s

/// source root for the given tree index
/// %tree            - tree index
#define CPTSR(%tree) ^||%isc.cpt.s(%tree)
 
/// count of source lines for the given tree index
/// %tree            - tree index
#define CPTSLINECOUNT(%tree) $List(^||%isc.cpt.s(%tree))

/// source line for the given tree, lineno indices
/// %tree            - tree index
/// %lineno          - lineno index
#define CPTSLINE(%tree,%lineno) ^||%isc.cpt.s(%tree,%lineno)
 
 
#; gloss extent

/// gloss global
#define CPTGG ^||%isc.cpt.g

/// gloss zone root for the given tree index
/// %tree            - tree index
#define CPTGR(%tree) ^||%isc.cpt.g(%tree)
 
/// gloss zone for the given tree, zone index
/// %tree            - tree index
/// %zone            - zone (0..)
#define CPTGZONEREF(%tree,%zone) ^||%isc.cpt.g(%tree,%zone)

/// gloss reference for the given tree, zone, start lineno index
/// %tree            - tree index
/// %zone            - zone (0..)
/// %startlineno     - start line number index
#define CPTGLINEREF(%tree,%zone,%startlineno) ^||%isc.cpt.g(%tree,%zone,%startlineno)

/// gloss reference/extent for the given tree, zone, start lineno+colno indices (endpoints are NOT included)
/// %tree            - tree index
/// %zone            - zone (0..)
/// %startlineno     - start line number index
/// %startcolno      - start column number index
#define CPTGEXTENT(%tree,%zone,%startlineno,%startcolno) ^||%isc.cpt.g(%tree,%zone,%startlineno,%startcolno)
 
 
#; tablist

/// tablist global (TSQL only, no treeindex)
/// ^(qual,name)=flags
/// - qual is 1 if a qualified name, 0 otherwise
/// - flags are "F" if a field, "" otherwise
#define TSQLTABLISTG ^||%isc.cpt.tablist

/// tablist global (all but TSQL, with treeindex)
/// ^(treeindex,qual,name)=flags
/// - qual is 1 if a qualified name, 0 otherwise
/// - flags are "F" if a field, "" otherwise
#define CPTTABLISTG ^||%isc.cpt.tfnames

 
#; node index
 
#define CPTIX(%lang) ^||%isc.cptix(%lang)
 
#; unset
#define CPTIXENUM(%lang,%enum) ^||%isc.cptix(%lang,"e",%enum)
 
#; set to the enum value name
#define CPTIXENUMVALUE(%lang,%enum,%valueindex) ^||%isc.cptix(%lang,"e",%enum,%valueindex)
 
#; set to the enum value index
#define CPTIXENUMVALUER(%lang,%enum,%valuename) ^||%isc.cptix(%lang,"er",%enum,%valuename)
 
#; set to the nodetype name
#define CPTIXNODE(%lang,%nodetype) ^||%isc.cptix(%lang,"n",%nodetype)

#; set to the node index
#define CPTIXNODER(%lang,%nodename) ^||%isc.cptix(%lang,"nr",%nodename)
 
#; set to $ListBuild(isoptional,anntype,annname)
#define CPTIXNODEANN(%lang,%nodetype,%ann) ^||%isc.cptix(%lang,"n",%nodetype,"a",%ann)
 
#; set to annotation index
#define CPTIXNODEANNR(%lang,%nodetype,%annname) ^||%isc.cptix(%lang,"n",%nodetype,"ar",%annname)

#; set to $ListBuild(isoptional,childname)
#; - or if a list then childname="list-X" and %child=0
#define CPTIXNODECHILD(%lang,%nodetype,%child) ^||%isc.cptix(%lang,"n",%nodetype,"c",%child)
 
#; set to child index
#define CPTIXNODECHILDR(%lang,%nodetype,%childname) ^||%isc.cptix(%lang,"n",%nodetype,"cr",%childname)

#; given an annotation name, return the field name part
#define CPTANNFIELDPART(%annname) $Piece(%annname,"-")

#; given an annotation name, return the enumeration type part
#define CPTANNENUMPART(%annname) $Select(%annname["-":$Piece(%annname,"-",2),1:%annname)


#; child reverse-index .. this is not set up by default, use CalloutIndex:BuildChildReverseIndexIfNeeded to create it

#; This is set (to "") when the index is built
#define CPTIXCRBUILT(%lang) ^||%isc.cptix(%lang,"built")

#; For clearing the index
#define CPTIXCRNODENODEBASE(%lang) ^||%isc.cptix(%lang,"crnn")
#define CPTIXCRNODECLASSBASE(%lang) ^||%isc.cptix(%lang,"crnc")

#; The meaning is that the %child child of node %nodetype is a node of type %childnodetype
#define CPTIXCRNODENODE(%lang,%childnodetype,%nodetype,%child) ^||%isc.cptix(%lang,"crnn",%childnodetype,%nodetype,%child)

#; The meaning is that the %child child of node %nodetype is a node class of name %childnodeclass
#define CPTIXCRNODECLASS(%lang,%childnodeclass,%nodetype,%child) ^||%isc.cptix(%lang,"crnc",%childnodeclass,%nodetype,%child)

#; For scanning the index subtrees (no data at these references) ..
#define CPTIXCRNODENODE1(%lang,%childnodetype) ^||%isc.cptix(%lang,"crnn",%childnodetype)
#define CPTIXCRNODENODE2(%lang,%childnodetype,%nodetype) ^||%isc.cptix(%lang,"crnn",%childnodetype,%nodetype)
#define CPTIXCRNODECLASS1(%lang,%childnodeclass) ^||%isc.cptix(%lang,"crnc",%childnodeclass)
#define CPTIXCRNODECLASS2(%lang,%childnodeclass,%nodetype) ^||%isc.cptix(%lang,"crnc",%childnodeclass,%nodetype)


#; type index
#; see also: %CPT.CalloutTypeIndex:IsEqualOrDescendantOf

#define CPTTIX(%lang) ^||%isc.cpttix(%lang)
 
#; unset
#define CPTTIXPBASE(%lang) ^||%isc.cpttix(%lang,"p")

#; set to "" when the node definition is seen
#define CPTTIXP(%lang,%ct) ^||%isc.cpttix(%lang,"p",%ct)

#; %pc is a parent class of %ct - set when the parent class is defined
#define CPTTIXP2(%lang,%ct,%pc) ^||%isc.cpttix(%lang,"p",%ct,%pc)
 
#define CPTIXCBASE(%lang) ^||%isc.cpttix(%lang,"c")

#; set to ""
#define CPTTIXC(%lang,%pc) ^||%isc.cpttix(%lang,"c",%pc)

#; %ct is a choice in class %pc - set to ""
#define CPTTIXC2(%lang,%pc,%ct) ^||%isc.cpttix(%lang,"c",%pc,%ct)

#; nodetype dispatch table

#define CPTDTG(%lang) ^||%isc.cptdt(%lang)

#define CPTDT(%lang,%nodetype) ^||%isc.cptdt(%lang,%nodetype)

#define CPTDTDEF(%lang,%nodetype) $Get(^||%isc.cptdt(%lang,%nodetype),"DefaultHandler")


#; throw a string -> general error
#define CPTTHROW(%str) Break:$Data(%BREAK)  Throw ##class(%Exception.General).%New(,,,%str)


#; callout config
#define GETCONFIG(%lang,%key) ##class(%CPT.CalloutConfig).GetConfig(%lang,%key)


#; callout shell
#define CPTCSSETTINGTOP ^||%isc.cpt.calloutshell("setting")
#define CPTCSSETTING(%settingname) ^||%isc.cpt.calloutshell("setting",%settingname)


#; %CPT.SQLCallout:CompileBatch overflow records

#; for SQLCallout:CompileBatch, only
#define CPTOVERFLOWROOT ^||%isc.cpt.overflow

#; for clients to access overflow records - note that the record number doesn't (usually) start at 1
#; - it follows on from the returned record's last record number
#define CPTOVERFLOW(%recno) ^||%isc.cpt.overflow(%recno)
#define CPTOVERFLOWSUB(%recno,%sub) ^||%isc.cpt.overflow(%recno,%sub)

#; create an object (return status if error)
#define CPTNEWOBJECTST(%var,%class,%args) $$$CPTNEWOBJECTIMPL(%var,%class,%args,Quit %objlasterror)

#; create an object (throw exception if error)
#define CPTNEWOBJECTEX(%var,%class,%args) $$$CPTNEWOBJECTIMPL(%var,%class,%args,$$$ThrowStatus(%objlasterror))

#; create an object and perform the given action on error
#define CPTNEWOBJECTIMPL(%var,%class,%args,%onerror) Kill %objlasterror Set %var=##class(%class).%New%args If '$IsObject(%var) {%onerror}


#; %CPT.SQLCallout:Compile2

#; PPG for SQL source to pass to SQLCallout:Compile2
#; ^||%isc.cpt.source = linecount
#; ^||%isc.cpt.source(lineno) = line
#define CPTSOURCEROOT ^||%isc.cpt.source

#; count of source lines
#define CPTSOURCECOUNT $$$CPTSOURCEROOT

#; a source line
#define CPTSOURCELINE(%lineno) $$$CPTSOURCEROOT(%lineno)

#; PPG for results from SQLCallout:Compile2
#; ^||%isc.cpt.results(1) = normsource linecount
#; ^||%isc.cpt.results(1,lineno) = normsource line
#; ^||%isc.cpt.results(2) = placeholder index ($List)
#; ^||%isc.cpt.results(3) = parsing errors ($List)
#; ^||%isc.cpt.results(4,1) = unqualified non-fields ($List)
#; ^||%isc.cpt.results(4,2) = qualified non-fields ($List)
#; ^||%isc.cpt.results(4,3) = unqualified fields ($List)
#; ^||%isc.cpt.results(4,4) = qualified fields ($List)
#define CPTRESULTSROOT ^||%isc.cpt.results

#; count of normalized-source lines
#define CPTRESULTSNORMCOUNT $$$CPTRESULTSROOT(1)

#; a normalized-source line
#define CPTRESULTSNORMLINE(%lineno) $$$CPTRESULTSROOT(1,%lineno)

#; placeholder index
#define CPTRESULTSPHINDEX $$$CPTRESULTSROOT(2)

#; list of errors
#define CPTRESULTSERRORS $$$CPTRESULTSROOT(3)

#; tablist
#define CPTRESULTSTABUNQUALNONF $$$CPTRESULTSROOT(4,1)
#define CPTRESULTSTABQUALNONF $$$CPTRESULTSROOT(4,2)
#define CPTRESULTSTABUNQUALF $$$CPTRESULTSROOT(4,3)
#define CPTRESULTSTABQUALF $$$CPTRESULTSROOT(4,4)

#define CacheIsUnicode $ZBitGet($ZVersion(0),1)

