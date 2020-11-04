ROUTINE %occConstant [Type=INC]
#include %occExtent
	
#define NL                 $c(13,10)
#define TAB                " "
#define NULLOREF           ""
#define NULLOID            ""
	
#; Maximum lengths for various names. Some use the $zu(40,0,n) function, others are only defined here.
#define sysNameSizeGet(%f)		$zu(40,0,%f)
 
#define MAXRTNNAMELENGTH		$$$sysNameSizeGet(34)
#define MAXGLOBALNAMELENGTH		$$$sysNameSizeGet(35)
#define MAXVARIABLELENGTH		$$$sysNameSizeGet(36)
 
#define MAXNAMELENGTH       180
#define MAXPARAMLENGTH		180
#define MAXPARAMVALUE       32767
 
#define MAXLABELLENGTH			$$$sysNameSizeGet(37)
 
#; The CLASSID is the unique portion of a class name
#define MAXCLASSIDLENGTH		$$$sysNameSizeGet(38)
#; The PACKAGEID is the unique portion of the package name
#define MAXPACKAGEIDLENGTH		$$$sysNameSizeGet(39)

#; Maximum number of user defined methods
#define MAXCLASSMETHOD 2000
#define MAXSYSTEMMETHOD 16383
#; Maximum number of properties
#define MAXCLASSPROPERTY 1000
#; Maximum number of parameters
#define MAXCLASSPARAMETER 1000
#; Maximum number of foreign keys
#define MAXCLASSFKEY 400
#; Maximum number of indicies
#define MAXCLASSINDEX 400
#; Maximum number of queries
#define MAXCLASSQUERY 200
#; Maximum number of storage definitions
#define MAXCLASSSTORAGE 10
#; Maximum number of triggers
#define MAXCLASSTRIGGER 200
#; Maximum number of projections
#define MAXCLASSPROJECTION 200
#; Maximum number of xdata blocks
#define MAXCLASSXDATA 1000
#; Maximum number of constraints
#define MAXCLASSCONSTRAINT 200
#; Maximum depth of inheritance tree
#define MAXCLASSDEPTH 50
 
#define MAXCLASSNAMELENGTH 220
#define MAXSQLNAMELENGTH   128
 
#define MaxPieceNum *
#define MaxLocalLength $zutil(96,39)
#define MaxPartitionSize 9223372036854775808

	// LOCKtimeout is quoted for use in code generators and should not be used.
	// Rather, use the same macro defined in %msql.inc - LockTimeoutQ. Both are maintained
	// here for compatibility
#define LOCKtimeout                                     "$zu(115,4)"
#define LockTimeoutQ									"$zu(115,4)"

	// LockTimeout is for direct use. This definition is repeated in %msql.inc
#define LockTimeout										$zu(115,4)
	
#define NameForGet         "Get"
#define NameForSet         "Set"
#define DEFAULTLOCALE      "default"
	