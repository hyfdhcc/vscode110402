ROUTINE %occVersion [Type=INC]

#define PRODUCTVERSIONSTR 		$SYSTEM.Version.GetMajor()_"."_$SYSTEM.Version.GetMinor()_"."_$case($SYSTEM.Version.GetPoint(),"":0,:$SYSTEM.Version.GetPoint())_"."_$SYSTEM.Version.GetBuildNumber()
#define VERSIONSTRING                   "Cache Objects Version "_$$$PRODUCTVERSIONSTR
#define BUILDNUMBER			$SYSTEM.Version.GetBuildNumber()
 
#define CLASSDEFINITIONVERSION          25
#define ClassDefinitionVersionOnDisk    ^oddDEF
#define ClassDefinitionVersionOnDB(%db) ^|%db|oddDEF
#define SetCompatibleClassDefVersion    Do:($g(^oddDEF)'=$$$CLASSDEFINITIONVERSION) SetCompatibleClassDefVersion^%occVersion()
#; If ^oddDEF is not defined we will call SetCompatibleClassDefVersion, if it is still not defined then database must be read only so assume it is the latest version
#define IsClassDefVersionMatched(%flag) $$$SetCompatibleClassDefVersion s %flag=$g($$$ClassDefinitionVersionOnDisk,$$$CLASSDEFINITIONVERSION)=$$$CLASSDEFINITIONVERSION
