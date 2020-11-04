Include %occActivate

Class %Activate.HandleEvents Extends %RegisteredObject [ Abstract, System = 3 ]
{

Property %Cookie As %Integer [ Final ];

Property %IConnectionPointPtr As %Integer [ Final ];

Method %Advise(pIDispatchPtr As %Integer)
{
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXAdvise,$ListBuild(pIDispatchPtr,..%GetIID(),$this))
 If $List(result,1)'=0 $$$ActXRaise(result)
 Set i%%Cookie=$List(result,2),i%%IConnectionPointPtr=$List(result,3)
 Quit
}

Method %UnAdvise()
{
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXUnAdvise,$ListBuild(i%%Cookie,i%%IConnectionPointPtr))
 If $List(result,1)'=0 $$$ActXRaise(result)
 Quit
}

}
