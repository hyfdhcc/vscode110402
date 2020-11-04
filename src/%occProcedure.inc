ROUTINE %occProcedure [Type=INC]
#;					30
#define cPROCclass					1
#define cPROCcolumn				"c"
#define cPROCcontextclass			25
#define cPROCdescription         	2
#define cPROCexecute             	3
#define cPROChidden              	5
#define cPROCidcolumn            	6
#define cPROCidextent				23
#define cPROCinputparms          	7
	#; cPROCinterface
	#;	-2	function procedure with a return value that may return result sets
	#;	-1	function procedure without a return value that may return result sets
	#;	0	function procedure without a return value, no result sets
	#;	1	query (single result set)
	#;	2	function with a return value, no result sets
#define cPROCinterface           	8
#define cPROCinformixlegacy			28
#; define cPROCmethod              	9
#define cPROCname                	10
#define cPROCodbccatalog         	11
#define cPROCodbcinfo            	12
#define cPROCoutputparms         	13
	#; cPROCparmsdirection is a string of 0|1 where a 1 value corresponds to a parm that is output or IO (indicate an output 'direction') Return values are not represented here.
#define cPROCparmsdirection      	15
#define cPROCparmslength			26
#define cPROCparmsobjectcat      	24
#define cPROCprocedure           	14
#define cPROCprojected				27
#define cPROCremarks             	16
#define cPROCresultsets          	17
#define cPROCreturnval           	18
#; define cPROCroutine             	19
#define cPROCschema              	20
#define cPROCselectmode				29
#define cPROCsignature           	21
#define cPROCstatementtype				30
#define cPROCsubquery			"s"
#define cPROCtype                	22
 
#define cPROCCOLparm       		"P"
#;						22
#define cPROCCOLattribute       	1
#define cPROCCOLbitstring		21
#define cPROCCOLcaption			15
#define cPROCCOLclass			16
#define cPROCCOLclientdatatypeenum	17
#define cPROCCOLcolinfo         	2
#define cPROCCOLdatatype		3
#define cPROCCOLdefault			22
#define cPROCCOLlength          	4
#define cPROCCOLname            	5
#define cPROCCOLnullable        	6
#define cPROCCOLodbctype        	7
#define cPROCCOLodbctypename    	8
#define cPROCCOLprecision       	9
#define cPROCCOLprocinfo        	10
#define cPROCCOLradix           	11
#define cPROCCOLremarks         	12
#define cPROCCOLscale           	13
#define cPROCCOLschema			18
#define cPROCCOLsubquery		20
#define cPROCCOLtablename		19
#define cPROCCOLtype            	14
 
#define cPROCSUBQUERYcardinality	1
 
#; ENUM values
#define cPROCTYPEFUNCTION       	"function"
#define cPROCTYPEQUERY			"query"
#;
#define pPROC(%schema,%proc)                                  ^oddPROC(%schema,%proc
#define PROC(%ref,%schema,%proc)                              %ref(%schema,%proc))
#define PROCxxx(%ref,%schema,%proc,%keyword)                  %ref(%schema,%proc),%keyword)
#define PROCclass(%ref,%schema,%proc)                         %ref(%schema,%proc),$$$cPROCclass)
#define PROCcolumn(%ref,%schema,%proc)                        %ref(%schema,%proc),$$$cPROCcolumn)
#define PROCcontextclass(%ref,%schema,%proc)		      %ref(%schema,%proc),$$$cPROCcontextclass)
#define PROCdescription(%ref,%schema,%proc)                   %ref(%schema,%proc),$$$cPROCdescription)
#define PROCexecute(%ref,%schema,%proc)                       %ref(%schema,%proc),$$$cPROCexecute)
#define PROChidden(%ref,%schema,%proc)                        %ref(%schema,%proc),$$$cPROChidden)
#define PROCidcolumn(%ref,%schema,%proc)		      %ref(%schema,%proc),$$$cPROCidcolumn)
#define PROCidextent(%ref,%schema,%proc)		      %ref(%schema,%proc),$$$cPROCidextent)
 
#define PROCinputparms(%ref,%schema,%proc)                    %ref(%schema,%proc),$$$cPROCinputparms)
#define PROCinterface(%ref,%schema,%proc)                     %ref(%schema,%proc),$$$cPROCinterface)
#define PROCinformixlegacy(%ref,%schema,%proc)                %ref(%schema,%proc),$$$cPROCinformixlegacy)
#; define PROCmethod(%ref,%schema,%proc)                        %ref(%schema,%proc),$$$cPROCmethod)
#define PROCname(%ref,%schema,%proc)                          %ref(%schema,%proc),$$$cPROCname)
#define PROCodbccatalog(%ref,%schema,%proc)                   %ref(%schema,%proc),$$$cPROCodbccatalog)
#define PROCodbcinfo(%ref,%schema,%proc)                      %ref(%schema,%proc),$$$cPROCodbcinfo)
#define PROCodbcinfoV(%ref,%schema,%proc,%version)            %ref(%schema,%proc),$$$cPROCodbcinfo,%version)
#define PROCoutputparms(%ref,%schema,%proc)                   %ref(%schema,%proc),$$$cPROCoutputparms)
#define PROCparmsdirection(%ref,%schema,%proc)                %ref(%schema,%proc),$$$cPROCparmsdirection)
	#; This is a $List() of integers where positive integers are the maxlen of string input directed parameters. A value that is not a positive integer means
	#; the parameter correpsonding to the element position is either not input directed (input or I-O) or it is not a string type.
#define PROCparmslength(%ref,%schema,%proc)		      %ref(%schema,%proc),$$$cPROCparmslength)
#define PROCparmsobjectcat(%ref,%schema,%proc)                %ref(%schema,%proc),$$$cPROCparmsobjectcat)
#define PROCprocedure(%ref,%schema,%proc)                     %ref(%schema,%proc),$$$cPROCprocedure)
	#; PROCprojected is true if this procedure is to be callable as a stored procedure
#define PROCprojected(%ref,%schema,%proc)                     %ref(%schema,%proc),$$$cPROCprojected)
#define PROCremarks(%ref,%schema,%proc)                       %ref(%schema,%proc),$$$cPROCremarks)
#define PROCresultsets(%ref,%schema,%proc)                    %ref(%schema,%proc),$$$cPROCresultsets)
#define PROCreturnval(%ref,%schema,%proc)                     %ref(%schema,%proc),$$$cPROCreturnval)
#define PROCschema(%ref,%schema,%proc)                        %ref(%schema,%proc),$$$cPROCschema)
#define PROCselectmode(%ref,%schema,%proc)                    %ref(%schema,%proc),$$$cPROCselectmode)
#define PROCsignature(%ref,%schema,%proc)                     %ref(%schema,%proc),$$$cPROCsignature)
#define PROCstatementtype(%ref,%schema,%proc)                 %ref(%schema,%proc),$$$cPROCstatementtype)
#define PROCsubquery(%ref,%schema,%proc)                      %ref(%schema,%proc),$$$cPROCsubquery)
#define PROCtype(%ref,%schema,%proc)                          %ref(%schema,%proc),$$$cPROCtype)
 
#define PROCCOL(%ref,%schema,%proc,%column)		      %ref(%schema,%proc),$$$cPROCcolumn,%column)
#define PROCCOLattribute(%ref,%schema,%proc,%column)	      %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLattribute)
#define PROCCOLbitstring(%ref,%schema,%proc,%column)	      %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLbitstring)
#define PROCCOLcaption(%ref,%schema,%proc,%column)	      %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLcaption)
#define PROCCOLclass(%ref,%schema,%proc,%column)	      %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLclass)
#define PROCCOLclientdatatypeenum(%ref,%schema,%proc,%column) %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLclientdatatypeenum)
#define PROCCOLcolinfo(%ref,%schema,%proc,%column)            %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLcolinfo)
#define PROCCOLcolinfoV(%ref,%schema,%proc,%column,%version)  %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLcolinfo,%version)
#define PROCCOLdatatype(%ref,%schema,%proc,%column)           %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLdatatype)
#define PROCCOLdefault(%ref,%schema,%proc,%column)            %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLdefault)
#define PROCCOLlength(%ref,%schema,%proc,%column)             %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLlength)
#define PROCCOLname(%ref,%schema,%proc,%column)               %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLname)
#define PROCCOLnullable(%ref,%schema,%proc,%column)           %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLnullable)
#define PROCCOLodbctype(%ref,%schema,%proc,%column)           %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLodbctype)
#define PROCCOLodbctypename(%ref,%schema,%proc,%column)       %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLodbctypename)
#define PROCCOLprecision(%ref,%schema,%proc,%column)          %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLprecision)
#define PROCCOLprocinfo(%ref,%schema,%proc,%column)           %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLprocinfo)
#define PROCCOLradix(%ref,%schema,%proc,%column)              %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLradix)
#define PROCCOLremarks(%ref,%schema,%proc,%column)            %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLremarks)
#define PROCCOLscale(%ref,%schema,%proc,%column)              %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLscale)
#define PROCCOLschema(%ref,%schema,%proc,%column)	      %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLschema)
#define PROCCOLsubquery(%ref,%schema,%proc,%column)	      %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLsubquery)
#define PROCCOLtablename(%ref,%schema,%proc,%column)	      %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLtablename)
#define PROCCOLtype(%ref,%schema,%proc,%column)               %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLtype)
#define PROCCOLparm(%ref,%schema,%proc,%column)               %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLparm)
 
#define PROCCOLPARM(%ref,%schema,%proc,%column,%parm)         %ref(%schema,%proc),$$$cPROCcolumn,%column,$$$cPROCCOLparm,%parm)
 
#define PROCSUBQUERY(%ref,%schema,%proc,%subquery)	      %ref(%schema,%proc),$$$cPROCsubquery,%subquery)
#define PROCSUBQUERYcardinality(%ref,%schema,%proc,%subquery) %ref(%schema,%proc),$$$cPROCsubquery,%subquery,$$$cPROCSUBQUERYcardinality)
 