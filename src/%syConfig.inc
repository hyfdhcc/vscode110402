ROUTINE %syConfig [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;RFD1610 12/03/15 Rob Davis, add list of all CPF classes for EM use
#;SML2138  9/15/15 Simon Li, Support default database for SLM mapping in %ALL namespace.
#;STC2455  8/12/15 Steve Clay, Add Config.Shards classes 
#;SML2049  4/21/15 Simon Li, Add compression modes in Config.Mirrors, update version to 2015.3.
#;STC2389 03/10/15 Steve Clay, Add SQL parameters to CPF file
#;STC2331 09/04/14 Steve Clay, Update version to 2015.1
#;STC2245 09/05/13 Steve Clay, Allow portal on VMS to create namespace mappings
#;STC2210 06/04/13 Steve Clay, Update CPF file to version 2014.1
#;STC2121 09/11/12 Steve Clay, Add Path= parameter to the CPF file; update version to 2013.1
#;STC2074 04/03/12 Add [Conversions] section, update to version 2012.2
#;RJW2001 01/18/12 Ron Watt, Allow SuperServer to bind to specific IP address
#;JO2452   7/26/11 Jeffrey Orlin, add [Mirrors] and [MapMirrors.*]
#;SML1372  7/15/11 Simon Li, Fix when STU failed before namespace is reloaded.
#;STC1884 02/09/11 Steve Clay, Remove (and add) parameters from the CPF file
#;STC1831 08/16/10 Steve Clay, Suppress CPF conversion messages to cconsole.log 
#;SML1229 08/11/10 Simon Li, Fix mapping when System DB location is changed.
#;STC1796 05/07/10 Steve Clay, Add [Shadows] section to the CPF file
#;STC1547 02/20/08 Steve Clay, Allow DDP servers to be configured in CPF file
#;SML1092 12/10/08 Simon Li, Avoid some default system DB been added to backup DB list during installation.
#;SML1081 11/24/08 Simon Li, Support single namespace activation and reduce usage of mapping memory.
#;STC1496 11/17/08 Fix ERROR #5814: Oid previously assigned during Config save 
#;STC1468 10/15/08 Update LegacyNetConn CPF parameter automatically
#;STC1440 08/27/08 Update CPF file with new fields 
#;STC1296 02/21/08 Initial version
#endif  /*=====================End Maintenance======================*/
#if 0
#;define CONFIG1(%CPFName) ^|$$$SecurityMapGroup|SYS("CONFIG",%CPFName)
#;define CONFIG2(%CPFName,%Section) ^|$$$SecurityMapGroup|SYS("CONFIG",%CPFName,%Section)
#;define CONFIG3(%CPFName,%Section,%Name) ^|$$$SecurityMapGroup|SYS("CONFIG",%CPFName,%Section,%Name)
#;define CONFIG2EXTENDEDREF(%CPFName,%Section) ^|$$$SecurityMapGroup|SYS("CONFIG",%CPFName,%Section)
#;define CONFIG3EXTENDEDREF(%CPFName,%Section,%Name) ^|$$$SecurityMapGroup|SYS("CONFIG",%CPFName,%Section,%Name)
#else
#define CONFIG1(%CPFName)$$$SecurityMapGlobal("CONFIG",%CPFName)
#define CONFIG2(%CPFName,%Section) $$$SecurityMapGlobal("CONFIG",%CPFName,%Section)
#define CONFIG3(%CPFName,%Section,%Name) $$$SecurityMapGlobal("CONFIG",%CPFName,%Section,%Name)
#define CONFIG4(%CPFName,%Section,%Name,%Map) $$$SecurityMapGlobal("CONFIG",%CPFName,%Section,%Name,%Map)
#define CONFIG2EXTENDEDREF(%CPFName,%Section) $$$SecurityMapGlobal("CONFIG",%CPFName,%Section)
#define CONFIG3EXTENDEDREF(%CPFName,%Section,%Name) $$$SecurityMapGlobal("CONFIG",%CPFName,%Section,%Name)
#endif
#define CPFTimeStamp "CPFTimeStamp"
#define CPFFile "CPFFile"

#define CONFGLO ^CONFIG
#define CONFGLONAM "^CONFIG"

#;List of valid sections in the CPF file. Keep this in the same order as the
#;RequiredSections and writeorder below. Note the [Map.] and [MapShadows.] sections are handled separately.
#define Sections ",ConfigFile,Shards,ECPServers,Databases,Namespaces,Mirrors,MapMirrors,MirrorMember,MirrorAsyncMemberSources,MirrorAsyncMemberAuthorizedIDs,Journal,Shadows,Startup,DeviceSubTypes,Devices,MagTapes,config,Miscellaneous,ECP,Cluster,LicenseServers,Monitor,IO,SQL,SqlSysDatatypes,SqlUserDatatypes,Telnet,ComPorts,Debug,Conversions,"
#define MapSection "Map."
#define MapShadowsSection "MapShadows."
#define MapMirrorsSection "MapMirrors."
#define RequiredSections "ConfigFile,Databases,Namespaces,MirrorMember,Journal,Startup,DeviceSubTypes,Devices,config,Miscellaneous,ECP,Cluster,Monitor,IO,SQL,SqlSysDatatypes,Telnet"
 
#;Order which the sections are written out to the CPF file. Also the order
#;in which the Active configuration is updated.
#define CPFWriteOrder "ConfigFile","Shards","ECPServers","Databases","Namespaces","Map","Mirrors","MapMirrors","MirrorMember","MirrorAsyncMemberSources","MirrorAsyncMemberAuthorizedIDs","Journal","Shadows","MapShadows","Startup","DeviceSubTypes","Devices","MagTapes","config","Miscellaneous","ECP","Cluster","LicenseServers","Monitor","IO","SQL","SqlSysDatatypes","SqlUserDatatypes","Telnet","ComPorts","Debug","Conversions"
#;List of all Classes used to write the CPF file. Similar to CPFWriteOrder, but includes individual Map classes (and any others)
#define CPFClasses "ConfigFile","Shards","ECPServers","Databases","Namespaces","MapGlobals","MapRoutines","MapPackages","MapShards","Mirrors","MapMirrors","MirrorMember","MirrorAsyncMemberSources","MirrorAsyncMemberAuthorizedIDs","Journal","Shadows","MapShadows","Startup","DeviceSubTypes","Devices","MagTapes","config","Miscellaneous","ECP","Cluster","LicenseServers","Monitor","IO","SQL","SqlSysDatatypes","SqlUserDatatypes","Telnet","ComPorts","Debug","Conversions"
 
#;Sections which have a bunch of different properties in them
#define SinglePropertySections "ConfigFile,config,Mirror,MirrorMember,Journal,Startup,Miscellaneous,ECP,Cluster,Monitor,IO,SQL,Telnet,Conversions"
 
#define CPFCurrentVersion "2015.3"
#;Used as an index while building or updating CPF files.
#define CPFTMPSuffix ("_"_(+$j))
 
#define CPFMappingsFileSuffix "_MAPPINGSFILE"
 
#define CPFRoutineTypeALL "ALL"
#define CPFValidRoutineTypes "MAC,INT,INC,OBJ"
 
#define OldLineDelim " ;;;"
#define OldLineDelimLen $l($$$OldLineDelim)

#;Comment definitions
#define BeginMultiLineComment "/*"
#define CommentContinuationChar "-"
#define CommentNextSectionChar "&"
#define EndMultiLineComment "*/"
#define CommentDelim "#,;,//,"_$$$BeginMultiLineComment
#;define DefaultCommentDelim "#"
#define CPFMaxCommentLength 4096
 
#;Argument for the Flags parameter in the Config Methods
#define CPFSave     1
#define CPFWrite    2
#define CPFActivate 4 
#define CPFImport   1024
#define CPFCreateDefault   2048
#define CPFAlreadyOpen   4096
#;SML1092 ; Don't add this created/Deleted DB in the backup DB list.
#define CPFAvoidBackupDB 8192
#define CPFIgnoreEMSSubscriptions 16384
#define CPFLogMessages 32768
 
#;Arguments to the Config.CPF.GetErrorText() method 
#define ErrorTextToScreen  1
#define ErrorTextToConsole 2
#define ErrorTextToArray   4
 
#;Arguments to Flags parameter in Config.CPF.Read method
#define CPFReadValidateOnly  1
#define CPFReadForceRead     2
#define CPFReadStartup		1024
 
#;Keywords in the CPF file for the different type of mappings in the [Map.] sections
#define CPFMapGlobalKey "Global_"
#define CPFMapRoutineKey "Routine_"
#define CPFMapPackageKey "Package_"
#define CPFMapShardKey "Shard_"
#define CPFMapGlobalKeyU "GLOBAL_"
#define CPFMapRoutineKeyU "ROUTINE_"
#define CPFMapPackageKeyU "PACKAGE_" 
#define CPFMapShardKeyU "SHARD_" 

#define DEFETHDEV $s($$$ISWINDOWS:"ie1",1:$p($zu(114,1),$c(1)))
#define DEFETHADDR $zu(114,0)
#define HOST2IP(%h) $p($zu(54,13,%h),",")
#define LOCALHOST $zu(54,0)
#define DEFUDPADDR $$$HOST2IP($$$LOCALHOST)
#define DEFIdTrxFrom "~ `!@#$%^&*()_+-=[]\{}|;':"",./<>?"

#;Dummy namespace definition
#define NamespaceALL "%ALL"
#;List of namespaces which don't get the %ALL mapping
#define MapNamespaceALL(%Namespace) (",%CACHELIB,SAMPLES,DOCBOOK,"'[(","_%Namespace_","))
#;SML2138+ 
#;Dummy database definition for %ALL namespace
#define DefaultDBALL "%DEFAULTDB"
#;SML2138-
#define INSTALLDIR              $zutil(12,$select($$$isUNIX:$translate($System.Util.InstallDirectory(),"\","/"),$$$isWINDOWS&&($translate($System.Util.InstallDirectory(),"/","\")'["\"):$System.Util.InstallDirectory()_"\",1:$System.Util.InstallDirectory()),1,1)
#define LASTGOODNAME            ($$$INSTALLDIR_"_LastGood_.cpf")
 
#;The following are the offsets in the CPF Config.SQL object record
#define AllowRowIDUpdate 2
#define Comment 3
#define DBMSSecurity 4
#define DDLNo30 5
#define DDLNo201 6
#define DDLNo307 7
#define DDLNo311 8
#define DDLNo315 9
#define DDLNo324 10
#define DDLNo333 11
#define DDLSQLOnlyCompile 12
#define DefaultSchema 13
#define DelimitedIds 14
#define DropDelete 15
#define ExtrinsicFunctions 16
#define FastDistinct 17
#define IdKey 18
#define IdTrxFrom 19
#define IdTrxTo 20
#define JavaClassPath 21
#define JavaHome 22
#define JDBCGatewayAddress 23
#define JDBCGatewayLog 24
#define JDBCGatewayPort 25
#define LockThreshold 26
#define LockTimeout 27
#define ODBCVarcharMaxlen 28
#define Prefix 29
#define QueryProcedures 30 
#define ReferentialChecks 31
#define SaveMAC 32
#define TCPKeepAlive 33
#define TimePrecision 34
#define TODATEDefaultFormat 35
#define ECPSync 36
#define JDBCGatewayJVMArgs 37
#define BiasQueriesAsOutlier 38
#define DDLDefineBitmapExtent 39
#define DDLFinal 40
#define DDLUseSequence 41

#;The following are offsets in the Config.SQLSysDatatypes and 
#;Config.SQLUserDatatypes CPF object record
#define SQLSysDatatype 2
#define SQLUserDatatype 2

#;SML1081+
#; The limit of modified NS for namespace configuration to reload all.
#define ReloadAllLimit	100
#; Whether we need to compare the old ^CONFIG node with the new ^CONFIG node
#; for namespace in MoveToActive methods.
#define	NSCheckReload	($d($$$SecurityMapGlobal("STUInProgress"))&&($g($$$SecurityMapGlobal("NSRELOAD"))<$$$ReloadAllLimit))
#define NSCheckReloadNS(%Namespace) $$$SecurityMapGlobal("NSRELOAD",%Namespace)
#;SML1229 ; Clear %f if counter is over the limit.
#define NSAddToReload(%ns,%f) S $$$SecurityMapGlobal("NSRELOAD")=$s(%ns=$$$NamespaceALL:$$$ReloadAllLimit,1:$s($d($$$SecurityMapGlobal("NSRELOAD",%ns)):$G($$$SecurityMapGlobal("NSRELOAD")),1:$g($$$SecurityMapGlobal("NSRELOAD"))+1)),$$$SecurityMapGlobal("NSRELOAD",%ns)="",%f=(%ns'=$$$NamespaceALL&&($g($$$SecurityMapGlobal("NSRELOAD"))<$$$ReloadAllLimit))
#;SML1081-
#;SML1372 ; Add namespace to the list caused by DB configuration change during non-STU.
#define NSAddToReloadNonSTU(%ns,%f) S ^||%ISC.NS("NSRELOAD")=$s(%ns=$$$NamespaceALL:$$$ReloadAllLimit,1:$s($d(^||%ISC.NS("NSRELOAD",%ns)):$G(^||%ISC.NS("NSRELOAD")),1:$g(^||%ISC.NS("NSRELOAD"))+1)),^||%ISC.NS("NSRELOAD",%ns)="",%f=(%ns'=$$$NamespaceALL&&($g(^||%ISC.NS("NSRELOAD"))<$$$ReloadAllLimit))
