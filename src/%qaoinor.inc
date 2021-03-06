ROUTINE %qaoinor [Type=INC]
%qaoinor(prev,array)  ;  QO - Put interesting orders into arrays  V13
#IF 0   ;-------------------------------------------------------------
	; Description:   QO - Put orders in an array
	; Author:        Terry Ragon
	; Date Started:  July 7, 1987
	;
	;  PVA316  (02/04/2015) - Make cost based decision for or->union optimization for multi-table OR condition case 
	;  PVA184  (06/14/2009) - Optimizer support for TOP... ORDER BY in subqueries. 
	;  AK611   (10/06/2004) - Don't include %VR in interesting orders
	;  DPV702  (01/02/1997) - ME:  Improve efficiency of Query Optimizer
	;
	;-------------------------------------------------------------
	;                       I N F O R M A T I O N
	;-------------------------------------------------------------
	;
	; Put interesting orders in an array for a given set of streams
	; The $$$Malg() and ptj() arrays must already have been created
	; input parameters:
	;       prev:  list of previous streams already processed
	;               bracketed by commas
	;       array: array in which to return interesting orders
	; input variables:
	;       qoqn: query #
	;       qojsn: join set #
	;       ptfjoo: column #s bracketed by commas for FJOO (final join
	;               output order)
	;       pftjoos: stream #s required for FJOO to be processed,
	;                comma bracketed
	; return in array: array(sub)="" where sub is a comma bracketed
	;        list of column numbers for the interesting order
	;
#ENDIF  ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	n a,b,c,x,i k array ; init the array
	#; PVA184: ptfjoo,ptfjoos now subscripted by query number. 
	g:ptfjoo(qoqn)="" b
	#; see how much of ptfjoo is an interesting order
	s c="",x=1 f i=2:1:$l(ptfjoos(qoqn),",")-1 s a=$p(ptfjoos(qoqn),",",i) i prev'[(","_a_",") s x=0 q
	i x s array(ptfjoo(qoqn))=""
	#; loop through all other streams in this join set that are not in
	#;  the 'prev' list.  To the extent they have join attributes that
	#;    are joined with 'prev', the corresponding
	#;    'prev' column(s) is an interesting order
	#; PVA316: skip join interesting orders for quickcost
b QUIT:nojord  s a="" f  s a=$o(ptj(qoqn,qojsn,a)) q:a=""  i prev'[(","_a_",") d stream
	QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
stream	;  Find each join attribute for this stream.  If it is joined
	#; to attribute(s) in the 'prev' streams, we have
	#; an interesting order
	s b="" f  s b=$o(ptj(qoqn,qojsn,a,b)) q:b=""  d stream1
	QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
stream1	;  have all of these streams been processed?
	f i=2:1:$l(b,",")-1 s c=$p(b,",",i) i prev'[(","_c_",") g stream2
	#; yes - these join algorithms represent interesting orders
#IF 0   ; AK612+
	s c="" f  s c=$o(ptj(qoqn,qojsn,a,b,c)) q:c=""  s array($p($$$Malg(c),"^",5))=""
#ELSE   ; AK612=
	#;  filter out %VR "OR virtual expresions"
	s c="" f  s c=$o(ptj(qoqn,qojsn,a,b,c)) q:c=""  s x=$p($$$Malg(c),"^",5) s:$e(mt("v",$p(x,",",2)),1,6)'="v^%VR^" array(x)=""
#ENDIF  ; AK612-
stream2	QUIT
	#;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-