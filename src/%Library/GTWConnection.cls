Class %Library.GTWConnection Extends %RegisteredObject [ System = 4 ]
{

Property dllhandle As %String;

Property hdbc As %String;

Property Name As %String;

Property Timeout As %String;

Property Legacy As %Integer;

/// This callback method is invoked by the <METHOD>%Close</METHOD> method to 
/// provide notification that the current object is being closed.
/// 
/// <P>The return value of this method is ignored.
Method %OnClose() As %Status [ Private, ProcedureBlock = 1 ]
{
	if ..dllhandle'="",..hdbc'="" s res=$zf(-5,..dllhandle,6,..hdbc)
}

Method Connect(dll As %String, name As %String, timeout As %Integer, legacy As %Integer) As %Status
{
	//in,lic,rc
 s ..Name=name
 s ..Timeout=timeout
 s ..dllhandle=dll
 s ..Legacy=legacy
 i $g(dll)="" q $$$ERROR($$$GatewayFailed,"DLL is not specified")
 i $g(^%ISCLOG)>1 s err=$zf(-5,..dllhandle,51,^%ISCLOG)
 i $zf(-5,..dllhandle,63, legacy)
 &sql(select dsn,usr,pwd into :a,:b,:c from %Library.sys_SQLConnection where connection_name=:name)
 i SQLCODE q $$$ERROR($$$GatewayFailed,"Connection name does not exist")
 s c=$System.Encryption.AESBase64Decode(c,"3Mandelbrot!") 
 if b="",c="" s ..hdbc=$zf(-5,..dllhandle,46,a,timeout) 
 i ..hdbc="" s ..hdbc=$zf(-5,..dllhandle,45,a,b,c,timeout) //look up 115 !!!!!
 i ..hdbc="" q $$$ERROR($$$GatewayFailed,"Connection failed")
 s in=$zf(-5,..dllhandle,28,..hdbc,6)
 s in=$lg(in)
 if $e(in,1,2)="IE" {
   s rc=$zf(-5,..dllhandle,32,..hdbc,1041,"DDIE.LIC")
   s rc=$zf(-5,..dllhandle,32,..hdbc,1042,"EaseAndPowerQQQQQQQQQQQQ")
 }
 ;i $zf(-3,"","SetUnicodeOption",$zbitget($zversion(0),1))
 i $g(%SQLGateway("-uv")) {
    i $zf(-5,%SQLGateway,33,$zbitget($zversion(0),1))}
 else {
	 i $zf(-5,%SQLGateway,33,0)
 }
 ;if $zu(115,1)=1 s err=$zf(-3,"",19,hdbc,102,1)
 ;if $zu(115,1)'=1 s err=$zf(-3,"",19,hdbc,102,0)
 //i '$zf(-5,%SQLGateway,52),$zf(-5,%SQLGateway,32,0) 
 if $zu(115,1)=1 s err=$zf(-5,..dllhandle,19,..hdbc,102,1)
 if $zu(115,1)= 2 s err=$zf(-5,..dllhandle,19,..hdbc,102,0)
	
 quit $$$OK
}

Method Reconnect() As %Status
{
 
 i ..dllhandle'="",..hdbc'="" s rc=$zf(-5,..dllhandle,53,..hdbc)
 k %SQLGateway(..Name)
 s ..hdbc=""
 q ..Connect(..dllhandle,..Name, ..Timeout,..Legacy)
}

}
