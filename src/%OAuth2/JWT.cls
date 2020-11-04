Include %callout

Class %OAuth2.JWT Extends %RegisteredObject [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
WDS594 10/29/15 David Shambroom, UTF-8 decode JWT Claims Set
WDS579 08/04/15 David Shambroom, HMAC signature algorithms
WDS575 06/29/15 David Shambroom, Return Signature and/or Encryption algorithms
                as an array
WDS566 06/26/15 David Shambroom, JSON Web Tokens (JWT), Signature (JWS),
                and Encryption (JWE)
-------------------End Documentation----------------------------------
*/
/// This method generates a JSON Web Token (JWT) performing signature and/or encryption operations as requested.<br>
/// <br>
/// Input parameters:<br>
/// <br>
/// JOSE - Array of Strings used to set the JSON Object Signature and/or Encryption operations to be performed on the JWT<br>
/// <br>
/// For JSON Web Signature (JWS):<br><br>
/// JOSE("sigalg") - Signature or MAC algorithm, supported options are:<br>
/// "HS256", HMAC with SHA-256<br>
/// "HS384", HMAC with SHA-384<br>
/// "HS512", HMAC with SHA-512<br>
/// "RS256", RSASSA-PKCS1-V1_5 using SHA-256<br>
/// "RS384", RSASSA-PKCS1-V1_5 using SHA-384<br>
/// "RS512", RSASSA-PKCS1-V1_5 using SHA-512<br>
/// <br>
/// For JSON Web Encryption (JWE):<br><br>
/// JOSE("keyalg") - Key management algorithm, supported options are:<br>
/// "RSA1_5", Encryption with RSAES-PKCS1-V1_5<br>
/// "RSA-OAEP", Encryption with RSAES-OAEP<br><br>
/// JOSE("encalg") - Content encryption algorithm, supported options are:<br>
/// "A128CBC-HS256", 128-bit AES in CBC mode with HMAC SHA-256<br>
/// "A192CBC-HS384", 192-bit AES in CBC mode with HMAC SHA-384<br>
/// "A256CBC-HS512", 256-bit AES in CBC mode with HMAC SHA-512<br><br>
/// Note, JOSE("keyalg") and JOSE("encalg") must both be specified or null.<br>
/// <br>
/// If JWS and JWE are both specified the JWT will be signed, then encrypted.<br>
/// <br>
/// Body - Object representation of the Claims contained in the JWT<br>
/// Note, if a property of Body is intended to be represented as a JSON Array it must be of type %ListOfDataTypes<br>
/// <br>
/// Local - Array of Strings containing additional data associate with the local system<br>
/// Local("alias") - Alias of a X509Credentials object containing a private key, certificate, and CA certificate file<br>
/// Local("password") - Password for private key if it is not specified in the X509Credentials object<br>
/// <br>
/// Remote - Array of Strings containing additional data associate with the remote system<br>
/// Remote("alias") - Alias of a X509Credentials object containing a certificate<br>
/// <br>
/// JWT - Output String containing JSON Web Token<br>
ClassMethod ObjectToJWT(ByRef JOSE As %String, Body As %DynamicAbstractObject, ByRef Local As %String, ByRef Remote As %String, Output JWT As %String) As %Status
{
#define BASE64URLENCODE(%x) $tr($p($SYSTEM.Encryption.Base64Encode(%x,1),"=",1),"+/","-_")
#define BASE64URLDECODE(%x) $SYSTEM.Encryption.Base64Decode($tr(%x,"-_","+/")_$case($length(%x)#4,0:"",2:"==",3:"="))
#define ALGTYPE(%x) $case(%x,"none":0,"HS256":1,"HS384":1,"HS512":1,"RS256":1,"RS384":1,"RS512":1,"RSA1_5":2,"RSA-OAEP":2,"A128CBC-HS256":3,"A192CBC-HS384":3,"A256CBC-HS512":3,:"")
#define AESBLOCKLEN 16
	Set st=$$$OK
	Try {
	Set sigalg=$g(JOSE("sigalg"))
	Set keyalg=$g(JOSE("keyalg"))
	Set encalg=$g(JOSE("encalg"))
	If (((keyalg'="")&&(encalg=""))||((keyalg="")&&(encalg'=""))) {
		Set st=$$$ERROR($$$GeneralError,"Invalid JOSE keyalg and encalg values")
		Quit
	}
	Set body=Body.%ToJSON()
	Set body=$zcvt(body,"O","UTF8")
	Set b64body=$$$BASE64URLENCODE(body)
	If sigalg="",keyalg="" {
		Set Header=##class(%DynamicObject).%New()
		Set Header.typ="JWT"
		Set Header.alg="none"
		Set header=Header.%ToJSON()
		Set header=$zcvt(header,"O","UTF8")
		Set b64header=$$$BASE64URLENCODE(header)
		Set JWT=b64header_"."_b64body_"."
	}
	If (sigalg'="") {
		If $$$ALGTYPE(sigalg)'=1 {
			Set st=$$$ERROR($$$GeneralError,"Invalid JOSE sigalg value")
			Quit
		}
		Set Header=##class(%DynamicObject).%New()
		Set Header.typ="JWT"
		Set Header.alg=sigalg
		Set header=Header.%ToJSON()
		Set header=$zcvt(header,"O","UTF8")
		Set b64header=$$$BASE64URLENCODE(header)
		Set size=$e(sigalg,3,5)
		If ($e(sigalg,1,2)="RS") {
			Set x509=##class(%SYS.X509Credentials).GetByAlias(Local("alias"))
			Set privateKey=x509.PrivateKey
			Set privateKeyPassword=x509.PrivateKeyPassword
			If privateKeyPassword="" Set privateKeyPassword=$get(Local("password"))
			Set sig=$SYSTEM.Encryption.RSASHASign(size,b64header_"."_b64body,privateKey,privateKeyPassword)
			Set b64sig=$$$BASE64URLENCODE(sig)
		} ElseIf ($e(sigalg,1,2)="HS") {
			Set sharedKey = $get(Local(sigalg))
			Set sig=$SYSTEM.Encryption.HMACSHA(size,b64header_"."_b64body,sharedKey)
			Set b64sig=$$$BASE64URLENCODE(sig)
		}
		Set JWT=b64header_"."_b64body_"."_b64sig
	}
	If (keyalg'="") {
		If ($$$ALGTYPE(keyalg)'=2)||($$$ALGTYPE(encalg)'=3) {
			Set st=$$$ERROR($$$GeneralError,"Invalid JOSE keyalg and/or encalg value(s)")
			Quit
		}
		Set Header=##class(%DynamicObject).%New()
		Set Header.typ="JWT"
		Set Header.alg=keyalg
		Set Header.enc=encalg
		If (sigalg'="") {
			Set Header.cty="JWT"
			Set body=JWT
		}
		Set header=Header.%ToJSON()
		Set header=$zcvt(header,"O","UTF8")
		Set b64header=$$$BASE64URLENCODE(header)
		If (keyalg="RSA1_5") { Set encoding=2 }
		ElseIf keyalg=("RSA-OAEP") { Set encoding=1 }
		Set keysize=$e(encalg,2,4)
		Set keylen=keysize/8
		Set hashsize=$e(encalg,11,13)
		Set key=$SYSTEM.Encryption.GenCryptRand(2*keylen,1)
		Set hashkey=$e(key,1,keylen)
		Set cipherkey=$e(key,keylen+1,2*keylen)
		Set x509=##class(%SYS.X509Credentials).GetByAlias(Remote("alias"))
		Set certificate=x509.Certificate
		Set cAFile=x509.CAFile
		Set enckey=$SYSTEM.Encryption.RSAEncrypt(key,certificate,cAFile,"",encoding)
		Set b64enckey=$$$BASE64URLENCODE(enckey)
		Set IV=$SYSTEM.Encryption.GenCryptRand($$$AESBLOCKLEN,1)
		Set b64IV=$$$BASE64URLENCODE(IV)
		Set cipher=$System.Encryption.AESCBCEncrypt(body,cipherkey,IV)
		Set b64cipher=$$$BASE64URLENCODE(cipher)
		Set hdrlen=$nconvert(8*$l($$$BASE64URLENCODE(header)),"S8",1)
		Set tag=$SYSTEM.Encryption.HMACSHA(hashsize,b64header_IV_cipher_hdrlen,hashkey)
		Set tag=$e(tag,1,keylen)
		Set b64tag=$$$BASE64URLENCODE(tag)
		Set JWT=b64header_"."_b64enckey_"."_b64IV_"."_b64cipher_"."_b64tag
	}
	} Catch ex {
		Set st=ex.AsStatus()
	}
	Quit st
}

/// This method processes a JSON Web Token (JWT), performing decryption and/or signature verification operations as required.<br>
/// <br>
/// JWT - String containing JSON Web Token<br>
/// <br>
/// Local - Array of Strings containing additional data associate with the local system<br>
/// Local("alias") - Alias of a X509Credentials object containing a private key, certificate, and CA certificate file<br>
/// Local("password") - Password for private key if it is not specified in the X509Credentials object<br>
/// <br>
/// Remote - Array of Strings containing additional data associate with the remote system<br>
/// Remote("alias") - Alias of a X509Credentials object containing a certificate<br>
/// <br>
/// JOSE - Output Array of Strings containing the algorithms used for
/// Signature and/or Encryption operations performed on the JWT<br>
/// (See the class documentation for ObjectToJWT() for details.)<br>
/// <br>
/// Body - Output Object representation of the claims contained in the JWT<br>
ClassMethod JWTToObject(JWT As %String, ByRef Local As %String, ByRef Remote As %String, Output JOSE As %String, Output Body As %RegisteredObject) As %Status
{
#define BASE64URLENCODE(%x) $tr($p($SYSTEM.Encryption.Base64Encode(%x,1),"=",1),"+/","-_")
#define BASE64URLDECODE(%x) $SYSTEM.Encryption.Base64Decode($tr(%x,"-_","+/")_$case($length(%x)#4,0:"",2:"==",3:"="))
#define ALGTYPE(%x) $case(%x,"none":0,"HS256":1,"HS384":1,"HS512":1,"RS256":1,"RS384":1,"RS512":1,"RSA1_5":2,"RSA-OAEP":2,"A128CBC-HS256":3,"A192CBC-HS384":3,"A256CBC-HS512":3,:"")
#define AESBLOCKLEN 16
	Set st=$$$OK
	Try {
NEXT
	Set b64header=$p(JWT,".",1)
	Set header=$$$BASE64URLDECODE(b64header)
	Set header=$zcvt(header,"I","UTF8")
	Set Header=##class(%DynamicAbstractObject).%FromJSON(header)
	Set alg=Header.alg
	If alg="" Set st=$$$ERROR($$$GeneralError,"Missing header parameter: ""alg""") Quit
	Set algtyp=$$$ALGTYPE(alg)
	Set enc=Header.enc
	Set cty=Header.cty
	If (algtyp="") {
		Set st=$$$ERROR($$$GeneralError,"Invalid header parameter: ""alg"":"""_alg_"""")
		Quit
	} ElseIf (algtyp=0) {
		If enc'="" {
			Set st=$$$ERROR($$$GeneralError,"Invalid header parameters: ""alg"":"_alg_""",""enc"":"""_enc_"""")
			Quit
		}
		If $l(JWT,".")'=3 {
			Set st=$$$ERROR($$$GeneralError,"Invalid JWT format")
			Quit
		}
		Set body=$$$BASE64URLDECODE($p(JWT,".",2))
		Set body=$zcvt(body,"I","UTF8")
		Set Body=##class(%DynamicAbstractObject).%FromJSON(body)
	} ElseIf (algtyp=1) {
		If enc'="" {
			Set st=$$$ERROR($$$GeneralError,"Invalid header parameters: ""alg"":"_alg_""",""enc"":"""_enc_"""")
			Quit
		}
		If $l(JWT,".")'=3 {
			Set st=$$$ERROR($$$GeneralError,"Invalid JWT format")
			Quit
		}
		If $get(Remote("alias"))="" {
			Set st=$$$ERROR($$$GeneralError,"Remote credentials must be specified to check signature")
			Quit
		}
		Set JOSE("sigalg")=alg
		Set body=$$$BASE64URLDECODE($p(JWT,".",2))
		Set body=$zcvt(body,"I","UTF8")
		Set Body=##class(%DynamicAbstractObject).%FromJSON(body)
		Set size=$e(alg,3,5)
		Set sig=$$$BASE64URLDECODE($p(JWT,".",3))
		If ($e(alg,1,2)="RS") {
			Set x509=##class(%SYS.X509Credentials).GetByAlias(Remote("alias"))
			Set certificate=x509.Certificate
			Set cAFile=x509.CAFile
			If ('$SYSTEM.Encryption.RSASHAVerify(size,$p(JWT,".",1,2),sig,certificate,cAFile,"")) {
				Set st=$$$ERROR($$$GeneralError,"Signature verificatiion failure")
				Quit
			}
		} ElseIf ($e(alg,1,2)="HS") {
			Set sharedKey = $get(Remote(alg))
			If ($SYSTEM.Encryption.HMACSHA(size,$p(JWT,".",1,2),sharedKey)'=sig) {
				Set st=$$$ERROR($$$GeneralError,"Signature verificatiion failure")
				Quit
			}
		}
	} ElseIf (algtyp=2) {
		If enc="" {
			Set st=$$$ERROR($$$GeneralError,"Missing header parameter: ""enc""")
			Quit
		}
		If ($$$ALGTYPE(enc)'=3) {
		Set st=$$$ERROR($$$GeneralError,"Invalid header parameter: ""enc"":"""_enc_"""")
			Quit
		}
		If $l(JWT,".")'=5 {
			Set st=$$$ERROR($$$GeneralError,"Invalid JWT format")
			Quit
		}
		If $get(Local("alias"))="" {
			Set st=$$$ERROR($$$GeneralError,"Local credentials must be specified to decrypt")
			Quit
		}
		Set JOSE("keyalg")=alg
		Set JOSE("encalg")=enc
		If (alg="RSA1_5") { Set encoding=2 }
		ElseIf alg=("RSA-OAEP") { Set encoding=1 }
		Set keysize=$e(enc,2,4)
		Set keylen=keysize/8
		Set hashsize=$e(enc,11,13)
		Set enckey=$$$BASE64URLDECODE($p(JWT,".",2))
		Set IV=$$$BASE64URLDECODE($p(JWT,".",3))
		Set cipher=$$$BASE64URLDECODE($p(JWT,".",4))
		Set tag=$$$BASE64URLDECODE($p(JWT,".",5))
		Set x509=##class(%SYS.X509Credentials).GetByAlias(Local("alias"))
		Set privateKey=x509.PrivateKey
		Set privateKeyPassword=x509.PrivateKeyPassword
		If privateKeyPassword="" Set privateKeyPassword=$get(Local("password"))
		Set key=$SYSTEM.Encryption.RSADecrypt(enckey,privateKey,privateKeyPassword,encoding)
		If $l(key)'=(2*keylen) {
			Set st=$$$ERROR($$$GeneralError,"Invalid key length")
			Quit
		}
		Set hashkey=$e(key,1,keylen)
		Set cipherkey=$e(key,keylen+1,2*keylen)
		Set hdrlen=$nconvert(8*$l(b64header),"S8",1)
		If $e($SYSTEM.Encryption.HMACSHA(hashsize,b64header_IV_cipher_hdrlen,hashkey),1,keylen)'=tag {
			Set st=$$$ERROR($$$GeneralError,"Authentication tag verification failure")
			Quit
		}
		Set body=$System.Encryption.AESCBCDecrypt(cipher,cipherkey,IV)
		If (cty="JWT") {
			Set JWT=body
			GoTo NEXT
		}
		Set body=$zcvt(body,"I","UTF8")
		Set Body=##class(%DynamicAbstractObject).%FromJSON(body)
	}
	} Catch ex {
		Set st=ex.AsStatus()
		If $$$GETERRORCODE(st)=$$$ERRORCODE($$$GeneralException) {
			Set st=$$$ERROR($$$GeneralError,"Invalid JWT format ("_$system.Status.GetErrorText(st)_")")
		}
	}
	Quit st
}

}
