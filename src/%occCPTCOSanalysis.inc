ROUTINE %occCPTCOSanalysis [Type=INC]

#include %occCPTconfig


#; conditions
#define CPTNONECOND ##class(%CPT.COS.Analysis.Condition.Abstract).NoneCondition()
#define CPTEXPRCOND(%treeindex,%langnode,%selectif) ##class(%CPT.COS.Analysis.Condition.Expression).%New(%treeindex,%langnode,%selectif)
#define CPTEXPRORNONECOND(%treeindex,%langnode,%selectif) $Select(%langnode:$$$CPTEXPRCOND(%treeindex,%langnode,%selectif),1:$$$CPTNONECOND)

#define CPTPOSTCONDCOND(%lhs,%postcond) If %postcond {Set %lhs=##class(%CPT.COS.Language.Abstract).LangNode(..TreeIndex,%postcond)} Else {Set %lhs=$$$NULLOREF}


#; tracing/reporting
#;
#; possible flags (comma-separated in CAREPORTCONFIG setting) :-
#;  N: narrative
#;  W: warnings
#;  D*: for debugging :-
#;   DNBB: debug Builder:NextBasicBlock
#;   DPPR: debug Builder Push/Pop-reader methods
#;   DAOET: debug Command.Abstract:AddOutEdgeTo
#;   DAOE: debug BasicBlock:AddOutEdge
#;   DST: debug symbol table
#;  G*: for graphs :-
#;   GEC: include conditions in edges
#;   GNC: include code in nodes
#;
#define CPTCAREPORTCONFIG $$$GETCONFIG("COS","CAREPORTCONFIG")
#define CPTCAREPORTIF(%flag) (","_$$$CPTCAREPORTCONFIG_",")[(","_%flag_",")

#if $$$HPTDEBUGENABLED
#define CPTCAREPORT(%flag,%message) If $$$CPTCAREPORTIF(%flag) {Write:$X ! Write %flag,"| ",%message,!}
#else
#define CPTCAREPORT(%flag,%message)
#endif


#; graph formatting
#define CPTGRAPHNODEWIDTH 20
#define CPTGRAPHNODELENGTH 80
#define CPTGRAPHEDGEWIDTH 20


#; public array for %CPT.COS.*
#define CPTCOSVARS %CPTCOSVARS
#define CPTCOSVARNONECOND %CPTCOSVARS("NoneCondition")


#; language nodes registry (treeindex is implicit)
#define CPTLANGNODESCOUNT %CPTCOSVARS("LangNodes")
#define CPTADDLANGNODE If $I(%CPTCOSVARS("LangNodes")) {}
#define CPTLANGNODES(%nodeindex) %CPTCOSVARS("LangNodes",%nodeindex)
#define CPTINITLANGNODES Kill %CPTCOSVARS("LangNodes")
