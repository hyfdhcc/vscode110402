ROUTINE %callout [Type=INC]
#; Each application that is to use the callout functionality should increment the index here
#; and define a manifest constant for use with the new $ZF functions. The constant is passed
#; to a $ZF function along with the name of the library which implements the callouts. Cache
#; will create a dynamic association between the constant and the handle of the library. In
#; this manner, the library functions may be invoked by specifying the constant rather than
#; a dynamic handle or library name.
#define ActivateLibrary      1025
#define SaxLibrary           1026
#define SyntaxColorLibrary   1027
#define TSQLTransformLibrary 1028
#define XSLTLibrary          1029
#define ISQLTransformLibrary 1030
#define SSHLibrary           1031
#define COSCalloutLibrary    1032
#define JSRuntimeLibrary     1033
#define ServiceInfoLibrary   1034
#define DICOMLibrary	     1035
#define CacheSqlLibrary      1036
 
