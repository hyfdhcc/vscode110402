ROUTINE %DYNAMICDISPATCH [Type=INC]
#; Macros for use with Dynamic Dispatch
#; The class definition must have the line:
#; Include %DYNAMICDISPATCH

#; Throw the error <PROPERTY DOES NOT EXIST> *property,class
#define THROWNOPROPERTY(%property,%class) Do $ZU(96,3,149,1,"","property "_%property_" of class "_%class)

#; Throw the error <METHOD DOES NOT EXIST> *method,class
#define THROWNOMETHOD(%method,%class) Do $ZU(96,3,148,1,"","method "_%method_" of class "_%class)

#; Throw the error <UNDEFINED> *name
#define THROWUNDEFINED(%name) Do $ZU(96,3,9,1,%name)

#; Throw the error <ILLEGAL VALUE>
#define THROWILLEGALVALUE Do $ZU(96,3,78,1)
