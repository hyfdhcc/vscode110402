ROUTINE %occCPTCOSqueue [Type=INC]

initqueue
	Kill queue
	Set queueadd=0 // increment queueadd then set queue(queueadd)
	Set queuerem=1 // remove from queue(queuerem) then increment queuerem
	Quit
	
enqueue(nodename)
	Set queue($I(queueadd))=nodename
	Quit
	
dequeue(nodename)
	If $$emptyqueue {Kill nodename Quit 0}
	Set nodename=queue(queuerem)
	Kill queue(queuerem)
	Set queuerem=queuerem+1
	Quit 1


emptyqueue()
	Quit queuerem>queueadd
	
	