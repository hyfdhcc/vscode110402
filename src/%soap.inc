ROUTINE %soap [Type=INC]
#define FAULTVersionMismatch        "VersionMismatch"
#define FAULTMustUnderstand         "MustUnderstand"
#; SOAP 1.1 only fault codes
#define FAULTClient                 "Client"
#define FAULTServer                 "Server"
#; SOAP 1.2 only fault codes
#define FAULTDataEncodingUnknown    "DataEncodingUnknown"
#define FAULTSender                 "Sender"
#define FAULTReceiver               "Receiver"

#; XML namespaces used for SOAP 
#define XMLNSns                     "http://www.w3.org/2000/xmlns/"
#define XSDns						"http://www.w3.org/2001/XMLSchema"
#define XSIns                       "http://www.w3.org/2001/XMLSchema-instance"
#define WSDLns                      "http://schemas.xmlsoap.org/wsdl/"
#define WSDLMIMEns                  "http://schemas.xmlsoap.org/wsdl/mime/"
#define SOAPns                      "http://schemas.xmlsoap.org/wsdl/soap/"
#define SOAP12ns                    "http://schemas.xmlsoap.org/wsdl/soap12/"
#define SOAPENVns                   "http://schemas.xmlsoap.org/soap/envelope/"
#define SOAP12ENVns                 "http://www.w3.org/2003/05/soap-envelope"
#define SOAPENCns                   "http://schemas.xmlsoap.org/soap/encoding/"
#define SOAP12ENCns                 "http://www.w3.org/2003/05/soap-encoding"
#define SOAP12RPC                   "http://www.w3.org/2003/05/soap-rpc"
#define SOAPhttp                    "http://schemas.xmlsoap.org/soap/http"
#define ISCSOAPns                   "http://www.intersystems.com/soap/"
#define ISCSOAPHeaderns             "http://www.intersystems.com/SOAPheaders"
#define SOAPWSSEns                  "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
#define SOAPWSSE11ns                "http://docs.oasis-open.org/wss/oasis-wss-wssecurity-secext-1.1.xsd"
#define SOAPWSUns                   "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
#define SOAPWSAns                   "http://schemas.xmlsoap.org/ws/2004/03/addressing"
#define SOAPWSAPns                  "http://schemas.xmlsoap.org/ws/2004/08/addressing/policy"
#define SOAPWSAw3ns                 "http://www.w3.org/2005/08/addressing"
#define SOAPWSAWns                  "http://www.w3.org/2006/05/addressing/wsdl"
#define SOAPWSAMns                  "http://www.w3.org/2007/05/addressing/metadata"
#define SOAPWSPolicy12              "http://schemas.xmlsoap.org/ws/2004/09/policy"
#define SOAPWSSecurityPolicy11      "http://schemas.xmlsoap.org/ws/2005/07/securitypolicy"
#define SOAPWSPolicy15              "http://www.w3.org/ns/ws-policy"
#define SOAPWSSecurityPolicy12      "http://docs.oasis-open.org/ws-sx/ws-securitypolicy/200702"
#define SOAPWSISCConfig             "http://www.intersystems.com/configuration"
#define SOAPWSMTOMns                "http://schemas.xmlsoap.org/ws/2004/09/policy/optimizedmimeserialization"
#define SOAPWSIncludeToken11        "http://schemas.xmlsoap.org/ws/2005/07/securitypolicy/IncludeToken/"
#define SOAPWSIncludeToken12        "http://docs.oasis-open.org/ws-sx/ws-securitypolicy/200702/IncludeToken/"
#define SOAPWSRMns                  "http://docs.oasis-open.org/ws-rx/wsrm/200702"
#define SOAPWSRMPns                 "http://docs.oasis-open.org/ws-rx/wsrmp/200702"
#define SOAPWSRMP10ns               "http://schemas.xmlsoap.org/ws/2005/02/rm/policy"
 
#; Descriptive constants for WS-Security
#define SOAPWSX509v3                "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3"
#define SOAPWSEncryptedKey          "http://docs.oasis-open.org/wss/oasis-wss-soap-message-security-1.1#EncryptedKey"
#define SOAPWSDerivedKey            "http://docs.oasis-open.org/ws-sx/ws-secureconversation/200512/dk"
#define SOAPWSThumbprint            "http://docs.oasis-open.org/wss/oasis-wss-soap-message-security-1.1#ThumbprintSHA1"
#define SOAPWSEncryptedKeySHA1      "http://docs.oasis-open.org/wss/oasis-wss-soap-message-security-1.1#EncryptedKeySHA1"
#define SOAPWSSubjectKeyIdentifier  "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509SubjectKeyIdentifier"
#define SOAPWSexcc14n               "http://www.w3.org/2001/10/xml-exc-c14n#"
#define SOAPWSc14n                  "http://www.w3.org/TR/2001/REC-xml-c14n-20010315"
#define SOAPWSSTRTransform          "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#STR-Transform"
#define SOAPWSEnvelopedSignature    "http://www.w3.org/2000/09/xmldsig#enveloped-signature"
#define SOAPWSrsasha1               "http://www.w3.org/2000/09/xmldsig#rsa-sha1"
#define SOAPWSrsasha256             "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"
#define SOAPWSrsasha384             "http://www.w3.org/2001/04/xmldsig-more#rsa-sha384"
#define SOAPWSrsasha512             "http://www.w3.org/2001/04/xmldsig-more#rsa-sha512"
#define SOAPWSsha1                  "http://www.w3.org/2000/09/xmldsig#sha1"
#define SOAPWSsha256                "http://www.w3.org/2001/04/xmlenc#sha256"
#define SOAPWSsha384                "http://www.w3.org/2001/04/xmldsig-more#sha384"
#define SOAPWSsha512                "http://www.w3.org/2001/04/xmlenc#sha512"
#define SOAPWShmacsha1              "http://www.w3.org/2000/09/xmldsig#hmac-sha1"
#define SOAPWShmacsha256            "http://www.w3.org/2001/04/xmldsig-more#hmac-sha256"
#define SOAPWShmacsha384            "http://www.w3.org/2001/04/xmldsig-more#hmac-sha384"
#define SOAPWShmacsha512            "http://www.w3.org/2001/04/xmldsig-more#hmac-sha512"
#define SOAPWSrsaoaep               "http://www.w3.org/2001/04/xmlenc#rsa-oaep-mgf1p"
#define SOAPWSrsa15                 "http://www.w3.org/2001/04/xmlenc#rsa-1_5"
#define SOAPWSaes128cbc             "http://www.w3.org/2001/04/xmlenc#aes128-cbc"
#define SOAPWSaes192cbc             "http://www.w3.org/2001/04/xmlenc#aes192-cbc"
#define SOAPWSaes256cbc             "http://www.w3.org/2001/04/xmlenc#aes256-cbc"
#define SOAPWSEncryptContent        "http://www.w3.org/2001/04/xmlenc#Content"
#define SOAPWSEncryptElement        "http://www.w3.org/2001/04/xmlenc#Element"
#define SOAPWSDerivedKeyPSHA1       "http://docs.oasis-open.org/ws-sx/ws-secureconversation/200512/dk/p_sha1"
#define SOAPWSTNS                   "http://docs.oasis-open.org/ws-sx/ws-trust/200512"
#define SOAPWSTPSHA1                "http://docs.oasis-open.org/ws-sx/ws-trust/200512/CK/PSHA1"
#define SOAPWSTSecretSymKey         "http://docs.oasis-open.org/ws-sx/ws-trust/200512/SymmetricKey"
#define SOAPWSTNonce                "http://docs.oasis-open.org/ws-sx/ws-trust/200512/Nonce"
#define SOAPWSTIssue                "http://docs.oasis-open.org/ws-sx/ws-trust/200512/Issue"
#define SOAPWSTCancel               "http://docs.oasis-open.org/ws-sx/ws-trust/200512/Cancel"
#define SOAPWSTRenew                "http://docs.oasis-open.org/ws-sx/ws-trust/200512/Renew"
#define SOAPWSTSTSCancel            "http://docs.oasis-open.org/ws-sx/ws-trust/200512/CancelSTS"
#define SOAPWSTValidate             "http://docs.oasis-open.org/ws-sx/ws-trust/200512/Validate"
#define SOAPWSSCToken               "http://docs.oasis-open.org/ws-sx/ws-secureconversation/200512/sct"
#define SOAPWSSCTokenRequest        "http://docs.oasis-open.org/ws-sx/ws-trust/200512/RST/SCT"
#define SOAPWSSCTokenResponse       "http://docs.oasis-open.org/ws-sx/ws-trust/200512/RSTR/SCT"
#define SOAPWSSCTokenCancelRequest  "http://docs.oasis-open.org/ws-sx/ws-trust/200512/RST/SCT/Cancel"
#define SOAPWSSCTokenCancelResponse "http://docs.oasis-open.org/ws-sx/ws-trust/200512/RSTR/SCT/Cancel"
#define SOAPWSSCDEFAULTKEYSIZE      16
#define SOAPWSPasswordText          "PasswordText"
#define SOAPWSPasswordDigest        "PasswordDigest"
#define SOAPWSPasswordNone          "PasswordNone"
 
#; Descriptive constants for SAML
#define SAMLns                      "urn:oasis:names:tc:SAML:2.0:assertion"
#define SOAPWSSAML                  "http://docs.oasis-open.org/wss/oasis-wss-saml-token-profile-1.1#SAMLV2.0"
#define SOAPWSSAMLASSERTION         "http://docs.oasis-open.org/wss/oasis-wss-saml-token-profile-1.1#SAMLID"
#define SOAPWSSAMLASSERTION10       "http://docs.oasis-open.org/wss/oasis-wss-saml-token-profile-1.0#SAMLAssertionID"
#define SAMLHolderOfKey             "urn:oasis:names:tc:SAML:2.0:cm:holder-of-key"
#define SAMLSenderVouches           "urn:oasis:names:tc:SAML:2.0:cm:sender-vouches"
#define SAMLBearer                  "urn:oasis:names:tc:SAML:2.0:cm:bearer"
 
#; Constants for WS-Security SignatureOptions
#define SOAPWSIncludeNone             0
#define SOAPWSIncludeDefault          $$$SOAPWSIncludeSoapBody+$$$SOAPWSIncludeTimestamp+$$$SOAPWSIncludeAddressing
#define SOAPWSIncludeSoapBody         1
#define SOAPWSIncludeTimestamp        2
#define SOAPWSIncludeAddressing     508
#define SOAPWSIncludeAction           4
#define SOAPWSIncludeFaultTo          8
#define SOAPWSIncludeFrom            16
#define SOAPWSIncludeMessageId       32
#define SOAPWSIncludeRelatesTo       64
#define SOAPWSIncludeReplyTo        128
#define SOAPWSIncludeTo             256
#define SOAPWSIncludeRMHeaders      512
 
#; Constants for WS-Security Encryption Options
#define SOAPWSEncryptNone             0
#define SOAPWSEncryptDefault          $$$SOAPWSEncryptSoapBody
#define SOAPWSEncryptSoapBody         1
#define SOAPWSEncryptNoBody           2
 
#; Constants for WS-Security SecurityTokenReference/KeyInfo types
#define SOAPWSReferenceDirect           1
#define SOAPWSReferenceKeyIdentifier    2
#define SOAPWSReferenceEncryptedKeySHA1 3
#define SOAPWSReferenceThumbprint       4
#define SOAPWSReferenceIssuerSerial     5
#define KeyInfoRSAKey                   6
#define KeyInfoX509Certificate          7
#define KeyInfoX509IssuerSerial         8
#define KeyInfoX509SKI                  9
#define KeyInfoX509SubjectName         10
#define SOAPWSReferenceEncryptedKey    11
#define SOAPWSReferenceDerivedKey      12
#define SOAPWSReferenceSCT             13
#define SOAPWSReferenceSCTIdentifier   14
 
#; Miscellaneous SOAP options 
#define AllowNone                   0
#define AllowAll                    1
#define OneWayOperation             1
#define RequestResponseOperation    2
#define SolicitResponseOperation    3
#define NotificationOperation       4
 
#; Trace macros
#define SOAPLogText(%line)          Do ##class(%SOAP.WebBase).LogText(%line)
#define SOAPLogRawText(%line)       Do ##class(%SOAP.WebBase).LogText(%line,1)
#define SOAPLogSecurity(%line)      If $get(^ISCSOAP("Log"))["s" Do ##class(%SOAP.WebBase).LogText(%line)
#define SOAPLogConfigCompile(%line) If $get(^ISCSOAP("Log"))["C" Do ##class(%SOAP.WebBase).LogText(%line)
#define SOAPLogInput(%isService,%action,%stream,%status)     If $get(^ISCSOAP("Log"))["i" Do ..LogInput(%isService,%action,%stream,%status)
#define SOAPLogOutput(%isService,%action,%stream,%desc)   If $get(^ISCSOAP("Log"))["o" Do ..LogOutput(%isService,%action,%stream,%desc) 
#define CheckSOAPLogSecurity        ($get(^ISCSOAP("Log"))["s")
#define CheckSOAPLogVerbose         ($get(^ISCSOAP("Log"))["v")
#define CheckSOAPLogOutput          ($get(^ISCSOAP("Log"))["o")
#define CheckSOAPLogInput           ($get(^ISCSOAP("Log"))["i")
#define CheckSOAPTestMode           ($get(^ISCSOAP("Log"))["t")
 
#; Macros for timing XML and SOAP support.  Define XMLTIMING=1 to run timing code.
#; For Internal ISC use only
#define XMLTIMING 0

#if $$$XMLTIMING

#define XMLTimerInit             Kill ^zzXMLTimer
#define XMLTimerMark             Set %zzXMLTimer=$zh
#define XMLTimerNewMark          New %zzXMLTimer Set %zzXMLTimer=$zh
#define XMLTimerRecord(%name)    Set ^zzXMLTimer(%name,"time")=$get(^zzXMLTimer(%name,"time"))+$zh-%zzXMLTimer,^zzXMLTimer(%name,"count")=$get(^zzXMLTimer(%name,"count"))+1
#define SOAPTimer1(%var,%name)    Set ^ISCSOAPTimer($get(^ISCSOAPTimer,0),%name)=$get(^ISCSOAPTimer($get(^ISCSOAPTimer,0),%name))+$zh-%var
#define SOAPTimer1Init(%var)      Set %var=$zh
#define SOAPTimer(%name)          Set ^ISCSOAPTimer($get(^ISCSOAPTimer,0),%name)=$zh
#define SOAPTimerInit             Set ^ISCSOAPTimer($increment(^ISCSOAPTimer),"init")=$zh
#define SOAPTimerSetup(%code)     %code

#else

#define XMLTimerInit
#define XMLTimerMark
#define XMLTimerNewMark
#define XMLTimerRecord(%name)
#define SOAPTimer1(%var,%name)
#define SOAPTimer1Init(%var)
#define SOAPTimer(%name)
#define SOAPTimerInit
#define SOAPTimerSetup(%code)

#endif
 
#; Macro for XMLExport output
#; For Internal ISC use only
#define XMLUseWrite                New %xmlBlock,%xmlSize,%xmlMemoryOnly,%xmlTerminator,%xmlTable,%xmlIndex,%xmlNodeIndex,%xmlBlockIndex,%xmlData,%xmlmsg,%xmlSave
#define XMLUseGlobal               $$$XMLUseWrite Do xeInit^%occXMLInternal()
#define XMLUseNext                 If $data(%xmlBlock) Do xeNext^%occXMLInternal
#define XMLUseLast                 If $data(%xmlBlock) Do xeLast^%occXMLInternal
#define XMLTruncate                If $data(%xmlBlock) Do xeTruncate^%occXMLInternal
#define XMLReplace(%index)         If $data(%xmlBlock) Do xeReplace^%occXMLInternal(%index)
#define XMLUseRestore              Kill %xmlBlock
#define XMLSave(%var)              Kill %var Merge %var=%xmlBlock
#define XMLRestore(%var)           Kill %xmlBlock Merge %xmlBlock=%var
#define XMLSetStream(%stream)      Do xeSetStream^%occXMLInternal(%stream)
#define XMLCurrentIndex            %xmlIndex
#define XMLIsWrite                 '$data(%xmlBlock)
#define XMLSetBuffer(%text)        Set %xmlmsg=%text
#define XMLAppendBuffer(%text)     Set %xmlmsg=%xmlmsg_%text
#define XMLWrite                   If $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { Write %xmlmsg }
#define XMLWriteLine               If $data(%xmlBlock) { Do xeWriteLine^%occXMLInternal } else { Write %xmlmsg,! }
#define XMLWriteRAW                If $data(%xmlBlock) { Do xeWriteRAW^%occXMLInternal } else { Write %xmlmsg }
#define XMLWriteRAWLine            If $data(%xmlBlock) { Do xeWriteRAWLine^%occXMLInternal } else { Write %xmlmsg,! }
#define XMLWriteNL                 If $data(%xmlBlock) { Set %xmlmsg="" Do xeWriteRAWEOL^%occXMLInternal } else { Write ! }
#define XMLOutputBuffer            Do xeOutput^%occXMLInternal
#define XMLRewind                  Set %xmlNodeIndex=1,%xmlBlockIndex=1,%xmlData=""
#define XMLRewindSingle(%index)    Set %xmlNodeIndex=-%index,%xmlBlockIndex=1,%xmlData=""
#define XMLSize                    $$xeSize^%occXMLInternal()
#define XMLRead(%len)              $$xeRead^%occXMLInternal(%len)
#define XMLSetTerminator(%term)    Set %xmlTerminator=%term
#define XMLSetDefaultTerminator    Set %xmlTerminator=$select($$$isUNIX:$char(10),1:$char(13,10))
 
#; Macros for XML Schema element and class trees
#define ElTreeRoot           ^CacheTemp(i%Tree)
#def1arg ElTree(%args)       ^CacheTemp(i%Tree,1,%args)
#def1arg ClassTreeRoot       ^CacheTemp(i%Tree,2)
#def1arg ClassTree(%args)    ^CacheTemp(i%Tree,2,%args)
 
#; Macros for SOAP binary protocol.
#;	Current version of SOAP binary protocol
#define	soapBinaryVersion		1
#;	Constants to indicate if encoded
#define	soapBinaryRaw			0
#define	soapBinaryUTF8			1
#;	Top level logical block types
#define	soapBinaryHeader			"h"
#define	soapBinaryClassDefinition	"d"
#define	soapBinaryClassInstance		"i"
#define soapBinaryTopInstance		"t"
#define	soapBinaryFault				"f"
#;	Property categories from class definition.
#define	soapBinaryList			1
#define	soapBinaryArray			2
#define	soapBinaryObject		4
#define	soapBinaryLiteral		8
#;	Indicate if a literal is a character string
#define	soapBinaryLitChar		16
#;  Indicate if a literal is a binary string
#define	soapBinaryLitBin		32
#;	Buffer Control
#define soapBinaryMaxBuflen		32000
 
#;	Macros for SOAP Configuration
#;	These macros are for ISC internal use only.
#def1arg SOAPConfig(%args)                ^oddXML("-wc",%args)
#def1arg SOAPPolicy(%args)                ^oddXML("-wp",%args)
#def1arg SOAPPolicyAlternatives(%args)    ^oddXML("-wa",%args)
#def1arg SOAPConfigIndex(%args)           ^oddXML("-wx",%args)
#define SOAPConfigClass                   ":c"
#define SOAPConfigPolicyRef               ":pr"
#define SOAPConfigMethodPolicyRef         ":mr"
#define SOAPConfigInputPolicyRef          ":ir"
#define SOAPConfigOutputPolicyRef         ":or"
#define SOAPConfigPolicyNormalized        ":pn"
#define SOAPConfigMethodPolicyNormalized  ":mn"
#define SOAPConfigInputPolicyNormalized   ":in"
#define SOAPConfigOutputPolicyNormalized  ":on"
#define SOAPConfigPolicyId                 ":i"
#define SOAPConfigPolicyName               ":n"
#define SOAPConfigPolicyTop                ":t"
#define SOAPConfigPolicyWsdlElement        ":w"
#define SOAPConfigPolicy                   ":p"
#define SOAPConfigPolicyExactlyOne         ":1"
#define SOAPConfigPolicyAll                ":a"
#define SOAPConfigPolicyChildren           ":c"
#define SOAPConfigPolicyOptional           ":O"
#define SOAPConfigPolicyIgnorable          ":I"
#define SOAPConfigPolicyNamespace          ":ns"
#define SOAPConfigPolicyVersion            ":v"
#define SOAPConfigPolicyText               ":t"
#define SOAPConfigIndicator                ":"
#define SOAPParametersNode(%class)         ^oddCOM(%class,$$$cCLASSxmldata,"P")
#define SOAPParametersAction(%class,%method,%kind)         ^oddCOM(%class,$$$cCLASSxmldata,"P",%method,%kind,"Action")
#define SOAPParametersSoapActionList(%class,%soapAction)   ^oddCOM(%class,$$$cCLASSxmldata,"P",0,"soapAction",$select(%soapAction="":$c(0),1:%soapAction))
#define SOAPParametersRequestNameList(%class,%requestName) ^oddCOM(%class,$$$cCLASSxmldata,"P",0,"requestName",%requestName)
 
 
 