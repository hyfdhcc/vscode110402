ROUTINE %occCPTJSoldgen [Type=INC]

#; only used for the old 'Pig' JS code generator

#define ANNGEN(%annslot) $Get($$$CPTNODEANN(..TreeIndex,NodeIndex,%annslot))

#define CHILDGEN(%childslot) ..DispatchNode($$$CPTNODECHILD(..TreeIndex,NodeIndex,%childslot))

#define CHILDGENDLMLIST(%dlm) ..ChildList(NodeIndex,%dlm)

#define DUMPSTREAM(%stream)
#; #define DUMPSTREAM(%stream) ZTrap:$$$ISERR(%stream.Rewind())  Write:$X ! Write ! While '%stream.AtEnd {Write "<|",%stream.ReadLine(),"|>",!} Write ! ZTrap:$$$ISERR(%stream.Rewind())
#define RENDERTO(%item,%stream) If $IsObject(%item) {Do %item.RenderTo(%stream)} Else {Set sc=%stream.Write(%item) If $$$ISERR(sc) {$$$ThrowStatus(sc)} $$$DUMPSTREAM(%stream)}

#define DUMPTO(%item,%stream) If $IsObject(%item) {Do %item.DumpTo(%stream)} Else {Set sc=%stream.Write(##class(%XSQL.Format).QuoteCos(%item)) If $$$ISERR(sc) {$$$ThrowStatus(sc)} $$$DUMPSTREAM(%stream)}


