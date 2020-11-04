ROUTINE %syInfo [Type=INC]
#; Support for the SYS.Info package

#; Structural Macros
#define PROLOGUE Set tSC=$$$OK,$ZT="Trap",$ZE="" do {
#define EPILOGUE } while (0) ##continue
Exit Quit tSC ##continue
Trap Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE) Goto Exit

#; Creation Macros
#define NEW(%o,%c) Kill %objlasterror Set %o=$classmethod(%c,"%New") If '$IsObject(%o) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,%c)) Quit
#define NEW1(%o,%c,%a) Kill %objlasterror Set %o=$classmethod(%c,"%New",%a) If '$IsObject(%o) Set tSC=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,%c)) Quit

#; ServiceInfoManager library entry points
#define EnumProviders 		1
#define EnumInstallations 	2
#define EnumApplications    3

#define EnumeratorKey		0
#define DictionaryKey		1

#; Temporary value for testing
#define ServiceInfoLibraryPath (^%SYS("bindir")_"ServiceInfoManager.dll")