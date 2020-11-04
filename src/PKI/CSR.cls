/// Certificate Signing Request.  For use with PKI.CAClient and PKI.CAServer.
Class PKI.CSR Extends (%Persistent, %XML.Adaptor)
{

/// Unique name (constructed)
Property Name As %String(MAXLEN = 200) [ Required ];

Index NameIndex On Name [ IdKey ];

/// DNS hostname of the PKI.CAClient that generated this Certificate Signing Request
Property Hostname As %String [ Required ];

/// Cache instance of the PKI.CAClient that generated this Certificate Signing Request
Property Instance As %String [ Required ];

/// Filename specified by the PKI.CAClient that generated this Certificate Signing Request
Property Filename As %String [ Required ];

/// PEM encoding of this Certificate Signing Request
Property Contents As %String(MAXLEN = 5000) [ Required ];

/// Name of the local technical contact for the Certificate Authority client that generated this request.
/// This is the person who will be contacted by the Certificate Authority server's
/// administrator to verify the validity this Certificate Signing Request.
Property ContactName As %String [ Required ];

/// Phone number of the local technical contact for the Certificate Authority client that generated this request.
Property ContactPhone As %String;

/// Email address of the local technical contact for the Certificate Authority client that generated this request.
/// Email notification will be sent to this address when an X.509 Certificate is issued
/// for this Certificate Signing Request.
Property ContactEmail As %String;

/// Return a text representation of this Certificate Signing Request.
Method Display() As %String
{
}

/// Return a text representation of the Subject Distinguished Name
/// of this Certificate Signing Request.
Method GetSubject() As %String
{
}

/// Return a text representaion of the SHA-1 Fingerprint of this Certificate Signing Request.
Method GetSHA1Fingerprint() As %String
{
}

Query List() As %SQLQuery
{
SELECT Name,Hostname,Instance,Filename FROM CSR ORDER BY Hostname,Instance,Filename
}

Storage Default
{
<Data name="CSRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Contents</Value>
</Value>
<Value name="3">
<Value>Instance</Value>
</Value>
<Value name="4">
<Value>FileName</Value>
</Value>
<Value name="5">
<Value>ContactName</Value>
</Value>
<Value name="6">
<Value>ContactPhone</Value>
</Value>
<Value name="7">
<Value>ContactEmail</Value>
</Value>
<Value name="8">
<Value>Node</Value>
</Value>
<Value name="9">
<Value>Hostname</Value>
</Value>
<Value name="10">
<Value>Filename</Value>
</Value>
</Data>
<DataLocation>^PKI.CSRD</DataLocation>
<DefaultData>CSRDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^PKI.CSRD</IdLocation>
<IndexLocation>^PKI.CSRI</IndexLocation>
<StreamLocation>^PKI.CSRS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
