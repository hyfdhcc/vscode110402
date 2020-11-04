ROUTINE %occCodeGen [Type=INC]
#define COMPILERstatus                          qastatus
#define COMPILERstatusOK                        +$g($$$COMPILERstatus)
#define setCOMPILERstatusOK                     s $$$COMPILERstatus=1
  
#define GENERATE(%code,%line)                   s %code=$g(%code)+1,%code(%code)=%line
 
#; Code Generation Sets         
#define CODESET                                 ^%qCacheObjectCDL
#define CODESETrule                             ^%qCacheObjectCDL(1)
#define CODESETsnip                             ^%qCacheObjectCDL(2)
 
#define RULE(%ruleid)                           ^%qCacheObjectCDL(1,%ruleid)
#define gRULE(%ruleid)                          $g($$$RULE(%ruleid))
#define getRULE(%ruleid,%rule)                  s %rule=$$$gRULE(%ruleid)
#define setRULE(%ruleid,%rule)                  s $$$RULE(%ruleid)=%rule
#define appendRULE(%ruleid,%rule)               s $$$RULE(%ruleid)=$$$gRULE(%ruleid)_%rule
  
#define SNIP(%snipid)                           ^%qCacheObjectCDL(2,%snipid)
#define gSNIP(%snipid)                          $g($$$SNIP(%snipid))
#define setSNIP(%snipid,%snip)                  s $$$SNIP(%snipid)=%snip
  
#define getSNIP(%snipid,%snip)                  s %snip=$$$gSNIP(%snipid)
 
#; Token sequence type
#define zfNODE                                  1
#define zfCHILD                                 2
#define zfERROR                                 9
 
#; Rule numbers
#define zrCREATECLASS                           5120
  
#; Parse Tree Structure Defining Macros
#; NEW STRUCTURES...
#define tPT(%tree)                              ^CacheTemp(%tree
 
#define PARSETREEincrement                      ^CacheTemp
#define PARSETREE(%tree)                        ^CacheTemp(%tree)
#define PARSETREEcode(%tree)                    $$$tPT(%tree),3)
#define PARSETREEdirectives(%tree)              $$$tPT(%tree),6)
#define PARSETREEfunction(%tree)                $$$tPT(%tree),5)
#define PARSETREEheadnode(%tree)                $$$tPT(%tree),0)
#define PARSETREEnode(%tree)                    $$$tPT(%tree),1)
#define PARSETREEroutine(%tree)                 $$$tPT(%tree),7)
#define PARSETREEstack(%tree)                   $$$tPT(%tree),2)
#define PARSETREEtag(%tree)                     $$$tPT(%tree),4)
 
#define CODEattrib(%tree,%node)                 $$$tPT(%tree),3,%node)
#define CODESEQ(%tree,%node,%seq)               $$$tPT(%tree),3,%node,%seq)
 
#define CODESEQLINE(%tree,%node,%seq,%line)     $$$tPT(%tree),3,%node,%seq,%line)
#define CODESEQLINEref(%tree,%node,%seq,%line)  $$$tPT(%tree),3,%node,%seq,%line,"r")
 
#; Directives
#define DIRECTIVESsize(%tree)                   $$$tPT(%tree),6,"size")
#define DIRECTIVESLINE(%tree,%line)             $$$tPT(%tree),6,%line)
 
#; Function definitions
#define FUNCTION(%tree,%function)               $$$tPT(%tree),5,%function)
#define FUNCTIONname(%tree,%function)           $$$tPT(%tree),5,%function,"n")
#define FUNCTIONformal(%tree,%function)         $$$tPT(%tree),5,%function,"f")
#define FUNCTIONroutine(%tree,%function)        $$$tPT(%tree),5,%function,"r")
#define FUNCTIONsize(%tree,%function)           $$$tPT(%tree),5,%function,"s")
 
#define FUNCTIONLINE(%tree,%function,%line)     $$$tPT(%tree),5,%function,%line)
#define FUNCTIONLINEref(%tree,%function,%line)  $$$tPT(%tree),5,%function,%line,"r")
 
#define PTNODE(%tree,%node)                     $$$tPT(%tree),1,%node)
#define PTNODEparent(%tree,%node)               $list($$$PTNODE(%tree,%node),2)
 
#define PTNODECHILD(%tree,%parent,%child)       $$$tPT(%tree),1,%parent,%child)
 
#define RTN(%tree,%rtn)                         $$$tPT(%tree),7,%rtn)
#define RTNLINE(%tree,%rtn,%line)               $$$tPT(%tree),7,%rtn,%line)
 
#define STACK(%tree)                            $$$PARSETREEstack(%tree)
#define STACKNODE(%tree,%stacknode)             $$$tPT(%tree),2,%stacknode)
 
 
#define InitializeStack(%tree)                  k $$$STACK(%tree) s $$$STACK(%tree)=""
#define PushStack(%tree,%node)                  s $$$STACK(%tree)=$$$STACK(%tree)+1,$$$STACKNODE(%tree,$$$STACK(%tree))=%node
#define PopStack(%tree)                         k $$$STACKNODE(%tree,$$$STACK(%tree)) s $$$STACK(%tree)=$$$STACK(%tree)-1
  
  
#; Code Queue Accessors/Mutators
#define codeSEQExist(%tree,%node)               $d($$$CODEattrib(%tree,%node))
#define dropCodeSeqAll(%tree,%node)             k $$$CODEattrib(%tree,%node)
#define dropCodeSeq(%tree,%node,%seq)           k $$$CODESEQ(%tree,%node,%seq)
 
#; Directives Accessors/Mutators
#define setDIRECTIVESline(%tree,%line)          s $$$PARSETREEdirectives(%tree)=$g($$$PARSETREEdirectives(%tree))+1,$$$DIRECTIVESLINE(%tree,$$$PARSETREEdirectives(%tree))=%line,$$$DIRECTIVESsize(%tree)=$g($$$DIRECTIVESsize(%tree))+$l(%line)
 
#; Function maniuplators
#define setFUNCTIONline(%tree,%function,%line)                s $$$FUNCTION(%tree,%function)=$g($$$FUNCTION(%tree,%function))+1,$$$FUNCTIONLINE(%tree,%function,$$$FUNCTION(%tree,%function))=%line,$$$FUNCTIONsize(%tree,%function)=$g($$$FUNCTIONsize(%tree,%function))+$l(%line)
#define setFUNCTIONlineREF(%tree,%function,%line,%references) s $$$FUNCTIONLINEref(%tree,%function,%line)=%references
 
#; Parse Tree accessors/mutators
#define addNode(%tree,%node,%label,%visit)      s $$$PTNODE(%tree,%node)=$lb(%label,"","",%visit)
#define dropNode(%tree,%node)                   k $$$PTNODE(%tree,%node)
#define nodeLabel(%tree,%node)                  $list($$$PTNODE(%tree,%node),1)
#define nodeOrder(%tree,%parent)                $list($$$PTNODE(%tree,%parent),3)
#define addChild(%tree,%parent,%child,%action)  s $$$PTNODECHILD(%tree,%parent,%child)=%action,$$$nodeOrder(%tree,%parent)=$$$nodeOrder(%tree,%parent)+1,$$$PTNODEparent(%tree,%child)=%parent
#define ascentRule(%tree,%parent,%child)        $p($$$PTNODECHILD(%tree,%parent,%child),"<",1)
#define descentRule(%tree,%parent,%child)       $p($$$PTNODECHILD(%tree,%parent,%child),"<",2)
#define visitRule(%tree,%node)                  $list($$$PTNODE(%tree,%node),4)
#define dropChild(%tree,%parent,%child)         s $$$nodeOrder(%tree,%parent)=$$$nodeOrder(%tree,%parent)-1 k $$$PTNODECHILD(%tree,%parent,%child)
#define setAttrib(%tree,%node,%attrib,%val)     s $list($$$PTNODE(%tree,%node),4+%attrib)=%val
#define getAttrib(%tree,%node,%attrib)          $lg($$$PTNODE(%tree,%node),4+%attrib)
#define getAttribAll(%tree,%node)               $list($$$PTNODE(%tree,%node),5,$ll($$$PTNODE(%tree,%node)))
#define attribCount(%tree,%node)                $ll($$$PTNODE(%tree,%node))-4
 
#; Tag Counter accessor/mutators
#define TAGcounterINIT(%tree)                   s $$$PARSETREEtag(%tree)=""
#define bumpTAGcounter(%tree)                   s $$$PARSETREEtag(%tree)=$$$PARSETREEtag(%tree)+1
#define getTAG(%tree,%tag)                      $$$bumpTAGcounter(%tree) s %tag=$$$PARSETREEtag(%tree)
 