Class %Net.Remote.Proxy Extends %RegisteredObject [ System = 3 ]
{

Property Gateway As %Net.Remote.Gateway;

Property Eager As %Boolean;

Property SyncGet As %ArrayOfDataTypes;

Property SyncSet As %ArrayOfDataTypes;

Method %SetEager(eager As %Boolean)
{
	Set ..Eager=eager
}

Method %FetchObject()
{
	Quit:'..Eager
	Set ..Gateway.CurrentDevice=$IO
	Use ..Gateway.GatewayDevice
	// Update oref registry
	If ..Gateway.ClosedProxies.Count()=0 { 
		Set x=$zobjexport(0,18) 
	} Else { 
		Do ..Gateway.%RegUpdate() 
		Use ..Gateway.GatewayDevice 
	}
	Set x=$zobjexport($this,18)
	Set x=$zobjexport("YF",8)
	Set id=$zobjexport(9),fun=$zobjexport(15)
    Set proxies=##class(%ListOfObjects).%New()
Y9	If fun="Y9" {
		Set count=$zobjexport(12)
		Set className=$zobjexport(12)
		For i=1:1:count {
			Set oref=$classmethod(className,"%New")
			Set oref.Gateway=..Gateway
			Do proxies.Insert(oref)
			Use ..Gateway.GatewayDevice 
			Set x=$zobjexport(oref,18)
		}
		Set x=$zobjexport("Y9",8)
		Set id=$zobjexport(9),fun=$zobjexport(15)
	}
	Goto:fun="Y9" Y9
	//Do:fun'="Y1" ..%ProcessError(..Gateway,fun,id)
	Set count=$zobjexport(12)
	If (..SyncGet=0) {
		Set ..SyncGet=##class(%ArrayOfDataTypes).%New()
	} Else {
		Do ..SyncGet.Clear()
	}
	For i=1:1:count {
		Set name=$zobjexport(12)
		Set type=$zobjexport(12)
		// this is datatype
		If (type = 0) {
			Set value=$zobjexport(12)
		// this is an oref
		} ElseIf (type = 1) {
			Set value=$zobjref($zobjexport(12))
		// this is an array
		} ElseIf (type = 2) {
			Set value=..%ReadArrayArgument(..Gateway)
		}
		Do ..SyncGet.SetAt(value,name)
	}
	Do proxies.Clear()
	Use ..Gateway.CurrentDevice
}

Method %SendObject()
{
	Quit:'..Eager
	If ((..SyncSet=0) || (..SyncSet.Count()=0)) {
		Quit
	}
	Set ..Gateway.CurrentDevice=$IO
	Use ..Gateway.GatewayDevice
	// Update oref registry
	If ..Gateway.ClosedProxies.Count()=0 { 
		Set x=$zobjexport(0,18) 
	} Else { 
		Do ..Gateway.%RegUpdate() 
		Use ..Gateway.GatewayDevice 
	}
	Set x=$zobjexport($this,18)
	Set x=$zobjexport(..SyncSet.Count(),18)
	Set name=..SyncSet.Next()
	While (name'="") {
		Set value=..SyncSet.GetAt(name)
		Set x=$zobjexport(name,18)
		If ($isobject(value)) {
			// see if this is an array
			If (value.%IsA("%GlobalBinaryStream")) {
				//Set x=$zobjexport(2,18)
				Do ..%WriteArray(..Gateway,"[B",value)
			} ElseIf (value.%IsA("%GlobalCharacterStream")) {
				//Set x=$zobjexport(2,18)
				Do ..%WriteArray(..Gateway,"[C",value)
			} ElseIf (value.%IsA("%ListOfDataTypes")) {
				//Set x=$zobjexport(2,18)
				Do ..%WriteArray(..Gateway,"other",value)
			// this is an oref
			} Else {	
				//Set x=$zobjexport(1,18)
				Set x=$zobjexport(value,18)
			}
		// this is datatype
		} Else {
			//Set x=$zobjexport(0,18)
			Set x=$zobjexport(value,18)
		}
		Set name=..SyncSet.Next(name)
	}
	Set x=$zobjexport("YS",8)
	Set id=$zobjexport(9),fun=$zobjexport(15)
	Do ..SyncSet.Clear()
	Use ..Gateway.CurrentDevice
}

Method %OnClose() As %Status
{
	Do:$isobject(..Gateway)=1 ..Gateway.ClosedProxies.Insert($this_"")
	Quit $$$OK
}

Method %RegisterOnDestructCallback(callbackName As %String) As %Status [ Final ]
{
	Quit:..Gateway.Closed $$$OK
	Try {
		Set ..Gateway.CurrentDevice=$IO
		Use ..Gateway.GatewayDevice
		Set x=$zobjexport($this,18)
		Set x=$zobjexport(callbackName,18)
		Set x=$zobjexport("YR",8)
		Set msgid=$zobjexport(9),fun=$zobjexport(15)
		If (fun="Y5") {
			Set status=..Gateway.%GetException()
		} Else {
			Set status=$$$OK
		}
	} Catch exception {
		Set status=..Gateway.%SetStatus(exception)
	}
	Use ..Gateway.CurrentDevice
	Quit status
}

Method %PreInvoke() [ Final ]
{
	Set ..Gateway.CurrentDevice=$IO
	Use ..Gateway.GatewayDevice
	// Update oref registry
	If ..Gateway.ClosedProxies.Count()=0 { 
		Set x=$zobjexport(0,18) 
	} Else { 
		Do ..Gateway.%RegUpdate() 
	}
	// Write out oref
	Set x=$zobjexport($this,18)
}

Method %PostInvoke() [ Final ]
{
	Set:$zobjexport(17) out=$zobjexport(12)
	Set:$zobjexport(17) err=$zobjexport(12)
    Use ..Gateway.CurrentDevice
	If ($IO["TRM") {
		Write:$D(out) "System.out: "_out,!
		Write:$D(err) "System.err: "_err,!
	}
}

ClassMethod %PreInvokeStatic(gateway As %Net.Remote.Gateway, className As %ObjectHandle) [ Final ]
{
	Set gateway.CurrentDevice=$IO
	Use gateway.GatewayDevice
	Set x=$zobjexport(0,18) 
	// Write out class name
	Set x=$zobjexport(className,18)
}

ClassMethod %PostInvokeStatic(gateway As %Net.Remote.Gateway) [ Final ]
{
	Set:$zobjexport(17) out=$zobjexport(12)
	Set:$zobjexport(17) err=$zobjexport(12)
    Use gateway.CurrentDevice
	If ($IO["TRM") {
		Write:$D(out) "System.out: "_out,!
		Write:$D(err) "System.err: "_err,!
	}
}

ClassMethod %OverloadWrite(gateway As %Net.Remote.Gateway, par As %ObjectHandle) [ Final ]
{
	// first, make a guess at a type name
	If $isobject(par) {
		Set type=$classname(par)
	} ElseIf $lb(par_"")=$lb(par) {
		Set type="%String"
	} ElseIf $lb(+par)=$lb(par) {
		If $extract($lb(par),2)=6 {
			Set type="%Float" 
		} Else { 
			Set type="%Integer" 
		}
	} Else {
		Set type="%String"
	}
	Use gateway.GatewayDevice
	If (type="%GlobalBinaryStream")||(type="%GlobalCharacterStream")||(type="%Library.GlobalBinaryStream")||(type="%Library.GlobalCharacterStream") {
		Set x=$zobjexport("%"_$E(type,10,100),18)
	    Do ..%WriteGlobalArray(gateway,type,par)
		Quit	
	}

	Set x=$zobjexport(type,18)
	Set x=$zobjexport(par,18)
}

Method %ProcessError(fun As %String, msgid As %Integer) [ Final ]
{
	Use ..Gateway.GatewayDevice 
	If fun="Y9" Do ..%ReadObjects(..Gateway) Quit
	Set error=$zobjexport(12)
	Set x=$$$ERROR($$$RemoteGatewayError,error)
	Use ..Gateway.CurrentDevice
	Zt "JGTW"
}

ClassMethod %ProcessErrorStatic(gateway As %Net.Remote.Gateway, fun As %String, msgid As %Integer) [ Final ]
{
	Use gateway.GatewayDevice 
	If fun="Y9" Do ..%ReadObjects(gateway) Quit
	Set error=$zobjexport(12)
	Set x=$$$ERROR($$$RemoteGatewayError,error)
	Use gateway.CurrentDevice
	Zt "JGTW"
}

ClassMethod %ReadObjects(gateway As %Net.Remote.Gateway) [ Final ]
{
    Use gateway.GatewayDevice 
Y9	Set count=$zobjexport(12)
	Set className=$zobjexport(12)
	For i=1:1:count {
		Set oref=$classmethod(className,"%New")
		Set oref.Gateway=gateway
		Do gateway.Proxies.Insert(oref)
		Use gateway.GatewayDevice 
		Set x=$zobjexport(oref,18)
	}
	Set x=$zobjexport("Y9",8)
	Set id=$zobjexport(9),fun=$zobjexport(15)
	Goto:fun="Y9" Y9
	Quit //	Set x=$zobjexport("Y1",8)
}

ClassMethod %GetObject(gateway As %Net.Remote.Gateway) As %ObjectHandle [ Final ]
{
    Use gateway.GatewayDevice 
	Set x=$zobjexport("Y1",8)
    Set msgid=$zobjexport(9),fun=$zobjexport(15)
Y9	If fun="Y9" {
		Set count=$zobjexport(12)
		Set className=$zobjexport(12)
		For i=1:1:count {
			Set oref=$classmethod(className,"%New")
			Set oref.Gateway=gateway
			Do gateway.Proxies.Insert(oref)
			Use gateway.GatewayDevice 
			Set x=$zobjexport(oref,18)
		}
		Set x=$zobjexport("Y9",8)
		Set id=$zobjexport(9),fun=$zobjexport(15)
	}
	Goto:fun="Y9" Y9
	Do:fun'="Y1" ..%ProcessErrorStatic(gateway,fun,msgid)
	If '$zobjexport(17) Quit $C(1)
	Set kind=$zobjexport(12)
	Set x=$zobjexport(12)
	If ..%IsDataType(kind) {
		Quit x
	}
	// One-dimensional array
	If (kind="%ListOfDataTypes") {
		Set size=x
		If (size=-1) {
			Quit ""
		}
		Set x=##class(%ListOfDataTypes).%New()
   		For i=1:1:size {
			Set value=$zobjexport(12)
    		Do x.Insert(value)
   		}
	} ElseIf (kind="%ListOfObjects") {
		Set size=x
		If (size=-1) {
			Quit ""
		}
		Set x=##class(%ListOfObjects).%New()
   		For i=1:1:size {
			Set value=$zobjref($zobjexport(12))
    		Do x.Insert(value)
   		}
	} ElseIf ((kind="%GlobalBinaryStream")||(kind="%GlobalCharacterStream")||(kind="%Library.GlobalBinaryStream")||(kind="%Library.GlobalCharacterStream")) {
		Set size=x
		If (size=-1) {
			Quit ""
		}
		If (kind="%GlobalBinaryStream")||(kind="%Library.GlobalBinaryStream") {
			Set stream=##class(%GlobalBinaryStream).%New()
		} Else {
			Set stream=##class(%GlobalCharacterStream).%New()
		}
		If (size=0) {
			Do stream.Write("")
		} Else {
			For {
				Set data=$zobjexport($S(size>32000:32000,1:size),13)
				Do stream.Write(data)
				Set size=size-$L(data)
				Quit:size=0
			}
		}
		Quit stream
	} ElseIf '..%IsDataType(kind) {
		Set x=$zobjref(x)
	}
    Quit x
}

ClassMethod %WriteArray(gateway As %Net.Remote.Gateway, type As %String, array As %ObjectHandle) [ Final ]
{
    Use gateway.GatewayDevice 
    if ((type="[B")||(type="[C")) {
	    Do ..%WriteGlobalArray(gateway,type,array)
		Quit	
	}
	Set x=$zobjexport(type,18)
	If (array="") {
		Set x=$zobjexport(-1,18)
		Quit
	}
	Set x=$zobjexport(array.Count(),18)
	For i=1:1:array.Count() {
		Set x=$zobjexport(array.GetAt(i),18)
	}
}

ClassMethod %WriteGlobalArray(gateway As %Net.Remote.Gateway, type As %String, array As %ObjectHandle) [ Final ]
{
	Set size=array.SizeGet(),total=0
	Do array.Rewind()
	If (type="[B")||(type="%GlobalBinaryStream")||(type="%Library.GlobalBinaryStream") {
		Set x=$zobjexport("byte",18)
		Set x=$zobjexport(size,18)
		For  Quit:array.AtEnd  Set chunk=$select(size-total>32000:32000,1:size-total) Set x=$zobjexport(array.Read(chunk),5) Set total=total+chunk Quit:total=size
	} Else {
		Set x=$zobjexport("char",18)
		Set x=$zobjexport(size,18)
		Set x=$zu(96,18,2,"UTF8") 
		For  Quit:array.AtEnd  Set chunk=$select(size-total>32000:32000,1:size-total) Set x=$zobjexport(array.Read(chunk),5) Set total=total+chunk Quit:total=size
		Set x=$zobjexport($C(0),5)
		Set x=$zu(96,18,2,"RAW")
	}
	Do array.Rewind()
}

ClassMethod %ReadArrayArgument(gateway As %Net.Remote.Gateway) As %ObjectHandle [ Final ]
{
	Use gateway.GatewayDevice
	Set kind=$zobjexport(12)
	Set size=$zobjexport(12)
	If (size=-1) {
		Quit ""
	}
	If ((kind="%GlobalBinaryStream") || (kind="%Library.GlobalBinaryStream") || (kind="%GlobalCharacterStream") || (kind="%Library.GlobalCharacterStream")) {
		Quit ..%ReadGlobalArray(kind,size)
	}
	If (kind="%ListOfDataTypes") {
		Set x=##class(%ListOfDataTypes).%New()
   		For i=1:1:size {
			Set value=$zobjexport(12)
    		Do x.Insert(value)
   		}
   		Quit x
	} ElseIf (kind="%ListOfObjects") {
		Set x=##class(%ListOfObjects).%New()
   		For i=1:1:size {
			Set value=$zobjref($zobjexport(12))
    		Do x.Insert(value)
   		}
		Quit x
	}
	Set stream=##class(%GlobalBinaryStream).%New()
	If (size=0) {
		Do stream.Write("")
	} Else {
		For {
			Set data=$zobjexport($S(size>32000:32000,1:size),13)
			Do stream.Write(data)
			Set size=size-$L(data)
			Quit:size=0
		}
	}
	Quit stream
}

ClassMethod %ReadGlobalArray(kind As %String, size As %Integer)
{
	If (kind="%GlobalBinaryStream")||(kind="%Library.GlobalBinaryStream") {
		Set stream=##class(%GlobalBinaryStream).%New()
	} ElseIf (kind="%GlobalCharacterStream")||(kind="%Library.GlobalCharacterStream") {
		Set stream=##class(%GlobalCharacterStream).%New()
		Set x=$zu(96,18,2,"UTF8") 
	}
	If (size=0) {
		Do stream.Write("")
	} Else {
		For {
			Set data=$zobjexport($S(size>32000:32000,1:size),13)
			Do stream.Write(data)
			Set size=size-$L(data)
			Quit:size=0
		}
	}
	If (kind="%GlobalCharacterStream") {
		Set x=$zu(96,18,2,"RAW") 
	}
	Quit stream
}

ClassMethod %IsDataType(type As %String) As %Boolean [ Final ]
{
   Quit (type="%Boolean")!(type="%TinyInt")!
    	(type="%Numeric")!(type="%Float")!
    	(type="%Integer")!(type="%SmallInt")!
    	(type="%String")!(type="%Date")!
    	(type="%Time")!(type="%TimeStamp")
}

Method %Get(propertyName As %String) As %ObjectHandle [ Final ]
{
	If (..Eager=1) {
		Set propertyName=$E(propertyName,4,9999)
		If (..SyncSet'=0) {
			Set x=..SyncSet.GetAt(propertyName)
			Quit:x'="" x
		}
		Quit ..SyncGet.GetAt(propertyName)
	}
	Do ..%PreInvoke()
	Set x=$zobjexport(propertyName,18)
	Set x=..%GetObject(..Gateway)
	Use ..Gateway.CurrentDevice
	Quit x
}

ClassMethod %GetStatic(gateway As %Net.Remote.Gateway, propertyName As %String, className As %ObjectHandle) As %ObjectHandle [ Final ]
{
	Do ..%PreInvokeStatic(gateway,className)
	Set x=$zobjexport(propertyName,18)
	Set x=..%GetObject(gateway)
	Use gateway.CurrentDevice
	Quit x
}

Method %Set(propertyName As %String, value As %ObjectHandle, arrayType As %String) [ Final ]
{
	If ..Eager=1 {
		If ..SyncSet=0 {
			Set ..SyncSet=##class(%ArrayOfDataTypes).%New()
		}
		Do ..SyncSet.SetAt(value,$E(propertyName,4,9999))
		Quit
	}
	Do ..%PreInvoke()
	Set x=$zobjexport(propertyName,18)
	If ($D(arrayType)) {
		Do ..%WriteArray(..Gateway,arrayType,value)
	} Else {
		Set x=$zobjexport(value,18)
	}
	Set x=$zobjexport("Y1",8)
	Set id=$zobjexport(9),fun=$zobjexport(15)
	Do:fun'="Y1" ..%ProcessError(fun,id)
	Use ..Gateway.CurrentDevice
}

ClassMethod %SetStatic(gateway As %Net.Remote.Gateway, propertyName As %String, value As %ObjectHandle, className As %ObjectHandle, arrayType As %String) [ Final ]
{
	Do ..%PreInvokeStatic(gateway,className)
	Set x=$zobjexport(propertyName,18)
	If ($D(arrayType)) {
		Do ..%WriteArray(gateway,arrayType,value)
	} Else {
		Set x=$zobjexport(value,18)
	}
	Set x=$zobjexport("Y1",8)
	Set id=$zobjexport(9),fun=$zobjexport(15)
	Do:fun'="Y1" ..%ProcessErrorStatic(gateway,fun,id)
	Use gateway.CurrentDevice
}

Method %I(methodName As %String, ByRef p1 As %ObjectHandle, ByRef p2 As %ObjectHandle, ByRef p3 As %ObjectHandle, ByRef p4 As %ObjectHandle, ByRef p5 As %ObjectHandle) [ Final ]
{
	Do ..%PreInvoke()
	Set x=$zobjexport(methodName,18)
	Set x=$zobjexport(-1,18)
	Set:$D(p1) x=$zobjexport(p1,18)
	Set:$D(p2) x=$zobjexport(p2,18)
	Set:$D(p3) x=$zobjexport(p3,18)
	Set:$D(p4) x=$zobjexport(p4,18)
	Set:$D(p5) x=$zobjexport(p5,18)
	Set x=$zobjexport("Y1",8)
	Set id=$zobjexport(9),fun=$zobjexport(15)
	Do:fun'="Y1" ..%ProcessError(fun,id)
	If $D(p1) Set:$zobjexport(17) p1=..%ReadArrayArgument(..Gateway)
	If $D(p2) Set:$zobjexport(17) p2=..%ReadArrayArgument(..Gateway)
	If $D(p3) Set:$zobjexport(17) p3=..%ReadArrayArgument(..Gateway)
	If $D(p4) Set:$zobjexport(17) p4=..%ReadArrayArgument(..Gateway)
	If $D(p5) Set:$zobjexport(17) p5=..%ReadArrayArgument(..Gateway)
	Do ..%PostInvoke()
}

Method %IR(methodName As %String, ByRef p1 As %ObjectHandle, ByRef p2 As %ObjectHandle, ByRef p3 As %ObjectHandle, ByRef p4 As %ObjectHandle, ByRef p5 As %ObjectHandle) As %ObjectHandle [ Final ]
{
	Do ..%PreInvoke()
	Set x=$zobjexport(methodName,18)
	Set x=$zobjexport(-1,18)
	Set:$D(p1) x=$zobjexport(p1,18)
	Set:$D(p2) x=$zobjexport(p2,18)
	Set:$D(p3) x=$zobjexport(p3,18)
	Set:$D(p4) x=$zobjexport(p4,18)
	Set:$D(p5) x=$zobjexport(p5,18)
	Set x=..%GetObject(..Gateway)
	If $D(p1) Set:$zobjexport(17) p1=..%ReadArrayArgument(..Gateway)
	If $D(p2) Set:$zobjexport(17) p2=..%ReadArrayArgument(..Gateway)
	If $D(p3) Set:$zobjexport(17) p3=..%ReadArrayArgument(..Gateway)
	If $D(p4) Set:$zobjexport(17) p4=..%ReadArrayArgument(..Gateway)
	If $D(p5) Set:$zobjexport(17) p5=..%ReadArrayArgument(..Gateway)
	Do ..%PostInvoke()
	Quit x
}

Method %IOL(methodName As %String, ByRef p1 As %ObjectHandle, ByRef p2 As %ObjectHandle, ByRef p3 As %ObjectHandle, ByRef p4 As %ObjectHandle, ByRef p5 As %ObjectHandle) [ Final ]
{
	Do ..%PreInvoke()
	Set x=$zobjexport(methodName,18)
	Set x=$zobjexport($D(p1)+$D(p2)+$D(p3)+$D(p4)+$D(p5),18)
	Do:$D(p1) ..%OverloadWrite(..Gateway,p1)
	Do:$D(p2) ..%OverloadWrite(..Gateway,p2)
	Do:$D(p3) ..%OverloadWrite(..Gateway,p3)
	Do:$D(p4) ..%OverloadWrite(..Gateway,p4)
	Do:$D(p5) ..%OverloadWrite(..Gateway,p5)
	Set x=$zobjexport("Y1",8)
	Set id=$zobjexport(9),fun=$zobjexport(15)
	Do:fun'="Y1" ..%ProcessError(fun,id)
	If $D(p1) Set:$zobjexport(17) p1=..%ReadArrayArgument(..Gateway)
	If $D(p2) Set:$zobjexport(17) p2=..%ReadArrayArgument(..Gateway)
	If $D(p3) Set:$zobjexport(17) p3=..%ReadArrayArgument(..Gateway)
	If $D(p4) Set:$zobjexport(17) p4=..%ReadArrayArgument(..Gateway)
	If $D(p5) Set:$zobjexport(17) p5=..%ReadArrayArgument(..Gateway)
	Do ..%PostInvoke()
}

Method %IOLR(methodName As %String, ByRef p1 As %ObjectHandle, ByRef p2 As %ObjectHandle, ByRef p3 As %ObjectHandle, ByRef p4 As %ObjectHandle, ByRef p5 As %ObjectHandle) As %ObjectHandle [ Final ]
{
	Do ..%PreInvoke()
	Set x=$zobjexport(methodName,18)
	Set x=$zobjexport($D(p1)+$D(p2)+$D(p3)+$D(p4)+$D(p5),18)
	Do:$D(p1) ..%OverloadWrite(..Gateway,p1)
	Do:$D(p2) ..%OverloadWrite(..Gateway,p2)
	Do:$D(p3) ..%OverloadWrite(..Gateway,p3)
	Do:$D(p4) ..%OverloadWrite(..Gateway,p4)
	Do:$D(p5) ..%OverloadWrite(..Gateway,p5)
	Set x=..%GetObject(..Gateway)
	If $D(p1) Set:$zobjexport(17) p1=..%ReadArrayArgument(..Gateway)
	If $D(p2) Set:$zobjexport(17) p2=..%ReadArrayArgument(..Gateway)
	If $D(p3) Set:$zobjexport(17) p3=..%ReadArrayArgument(..Gateway)
	If $D(p4) Set:$zobjexport(17) p4=..%ReadArrayArgument(..Gateway)
	If $D(p5) Set:$zobjexport(17) p5=..%ReadArrayArgument(..Gateway)
	Do ..%PostInvoke()
	Quit x
}

// static methods

ClassMethod %S(gateway As %Net.Remote.Gateway, methodName As %String, className As %ObjectHandle, ByRef p1 As %ObjectHandle, ByRef p2 As %ObjectHandle, ByRef p3 As %ObjectHandle, ByRef p4 As %ObjectHandle, ByRef p5 As %ObjectHandle) [ Final ]
{
	Do ..%PreInvokeStatic(gateway,className)
	Set x=$zobjexport(methodName,18)
	Set x=$zobjexport(-1,18)
	Set:$D(p1) x=$zobjexport(p1,18)
	Set:$D(p2) x=$zobjexport(p2,18)
	Set:$D(p3) x=$zobjexport(p3,18)
	Set:$D(p4) x=$zobjexport(p4,18)
	Set:$D(p5) x=$zobjexport(p5,18)
	Set x=$zobjexport("Y1",8)
	Set id=$zobjexport(9),fun=$zobjexport(15)
	Do:fun'="Y1" ..%ProcessErrorStatic(gateway,fun,id)
	If $D(p1) Set:$zobjexport(17) p1=..%ReadArrayArgument(gateway)
	If $D(p2) Set:$zobjexport(17) p2=..%ReadArrayArgument(gateway)
	If $D(p3) Set:$zobjexport(17) p3=..%ReadArrayArgument(gateway)
	If $D(p4) Set:$zobjexport(17) p4=..%ReadArrayArgument(gateway)
	If $D(p5) Set:$zobjexport(17) p5=..%ReadArrayArgument(gateway)
	Do ..%PostInvokeStatic(gateway)
}

ClassMethod %SR(gateway As %Net.Remote.Gateway, methodName As %String, className As %ObjectHandle, ByRef p1 As %ObjectHandle, ByRef p2 As %ObjectHandle, ByRef p3 As %ObjectHandle, ByRef p4 As %ObjectHandle, ByRef p5 As %ObjectHandle) As %ObjectHandle [ Final ]
{
	Do ..%PreInvokeStatic(gateway,className)
	Set x=$zobjexport(methodName,18)
	Set x=$zobjexport(-1,18)
	Set:$D(p1) x=$zobjexport(p1,18)
	Set:$D(p2) x=$zobjexport(p2,18)
	Set:$D(p3) x=$zobjexport(p3,18)
	Set:$D(p4) x=$zobjexport(p4,18)
	Set:$D(p5) x=$zobjexport(p5,18)
	Set x=..%GetObject(gateway)
	If $D(p1) Set:$zobjexport(17) p1=..%ReadArrayArgument(gateway)
	If $D(p2) Set:$zobjexport(17) p2=..%ReadArrayArgument(gateway)
	If $D(p3) Set:$zobjexport(17) p3=..%ReadArrayArgument(gateway)
	If $D(p4) Set:$zobjexport(17) p4=..%ReadArrayArgument(gateway)
	If $D(p5) Set:$zobjexport(17) p5=..%ReadArrayArgument(gateway)
	Do ..%PostInvokeStatic(gateway)
	Quit x
}

ClassMethod %SOL(gateway As %Net.Remote.Gateway, methodName As %String, className As %ObjectHandle, ByRef p1 As %ObjectHandle, ByRef p2 As %ObjectHandle, ByRef p3 As %ObjectHandle, ByRef p4 As %ObjectHandle, ByRef p5 As %ObjectHandle) [ Final ]
{
	Do ..%PreInvokeStatic(gateway,className)
	Set x=$zobjexport(methodName,18)
	Set x=$zobjexport($D(p1)+$D(p2)+$D(p3)+$D(p4)+$D(p5),18)
	Do:$D(p1) ..%OverloadWrite(gateway,p1)
	Do:$D(p2) ..%OverloadWrite(gateway,p2)
	Do:$D(p3) ..%OverloadWrite(gateway,p3)
	Do:$D(p4) ..%OverloadWrite(gateway,p4)
	Do:$D(p5) ..%OverloadWrite(gateway,p5)
	Set x=$zobjexport("Y1",8)
	Set id=$zobjexport(9),fun=$zobjexport(15)
	Do:fun'="Y1" ..%ProcessErrorStatic(gateway,fun,id)
	If $D(p1) Set:$zobjexport(17) p1=..%ReadArrayArgument(gateway)
	If $D(p2) Set:$zobjexport(17) p2=..%ReadArrayArgument(gateway)
	If $D(p3) Set:$zobjexport(17) p3=..%ReadArrayArgument(gateway)
	If $D(p4) Set:$zobjexport(17) p4=..%ReadArrayArgument(gateway)
	If $D(p5) Set:$zobjexport(17) p5=..%ReadArrayArgument(gateway)
	Do ..%PostInvokeStatic(gateway)
}

ClassMethod %SOLR(gateway As %Net.Remote.Gateway, methodName As %String, className As %ObjectHandle, ByRef p1 As %ObjectHandle, ByRef p2 As %ObjectHandle, ByRef p3 As %ObjectHandle, ByRef p4 As %ObjectHandle, ByRef p5 As %ObjectHandle) As %ObjectHandle [ Final ]
{
	Do ..%PreInvokeStatic(gateway,className)
	Set x=$zobjexport(methodName,18)
	Set x=$zobjexport($D(p1)+$D(p2)+$D(p3)+$D(p4)+$D(p5),18)
	Do:$D(p1) ..%OverloadWrite(gateway,p1)
	Do:$D(p2) ..%OverloadWrite(gateway,p2)
	Do:$D(p3) ..%OverloadWrite(gateway,p3)
	Do:$D(p4) ..%OverloadWrite(gateway,p4)
	Do:$D(p5) ..%OverloadWrite(gateway,p5)
	Set x=..%GetObject(gateway)
	If $D(p1) Set:$zobjexport(17) p1=..%ReadArrayArgument(gateway)
	If $D(p2) Set:$zobjexport(17) p2=..%ReadArrayArgument(gateway)
	If $D(p3) Set:$zobjexport(17) p3=..%ReadArrayArgument(gateway)
	If $D(p4) Set:$zobjexport(17) p4=..%ReadArrayArgument(gateway)
	If $D(p5) Set:$zobjexport(17) p5=..%ReadArrayArgument(gateway)
	Do ..%PostInvokeStatic(gateway)
	Quit x
}

Method %Constructor(gateway As %ObjectHandle, className As %String, count As %Integer, p1 As %ObjectHandle, p2 As %ObjectHandle, p3 As %ObjectHandle, p4 As %ObjectHandle, p5 As %ObjectHandle, p6 As %ObjectHandle, p7 As %ObjectHandle, p8 As %ObjectHandle, p9 As %ObjectHandle, p10 As %ObjectHandle, p11 As %ObjectHandle, p12 As %ObjectHandle, p13 As %ObjectHandle, p14 As %ObjectHandle, p15 As %ObjectHandle, p16 As %ObjectHandle, p17 As %ObjectHandle, p18 As %ObjectHandle, p19 As %ObjectHandle, p20 As %ObjectHandle, p21 As %ObjectHandle, p22 As %ObjectHandle, p23 As %ObjectHandle, p24 As %ObjectHandle, p25 As %ObjectHandle) As %Status
{
	Quit:'$D(gateway) $$$OK
	Set ..Gateway=gateway
	Do ..%PreInvoke()
	Set x=$zobjexport(className,18)
	Set x=$zobjexport(count,18)
	Do:$D(p1) ..%OverloadWrite(..Gateway,p1)
	Do:$D(p2) ..%OverloadWrite(..Gateway,p2)
	Do:$D(p3) ..%OverloadWrite(..Gateway,p3)
	Do:$D(p4) ..%OverloadWrite(..Gateway,p4)
	Do:$D(p5) ..%OverloadWrite(..Gateway,p5)
	Do:$D(p6) ..%OverloadWrite(..Gateway,p6)
	Do:$D(p7) ..%OverloadWrite(..Gateway,p7)
	Do:$D(p8) ..%OverloadWrite(..Gateway,p8)
	Do:$D(p9) ..%OverloadWrite(..Gateway,p9)
	Do:$D(p10) ..%OverloadWrite(..Gateway,p10)
	Do:$D(p11) ..%OverloadWrite(..Gateway,p11)
	Do:$D(p12) ..%OverloadWrite(..Gateway,p12)
	Do:$D(p13) ..%OverloadWrite(..Gateway,p13)
	Do:$D(p14) ..%OverloadWrite(..Gateway,p14)
	Do:$D(p15) ..%OverloadWrite(..Gateway,p15)
	Do:$D(p16) ..%OverloadWrite(..Gateway,p16)
	Do:$D(p17) ..%OverloadWrite(..Gateway,p17)
	Do:$D(p18) ..%OverloadWrite(..Gateway,p18)
	Do:$D(p19) ..%OverloadWrite(..Gateway,p19)
	Do:$D(p20) ..%OverloadWrite(..Gateway,p20)
	Do:$D(p21) ..%OverloadWrite(..Gateway,p21)
	Do:$D(p22) ..%OverloadWrite(..Gateway,p22)
	Do:$D(p23) ..%OverloadWrite(..Gateway,p23)
	Do:$D(p24) ..%OverloadWrite(..Gateway,p24)
	Do:$D(p25) ..%OverloadWrite(..Gateway,p25)
	Set x=$zobjexport("Y3",8)
	Set id=$zobjexport(9),fun=$zobjexport(15)
	Do:fun'="Y3" ..%ProcessError(fun,id)
	Do:fun'="Y5" ..%PostInvoke()
	Quit $$$OK
}

}
