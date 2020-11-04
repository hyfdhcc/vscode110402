ROUTINE %qao [Type=INC]
        ;  mqo.inc
        ;  query optimizer macros
        #;  PVA154  (09/01/2008) - Improve optimizer cost model : distinguish selectivity for complex conditions on map subscripts from that on map data

        ; Macros for subscripts of cost formula
        ; #   NAME     MEANING
        ;
        ; 1   SSE1     Selectivity of equals rest above JA and above range
        ;              Maybe reduced by migration of restriction.
#define SSE1 1
        ; 2   SSE1M    Max "".  Prior to considering effect of migration
#define SSE1M 2
        ; 3   SSE2     Selectivity of equals rest on JA.  Maybe reduced
        ;              by migration.
#define SSE2 3
        ; 4   SSE2M    Max "". Prior to considering effect of migration.
        ;              (affects index/sort creation but not node
        ;              distribution and not join cost)
#define SSE2M 4
        ; 5   SSE3     Selectivity of equals rest below JA
        ;              Maybe reduced by migration.
#define SSE3 5
        ; 6   SSE3M    Max "".  Prior to considering effect of migration
#define SSE3M 6
        ; 7   SSJA     Selectivity of join attribute
#define SSJA 7
        ; 8   SSJASUB  Selectivity of join attribute in subscript.  Used for
        ;              calculating subscript distributions.  Calculated prior
        ;              to considering effect of migration
#define SSJASUB 8
        ; 9   SSJAADD  Additional selectivity to be applied to join
        ;              attribute restriction due to situation in which
        ;              join attribute appears in a subscript, and domain
        ;              of the 2nd (B) relation is smaller than the domain
        ;              of the attribute in the 1st (A) relation, hence
        ;              many join combinations will automatically fail on
        ;              the attempt to access the indexd
#define SSJAADD 9
        ; 10   SSJAADDM Maximum value that would be taken by the SSJAADD
        ;               (i.e. the value that would occur if the JA ifn
        ;               appears exactly as a subscript in the index)
#define SSJAADDM 10
        ; 11   SSR     Selectivity of a range restriction.  Maybe reduced
        ;              by migration.
#define SSR 11
        ; 12  SSRM     Max "".  Maybe reduced by migration.
#define SSRM 12
        ; 13  SSOI     Selectivity of other subscript
        ;              restrictions satisfied in 'index map' that don't
        ;              require data from any other stream
#define SSOI 13
        ; 14  SSOID    Selectivity of other non-subscript
        ;              restrictions satisfied in 'index map' that don't
        ;              require data from any other stream
#define SSOID 14
        ; 15  SSOIMUL    Selectivity of other subscript
        ;                restrictions that can be satisfied by the index
        ;                map but require other streams to already have
        ;                been processed.  Hence, these restrictions cannot
        ;                be used in index creation or sort file creation or
        ;                initial stream processing
#define SSOIMUL 15
        ; 16  SSOIMULD   Selectivity of other non-subscript
        ;                restrictions that can be satisfied by the index
        ;                map but require other streams to already have
        ;                been processed.  Hence, these restrictions cannot
        ;                be used in index creation or sort file creation or
        ;                initial stream processing
#define SSOIMULD 16
        ; 17  SSO0     Selectivity of other restrictions satisfied in map 0
        ;               that don't require data from any other stream
        ;               Hence it can be used in sort file creation.
#define SSO0 17
        ; 18  SSO0MUL   Selectivity of other restrictions satisfied in map 0
        ;               that require other streams to already have been
        ;               processed.  Hence these restrictions cannot be used
        ;               in index creation or sort file creation or initial
        ;               stream processing.
#define SSO0MUL 18
        ; 19   SSOE   selectivity to be applied to output tuples of outer
        ;             join (can arise due to outer joins with restrictions
        ;             that can be passed by nul tuples)
#define SSOE 19
        ; 20  SNbtup   # tuples in map 0 of 'B' stream
#define SNbtup 20
        ; 21  SNbblk   # blocks in map 0 of 'B' stream
#define SNbblk 21
        ; 22  SNitup   # tuples in 'index map' of 'B' stream that satisfy all
        ;              implicit restrictions, SSE1, and SSE2
#define SNitup 22
        ; 23  SNiblk   # blocks in 'index map' that satisfy all high level
        ;              and JA equals restrictions (satisfy SSE1M and SSE2M
        ;              restrictions)
#define SNiblk 23
        ; 24  SGPi     # nodes per tuple to retrieve from 'index map'
#define SGPi 24
        ; 25  SGPb     # nodes per tuple to retrieve from map 0
#define SGPb 25
        ; 26  SL2B     # nodes at the join attribute subscript level ('jasub')
        ;              for the 'index map' of 'B' stream for which the node
        ;              passes all SSE1M and SSE2M restrictions (i.e. equals
        ;              restrictions at and above the JA)
#define SL2B 26
        ; 27  SZB      average # of nodes below the 'jasub' level for each
        ;              node at the 'jasub' level
#define SZB 27
        ; 28  SSJAIN     Selectivity of input column for a join (1 if initial stream)
#define SSJAIN 28
        ; 29  SSJACOND   Selectivity of a "RANGE" or "CON" restriction on the JA
#define SSJACOND 29
        ; SUBMAX is the highest subscript
#define SUBMAX 29