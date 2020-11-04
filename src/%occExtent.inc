ROUTINE %occExtent [Type=INC]
	#; EXTENT Keywords									76		99
#; Common keywords - these are keywords that share a common node value with their ^oddCOM counterparts (range 1-20, as assigned in %occKeyword.inc)
#define cEXTXXXXcompilergenerated		10
#define cEXTXXXXdescription				4
#define cEXTXXXXfinal					7
#define cEXTXXXXid						6
#define cEXTXXXXinheritedid				8
#define cEXTXXXXinheritsecondary		15
#define cEXTXXXXkeyworderror			12
#define cEXTXXXXkeywordmodified			13
#define cEXTXXXXname					1
#define cEXTXXXXnotinheritable			9
#define cEXTXXXXorigin					2
#define cEXTXXXXsequencenumber			11
#define cEXTXXXXsignature				3
#define cEXTXXXXstubmember				14
#define cEXTXXXXtype					5

#;	Common keywords that are specific to a compiled extent definition - current counter = 53 (range = 21-60)
#define cEXTXXXXinterface					53

#;	Keywords specific to one submember type are assigned a value unique to that submember in the range 61-99.

#;	Common Keyword constant values
#define cEXTXXXXINTERFACEALL				$lb("direct","functional")
#define cEXTXXXXINTERFACEDIRECT				"direct"
#define cEXTXXXXINTERFACEFUNCTIONAL			"functional"

#;	Miscellaneous Constants
#define cEXTXXXXCONTEXTINMEMORY				"N"
#define cEXTXXXXCONTEXTONDISK				"O"

	#; Simple keywords						102
#define cEXTancestry							61
#define cEXTchildren							73
#define	cEXTclass							98
#define cEXTconversioncode						101
#define cEXTcounterlocation						36
#define cEXTdataaddress							62
#define cEXTdatalocation						21
#define cEXTdefaultdata							22
#define cEXTextentsize							75
#define cEXTidcheck							74
	#; This is the name of the IDENTITY property. Not to be confused with the parent reference. This
	#; is the property declared by the user as IDENTITY.
#define cEXTidentity							65
#define cEXTidexpression						23
#define cEXTidkey							63
#define cEXTidkeyelementcount						64
#define cEXTidlocation							24
#define cEXTidreference							66
#define cEXTorigin							$$$cEXTXXXXorigin
#define cEXTparent							67
#define cEXTreferencedby						93
	#; cEXTroot is the name of the class that instantiates the extent of this class. The root class cannot have any instantiable super class, it must extend %SwizzleObject and it cannot declare NOEXTENT
#define cEXTroot							68
	#; cEXTrootclass - TRUE if this class is the extent root class
#define cEXTrootclass							26
#define cEXTschema							69
#define cEXTskipped							70
#define cEXTsqlcheckoption						92
#define cEXTsqlchildsub							27
#define cEXTsqlcolumnidx						99
#define cEXTsqlidexpression						28
#define cEXTsqlinfo							91
#define cEXTsqlmetadataversion						102
#define cEXTsqlrowidcolumnlist						71
#define cEXTsqltableviewidx						95
#define cEXTsqlviewquery						94
#define cEXTsqlviewtableidx						96
#define cEXTsqlviewviewsidx						97
#define cEXTstate							32
#define cEXTstreamlocation						33
#define cEXTtablename							72
#define cEXTtriggers							100
#define cEXTtransporter							76
#define cEXTtype							$$$cEXTXXXXtype
#define cEXTversionlocation						35
 
	#; Substructures
#define cEXTaddress										"G"
#define cEXTaddrvar										"W"
#define cEXTcolumn										"b"
#define cEXTconstraint										"n"
#define cEXTcq											"cq"
#define cEXTcounter										"c"
#define cEXTindex										"X"
#define cEXTsqlinsertcode									"zi"
#define cEXTiterator										"L"
#define cEXTmap											"H"
#define cEXTproperty										"a"
#define cEXTrelationship									"J"
#define cEXTrowversion										"r"
#define cEXTspec										"spec"
#define cEXTsqlmap										"S"
#define cEXTstream										"M"
#define cEXTsubextent										"Z"
 
	#; ADDRESS Keywords
	#;		simple keywords									86
#define cEXTADDRaddresslock									67
#define cEXTADDRbasereference								61
#define cEXTADDRcalldelete									82
#define cEXTADDRcallinsert									83
#define cEXTADDRcallsegmentinsert							86
#define cEXTADDRcallupdate									84
#define cEXTADDRglobal										62
#define cEXTADDRindex										63
#define cEXTADDRiterators									75
#define cEXTADDRkey											64
#define cEXTADDRkeysubscripts								65
#define cEXTADDRlocation									66
#define	cEXTADDRnodestructure								79
#define cEXTADDRnotinheritable		$$$cEXTXXXXnotinheritable
#define cEXTADDRorder										68
#define cEXTADDRorigin				$$$cEXTXXXXorigin
#define cEXTADDRproperties									69
#define cEXTADDRreference									70
#define cEXTADDRrowreference								80
#define cEXTADDRsymbol								43
#define cEXTADDRtype				$$$cEXTXXXXtype
#define cEXTADDRunique										71
#define cEXTADDRuniqueptr									72
#define cEXTADDRuniquereference								73
#define cEXTADDRuniquesymbol								74
#define cEXTADDRupdatable									76
#define cEXTADDRupdatecondition								77
#define cEXTADDRuniquecondition								78
#define cEXTADDRuniqueupdatecondition						85
 
	#;		substructures
#define cEXTADDRiva											"K"
#define cEXTADDRkeyspec										"Y"
#define cEXTADDRsubscript					"B"
 
	#; subscript keywords									68
#define cEXTADDRSUBdependency								61
#define cEXTADDRSUBkeysub									62
#define cEXTADDRSUBliteral									65
#define cEXTADDRSUBnotsql									66
#define cEXTADDRSUBnulls									63
#define cEXTADDRSUBproperty									67
#define cEXTADDRSUBsql								43
#define cEXTADDRSUBsqlaccesstype							68
#define cEXTADDRSUBsqlcondition								64
 
#define cEXTCONSsqlinfo										61
#define cEXTCONSfkey						"f"
 
#define	cEXTCONSFKEYaction									61
 
	#; INDEX keywords										75
#define cEXTIDXcardinality									62
#define cEXTIDXcondition									63
#define cEXTIDXcounter										64
#define cEXTIDXcountersql									65
#define cEXTIDXdata											66
#define cEXTIDXextent										67
#define cEXTIDXidkey										68
#define cEXTIDXlocation						21
	#; This is equal to the number of properties in the index. If the index is the idkey and the parent property is not
	#; one of the explicit properties then this number is one greater than the EXTIDXproperty value.
#define cEXTIDXlogicalcardinality							73
	// the index offset is an integer that is unique within the root extent and it is assigned by the compiler.
#define cEXTIDXoffset										75
#define cEXTIDXorigin					$$$cEXTXXXXorigin
#define cEXTIDXprimarykey									69
#define cEXTIDXsqlcolumnlist								70
#define cEXTIDXsymbol								43
#define cEXTIDXsystemassigned								71
	// cEXTIDXtype is the index type - key, bitmap, bitslice, etc.
#define cEXTIDXtype											74
	// cEXTIDXtypeclass is the declared index type. If this value is not null then the index is a functional index
#define cEXTIDXtypeclass				$$$cEXTXXXXtype
#define cEXTIDXunique										72
	#;		substructures
#define cEXTIDXproperty						"I"
#define cEXTIDXglobal						"G"

	#; Index properties										66
#define cEXTIDXPROPcollation								61
#define cEXTIDXPROPcollationparms							62
#define cEXTIDXPROPexpression						41
	#; This is a $List() of iterators
#define cEXTIDXPROPiterators								66
	#; ivaproperty might go away if cEXTIDXPROPiterators is fully utilized....
#define cEXTIDXPROPivaproperty								63
#define cEXTIDXPROPnulls									64
#define cEXTIDXPROPsql										65
 
	#; EXTITERATOR											62
#define cEXTITERATORiteratortype							61
#define cEXTITERATORsource									62
#define cEXTITERATORparam				"P"
 
#define cEXTMAPancestry					"ancestry"
#define cEXTMAPdata						"data"
#define cEXTMAPdatadependency			"datadependency"
#define cEXTMAPsqlsubscripts			"sqlsubscripts"
	#;		substructures
	
#define cEXTMAPDATAaddress				"address"
#define cEXTMAPDATAnode					"node"
#define cEXTMAPDATAsqladdress			"sqladdress"
#define cEXTMAPDATAtype					"type"
#define cEXTMAPDATAvalue				"value"
 
	#; EXT property keywords							108
#define cEXTPROPautoincrement								86
#define cEXTPROPaveragefieldsize							97
#define cEXTPROPbiasqueriesasoutlier							96
#define cEXTPROPcardinality								24
#define cEXTPROPcollation								61
#define cEXTPROPcollection								27
#define cEXTPROPcollectionproxy								82
#define cEXTPROPcontainer								62
#define cEXTPROPcontainercollection							93
#define cEXTPROPcounterreference							80
#define cEXTPROPdatamap									91
#define cEXTPROPdependency								63
#; define cEXTPROPdescription			$$$cEXTXXXXdescription
#define cEXTPROPifn									64
#define cEXTPROPgenerated								67
#define cEXTPROPindexsubscripts								68
#define cEXTPROPinitialexpression							31
#; define cEXTPROPinverse								32
#define cEXTPROPkeycol									88
#define cEXTPROPlogicalexpression							84
#define cEXTPROPlogicalinstanceexpression						95
#define cEXTPROPlogicaltostorage							66
#define cEXTPROPoidtype									69
#define cEXTPROPelementoidtype								108
#define cEXTPROPoutlierselectivity							94
#define cEXTPROPondisk									85
#define cEXTPROPprivate									35
#define cEXTPROPreadonly								52
	#; cEXTPROPreferencecardinality is the number of pipe-delimited pieces in the reference.
#define cEXTPROPreferencecardinality							83
#define cEXTPROPrelationship								36
#define cEXTPROPrequired								37
#define cEXTPROPselectivity								70
#define cEXTPROPserialdelimiter								89
#define cEXTPROPserialexpression							71
#define cEXTPROPserialkeydelimiter							90
#define cEXTPROPserialreference								72
#define cEXTPROPserialsqlexpression							73
#define cEXTPROPserialstructure								74
#define cEXTPROPserialtype								75
#define cEXTPROPslot									76
#define cEXTPROPsqlcolumnnumber								43
#define cEXTPROPsqlcolumnname								47
#define cEXTPROPsqlcolumnnameexternal							81
#define cEXTPROPsqlcomputecode								44
#define cEXTPROPsqlcomputed								45
#define cEXTPROPsqlcomputeonchange							46
#define cEXTPROPsqlinfo									91
#define cEXTPROPsqllisttype								49
#define cEXTPROPsqllistdelimiter							48
#define cEXTPROPsqltablename								77
#define cEXTPROPstreamlocation								92
#define cEXTPROPstoragetological							78
#define cEXTPROPtransient								51
#define cEXTPROPtype								$$$cEXTXXXXtype
#define cEXTPROPtypecat									79
#define cEXTPROPunique									87
 
#define cEXTPROPparameter								"P"
#define cEXTPROPPARAMvalue								61
	
#define cEXTSQLCOLsqlinfo								91
#define cEXTSQLCOLsqlcomputecode							92
#define cEXTSQLCOLmapsubsidx								93
#define cEXTSQLCOLmapdataidx								94
#define cEXTSQLCOLnameidx								95
#define cEXTSQLCOLLogicalToDisplay							96
#define cEXTSQLCOLLogicalToOdbc								97
#define cEXTSQLCOLLogicalToStorage							98
#define cEXTSQLCOLDisplayToLogical							99
#define cEXTSQLCOLOdbcToLogical								100
#define cEXTSQLCOLStorageToLogical							101
#define cEXTSQLCOLLogicalToFDBMS							102
#define cEXTSQLCOLFDBMSToLogical							103
#define cEXTSQLCOLLogicalToDate								104
#define cEXTSQLCOLDateToLogical								105
#define cEXTSQLCOLLogicalToTimeStamp							106
#define cEXTSQLCOLTimeStampToLogical							107

 
#define cEXTSQLMAPglobal				24
#define cEXTSQLMAPpopulationpct				25
#define cEXTSQLMAPpopulationtype			26
#define cEXTSQLMAPsqlinfo									91
#define cEXTSQLMAPstructure				28
#define cEXTSQLMAPtype					$$$cEXTXXXXtype
 
#define cEXTSQLMAPdata					"T"
#define cEXTSQLMAProwidspec				"R"
#define cEXTSQLMAPsubscript				"B"
	
#define cEXTSQLMAPDATAdelimiter				21
#define cEXTSQLMAPDATAnode				22
#define cEXTSQLMAPDATApiece				23
#define cEXTSQLMAPDATAretrievalcode			24
#define cEXTSQLMAPDATAsqlinfo								91
	
#define cEXTSQLMAPROWIDSPECexpression		21
#define cEXTSQLMAPROWIDSPECfield			22
#define cEXTSQLMAPROWIDSPECsqlinfo							91
	
#define cEXTSQLMAPSUBaccesstype				21
#define cEXTSQLMAPSUBdataaccess				22
#define cEXTSQLMAPSUBdelimiter				23
#define cEXTSQLMAPSUBexpression				24
#define cEXTSQLMAPSUBloopinit				25
#define cEXTSQLMAPSUBnextcode				26
#define cEXTSQLMAPSUBnullmarker				27
#define cEXTSQLMAPSUBsqlinfo								91
#define cEXTSQLMAPSUBstartvalue				28
#define cEXTSQLMAPSUBstopexpression			29
#define cEXTSQLMAPSUBstopvalue				30
 
#define cEXTSQLMAPSUBvariables			"V"
#define cEXTSQLMAPSUBVARSaccesscode							92
#define cEXTSQLMAPSUBVARSsqlinfo							91
#define cEXTSQLMAPSUBVARSvariable							93
 
#define cEXTSQLMAPSUBinvalidcondition		"N"
 
#define cEXTSQLMAPSUBINVCONDexpression		21
 
	#; Temporary storage nodes
#define cSYMaddress							"G"
#define cSYMcollection										"C"
#define cSYMkey									 			"E"
#define cSYMstore											"O"
 
#define cSYMancestry										61
#define cSYMattribute										62
#define cSYMcardinality										63
#define cSYMclustertype										65
#define cSYMdata											66
#define cSYMdatadependency									67
#define cSYMelement											68
#define cSYMkeyserial										69
#define cSYMexpression						41
#define cSYMindex											70
#define cSYMlockdependency									73
#define cSYMlogical											74
#define cSYMmap												75
#define cSYMmaxcol											76
#define cSYMname											77
#define cSYMnode											78
#define cSYMnulls											79
#define cSYMproperty										80
#define cSYMreference										81
#define cSYMreferencecounter								82
#define cSYMserial											83
#define cSYMslot											84
#define cSYMsqladdress										85
#define cSYMsqlsubscripts									86
#define cSYMtype											87
#define cSYMvalue											88
 
#define cSYMKEYreferenceelements							61
 
#define cMAPbindery							"bindery"
#define cMAPcode							"code"
#define cMAPdata							"data"
#define cMAPindex							"index"
#define cMAPkey								"key"
#define cMAPmap								"map"
#define cMAPnodecount						"nodecount"
#define cMAPsql								"sql"
#define cMAPrsql							"rsql"
#define cMAPsubscript						"subscript"
#define cMAPtype							"type"
#define cMAPvalue							"value"

#;	ADDRESS constants 

#define cEXTADDRADDRESSTYPEALL				$lb("bitmap","bitmapextent","bitslice","data","index","key")
#define cEXTADDRADDRESSTYPEBITMAP			"bitmap"
#define cEXTADDRADDRESSTYPEBITMAPEXTENT		"bitmapextent"
#define cEXTADDRADDRESSTYPEBITSLICE			"bitslice"
#define cEXTADDRADDRESSTYPEDATA				"data"
#define cEXTADDRADDRESSTYPEINDEX			"index"
#define cEXTADDRADDRESSTYPEKEY				"key"

#; INDEX constants
#define cEXTIDXINDEXTYPEALL					$lb("bitmap","bitslice","index","key","collatedkey")
#define cEXTIDXINDEXTYPEBITMAP				"bitmap"
#define cEXTIDXINDEXTYPEBITSLICE			"bitslice"
#define cEXTIDXINDEXTYPECOLLATEDKEY         "collatedkey"
#define cEXTIDXINDEXTYPEINDEX				"index"
#define cEXTIDXINDEXTYPEKEY					"key"
 
#define cEXTITERATORITERATORTYPECOLLECTION		"c"
#define cEXTITERATORITERATORTYPEARRAY			"a"
#define cEXTITERATORITERATORTYPELIST			"l"
#define cEXTITERATORITERATORTYPEBVA				"v"
#define cEXTITERATORITERATORTYPEBITSTRING		"b"
 
#define cEXTMAPDATATYPELISTNODE					"listnode"
#define cEXTMAPDATATYPENODE						"node"
#define cEXTMAPDATATYPESUBNODE					"subnode"
#;
#; global references, new syntax 
#;							   
#define pEXT(%extent)										^oddMAP(%extent
#define pEXTroot											^oddMAP
	
#define rEXT(%extent)										^oddEXTR(%extent
#define rEXTroot											^oddEXTR
 
#define pMAP(%extent)										^oddMAP(%extent
#define pMAProot											^oddMAP
 #; NOTINHERITABLE keywords omit the $$$cEXTspec keyword - all cEXTspec keywords are inheritable
#define EXT(%ref,%extent)							%ref(%extent))
#define EXTxxx(%ref,%extent,%keyword)						%ref(%extent),%keyword)
#define EXTancestry(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTancestry)
#define EXTchildren(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTchildren)
#define EXTclass(%ref,%extent)							%ref(%extent),$$$cEXTspec,$$$cEXTclass)
#define EXTcounterlocation(%ref,%extent)					%ref(%extent),$$$cEXTspec,$$$cEXTcounterlocation)
#define EXTdataaddress(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTdataaddress)
#define EXTdefaultdata(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTdefaultdata)
#define EXTextentsize(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTextentsize)
#define EXTparent(%ref,%extent)							%ref(%extent),$$$cEXTspec,$$$cEXTparent)
#define EXTidexpression(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTidexpression)
#define EXTidentity(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTidentity)
#define EXTidkey(%ref,%extent)							%ref(%extent),$$$cEXTspec,$$$cEXTidkey)
#define EXTidkeyelementcount(%ref,%extent)					%ref(%extent),$$$cEXTspec,$$$cEXTidkeyelementcount)
	#; cEXTidcheck is an expression that evaluates to TRUE if the highest ID value is not greater than the current ID counter value
#define EXTidcheck(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTidcheck)
#define EXTidlocation(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTidlocation)
#define EXTidreference(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTidreference)
#define EXTreferencedby(%ref,%extent,%column)					%ref(%extent),$$$cEXTreferencedby,%column)
#define EXTroot(%ref,%extent)							%ref(%extent),$$$cEXTspec,$$$cEXTroot)
#define EXTrootclass(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTrootclass)
#define EXTschema(%ref,%extent)							%ref(%extent),$$$cEXTspec,$$$cEXTschema)
#define EXTsqlcheckoption(%ref,%extent,%line)					%ref(%extent),$$$cEXTspec,$$$cEXTsqlcheckoption,%line)
#define EXTsqlcheckoptionRoot(%ref,%extent)					%ref(%extent),$$$cEXTspec,$$$cEXTsqlcheckoption)
#define EXTsqlinfo(%ref,%extent)						%ref(%extent),$$$cEXTsqlinfo)
#define GetEXTsqlinfo(%ref,%extent)						$g(%ref(%extent),$$$cEXTsqlinfo))
#define EXTsqlmetadataversion(%ref,%extent)					%ref(%extent),$$$cEXTsqlmetadataversion)
#define EXTsqlviewquery(%ref,%extent,%line)					%ref(%extent),$$$cEXTspec,$$$cEXTsqlviewquery,%line)
#define EXTsqlviewqueryRoot(%ref,%extent)					%ref(%extent),$$$cEXTspec,$$$cEXTsqlviewquery)
#define EXTstate(%ref,%extent)							%ref(%extent),$$$cEXTspec,$$$cEXTstate)
#define EXTtablename(%ref,%extent)						%ref(%extent),$$$cEXTspec,$$$cEXTtablename)
#define EXTsqltableviewidx(%ref,%extent,%viewextent)				%ref(%extent),$$$cEXTspec,$$$cEXTsqltableviewidx,%viewextent)
#define EXTsqltableviewidxRoot(%ref,%extent)					%ref(%extent),$$$cEXTspec,$$$cEXTsqltableviewidx)
#define EXTsqlviewviewsidx(%ref,%extent,%extent2)				%ref(%extent),$$$cEXTspec,$$$cEXTsqlviewviewsidx,%extent2)
#define EXTsqlviewviewsidxRoot(%ref,%extent)					%ref(%extent),$$$cEXTspec,$$$cEXTsqlviewviewsidx)
#define EXTsqlviewtableidx(%ref,%viewextent,%tableextent)			%ref(%viewextent),$$$cEXTspec,$$$cEXTsqlviewtableidx,%tableextent)
#define EXTsqlviewtableidxRoot(%ref,%viewextent)				%ref(%viewextent),$$$cEXTspec,$$$cEXTsqlviewtableidx)
#define EXTsqlcolumnidx(%ref,%extent,%column)					%ref(%extent),$$$cEXTspec,$$$cEXTsqlcolumnidx,$zcvt(%column,"U"))
#define EXTsqlcolumnidxRoot(%ref,%extent)					%ref(%extent),$$$cEXTspec,$$$cEXTsqlcolumnidx)
#define EXTsqlconversioncodenumlines(%ref,%extent,%hash)			%ref(%extent),$$$cEXTspec,$$$cEXTconversioncode,%hash)
#define EXTsqlconversioncodesignature(%ref,%extent,%hash)			%ref(%extent),$$$cEXTspec,$$$cEXTconversioncode,%hash,0)
#define EXTsqlconversioncodeline(%ref,%extent,%hash,%line)			%ref(%extent),$$$cEXTspec,$$$cEXTconversioncode,%hash,%line)
#define EXTtransporter(%ref,%extent)						%ref(%extent),$$$cEXTtransporter)
	#; This is the storage class name...
#define EXTtype(%ref,%extent)							%ref(%extent),$$$cEXTspec,$$$cEXTtype)
#define EXTppclassname(%ref,%extent)						%ref(%extent),$$$cEXTspec,0)
#define EXTversionlocation(%ref,%extent)					%ref(%extent),$$$cEXTspec,$$$cEXTversionlocation)
	
#define EXTXXX(%ref,%extent,%keyword,%value)				%ref(%extent),%keyword,%value)
#define EXTaddress(%ref,%extent)							%ref(%extent),$$$cEXTaddress)
#define EXTaddrvar(%ref,%extent)							%ref(%extent),$$$cEXTaddrvar)
#define EXTcq(%ref,%extent)									%ref(%extent),$$$cEXTcq)
#define EXTconstraint(%ref,%extent)							%ref(%extent),$$$cEXTconstraint)
#define EXTcounter(%ref,%extent)							%ref(%extent),$$$cEXTcounter)
#define EXTindex(%ref,%extent)								%ref(%extent),$$$cEXTindex)
#define EXTsqlinsertcode(%ref,%extent)						%ref(%extent),$$$cEXTsqlinsertcode)
#define EXTiterator(%ref,%extent)							%ref(%extent),$$$cEXTiterator)
#define EXTmap(%ref,%extent)								%ref(%extent),$$$cEXTmap)
#define EXTproperty(%ref,%extent)							%ref(%extent),$$$cEXTproperty)
#define EXTrelationship(%ref,%extent)						%ref(%extent),$$$cEXTrelationship)
#define EXTrowversion(%ref,%extent)							%ref(%extent),$$$cEXTrowversion)
#define EXTspec(%ref,%extent)								%ref(%extent),$$$cEXTspec)
#define EXTskipped(%ref,%extent)							%ref(%extent),$$$cEXTspec,"skipped")
#define EXTsql(%ref,%extent)								%ref(%extent),$$$cEXTsql)
#define EXTsqlmap(%ref,%extent)								%ref(%extent),$$$cEXTsqlmap)
#define EXTsqlonemap(%ref,%extent,%mapname)					%ref(%extent),$$$cEXTsqlmap,%mapname)
#define EXTsubextent(%ref,%extent)							%ref(%extent),$$$cEXTsubextent)
#; EXTtriggers is a character string of $Char(0) and $Char(1) characters indicating insert before, insert after, update before, update after, delete before, delete after
#define EXTtriggers(%ref,%extent)							%ref(%extent),$$$cEXTtriggers)

	#; These are really extent-level keywords but for backward compatibility I am leaving them as EXTSQLxxx
#define EXTSQLchildcounter(%ref,%extent)					%ref(%extent),$$$cEXTsqlchildsub)
#define EXTSQLidexpression(%ref,%extent)					%ref(%extent),$$$cEXTsqlidexpression)
#define EXTSQLrowidcolumnlist(%ref,%extent)					%ref(%extent),$$$cEXTsqlrowidcolumnlist)
 
	#; (COM only for INDEX)
#define EXTSKIPPED(%ref,%extent,%serial,%value)				%ref(%extent),$$$cEXTspec,"skipped",%serial,%value)
	
#define EXTADDR(%ref,%extent,%address)							%ref(%extent),$$$cEXTaddress,%address)
	#; addresslock is a lock reference that is used to lock the entire address, similar to basereference but different for child extents
#define EXTADDRaddresslock(%ref,%extent,%address)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRaddresslock)
	#; basereference is the location root of the address (no variables except perhaps %%PARENT stuff)
#define EXTADDRbasereference(%ref,%extent,%address)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRbasereference)
#define EXTADDRcalldelete(%ref,%extent,%address)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRcalldelete)
#define EXTADDRcallinsert(%ref,%extent,%address)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRcallinsert)
#define EXTADDRcallsegmentinsert(%ref,%extent,%address)			%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRcallsegmentinsert)
#define EXTADDRcallupdate(%ref,%extent,%address)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRcallupdate)
#define EXTADDRglobal(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRglobal)
	#; The index that generated this address. Not every address has an index - INDEXTYPE = KEY addresses do not have an index.
	#; Addresses without an index have subscripts that corrrespond to the key index only.
	#; When an address has both an index and a key then the index subscripts are first and the key subscripts added after them.
	#; If a key subscript is the same as an existing index subscript then the subscript is not duplicated.
#define EXTADDRindex(%ref,%extent,%address)						%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRindex)
#define EXTADDRinterface(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTXXXXinterface)
	#; This an ordered $list of iterators that must be instantiated in order to refer to this address
#define EXTADDRiterators(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRiterators)
	#; Every address has a key - this is the index from which the ID value can be derived. Normally, the key is the IDKEY.
	#; If the index type is a key index then the ID is either the address subscripts themselves or the node value is the ID.
	#; For all other index types, the key is the IDKEY and the IDKEY subscripts are added to the address (unless already present).
#define EXTADDRkey(%ref,%extent,%address)						%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRkey)
	#; This is a list of the subscripts that correspond to the address key.
#define EXTADDRkeysubscripts(%ref,%extent,%address)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRkeysubscripts)
	#; location is the 'LOCATION' value used to generate this address. It preserves the %%PARENT token
#define EXTADDRlocation(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRlocation)
	#; Structure has meaning only for SQL projection - it is D - delimited or L - list. Default to 'L'
#define EXTADDRnodestructure(%ref,%extent,%address)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRnodestructure)
#define EXTADDRnotinheritable(%ref,%extent,%address)			%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRnotinheritable)
	#; Order is the number of non-literal subscripts in the list
#define EXTADDRorder(%ref,%extent,%address)						%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRorder)
#define EXTADDRorigin(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRorigin)
#define EXTADDRrowreference(%ref,%extent,%address)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRrowreference)
#define EXTADDRproperties(%ref,%extent,%address)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRproperties)
#define EXTADDRreference(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRreference)
	#; Subscript list is the expression to construct the Address key (all non-literal subscript values) in $lb() form...
#define EXTADDRsubscriptlist(%ref,%extent,%address)				%ref(%extent),$$$cEXTaddress,%address,"subscriptlist")
#define EXTADDRsymbol(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsymbol)
	#; One of: DATA, KEY, INDEX, UNIQUEINDEX
	#; One of: DATA, KEY, INDEX, BITMAP (UNIQUEINDEX now replaced with UNIQUE flag...
#define EXTADDRtype(%ref,%extent,%address)						%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRtype)
#define EXTADDRunique(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRunique)
	#; uniqueptr is the location of the last subscript for the index sortkey. Each data address is bound to a key as is each key address
	#; Each index address is bound both to the index sortkey and to a key.
#define EXTADDRuniqueptr(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRuniqueptr)
	#; uniquereference is the location root of the address plus subscripts introduced by the 'index sortkey'
	#; If the index sort key is defined to be UNIQUE, then this is the reference to check for uniqueness
#define EXTADDRuniquereference(%ref,%extent,%address)			%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRuniquereference)
#define EXTADDRuniquesymbol(%ref,%extent,%address)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRuniquesymbol)
#define EXTADDRupdatable(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRupdatable)
#define EXTADDRupdatecondition(%ref,%extent,%address)			%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRupdatecondition)
	// uniquecondition is a $List() of properties that need to be checked for NULL. If any property in this list is NULL then
	// the unique constraint is not checked further.
#define EXTADDRuniquecondition(%ref,%extent,%address)			%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRuniquecondition)
	// This is a $list of properties that if changed will trigger the constraint to be checked on update
#define EXTADDRuniqueupdatecondition(%ref,%extent,%address)		%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRuniqueupdatecondition)
	#; Substructures of ADDR
#define EXTADDRiva(%ref,%extent,%address)						%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRiva)
#define EXTADDRkeyspec(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRkeyspec)
#define EXTADDRsubscript(%ref,%extent,%address)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript)
	
#define EXTADDRIVA(%ref,%extent,%address,%iva)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRiva,%iva)
	
#define EXTADDRKEYSPEC(%ref,%extent,%address,%spec)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRkeyspec,%spec)
 
#define EXTADDRSUB(%ref,%extent,%address,%sub)					%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript,%sub)
#define EXTADDRSUBdependency(%ref,%extent,%address,%sub)		%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript,%sub,$$$cEXTADDRSUBdependency)
#define EXTADDRSUBexpression(%ref,%extent,%address,%sub)		%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript,%sub)
#define EXTADDRSUBkeysub(%ref,%extent,%address,%sub)			%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript,%sub,$$$cEXTADDRSUBkeysub)
	#; EXTADDRSUBliteral is true if the subscript expression is a literal
#define EXTADDRSUBliteral(%ref,%extent,%address,%sub)			%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript,%sub,$$$cEXTADDRSUBliteral)
	#; if cEXTADDRSUBnotsql is true then this subscript does not project to SQL
#define EXTADDRSUBnotsql(%ref,%extent,%address,%sub)			%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript,%sub,$$$cEXTADDRSUBnotsql)
#define EXTADDRSUBnulls(%ref,%extent,%address,%sub)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript,%sub,$$$cEXTADDRSUBnulls)
	#; cEXTADDRSUBproperty is a reference to the property (defined in EXTPROP) on which this subscript is based. 
#define EXTADDRSUBproperty(%ref,%extent,%address,%sub)			%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript,%sub,$$$cEXTADDRSUBproperty)
	#; This is the SQL equivalent expression
#define EXTADDRSUBsql(%ref,%extent,%address,%sub)				%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript,%sub,$$$cEXTADDRSUBsql)
#define EXTADDRSUBsqlcondition(%ref,%extent,%address,%sub)		%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript,%sub,$$$cEXTADDRSUBsqlcondition)
	#; This corresponds to EXTSQLMAPSUB - if this is set then additional keywords are available as $$$EXTSQLMAPSUBxxx($$$pEXT,%extent,%address,%sub)
#define EXTADDRSUBsqlaccesstype(%ref,%extent,%address,%sub)		%ref(%extent),$$$cEXTaddress,%address,$$$cEXTADDRsubscript,%sub,$$$cEXTADDRSUBsqlaccesstype)
 
 
#define EXTCQns(%ref,%extent,%system,%ns)						%ref(%extent),$$$cEXTcq,%system,%ns)
#define EXTCQcq(%ref,%extent,%system,%ns,%cq)					%ref(%extent),$$$cEXTcq,%system,%ns,%cq)
 
#define EXTCONS(%ref,%extent,%constraint)						%ref(%extent),$$$cEXTconstraint,%constraint)
#define EXTCONSsqlinfo(%ref,%extent,%constraint)				%ref(%extent),$$$cEXTconstraint,%constraint,$$$cEXTCONSsqlinfo)
#define EXTCONSfkey(%ref,%extent,%constraint)					%ref(%extent),$$$cEXTconstraint,%constraint,$$$cEXTCONSfkey)
 
#define EXTCONSFKEY(%ref,%extent,%constraint,%fclass,%fkey)		%ref(%extent),$$$cEXTconstraint,%constraint,$$$cEXTCONSfkey,%fclass,%fkey)
#define EXTCONSFKEYaction(%ref,%extent,%constraint,%fclass,%fkey) %ref(%extent),$$$cEXTconstraint,%constraint,$$$cEXTCONSfkey,%fclass,%fkey,$$$cEXTCONSFKEYaction)
 
#define EXTCOUNTER(%ref,%extent,%counter)						%ref(%extent),$$$cEXTcounter,%counter)

#define EXTROWVERSION(%ref,%extent,%rowversion)						%ref(%extent),$$$cEXTrowversion,%rowversion)

#define EXTIDX(%ref,%extent,%index)								%ref(%extent),$$$cEXTindex,%index)
#define EXTIDXcardinality(%ref,%extent,%index)					%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXcardinality)
#define EXTIDXcondition(%ref,%extent,%index)					%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXcondition)
#define EXTIDXcounter(%ref,%extent,%index)						%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXcounter)
#define EXTIDXcountersql(%ref,%extent,%index)					%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXcountersql)
#define EXTIDXextent(%ref,%extent,%index)						%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXextent)
#define EXTIDXidkey(%ref,%extent,%index)						%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXidkey)
#define EXTIDXinterface(%ref,%extent,%index)					%ref(%extent),$$$cEXTindex,%index,$$$cEXTXXXXinterface)
#define EXTIDXlocation(%ref,%extent,%index)						%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXlocation)
#define EXTIDXlogicalcardinality(%ref,%extent,%index)			%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXlogicalcardinality)
	// the index offset is an integer that is unique within the root extent and it is assigned by the compiler.
#define EXTIDXoffset(%ref,%extent,%index)						%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXoffset)
#define EXTIDXorigin(%ref,%extent,%index)						%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXorigin)
#define EXTIDXprimarykey(%ref,%extent,%index)					%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXprimarykey)
#define EXTIDXsqlcolumnlist(%ref,%extent,%index)				%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXsqlcolumnlist)
#define EXTIDXsymbol(%ref,%extent,%index)						%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXsymbol)
#define EXTIDXsystemassigned(%ref,%extent,%index)				%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXsystemassigned)
#define EXTIDXtype(%ref,%extent,%index)							%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXtype)
	// typeclass is used simply because of prior bad acts - TYPE was already used for a different keyword
#define EXTIDXtypeclass(%ref,%extent,%index)					%ref(%extent),$$$cEXTindex,%index,$$$cEXTXXXXtype)
#define EXTIDXunique(%ref,%extent,%index)						%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXunique)

#define EXTIDXdata(%ref,%extent,%index)							%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXdata)
#define EXTIDXglobal(%ref,%extent,%index)						%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXglobal)
#define EXTIDXprop(%ref,%extent,%index)							%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXproperty)
	
#define EXTIDXDATA(%ref,%extent,%index,%position)				%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXdata,%position)

	// EXTIDXGLOBAL provides a place to record all of the globals used by a functional index. This is typically not used for non-function (direct)
	// indexes. %glouse (Global Usage) is some arbitrary word used to identify the global.
#define EXTIDXGLOBAL(%ref,%extent,%index,%glouse)				%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXglobal,%glouse)
	 
#define EXTIDXPROP(%ref,%extent,%index,%position)				%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXproperty,%position)
#define EXTIDXPROPcollation(%ref,%extent,%index,%position)		%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXproperty,%position,$$$cEXTIDXPROPcollation)
#define EXTIDXPROPcollationparms(%ref,%extent,%index,%position)	%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXproperty,%position,$$$cEXTIDXPROPcollationparms)
#define EXTIDXPROPexpression(%ref,%extent,%index,%position)		%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXproperty,%position,$$$cEXTIDXPROPexpression)
#define EXTIDXPROPiterators(%ref,%extent,%index,%position)		%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXproperty,%position,$$$cEXTIDXPROPiterators)
#define EXTIDXPROPivaproperty(%ref,%extent,%index,%position)	%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXproperty,%position,$$$cEXTIDXPROPivaproperty)
#define EXTIDXPROPnulls(%ref,%extent,%index,%position)			%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXproperty,%position,$$$cEXTIDXPROPnulls)
#define EXTIDXPROPsql(%ref,%extent,%index,%position)			%ref(%extent),$$$cEXTindex,%index,$$$cEXTIDXproperty,%position,$$$cEXTIDXPROPsql)
	
#define EXTITERATOR(%ref,%extent,%iterator)						%ref(%extent),$$$cEXTiterator,%iterator)
	#; one of Collection, bva, bitstring
#define EXTITERATORiteratortype(%ref,%extent,%iterator)			%ref(%extent),$$$cEXTiterator,%iterator,$$$cEXTITERATORiteratortype)
#define EXTITERATORsource(%ref,%extent,%iterator)				%ref(%extent),$$$cEXTiterator,%iterator,$$$cEXTITERATORsource)
#define EXTITERATORparam(%ref,%extent,%iterator)				%ref(%extent),$$$cEXTiterator,%iterator,$$$cEXTITERATORparam)
 
#define EXTITERATORPARAM(%ref,%extent,%iterator,%parameter)		%ref(%extent),$$$cEXTiterator,%iterator,$$$cEXTITERATORparam,%parameter)
 
#define EXTMAP(%ref,%extent,%address)							%ref(%extent),$$$cEXTmap,%address)
#define EXTMAPancestrystored(%ref,%extent,%address)				%ref(%extent),$$$cEXTmap,%address,$$$cEXTMAPancestry)
#define EXTMAPdata(%ref,%extent,%address)						%ref(%extent),$$$cEXTmap,%address,$$$cEXTMAPdata)
#define EXTMAPdatadependency(%ref,%extent,%address)				%ref(%extent),$$$cEXTmap,%address,$$$cEXTMAPdatadependency)
#define EXTMAPsqlsubscripts(%ref,%extent,%address)				%ref(%extent),$$$cEXTmap,%address,$$$cEXTMAPsqlsubscripts)
	 
#define EXTMAPDATA(%ref,%extent,%address,%data)					%ref(%extent),$$$cEXTmap,%address,$$$cEXTMAPdata,%data)
#define EXTMAPDATAaddress(%ref,%extent,%address,%data)			%ref(%extent),$$$cEXTmap,%address,$$$cEXTMAPdata,%data,$$$cEXTMAPDATAaddress)
#define EXTMAPDATAnode(%ref,%extent,%address,%data)				%ref(%extent),$$$cEXTmap,%address,$$$cEXTMAPdata,%data,$$$cEXTMAPDATAnode)
#define EXTMAPDATAsqladdress(%ref,%extent,%address,%data)		%ref(%extent),$$$cEXTmap,%address,$$$cEXTMAPdata,%data,$$$cEXTMAPDATAsqladdress)
#define EXTMAPDATAtype(%ref,%extent,%address,%data)				%ref(%extent),$$$cEXTmap,%address,$$$cEXTMAPdata,%data,$$$cEXTMAPDATAtype)
#define EXTMAPDATAvalue(%ref,%extent,%address,%data)			%ref(%extent),$$$cEXTmap,%address,$$$cEXTMAPdata,%data,$$$cEXTMAPDATAvalue)
	
	#; This is where all of the stuff pertinent to the storage of properties is defined.
	#; MetaProperties (synthesized properties such as %%ID, %%IDKEY and %%extentNAME) are defined here
	#; and a flag - $$$EXTPROPgenerated - is set to true for synthesized properties.
	#; Also, properties generated for SQL projection of serial attributes are defined here.
	#; such properties are also $$$EXTPROPgenerated!
#define EXTPROP(%ref,%extent,%property)							%ref(%extent),$$$cEXTproperty,%property)
#define EXTPROPautoincrement(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPautoincrement)
#define EXTPROPaveragefieldsize(%ref,%extent,%property)		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPaveragefieldsize)
#define EXTPROPbiasqueriesasoutlier(%ref,%extent,%property)		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPbiasqueriesasoutlier)
#define EXTPROPcardinality(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPcardinality)
	#; This is logical, the collection type can easily be determined from other sources.
#define EXTPROPcollection(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPcollection)
#define EXTPROPcollectionproxy(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPcollectionproxy)
#define EXTPROPcollation(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPcollation)
#define EXTPROPcontainer(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPcontainer)
	// This is TRUE if this property was projected by flattening a collection property whose type class is SERIAL
#define EXTPROPcontainercollection(%ref,%extent,%property)		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPcontainercollection)
#define EXTPROPcounterreference(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPcounterreference)
	#; datamap is the location of this property in a data map. There can only be on storage location with a data map
	#; and only one DATA address (multiple data nodes mapped to it at a particular 'node' (aka 'subscript').
	#; This value is a $List of address, data, and slot where slot can be a comma delimited list to account for nested serials.
#define EXTPROPdatamap(%ref,%extent,%property)					%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPdatamap)
	#; EXTPROPdependency is a list of other EXTPROP references that the computation of this property is dependent on
#define EXTPROPdependency(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPdependency)
#define EXTPROPifn(%ref,%extent,%property)						%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPifn)
#define EXTPROPelementoidtype(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPelementoidtype)
#define EXTPROPlogicalexpression(%ref,%extent,%property)		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPlogicalexpression)
#define EXTPROPlogicalinstanceexpression(%ref,%extent,%property)	%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPlogicalinstanceexpression)
#define EXTPROPlogicaltostorage(%ref,%extent,%property)	  		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPlogicaltostorage)
#define EXTPROPgenerated(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPgenerated)
#define EXTPROPindexsubscripts(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPindexsubscripts)
#define EXTPROPinitialexpression(%ref,%extent,%property)		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPinitialexpression)
#define EXTPROPkeycol(%ref,%extent,%property)					%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPkeycol)
#define EXTPROPoidtype(%ref,%extent,%property)					%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPoidtype)
#define EXTPROPondisk(%ref,%extent,%property)					%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPondisk)
#define EXTPROPoutlierselectivity(%ref,%extent,%property)		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPoutlierselectivity)
#define EXTPROPprivate(%ref,%extent,%property)					%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPprivate)
#define EXTPROPreadonly(%ref,%extent,%property)					%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPreadonly)
#define EXTPROPreferencecardinality(%ref,%extent,%property)		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPreferencecardinality)
#define EXTPROPrelationship(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPrelationship)
#define EXTPROPrequired(%ref,%extent,%property)					%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPrequired)
#define EXTPROPselectivity(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPselectivity)
#define EXTPROPserialdelimiter(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPserialdelimiter)
#define EXTPROPserialexpression(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPserialexpression)
#define EXTPROPserialkeydelimiter(%ref,%extent,%property)		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPserialkeydelimiter)
#define EXTPROPserialreference(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPserialreference)
#define EXTPROPserialsqlexpression(%ref,%extent,%property)		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPserialsqlexpression)
#define EXTPROPserialstructure(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPserialstructure)
#define EXTPROPserialtype(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPserialtype)
#define EXTPROPsqlcolumnnumber(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPsqlcolumnnumber)
#define EXTPROPsqlcolumnname(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPsqlcolumnname)
#define EXTPROPsqlcolumnnameexternal(%ref,%extent,%property)	%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPsqlcolumnnameexternal)
#define EXTPROPsqlcomputecode(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPsqlcomputecode)
#define EXTPROPsqlcomputed(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPsqlcomputed)
#define EXTPROPsqlcomputeonchange(%ref,%extent,%property)		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPsqlcomputeonchange)
#define EXTPROPsqlinfo(%ref,%extent,%property)					%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPsqlinfo)
#define EXTPROPsqllisttype(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPsqllisttype)
#define EXTPROPsqllistdelimiter(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPsqllistdelimiter)
	#; This is the name of a child table projected from a multi-valued property (i.e. Collection)
#define EXTPROPsqltablename(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPsqltablename)
#define EXTPROPstreamlocation(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPstreamlocation)
#define EXTPROPstoragetological(%ref,%extent,%property)			%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPstoragetological)
#define EXTPROPtransient(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPtransient)
#define EXTPROPtype(%ref,%extent,%property)						%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPtype)
	#; This is one of: literal, serial, reference
#define EXTPROPtypecategory(%ref,%extent,%property)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPtypecat)
#define EXTPROPunique(%ref,%extent,%property)					%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPunique)
	 
#define EXTPROPPARAM(%ref,%extent,%property,%param)				%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPparameter,%param)
#define EXTPROPPARAMvalue(%ref,%extent,%property,%param)		%ref(%extent),$$$cEXTproperty,%property,$$$cEXTPROPparameter,%param,$$$cEXTPROPPARAMvalue)
	
#define EXTPROPslot(%ref,%extent,%prop)							%ref(%extent),$$$cEXTproperty,%prop,$$$cEXTPROPslot)
	
#define EXTPROPSLOT(%ref,%extent,%prop,%slot)					%ref(%extent),$$$cEXTproperty,%prop,$$$cEXTPROPslot,%slot)
 
#define EXTSQLCOL(%ref,%extent,%column)					%ref(%extent),$$$cEXTcolumn,%column)
#define EXTSQLCOLRoot(%ref,%extent)					%ref(%extent),$$$cEXTcolumn)
#define EXTSQLCOLsqlinfo(%ref,%extent,%column)				%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLsqlinfo)
#define EXTSQLCOLsqlcomputecode(%ref,%extent,%column)			%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLsqlcomputecode)
#define EXTSQLCOLmapsubsidx(%ref,%extent,%column,%map,%lev)		%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLmapsubsidx,%map,%lev)
#define EXTSQLCOLOnMapSub(%ref,%extent,%column,%mapname)		$d(%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLmapsubsidx,%mapname))
#define EXTSQLCOLOnAnyMapSub(%ref,%extent,%column)			$d(%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLmapsubsidx))
#define EXTSQLCOLmapdataidx(%ref,%extent,%column,%map,%lev)		%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLmapdataidx,%map,%lev)
#define EXTSQLCOLOnMapData(%ref,%extent,%column,%mapname)		$d(%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLmapdataidx,%mapname))
#define EXTSQLCOLOnAnyMapData(%ref,%extent,%column,)			$d(%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLmapdataidx))
#define EXTSQLCOLLogicalToDisplay(%ref,%extent,%column,)		%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLLogicalToDisplay)
#define EXTSQLCOLLogicalToOdbc(%ref,%extent,%column,)			%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLLogicalToOdbc)
#define EXTSQLCOLLogicalToStorage(%ref,%extent,%column,)		%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLLogicalToStorage)
#define EXTSQLCOLDisplayToLogical(%ref,%extent,%column,)		%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLDisplayToLogical)
#define EXTSQLCOLOdbcToLogical(%ref,%extent,%column,)			%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLOdbcToLogical)
#define EXTSQLCOLStorageToLogical(%ref,%extent,%column,)		%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLStorageToLogical)
#define EXTSQLCOLLogicalToFDBMS(%ref,%extent,%column,)			%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLLogicalToFDBMS)
#define EXTSQLCOLFDBMSToLogical(%ref,%extent,%column,)			%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLFDBMSToLogical)
#define EXTSQLCOLLogicalToDate(%ref,%extent,%column,)			%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLLogicalToDate)
#define EXTSQLCOLDateToLogical(%ref,%extent,%column,)			%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLDateToLogical)
#define EXTSQLCOLLogicalToTimeStamp(%ref,%extent,%column,)		%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLLogicalToTimeStamp)
#define EXTSQLCOLTimeStampToLogical(%ref,%extent,%column,)		%ref(%extent),$$$cEXTcolumn,%column,$$$cEXTSQLCOLTimeStampToLogical)
	
	#; EXTRELATIONSHIP is an index of relationships that need to be a) checked for validity and b) projected to SQL as an FKEY
#define EXTRELATIONSHIP(%ref,%extent,%relationship)				%ref(%extent),$$$cEXTrelationship,%relationship)
 
#define EXTSQLINSERTCODE(%ref,%extent,%line)					%ref(%extent),$$$cEXTsqlinsertcode,%line)
 
#define EXTSQLMAP(%ref,%extent,%map)							%ref(%extent),$$$cEXTsqlmap,%map)
#define EXTSQLMAPglobal(%ref,%extent,%map)						%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPglobal)
#define EXTSQLMAPpopulationpct(%ref,%extent,%map)				%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPpopulationpct)
#define EXTSQLMAPpopulationtype(%ref,%extent,%map)				%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPpopulationtype)
#define EXTSQLMAPstructure(%ref,%extent,%map)					%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPstructure)
#define EXTSQLMAPsqlinfo(%ref,%extent,%map)						%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsqlinfo)
#define EXTSQLMAPtype(%ref,%extent,%map)						%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPtype)
	
#define EXTSQLMAPdata(%ref,%extent,%map)						%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPdata)
#define EXTSQLMAProwidspec(%ref,%extent,%map)					%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAProwidspec)
#define EXTSQLMAPsubscript(%ref,%extent,%map)					%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript)
	
#define EXTSQLMAPDATA(%ref,%extent,%map,%data)					%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPdata,%data)
#define EXTSQLMAPDATAdelimiter(%ref,%extent,%map,%data)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPdata,%data,$$$cEXTSQLMAPDATAdelimiter)
#define EXTSQLMAPDATAnode(%ref,%extent,%map,%data)				%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPdata,%data,$$$cEXTSQLMAPDATAnode)
#define EXTSQLMAPDATApiece(%ref,%extent,%map,%data)				%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPdata,%data,$$$cEXTSQLMAPDATApiece)
#define EXTSQLMAPDATAretrievalcode(%ref,%extent,%map,%data)		%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPdata,%data,$$$cEXTSQLMAPDATAretrievalcode)
#define EXTSQLMAPDATAsqlinfo(%ref,%extent,%map,%data)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPdata,%data,$$$cEXTSQLMAPDATAsqlinfo)
	
#define EXTSQLMAPROWIDSPEC(%ref,%extent,%map,%spec)				%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAProwidspec,%spec)
#define EXTSQLMAPROWIDSPECexpression(%ref,%extent,%map,%spec)	%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAProwidspec,%spec,$$$cEXTSQLMAPROWIDSPECexpression)
#define EXTSQLMAPROWIDSPECfield(%ref,%extent,%map,%spec)		%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAProwidspec,%spec,$$$cEXTSQLMAPROWIDSPECfield)
#define EXTSQLMAPROWIDSPECsqlinfo(%ref,%extent,%map,%spec)		%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAProwidspec,%spec,$$$cEXTSQLMAPROWIDSPECsqlinfo)
	
#define EXTSQLMAPSUB(%ref,%extent,%map,%sub)					%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub)
#define EXTSQLMAPSUBaccesstype(%ref,%extent,%map,%sub)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBaccesstype)
#define EXTSQLMAPSUBdataaccess(%ref,%extent,%map,%sub)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBdataaccess)
#define EXTSQLMAPSUBdelimiter(%ref,%extent,%map,%sub)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBdelimiter)
#define EXTSQLMAPSUBexpression(%ref,%extent,%map,%sub)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBexpression)
#define EXTSQLMAPSUBinvcond(%ref,%extent,%map,%sub)				%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBinvalidcondition)
#define EXTSQLMAPSUBloopinit(%ref,%extent,%map,%sub)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBloopinit)
#define EXTSQLMAPSUBnextcode(%ref,%extent,%map,%sub)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBnextcode)
#define EXTSQLMAPSUBnullmarker(%ref,%extent,%map,%sub)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBnullmarker)
#define EXTSQLMAPSUBsqlinfo(%ref,%extent,%map,%sub)				%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBsqlinfo)
#define EXTSQLMAPSUBstartvalue(%ref,%extent,%map,%sub)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBstartvalue)
#define EXTSQLMAPSUBstopexpression(%ref,%extent,%map,%sub)		%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBstopexpression)
#define EXTSQLMAPSUBstopvalue(%ref,%extent,%map,%sub)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBstopvalue)
	
#define EXTSQLMAPSUBINVCOND(%ref,%extent,%map,%sub,%cond)		%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBinvalidcondition,%cond)
#define EXTSQLMAPSUBINVCONDexpression(%ref,%extent,%map,%sub,%cond)	%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBinvalidcondition,%cond,$$$cEXTSQLMAPSUBINVCONDexpression)
 
#define EXTSQLMAPSUBVARS(%ref,%extent,%map,%sub,%var)			%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBvariables,%var)
#define EXTSQLMAPSUBVARSaccesscode(%ref,%extent,%map,%sub,%var)	%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBvariables,%var,$$$cEXTSQLMAPSUBVARSaccesscode)
#define EXTSQLMAPSUBVARSsqlinfo(%ref,%extent,%map,%sub,%var)	%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBvariables,%var,$$$cEXTSQLMAPSUBVARSsqlinfo)
#define EXTSQLMAPSUBVARSvariable(%ref,%extent,%map,%sub,%var)	%ref(%extent),$$$cEXTsqlmap,%map,$$$cEXTSQLMAPsubscript,%sub,$$$cEXTSQLMAPSUBvariables,%var,$$$cEXTSQLMAPSUBVARSvariable)
	
#define EXTSUBEXTENT(%ref,%extent,%subclass)					%ref(%extent),$$$cEXTsubextent,%subclass)
	 
#define MAPall(%ref,%extent)									%ref(%extent))
	
#define MAPboundmaps(%ref,%extent)								%ref(%extent),"boundmaps")
#define MAPbindery(%ref,%extent)								%ref(%extent),$$$cMAPbindery)
#define MAPbindnewproperties(%ref,%extent)						%ref(%extent),"bindnew")
#define MAPbindexistingproperties(%ref,%extent,%map)			%ref(%extent),"bindexisting",%map)
#define MAPbindnewlist(%ref,%extent)							%ref(%extent),"bindnewlist")
#define MAPbindoldlist(%ref,%extent)							%ref(%extent),"bindoldlist")
#define MAPnodecount(%ref,%extent)								%ref(%extent),$$$cMAPnodecount)
	 
#define MAPindex(%ref,%extent)									%ref(%extent),$$$cMAPindex)
#define MAPkey(%ref,%extent)									%ref(%extent),$$$cMAPkey)
	 
#define MAPKEYall(%ref,%extent)									%ref(%extent),$$$cMAPkey)
#define MAPKEYNEXT(%ref,%extent)								$zincr($$$MAPKEYall(%ref,%extent))
	 
#define MAPIDX(%ref,%extent,%index)								%ref(%extent),$$$cMAPindex,%index)
#define MAPIDXassign(%ref,%extent,%index)						%ref(%extent),$$$cMAPindex,%index,"assign")
#define MAPIDXcardinality(%ref,%extent,%index)					%ref(%extent),$$$cMAPindex,%index,"cardinality")
	 
#define MAPIDXpropertyall(%ref,%extent,%index)					%ref(%extent),$$$cMAPindex,%index,"property")
#define MAPIDXproperty(%ref,%extent,%index,%idxseq)				%ref(%extent),$$$cMAPindex,%index,"property",%idxseq)
#define MAPIDXpropertyxform(%ref,%extent,%index,%idxseq)		%ref(%extent),$$$cMAPindex,%index,"property",%idxseq,"transformation")
#define MAPIDXextract(%ref,%extent,%index)						%ref(%extent),$$$cMAPindex,%index,"extract")
#define MAPIDXextractlvars(%ref,%extent,%index)					%ref(%extent),$$$cMAPindex,%index,"extractlvars")
#define MAPIDXtype(%ref,%extent,%index)							%ref(%extent),$$$cMAPindex,%index,"type")
	 
#define MAPkeysub(%ref,%extent,%key)							%ref(%extent),"keysub",%key)
#define MAPkeysubdepth(%ref,%extent,%key)						%ref(%extent),"keysubdepth",%key)
#define MAPKEY(%ref,%extent,%key)								%ref(%extent),$$$cMAPkey,%key)
#define MAPKEYassign(%ref,%extent,%key)							%ref(%extent),$$$cMAPkey,%key,"assign")
#define MAPKEYcardinality(%ref,%extent,%key)					%ref(%extent),$$$cMAPkey,%key,"cardinality")
#define MAPKEYidentity(%ref,%extent,%key)						%ref(%extent),$$$cMAPkey,%key,"identity")
#define MAPKEYidentitykeys(%ref,%extent,%key)					%ref(%extent),$$$cMAPkey,%key,"identitykeys")
#define MAPKEYidentitynames(%ref,%extent,%key)					%ref(%extent),$$$cMAPkey,%key,"identitynames")
#define MAPKEYidentitycardinality(%ref,%extent,%key)			%ref(%extent),$$$cMAPkey,%key,"identitycardinality")
	 
#define MAPKEYpropertyall(%ref,%extent,%key)					%ref(%extent),$$$cMAPkey,%key,"property")
#define MAPKEYproperty(%ref,%extent,%key,%keyseq)				%ref(%extent),$$$cMAPkey,%key,"property",%keyseq)
#define MAPKEYpropertyxform(%ref,%extent,%key,%keyseq)			%ref(%extent),$$$cMAPkey,%key,"property",%keyseq,"transformation")
#define MAPKEYextract(%ref,%extent,%key)						%ref(%extent),$$$cMAPkey,%key,"extract")
#define MAPKEYextractlvars(%ref,%extent,%key)					%ref(%extent),$$$cMAPkey,%key,"extractlvars")
#define MAPKEYtype(%ref,%extent,%key)							%ref(%extent),$$$cMAPkey,%key,"type")
	 
#define MAPKEYsqlsubscriptall(%ref,%extent,%key)				%ref(%extent),$$$cMAPkey,%key,"sqlsubscript")
#define MAPKEYsqlsubscript(%ref,%extent,%key,%subscript)		%ref(%extent),$$$cMAPkey,%key,"sqlsubscript",%subscript)
#define MAPKEYsqlsubscriptnames(%ref,%extent,%key)				%ref(%extent),$$$cMAPkey,%key,"sqlsubscriptnames")
#define MAPKEYsqlnames(%ref,%extent,%key)						%ref(%extent),$$$cMAPkey,%key,"sqlnames")
#define MAPKEYsqlwhere(%ref,%extent,%key)						%ref(%extent),$$$cMAPkey,%key,"sqlwhere")
	 
	
#define MAPidexpression(%ref,%extent)							%ref(%extent),"id","expression")
#define MAPidsubscripts(%ref,%extent)							%ref(%extent),"id","indexsubscripts")
#define MAPidtype(%ref,%extent)									%ref(%extent),"id","type")
#define MAPidkeyproperty(%ref,%extent,%property)				%ref(%extent),"id","property",%property)
#define MAPidlvarnew(%ref,%extent)								%ref(%extent),"id","lvarnew")
#define MAPidlvarexpr(%ref,%extent)								%ref(%extent),"id","lvarexpr")
	
#define MAPbinderyxxx(%ref,%extent,%key)						%ref(%extent),$$$cMAPbindery,%key)
#define MAPbinderyprop(%ref,%extent,%property)					%ref(%extent),$$$cMAPbindery,%property)
#define MAPbinderyproppred(%ref,%extent,%property)				%ref(%extent),$$$cMAPbindery,%property,"pred")
#define MAPbinderyproppredref(%ref,%extent,%property,%context)	%ref(%extent),$$$cMAPbindery,%property,"pred","lvar",%context)
#define MAPbinderyproppredexpr(%ref,%extent,%property,%context)	%ref(%extent),$$$cMAPbindery,%property,"pred","expr",%context)
#define MAPbinderypropxformcount(%ref,%extent,%property)		%ref(%extent),$$$cMAPbindery,%property,"xform")
#define MAPbinderypropxform(%ref,%extent,%property,%xform)		%ref(%extent),$$$cMAPbindery,%property,"xform",%xform)
#define MAPbinderypropxformref(%ref,%extent,%property,%xform,%context)	%ref(%extent),$$$cMAPbindery,%property,"xform",%xform,"lvar",%context)
#define MAPbinderypropxformexpr(%ref,%extent,%property,%xform,%context)	%ref(%extent),$$$cMAPbindery,%property,"xform",%xform,"expr",%context)
#define MAPbinderypropstorage(%ref,%extent,%property,%map,%element)		%ref(%extent),$$$cMAPbindery,%property,"store",%map,%element)
#define MAPbinderypropxxx(%ref,%extent,%property,%key)			%ref(%extent),$$$cMAPbindery,%property,%key)
#define MAPbinderypropXXX(%ref,%extent,%property,%key,%val)		%ref(%extent),$$$cMAPbindery,%property,%key,%val)
#define MAPbinderypropXXXxxx(%ref,%extent,%property,%key,%val,%sub)		%ref(%extent),$$$cMAPbindery,%property,%key,%val,%sub)
#define MAPbinderypropXXXXXXxxx(%ref,%extent,%property,%key,%val,%sub,%subsub)   %ref(%extent),$$$cMAPbindery,%property,%key,%val,%sub,%subsub)
#define MAPbinderySQLcolname(%ref,%extent,%property)			%ref(%extent),$$$cMAPbindery,%property,"colname")
#define MAPbinderySQLcolnbr(%ref,%extent,%property)				%ref(%extent),$$$cMAPbindery,%property,"colnbr")
	 
#define MAPcode(%ref,%extent)									%ref(%extent),$$$cMAPcode)
#define MAPcodeload(%ref,%extent)								%ref(%extent),$$$cMAPcode,"load")
#define MAPcodeinsert(%ref,%extent)								%ref(%extent),$$$cMAPcode,"insert")
#define MAPcodeupdate(%ref,%extent)								%ref(%extent),$$$cMAPcode,"update")
#define MAPcodedelete(%ref,%extent)								%ref(%extent),$$$cMAPcode,"delete")
	 
#define MAPmap(%ref,%extent)							   %ref(%extent),$$$cMAPmap)
	 
#define MAP(%ref,%extent,%map)							 %ref(%extent),$$$cMAPmap,%map)
#define MAPxxx(%ref,%extent,%map,%keyword)				 %ref(%extent),$$$cMAPmap,%map,%keyword)
#define MAPXXX(%ref,%extent,%map,%keyword,%key)			%ref(%extent),$$$cMAPmap,%map,%keyword,%key)
#define MAPXXXxxx(%ref,%extent,%map,%keyword,%key,%subkey) %ref(%extent),$$$cMAPmap,%map,%keyword,%key,%subkey)
#define MAPtype(%ref,%extent,%map)						 %ref(%extent),$$$cMAPmap,%map,$$$cMAPtype)
#define MAPmapindex(%ref,%extent,%type,%map)			   %ref(%extent),"mapindex",%type,%map)
	 
#define MAPsql(%ref,%extent)							   %ref(%extent),$$$cMAPsql)
#define MAPsqltablename(%ref,%extent)					  %ref(%extent),$$$cMAPsql,"table")
#define MAPsqlrowidname(%ref,%extent)					  %ref(%extent),$$$cMAPsql,"rowidname")
#define MAPsqlchildcounter(%ref,%extent)				   %ref(%extent),$$$cMAPsql,"childsub")
	 
#; These macros are for SQL Gateway (Remote SQL) primarily
#define MAPrsqlcountercolumn(%ref,%extent)				 %ref(%extent),$$$cMAPrsql,"counter")
#define MAPrsqlconnection(%ref,%extent)					%ref(%extent),$$$cMAPrsql,"connection")
#define MAPrsqlcolinfo(%ref,%extent,%property)			 %ref(%extent),$$$cMAPrsql,"colinfo",%property)
#define MAPrsqlcolinfoname(%ref,%extent,%property)		 %ref(%extent),$$$cMAPrsql,"colinfo",%property,"name")
#define MAPrsqlcolinfotype(%ref,%extent,%property)		 %ref(%extent),$$$cMAPrsql,"colinfo",%property,"type")
#define MAPrsqlprimarykey(%ref,%extent)					%ref(%extent),$$$cMAPrsql,"primarykey")
	 
#define PUSHNEWCOMMALIST(%list,%newlist) i %newlist'="" f i=1:1:$l(%newlist,",") $$$PUSHNEW(%list,$p(%newlist,",",i))
#define PUSHNEW(%list,%new)			  s new(%list,%new)=""
#define INITCODEQUEUE(%queue)			s lcode(%queue)=0
#define CODEQUEUESIZE(%queue)			+$g(lcode(%queue))
#define QUEUECODE(%queue,%line)		  s lcode(%queue)=lcode(%queue)+1,lcode(%queue,lcode(%queue))=%line
#define DEQUEUENEWLIST(%list)			s i=$o(new(%list,"")) i i'="" $$$GENERATE(" n "_i)  f  s i=$o(new(%list,i)) q:i=""  s %code(%code)=%code(%code)_","_i
#define DEQUEUECONDITIONALNEWLIST(%nest,%list) s i=$o(new(%list,"")) i i'="" $$$GENERATE(%nest_" n "_i)  f  s i=$o(new(%list,i)) q:i=""  s %code(%code)=%code(%code)_","_i
#define DEQUEUECODE(%queue)			  f i=1:1:$g(lcode(%queue)) $$$GENERATE(lcode(%queue,i))
#define DEQUEUEBLOCK(%queue,%prefix)  f i=1:1:$g(lcode(%queue)) $$$GENERATE(%prefix_lcode(%queue,i))
#define GENERATE(%line)               Set %code($increment(%code))=%line
#define QuoteName(%name)              $zutil(144,1,%name)
#define QN(%name)                     $select($zname(%name,6):%name,1:""""_$extract($zutil(144,1,"z"_%name),3,*))
#define QNC(%name)                    $select(%name[":":""""_$extract($zutil(144,1,"z"_%name),3,*),1:%name)
	 
#if 0   ; DLP773+		
#define LOCKtimeout									 5
#endif  ; DLP773-

#; Flo Graph code generation and symbol macros
#define SymbolReferenceStart							$Char(0)
#define SymbolReferenceEnd								$Char(0)
#define SymbolContextDelimiter							$Char(1)
#define SymbolReference(%arg,%context)					$$$SymbolReferenceStart_%arg_$Select(%context'="":$$$SymbolContextDelimiter_%context,1:"")_$$$SymbolReferenceEnd

#; #define SymbolReference(%arg,%context)					"{"_%arg_$Select(%context'="":"*"_%context,1:"")_"}"

#; Temporary symbols -only- Macros - these nodes are not set in the storage definition:

#define SYM(%ref,%extent)								%ref(%extent))
	 
#define SYMap(%ref,%extent)								%ref(%extent),$$$cSYMap)
#define SYMav(%ref,%extent)								%ref(%extent),$$$cSYMav)
#define SYMcollection(%ref,%extent)						%ref(%extent),$$$cSYMcollection)
#define SYMlogical(%ref,%extent)						%ref(%extent),$$$cSYMlogical)
	#;  This is a $List of the symbols on which the lock expressions are dependent (successors)
#define SYMlockdependency(%ref,%extent)					%ref(%extent),$$$cSYMlockdependency)
#define SYMmaxcol(%ref,%extent)							%ref(%extent),$$$cSYMmaxcol)
#define SYMreferencecounter(%ref,%extent)				%ref(%extent),$$$cSYMreferencecounter)
	
#define SYMCOLLECTION(%ref,%extent,%collection)			%ref(%extent),$$$cSYMcollection,%collection)
	
#define SYMKEY(%ref,%extent,%key)						%ref(%extent),$$$cSYMkey,%key)
#define SYMKEYcardinality(%ref,%extent,%key)			%ref(%extent),$$$cSYMkey,%key,$$$cSYMcardinality)
#define SYMKEYelement(%ref,%extent,%key)				%ref(%extent),$$$cSYMkey,%key,$$$cSYMelement)
#define SYMKEYnulls(%ref,%extent,%key)					%ref(%extent),$$$cSYMkey,%key,$$$cSYMnulls)
#define SYMKEYreference(%ref,%extent,%key)				%ref(%extent),$$$cSYMkey,%key,$$$cSYMreference)
	#; cSYMreferenceelements is the number of pipe delimited elements in this key
#define SYMKEYreferenceelements(%ref,%extent,%key)		%ref(%extent),$$$cSYMkey,%key,$$$cSYMKEYreferenceelements)
	
#define SYMKEYELEMENT(%ref,%extent,%key,%element)		%ref(%extent),$$$cSYMkey,%key,$$$cSYMelement,%element)
#define SYMKEYELEMENTnulls(%ref,%extent,%key,%element)	%ref(%extent),$$$cSYMkey,%key,$$$cSYMelement,%element,$$$cSYMnulls)
	#; Type is one of:
	#;	  a - attribute
	#;	  r - reference
	#;	  v - address variable
	#;	  x - expression
#define SYMKEYELEMENTtype(%ref,%extent,%key,%element)				 %ref(%extent),$$$cSYMkey,%key,$$$cSYMelement,%element,$$$cSYMtype)
	
#define SYMLOGICAL(%ref,%extent,%symbol)					   %ref(%extent),$$$cSYMlogical,%symbol)
	 
#define SYMSTORE(%ref,%extent,%store)						 %ref(%extent),$$$cSYMstore,%store)
#define SYMSTORExxx(%ref,%extent,%store,%keyword)			 %ref(%extent),$$$cSYMstore,%store,%keyword)
#define SYMSTOREaddress(%ref,%extent,%store)				  %ref(%extent),$$$cSYMstore,%store,$$$cSYMaddress)
#define SYMSTOREancestrystored(%ref,%extent,%store)		   %ref(%extent),$$$cSYMstore,%store,$$$cSYMancestry)
#define SYMSTOREclustertype(%ref,%extent,%store)			  %ref(%extent),$$$cSYMstore,%store,$$$cSYMclustertype)
#define SYMSTOREindex(%ref,%extent,%store)					%ref(%extent),$$$cSYMstore,%store,$$$cSYMindex)
#define SYMSTOREkey(%ref,%extent,%store)					  %ref(%extent),$$$cSYMstore,%store,$$$cSYMkey)
#define SYMSTOREname(%ref,%extent,%store)					 %ref(%extent),$$$cSYMstore,%store,$$$cSYMname)
#define SYMSTOREnode(%ref,%extent,%store)					 %ref(%extent),$$$cSYMstore,%store,$$$cSYMnode)
#define SYMSTOREserial(%ref,%extent,%store)				   %ref(%extent),$$$cSYMstore,%store,$$$cSYMserial)
#define SYMSTOREtype(%ref,%extent,%store)					 %ref(%extent),$$$cSYMstore,%store,$$$cSYMtype)
	
	#; Digraph temporary storage
#define DAG(%ref,%dag)									   %ref(%dag))
#define DAGbindery(%ref,%dag)								%ref(%dag),0)
#define DAGbindprefix(%ref,%dag)							 %ref(%dag),1)
#define DAGnode(%ref,%dag)								   %ref(%dag),2)
#define DAGiterator(%ref,%dag)							   %ref(%dag),3)
	#; The DAGbindery is a list of bound symbols and the expressions necessary to initialize
	#; the binding to the symbol value. When a symbol table contains entries in the bindery, those
	#; entries must be dequeued in to a code block and placed in the generated code prior to accessing
	#; any bound symbol in the generated code. Bindery entries are of two types - expression and code. An
	#; expression is dequeued in the form 's '_expression_","_expression... for as many expressions as will fit
	#; on a single line. Code is in the form of a counted array and will dequeue as lines of code. Any expression line
	#; being constructed will be dequeued before dequeuing a code block as order in the bindery is important.
#define DAGBIND(%ref,%dag,%bind)							 %ref(%dag),0,%bind)
#define DAGBINDexpression(%ref,%dag,%bind)				   %ref(%dag),0,%bind,0)
#define DAGBINDiterators(%ref,%dag,%bind)					%ref(%dag),0,%bind,1)
#define DAGBINDlvars(%ref,%dag,%bind)						%ref(%dag),0,%bind,2)
#define DAGBINDtoken(%ref,%dag,%bind)						%ref(%dag),0,%bind,3)
	
#define DAGNODE(%ref,%dag,%node)							 %ref(%dag),2,%node)
#define DAGNODEbindlvar(%ref,%dag,%node)					 %ref(%dag),2,%node,6)
#define DAGNODEbound(%ref,%dag,%node)						%ref(%dag),2,%node,7)
#define DAGNODEboundby(%ref,%dag,%node)					  %ref(%dag),2,%node,2)
#define DAGNODEisiterator(%ref,%dag,%node)				   %ref(%dag),2,%node,8)
#define DAGNODEiterators(%ref,%dag,%node)					%ref(%dag),2,%node,9)
#define DAGNODEneverbind(%ref,%dag,%node)					%ref(%dag),2,%node,1)
#define DAGNODEorder(%ref,%dag,%node)						%ref(%dag),2,%node,3)
#define DAGNODEpredecessor(%ref,%dag,%node)				  %ref(%dag),2,%node,4)
#define DAGNODEsuccessor(%ref,%dag,%node)					%ref(%dag),2,%node,5)
	
#define DAGNODEPRED(%ref,%dag,%node,%pred)				   %ref(%dag),2,%node,4,%pred)
#define DAGNODESUCC(%ref,%dag,%node,%succ)				   %ref(%dag),2,%node,5,%succ)
	
#define DAGITERATOR(%ref,%dag,%symbol)					   %ref(%dag),3,%symbol)
	
	#; Storage Definition iterators
#define FOREACHaddress(%ref,%extent,%address)				 s %address="" f  s %address=$o($$$EXTADDR(%ref,%extent,%address)) q:%address=""
#define FOREACHdatavalue(%ref,%extent,%sdef,%data,%value)	 s %value="" f  s %value=$o($$$SDEFDATAVAL(%ref,%extent,%sdef,%data,%value)) q:%value=""
	
#define FOREACHkeysymelement(%ref,%extent,%key,%element)	  s %element="" f  s %element=$o($$$SYMKEYELEMENT(%ref,%extent,%key,%element)) q:%element=""
	
#define FOREACHstore(%ref,%extent,%store)					 s %store="" f  s %store=$o($$$SYMSTORE(%ref,%extent,%store)) q:%store=""
	
	#; General purpose iterators
#define FOREACHcommaelement(%list,%counter,%element)		 f %counter=1:1:$l(%list,",") s %element=$p(%list,",",%counter) q:%element=""
