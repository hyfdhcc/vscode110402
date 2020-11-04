ROUTINE %XML.Exchange [Type=INC]
#;
#define xmlListDefined(%list)                                             $d(^||%xmlExchangeList(%list,0))
#define xmlMemberDefined(%list,%member)                                   $d(^||%xmlExchangeList(%list,0,%member))
#define xmlSubListDefined(%list,%member,%sublist)                         $d(^||%xmlExchangeList(%list,0,%member,%sublist))
#define xmlSubMemberDefined(%list,%member,%sublist,%submember)            $d(^||%xmlExchangeList(%list,0,%member,%sublist,%submember))

#define xmlListKill(%list)                                                k ^||%xmlExchangeList(%list)
#define xmlMemberKill(%list,%member)                                      k:$d(^||%xmlExchangeList(%list,0,%member)) ^||%xmlExchangeList(%list,1,^||%xmlExchangeList(%list,0,%member)),^||%xmlExchangeList(%list,0,%member)
#define xmlSubListKill(%list,%member,%sublist)                            k:$d(^||%xmlExchangeList(%list,0,%member)) ^||%xmlExchangeList(%list,1,^||%xmlExchangeList(%list,0,%member),%sublist),^||%xmlExchangeList(%list,0,%member,%sublist)
#define xmlSubMemberKill(%list,%member,%sublist,%submember)               k:$d(^||%xmlExchangeList(%list,0,%member,%sublist,%submember)) ^||%xmlExchangeList(%list,1,^||%xmlExchangeList(%list,0,%member),%sublist,^||%xmlExchangeList(%list,0,%member,%sublist,%submember)),^||%xmlExchangeList(%list,0,%member,%sublist,%submember) ##; noalert

#define xmlMemberNext(%list,%key,%member)                                 s %key=$o(^||%xmlExchangeList(%list,1,%key),1,%member)
#define xmlSubMemberNext(%list,%member,%sublist,%key,%submember)          s xmlExchangeKey=^||%xmlExchangeList(%list,0,%member),%key=$o(^||%xmlExchangeList(%list,1,xmlExchangeKey,%sublist,%key),1,%submember)

#define xmlMemberSet(%list,%member)                                       s ^||%xmlExchangeList(%list,1,$i(^||%xmlExchangeList(%list)))=%member,^||%xmlExchangeList(%list,0,%member)=^||%xmlExchangeList(%list)
#define xmlSubMemberSet(%list,%member,%sublist,%submember)                s xmlExchangeKey=^||%xmlExchangeList(%list,0,%member),^||%xmlExchangeList(%list,1,xmlExchangeKey,%sublist,$i(^||%xmlExchangeList(%list,1,xmlExchangeKey,%sublist)))=%submember,^||%xmlExchangeList(%list,0,%member,%sublist,%submember)=^||%xmlExchangeList(%list,1,xmlExchangeKey,%sublist) ##; noalert
