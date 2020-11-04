/// This SOAP header is defined as part of Medicare Australia (Federal Agency)
/// Healthcare Identifiers (HI) Service in document Healthcare Identifiers (HI) Service,
/// System Interface Specification (SIS), B2B Common Functionality Document, TECH.SIS.HI.01<br>
/// The class name is derived from the type definition in CommonCoreElements.xsd.<br>
/// The SOAP header element name is "signature".<br>
/// See %Standards.AU.eHealth.HI.Headers class for adding and validating headers.
Class %Standards.AU.eHealth.HI.SignatureContainerType Extends %SOAP.Header [ System = 4 ]
{

/// The header element name and key name for HeadersIn and HeadersOut arrays.
Parameter XMLNAME = "signature";

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0";

Parameter XMLPREFIX = "cce";

/// Handle this header as a custom security header
Parameter CUSTOMSECURITY [ Internal ] = 1;

Parameter SOAPENABLEREWRITE [ Internal ] = 1;

Property Signature As %XML.Security.Signature(REFNAMESPACE = "http://www.w3.org/2000/09/xmldsig#", XMLPROJECTION = "element", XMLREF = 1) [ Required ];

/// Create a signature header and sign user header, timestamp header and Body.
/// Create signature interface:
/// <ul>
/// <li>The service argument is required and is the web client or service for which to add the headers.</li>
/// <li>The credentials argument is the X.509 credentials object used for signing.
/// See %SYS.X509Credentials class documentation for details.</li>
/// </ul>
ClassMethod Create(service As %SOAP.WebBase, credentials As %SYS.X509Credentials)
{
	Set signature=##class(%XML.Security.Signature).CreateX509(credentials,$$$SOAPWSIncludeNone,$$$KeyInfoX509Certificate)
	
	If service.BodyXmlId="" {
		Set service.BodyXmlId="Body-"_$system.Util.CreateGUID()
	}
	Do signature.AddReference(##class(%XML.Security.Reference).Create(service.BodyXmlId))

	Set user=service.HeadersOut.GetAt("user")
	If $isobject(user) {
		If user.XmlId="" {
			Set user.XmlId="Id-"_$system.Util.CreateGUID()
		}
		Do signature.AddReference(##class(%XML.Security.Reference).Create(user.XmlId))
	}

	Set timestamp=service.HeadersOut.GetAt("timestamp")
	If $isobject(timestamp) {
		If timestamp.XmlId="" {
			Set timestamp.XmlId="Id-"_$system.Util.CreateGUID()
		}
		Do signature.AddReference(##class(%XML.Security.Reference).Create(timestamp.XmlId))
	}
	
	Set container=..%New()
	Set container.Signature=signature
	Quit container
}

/// Initialize signature
/// Alwats return true to indicate signing will take place.
Method Initialize(service As %SOAP.WebBase, status As %Status) As %Boolean [ Internal ]
{
	If service.AddressingOut="" {
		If service.%Extends("%SOAP.WebClient") {
			Set service.AddressingOut=##class(%SOAP.Addressing.Properties).GetDefaultRequestProperties(service.Location,service.Action)
		} ElseIf service.AddressingIn'="" {
			Set service.AddressingOut=##class(%SOAP.Addressing.Properties).GetDefaultResponseProperties(service.AddressingIn)
			Set service.AddressingOut.Relationship.RelationshipType=##class(%SOAP.Addressing.RelatesTo).ReplyType()
		}
	}

	Set status=..Signature.InitializeForService(service)
	Quit $$$ISOK(status)
}

/// Perform signing of HI headers
Method Perform() As %Status [ Internal ]
{
	Set sc=..Signature.Perform(0)

	If $$$ISOK(sc) {
		Set sc=..RewriteHeader()
	}
	
	Quit sc
}

/// Reset signature header
Method Reset() [ Internal ]
{
	Do ..Signature.Reset()
}

/// Validate the security signature header.
/// If invalid return an error code.
Method Validate(document As %XML.Document, service As %SOAP.WebBase) As %String [ Internal ]
{
	If '$isobject(..Signature) Quit "Not Signed"

	Quit ..Signature.ValidateElement(document,service)
}

}
