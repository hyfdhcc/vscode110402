ROUTINE %occCPTHPT [Type=INC]

#include %occCPTcommon

#;
#; exceptions
#define HPTTHROW(%message,%loadingstate) Break:$Data(%BREAK)  Throw ##class(%CPT.HPT.Exception).Create(..%ClassName()_": "_%message,%loadingstate)
#define HPTEXPRTHROW(%message,%loadingstate) ##class(%HPT.Exception).Throw(%message,%loadingstate)

#;
#; reader macros
#define HPTCURRENT(%currentlang,%lang,%attrname,%code) Set $ListBuild(%lang,%attrname,%code)=LoadingState.Current() $$$HPTTRACE(%currentlang,"R","Current",$$$HPTF($ListBuild(%attrname,%code)))
#define HPTCURRENTWS(%currentlang,%lang,%attrname,%code) Set $ListBuild(%lang,%attrname,%code)=LoadingState.Current(0) $$$HPTTRACE(%currentlang,"R","CurrentWS",$$$HPTF($ListBuild(%attrname,%code)))
#define HPTCURRENTFOR(%expectedlang,%attrname,%code) Set $ListBuild(%attrname,%code)=LoadingState.CurrentFor(%expectedlang) $$$HPTTRACE(%expectedlang,"R","CurrentFor",$$$HPTF($ListBuild(%attrname,%code)))
#define HPTCURRENTFORWS(%expectedlang,%attrname,%code) Set $ListBuild(%attrname,%code)=LoadingState.CurrentFor(%expectedlang,0) $$$HPTTRACE(%expectedlang,"R","CurrentForWS",$$$HPTF($ListBuild(%attrname,%code)))
#define HPTNEXT(%currentlang,%lang,%attrname,%code) Set $ListBuild(%lang,%attrname,%code)=LoadingState.Next() $$$HPTTRACE(%currentlang,"R","Next",$$$HPTF($ListBuild(%attrname,%code)))
#define HPTNEXTWS(%currentlang,%lang,%attrname,%code) Set $ListBuild(%lang,%attrname,%code)=LoadingState.Next(0) $$$HPTTRACE(%currentlang,"R","NextWS",$$$HPTF($ListBuild(%attrname,%code)))
#define HPTNEXTFOR(%expectedlang,%attrname,%code) Set $ListBuild(%attrname,%code)=LoadingState.NextFor(%expectedlang) $$$HPTTRACE(%expectedlang,"R","NextFor",$$$HPTF($ListBuild(%attrname,%code)))
#define HPTNEXTFORWS(%expectedlang,%attrname,%code) Set $ListBuild(%attrname,%code)=LoadingState.NextFor(%expectedlang,0) $$$HPTTRACE(%expectedlang,"R","NextForWS",$$$HPTF($ListBuild(%attrname,%code)))
#define HPTSKIPLINES(%attrname,%code) Set $ListBuild(,%attrname,%code)=LoadingState.SkipLines() $$$HPTTRACE("COS","R","SkipLines",$$$HPTF($ListBuild(%lang,%attrname,%code)))

#;
#; macros for %CPT.HPT.language... Accept methods

#; in the list returned from ParseNode:Accept this is used in place of a child to signal an injection-call
#define HPTINJECT(%childname) ("*"_%childname)
#define HPTISINJECT(%childname) ($Extract(%childname)="*")
#define HPTINJECTCHILD(%childname) ($Extract(%childname,2,*))

#; returning actions from the Accept method
#; -* NOTE: all these macros return from the current method *-
#define HPTACCEPTRETURN Set ..Progress="" Quit ""
#define HPTACCEPTCALL(%childname,%target,%progress) Set ..Progress=%progress Quit $ListBuild(%childname,%target)
#define HPTACCEPTINJECT(%childname,%target,%targetprogress) Set ..Progress="" Quit $ListBuild($$$HPTINJECT(%childname),%target,%targetprogress)

		
#define HPTGvnTypeNone 1
#define HPTGvnTypeName 2
#define HPTGvnTypeEnvBrackets 3
#define HPTGvnTypeEnvVBars 4
#define HPTGvnTypeEnvVBarsEmpty 5
#define HPTGvnTypeNaked 6


#; the current method name
#define METHODNAME ##safeexpression(""""_$Get(%methodname)_"""")


#; return the given (line,col) as (line,col-1) - col must be >1 (not checked here)
#define DECREMENTPOSCOL(%pos,%decr) $ListBuild($List(%pos),$List(%pos,2)-%decr)


#; PPG reference for LineBufferedStream class

#; global root
#define LBSG ^||%isc.cpt.linebufferedstream(..QueueKey)

#; a line
#define LBSL(%K) ^||%isc.cpt.linebufferedstream(..QueueKey,%K)

#; Show LineBufferedStream state if tracing includes "B"
#define LBSSHOW(%message) $$$HPTTRACE(0,"B",%message,..StateDump())

