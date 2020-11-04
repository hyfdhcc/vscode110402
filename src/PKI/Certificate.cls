/// X.509 Certificate.  For use with PKI.CAClient and PKI.CAServer.
Class PKI.Certificate Extends (%Persistent, %XML.Adaptor)
{

/// Serial number.  Max length = 20 octets = 49 digits.
Property Number As %String [ Required ];

Index NumberIndex On Number [ IdKey ];

/// DNS hostname of the PKI.CAClient that requested this X.509 Certificate
Property Hostname As %String [ Required ];

/// Cache instance of the PKI.CAClient that requested this X.509 Certificate
Property Instance As %String [ Required ];

/// Filename specified by the PKI.CAClient that requested this X.509 Certificate
Property Filename As %String [ Required ];

/// PEM encoding of this X.509 certificate
Property Contents As %String(MAXLEN = 5000) [ Required ];

/// String representation of the Subject Distinguished Name of this X.509 Certificate
Property Subject As %String(MAXLEN = 200) [ Required ];

/// Return an RFC 2253 string representation of the Subject field of this X.509 Certificate.
Method GetSubject() As %String
{
}

/// Return a text representaion of the SHA-1 Fingerprint of this X.509 Certificate.
Method GetSHA1Fingerprint() As %String
{
}

Query ListMy(Hostname As %String, Instance As %String) As %SQLQuery
{
SELECT Number,Filename FROM Certificate
WHERE Number <> 0 AND Hostname=:Hostname And Instance=:Instance
ORDER BY Number
}

Query ListAll() As %SQLQuery
{
SELECT Number,Hostname,Instance,Filename FROM Certificate
WHERE Number <> 0 ORDER BY Number
}

Storage Default
{
<Data name="CertificateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Contents</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>FileName</Value>
</Value>
<Value name="5">
<Value>Subject</Value>
</Value>
<Value name="6">
<Value>Filename</Value>
</Value>
<Value name="7">
<Value>Hostname</Value>
</Value>
<Value name="8">
<Value>Instance</Value>
</Value>
</Data>
<DataLocation>^PKI.CertificateD</DataLocation>
<DefaultData>CertificateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^PKI.CertificateD</IdLocation>
<IndexLocation>^PKI.CertificateI</IndexLocation>
<StreamLocation>^PKI.CertificateS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
