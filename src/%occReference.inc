ROUTINE %occReference [Type=INC]
#;
#; macro definition for ^oddDEF
#;
#define defClassDefined(%mcls)                                                      $d(^oddDEF(%mcls))
#define defClassKeyDefined(%mcls,%mckey)                                             $d(^oddDEF(%mcls,%mckey))
#define defClassArrayDefined(%mcls,%mckey,%mmem)                                   $d(^oddDEF(%mcls,%mckey,%mmem))
#define defMemberDefined(%mcls,%mckey,%mmem)                                       $d(^oddDEF(%mcls,%mckey,%mmem))
#define defMemberKeyDefined(%mcls,%mckey,%mmem,%mmkey)                              $d(^oddDEF(%mcls,%mckey,%mmem,%mmkey))
#define defSubMemberDefined(%mcls,%mckey,%mmem,%mmkey,%msubmem)                   $d(^oddDEF(%mcls,%mckey,%mmem,%mmkey,%msubmem))
#define defSubMemberKeyDefined(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)          $d(^oddDEF(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey))
#;
#define defClassGet(%mcls)                                                          $g(^oddDEF(%mcls))
#define defClassVersionGet(%mcls)                                                   $g(^oddDEF(%mcls))
#define defClassKeyGet(%mcls,%mckey)                                                 $s($d(^oddDEF(%mcls,%mckey))#2:^(%mckey),1:##safeexpression($$lookupdef(%literalargs,2)))
#define defClassArrayGet(%mcls,%mckey,%mmem)                                       $g(^oddDEF(%mcls,%mckey,%mmem))
#define defMemberKeyGet(%mcls,%mckey,%mmem,%mmkey)                                  $s($d(^oddDEF(%mcls,%mckey,%mmem,%mmkey))#2:^(%mmkey),1:##safeexpression($$lookupdef(%literalargs,2,4))) 
#define defMemberArrayGet(%mcls,%mckey,%mmem,%mmkey,%mmsub)                          $g(^oddDEF(%mcls,%mckey,%mmem,%mmkey,%mmsub))
#define defSubMemberKeyGet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)              $s($d(^oddDEF(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey))#2:^(%mskey),1:##safeexpression($$lookupdef(%literalargs,4,6)))
#define defSubMemberArrayGet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub)      $g(^oddDEF(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub))
#;
#define defClassKill(%mcls)                                                         k ^oddDEF(%mcls)
#define defClassKeyKill(%mcls,%mckey)                                                k ^oddDEF(%mcls,%mckey)
#define defClassArrayKill(%mcls,%mckey,%mmem)                                      k ^oddDEF(%mcls,%mckey,%mmem)
#define defMemberKill(%mcls,%mckey,%mmem)                                          k ^oddDEF(%mcls,%mckey,%mmem)
#define defMemberKeyKill(%mcls,%mckey,%mmem,%mmkey)                                 k ^oddDEF(%mcls,%mckey,%mmem,%mmkey)
#define defSubMemberKill(%mcls,%mckey,%mmem,%mmkey,%msubmem)                      k ^oddDEF(%mcls,%mckey,%mmem,%mmkey,%msubmem)
#define defSubMemberKeyKill(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)             k ^oddDEF(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)
#;
#define defClassNext(%mcls)                                                         $o(^oddDEF(%mcls))
#define defClassKeyNext(%mcls,%mckey)                                                $o(^oddDEF(%mcls,%mckey))
#define defClassArrayNext(%mcls,%mckey,%mmem)                                      $o(^oddDEF(%mcls,%mckey,%mmem))
#define defMemberNext(%mcls,%mckey,%mmem)                                          $o(^oddDEF(%mcls,%mckey,%mmem))
#define defMemberKeyNext(%mcls,%mckey,%mmem,%mmkey)                                 $o(^oddDEF(%mcls,%mckey,%mmem,%mmkey))
#define defSubMemberNext(%mcls,%mckey,%mmem,%mmkey,%msubmem)                      $o(^oddDEF(%mcls,%mckey,%mmem,%mmkey,%msubmem))
#define defSubMemberKeyNext(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)             $o(^oddDEF(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey))
#;
#define defClassSet(%mcls,%mval)                                                   s ^oddDEF(%mcls)=%mval
#define defClassVersionSet(%mcls,%mval)                                            s ^oddDEF(%mcls)=%mval
#define defClassKeySet(%mcls,%mckey,%mval)                                          s ^oddDEF(%mcls,%mckey)=%mval
#define defClassArraySet(%mcls,%mckey,%mmem,%mval)                                s ^oddDEF(%mcls,%mckey,%mmem)=%mval
#define defMemberSet(%mcls,%mckey,%mmem,%mval)                                    s ^oddDEF(%mcls,%mckey,%mmem)=%mval
#define defMemberKeySet(%mcls,%mckey,%mmem,%mmkey,%mval)                           s ^oddDEF(%mcls,%mckey,%mmem,%mmkey)=%mval
#define defMemberArraySet(%mcls,%mckey,%mmem,%mmkey,%mmsub,%mval)                   s ^oddDEF(%mcls,%mckey,%mmem,%mmkey,%mmsub)=%mval
#define defSubMemberSet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mval)                s ^oddDEF(%mcls,%mckey,%mmem,%mmkey,%msubmem)=%mval
#define defSubMemberKeySet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%mval)       s ^oddDEF(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)=%mval
#define defSubMemberArraySet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub,%mval) s ^oddDEF(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub)=%mval
#;
#; macro definition for class being edited that lives ^||%occEditClass(number)
#;
#define editClassDefined(%mcls)                                                     $d(^||%occEditClass(%mcls))
#define editClassKeyDefined(%mcls,%mckey)                                            $d(^||%occEditClass(%mcls,%mckey))
#define editClassArrayDefined(%mcls,%mckey,%mmem)                                  $d(^||%occEditClass(%mcls,%mckey,%mmem))
#define editMemberDefined(%mcls,%mckey,%mmem)                                      $d(^||%occEditClass(%mcls,%mckey,%mmem))
#define editMemberKeyDefined(%mcls,%mckey,%mmem,%mmkey)                             $d(^||%occEditClass(%mcls,%mckey,%mmem,%mmkey))
#define editSubMemberDefined(%mcls,%mckey,%mmem,%mmkey,%msubmem)                  $d(^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%msubmem))
#define editSubMemberKeyDefined(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)         $d(^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey))
#;
#define editClassGet(%mcls)                                                         $g(^||%occEditClass(%mcls))
#define editClassKeyGet(%mcls,%mckey)                                                $s($d(^||%occEditClass(%mcls,%mckey))#2:^(%mckey),1:$$$tableDefaultGet("c",%mckey))
#define editClassArrayGet(%mcls,%mckey,%mmem)                                      $g(^||%occEditClass(%mcls,%mckey,%mmem))
#define editMemberKeyGet(%mcls,%mckey,%mmem,%mmkey)                                 $s($d(^||%occEditClass(%mcls,%mckey,%mmem,%mmkey))#2:^(%mmkey),1:$$$tableDefaultGet(%mckey,%mmkey))
#define editMemberArrayGet(%mcls,%mckey,%mmem,%mmkey,%mmsub)                         $g(^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%mmsub))
#define editSubMemberKeyGet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)             $s($d(^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey))#2:^(%mskey),1:$$$tableDefaultGet(%mmkey,%mskey))
#define editSubMemberArrayGet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub)     $g(^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub))
#;
#define editClassKill(%mcls)                                                        k ^||%occEditClass(%mcls)
#define editClassKeyKill(%mcls,%mckey)                                               k ^||%occEditClass(%mcls,%mckey)
#define editClassArrayKill(%mcls,%mckey,%mmem)                                     k ^||%occEditClass(%mcls,%mckey,%mmem)
#define editMemberKill(%mcls,%mckey,%mmem)                                         k ^||%occEditClass(%mcls,%mckey,%mmem)
#define editMemberKeyKill(%mcls,%mckey,%mmem,%mmkey)                                k ^||%occEditClass(%mcls,%mckey,%mmem,%mmkey)
#define editSubMemberKill(%mcls,%mckey,%mmem,%mmkey,%msubmem)                     k ^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%msubmem)
#define editSubMemberKeyKill(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)            k ^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)
#;
#define editClassNext(%mcls)                                                        $o(^||%occEditClass(%mcls))
#define editClassKeyNext(%mcls,%mckey)                                               $o(^||%occEditClass(%mcls,%mckey))
#define editClassArrayNext(%mcls,%mckey,%mmem)                                     $o(^||%occEditClass(%mcls,%mckey,%mmem))
#define editMemberNext(%mcls,%mckey,%mmem)                                         $o(^||%occEditClass(%mcls,%mckey,%mmem))
#define editMemberKeyNext(%mcls,%mckey,%mmem,%mmkey)                                $o(^||%occEditClass(%mcls,%mckey,%mmem,%mmkey))
#define editSubMemberNext(%mcls,%mckey,%mmem,%mmkey,%msubmem)                     $o(^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%msubmem))
#define editSubMemberKeyNext(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)            $o(^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey))
#;
#define editClassSet(%mcls,%mval)                                                  s ^||%occEditClass(%mcls)=%mval
#define editClassKeySet(%mcls,%mckey,%mval)                                         s ^||%occEditClass(%mcls,%mckey)=%mval
#define editClassArraySet(%mcls,%mckey,%mmem,%mval)                               s ^||%occEditClass(%mcls,%mckey,%mmem)=%mval
#define editMemberSet(%mcls,%mckey,%mmem,%mval)                                   s ^||%occEditClass(%mcls,%mckey,%mmem)=%mval
#define editMemberKeySet(%mcls,%mckey,%mmem,%mmkey,%mval)                          s ^||%occEditClass(%mcls,%mckey,%mmem,%mmkey)=%mval
#define editMemberArraySet(%mcls,%mckey,%mmem,%mmkey,%mmsub,%mval)                  s ^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%mmsub)=%mval
#define editSubMemberSet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mval)               s ^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%msubmem)=%mval
#define editSubMemberKeySet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%mval)      s ^||%occEditClass(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)=%mval
#;
#; macro definition for ^oddCOM
#;
#define comClassDefined(%mcls)                                                      $d(^oddCOM(%mcls))
#define comClassKeyDefined(%mcls,%mckey)                                             $d(^oddCOM(%mcls,%mckey))
#define comClassArrayDefined(%mcls,%mckey,%mmem)                                   $d(^oddCOM(%mcls,%mckey,%mmem))
#define comMemberDefined(%mcls,%mckey,%mmem)                                       $d(^oddCOM(%mcls,%mckey,%mmem))
#define comMemberKeyDefined(%mcls,%mckey,%mmem,%mmkey)                              $d(^oddCOM(%mcls,%mckey,%mmem,%mmkey))
#define comRealMemberKeyDefined(%mcls,%mckey,%mmem,%mmkey)                          $s($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey))#2:1,$d(^oddCOM($g(^($$$cXXXXorigin),%mcls),%mckey,%mmem,%mmkey))#2:1,1:$$$defMemberKeyDefined($g(^oddCOM(%mcls,%mckey,%mmem,$$$cXXXXorigin),%mcls),%mckey,%mmem,%mmkey))
#define comSubMemberDefined(%mcls,%mckey,%mmem,%mmkey,%msubmem)                   $d(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem))
#define comSubMemberKeyDefined(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)          $d(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey))
#;
#define comClassGet(%mcls)                                                          $g(^oddCOM(%mcls),$$$defClassGet(%mcls))
#define comClassKeyGet(%mcls,%mckey)                                                 $s($d(^oddCOM(%mcls,%mckey))#2:^(%mckey),1:$$$defClassKeyGet(%mcls,%mckey))
#define comClassArrayGet(%mcls,%mckey,%mmem)                                       $g(^oddCOM(%mcls,%mckey,%mmem))
#define comMemberKeyGet(%mcls,%mckey,%mmem,%mmkey)                                  $s($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey))#2:^(%mmkey),$d(^oddCOM($g(^($$$cXXXXorigin),%mcls),%mckey,%mmem,%mmkey))#2:^(%mmkey),1:$$$defMemberKeyGet($g(^oddCOM(%mcls,%mckey,%mmem,$$$cXXXXorigin),%mcls),%mckey,%mmem,%mmkey))
#define comMemberArrayGet(%mcls,%mckey,%mmem,%mmkey,%mmsub)                          $s($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%mmsub))#2:^(%mmsub),$d(^oddCOM($g(^oddCOM(%mcls,%mckey,%mmem,$$$cXXXXorigin),%mcls),%mckey,%mmem,%mmkey,%mmsub))#2:^(%mmsub),1:$$$defMemberArrayGet($g(^oddCOM(%mcls,%mckey,%mmem,$$$cXXXXorigin),%mcls),%mckey,%mmem,%mmkey,%mmsub))
#define comSubMemberKeyGet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)              $s($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey))#2:^(%mskey),$d(^oddCOM($g(^($$$cXXXXorigin),"*"),%mmkey,%msubmem,%mskey))#2:^(%mskey),1:$$$defMemberKeyGet($g(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,$$$cXXXXorigin),"*"),%mmkey,%msubmem,%mskey))
#define comSubMemberArrayGet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub)      $s($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub))#2:^(%ssub),$d(^oddCOM($g(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,$$$cXXXXorigin),%mcls),%mmkey,%msubmem,%mskey,%ssub))#2:^(%ssub),1:$$$defMemberArrayGet($g(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,$$$cXXXXorigin),%mcls),%mmkey,%msubmem,%mskey,%ssub))
#;
#define comClassKeyGetLvar(%lvar,%mcls,%mckey)                                            s:'($d(^oddCOM(%mcls,%mckey),%lvar)#2)&&'($d(^oddDEF(%mcls,%mckey),%lvar)#2) %lvar=##safeexpression($$lookupdef(%literalargs,3))
#define comClassArrayGetLvar(%lvar,%mcls,%mckey,%mmem)                                  s %lvar=$$$comClassArrayGet(%mcls,%mckey,%mmem)
#define comMemberKeyGetLvar(%lvar,%mcls,%mckey,%mmem,%mmkey)                             s:'($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey),%lvar)#2)&&'$s($d(^($$$cXXXXorigin),%lvar)#2&&(%lvar'=%mcls):$d(^oddCOM(%lvar,%mckey,%mmem,%mmkey),%lvar)#2||($d(^oddDEF(%lvar,%mckey,%mmem,%mmkey),%lvar)#2),1:$d(^oddDEF(%mcls,%mckey,%mmem,%mmkey),%lvar)#2) %lvar=##safeexpression($$lookupdef(%literalargs,3,5))
#define comMemberArrayGetLvar(%lvar,%mcls,%mckey,%mmem,%mmkey,%mmsub)                     s:'($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%mmsub),%lvar)#2)&&'$s($d(^oddCOM(%mcls,%mckey,%mmem,$$$cXXXXorigin),%lvar)#2&&(%lvar'=%mcls):$d(^oddCOM(%lvar,%mckey,%mmem,%mmkey,%mmsub),%lvar)#2||($d(^oddDEF(%lvar,%mckey,%mmem,%mmkey,%mmsub),%lvar)#2),1:$d(^oddDEF(%mcls,%mckey,%mmem,%mmkey,%mmsub),%lvar)#2) %lvar=""
#define comSubMemberKeyGetLvar(%lvar,%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)         s:'($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey),%lvar)#2)&&'$s($d(^($$$cXXXXorigin),%lvar)#2:$d(^oddCOM(%lvar,%mmkey,%msubmem,%mskey),%lvar)#2||($d(^oddDEF(%lvar,%mmkey,%msubmem,%mskey),%lvar)#2),1:0) %lvar=##safeexpression($$lookupdef(%literalargs,5,7))
#define comSubMemberArrayGetLvar(%lvar,%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub) s:'($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub),%lvar)#2)&&'$s($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,$$$cXXXXorigin),%lvar)#2:$d(^oddCOM(%lvar,%mmkey,%msubmem,%mskey,%ssub),%lvar)#2||($d(^oddDEF(%lvar,%mmkey,%msubmem,%mskey,%ssub),%lvar)#2),1:$d(^oddDEF(%mcls,%mmkey,%msubmem,%mskey,%ssub),%lvar)#2) %lvar=""
#;
#; Get the key passing in origin variable which may not be defined in which case it will set it
#; if it looks this up, but you must insure this origin variable is killed each time you move
#; to a new member so it is not pointing to wrong superclass.
#define comMemberKeyGetO(%origin,%mcls,%mckey,%mmem,%mmkey)                                   $s($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey))#2:^(%mmkey),(($d(%origin)#2)||($d(^($$$cXXXXorigin),%origin)#2))&&(%origin'=%mcls)&&($d(^oddCOM(%origin,%mckey,%mmem,%mmkey))#2):^(%mmkey),1:$$$defMemberKeyGet($g(%origin,%mcls),%mckey,%mmem,%mmkey))
#define comMemberKeyGetLO(%lvar,%origin,%mcls,%mckey,%mmem,%mmkey)                            s:'($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey),%lvar)#2)&&'$s($s($d(%origin):1,1:$d(^($$$cXXXXorigin),%origin))#2&&(%origin'=%mcls):$d(^oddCOM(%origin,%mckey,%mmem,%mmkey),%lvar)#2||($d(^oddDEF(%origin,%mckey,%mmem,%mmkey),%lvar)#2),1:$d(^oddDEF(%mcls,%mckey,%mmem,%mmkey),%lvar)#2) %lvar=##safeexpression($$lookupdef(%literalargs,4,6))
#define comSubMemberKeyGetO(%origin,%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)                $s($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey))#2:^(%mskey),(($d(%origin)#2)||($d(^($$$cXXXXorigin),%origin)#2))&&(%origin'=%mcls)&&($d(^oddCOM(%origin,%mmkey,%msubmem,%mskey))#2):^(%mskey),1:$$$defMemberKeyGet($g(%origin,%mcls),%mmkey,%msubmem,%mskey))
#define comSubMemberKeyGetLO(%lvar,%origin,%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)         s:'($d(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey),%lvar)#2)&&'$s($s($d(%origin):1,1:$d(^($$$cXXXXorigin),%origin))#2:$d(^oddCOM(%origin,%mmkey,%msubmem,%mskey),%lvar)#2||($d(^oddDEF(%origin,%mmkey,%msubmem,%mskey),%lvar)#2),1:0) %lvar=##safeexpression($$lookupdef(%literalargs,6,8))
#;
#define comClassKill(%mcls)                                                         k ^oddCOM(%mcls)
#define comClassKeyKill(%mcls,%mckey)                                                k ^oddCOM(%mcls,%mckey)
#define comClassArrayKill(%mcls,%mckey,%mmem)                                      k ^oddCOM(%mcls,%mckey,%mmem)
#define comMemberKill(%mcls,%mckey,%mmem)                                          k ^oddCOM(%mcls,%mckey,%mmem)
#define comMemberKeyKill(%mcls,%mckey,%mmem,%mmkey)                                 k ^oddCOM(%mcls,%mckey,%mmem,%mmkey)
#define comSubMemberKill(%mcls,%mckey,%mmem,%mmkey,%msubmem)                      k ^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem)
#define comSubMemberKeyKill(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)             k ^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)
#;
#define comClassNext(%mcls)                                                         $o(^oddCOM(%mcls))
#define comClassKeyNext(%mcls,%mckey)                                                $o(^oddCOM(%mcls,%mckey))
#define comClassArrayNext(%mcls,%mckey,%mmem)                                      $o(^oddCOM(%mcls,%mckey,%mmem))
#define comMemberNext(%mcls,%mckey,%mmem)                                          $o(^oddCOM(%mcls,%mckey,%mmem))
#define comMemberKeyNext(%mcls,%mckey,%mmem,%mmkey)                                 $o(^oddCOM(%mcls,%mckey,%mmem,%mmkey))
#define comSubMemberNext(%mcls,%mckey,%mmem,%mmkey,%msubmem)                      $o(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem))
#define comSubMemberKeyNext(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)             $o(^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey))
#;
#define comClassSet(%mcls,%mval)                                                   s ^oddCOM(%mcls)=%mval
#define comClassKeySet(%mcls,%mckey,%mval)                                          s ^oddCOM(%mcls,%mckey)=%mval
#define comClassArraySet(%mcls,%mckey,%mmem,%mval)                                s ^oddCOM(%mcls,%mckey,%mmem)=%mval
#define comMemberSet(%mcls,%mckey,%mmem,%mval)                                    s ^oddCOM(%mcls,%mckey,%mmem)=%mval
#define comMemberKeySet(%mcls,%mckey,%mmem,%mmkey,%mval)                           s ^oddCOM(%mcls,%mckey,%mmem,%mmkey)=%mval
#define comSubMemberSet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mval)                s ^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem)=%mval
#define comSubMemberKeySet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%mval)       s ^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)=%mval
#define comSubMemberArraySet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub,%mval)       s ^oddCOM(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%ssub)=%mval
#;
#; macro definition for 'modify' location which points to %mclsmodify local variable
#; 'modify' location only has 'Set' action macros
#;
#define modifyClassSet(%mcls,%mval)                                                s %classmodify(%mcls)=%mval
#define modifyClassKeySet(%mcls,%mckey,%mval)                                       s %classmodify(%mcls,%mckey)=%mval
#define modifyClassArraySet(%mcls,%mckey,%mmem,%mval)                             s %classmodify(%mcls,%mckey,%mmem)=%mval
#define modifyMemberSet(%mcls,%mckey,%mmem,%mval)                                 s %classmodify(%mcls,%mckey,%mmem)=%mval
#define modifyMemberKeySet(%mcls,%mckey,%mmem,%mmkey,%mval)                        s %classmodify(%mcls,%mckey,%mmem,%mmkey)=%mval
#define modifySubMemberSet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mval)             s %classmodify(%mcls,%mckey,%mmem,%mmkey,%msubmem)=%mval
#define modifySubMemberKeySet(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey,%mval)    s %classmodify(%mcls,%mckey,%mmem,%mmkey,%msubmem,%mskey)=%mval
	
