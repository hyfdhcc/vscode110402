ROUTINE %occReferenceStorage [Type=INC]
#;
#; macro definition for ^oddDEF
#;
#define defStorageSubMemberRaw(%class,%ck,%m,%mk,%sm)                                    ^oddDEF(%class,%ck,%m,%mk,%sm)
#define defStorageSubMemberKeyRaw(%class,%ck,%m,%mk,%sm,%sk)                             ^oddDEF(%class,%ck,%m,%mk,%sm,%sk)
#define defStorageSubSubMemberRaw(%class,%ck,%m,%mk,%sm,%sk,%ssm)                        ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm)
#define defStorageSubSubMemberKeyRaw(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)
#define defStorageSubSubSubMemberRaw(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)          ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)
#define defStorageSubSubSubMemberKeyRaw(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk) ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)
#; 
#define defStorageSubMemberDefined(%class,%ck,%m,%mk,%sm)                                    $d(^oddDEF(%class,%ck,%m,%mk,%sm))
#define defStorageSubMemberKeyDefined(%class,%ck,%m,%mk,%sm,%sk)                             $d(^oddDEF(%class,%ck,%m,%mk,%sm,%sk))
#define defStorageSubSubMemberDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm)                        $d(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm))
#define defStorageSubSubMemberKeyDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                $d(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk))
#define defStorageSubSubSubMemberDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)          $d(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm))
#define defStorageSubSubSubMemberKeyDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk) $d(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk))
#; 
#define defStorageSubMemberGet(%class,%ck,%m,%mk,%sm)                                      $g(^oddDEF(%class,%ck,%m,%mk,%sm))
#define defStorageSubSubMemberGet(%class,%ck,%m,%mk,%sm,%sk,%ssm)                          $g(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm))
#define defStorageSubSubSubMemberGet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)            $g(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm))
#define defStorageSubMemberKeyGet(%class,%ck,%m,%mk,%sm,%sk)                               $g(^oddDEF(%class,%ck,%m,%mk,%sm,%sk),$$$tableDefaultGet(%mk,%sk))
#define defStorageSubSubMemberKeyGet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                  $g(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk),$$$tableDefaultGet(%sk,%ssk))
#define defStorageSubSubSubMemberKeyGet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)   $g(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk),$$$tableDefaultGet(%ssk,%sssk))
#;
#define defStorageSubMemberKill(%class,%ck,%m,%mk,%sm)                                     k ^oddDEF(%class,%ck,%m,%mk,%sm)
#define defStorageSubMemberKeyKill(%class,%ck,%m,%mk,%sm,%sk)                              k ^oddDEF(%class,%ck,%m,%mk,%sm,%sk)
#define defStorageSubSubMemberKill(%class,%ck,%m,%mk,%sm,%sk,%ssm)                         k ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm)
#define defStorageSubSubMemberKeyKill(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                 k ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)
#define defStorageSubSubSubMemberKill(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)           k ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)
#define defStorageSubSubSubMemberKeyKill(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)  k ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)
#;
#define defStorageSubMemberNext(%class,%ck,%m,%mk,%sm)                                     $o(^oddDEF(%class,%ck,%m,%mk,%sm))
#define defStorageSubMemberKeyNext(%class,%ck,%m,%mk,%sm,%sk)                              $o(^oddDEF(%class,%ck,%m,%mk,%sm,%sk))
#define defStorageSubSubMemberNext(%class,%ck,%m,%mk,%sm,%sk,%ssm)                         $o(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm))
#define defStorageSubSubMemberKeyNext(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                 $o(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk))
#define defStorageSubSubSubMemberNext(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)           $o(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm))
#define defStorageSubSubSubMemberKeyNext(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)  $o(^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk))
#;
#define defStorageSubMemberSet(%class,%ck,%m,%mk,%sm,%value)                                    s ^oddDEF(%class,%ck,%m,%mk,%sm)=%value
#define defStorageSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%value)                             s ^oddDEF(%class,%ck,%m,%mk,%sm,%sk)=%value
#define defStorageSubSubMemberSet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%value)                        s ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm)=%value
#define defStorageSubSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%value)                s ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)=%value
#define defStorageSubSubSubMemberSet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%value)          s ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)=%value
#define defStorageSubSubSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk,%value) s ^oddDEF(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)=%value
#;
#; macro definition for class being edited that lives ^||%occEditClass(number)
#;
#define editStorageSubMemberDefined(%class,%ck,%m,%mk,%sm)                                    $d(^||%occEditClass(%class,%ck,%m,%mk,%sm))
#define editStorageSubMemberKeyDefined(%class,%ck,%m,%mk,%sm,%sk)                             $d(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk))
#define editStorageSubSubMemberDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm)                        $d(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm))
#define editStorageSubSubMemberKeyDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                $d(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk))
#define editStorageSubSubSubMemberDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)          $d(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm))
#define editStorageSubSubSubMemberKeyDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk) $d(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk))
#;
#define editStorageSubMemberGet(%class,%ck,%m,%mk,%sm)                                      $g(^||%occEditClass(%class,%ck,%m,%mk,%sm))
#define editStorageSubSubMemberGet(%class,%ck,%m,%mk,%sm,%sk,%ssm)                          $g(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm))
#define editStorageSubSubSubMemberGet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)            $g(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm))
#define editStorageSubMemberKeyGet(%class,%ck,%m,%mk,%sm,%sk)                               $g(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk),$$$tableDefaultGet(%mk,%sk))
#define editStorageSubSubMemberKeyGet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                  $g(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk),$$$tableDefaultGet(%sk,%ssk))
#define editStorageSubSubSubMemberKeyGet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)   $g(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk),$$$tableDefaultGet(%ssk,%sssk))
#;
#define editStorageSubMemberKill(%class,%ck,%m,%mk,%sm)                                     k ^||%occEditClass(%class,%ck,%m,%mk,%sm)
#define editStorageSubMemberKeyKill(%class,%ck,%m,%mk,%sm,%sk)                              k ^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk)
#define editStorageSubSubMemberKill(%class,%ck,%m,%mk,%sm,%sk,%ssm)                         k ^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm)
#define editStorageSubSubMemberKeyKill(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                 k ^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)
#define editStorageSubSubSubMemberKill(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)           k ^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)
#define editStorageSubSubSubMemberKeyKill(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)  k ^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)
#;
#define editStorageSubMemberNext(%class,%ck,%m,%mk,%sm)                                     $o(^||%occEditClass(%class,%ck,%m,%mk,%sm))
#define editStorageSubMemberKeyNext(%class,%ck,%m,%mk,%sm,%sk)                              $o(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk))
#define editStorageSubSubMemberNext(%class,%ck,%m,%mk,%sm,%sk,%ssm)                         $o(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm))
#define editStorageSubSubMemberKeyNext(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                 $o(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk))
#define editStorageSubSubSubMemberNext(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)           $o(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm))
#define editStorageSubSubSubMemberKeyNext(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)  $o(^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk))
#;
#define editStorageSubMemberSet(%class,%ck,%m,%mk,%sm,%value)                                    s ^||%occEditClass(%class,%ck,%m,%mk,%sm)=%value
#define editStorageSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%value)                             s ^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk)=%value
#define editStorageSubSubMemberSet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%value)                        s ^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm)=%value
#define editStorageSubSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%value)                s ^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)=%value
#define editStorageSubSubSubMemberSet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%value)          s ^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)=%value
#define editStorageSubSubSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk,%value) s ^||%occEditClass(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)=%value
#;
#; macro definition for ^oddCOM
#;
#define comStorageSubMemberRaw(%class,%ck,%m,%mk,%sm)                                    ^oddCOM(%class,%ck,%m,%mk,%sm)
#define comStorageSubMemberKeyRaw(%class,%ck,%m,%mk,%sm,%sk)                             ^oddCOM(%class,%ck,%m,%mk,%sm,%sk)
#define comStorageSubSubMemberRaw(%class,%ck,%m,%mk,%sm,%sk,%ssm)                        ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm)
#define comStorageSubSubMemberKeyRaw(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)
#define comStorageSubSubSubMemberRaw(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)          ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)
#define comStorageSubSubSubMemberKeyRaw(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk) ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)
#; 
#define comStorageSubMemberDefined(%class,%ck,%m,%mk,%sm)                                    $d(^oddCOM(%class,%ck,%m,%mk,%sm))
#define comStorageSubMemberKeyDefined(%class,%ck,%m,%mk,%sm,%sk)                             $d(^oddCOM(%class,%ck,%m,%mk,%sm,%sk))
#define comStorageSubSubMemberDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm)                        $d(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm))
#define comStorageSubSubMemberKeyDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                $d(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk))
#define comStorageSubSubSubMemberDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)          $d(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm))
#define comStorageSubSubSubMemberKeyDefined(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk) $d(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk))
#;
#define comStorageSubMemberGet(%class,%ck,%m,%mk,%sm)                                      $g(^oddCOM(%class,%ck,%m,%mk,%sm),"")
#define comStorageSubSubMemberGet(%class,%ck,%m,%mk,%sm,%sk,%ssm)                          $g(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm),"")
#define comStorageSubSubSubMemberGet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)            $g(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm),"")
#define comStorageSubMemberKeyGet(%class,%ck,%m,%mk,%sm,%sk)                               $g(^oddCOM(%class,%ck,%m,%mk,%sm,%sk),$$$tableDefaultGet(%mk,%sk))
#define comStorageSubSubMemberKeyGet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                  $g(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk),$$$tableDefaultGet(%sk,%ssk))
#define comStorageSubSubSubMemberKeyGet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)   $g(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk),$$$tableDefaultGet(%ssk,%sssk))
#;
#define comStorageSubMemberKill(%class,%ck,%m,%mk,%sm)                                     k ^oddCOM(%class,%ck,%m,%mk,%sm)
#define comStorageSubMemberKeyKill(%class,%ck,%m,%mk,%sm,%sk)                              k ^oddCOM(%class,%ck,%m,%mk,%sm,%sk)
#define comStorageSubSubMemberKill(%class,%ck,%m,%mk,%sm,%sk,%ssm)                         k ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm)
#define comStorageSubSubMemberKeyKill(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                 k ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)
#define comStorageSubSubSubMemberKill(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)           k ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)
#define comStorageSubSubSubMemberKeyKill(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)  k ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)
#;
#define comStorageSubMemberNext(%class,%ck,%m,%mk,%sm)                                     $o(^oddCOM(%class,%ck,%m,%mk,%sm))
#define comStorageSubMemberKeyNext(%class,%ck,%m,%mk,%sm,%sk)                              $o(^oddCOM(%class,%ck,%m,%mk,%sm,%sk))
#define comStorageSubSubMemberNext(%class,%ck,%m,%mk,%sm,%sk,%ssm)                         $o(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm))
#define comStorageSubSubMemberKeyNext(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)                 $o(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk))
#define comStorageSubSubSubMemberNext(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)           $o(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm))
#define comStorageSubSubSubMemberKeyNext(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)  $o(^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk))
#;
#define comStorageSubMemberSet(%class,%ck,%m,%mk,%sm,%value)                                    s ^oddCOM(%class,%ck,%m,%mk,%sm)=%value
#define comStorageSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%value)                             s ^oddCOM(%class,%ck,%m,%mk,%sm,%sk)=%value
#define comStorageSubSubMemberSet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%value)                        s ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm)=%value
#define comStorageSubSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%value)                s ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)=%value
#define comStorageSubSubSubMemberSet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%value)          s ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)=%value
#define comStorageSubSubSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk,%value) s ^oddCOM(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)=%value
#;
#; macro definition for 'modify' location which points to %classmodify local variable
#; 'modify' location only has 'Set' action macros
#;
#define modifyStorageSubMemberSet(%class,%ck,%m,%mk,%sm,%value)                                    s %classmodify(%class,%ck,%m,%mk,%sm)=%value
#define modifyStorageSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%value)                             s %classmodify(%class,%ck,%m,%mk,%sm,%sk)=%value
#define modifyStorageSubSubMemberSet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%value)                        s %classmodify(%class,%ck,%m,%mk,%sm,%sk,%ssm)=%value
#define modifyStorageSubSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%value)                s %classmodify(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk)=%value
#define modifyStorageSubSubSubMemberSet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%value)          s %classmodify(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm)=%value
#define modifyStorageSubSubSubMemberKeySet(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk,%value) s %classmodify(%class,%ck,%m,%mk,%sm,%sk,%ssm,%ssk,%sssm,%sssk)=%value
	