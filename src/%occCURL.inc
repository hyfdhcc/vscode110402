ROUTINE %occCURL [Type=INC]
#; CURL library definitions ( derived from CURL.h )
#; See http://curl.haxx.se/ for comprehensive information
 
#; Port number to connect to, if other than default.
#define CurlPORT            3
 
#; Network timeout
#define CurlTIMEOUT			13
 
#; SLL Version
#define CurlSSLVERSION		32
 
#; Port of the proxy, can also be set in the proxy string "[host]:[port]"
#define CurlPROXYPORT		59
 
#; Set this to 1 to enable peer verification in SSL handshake, 0 to disable ( default is enabled )
#define CurlSSLVERIFYPEER	64
 
#; Set if we should verify the Common name from the peer certificate in ssl
#; handshake, set 1 to check existence, 2 to ensure that it matches the
#; provided hostname, 0 to disable. ( default is 2)
#define CurlSSLVERIFYHOST	81
 
#; Set this to a bitmask value to enable the particular authentications
#; methods you like. Use this in combination with CurlUSERPWD.
#; Note that setting multiple bits may cause extra network round-trips
#define CurlHTTPAUTH		107
 
#; Set this to a bitmask value to enable the particular authentications
#; methods you like. Use this in combination with CurlPROXYUSERPWD.
#; Note that setting multiple bits may cause extra network round-trips
#define CurlPROXYAUTH		111
 
#; "[host]:[port]" of proxy to use when fetching	
#define CurlPROXY	        10004
 
#; "name:password" to use when fetching.
#define CurlUSERPWD         10005
 
#; "name:password" to use with proxy.
#define CurlPROXYUSERPWD	10006
 
#; name of the file keeping your private SSL-certificate
#define CurlSSLCERT			10025
 
#; password for the SSL private key
#define CurlSSLKEYPASSWD    10026
 
#; The CApath or CAfile used to validate the peer certificate this option is used only if CurlSSLVERIFYPEER is non zero
#define CurlCAINFO			10065
 
#; The CApath directory used to validate the peer certificate this option is used only if CurlSSLVERIFYPEER is non zero
#define CurlCAPATH			10097
 
#; These are the Authentication BitFlags to be used with CurlHTTPAUTH and CurlPROXYAUTH
#define CurlAuthNONE            0
#define CurlAuthBASIC           1
#define CurlAuthDIGEST			2
#define CurlAuthGSS				4
#define CurlAuthNTLM			8 
 
#; These are INFO types for use with the %XML.SAX.Utils.NetRequest.Logger class
#define CurlInfoTEXT			0
#define CurlInfoHEADERIN		1
#define CurlInfoHEADEROUT		2
#define CurlInfoDATAIN			3
#define CurlInfoDATAOUT			4
#define CurlInfoSSLDATAIN		5
#define CurlInfoSSLDATAOUT		6
 
#; These are the SSL Versions to be used with CurlSSLVERSION
#define CurlSSLVersionDEFAULT	0
#define CurlSSLVersionTLSv1		1
#define CurlSSLVersionSSLv2		2
#define CurlSSLVersionSSLv3		3