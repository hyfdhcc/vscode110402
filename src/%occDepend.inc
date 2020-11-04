ROUTINE %occDepend [Type=INC]
#; oddDEP
#define depClass(%depClass)				^oddDEP(%depClass)
#define depType(%depClass,%type)			^oddDEP(%depClass,%type)
#define depDependsOn(%depClass,%type,%class)	^oddDEP(%depClass,%type,%class)
#define depData(%depClass,%type,%class,%data)		^oddDEP(%depClass,%type,%class,%data)
#;
#define depTypeNext(%depClass,%type)		$o($$$depType(%depClass,%type))
#define depDependsOnNext(%depClass,%type,%class)		$o($$$depDependsOn(%depClass,%type,%class))
#define depDataNext(%depClass,%type,%class,%data)		$o($$$depData(%depClass,%type,%class,%data))
#;
#define rdepClass(%class)				^oddDEP(0,%class)
#define rdepType(%class,%type)			^oddDEP(0,%class,%type)
#define rdepDependsOn(%class,%type,%depClass)	^oddDEP(0,%class,%type,%depClass)
#define rdepData(%class,%type,%depClass,%data)		^oddDEP(0,%class,%type,%depClass,%data)
#;
#define rdepClassNext(%class)			$o($$$rdepClass(%class))
#define rdepTypeNext(%class,%type)		$o($$$rdepType(%class,%type))
#define rdepDependsOnNext(%class,%type,%depClass)		$o($$$rdepDependsOn(%class,%type,%depClass))
#define rdepDataNext(%class,%type,%depClass,%data)		$o($$$rdepData(%class,%type,%depClass,%data))
#; dependency types
#define depTYPEALL				-1
#define depTYPELIST				0
#define depTYPESQL				1
#define depTYPEINCLUDE			2
#define depTYPEPROPERTYCLASS	3
#define depTYPEINDEXCLASS		4
#define depTYPESUPERCLASS		5
#define depTYPECOMPILEAFTER		6
#define depTYPEPROPDATATYPE		7
#define depTYPEPARENT			8
#define depTYPEPROJECTION		9
#define depTYPEFKEY				10
#define depTYPECHILD			11
#define depTYPESUBCLASS			12
#define depTYPEQUERYCLASS		13
#define depTYPEDEPENDSON        14
#; Note we do not store this type, we rely on PROPDATATYPE but we use this to say what to scan for
#define depTYPEPROPPERSIST      15
#define depTYPEARGUMENT         16
#; dependency catagories
#define utdCOMPLETE				0
#define utdDESCRIPTION			1
#define utdSTRUCTURE			2
#define utdSQLSTRUCTURE         3
#; compile phases
#define precompile 1
#define midcompile 2
#define alldeptimes 3
#; data flags
#define dataflagBLANK 0
#define dataflagIGNORE -1
#;
#define depListContains(%list,%dep) ((","_%list_",")[(","_%dep_","))
#define appendDepType(%current,%deptype) Set %current = $s($g(%current)="":%deptype,'$$$depListContains(%current,%deptype):%current_","_%deptype,1:%current)
#define isSysOrPercent(%class) (("^"_$piece($zutil(90,22,"","oddDEF",%class),"^",2,3))=$get(^%SYS("DBRefByName","CACHELIB")))
#define GBLDB(%ref) $$GetGlobalSourceDatabase^%SYS.SECURITY($name(%ref))
#def1arg GBLDBREF(%args) ("^"_$piece($zutil(90,22,"",%args),"^",2,3))
#def1arg GBLDBREFNS(%args) ("^"_$piece($zutil(90,22,%args),"^",2,3))
#define DEPENDENCYFLAGBYTYPE(%type)	$case(%type,"":$$$utdDESCRIPTION,$$$depTYPESQL:$$$utdSQLSTRUCTURE,$$$depTYPEPARENT:$$$utdSTRUCTURE,$$$depTYPECHILD:$$$utdSQLSTRUCTURE,$$$depTYPEFKEY:$$$utdSTRUCTURE,:$$$utdDESCRIPTION)
#define depTYPETOSTRING(%type) $case(%type,$$$depTYPEALL:"all",$$$depTYPELIST:"list",$$$depTYPESQL:"sql",$$$depTYPEINCLUDE:"include",$$$depTYPEPROPERTYCLASS:"propertyclass",$$$depTYPEQUERYCLASS:"queryclass",$$$depTYPEINDEXCLASS:"indexclass",$$$depTYPESUPERCLASS:"superclass",$$$depTYPECOMPILEAFTER:"compileafter",$$$depTYPEPROPDATATYPE:"propertydatatype",$$$depTYPEPARENT:"parent",$$$depTYPECHILD:"child",$$$depTYPEPROJECTION:"projection",$$$depTYPEFKEY:"foreignkey",$$$depTYPESUBCLASS:"subclass",$$$depTYPEDEPENDSON:"dependson",:"unknown")
#;
#define DEFroot ^oddDEF
#define incIsSystemInclude(%include) ''$lf($lb("%occCompiler","%occCacheDirect","%occExtent","%occTransaction","%occInclude","%msql","%cspInclude","%occReference"),%include)