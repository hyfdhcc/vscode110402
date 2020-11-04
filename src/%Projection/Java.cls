/// This projection class generates the appropriate Java client code (using 
/// the Cach&eacute; Java Binding) for the associated class.<BR>
/// For more information refer to the <CLASS>%Projection.AbstractProjection</CLASS> class.
Class %Projection.Java Extends %Projection.AbstractProjection [ Abstract, System = 2 ]
{

/// The root directory in which generated files are written.
Parameter ROOTDIR;

/// When NEWCOLLECTIONS is set collection properties project as java.util.Map (for arrays) and Java.util.List (for lists).  
/// When NEWCOLLECTIONS is zero (the default) collection properties project as follows:
/// ArrayOfDataTypes for array of a datatypoe
/// ArrayOfObjects for array of an object
/// ListOfDataTypes for list of a datatype
/// ListOfObjects for list of an object
/// This parameter will be overriden by JAVATYPE if that is specified for property.
Parameter NEWCOLLECTIONS = 1;

/// When PRIMITIVEDATATYPES is set %Integer maps to int, %Float maps to double, %Boolean maps to boolean, and %BigInt maps to long
Parameter PRIMITIVEDATATYPES = 0;

/// Only generate dependency or class if timestamp of last compilation is greater than timestamp of last generation
Parameter MAKE = 0;

// Choose DOCUMATIC Host

Parameter DOCUMATICHOST;

/// Choose DOCUMATIC Port
Parameter DOCUMATICPORT;

/// Choose DOCUMATIC Namespace
Parameter DOCUMATICNAMESPACE;

/// Generation Type
/// 1 - legacy
/// 2 - generate class as implementing interface
Parameter GENERATIONTYPE = 1;

/// POJO mode
/// 0 - legacy
/// 1 - POJO on
Parameter POJO = 0;

/// CHECKUPTODATE
/// 0 - don't check if classes are up to date to project
/// 1 - do check if classes are up to date, useful for deploying final application
Parameter CHECKUPTODATE = 1;

/// JAVADOC
/// 0 - do NOT generate javadoc
/// 1 - generate javadoc (the default)
Parameter JAVADOC = 1;

/// RECURSIVE
/// 0 - do NOT generate dependencies
/// 1 - generate dependencies, default
Parameter RECURSIVE = 1;

/// PROJECTBYREFMETHODSTOPOJO
/// 0 - generate error when you try to project classes that contain methods with ByRef arguments to pojo implementation
/// 1 - project classes that contain methods with ByRef arguments to pojo implementation
Parameter PROJECTBYREFMETHODSTOPOJO = 0;

/// PROJECTBYREFMETHODSTOPOJO
/// 0 - generate error when you try to project classes that contain methods with abstract stream arguments or return type
/// 1 - project classes that contain methods with with abstract stream arguments or return type
Parameter PROJECTABSTRACTSTREAM = 0;

/// Generate serialVersionUID
Parameter GENSERIALUID = 1;

ClassMethod CreateProjection(classname As %String, ByRef parameters As %String) As %Status
{
 set $zt="CreateProjErr"
 ; 03/08/2012 - comment out lock
 ;Lock +^CacheTemp.oddBIND($ZU(5),classname):30 Else  Quit $$$ERROR($$$LGCacheLockTimeOut,classname)	
 do {
 s qspec=$g(parameters("%qstruct"))
 s Status=$$ProcessFormatFlag^%occLGUtil(qspec,.qspec) q:$$$ISERR(Status)
 s Status=$$$qualifierParse("Export",.qspec,.qstruct) q:$$$ISERR(Status) 
 s flag=""
 i +$g(parameters("JAVADOC"))=1 s flag=flag_"/javadoc=1"
 e  s flag=flag_"/javadoc=0"
 i +$g(parameters("CHECKUPTODATE"))=1 s flag=flag_"/checkuptodate=1"
 e  s flag=flag_"/checkuptodate=0"
 i +$g(parameters("NEWCOLLECTIONS"))=1 s flag=flag_"/newcollections=1"
 e  s flag=flag_"/newcollections=0"
 i +$g(parameters("PRIMITIVEDATATYPES"))=1 s flag=flag_"/primitivedatatypes=1"
 e  s flag=flag_"/primitivedatatypes=0"
 i +$g(parameters("POJO"))=1 s flag=flag_"/pojo=1"
 e  s flag=flag_"/pojo=0"
 i +$g(parameters("MAKE"))=1 s flag=flag_"/make=1"
 e  s flag=flag_"/make=0"
 s flag=flag_"/documatichost="_$g(parameters("DOCUMATICHOST"))
 s flag=flag_"/documaticport="_$g(parameters("DOCUMATICPORT"))
 s flag=flag_"/documaticnamespace="_$g(parameters("DOCUMATICNAMESPACE"))
 s flag=flag_"/generationtype="_$g(parameters("GENERATIONTYPE"))
 s flag=flag_"/recursive="_$g(parameters("RECURSIVE"))
 s flag=flag_"/projectbyrefmethodstopojo="_$g(parameters("PROJECTBYREFMETHODSTOPOJO"))
 s flag=flag_"/projectabstractstream="_$g(parameters("PROJECTABSTRACTSTREAM"))
 s flag=flag_"/genserialuid="_$g(parameters("GENSERIALUID"))
 s Node=$i(^CacheTemp)
 k ^CacheTemp(Node,"JavaProjection")
 ;w !,"before ExportJavaNode dump ^CacheTempCls"
 ;s i="" f  s i=$o(^CacheTempCls($J,"JavaProjection",i)) q:i=""  w !,i
 s ROOTDIR=..getROOTDIR(.parameters,"java")
 m ^CacheTemp(Node,"JavaProjection")=^CacheTempCls($J,"JavaProjection",ROOTDIR)
 if flag'="" Set sc=$$$qualifierAmend("Export",.qstruct,flag,.qstruct)
 s Status=##class(%Compiler.LG.JavaRoot).ExportJavaNode(classname,ROOTDIR,.qstruct,,Node,.paths)
 m ^CacheTempCls($J,"JavaProjection",ROOTDIR)=^CacheTemp(Node,"JavaProjection")
 ;w !,"after ExportJavaNode dump ^CacheTempCls"
 ;s i="" f  s i=$o(^CacheTempCls($J,"JavaProjection",i)) q:i=""  w !,i
 k ^CacheTemp(Node,"JavaProjection")
 } while (0) ;
 ; 03/08/2012 - comment out lock
 ;Lock -^CacheTemp.oddBIND($ZU(5),classname)#"I"
 q Status
CreateProjErr
	s $zt=""
	s Status=$$$ERROR($$$LGRoutineError,"CreateProjectionErr",$ze,classname)
	q Status
}

}
