ROUTINE %occCPTcoverage [Type=INC]

#; coverage temporary, persistent storage
#define CVTEMP ^||%isc.cpt.cov
#define CVPERS ^%isc.cpt.cov


#; - raw log -

/// raw log base
#define CVLOGBASE ^||%isc.cpt.log

/// raw log record
#define CVLOG(%index) ^||%isc.cpt.log(%index)

/// raw log record count
#define CVLOGCOUNT (+$Order($$$CVLOG(""),-1))

#; - log data -

/// log data - base node
#define CVLNBASE $$$CVTEMP("n")

/// log data - seen node
#define CVLN(%nodetype) $$$CVTEMP("n",%nodetype)

/// log data - discarded node
#define CVLND(%nodetype) $$$CVTEMP("n",%nodetype,"d")

/// log data - annotation
#define CVLNA(%nodetype,%annindex) $$$CVTEMP("n",%nodetype,"a",%annindex)

/// log data - child
#define CVLNC(%nodetype,%childindex) $$$CVTEMP("n",%nodetype,"c",%childindex)


#; - nodes we didn't see at all -

/// unseen - node
#define CVU(%nodename) $$$CVTEMP("u",%nodename)


#; - nodes we saw but which were discarded -

/// discarded - node
#define CVD(%nodename) $$$CVTEMP("d",%nodename)


#; - nodes we saw but without all their annotations/children -

/// partial - unseen node (no data)
#define CVP(%nodename) $$$CVTEMP("p",%nodename)

/// partial - unseen annotation
#define CVPA(%nodename,%annname) $$$CVTEMP("p",%nodename,"a",%annname)

/// partial - unseen child
#define CVPC(%nodename,%childname) $$$CVTEMP("p",%nodename,"c",%childname)


#; general global utilities

/// count the (immediate) siblings of the given global node
#define COUNTSIB(%g,%var) If $Data(%g)||1 {Set countsib="" For %var=0:1 {Set countsib=$Order(^(countsib)) Quit:countsib=""} }

/// list the sibling keys of the given global node to the current device, indenting each line as given
#define LISTKEYS(%indent,%g) If $Data(%g)||1 {Set countsib="" While 1 {Set countsib=$Order(^(countsib)) Quit:countsib=""  Write %indent,countsib,!} }
