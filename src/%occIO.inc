ROUTINE %occIO [Type=INC]
#; %occIO.inc
 
 
#; Macros to get current class and method at compile time. 
#define CurrentClass            $classname()
#define CurrentMethod           ##safeexpression(""""_$get(%methodname)_"""")
 
#; Macro to get a Parameter from another class at compile time
#define ClassParameter(%cls,%parm) ##safeexpression($$$comMemberKeyGet(%cls,$$$cCLASSparameter,%parm,$$$cPARAMdefault))
 
 