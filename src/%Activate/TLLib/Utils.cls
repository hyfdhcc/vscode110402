Include %occActivate

Class %Activate.TLLib.Utils Extends %Activate.TLLib.IUtils [ Not ProcedureBlock, System = 3 ]
{

Method %OnNew(initval As %Integer) As %Status [ Language = cache, Private ]
{
 If $Get(initval)]"" Set i%%IDispatchPtr=initval Quit $$$OK
 New result Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXCreateObject,$ListBuild("{400C6600-DB40-11D4-95D0-00C04F60B2F5}",..%GetIID()))
 If $List(result,1)'=0 $$$ActXRaise(result)
 Set i%%IDispatchPtr=$List(result,2)
 Quit $$$OK
}

}
