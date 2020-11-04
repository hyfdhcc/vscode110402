ROUTINE %occCPTCOSpushpop [Type=INC]

push(frame)
	Set stack($I(stack))=frame
	Quit
	
pop(frame)
	If 'stack {Kill frame Quit 0}
	Set frame=stack(stack)
	Kill stack(stack)
	Set stack=stack-1
	Quit 1
