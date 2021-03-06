/// This SOAP header is defined as part of Medicare Australia (Federal Agency)
/// Healthcare Identifiers (HI) Service in document Healthcare Identifiers (HI) Service,
/// System Interface Specification (SIS), B2B Common Functionality Document, TECH.SIS.HI.01<br>
/// The class name is derived from the type definition in CommonCoreElements.xsd.<br>
/// The SOAP header element name is "timestamp".<br>
/// See %Standards.AU.eHealth.HI.Headers class for adding and validating headers.
Class %Standards.AU.eHealth.HI.TimestampType Extends %SOAP.Header [ System = 4 ]
{

/// The header element name and key name for HeadersIn and HeadersOut arrays.
Parameter XMLNAME = "timestamp";

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/hi/xsd/common/CommonCoreElements/3.0";

Parameter XMLPREFIX = "cce";

Property created As %TimeStamp [ Required ];

Property expires As %TimeStamp;

/// Create a Timestamp element that expires in <interval> seconds.
ClassMethod Create(interval As %Integer) As %Standards.AU.eHealth.HI.TimestampType
{
	Set timestamp=..%New()
	Set now=$ztimestamp
	Set timestamp.created=$zdt(now,3)
	If $data(interval) {
		Set day=$piece(now,",",1)
		Set sec=$piece(now,",",2)+interval
		Set secsInDay=60*60*24
		Set timestamp.expires=$zdt((day+(sec\secsInDay))_","_(sec#secsInDay),3)
	}
	Quit timestamp
}

/// Validate the security timestamp header.
/// If invalid return an error code.
Method Validate(document As %XML.Document, service As %SOAP.WebBase) As %String [ Internal ]
{
	If ..expires'="" {
		Set expires=$zdth(..expires,3)
		Set now=$ztimestamp
		If (now>expires) || 
		   (($piece(now,",",1)=$piece(expires,",",1)) &&
		    ($piece(now,",",2)>$piece(expires,",",2))) {
				$$$SOAPLogSecurity("Security TimeStamp validation failed.  Expires="_..expires_", Now="_$zdt(now,3))
				Quit "MessageExpired"
		}
	}
	$$$SOAPLogSecurity("Security TimeStamp validated")
	Quit ""
}

}
