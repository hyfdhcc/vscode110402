ROUTINE %occCPTSR [Type=INC]

#define STACK ^||%isc.cpt.rstack
#define STACKLAST $Order($$$STACK(""),-1)
#define STACKITEM(%index) ^||%isc.cpt.rstack(%index)
#define EMPTY ($$$STACKLAST="")
#define TOP $$$STACKITEM($$$STACKLAST)

#define STACKSTRLITTYPE "l"
#define STACKSTRLITITEM(%strlit) $ListBuild($$$STACKSTRLITTYPE,%strlit)
#define STACKNODETYPE "n"
#define STACKNODEITEM(%nodeindex) $ListBuild($$$STACKNODETYPE,%nodeindex)
#define STACKPGZTYPE "p"
#define STACKPGZITEM(%oldgzone) $ListBuild($$$STACKPGZTYPE,%oldgzone)
#define STACKFILLTYPE "f"
#define STACKFILLITEM $ListBuild($$$STACKFILLTYPE,"")
#define STACKOPTSPACETYPE "s"
#define STACKOPTSPACEITEM $ListBuild($$$STACKOPTSPACETYPE,"")

#define DOPUSHLIT(%lit,%pos) Do State.Push($$$STACKSTRLITITEM(%lit)_%pos)
#define DOPUSHNODE(%treeindex,%nodeindex) Do State.Push($$$STACKNODEITEM(%nodeindex)_$$$STARTPOSITION(%treeindex,%nodeindex))
#define DOPUSHOPTSPACE Do State.Push($$$STACKOPTSPACEITEM_$ListBuild("",""))
#define DORPUSHLIT(%lit,%pos) Do State.RPush($$$STACKSTRLITITEM(%lit)_%pos)
#define DORPUSHNODE(%treeindex,%nodeindex) Do State.RPush($$$STACKNODEITEM(%nodeindex)_$$$STARTPOSITION(%treeindex,%nodeindex))
#define DORPUSHOPTSPACE Do State.RPush($$$STACKOPTSPACEITEM_$ListBuild("",""))

#define STARTPOSITION(%treeindex,%nodeindex) $List($$$CPTNODESRCEXT(%treeindex,%nodeindex),1,2)
#define OFFSETSTARTPOSITION(%treeindex,%nodeindex,%offset) ##class(%CPT.Regen.Impl).AdjustStartPosition(TreeIndex,$$$CURRENTGZONE,$$$STARTPOSITION(%treeindex,%nodeindex),%offset)

#define ENDPOSITION(%treeindex,%nodeindex) $List($$$CPTNODESRCEXT(%treeindex,%nodeindex),3,4)
#define OFFSETENDPOSITION(%treeindex,%nodeindex,%offset) ##class(%CPT.Regen.Impl).AdjustEndPosition(TreeIndex,$$$CURRENTGZONE,$$$ENDPOSITION(%treeindex,%nodeindex),%offset)

#define HANCLASS(%language) "%CPT.Regen.Impl"_%language

#define FIRSTFOLLOWSSECOND(%lineno1st,%colno1st,%lineno2nd,%colno2nd) ((%lineno1st>%lineno2nd) || ((%lineno1st=%lineno2nd) && (%colno1st>%colno2nd)))

#define CURRENTGZONE (State.GetGlossZone())

#define LOGWRITE(%message,%dest) If $IsObject(%dest) {Set sc=%dest.WriteLine(%message) If $$$ISERR(sc) {ZTrap}} Else {Write %message,!}
#define LOGWRITEV(%message) $$$LOGWRITE(%message,LogDest)
#define LOGWRITEP(%message) $$$LOGWRITE(%message,..LogDest)

#define TRACEOUT(%message,%dest) If ..Trace {$$$LOGWRITE(%message,%dest)}
#define TRACEOUTV(%message) $$$TRACEOUT(%message,LogDest)
#define TRACEOUTP(%message) $$$TRACEOUT(%message,..LogDest)

