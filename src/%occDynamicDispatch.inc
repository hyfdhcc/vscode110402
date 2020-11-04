ROUTINE %occDynamicDispatch [Type=INC]
#include %syGluedef
#;
#; Macros for use with dynamic dispatch
#; 
#; Use this macro to force a <METHOD DOES NOT EXIST> error for the named method and class
#define ThrowMethodDoesNotExistError(%method) Do $ZU(96,3,$$$ERNOMETHOD,1,"","method "_%method_" of class "_$classname())
#;
#; Use this macro to force a <PROPERTY DOES NOT EXIST> error for the named property and class
#define ThrowPropertyDoesNotExistError(%property) Do $ZU(96,3,$$$ERNOPROPERTY,1,"","property "_%property_" of class "_$classname())