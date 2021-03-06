ROUTINE %qaois [Type=INC]
%qaois   ; QO - Cost formulas for initial stream
         #;
#INCLUDE %msql
#INCLUDE %qao
         #;
#IF 0    ;
         ;---------------------------------------------------------------------
         ; Description:   QO - Cost formulas for initial stream
         ; Author:        Terry Ragon
         ; Date:          September 17, 1991
         ; Maintenance History: [ XXXnnn (MM/DD/YY) - Description ]
         ;
         ;  PVA178  (05/12/2009) - Make cost formulas for index access more consistent. 
         ;  PVA154  (09/01/2008) - Improve optimizer cost model : distinguish selectivity for complex conditions on map subscripts from that on map data
 		 ;  PVA073  (01/28/2005) - Avoid unnecessary data map access for "TOP n id .... ORDER BY id" queries; also for idkey columns. Also, additional TOP bugs.
		 ;  PVA072 11/10/2004 - Support pseudo conditions implied by TOP... ORDER BY in optimizer
         ;  PVA36  06/27/2002 - Query processor uses temp files too often. 
         ;  PVA017 09/20/2000 Make computation of index disk accesses consistent across the
         ;                    initial stream algorithms.
         ;  AK209
         ;
         ;---------------------------------------------------------------------
         ;                     I N F O R M A T I O N
         ;---------------------------------------------------------------------
         ;
         ; cost formulas for initial streams
         ;
         ; $$is^%qaois(...)
         ; input parameters:
         ;     alg: the low level algorithm name
         ;     recid: 1 if interesting order attribute (IOA) is record id
         ;     abp:  available buffer pool (# buffers available for this join)
         ; input variables:
         ;     form:  input array for cost formulas
         ; return:       cost ^ number of tuples
         ;     where cost is expressed in the format:
         ;           total cost,disc cost,global get cost,global set cost
         ;
         ; ***When using ISALG1, don't ignore range in cost formulas
         ; ***(it won't be migrated as it will in join algorithms)
         ;
         ; Algorithms IS1 through IS7 are just like the corresponding join
         ; algorithms J1 through J7 except that:
         ;      intuples = form($$$SL2B)   ; formerly: 1/form($$$SSJASUB)
         ;      qoouter = 0, ordinput = 1, nocdmap0 = 0
         ;
         ;---------------------------------------------------------------------
#ENDIF   ;
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
is(alg,recid,abp) n a,b,x,y,cd,cgg,rilowsub,riother,rbother,intuples
         s intuples=form($$$SL2B)
         d @alg  ;  set cd,cgg,numtup
         s:cd>5 cd=cd\1 s:cgg>5 cgg=cgg\1 s:numtup>5 numtup=numtup+.5\1
         QUIT ((cd*CDFACTOR)+(cgg*CGGFACTOR))_","_cd_","_cgg_",0^"_numtup
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #; IS1
         #; Sequentially process a temporary index on stream-A.
         #; We must go to Map 0.
IS1      g IS7
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #; IS2
         #; Iterative loop on initial stream.  Use a map that contains all of
         #; the necessary data ordered on the interesting order attrib (IOA).
         #; There may be an equals restriction above or on the IOA.
         #; Consider all the nodes under the IOA as 
         #; candidates, subject to satisfying all restrictions.
IS2      g IS6
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #; IS3 - like IS2 except also have to go to map 0
IS3      g IS7
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #; IS4 - Like IS2, except also have an equals restriction in a
         #;       subscript below the interesting order attribute
IS4      g IS6
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #; IS5 - Like IS4 except that we must goto map 0
IS5      g IS7
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #; IS6 - like IS2, except also have a range restriction in a
         #;       subscript below the interesting order attribute
IS6      s a=form($$$SL2B)*form($$$SSJASUB),rilowsub=form($$$SSE3)*form($$$SSR),b=a*form($$$SZB)*rilowsub,riother=form($$$SSOI)
         s numtup=b*riother*form($$$SSOID)/form($$$SSJASUB) // PVA154
         #; calculate cgg cost for index accesses:
         #; If interesting order on record id,
         #; then index access cost = 
         #;     1 $O per IOA if there's no data to pick up in index
         #;     or 1 $O + 1 $G per IOA if there's data to pick up in index
         #;            + ($$$SGPi - 1) for each of those that pass any 
         #;                             additional test
         #;  else:  (also assume the next subscript is the record id)
         #;     2 $O per IOA (1 at IOA subscript + 1 extra at ID level)
         #;           (3 if range: $G + $O)
         #;     + 2 ($O and a get) per B tuple that matches that IOA and 
         #;                        pases sub rest
         #;     + ($$$SGPi - 1) per B tuple that matches that IOA and passes 
         #;                     sub rest
         #;         i.e.: intuples*((form($$$SSR)<1)+2+(2*b)+
         #;                                   (b*riother*(form($$$SGPi)-1)))
         #;  PVA178: Of much more importance than the detailed accounting describe above 
         #;          is to ensure that different uses of an index that represent the 
         #;          exact same actual global usage have the same cost.                                    
         i recid s cgg=$s(form($$$SGPi)>0:riother*(form($$$SGPi)-1)+2,1:1)*rilowsub*intuples
         e  s cgg=intuples* b*(2+$s(form($$$SGPi)>1:riother*(form($$$SGPi)-1),1:0))
         #; s cd = form($$$SNiblk) - # index blocks skipped due to 
         #;                                                $$$SSE3 & $$$SSR
#IF 0  ; PVA017+
         i rilowsub<1 s y=form($$$SNiblk)*(1-rilowsub)-form($$$SL2B) ; # blocks per IOA disqualified due to $$$SSE3 & $$$SSR
         i  i y>0 s cd=form($$$SNiblk)-y
         e  s cd=form($$$SNiblk)
#ELSE  ; PVA017=
                 s cd=form($$$SNiblk)*rilowsub+1         
#ENDIF ; PVA017-                
         QUIT
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #;IS7 - same as IS6, except that we must also goto map0
IS7      n cdi,cdb
		 #; PVA072: accumulate 0mul into rbother as well. 
		 #; PVA073: accumulate imul into riother as well (for case of TOP condition on ID
		 #;         applied after multi-intex strategy, but before going to map0. 
         s a=form($$$SL2B)*form($$$SSJASUB),rilowsub=form($$$SSE3)*form($$$SSR),b=a*form($$$SZB)*rilowsub,riother=form($$$SSOI)*form($$$SSOIMUL),rbother=form($$$SSO0)*form($$$SSO0MUL)
         s numtup=b*riother*form($$$SSOID)*form($$$SSOIMULD)*rbother/form($$$SSJASUB) //PVA154
         #;
         #; calculate cgg cost for index accesses:
         #; If interesting order on record id,
         #; then index access cost = 
         #;     1 $O per IOA if there's no data to pick up in index
         #;     or 1 $O + 1 $G per IOA if there's data to pick up in index
         #;           (which is needed to pass a test)
         #;            + ($$$SGPi - 1) for each of those that pass that 
         #;                            first test
         #; else  if no extra restrictions to process in index:
         #;      (assume the next subscript is the record id & we do $O on it)
         #;     2 $O per IOA (1 for $O at IOA subscript, 
         #;                   1 for extra $O at ID level)
         #;              (3 if there's a range: $G + $O)
         #;     + 1 $O per B tuple that matches that join attribute and
         #;            passes subscript restrictions
         #;  else:  (also assume the next subscript is the record id)
         #;     2 $O per IOA (1 for $O at IOA subscript, 
         #;                   1 for extra $O at ID level)
         #;           (3 if there's a range: $G + $O)
         #;     + 2 ($O and a get) per B tuple that matches that IOA and 
         #;                       pases sub rest
         #;     + ($$$SGPi - 1) per B tuple that matches that IOA and passes 
         #;                    sub rest
         #;         i.e.: intuples*((form($$$SSR)<1)+1+(2*b)+
         #;                     (b*riother*(form($$$SGPi)-1)))
         #;  PVA178: Of much more importance than the detailed accounting describe above 
         #;          is to ensure that different uses of an index that represent the 
         #;          exact same actual global usage have the same cost.                                    
         i recid s cgg=$s(form($$$SGPi)>0:riother*(form($$$SGPi)-1)+2,1:1)*rilowsub*intuples
		 #; PVA154: No plausible reason for this case. Index access for IS7 should
		 #;    be no different than IS6. Further, whether riother is <1 has nothing to 
		 #;    do with whether data nodes in the index need fetching (currently this must
		 #;    be asssumed, as there is no determination of this).
         #; e  i riother=1 s cgg=intuples*((form($$$SSR)<1)+2+b)
         e  s cgg=intuples* b*(2+$s(form($$$SGPi)>1:riother*(form($$$SGPi)-1),1:0))
         #; + add cgg cost for map0
         #; PVA154: rbother selectivity applied to this cgg computation. That is wrong, because
         #;         the SGPb cost must be paid before you have data to test rbother conditions.
         s cgg=intuples*b*riother*form($$$SSOID)*form($$$SSOIMULD)*$s(form($$$SGPb)>1:form($$$SGPb),1:1)+cgg
         #; s y=form($$$SNiblk) - # index blcks skipped due to $$$SSE3 & $$$SSR
#IF 0  ; PVA017+
         i rilowsub<1 s y=form($$$SNiblk)*(1-rilowsub)-form($$$SL2B) ; # blocks per IOA disqualified due to $$$SSE3 & $$$SSR
         i  i y>0 s y=form($$$SNiblk)-y
         e  s y=form($$$SNiblk)
#ELSE  ; PVA017=
                 s y=form($$$SNiblk)*rilowsub+1          
#ENDIF ; PVA017-                
         #; now y = total # of index blocks needed
         s cdi=y
         s cdb=b*riother*form($$$SSOID)*form($$$SSOIMULD)/form($$$SSJASUB) // PVA154
         #; PVA36: limiting cdb to form($$$SNbblk) should only be done if recid (order) true.
         #;        Restructure random case (recid off) to have more complete and correct logic.
         #;        In particular, size of map0 (form($$$SNbblk)) in relation to assumed buffer pool
         #;        affects cache hit probability. Prior logic used cdb where map0 size should have been
         #;        used. 
         if recid { s:cdb>form($$$SNbblk) cdb=form($$$SNbblk) }
         elseif cdb>form($$$SNbblk) {
	        if form($$$SNbblk)'>abp {s cdb=form($$$SNbblk)}
	        else {s cdb=cdb-((cdb-abp)*(abp/form($$$SNbblk))) s:cdb<form($$$SNbblk) cdb=form($$$SNbblk)}
	        }
	     #; else leave cdb as is: random, but we predict every tuple from different block because
	     #;           of sparseness
         s cd=cdi+cdb QUIT
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #; IS8
         #; Sequentially process a map that has an A-only equals restriction
         #; subscript.  DON'T go to map 0.  There is NO IOA.  Consider all
         #; nodes under the A-only equals subscript as candidates, subject
         #; to satisfying all restrictions.
IS8      s riother=form($$$SSOI) ;form($$$SSR)=1
         s numtup=form($$$SNitup)*form($$$SSE3)*riother*form($$$SSOID) // PVA154
         #; calculate cgg
         #; assume there's a $O and a GET for each tuple that passes
         #; $$$SSE1 and $$$SSE2 and $$$SSE3
         #; + if there's other index map restrictions and we need more
         #;   than one data node then we pick up form($$$SGPi)-1 nodes for
         #;   each tuple that also passes riother restrictions
         s cgg=form($$$SNitup)*form($$$SSE3)*(2+$s(form($$$SGPi)>1:form($$$SGPi)-1*riother,1:0))
         s cd=form($$$SNiblk)*form($$$SSE3)+1 QUIT
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #; IS9
         #; same as IS8 except must also go to map 0
		 #; PVA072: accumulate 0mul into rbother as well. 
		 #;    most likely no need for $$$SSO0MUL handling in this alg.
IS9      s riother=form($$$SSOI),rbother=form($$$SSO0)*form($$$SSO0MUL) ;form($$$SSR)=1
         #; PVA154: 'a' in IS9 is only used in post index access, so include ssoid
         s a=form($$$SNitup)*form($$$SSE3)*riother*form($$$SSOID),numtup=a*rbother
         #; calculate cgg
         #; assume there's a $O and a GET for each tuple that passes
         #; $$$SSE1 and $$$SSE2 and $$$SSE3
         #; + if there's other index map restrictions and we need more
         #;   than one data node then we pick up form($$$SGPi)-1 nodes for
         #;   each tuple that also passes riother restrictions
         s cgg=form($$$SNitup)*form($$$SSE3)*(2+$s(form($$$SGPi)>1:form($$$SGPi)-1*riother,1:0)) ; index access cost
         #; PVA154: rbother selectivity applied to this cgg computation. That is wrong, because
         #;         the SGPb cost must be paid before you have data to test rbother conditions.
         s cgg=cgg+(a*$s(form($$$SGPb)>1:form($$$SGPb),1:1)) ; add cost to access B file
         s cd=form($$$SNiblk)*form($$$SSE3)+1  ; index access cost
         s cd=cd+$s(a<form($$$SNbblk):a,1:form($$$SNbblk)) ; add cost to access map 0, assuming access it sequentially
         QUIT
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #; IS10
         #; Sequentially process a map that has an A-only range restriction
         #; subscript.  There may or may not be an A-only equals restriciton
         #; subscript above and/or below the range restriction subscript.
         #; Don't go to map 0.  There is NO IOA.
         #; ***Doesn't deal properly with possible equals restriction below
         #; range??
IS10     s a=form($$$SSE3)*form($$$SSR)
         s riother=form($$$SSOI)
         s numtup=form($$$SNitup)*a*riother*form($$$SSOID) // PVA154
         #; calculate cgg
         #; 1) there's a $O and a GET for each tuple that passes
         #; $$$SSE1 and $$$SSE2 and $$$SSE3 and $$$SSR
         #; + 2) there is a $O at the range subscript level for each subscript
         #;      at this lev that passes $$$SSE1, $$$SSE2, $$$SSE3, and $$$SSR
         #;      and  another extra $O at the next lower level.  At worst,
         #;      this amounts equals 100% of 1) above,
         #;     and at best it approaches 0.
         #;     For calculation purposes, we ignore it, under the assumption
         #;       that if there is a range subscript, that there are
         #;       probably several nodes below each range subscript value.
         #; + 3) if there's other index map restrictions and we need more
         #;   than one data node then we pick up form($$$SGPi)-1 nodes for
         #;   each tuple that also passes riother restrictions
         s cgg=form($$$SNitup)*a*(2+$s(form($$$SGPi)>1:form($$$SGPi)-1*riother,1:0))
         s cd=form($$$SNiblk)*a+1 QUIT
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #; IS11 - Same as IS10 except go to map 0
		 #; PVA072: accumulate 0mul into rbother as well. 
		 #;    most likely no need for $$$SSO0MUL handling in this alg.
IS11     n cdb s a=form($$$SSE3)*form($$$SSR),riother=form($$$SSOI),rbother=form($$$SSO0)*form($$$SSO0MUL)
		 #; PVA154: Accumulate SSOID into x, which is only used post index processing
         s x=form($$$SNitup)*a*riother*form($$$SSOID),numtup=x*rbother  ; x = # tuples that pass index restrictions
         #; calculate cgg for index
         #; 1) there's a $O for each tuple that passes
         #; $$$SSE1 and $$$SSE2 and $$$SSE3 and $$$SSR
         #; + , if there's at least one riother restriction, a get
         #;   for each $O
         #; + 2) there is a $O at the range subscript level for each subscript
         #;      at this lev that passes $$$SSE1, $$$SSE2, $$$SSE3, and $$$SSR
         #;      and  another extra $O at the next lower level.  At worst,
         #;      this amounts equals 100% of 1) above,
         #;     and at best it approaches 0.
         #;     For calculation purposes, we ignore it, under the assumption
         #;       that if there is a range subscript, that there are
         #;       probably several nodes below each range subscript value.
         #; + 3) if there's other index map restrictions and we need more
         #;   than one data node then we pick up form($$$SGPi)-1 nodes for
         #;   each tuple that also passes riother restrictions
         #; PVA178: Make cgg formula like IS10.
         s cgg=form($$$SNitup)*a*(2+$s(form($$$SGPi)>1:form($$$SGPi)-1*riother,1:0))
         s cd=form($$$SNiblk)*a+1
         #; now calculate cost of accessing map 0
         #; PVA154: rbother selectivity applied to this cgg computation. That is wrong, because
         #;         the SGPb cost must be paid before you have data to test rbother conditions.
         s cgg=x*$s(form($$$SGPb)>1:form($$$SGPb),1:1)+cgg
         s cdb=x ; initially assume 1 disk access per tuple
         #; PVA36: IS11 is ONLY used when access in in ID order; previous code assumed NEVER in ID
         #;        order.
         s:cdb>form($$$SNbblk) cdb=form($$$SNbblk)
         s cd=cd+cdb QUIT
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
IS12     g:form($$$SSR)=1 IS8 g IS10
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
         #; IS13
         #; do nothing except calculate # tuples.  We produced a sort file
         #; as a stream preprocessing temp file and that is the solution.
         #; PVA072: allow 'join' time selectivity after building temp file:
         #;         multiply in SSOIMUL in numtup computation.
IS13     s cd=0,cgg=0,numtup=form($$$SNitup)*form($$$SSOIMUL)*form($$$SSOIMULD) QUIT //PVA154
         #;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-