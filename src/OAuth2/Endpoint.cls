/// Define an OAuth 2.0 endpoint
Class OAuth2.Endpoint Extends %SerialObject [ System = 4 ]
{

/// If the URL is TLS/SSL
Property UseSSL As %Boolean [ InitialExpression = 1, Internal ];

/// The host part of the address
Property Host As %String [ Internal ];

/// The port part of the address
Property Port As %String [ Internal ];

/// The CSP prefix part of the address
Property Prefix As %String [ Internal ];

/// The server porion of Locarion
Method GetServerURL() As %String [ Internal ]
{
	Set addr=..Host
	If addr[":" Set addr="["_addr_"]"
	If ..Port'="" Set addr=addr_":"_..Port
	
	Quit $select(..UseSSL=0:"http",1:"https")_"://"_addr_$select(..Prefix="":"",1:"/"_..Prefix)
}

Storage Default
{
<Data name="EndpointState">
<Value name="1">
<Value>Host</Value>
</Value>
<Value name="2">
<Value>Port</Value>
</Value>
<Value name="3">
<Value>Prefix</Value>
</Value>
<Value name="4">
<Value>UseSSL</Value>
</Value>
</Data>
<State>EndpointState</State>
<StreamLocation>^OAuth2.EndpointS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
