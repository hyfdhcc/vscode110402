ROUTINE %ocsFlowGraph [Type=INC]
#; FLOW GRAPH methods
InitializeFlowGraph(&fGraph,formal,procedure)	public {
	Set fGraph=0,fGraph("h")=0
	Set:$g(procedure) fGraph("p")=1
	If $g(formal)'="" {
		For ptr=1:1:$l(formal,",") {
			Set lvar=$p(formal,",",ptr)
			Set:lvar'="" fGraph("f",lvar)=""
		}
	}
}
NewCodeBlock(&fGraph,parent,conditional,label)	public {
	Set fGraph=fGraph+1
	If $Get(parent) {
	    #; Acknowledge parent
		Set fGraph(fGraph)=parent
		#; Adopt this child
		Set fGraph(parent,"d",$increment(fGraph(parent,"d")))=fGraph
		#; Set up the tab sequence
		Set fGraph(fGraph,"t")=fGraph(parent,"t")
	} Else {
		#; This must be the head node - set it up. It should always be node #1!!!
		Set fGraph("h")=fGraph,fGraph(fGraph)="",fGraph(fGraph,"t")=$c(9)
	}
	#; If this is a conditional block then add the dot to the tab
	If $Get(conditional) {
		Set fGraph(fGraph,"t")=fGraph(fGraph,"t")_$s(conditional=2:$c(9),1:". ")
	} ElseIf $Get(label)'="" {
		Set fGraph(fGraph,"l") = label
	}
	#; Initialize the code counter
	Set fGraph(fGraph,"c")=0
	#; Initialize the descendent counter
	Set fGraph(fGraph,"d")=0
	QUIT fGraph
}
QueueCodeLine(fGraph,node,line)	public {
	Set fGraph(node,"c",$increment(fGraph(node,"c")))=line
}
QueueCodeArray(fGraph,node,code)	public {
	For i=1:1:$g(code) {
		Set fGraph(node,"c",$increment(fGraph(node,"c")))=code(i)
	}
}
DefineLocalVariable(fGraph,node,lvar)	public {
	Set lvar=$p(lvar,"(")
	If lvar'="",'$d(fGraph("f",lvar)) {
		Set fGraph(node,"n",lvar)=""
	}
}
DefineLocalVariables(fGraph,node,lvars)	public {
	For ptr=1:1:$l(lvars,",") {
		Set lvar=$p($p(lvars,",",ptr),"(")
		If lvar'="",'$d(fGraph("f",lvar)) {
			Set fGraph(node,"n",lvar)=""
		}
	}
}
AppendCodeBlock(&fromGraph,fromBlock,&toGraph,toBlock)	public {
	#; Copy the lines of code from one code block and place them
	#; at the end of another. Descendent blocks are ignored
	Merge toGraph(toBlock,"n")=fromGraph(fromBlock,"n")
	For i=1:1:fromGraph(fromBlock,"c") {
		Set toGraph(toBlock,"c",$increment(toGraph(toBlock,"c")))=fromGraph(fromBlock,"c",i)
	}
}	      
CopyCodeBlock(&fromGraph,fromBlock,&toGraph,toBlock)	public {
	Merge toGraph(toBlock,"c")=fromGraph(fromBlock,"c")
	Merge toGraph(toBlock,"n")=fromGraph(fromBlock,"n")
}
DequeueFlowGraph(fGraph,code)	public {
	Set code=0,node=fGraph("h")
	#; This shouldn't ever happen, but check to see if there is a head node
	If node {
		Do DequeueBlock(.fGraph,node,.code)
	}
}	      
DequeueBlock(fGraph,node,code) private {
	Do DequeueNewList(.fGraph,node,.code)
	Set tab=fGraph(node,"t"), label = $Get(fGraph(node,"l"))
	If (fGraph(node,"c")) || ( label '= "") {
		Set code($increment(code))=label_tab_fGraph(node,"c",1)
		For i=2:1:fGraph(node,"c") {
			Set code($increment(code))=tab_fGraph(node,"c",i)
		}
	}
	For i=1:1:fGraph(node,"d") {
		Do DequeueBlock(.fGraph,fGraph(node,"d",i),.code)
	}
}	      
DequeueNewList(fGraph,node,code) private {
	Quit:'$d(fGraph(node,"n"))
	Set procflg=+$g(fGraph("p"))
	Set lvar="",new=""
	Do {
		Set lvar=$o(fGraph(node,"n",lvar))
		Quit:lvar=""
		If procflg,$e(lvar)'="%" {} Else { Set new=new_","_lvar }
	} While (1)
	Set:new'="" code($increment(code))=fGraph(node,"t")_"New "_$e(new,2,*)
}