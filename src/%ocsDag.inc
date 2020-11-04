ROUTINE %ocsDag [Type=INC]
#; Functions to process DAG's - Directed Acyclic Graphs
NewGraph(prefix)	public {       
	Set graph=$Increment($$$tDAGc)
	Kill $$$DAG($$$tDAG,graph)
	Set $$$DAGbindprefix($$$tDAG,graph)=$Select($Get(prefix)'="":prefix,1:"t"_graph)
	QUIT graph
}
BuildGraph(dag)	public {
	        #; Parse each expression in a table and construct a DAG
	        #; Graph nodes are defined as:
	        #;   dag(symbol)                 - expression
	        #;   dag(symbol,2)               - # of incoming edges
	        #;   dag(symbol,3,<predecessor>) - incoming edge from <predecessor>
	        #;   dag(symbol,4)               - # of outgoing edges
	        #;   dag(symbol,4,<successor>)   - outgoing edge to <successor>
	Set sc=$$$OK, sym = $Order($$$DAGNODE($$$tDAG,dag,""))
	While sym '= "" {
	    If '($Data($$$DAGNODE($$$tDAG,dag,sym))#2) Set sc=$$$ERROR($$$StorageSymbolUndefined,sym) Quit
	    Set expr=$$$DAGNODE($$$tDAG,dag,sym),dependency=0,i=0
	    If expr[$$$SymbolReferenceStart {
	        Set sc=$$ExtractDependency(expr,.dependency) Quit:$$$ISERR(sc)
	        Set pred="" For  Set pred=$Order(dependency(pred)) Quit:pred=""  Set i=i+1,$$$DAGNODESUCC($$$tDAG,dag,pred,sym)="",$$$DAGNODEsuccessor($$$tDAG,dag,pred)=$Get($$$DAGNODEsuccessor($$$tDAG,dag,pred))+1,$$$DAGNODEPRED($$$tDAG,dag,sym,i)=pred
	    }
	    Set $$$DAGNODEpredecessor($$$tDAG,dag,sym)=i,$$$DAGNODEorder($$$tDAG,dag,sym)=i
	    Kill dependency
	    Set sym = $Order($$$DAGNODE($$$tDAG,dag,sym))
	}
	QUIT sc
}

ExtractSubgraph(tDag,symbols,sDag)	public {
	        #; Extract a graph that contains all symbols in the symbols parameter from a graph
	        #; The resulting subgraph does not need to be compiled!
	
	        #; PARAMETERS:
	        #;   tDag    - the graph to extract from
	        #;   symbols - a $list of symbols to be extracted
	        #;   sDag    - the subgraph to be returned
	Set sc=$$$OK,stack=0
	For i=1:1:$ListLength(symbols) { Set stack($increment(stack))=$ListGet(symbols,i) }
	While stack '= 0 {
	    Set symbol=stack(stack),stack=stack-1
	        #; Extract only symbols not already defined...
	    If '($Data($$$DAGNODE($$$tDAG,sDag,symbol))#2) {
	            #; I'm not sure but this check may be redundant. I believe that a BuildGraph must be done before Extract can be run
	        If '$Data($$$DAGNODE($$$tDAG,tDag,symbol)) Set sc=$$$ERR($$$StorageInvalidStructure) Quit
	        Set $$$DAGNODE($$$tDAG,sDag,symbol)=$$$DAGNODE($$$tDAG,tDag,symbol)
	            #; merge/stack predecessors
	        Set $$$DAGNODEorder($$$tDAG,sDag,symbol)=$$$DAGNODEorder($$$tDAG,tDag,symbol),$$$DAGNODEpredecessor($$$tDAG,sDag,symbol)=$$$DAGNODEpredecessor($$$tDAG,tDag,symbol),$$$DAGNODEneverbind($$$tDAG,sDag,symbol)=$Get($$$DAGNODEneverbind($$$tDAG,tDag,symbol)),$$$DAGNODEisiterator($$$tDAG,sDag,symbol)=$Get($$$DAGNODEisiterator($$$tDAG,tDag,symbol))
	        Set:$Data($$$DAGITERATOR($$$tDAG,tDag,symbol)) $$$DAGITERATOR($$$tDAG,sDag,symbol)=$$$DAGITERATOR($$$tDAG,tDag,symbol)
	        Set:$Get($$$DAGNODEbindlvar($$$tDAG,tDag,symbol))'="" $$$DAGNODEbindlvar($$$tDAG,sDag,symbol)=$$$DAGNODEbindlvar($$$tDAG,tDag,symbol)
	        Set:$Get($$$DAGNODEbound($$$tDAG,tDag,symbol)) $$$DAGNODEbound($$$tDAG,sDag,symbol)=$$$DAGNODEbound($$$tDAG,tDag,symbol)
	        For i=1:1:$$$DAGNODEpredecessor($$$tDAG,tDag,symbol) Set pred=$$$DAGNODEPRED($$$tDAG,tDag,symbol,i) Set stack($increment(stack))=pred,$$$DAGNODESUCC($$$tDAG,sDag,pred,symbol)="",$$$DAGNODEsuccessor($$$tDAG,sDag,pred)=$Get($$$DAGNODEsuccessor($$$tDAG,sDag,pred))+1,$$$DAGNODEPRED($$$tDAG,sDag,symbol,i)=$$$DAGNODEPRED($$$tDAG,tDag,symbol,i)
	    }
	}
	QUIT sc
}

BuildSymbolTable(pDag,sTable,symbols,force)	public {
	        #; Traverse a DAG in topological sequence, detect cycles
	        #; PARAMETERS:
	        #; pDag    - graph containing symbol definitions
	        #; sTable  - compiled symbol table. This table also contains lvar bindings
	        #;           for complex expressions with multiple outgoing edges (descendants)
	        #; symbols - list of symbols to sort in visit sequence. This parameter is
	        #;           destroyed and returned in a different form.
	        #; force   - If 1, bind complex expressions even if reference count is not
	        #;           greater than 1, if -1, don't bind symbols ever!
	        #; LVARS:
	        #;   i     - loop counter
	        #;   node  - holds the pointer to the current node in the graph
	        #;   order - an array of symbols to be sorted in visit sequence
	        #;   ptr   - pointer to the top of the stack
	        #;   stack - stack of nodes without incoming edges
	        #;   tDag  - contains the edge definitions and node edge counts (incoming and outgoing)
	Set $$$DAGbindery($$$tDAG,sTable)=$Get($$$DAGbindery($$$tDAG,sTable))
	QUIT:'$Data($$$DAGnode($$$tDAG,pDag)) $$$OK
	Set force=$Get(force),tDag=$$NewGraph()
	Merge $$$DAG($$$tDAG,tDag)=$$$DAG($$$tDAG,pDag)
	        #; Check the binding lvar prefix. If not defined, set it to 't'
	If $Get($$$DAGbindprefix($$$tDAG,sTable))="" Set $$$DAGbindprefix($$$tDAG,sTable)="t"
	        #; Initialize the stack
	Set node="",stack=0 For  Set node=$Order($$$DAGNODE($$$tDAG,tDag,node)) Quit:node=""  Set:+$$$DAGNODEorder($$$tDAG,tDag,node)=0 stack($increment(stack))=node,$$$DAGNODE($$$tDAG,sTable,node)=$$$DAGNODE($$$tDAG,tDag,node)
	QUIT:stack=0 $$$ERR($$$StorageInvalidDependency)
	        #; Extract the symbols to order...
	If $Get(symbols)'="" For i=1:1:$ListLength(symbols) Set order($ListGet(symbols,i))=""
	Set symbols=0
	        #; Pop nodes off the stack and visit them
	For  Set ptr=stack,stack=stack-1 Set:$Data(order(stack(ptr))) symbols($increment(symbols))=stack(ptr) Set sc=$$visit(tDag,.stack,stack(ptr),sTable,.symbols,force) Quit:(stack=0)!($$$ISERR(sc))
	QUIT:$$$ISERR(sc) sc
	QUIT $Select('$Data($$$DAGnode($$$tDAG,tDag)):$$$OK,1:$$$ERR($$$StorageInvalidDependency))
}
visit(tDag,stack,node,sTable,symbols,force)	private {
	        #; build the expression from the expression of each of the predecessors
	Set expr=$$$DAGNODE($$$tDAG,tDag,node)
	Set lsIterators = $Get($$$DAGNODEiterators($$$tDAG,tDag,node))
	Set neverbind = ''$Get($$$DAGNODEneverbind($$$tDAG,tDag,node))
	        #; If the force flag is less than zero, never bind!!!
	If '(expr?1(.1"%"1a.an,.n,1"""".e1"""",1"i%".1"%".an)) {
	        #; set the bound flag to tDag(node,6). The result, if it is TRUE, is to never bind the symbol!
	    Set bound=''$Get($$$DAGNODEbound($$$tDAG,tDag,node)) ! neverbind
	    Set sc=$$Parse(sTable,expr,.result) Quit:$$$ISERR(sc) sc
	        #; If the expression is complex then bind it to a local variable
	        #; and notify successors that this symbol is bound!
	        #; ...BUT - never bind anything if the force flag is less than zero!!!
	
	        #; tDag(node,5) is the forced binding to a specific lvar
	    If force'<0,$Get($$$DAGNODEbindlvar($$$tDAG,tDag,node))'="" Set lvar=$$$DAGNODEbindlvar($$$tDAG,tDag,node) Do bindSymbol(sTable,node,result,.lvar,.symbols,lsIterators) Set result=lvar,bound=1
	        #; If not already bound, and complex enough, and referred to often enough (or we don't care) then bind it!
	    If force'<0,'bound,'(result?1(.1"%"1a.an,.n,1"""".e1"""",1"i%".1"%".an)),(($Get($$$DAGNODEsuccessor($$$tDAG,tDag,node))>1)!(force=1)) Do bindSymbol(sTable,node,result,.lvar,.symbols,lsIterators) Set result=lvar
	    Set $$$DAGNODE($$$tDAG,sTable,node)=result
	}
	Else { Set $$$DAGNODE($$$tDAG,sTable,node)=$$$DAGNODE($$$tDAG,tDag,node) }
	    #; If this node is an iterator node, then add it to the list of iterators
	If $Get($$$DAGNODEisiterator($$$tDAG,tDag,node)) Set lsIterators = lsIterators _ $ListBuild(node)
	Set:$Data($$$DAGITERATOR($$$tDAG,tDag,node)) $$$DAGITERATOR($$$tDAG,sTable,node)=$$$DAGITERATOR($$$tDAG,tDag,node)
	Set iterators = $ListLength(lsIterators)
	        #; Process each successor
	Set ptr = $Order($$$DAGNODESUCC($$$tDAG,tDag,node,""))
	While ptr '= "" {
	        #; Decrement the degree of each successor
	    Set $$$DAGNODEorder($$$tDAG,tDag,ptr)=$$$DAGNODEorder($$$tDAG,tDag,ptr)-1
	        #; If a predecessor cannot be bound then the successor can't either...
	 #;   Set:neverbind $$$DAGNODEneverbind($$$tDAG,tDag,ptr)=1
	    Set:iterators $$$DAGNODEiterators($$$tDAG,tDag,ptr) = lsIterators
	        #; Push node onto stack - all predecessors have been visited
	    Set:$$$DAGNODEorder($$$tDAG,tDag,ptr)=0 stack($increment(stack))=ptr
	    Set ptr = $Order($$$DAGNODESUCC($$$tDAG,tDag,node,ptr))
	}
	Kill $$$DAGNODE($$$tDAG,tDag,node)
	QUIT $$$OK
}
	
AllocateLVAR(sTable)	public {
	Set bindptr=$Increment($$$DAGbindery($$$tDAG,sTable))
	Quit $$$DAGbindprefix($$$tDAG,sTable)_bindptr
}

bindSymbol(sTable,symbol,expression,lvar,symbols,lsIterators)	private {
	s bindptr=$i($$$DAGbindery($$$tDAG,sTable))
	s:$g(lvar)="" lvar=$$$DAGbindprefix($$$tDAG,sTable)_bindptr
	s $$$DAGBIND($$$tDAG,sTable,bindptr)=lvar,$$$DAGBINDexpression($$$tDAG,sTable,bindptr)=lvar_"="_expression
	s $$$DAGNODEboundby($$$tDAG,sTable,symbol)=lvar,$$$DAGBINDtoken($$$tDAG,sTable,bindptr)=symbol
	Set:$ListLength(lsIterators) $$$DAGBINDiterators($$$tDAG,sTable,bindptr) = $$ListToOADS(lsIterators)
	        #; Add the binding reference to the tracked symbols
	        #; This allows an external semantic rule to dequeue the bindings in the proper
	        #; sequence...
	s symbols(symbols,bindptr)=""
	QUIT
}

ListToOADS(list)	{
	    #; Convert a $List to an ordered ascii-delimited string
	Set ads = ""
	For ptr = 1:1:$ListLength(list) { Set sa($List(list,ptr)) = "" }
	Set element = $Order(sa(""))
	While element '= "" { Set ads = ads _ element _ "~", element = $Order(sa(element)) }
	Quit ads
}

ExtractDependency(expr,dependency) [] public {
	try {
		set tokenStart = $find(expr,$$$SymbolReferenceStart,1)
		if 'tokenStart { set resolved = expr}
		else {
			set tokenEnd = 1, resolved = ""
			while tokenStart {
				set tokenEnd = $find(expr,$$$SymbolReferenceEnd,tokenStart)
					// This condition should never be true as it indicates unbalanced $c(0) delimiters. - the old version in %ocsDag would return this as an error
				if 'tokenEnd { set tokenEnd = $Length(expr) }
				set symbolRef = $Extract(expr,tokenStart,tokenEnd-2)
					// Process a $$$SymbolContextDelimiter in the symbol - the $$$SymbolContextDelimiter separates the symbol name from the symbol Context.
					// We aren't supporting cross-table symbol references
	        #; Extract all symbol references ("{}") from the expression and
	        #; returned referenced symbols in the dependency array.
				set dependency(symbolRef) = $Get(dependency(symbolRef))+1
				set tokenStart = $find(expr,$Char(0),tokenEnd)
			}
		}
		set tSC = $$$OK
	}
	catch {
		throw
	}
	quit tSC
}
 
#; Note that $$$SymbolReferenceStart and $$$SymbolReferenceEnd are both $c(0) so we can use this here
Parse(sTable,expr,result)	public {
	Set result="",insub=0,sc=$$$OK,ptr=1
	For {
		Set oldptr=ptr,ptr=$find(expr,$$$SymbolReferenceStart,oldptr) Quit:ptr=0
		If 'insub {
			Set insub=1,result=result_$extract(expr,oldptr,ptr-2)
		} Else {
			Set insub=0,subsym=$g($$$DAGNODE($$$tDAG,sTable,$extract(expr,oldptr,ptr-2)))
			If subsym="" Set sc=$$$ERROR($$$StorageUndefinedSymbol,$extract(expr,oldptr,ptr-2)) Quit
			Set result=result_subsym
		}
	}
	Set result=result_$extract(expr,oldptr,*)
	If insub,$$$ISOK(sc) Set sc=$$$ERROR($$$StorageInvalidSymbol,expr)
	QUIT sc
}

DequeueBindings(stable,code,lvars,saIterators)	public {
	    #; Dequeue the symbol bindings located in 'stable' to an array - 'code'.
	    #; Compact the bindings so few lines of code are generated. This subroutine can be called several times and
	    #;  the results will accumulate in code and lvars.
	Set code=$Get(code),lvars=$Get(lvars)
	QUIT:'$Get($$$DAGbindery($$$tDAG,stable))
	Set line="", adsIterators = ""
	    #; Dequeue bindings not dependent on iterators if no iterators present in the lsIterators parm
	If $Data(saIterators) > 2 {
	        #; Convert the subscripted array into an ASCII delimited string (ordered)
	    Set iterator = $Order(saIterators(""))
	    While iterator '= "" { Set adsIterators = adsIterators _ iterator _ "~", iterator = $Order(saIterators(iterator)) }
	}
	For i=1:1:$$$DAGbindery($$$tDAG,stable) {
	        #; Only dequeue bindings not dependent upon an iterator
	    If $Get($$$DAGBINDiterators($$$tDAG,stable,i)) = adsIterators {
	        Set lvars=lvars_","_$$$DAGBIND($$$tDAG,stable,i),line=line_","_$$$DAGBINDexpression($$$tDAG,stable,i)
	        If $Length(line)>1024 Set code($increment(code))="s "_$Extract(line,2,*),line=""
	    }
	}
	If line'="" Set code($increment(code))="s "_$Extract(line,2,*)
	QUIT
}

AddGraphNode(dag,node,expr,bindto,neverbind,iteratortype)	public {
	Set $$$DAGNODE($$$tDAG,dag,node)=expr
	If $Get(bindto)'="" Set $$$DAGNODEbindlvar($$$tDAG,dag,node)=bindto QUIT
	Set:$Get(neverbind) $$$DAGNODEbound($$$tDAG,dag,node)=1,$$$DAGNODEneverbind($$$tDAG,dag,node)=1
	Set:$Get(iteratortype)'="" $$$DAGNODEisiterator($$$tDAG,dag,node) = 1, $$$DAGITERATOR($$$tDAG,dag,node) = iteratortype
	QUIT
}