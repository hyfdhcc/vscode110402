Class %BI.DataObject [ Abstract, ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

ClassMethod Execute(Code As %String, PArray As %String, Delim As %String, P0 As %String, P1 As %String, P2 As %String, P3 As %String, P4 As %String, P5 As %String, P6 As %String, P7 As %String, P8 As %String, P9 As %String) As %String
{
	N (Code,PArray,Delim,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,%session)
	i PArray'="" d
    . s PArray=$E(PArray,2,999999)
    . s PLIST=$L(PArray,Delim)
    . for i=1:1:PLIST s PLIST(i)=$P(PArray,Delim,i)
	X Code
	s plisval=""
	i $D(OLIST)&($G(OLIST)'=0) d
	. s i2=$O(OLIST(""),-1),plisval=$C(1)_$C(1)_$C(1)_$G(OLIST(1))
	. f i=2:1:i2 s plisval=plisval_Delim_$G(OLIST(i))
	I Code["VALUE" quit $G(VALUE)_plisval
	quit plisval
}

ClassMethod CvtPLIST(PArray)
{
	N (PArray,PLIST)
    for i=1:1:$L(PArray,$C(1)) s PLIST(i)=$P(PArray,$C(1),i)
	quit
}

ClassMethod Login(User, Password)
{
	N (User,Password,%session)
	s User=$zcvt($zstrip(User,"*P",,",?"_$g(r)),"U")
	i User="" quit 0	
	s userid=$O(^BI.UsersI("Code"," "_User,"")) 
	i +userid=0 quit 0
	s nusr=##class(%BI.Users).%OpenId(userid)
	s upass=nusr.Password
	s ipass=nusr.Encrypt(Password)
	;s UsrLang=nusr.SysLanguage
	;s SecureLvl=nusr.SecurityLevel
	;(+nusr.FolderSuperUser)
	if upass'=ipass quit 0

	s %session=##class(%CSP.Session).%New("W"_$J)
	s %session.Data("currUserID") = userid_$C(6)_$J
	quit
}

}
