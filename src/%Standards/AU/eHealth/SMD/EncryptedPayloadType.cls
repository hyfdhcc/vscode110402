Include %soap

/// Implementation of Australian E-health XML secured payload profiles.
/// Document ATS 5821-2010<br><br>
/// 
/// To create an encryptedPayload just call the Create class method with a data object
/// and a %SYS.X509Credentials object that contains the certificate of the receiver.
/// Additional EncryptedKey elements may be added using the AddEncryptedKey method.<br>
/// An example of encrypting a signedPayload follows
/// <pre>
///   // obj is the oref of a data object which is a subclass of %Standards.AU.eHealth.SMD.BaseDataType
///   // obj is filled in as needed
///   // get the credentials for signing
///   set x509Sign = ##class(%SYS.X509Credentials).GetByAlias("MyConfig")
///   // sign obj using these credentials to create signedPayload
///   set payload=##class(%Standards.AU.eHealth.SMD.SignedPayloadType).Create(obj,x509Sign,.sc)
///   if $$$ISOK(sc) {
///       // get the credentials for encrypting
///       set x509Encrypt = ##class(%SYS.X509Credentials).GetByAlias("HisConfig")
///       // encrypt usiing these credentials to create encryptedPayload
///       set encryptedPayload=##class(%Standards.AU.eHealth.SMD.EncryptedPayloadType).Create(payload,x509Encrypt,.sc)
///   }
///   // if $$$ISERR(sc) report error
/// </pre>
/// 
/// To validate an encryptedPayload call the Validate method of the EncryptedPayloadType object.
/// An example of validating and decrypting an encryptd signedPayload follows.
/// This example assume that this is a web service or client and ImportHandler is the DOM
/// of the SOAP message and encryptedPayload is a web service argument or client return type.
/// These variable would need to be obtained in other ways if not SOAP situation.
/// <pre>
///   // decrypt encryptedPayload and save back to document.
///   set document=..ImportHandler
///   if encryptedPayload.Validate(.document) {
///      // find and instantiate signedPayload in decryptedPayload
///      set reader=##class(%XML.Reader).%New()
///      set reader.Document=document
///      do reader.Correlate("signedPayload","%Standards.AU.eHealth.SMD.SignedPayloadType")
///      if reader.Next(.signedPayload,.sc) {
///         set error=""
///      } else {
///         if $$$ISOK(sc) {
///            set error="no signed payload"
///         } else {
///            set error="decrypt error: "_$system.Status.GetErrorText(sc)
///         }
///      }
///   } else {
///      set error="unable to decrypt"
///      quit error
///   }
///   if error="" {
///      // validate signature.
///      set sc=signedPayload.Validate(document)
///      if $$$ISERR(sc) {
///         set error="signature error: "_$system.Status.GetErrorText(sc)
///      }
///   }
///   // if error="", then data is in signedPayload.signedPayloadData.content
///   // otherwise report error
/// </pre>
Class %Standards.AU.eHealth.SMD.EncryptedPayloadType Extends (%RegisteredObject, %XML.Adaptor) [ LegacyInstanceContext, System = 4 ]
{

Parameter XMLNAME = "encryptedPayload";

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://ns.electronichealth.net.au/xsp/xsd/EncryptedPayload/2010";

Parameter XMLPREFIX = "ep";

Property keys As %Standards.AU.eHealth.SMD.KeyListType;

Property encryptedPayloadData As %Standards.AU.eHealth.SMD.EncryptedPayloadDataType [ Required ];

/// Create an encryptedPayload and sign using a random symmetric key.<br>
/// - data is the subclass of %Standards.AU.eHealth.SMD.BaseDataType that contains the payload to encrypt.<br>
/// - credentials contains the X.509 credentials used to encrypt the random symmetric key.<br>
/// - If error, error %Status is stored in status argument.
ClassMethod Create(data As %Standards.AU.eHealth.SMD.BaseDataType, credentials As %SYS.X509Credentials = "", Output status As %Status) As %Standards.AU.eHealth.SMD.SignedPayloadType
{
	Set writer=##class(%XML.Writer).%New()
	set writer.NoXMLDeclaration=1
	Set status=writer.OutputToStream(.str)
	If $$$ISOK(status) Set status=writer.StartDocument()
	If $$$ISOK(status) Set status=writer.RootObject(data)
	If $$$ISOK(status) Set status=writer.EndDocument()
	
	If $$$ISOK(status) {
		Quit ..CreateFromStream(str,credentials,.status)
	} Else {
		Quit ""
	}
}

/// CreateFromStream creates an encryptedPayload and sign using a random symmetric key.<br>
/// - stream is stream containing the data to be encrypted encoded as UTF-8.<br>
/// - credentials contains the X.509 credentials used to encrypt the random symmetric key.<br>
/// - If error, error %Status is stored in status argument.
ClassMethod CreateFromStream(stream As %BinaryStream, credentials As %SYS.X509Credentials = "", Output status As %Status) As %Standards.AU.eHealth.SMD.SignedPayloadType
{
	// Create the EncryptedPayload object
	Set payload=..%New()
	
	// Create empty list of Encrypted keys
	Set payload.keys=##class(%Standards.AU.eHealth.SMD.KeyListType).%New()
	
	// Create the EncryptedData
	set edata=##class(%XML.Security.EncryptedData).%New()
	set edata.Algorithm=$$$SOAPWSaes256cbc
	set edata.Type=$$$SOAPWSEncryptElement
	set payload.encryptedPayloadData=##class(%Standards.AU.eHealth.SMD.EncryptedPayloadDataType).%New()
	set payload.encryptedPayloadData.EncryptedData=edata
	
	// Create random symmetric key and use it to encrypt the stream
	do stream.Rewind()
	set status=edata.EncryptStream(stream,payload.keys.EncryptedKey)
	
	// Add the EncryptedKey based on our credentials
	If $$$ISOK(status),credentials'="" {
		Set status=payload.AddEncryptedKey(credentials)
	}
	
	If $$$ISOK(status) {
		Quit payload
	} Else {
		Quit ""
	}
}

/// Add an additional EncryptedKey containing the symmetric key for the EncryptedKey element.
/// AddEncryptedKey method should be called after Create or CreateFromStream.
Method AddEncryptedKey(credentials As %SYS.X509Credentials) As %Status
{
	Set status=$$$OK
	Set encryptedKey=##class(%XML.Security.EncryptedKey).CreateX509(credentials,$$$SOAPWSEncryptNoBody,$$$KeyInfoX509SKI)
	If $isobject(encryptedKey) {
		Set encryptedData=..encryptedPayloadData.EncryptedData
		Set encryptedKey.Algorithm=encryptedData.Algorithm
		Set encryptedKey.Key=encryptedData.Key
		Do encryptedKey.SetEncryptionMethod($$$SOAPWSrsa15)
		Set status=encryptedKey.EncryptKey()
		If $$$ISERR(status) Quit status
		Do encryptedKey.AddReference(##class(%XML.Security.DataReference).Create(encryptedData))
		Do ..keys.EncryptedKey.Insert(encryptedKey)
	}
	Quit status
}

/// Validate and decrypt the EncryptedData in an encryptedPayload.<br>
/// The document argument is the DOM for the document which contains the payload.
/// The document will be modified to contain the decrypted data.
/// Then %XML.Reader may be used to extract the decrypted object.<br><br>
/// For SOAP messages, the document is in the ImportHandler property of the client or service.
/// Otherwise the payload may be exported and then the %XML.Reader OpenStream method will
/// convert the stream to a document in its Document property.<br>
/// 
Method Validate(ByRef document As %XML.Document) As %Boolean
{
	Quit ##class(%XML.Security.EncryptedData).ValidateDocument(.document,..keys.EncryptedKey)
}

}
