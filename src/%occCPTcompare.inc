ROUTINE %occCPTcompare [Type=INC]
%occCPTcompare

#define DIFF(%orgstart,%orgend,%chgstart,%chgend) $ListBuild(0,%orgstart,%orgend,%chgstart,%chgend)
#define SAME(%orgstart,%orgend,%chgstart,%chgend) $ListBuild(1,%orgstart,%orgend,%chgstart,%chgend)

#define ORGSTART(%r) $List(%r)
#define ORGEND(%r) $List(%r,2)
#define CHGSTART(%r) $List(%r,3)
#define CHGEND(%r) $List(%r,4)

