ROUTINE %occMGInfo [Type=INC]
#;
#; macro definition for 'mginfo' location which points to ^oddCOM
#; 'mginfo' location does not have 'Set' action macros
#;
#define mginfoClassDefined(%class)                                                   $d(^oddCOM(%class))
#define mginfoClassKeyDefined(%class,%ckey)                                          $d(^oddCOM(%class,%ckey))
#define mginfoClassArrayDefined(%class,%ckey,%member)                                $d(^oddCOM(%class,%ckey,%member))
#define mginfoMemberDefined(%class,%ckey,%member)                                    $d(^oddCOM(%class,%ckey,%member))
#define mginfoMemberKeyDefined(%class,%ckey,%member,%mkey)                           $d(^oddCOM(%class,%ckey,%member,%mkey))
#define mginfoSubMemberDefined(%class,%ckey,%member,%mkey,%submember)                $d(^oddCOM(%class,%ckey,%member,%mkey,%submember))
#define mginfoSubMemberKeyDefined(%class,%ckey,%member,%mkey,%submember,%skey)       $d(^oddCOM(%class,%ckey,%member,%mkey,%submember,%skey))
#;
#if $g(^%qCacheObjectSys("usecompatiblemacros"))
#define mginfoClassGet(%class)                                                       $g(^oddCOM(%class),$$$defClassGet(%class))
#define mginfoClassKeyGet(%class,%ckey)                                              $g(^oddCOM(%class,%ckey),$g(^oddCOM($g(^oddCOM(%class,$$$cXXXXorigin),%class),%ckey),$$$defClassKeyGet($g(^oddCOM(%class,$$$cXXXXorigin),%class),%ckey)))
#define mginfoClassArrayGet(%class,%ckey,%member)                                    $g(^oddCOM(%class,%ckey,%member),$g(^oddCOM($g(^oddCOM(%class,%ckey,$$$cXXXXorigin),%class),%ckey,%member),$$$defMemberGet($g(^oddCOM(%class,%ckey,$$$cXXXXorigin),%class),%ckey,%member)))
#define mginfoMemberGet(%class,%ckey,%member)                                        $g(^oddCOM(%class,%ckey,%member),$g(^oddCOM($g(^oddCOM(%class,%ckey,%member,$$$cXXXXorigin),%class),%ckey,%member),$$$defMemberGet($g(^oddCOM(%class,%ckey,%member,$$$cXXXXorigin),%class),%ckey,%member)))
#define mginfoMemberKeyGet(%class,%ckey,%member,%mkey)                               $g(^oddCOM(%class,%ckey,%member,%mkey),$g(^oddCOM($g(^oddCOM(%class,%ckey,%member,$$$cXXXXorigin),%class),%ckey,%member,%mkey),$$$defMemberKeyGet($g(^oddCOM(%class,%ckey,%member,$$$cXXXXorigin),%class),%ckey,%member,%mkey)))
#define mginfoSubMemberGet(%class,%ckey,%member,%mkey,%submember)                    $g(^oddCOM(%class,%ckey,%member,%mkey,%submember),$g(^oddCOM($g(^oddCOM(%class,%ckey,%member,%mkey,%submember,$$$cXXXXorigin),%class),%mkey,%submember),$$$defMemberGet($g(^oddCOM(%class,%ckey,%member,%mkey,%submember,$$$cXXXXorigin),%class),%mkey,%submember)))
#define mginfoSubMemberKeyGet(%class,%ckey,%member,%mkey,%submember,%skey)           $g(^oddCOM(%class,%ckey,%member,%mkey,%submember,%skey),$g(^oddCOM($g(^oddCOM(%class,%ckey,%member,%mkey,%submember,$$$cXXXXorigin),%class),%mkey,%submember,%skey),$$$defMemberKeyGet($g(^oddCOM(%class,%ckey,%member,%mkey,%submember,$$$cXXXXorigin),%class),%mkey,%submember,%skey)))
#else
#define mginfoClassGet(%class)                                                       $s($d(^oddCOM(%class))#2:^(%class),1:$$$defClassGet(%class))
#define mginfoClassKeyGet(%class,%ckey)                                              $s($d(^oddCOM(%class,%ckey))#2:^(%ckey),1:$$$defClassKeyGet(%class,%ckey))
#define mginfoClassArrayGet(%class,%ckey,%member)                                    $s($d(^oddCOM(%class,%ckey,%member))#2:^(%member),1:$$$defClassArrayGet(%class,%ckey,%member))
#define mginfoMemberGet(%class,%ckey,%member)                                        $s($d(^oddCOM(%class,%ckey,%member))#2:^(%member),$d(^oddCOM($g(^(%member,$$$cXXXXorigin),%class),%ckey,%member))#2:^(%member),1:$$$defMemberGet($g(^oddCOM(%class,%ckey,%member,$$$cXXXXorigin),%class),%ckey,%member))
#define mginfoMemberKeyGet(%class,%ckey,%member,%mkey)                               $s($d(^oddCOM(%class,%ckey,%member,%mkey))#2:^(%mkey),$d(^oddCOM($g(^($$$cXXXXorigin),%class),%ckey,%member,%mkey))#2:^(%mkey),1:$$$defMemberKeyGet($g(^oddCOM(%class,%ckey,%member,$$$cXXXXorigin),%class),%ckey,%member,%mkey))
#define mginfoSubMemberGet(%class,%ckey,%member,%mkey,%submember)                    $s($d(^oddCOM(%class,%ckey,%member,%mkey,%submember))#2:^(%submember),$d(^oddCOM($g(^(%submember,$$$cXXXXorigin),%class),%mkey,%submember))#2:^(%submember),1:$$$defMemberGet($g(^oddCOM(%class,%ckey,%member,%mkey,%submember,$$$cXXXXorigin),%class),%mkey,%submember))
#define mginfoSubMemberKeyGet(%class,%ckey,%member,%mkey,%submember,%skey)           $s($d(^oddCOM(%class,%ckey,%member,%mkey,%submember,%skey))#2:^(%skey),$d(^oddCOM($g(^($$$cXXXXorigin),%class),%mkey,%submember,%skey))#2:^(%skey),1:$$$defMemberKeyGet($g(^oddCOM(%class,%ckey,%member,%mkey,%submember,$$$cXXXXorigin),%class),%mkey,%submember,%skey))
#endif
#;
#define mginfoClassKill(%class)                                                      k ^oddCOM(%class)
#define mginfoClassKeyKill(%class,%ckey)                                             k ^oddCOM(%class,%ckey)
#define mginfoClassArrayKill(%class,%ckey,%member)                                   k ^oddCOM(%class,%ckey,%member)
#define mginfoMemberKill(%class,%ckey,%member)                                       k ^oddCOM(%class,%ckey,%member)
#define mginfoMemberKeyKill(%class,%ckey,%member,%mkey)                              k ^oddCOM(%class,%ckey,%member,%mkey)
#define mginfoSubMemberKill(%class,%ckey,%member,%mkey,%submember)                   k ^oddCOM(%class,%ckey,%member,%mkey,%submember)
#define mginfoSubMemberKeyKill(%class,%ckey,%member,%mkey,%submember,%skey)          k ^oddCOM(%class,%ckey,%member,%mkey,%submember,%skey)
#;
#define mginfoClassNext(%class)                                                      $o(^oddCOM(%class))
#define mginfoClassKeyNext(%class,%ckey)                                             $o(^oddCOM(%class,%ckey))
#define mginfoClassArrayNext(%class,%ckey,%member)                                   $o(^oddCOM(%class,%ckey,%member))
#define mginfoMemberNext(%class,%ckey,%member)                                       $o(^oddCOM(%class,%ckey,%member))
#define mginfoMemberKeyNext(%class,%ckey,%member,%mkey)                              $o(^oddCOM(%class,%ckey,%member,%mkey))
#define mginfoSubMemberNext(%class,%ckey,%member,%mkey,%submember)                   $o(^oddCOM(%class,%ckey,%member,%mkey,%submember))
#define mginfoSubMemberKeyNext(%class,%ckey,%member,%mkey,%submember,%skey)          $o(^oddCOM(%class,%ckey,%member,%mkey,%submember,%skey))
