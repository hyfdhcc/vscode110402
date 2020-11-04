ROUTINE %occDS [Type=INC]
#; %occDS.inc - macros that implement various data structures used by the class compiler
#;
#define me +$this
#; Macros that implement a stack
#;=================================================================\\
#; G L O B A L  N A M E S                                          ||
#;-----------------------------------------------------------------||
#; cpsGlobal - global used to store instances of a stack
#define cpsGlobal								^||%isc.stack
#; cptGlobal - global used to store instances of Cache Parse Tree
#define cptGlobal								^||%isc.cpt
#; opGlobal - global used to store instances of Operand (superTokens)
#define opGlobal								^||%isc.op
#; floGlobal - global used to store instances of a flo graph (primitive/perhaps misuse of term) 
#define floGlobal								i%flodata
 
#; PREFIX
#; form of cpsGlobal, cptGlobal, etc to be used for combining with more specific references
#define cpsRoot														^||%isc.stack(
#define cptRoot														^||%isc.cpt(
#define opRoot														^||%isc.op(
#define floRoot														i%flodata(
 
#; Reference to an instance of a stack, combinable form
#define cps(%stack)													$$$cpsGlobal(%stack
#; Reference to an instance of a parse tree, combinable form
#define cpt(%tree)													$$$cptGlobal(%tree
#; Reference to operands, subscripted by the tree pointer, just like CPT
#define op															$$$opGlobal($$$me
#; Reference to a flo graph, combinable form (prefix)
#define flo(%flo)													$$$floGlobal
#;-----------------------------------------------------------------||
#; E N D  G L O B A L  N A M E S                                   ||
#;=================================================================//
 
#;-----------------------------------------------------------------||
#; S T A C K
#; stack IDLOCATION
#define cpsCounter													$$$cpsGlobal
 
#; The STACK instance
#define STACK(%stack)												$$$cps(%stack))
#define STACKELEMENT(%stack,%element)								$$$cps(%stack),%element)
#define	STACKELEMENTattribute(%stack,%element)						$$$cps(%stack),%element,"a") 
 
#; A specific attribute. STACKELEMENTATTRIBUTE allows additional information to be stored in the stack
#define	STACKELEMENTATTRIBUTE(%stack,%element,%attribute)			$$$cps(%stack),%element,%attribute) 
 
#;---------------------------------------- 
#; Stack methods - LIFO
#;---------------------------------------- 
#if '$Get(^ISCDEBUG)	;
#define createStack(%stack)											s %stack=$i($$$cpsCounter) k $$$STACK(%stack) s $$$STACK(%stack)=""
	#; destruct stack
#define dropStack(%stack)											k $$$STACK(%stack)
	#; clear stack
#define clearStack(%stack)											k $$$STACK(%stack) s $$$STACK(%stack)=""
	#; push new element onto the stack
#define pushoperand(%stack,%value,%type,%priority,%token)			s $$$STACKELEMENT(%stack,$i($$$STACK(%stack)))=$lb(%value,%type,%priority,%token)
#define pushstack(%stack,%value)									s $$$STACKELEMENT(%stack,$i($$$STACK(%stack)))=%value
	#; pop and return
#define popoperand(%stack,%value,%type,%priority,%token)			s %value=$$$STACKELEMENT(%stack,$$$STACK(%stack)),%type=$lg(%value,2),%priority=$lg(%value,3),%token=$lg(%value,4),%value=$lg(%value,1) k $$$STACKELEMENT(%stack,$$$STACK(%stack)) s $$$STACK(%stack)=$$$STACK(%stack)-1
#define popstack(%stack,%value)										s %value=$$$STACKELEMENT(%stack,$$$STACK(%stack)) k $$$STACKELEMENT(%stack,$$$STACK(%stack)) s $$$STACK(%stack)=$$$STACK(%stack)-1
	#; returns the value of the top element on the stack
#define top(%stack)													$$$STACKELEMENT(%stack,$$$STACK(%stack))
#define topopvalue(%stack)											$lg($$$STACKELEMENT(%stack,$$$STACK(%stack)),1)
	#; This allows the caller to peek below the top of the stack without disrupting the stack. I know - it's cheating.
#define peek(%stack,%level)											$Select(($$$STACK(%stack)-%level)>0:$$$STACKELEMENT(%stack,($$$STACK(%stack)-%level)),1:"")
	#; returns the value, type and token flag in %value, %type, %priority and %token
#define topoperand(%stack,%value,%type,%priority,%token)			s %value=$$$STACKELEMENT(%stack,$$$STACK(%stack)),%type=$lg(%value,2),%priority=$lg(%value,3),%token=$lg(%value,4),%value=$lg(%value,1)
	#; pop and discard
#define pop(%stack)													k $$$STACKELEMENT(%stack,$$$STACK(%stack)) s $$$STACK(%stack)=$$$STACK(%stack)-1
#else	;
#define WhoStackedMe												$Select($Get(nodePtr):nodePtr_"::"_$Select($Get(parseTree)'="":$$$CPTNODEtype(parseTree.treePtr,nodePtr),1:""),1:"")
#define createStack(%stack)											s %stack=$i($$$cpsCounter) k $$$STACK(%stack) s $$$STACK(%stack)="" w !,$$$WhoStackedMe,":Created new stack: ",%stack
	#; destruct stack
#define dropStack(%stack)											k $$$STACK(%stack) w !,$$$WhoStackedMe,":Destructed stack: ",%stack
	#; clear stack
#define clearStack(%stack)											k $$$STACK(%stack) s $$$STACK(%stack)="" w !,$$$WhoStackedMe,":Cleared stack: ",%stack
	#; push new element onto the stack
#define pushoperand(%stack,%value,%type,%priority,%token)			s $$$STACKELEMENT(%stack,$i($$$STACK(%stack)))=$lb(%value,%type,%priority,%token) w !,$$$WhoStackedMe,":Pushed stack '%stack': " s %zw=%value zw %zw  w "::",%type,"::",%priority,"::",%token
#define pushstack(%stack,%value)									s $$$STACKELEMENT(%stack,$i($$$STACK(%stack)))=%value w !,$$$WhoStackedMe,":Pushed stack '%stack': " s %zw = %value zw %zw
	#; pop and return
#define popoperand(%stack,%value,%type,%priority,%token)			w !,$$$WhoStackedMe,":Popped element from stack '%stack': " zw $$$STACKELEMENT(%stack,$$$STACK(%stack)) s %value=$$$STACKELEMENT(%stack,$$$STACK(%stack)),%type=$lg(%value,2),%priority=$lg(%value,3),%token=$lg(%value,4),%value=$lg(%value,1) k $$$STACKELEMENT(%stack,$$$STACK(%stack)) s $$$STACK(%stack)=$$$STACK(%stack)-1
#define popstack(%stack,%value)										w !,$$$WhoStackedMe,":Popped element from stack '%stack': " zw $$$STACKELEMENT(%stack,$$$STACK(%stack)) s %value=$$$STACKELEMENT(%stack,$$$STACK(%stack)) k $$$STACKELEMENT(%stack,$$$STACK(%stack)) s $$$STACK(%stack)=$$$STACK(%stack)-1
	#; returns the value of the top element on the stack
#define top(%stack)													$$$STACKELEMENT(%stack,$$$STACK(%stack))
#define topopvalue(%stack)											$lg($$$STACKELEMENT(%stack,$$$STACK(%stack)),1)
	#; This allows the caller to peek below the top of the stack without disrupting the stack. I know - it's cheating.
#define peek(%stack,%level)											$Select($$$STACK(%stack)-%level:$$$STACKELEMENT(%stack,($$$STACK(%stack)-%level)),1:"")
	#; returns the value, type and token flag in %value, %type, %priority, and %token
#define topoperand(%stack,%value,%type,%priority,%token)			s %value=$$$STACKELEMENT(%stack,$$$STACK(%stack)),%type=$lg(%value,2),%priority=$lg(%value,3),%token=$lg(%value,4),%value=$lg(%value,1)
	#; pop and discard
#define pop(%stack)													k $$$STACKELEMENT(%stack,$$$STACK(%stack)) s $$$STACK(%stack)=$$$STACK(%stack)-1
#endif	;
 
#; Queue methods - FIFO
#; To queue a new element, use queue(%queue,%element).
#; The current queue pointer is always left in the "before first" position.
#define queueCounter(%queue)									$$$STACK(%queue)
#define queuePointer(%queue)									$$$STACKELEMENT(%queue,0)
#define createQueue(%queue)										s %queue=$i($$$cpsCounter) k $$$STACK(%queue) s $$$STACK(%queue)="",$$$queuePointer(%queue)=0
	#; destruct stack
#define dropQueue(%queue)										k $$$STACK(%queue)
	#; push new element onto the stack
#define queue(%queue,%element)									s $$$STACKELEMENT(%queue,$i($$$STACK(%queue)))=%element
	#; push new array element onto the stack
#define queuearray(%queue,%elementvar,%element)					set %elementvar = $i($$$STACK(%queue)) m $$$STACKELEMENT(%queue,%elementvar)=%element
	#; dequeue array and return
#define dequeuearray(%queue,%element)							i $$$queuePointer(%queue)'="" { s $$$queuePointer(%queue)=$o($$$STACKELEMENT(%queue,$$$queuePointer(%queue))) i $$$queuePointer(%queue) { m %element=$$$STACKELEMENT(%queue,queuePointer(%queue)) k $$$STACKELEMENT(%queue,queuePointer(%queue)) } } else { kill %element }
	#; return first element
#define dequeue(%queue,%element)								i $$$queuePointer(%queue)'="" { s $$$queuePointer(%queue)=$o($$$STACKELEMENT(%queue,$$$queuePointer(%queue)),1,%element) k:$$$queuePointer(%queue) $$$STACKELEMENT(%queue,$$$queuePointer(%queue)) } else { set %element="" }
 
/// The NETWORK instance
/// The network uses tDAGc for the network IDLOCATION and tDAG for the combinable form of the network location.
/// tDAG macros are defined in %occLocation.inc
#define AOV(%aov)												$$$tDAG(%aov))
#define AOVNODE(%aov,%node)										$$$tDAG(%aov),%node)
#define	AOVNODEpredecessor(%aov,%node)							$$$tDAG(%aov),%node,"p")
#define	AOVNODEsuccessor(%aov,%node)							$$$tDAG(%aov),%node,"s")
 
#define AOVNODEPREDECESSOR(%aov,%node,%pred)					$$$tDAG(%aov),%node,"p",%pred)
#define AOVNODESUCCESSOR(%aov,%node,%successor)					$$$tDAG(%aov),%node,"s",%successor)
 
#;---------------------------------------- 
#; AOV methods
#;---------------------------------------- 
#define createAOV(%aov)											s %aov=$i($$$tDAGc) k $$$AOV(%aov)
	#; destruct AOV
#define dropAOV(%aov)											k $$$AOV(%aov)
 
#define addNodePredecessor(%aov,%node,%predecessor,%refCount)	s $$$AOVNODEPREDECESSOR(%aov,%node,%predecessor) = "", $$$AOVNODEsuccessor(aov,%predecessor) = $Get($$$AOVNODEsuccessor(aov,%predecessor)) + %refCount, $$$AOVNODESUCCESSOR(aov,%predecessor,%node) = ""
#define dropNodePredecessor(%aov,%node,%predecessor)			k $$$AOVNODEPREDECESSOR(%aov,%node,%predecessor)
	#; We are performing the activity on this vertex (node) so remove this vertex from all successors and remove this node from the network
#define performActivity(%aov,%node,%successor,%stack)			s %successor = $Order($$$AOVNODESUCCESSOR(%aov,%node,"")) while %successor '= "" { $$$dropNodePredecessor(%aov,%successor,%node) if '$Data($$$AOVNODEpredecessor(%aov,%successor)) { $$$pushstack(%stack,%successor) } s %successor = $Order($$$AOVNODESUCCESSOR(%aov,%node,%successor)) }	k $$$AOVNODE(%aov,%node)
 
#;	SymbolReference - this macro formats the argument as a symbol reference in the given context
#define SymbolReference(%arg,%context)		$Char(0) _ %arg _ "*" _ %context _ $Char(0)
#define SymbolLiteral(%arg,%context)		$Char(0) _ "%arg*%context" _ $Char(0)
#;=================================================================\\
#; flo graph definition
#define FLO(%flo)													$$$flo(%flo)
#define FLOnode(%flo)												$$$flo(%flo)
#define FLONODE(%flo,%node)											$$$flo(%flo)(%node)
 
 	#; This is the code snip to end the block. Defaults to "}"
#define FLONODEancestry(%flo,%node)									$$$flo(%flo)(%node,1)
#define FLONODEblockend(%flo,%node)									$$$flo(%flo)(%node,2)
#define FLONODEblocklink(%flo,%node)								$$$flo(%flo)(%node,3)

/// FLONODEblock is true if the node's child nodes' code is to be placed inside a block
/// 		later we can add additional values to indicate IF..THEN..ELSEIF..ELSE, loops, etc.
///	BLOCKTYPE =	0	- not in block
#define FLONODEBLOCKTYPENONE					0
///				1	- BEGIN/END block
#define FLONODEBLOCKTYPEPROC					1
///				2	- LOOP BLOCK
#define FLONODEBLOCKTYPELOOP					2
///				3	- TRY/CATCH block
#define FLONODEBLOCKTYPETRY						3
/// CATCH is linked to TRY
#define FLONODEBLOCKTYPECATCH					4
#define FLONODEBLOCKTYPEIF						5
/// ELSEIF inked to IF
#define FLONODEBLOCKTYPEELSEIF					6
/// ELSE inked to IF
#define FLONODEBLOCKTYPEELSE					7
/// Iterator parent block - symbols defined in this subgraph cannot be promoted above an iterator block
#define FLONODEBLOCKTYPEITERATOR				8

#define FLONODEblocktype(%flo,%node)									$$$flo(%flo)(%node,4)
	#; FLONODEgenerator is the code generator type. Generator parameters are used by the code generator
#; TODO:
	#; FLONODEconditional is true if the node's code value is conditionally executed by the parent - for now this is a synonym for blocktype
#define FLONODEconditional(%flo,%node)									$$$flo(%flo)(%node,4)
#define FLONODEgenerator(%flo,%node)									$$$flo(%flo)(%node,5)
#define FLONODEparent(%flo,%node)										$$$flo(%flo)(%node,6)
	#; This node is only used in the 0 node to generate the names of lvars which are bsv_$increment(FLONODElvarcounter)
#define FLONODElvarcounter(%flo,%node)									$$$flo(%flo)(%node,7)
 
	// Substructures
#define FLONODEcsrcode(%flo,%node)										$$$flo(%flo)(%node,"b")
#define FLONODEchildren(%flo,%node)										$$$flo(%flo)(%node,"d")
#define FLONODEcode(%flo,%node)											$$$flo(%flo)(%node,"c")
#define FLONODEcontext(%flo,%node)										$$$flo(%flo)(%node,"s")
#define FLONODEgeneratorparameter(%flo,%node)							$$$flo(%flo)(%node,"p")
#define FLOTAB(%flo,%node)												$$$flo(%flo)(%node,"t")

	#; This is a synonym for context
#define FLONODEsymspace(%flo,%node)										$$$flo(%flo)(%node,"s")
 
#define FLONODECSRCODE(%flo,%node,%line)								$$$flo(%flo)(%node,"b",%line)
 
#define FLONODECODE(%flo,%node,%line)									$$$flo(%flo)(%node,"c",%line)

/// TODO: This might not be useful, consider this temporary
#define FLONODECODEdependson(%flo,%node,%line)							$$$flo(%flo)(%node,"cd",%line,"d")
#define FLONODECODEDEPENDSON(%flo,%node,%line,%pred)					$$$flo(%flo)(%node,"cd",%line,"d",%pred)

#define FLONODECHILD(%flo,%node,%child)									$$$flo(%flo)(%node,"d",%child)
 
#define FLONODEGENERATORPARAMETER(%flo,%node,%parameter)				$$$flo(%flo)(%node,"p",%parameter)

#define FLONODECONTEXT(%flo,%node,%context)								$$$flo(%flo)(%node,"s",%context)
#define FLONODESYMSPACE(%flo,%node,%context)							$$$flo(%flo)(%node,"s",%context)
 
#define FLONODESYMBOL(%flo,%node,%context,%symbol)						$$$flo(%flo)(%node,"s",%context,%symbol)
	#; SYMBOLdatatype is the declared type of the symbol as defined in the source language
#define FLONODESYMBOLdatatype(%flo,%node,%context,%symbol)				$$$flo(%flo)(%node,"s",%context,%symbol,1)
	#; The floNODESYMBOLelementxxx macros apply only to cl and ca serial types. The value is the method call for
	#; the various conversions. For example, ..MyCollectionLogicalToStorage. To be used, it must be combined with
	#; the element value to complete the expression. For example, ..MyCollectionLogicalToStorage($list(i%MyCollection,iPtr))
	#; floNODESYMBOLelementl2s is an expression to be applied to the element value to convert from logical to storage
	#; floNODESYMBOLelementl2s is an expression to be applied to the element value to convert from storage to logical
#define FLONODESYMBOLelementl2s(%flo,%node,%context,%symbol)			$$$flo(%flo)(%node,"s",%context,%symbol,2)
#define FLONODESYMBOLelements2l(%flo,%node,%context,%symbol)			$$$flo(%flo)(%node,"s",%context,%symbol,3)
	// Expression is a synonym for the base symbol node
#define FLONODESYMBOLexpression(%flo,%node,%context,%symbol)			$$$flo(%flo)(%node,"s",%context,%symbol)

	// Expression type is:
		// Unknown
#define FLOSYMBOLEXPRESSIONTYPEUNKNOWN			-1
		// Cache Storage Address Reference - often is a global reference but can also be an lvar reference
#define FLOSYMBOLEXPRESSIONTYPEADDRESS			1
		// COS Expression
#define FLOSYMBOLEXPRESSIONTYPECOSEXPRESSION	2
		// Instance Variable
#define FLOSYMBOLEXPRESSIONTYPEIVAR				3
		// Iterator - these symbol expressions are almost always defined
		// in a loop and cannot be promoted outside of the loop
#define FLOSYMBOLEXPRESSIONTYPEITERATOR			4
		// Literal
#define FLOSYMBOLEXPRESSIONTYPELITERAL			5
		// Local Variable
#define FLOSYMBOLEXPRESSIONTYPELVAR				6
		// Expression that will swizzle an object value into an OREF - these types should almost always be bound
#define FLOSYMBOLEXPRESSIONTYPESWIZZLE			7
		// Replaced expression - CSR replaced this expression with an lvar and bound the expression's value to the lvar in the FLONODEbindcode
#define FLOSYMBOLEXPRESSIONTYPECSR				8


#define FLONODESYMBOLexpressiontype(%flo,%node,%context,%symbol)		$$$flo(%flo)(%node,"s",%context,%symbol,4)

	#; FLONODESYMBOLoidtype is used only for serializing collections. It is a temporary fix to a bigger
	#; problem that should be resolved by using iterators to serialize collections as needed outside of using
	#; the collection proxy property. We should just recognize when we need to serialize a collection for storage purposes
	#; and do it.
#define FLONODESYMBOLoidtype(%flo,%node,%context,%symbol)				$$$flo(%flo)(%node,"s",%context,%symbol,5)
#define FLONODESYMBOLelementoidtype(%flo,%node,%context,%symbol)		$$$flo(%flo)(%node,"s",%context,%symbol,9)

#define FLONODESYMBOLresolveoperator(%flo,%node,%context,%symbol)		$$$flo(%flo)(%node,"s",%context,%symbol,6)
	#; SERIALDELIMITER is the delimiter used when serializing a value. If null then $list is used
#define FLONODESYMBOLserialdelimiter(%flo,%node,%context,%symbol)		$$$flo(%flo)(%node,"s",%context,%symbol,7)
	#; When serializing array collections this is the delimiter between the element value and the element key
#define FLONODESYMBOLserialkeydelimiter(%flo,%node,%context,%symbol)	$$$flo(%flo)(%node,"s",%context,%symbol,8)

/// DEPENDSON is only defined during the analyze phase
#define FLONODESYMBOLdependson(%flo,%node,%context,%symbol)				$$$flo(%flo)(%node,"s",%context,%symbol,"d")
#define FLONODESYMBOLDEPENDSON(%flo,%node,%context,%symbol,%pred)		$$$flo(%flo)(%node,"s",%context,%symbol,"d",%pred)

	#; The only type of symbol that can have multiple lines of definition and produce multiple lines of resolved expression
	#; is a serialization. Therefore, the definition is assumed to be either the unresolved expression (FLONODESYMBOL)
	#; or, it is the expression generated from the serialization constructor - i.e. $listbuild(<slot1>,<slot2>,...)
	#; If that constructor generates multiple lines of code then the symbol is bound, the resolved expression becomes the lvar and the
	#; code goes into FLONODESYMBOLBINDCODE
#define FLONODESYMBOLserial(%flo,%node,%context,%symbol)				$$$flo(%flo)(%node,"s",%context,%symbol,"l")
#define FLONODESYMBOLSERIAL(%flo,%node,%context,%symbol,%slot)			$$$flo(%flo)(%node,"s",%context,%symbol,"l",%slot)

#; define FLONODESYMSPACEbindery(%flo,%node,%ss)				$$$flo(%flo),%node,"s",%ss,"b")
#; define FLONODESYMSPACEsymbol(%flo,%node,%ss)				$$$flo(%flo),%node,"s",%ss,"s")
 
	#; this reference is set to the name of the symbol that is bound
#; define FLONODESYMSPACEBINDERY(%flo,%node,%ss,%bindorder)	$$$flo(%flo),%node,"s",%ss,"b",%bindorder)
	#; Symbols may have a multi-line definition but the resolved symbol must always be an expression. When a multi-line definition
	#; requires multiple lines of code to evaluate the symbol value then the symbol value must be bound to a local variable.
	#; The code to bind the symbol value to the variable is stored in FLONODESYMBOLbindcode, FLONODESYMBOLbound indicates that the symbol
	#; has been bound to this FLONODE. If it is set and no binding defined then it means that the symbol is never to be bound.
	#; 
	#; It will probably be necessary to establish some bind predecessor array so that we can dequeue the bindings in the order necessary.
	#; I believe that order is the order in which the symbol is 'visited' so dequeuing in visit order (topological) is probably acceptable.
	#; Other symbol definitions may have some performance reason for binding. Some algorithm for determining which symbols will be bound
	#; will be implemented later. Still other symbols are always 'bound', at least in the old model. I'm thinking that such requirements will
	#; be handled by code generation instead.
 
	#; IT may also be desirable to construct a child node of the %node that will not ever have any symbols but will have code generated in visit order
	#; and will contain all of the symbol binding code.
#; define FLONODESYMBOL(%flo,%node,%ss,%sym)					$$$flo(%flo),%node,"s",%ss,"s",%sym)
	#; This is a clue to the bindery that this symbol is (=1) always to be bound.
#; define FLONODESYMBOLbind(%flo,%node,%ss,%sym)				$$$flo(%flo),%node,"s",%ss,"s",%sym,3)
#; define FLONODESYMBOLbound(%flo,%node,%ss,%sym)				$$$flo(%flo),%node,"s",%ss,"s",%sym,1)
	#; iterator - this is the name of the iterator on which this symbol is dependent. That means that unless the
	#; 	iterator symbol is present that this symbol cannot be resolved in this context.
#; define FLONODESYMBOLiterator(%flo,%node,%ss,%sym)			$$$flo(%flo),%node,"s",%ss,"s",%sym,2)
	#; FLONODESYMBOLoidtype is used only for serializing collections. It is a temporary fix to a bigger
	#; problem that should be resolved by using iterators to serialize collections as needed outside of using
	#; the collection proxy property. We should just recognize when we need to serialize a collection for storage purposes
	#; and do it.
#; define FLONODESYMBOLoidtype(%flo,%node,%ss,%sym)			$$$flo(%flo),%node,"s",%ss,"s",%sym,4)
	#;



/// A FLOTAB (FLOgraph Symbol TABLE) is generally constructed only on the head node of a FLOgraph (a FLO structure having the capability of multiple FLOgraphs).
#define FLOTABCONTEXT(%flo,%headnode,%context)									$$$flo(%flo)(%headnode,"t",%context)
#define FLOTABSYMBOL(%flo,%headnode,%context,%symbol)							$$$flo(%flo)(%headnode,"t",%context,%symbol)

#define FLOTABSYMBOLreferencecount(%flo,%headnode,%context,%symbol)				$$$flo(%flo)(%headnode,"t",%context,%symbol,"r")

#define FLOTABSYMBOLNODE(%flo,%headnode,%context,%symbol,%node)					$$$flo(%flo)(%headnode,"t",%context,%symbol,"r",%node)
#define FLOTABSYMBOLNODEreferencecount(%flo,%headnode,%context,%symbol,%node)	$$$flo(%flo)(%headnode,"t",%context,%symbol,"r",%node)

#define FLOTABSYMBOLdefinition(%flo,%headnode,%context,%symbol)					$$$flo(%flo)(%headnode,"t",%context,%symbol,"d")
#define FLOTABSYMBOLDEF(%flo,%headnode,%context,%symbol,%node)					$$$flo(%flo)(%headnode,"t",%context,%symbol,"d",%node)
#define FLOTABSYMBOLDEFcode(%flo,%headnode,%context,%symbol,%node)				$$$flo(%flo)(%headnode,"t",%context,%symbol,"d",%node,"c")
#define FLOTABSYMBOLDEFexpression(%flo,%headnode,%context,%symbol,%node)		$$$flo(%flo)(%headnode,"t",%context,%symbol,"d",%node,2)
#define FLOTABSYMBOLDEFreferencecount(%flo,%headnode,%context,%symbol,%node)	$$$flo(%flo)(%headnode,"t",%context,%symbol,"d",%node,3)

#define FLOTABSYMBOLDEFCODE(%flo,%headnode,%context,%symbol,%node,%line)		$$$flo(%flo)(%headnode,"t",%context,%symbol,"d",%node,"c",%line)



#; The CPT Instance
#define CPT(%tree)													$$$cpt(%tree))
#define CPTheadnode(%tree)											1
#define CPTnode(%tree)												$$$cpt(%tree)
 
#define CPTNODE(%tree,%node)										$$$CPTnode(%tree),%node)
#define CPTNODEannotation(%tree,%node,%ant)							$$$CPTnode(%tree),%node,"a",%ant)

/// count of annotations for the given node (some may be absent)
/// %tree            - tree index
/// %node            - node index
#define CPTNODEANNCOUNT(%tree,%node) ^||%isc.cpt(%tree,%node,"a")

/// annotation for the given tree, node, annotation indices
/// %tree            - tree index
/// %node            - node index
/// %ann             - annotation index
/// - guaranteed to be a glvn node
#define CPTNODEANN(%tree,%node,%ann) ^||%isc.cpt(%tree,%node,"a",%ann)



#define CPTNODEcontext(%tree,%node)									$$$CPTnode(%tree),%node,"x")
#define CPTNODEchild(%tree,%node)									$$$CPTnode(%tree),%node,"c")
#define CPTNODEflo(%tree,%node)										$$$CPTnode(%tree),%node,"f")
#define CPTNODEsourcelocation(%tree,%node)							$$$CPTnode(%tree),%node,"m")
	#; This retains the index of the last child stacked
#define CPTNODElastchild(%tree,%node)								$$$CPTnode(%tree),%node,"l")
#define CPTNODEparent(%tree,%node)									$list($$$CPTNODE(%tree,%node),2)
#define CPTNODEparentindex(%tree,%node)								$list($$$CPTNODE(%tree,%node),3)
#define CPTNODEtype(%tree,%node)									$list($$$CPTnode(%tree),%node),1)
	// CPTNODEsubtreetype is a generic value that can be set during parse tree analysis
	// and used by the code generator for any purpose as defined by the language specific code generators.
	// For example, CPTNODEsubtreetype = 1 for Informix indicates that this subtree includes a RESUME attribute
	// on a RETURN node type.
#define CPTNODEsubtreetype(%tree,%node)								$$$CPTnode(%tree),%node,"s")

#define CPTNODECHILD(%tree,%node,%child)							$$$CPTnode(%tree),%node,"c",%child)
#define CPTNODEFLO(%tree,%node,%flonode)							$$$CPTnode(%tree),%node,"f",%flonode)
 
#; The Operands
#define OP															$$$op)
#define OPerand														$$$op
 
#define OPERAND(%operand)											$$$OPerand,%operand)
#define OPERANDannotation(%operand,%ant)							$$$OPerand,%operand,%ant)
#define OPERANDANNOTATIONline(%operand,%ant,%line)					$$$OPerand,%operand,%ant,%line)
#; OPERANDtype is QUERY, LIST, etc.
#define OPERANDtype(%operand,%ant)									$$$OPerand,%operand,%ant)
 
#define createOperand												$i($$$OP)
#define dropAllOperands												kill $$$OP
#define dropOperand(%operand)										kill $$$OPERAND(%operand)
#define appendOpAnnotation(%operand,%annotation,%value)				set $$$OPERANDannotation(%operand,%annotation)=$Get($$$OPERANDannotation(%operand,%annotation))_%value
#define setOpAnnotation(%operand,%annotation,%value)				set $$$OPERANDannotation(%operand,%annotation)=%value
#define getOpAnnotation(%operand,%annotation,%value)				set %value=$$$OPERANDannotation(%operand,%annotation)
	#; isDefinedOpAnnotation uses $Data to see if the annotation is defined. %value is returned as the annotation value if defined.
#define isDefinedOpAnnotation(%operand,%annotation,%value)			$Data($$$OPERANDannotation(%operand,%annotation),%value)
#define deleteOpAnnotation(%operand,%annotation)					kill $$$OPERANDannotation(%operand,%annotation)
 
#define appendOpArray(%operand,%annotation,%line,%value)			for %line = 1:1:%value { set $$$OPERANDANNOTATIONline(%operand,%annotation,$i($$$OPERANDannotation(%operand,%annotation)))=%value(%line) }
#define appendOpLine(%operand,%annotation,%value)					set $$$OPERANDANNOTATIONline(%operand,%annotation,$i($$$OPERANDannotation(%operand,%annotation)))=%value
#define appendOpOperand(%operand,%annotation,%value,%type,%priority,%token) set $$$OPERANDANNOTATIONline(%operand,%annotation,$i($$$OPERANDannotation(%operand,%annotation)))=$lb(%value,%type,%priority,%token)
#define setOpArray(%operand,%annotation,%value)						merge $$$OPERANDannotation(%operand,%annotation)=%value
 
#define getOpArray(%operand,%annotation,%value)						merge %value=$$$OPERANDannotation(%operand,%annotation)
 
#;---------------------------------------- 
#; Parse Tree methods
#;---------------------------------------- 
#define dropNode(%tree,%node)									k $$$CPTNODE(%tree,%node)
#define dropChild(%tree,%parent,%child)							k $$$CPTNODECHILD(%tree,%parent,%child)

#; Convenience items
#;	SymbolReference - this macro formats the argument as a FLO symbol reference in the given context
#define SymbolReference(%arg,%context)		$Char(0) _ %arg _ "*" _ %context _ $Char(0)

/// Flo Graph code generation and symbol macros
#define FloSymbolReferenceStart							$Char(0)
#define FloSymbolReferenceEnd							$Char(0)
#define FloSymbolContextDelimiter						$Char(1)
#define FloSymbolReference(%arg,%context)				$$$FloSymbolReferenceStart_%arg_$Select(%context'="":$$$FloSymbolContextDelimiter_%context,1:"")_$$$FloSymbolReferenceEnd
