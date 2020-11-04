ROUTINE %occObject [Type=INC]
#include %occOptions
#include %occOID
 
#define objExists(%oref)                $isobject(%oref)
#define objIsValid(%oref)               $isobject(%oref)=1
#define objClassName(%oref)             $classname(%oref)
#define objClass                        $classname()
#define objOID(%oref)                   ##safeexpression($s($lg(%literalargs)="":"i%""%%OID""",1:$lg(%literalargs)_".""%%OID"""))
#define objIsUserCount(%oref)           0
 
#define CreateObject(%class)            $zobjnew(%class)
#define objModBit(%oref,%bit)           $zobjmod(%oref,%bit)
#define objModAll(%oref)                $system.CLS.GetModified(%oref)
#define objModAllSet(%oref,%value)      ##safeexpression($s($lg(%literalargs)="":"Do $system.CLS.SetModified("_$lg(%literalargs,2)_")",1:"Do $system.CLS.SetModified("_$lg(%literalargs)_","_$lg(%literalargs,2)_")"))
#define objNext(%oref)                  $zobjnext(%oref)
 
#define objOrefToInt(%oref)                 +%oref
#define objIntToOref(%int)                  $zobjref(%int)
#define IncrementReferenceCount(%oref)
#define SYSFUNCNULLOREF                     ""
#define objIncSysRefCount(%oref)            Do $zobjincref(%oref)
#define objDecSysRefCount(%oref)            Do $zobjdecref(%oref)
 
#define objReferenceCount(%oref)            $zobjcnt(%oref,0)
#define objReferenceList(%oref)
#define objReferenceListAdd(%a,%b)
#define objReferenceListRemove(%a,%b,%c)
#define objReferenceListRemoveNTV(%a,%b,%c)
#define objlistReferenceListAdd(%oref)
#define objlistReferenceListRemove(%oref,%temp)

#define objPropSlot(%oref,%prop)         $piece($system.CLS.Property(%prop,%oref,0),"^",2)
#define objPropRef(%oref,%prop)           ($zb(+$piece($system.CLS.Property(%prop,%oref,0),"^",3),16,1)=16)
#define objObjectIsLatestVersion(%oref)   ($piece($system.CLS.DumpContext(%oref),"^",11)'=0)
 
#define RemoveAllObjMemory               
#define RemoveAllActiveOid               
 
#define ActiveOidInsert(%oid,%oref)      Set $zobjoid("",$$$oidPrimary(%oid))=%oref
#define ActiveOidRemove(%oid,%oref)      Set $zobjoid("",$$$oidPrimary(%oid))=""
#define ActiveOidSearch(%oid,%oref)      Set %oref=$zobjoid($$$oidClassName(%oid),$$$oidPrimary(%oid))
#define ActiveOidModified(%oid,%oref)    Set %oref=$zobjoid($$$oidClassName(%oid),$$$oidPrimary(%oid)) If %oref'="" Do $system.CLS.SetModified(%oref,1)
#define SetOid(%class,%id,%oref)         Set $zobjoid(%class,%id)=%oref,.."%%OID"=$lb(%id_"",%class)
 
#define BindPutOref(%dev,%o) s t=$io u %dev i $zobjexport(%o_"",3)+$zobjexport($$$objOID(%o),3)+$zobjexport(%o,3)!1 u t
#define BindPutStr(%dev,%s) s t=$io u %dev i $zobjexport(%s_"",3)!1 u t
#define BindExportObj(%obj,%dev,%Seen,%reg,%depth,%caps,%sc) s sc=$$$OK i %depth'=0,%caps'=0 s %sc=%obj.%BindExport(%dev,.%Seen,%reg,%depth,%caps)
 
 
 