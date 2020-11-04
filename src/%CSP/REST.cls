Include %occSAX

IncludeGenerator %occSAX

/// Applications wishing to support REST should subclass this class, implement the methods to be called
/// and define a UrlMap XDATA block which maps Urls and request Method (DELETE/GET/POST/PUT) to those methods
/// Users define a csp web application which will be serviced by their custom subclass. To achieve this,in the
/// management portal set the 'Dispatch Class' to the name of the custom subclass of THIS class. See the
/// csp/samples/docserver web application and the corresponding REST.DocServer sample in the SAMPLES namespace
Class %CSP.REST Extends Page [ System = 4 ]
{

Parameter CONTENTTYPEJSON As %String = "application/json";

Parameter CONTENTTYPETEXT As %String = "text/plain";

Parameter HTTP200OK As %String = "200 OK";

Parameter HTTP201CREATED As %String = "201 Created";

Parameter HTTP202ACCEPTED As %String = "202 Accepted";

Parameter HTTP204NOCONTENT As %String = "204 No Content";

Parameter HTTP400BADREQUEST As %String = "400 Bad Request";

Parameter HTTP304NOTMODIFIED As %String = "304 Not Modified";

Parameter HTTP401UNAUTHORIZED As %String = "401 Unauthorized";

Parameter HTTP403FORBIDDEN As %String = "403 Forbidden";

Parameter HTTP404NOTFOUND As %String = "404 Not Found";

Parameter HTTP405METHODNOTALLOWED As %String = "405 Method Not Allowed";

Parameter HTTP406NOTACCEPTABLE As %String = "406 Not Acceptable";

Parameter HTTP409CONFLICT As %String = "409 Conflict";

Parameter HTTP415UNSUPPORTEDMEDIATYPE = "415 Unsupported Media Type";

Parameter HTTP423LOCKED = "423 Locked";

Parameter HTTP500INTERNALSERVERERROR As %String = "500 Internal Server Error";

/// 
/// The UrlMap determines how a Url should map to a HTTP Method and a Target ClassMethod
/// indicated by the 'Call' attribute. The call attribute is either the name of a method
/// or the name of a class and method seperated by a ':'. Parameters within the URL preceded
/// by a ':' will be extracted from the supplied URL and passed as arguments to the named method.
/// 
/// In this Route Entry GET requests to /class/namespace/classname will call the GetClass method
/// 
/// <Route Url="/class/:namespace/:classname" Method="GET" Call="GetClass"/>
/// 
/// To influence CORS processing you can set the "Cors" attribute to "true", default is "false".
/// The "Cors" attribute is only considered if the PARAMETER 'HandleCorsRequest' is left unspecified.
/// 
/// <Route Url="/class/:namespace/:classname" Method="GET" Call="GetClass" Cors="true"/>
/// 
/// Use a Map Entry to forward ALL requests made to a particular URL prefix. For example. If your 
/// web application has a base url route of /api/v1 and you want to map all requests to 
/// /api/v1/docserver (including all sub-urls) enter a Map entry like this:
/// 
/// <Map Prefix="/docserver" Forward="%Api.v1.DocServer"/>
/// 
/// This will result in calls such as /api/v1/docserver/class/Samples/Sample.Person being redirected
/// to the class %API.v1.DocServer ( another subclass of %CSP.REST )for futher processing. 
XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!--
<Route Url="/class/:namespace/:classname" Method="GET" Call="GetClass" Cors="true"/>
<Map Prefix="/docserver" Forward="%Api.v1.DocServer"/>
-->
</Routes>
}

/// This parameter controls the CSP session support. By default the CSP session will be
/// ended after each request in accordance with the spirit of REST. However this CAN be
/// overridden by the user. To use a session, it's necessary to manage the CSPSESSION cookie.
/// Browsers do this automatically but command line tools such as CURL require the setting of
/// options.<p>
/// Note that if you choose to use a session then this will use a CSP license until the session
/// is ended or expires and the grace period has been satisfied. If you use the default of no
/// session then this will be the same behavior as SOAP requests of holding a license for ten
/// seconds.
Parameter UseSession As BOOLEAN = 0;

/// This parameter influences the CORS support. The default is an empty string meaning 'not specified'.
/// If set to true (1) then CORS processing is ON. If set to false (0) then CORS processing is OFF.
/// If left unset "" then the decision to process CORS is delegated to the setting on the URL map route.
Parameter HandleCorsRequest;

/// This method matches matches the request and method and calls the dispatcher
ClassMethod Page(skipheader As %Boolean = 1) As %Status [ ProcedureBlock = 0 ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tAuthorized,tRedirected As %Boolean
    #dim tRedirectRoutine,tURL As %String = ""
    #dim %response As %CSP.Response
        
    Try {

        #; Ensure that we honor the requested charset 
        Set %response.CharSet=..#CHARSET

        #; Ensure that we honor the requested CONTENTTYPE
        If ..#CONTENTTYPE'="" Set %response.ContentType=..#CONTENTTYPE 

        #; Ensure that we honor the requested HTTP_ACCEPT_LANGUAGE 
        Do %response.MatchLanguage() 
        
        #; Record if device re-direction is already active
        Set tRedirected=##class(%Library.Device).ReDirectIO()
        
        #; Record the redirect routine
        Set tRedirectRoutine=$System.Device.GetMnemonicRoutine()
        
        #; Now switch to using THIS routine for device redirection
        Use $io::("^%SYS.cspServer2")
        
        #; Switch device redirection on (may already be on but thats ok)
        Do ##class(%Library.Device).ReDirectIO(1)
        
        #; Ensure that the application is defined (security check)
        If $$$GetSecurityApplicationsDispatchClass(%request.AppData)="" {
             
             #; Report not authorized
             Set tSC=..Http403()
             
             #; Done
             Quit
        }
        
        #; GgiEnvs are not defined in the CSP shell
        Set tURL=$Get(%request.CgiEnvs("CSPLIB"))
        If tURL="" Set tURL=%request.URL
        
        #; Ensure that any query string is not taken into account
        Set tURL=$Piece(tURL,"?")
          
        #; Do an access check
        Set tSC=..AccessCheck(.tAuthorized)
        If $$$ISERR(tSC) Quit

        If tAuthorized=0 {
            
            #; Don't want the session token
            Set %response.OutputSessionToken=0
            
            #; Set the Http Status
            Set %response.Status=..#HTTP401UNAUTHORIZED
            
            #; Done
            Quit
        }
        
        #; Dispatch the request
        Do ..DispatchRequest(tURL,%request.Method)
        
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    
    #; Ensure that at least something is written out as the body
    #; This will trigger the device redirect capture and force headers to be written
    #; (if not already done)
    Write ""
    
    #; Reset redirect device if necessary
    If tRedirected {
        
        #; Use the original redirected routine
        Use $io::("^"_tRedirectRoutine)
        
        #; Switch device redirection on
        Do ##class(%Library.Device).ReDirectIO(1)
    }
    
    #; Any errors should have been caught and reported
    Quit $$$OK
}

/// Called for a REST page in the event of an error being trapped by CSP server
ClassMethod Error(skipheader As %Boolean = 1) As %Status
{
    #dim e As %Exception.AbstractException
    
    #; We don't want the session token
    Set %response.OutputSessionToken=0
    
    Quit ..Http500(##class(%Exception.StatusException).CreateFromStatus(%request.Get("Error:ErrorCode")))
}

/// Called for a REST page in the event of a login being required
ClassMethod Login(skipheader As %Boolean = 1) As %Status [ ProcedureBlock = 0 ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tMatchURL As %String
           
    Try {
        
        #; Don't want the session token
        Set %response.OutputSessionToken=0
        
        Set tMatchURL=$Extract(%request.URL,$Length(%request.Application),*)
      
        #; Process CORS request
        Set tSC=..ProcessCorsRequest(tMatchURL)
        If $$$ISERR(tSC) Quit
            
        If %request.Method="OPTIONS" {
            
            #; We want to allow OPTIONS requests even if not authorized
            Set tSC=..OnHandleOptionsRequest(tMatchURL)
            If $$$ISERR(tSC) Quit
         
        } else {
            
            #; Set the Http Status
            Set %response.Status=..#HTTP401UNAUTHORIZED
            
            #; We want Basic authentication
            Do %response.SetHeader("WWW-Authenticate","Basic")
        }
        
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    
    #; We need to manually write out the headers here because PAGE has not been called
    Do %response.WriteHTTPHeader()
        
    #; Done
    Quit tSC
}

/// This methods provides handling of the options request.
/// Note carefully: If authentication is required then this method will be
/// called before login and as such will have only limited privileges
ClassMethod OnHandleOptionsRequest(pUrl As %String) As %Status
{
    #; Simply dispatch to the default implementation
    Quit ..HandleDefaultOptionsRequest(pUrl)
}

/// Handle an OPTIONS request
ClassMethod HandleDefaultOptionsRequest(pUrl As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tOrigin,tHeaders,tSupportedVerbs As %String
    
    Try {
       
        #; No content
        Set %response.ContentType="",tSupportedVerbs=""
        Set tSC=..SupportedVerbs(pUrl,.tSupportedVerbs)
        If $$$ISERR(tSC) Quit
      
        Do %response.SetHeader("Allow",tSupportedVerbs)
       
    } Catch (e) {
        
        Set tSC=e.AsStatus()
    }
    Quit tSC
}

/// Determine if this request requires CORS processing and if so, dispatch to OnHandleCorsRequest
ClassMethod ProcessCorsRequest(pUrl As %String, pRequireCors As %String = "") As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Try {
        
        #; Parameter over-rides
        If ($zcvt(..#HandleCorsRequest,"U")="FALSE")||(..#HandleCorsRequest="0") {
            
            #; Override says DO NOT handle
            Quit
        }

        If ($zcvt(..#HandleCorsRequest,"U")="TRUE")||(..#HandleCorsRequest="1") {
            
            #; Override says DO handle
            Set tSC=..OnHandleCorsRequest(pUrl)
            Quit
        }
        
        #; Parameter is NOT set, honor ROUTE cors setting
        If pRequireCors="true" {
            
            Set tSC=..OnHandleCorsRequest(pUrl)
            Quit
        }
        
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    Quit tSC
}

/// This is the CORS request handler. User should override this method in their subclass
/// if they don't want the default behavior
ClassMethod OnHandleCorsRequest(pUrl As %String) As %Status
{

    #; The default implementation is simply to dispatch to the 
    #; default handler
    Quit ..HandleDefaultCorsRequest(pUrl)
}

/// Provide reasonable default handling for a CORS-enabled request for those who
/// 'JUST WANT IT TO WORK'
ClassMethod HandleDefaultCorsRequest(pUrl As %String) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim %request As %CSP.Request
    #dim %response As %CSP.Response
    
    #dim tOrigin,tHeaders,tMethod As %String
    
    Try {
        
        #; Get the origin
        Set tOrigin=$Get(%request.CgiEnvs("HTTP_ORIGIN"))
            
        #; Allow requested origin
        Do ..SetResponseHeaderIfEmpty("Access-Control-Allow-Origin",tOrigin)
       
        #; Set allow credentials to be true
        Do ..SetResponseHeaderIfEmpty("Access-Control-Allow-Credentials","true")
        
        #; Allow requested headers
        Set tHeaders=$Get(%request.CgiEnvs("HTTP_ACCESS_CONTROL_REQUEST_HEADERS"))
        Do ..SetResponseHeaderIfEmpty("Access-Control-Allow-Headers",tHeaders)
        
        #; Allow requested method
        Set tMethod=$Get(%request.CgiEnvs("HTTP_ACCESS_CONTROL_REQUEST_METHOD"))
        Do ..SetResponseHeaderIfEmpty("Access-Control-Allow-Methods",tMethod)
        
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    Quit tSC
}

/// This method Gets called prior to dispatch of the request. Put any common code here
/// that you want to be executed for EVERY request. If pContinue is set to 0, the
/// request will NOT be dispatched according to the UrlMap. If this case it's the
/// responsibility of the user to return a response.
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
    Quit $$$OK
}

/// This method performs a basic access check. You can override this to add additional checks
ClassMethod AccessCheck(Output pAuthorized As %Boolean = 0) As %Status
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tAccess As %String
    
    Try {
        #; Check that the effective user ( could be unknown user ) can access this resource
        Set tAccess=$SYSTEM.Security.Check($Piece($zu(90,21,$namespace),"^",4))
        If tAccess["READ,WRITE"
        {
           Set pAuthorized=1
        }
    } catch (e) {
        Set tSC=e.AsStatus()
    }
    Quit tSC
}

/// Dispatch a REST request according to URL and Method
ClassMethod DispatchRequest(pUrl As %String, pMethod As %String, pForwarded As %Boolean = 0) As %Status
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tMatcher As %Regex.Matcher
    
    #dim tArgs,tClass,tMatchUrl,tMapEntry,tRegEx,tCall,tForward,tAccess,tSupportedVerbs,tTarget,tType As %String
    #dim tI,tIndex As %Integer
    #dim tResourceMatched,tContinue As %Boolean
    #dim tMethodMatched As %Boolean
    
    Try {
        
        Set (tResourceMatched,tMethodMatched)=0
                
        #; Extract the match url from the application name
        If (0=pForwarded) {
            Set tMatchUrl="/"_$Extract(pUrl,$Length(%request.Application)+1,*)
        } else {
            Set tMatchUrl=pUrl
        }
      
        #; Uppercase the method
        Set pMethod=$ZCVT(pMethod,"U")
          
        #; Pre-Dispatch
        Set tContinue=1,tSC=..OnPreDispatch(tMatchUrl,pMethod,.tContinue)
        If $$$ISERR(tSC) Quit
        
        #; It's the users responsibility to return the response in OnPreDispatch() if Continue = 0
        If tContinue=0 Quit
            
        #; Walk the dispatch map in collation order of defintion
        For tIndex=1:1 {
            
            #; Get the next map entry
            Set tMapEntry=..DispatchMap(tIndex) If tMapEntry="" Quit
             
            #; Pick out the RegEx
            Set tRegEx=$List(tMapEntry,2)
            
            #; Create a matcher
            Set tMatcher=##class(%Regex.Matcher).%New(tRegEx)
            
            #; Test each regular expression in turn, extracting the arguments,
            #; dispatching to the named method  
            If tMatcher.Match(tMatchUrl) {
                
                #; We have matched the resource
                Set tResourceMatched=1
                
                Set tType=$List(tMapEntry,1)
                
                #; If we are a simple route
                If tType="R" {
                   
                    #; Support OPTIONS VERB (cannot be overriden)
                    If pMethod="OPTIONS" {
                        
                        Set tMethodMatched=1 
                       
                        Set tSC=..OnHandleOptionsRequest(tMatchUrl)
                        If $$$ISERR(tSC) Quit
                        
                        #; Dispatch CORS
                        Set tSC=..ProcessCorsRequest(pUrl,$list(tMapEntry,5))
                        If $$$ISERR(tSC) Quit
                        
                        Quit
                    }
                    
                    #; comparison is case-insensitive now
                    If pMethod'=$ZCVT($List(tMapEntry,3),"U") Continue
                    
                    Set tTarget=$List(tMapEntry,4)
                    
                    #; We have matched a method
                    Set tMethodMatched=1
                    
                    #; Dispatch CORS
                    Set tSC=..ProcessCorsRequest(pUrl,$list(tMapEntry,5))
                    If $$$ISERR(tSC) Quit
                   
                    #; Got a match, marshall the arguments can call directly
                    If tMatcher.GroupCount {
                        For tI=1:1:tMatcher.GroupCount Set tArgs(tI)=tMatcher.Group(tI)
                        Set tArgs=tI
                    } else {
                        Set tArgs=0
                    }
                    
                    #; Check for optional ClassName prefix
                    Set tClass=$classname()
                    If tTarget[":" Set tClass=$Piece(tTarget,":"),tTarget=$Piece(tTarget,":",2)
                    
                    #; Dispatch
                    Set tSC=$zobjclassmethod(tClass,tTarget,tArgs...)
                       
                } else {
                    
                    #; We are a map, massage the URL and forward the request
                    Set tMatchUrl=$piece(tMatchUrl,tMatcher.Group(1),"2",*),tForward=$ListGet(tMapEntry,3)
                    Set (tResourceMatched,tMethodMatched)=1
                   
                    #; Dispatch with modified URL 
                    Set tSC=$zobjclassmethod(tForward,"DispatchRequest",tMatchUrl,pMethod,1)
                }
                
                If $$$ISERR(tSC) {
                   
                    Do ..Http500(##class(%Exception.StatusException).CreateFromStatus(tSC))
                    
                    #; Reset status (already been reported)
                    Set tSC=$$$OK
                }
                
                #; Don't want multiple matches
                Quit
            }
        }
        
        #; Didn't have a match for the resource, report not found
        If tResourceMatched=0 Set tSC=..ReportHttpStatusCode(..#HTTP404NOTFOUND) Quit
                  
        #; Had a match for resource but method not matched
        If tMethodMatched=0 {
            
            Set tSC=..SupportedVerbs(tMatchUrl,.tSupportedVerbs)
            If $$$ISERR(tSC) Quit
            
            Set tSC=..Http405(tSupportedVerbs) Quit
        }
            
    } Catch (e) {
        
        #; Issue a '500'
        Do ..Http500(e)
    }
    
    Quit tSC
}

/// Issue an 'Http' error
ClassMethod ReportHttpStatusCode(pHttpStatus, pSC As %Status = {$$$OK}) As %Status
{
    Set %response.Status=pHttpStatus
    
    If $$$ISERR(pSC) Do ..outputStatus(pSC)
        
    Quit $$$OK
}

/// Issue an '403' error (Deprecated, use ..ReportHttpStatusCode)
ClassMethod Http403(pSC As %Status = {$$$OK}) As %Status [ Final ]
{
    #; Delegate
    Quit ..ReportHttpStatusCode(..#HTTP403FORBIDDEN,pSC)
}

/// Issue an '404' error (Deprecated, use ..ReportHttpStatusCode)
ClassMethod Http404(pSC As %Status = {$$$OK}) As %Status [ Final ]
{
    #; Delegate
    Quit ..ReportHttpStatusCode(..#HTTP404NOTFOUND,pSC)
}

/// Issue an '405' error ( user can override)
ClassMethod Http405(pSupportedVerbs As %String = "") As %Status
{
    #; No content
    Set %response.ContentType=""
    
    #; Fix up the reported verbs
    Do %response.SetHeader("Allow",pSupportedVerbs)
           
    Quit ..ReportHttpStatusCode(..#HTTP405METHODNOTALLOWED)
}

/// Issue an '500' error and give some indication as to what occurred
ClassMethod Http500(pE As %Exception.AbstractException) As %Status
{
    #; Set up for an HTTP status
    Quit ..ReportHttpStatusCode(..#HTTP500INTERNALSERVERERROR,pE.AsStatus())
}

/// This method takes a status, renders it as jason (if requested) and outputs the result
ClassMethod outputStatus(pSC As %Status) As %Status [ Internal ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Try {
        
        #dim tJSON As %ZEN.proxyObject
    
        If ..AcceptsContentType("application/json") {
        
            Set %response.ContentType = ..#CONTENTTYPEJSON
        
            #; Convert the exception to a status and render to JSON
            Set tSC = ..StatusToProxyObject(pSC, .tJSON)
            If $$$ISERR(tSC) Quit

            #; Write the JSON to the output device
            Set tSC = tJSON.%ToJSON()
            If $$$ISERR(tSC) Quit
            
        } else {
            
            #; Set plain text
            Set %response.ContentType = ..#CONTENTTYPETEXT
            
            #; Write out a simple text message
            Do ##class(%Exception.StatusException).CreateFromStatus(pSC).OutputToDevice()
        }
        
    } Catch (e) {
        
        #; Oops
        Set tSC = e.AsStatus()
    }
    Quit $$$OK
}

/// This generator creates the SupportedVerbs Method used to determine supported verbs for return via 405 HTTP Status
ClassMethod SupportedVerbs(pUrl, Output pVerbs As %String) As %Status [ CodeMode = generator, GenerateAfter = ResolveTarget ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tStream As %Stream.TmpCharacter
    #dim tHandler As %XML.ImportHandler
    #dim tCompiledClass As %Dictionary.CompiledClass
    
    #dim tArgCount,tIndex,tI,tCounter As %Integer
    #dim tAllow,tArgs,tChild,tClassName,tError,tMap,tMethod,tUrl,tType,tPiece,tPattern As %String
    
    Try {
        
        Set tClassName=%classname
        
        #; Don't run on base class
        If tClassName="%CSP.REST" Quit
       
        #; Find named XDATA block
        If ##class(%Dictionary.CompiledXData).%ExistsId(tClassName_"||UrlMap") {
            
            Set tCompiledClass=##class(%Dictionary.CompiledClass).%OpenId(tClassName,,.tSC)
            If '$IsObject(tCompiledClass)||$$$ISERR(tSC) Quit
            
            Set tIndex = tCompiledClass.XDatas.FindObjectId(tClassName_"||UrlMap")
            If tIndex="" Set tSC=$$$ERROR($$$XDataBlockMissing,tClassName,"UrlMap") Quit
        
            #; Get XDATA as stream
            Set tStream = tCompiledClass.XDatas.GetAt(tIndex).Data
            Do tStream.Rewind()
            
            #; Create an XML import handler ( use the internal handler )
            Set tHandler=##class(%XML.ImportHandler).%New("CacheTemp",$$$IntHandler) 
        
            #; Create the Entity Resolver
            Set tResolver=##class(%XML.SAX.XDataEntityResolver).%New(tClassName)
        
            #; Parse the XML data in the specfied stream
            Set tSC=##Class(%XML.SAX.Parser).ParseStream(tStream,tHandler,tResolver,,,"Schema")
            If $$$ISERR(tSC) Quit       
        
            #; Copy tree because handler will delete it's copy when it goes out of scope
            Merge tMap=^CacheTemp(tHandler.Tree)
    
            If $Data(tMap("error"))||$Data(tMap("warning")) {
                
                Set tSC=$$$ERROR($$$InvalidDispatchMap)
                For tType="error","warning" {       
                    Set tIndex = "" For {
                        Set tIndex=$Order(tMap(tType,tIndex),1,tError) If tIndex="" Quit
                        Set tSC=$$$ADDSC(tSC,$$$ERROR($$$GeneralError,tError))
                    }
                }
                Quit
            }
                      
            #; Walk the xml and collect all the methods for each url.
            Set tChild="" For {
                
                Set tChild=$Order(tMap(1,"c",tChild)) If tChild="" Quit
                If tMap(tChild)="Route" {
                    
                    Set tUrl=tMap(tChild,"a","Url"),tMethod=tMap(tChild,"a","Method"),tPattern=""
                    
                    #; Substitute variable placeholders for capture group
                    For tI=1:1:$Length(tUrl,"/") {
                        Set tPiece=$Piece(tUrl,"/",tI)
                        If $Extract(tPiece)=":" {
                            Set $Piece(tPattern,"/",tI)="([^"_$Char(0)_"]+)"
                        } else {
                            Set $Piece(tPattern,"/",tI)=tPiece                  }
                    }
                    Set tPattern=$Translate(tPattern,$Char(0),"/")
                    
                    Set tAllow(tPattern,tMethod)=""
                }   
            }
                       
            $$$GENERATE(" Set pVerbs="""",tSC=$$$OK")
            $$$GENERATE(" Do {")
            $$$GENERATE("   Set tSC=..ResolveTarget(pUrl,.tTargetUrl,.tTargetClass)")
            $$$GENERATE("   If $$$ISERR(tSC)||((tTargetUrl="""")&&(tTargetClass="""")) Quit")
            $$$GENERATE("   If (tTargetUrl'=pUrl)&&(tTargetClass'=$classname()) {")
            $$$GENERATE("       Set tSC=$zobjclassmethod(tTargetClass,""SupportedVerbs"",tTargetUrl,.pVerbs)")
            $$$GENERATE("       Quit")
            $$$GENERATE("   }")
            
            #; Walk the allowed methods and generate a entry
            Set tPattern="" For {
               
                Set tPattern=$Order(tAllow(tPattern)) If tPattern="" Quit
                
                Set (tAllow,tMethod)="" For {
                    Set tMethod=$Order(tAllow(tPattern,tMethod)) If tMethod="" Quit
                    Set tAllow=tAllow_tMethod_","
                }
                
                #; Add OPTIONS
                Set tAllow=tAllow_"OPTIONS"
                
                $$$GENERATE("   If ##class(%Regex.Matcher).%New("""_tPattern_""").Match(pUrl) Set pVerbs="""_tAllow_""" Quit")
            }
            $$$GENERATE(" } while 0")
            $$$GENERATE(" Quit tSC")
                
        } else {
            
            #; The specified class must have an XDATA Block named UrlMap
            Set tSC=$$$ERROR($$$XDataBlockMissing,tClassName,"UrlMap")
        }
        
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    
    Quit tSC
}

/// This resolves the target class and url according to the forwarding rules
ClassMethod ResolveTarget(pOriginalUrl As %String, Output pTargetUrl As %String = "", Output pTargetClass As %String = "") As %Status
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tIndex As %Integer
    #dim tMapEntry As %List
    #dim tClass,tRegEx,tType As %String
    
    #dim tMatcher As %Regex.Matcher
    #dim tMatched As %Boolean = 0
    
    Try {
        
        #; Walk the dispatch map in collation order of defintion
        For tIndex=1:1 {
            
            #; Get the next map entry
            Set tMapEntry=..DispatchMap(tIndex) If tMapEntry="" Quit
             
            #; Pick out the RegEx
            Set tRegEx=$List(tMapEntry,2)
            
            #; Create a matcher
            Set tMatcher=##class(%Regex.Matcher).%New(tRegEx)
        
            #; Test each regular expression in turn, extracting the arguments,
            #; dispatching to the named method  
            If tMatcher.Match(pOriginalUrl) {
                
                Set tType=$List(tMapEntry,1)
                
                #; If we are a simple route
                If tType="R" {
                    
                    Set pTargetUrl=pOriginalUrl
                    Set pTargetClass=$classname()
         
                } else {
                    
                    #; We are a map, massage the URL and forward the request
                    Set pTargetUrl=$piece(pOriginalUrl,tMatcher.Group(1),"2",*)
                    Set pTargetClass=$List(tMapEntry,3)
                }
                
                #; Successful match, search no further     
                Quit
            }
        }
    
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    Quit tSC
}

/// This generator creates the DispatchMap Method used to dispatch the Url and Method to the associated target method
ClassMethod DispatchMap(pIndex As %Integer) As %String [ CodeMode = generator ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tStream As %Stream.TmpCharacter
    #dim tHandler As %XML.ImportHandler
    #dim tCompiledClass As %Dictionary.CompiledClass
    
    #dim tArgCount,tIndex,tI,tCounter As %Integer
    #dim tArgs,tChild,tClassName,tCall,tCors,tForward,tError,tMap,tMethod,tPattern,tPiece,tPrefix,tType,tUrl As %String
    
    Try {
        
        Set tClassName=%classname
        
        #; Don't run on base class
        If tClassName="%CSP.REST" Quit
       
        #; Find named XDATA block
        If ##class(%Dictionary.CompiledXData).%ExistsId(tClassName_"||UrlMap") {
            
            Set tCompiledClass=##class(%Dictionary.CompiledClass).%OpenId(tClassName,,.tSC)
            If '$IsObject(tCompiledClass)||$$$ISERR(tSC) Quit
            
            Set tIndex = tCompiledClass.XDatas.FindObjectId(tClassName_"||UrlMap")
            If tIndex="" Set tSC=$$$ERROR($$$XDataBlockMissing,tClassName,"UrlMap") Quit
        
            #; Get XDATA as stream
            Set tStream = tCompiledClass.XDatas.GetAt(tIndex).Data
            Do tStream.Rewind()
            
            #; Create an XML import handler ( use the internal handler )
            Set tHandler=##class(%XML.ImportHandler).%New("CacheTemp",$$$IntHandler) 
        
            #; Create the Entity Resolver
            Set tResolver=##class(%XML.SAX.XDataEntityResolver).%New(tClassName)
        
            #; Parse the XML data in the specfied stream
            Set tSC=##Class(%XML.SAX.Parser).ParseStream(tStream,tHandler,tResolver,,,"Schema")
            If $$$ISERR(tSC) Quit       
        
            #; Copy tree because handler will delete it's copy when it goes out of scope
            Merge tMap=^CacheTemp(tHandler.Tree)
    
            If $Data(tMap("error"))||$Data(tMap("warning")) {
                
                Set tSC=$$$ERROR($$$InvalidDispatchMap)
                For tType="error","warning" {       
                    Set tIndex = "" For {
                        Set tIndex=$Order(tMap(tType,tIndex),1,tError) If tIndex="" Quit
                        Set tSC=$$$ADDSC(tSC,$$$ERROR($$$GeneralError,tError))
                    }
                }
                Quit
            }
            
            #; Walk the xml and generate the routing map
            Set tChild="",tCounter=0 For {
                
                Set tChild=$Order(tMap(1,"c",tChild)) If tChild="" Quit
                
                If tMap(tChild)="Route" {
                    
                #; Need to substitute capture groups for arguments
                Set tPattern="",tArgCount=0,tUrl=tMap(tChild,"a","Url"),tCors=tMap(tChild,"a","Cors")
                        
                #; Substitute variable placeholders for capture group
                For tI=1:1:$Length(tUrl,"/") {
                    Set tPiece=$Piece(tUrl,"/",tI)
                    If $Extract(tPiece)=":" {
                        Set $Piece(tPattern,"/",tI)="([^"_$Char(0)_"]+)"
                    } else {
                        Set $Piece(tPattern,"/",tI)=tPiece                  }
                }
                Set tPattern=$Translate(tPattern,$Char(0),"/")

                Set tCounter=$Increment(tCounter),tMethod=tMap(tChild,"a","Method"),tCall=$Get(tMap(tChild,"a","Call"))
                                    
                $$$GENERATE(" If pIndex="_tCounter_" Quit $ListBuild(""R"","""_tPattern_""","""_tMethod_""","""_tCall_""","""_tCors_""")")
                
            } else {
                
                Set tCounter=$Increment(tCounter),tPrefix=tMap(tChild,"a","Prefix"),tForward=$Get(tMap(tChild,"a","Forward"))

                #; Need to substitute capture groups for arguments
                Set tPattern=""
                For tI=2:1:$Length(tPrefix,"/") {
                    Set tPiece=$Piece(tPrefix,"/",tI)
                    If $Extract(tPiece)=":" {
                        Set tPattern=tPattern_"/[^/]+"
                    } else {
                        Set tPattern=tPattern_"/"_tPiece
                    }
                }
                
                Set tPattern = "("_ tPattern _ ")/.*"
                
                $$$GENERATE(" If pIndex="_tCounter_" Quit $ListBuild(""M"","""_tPattern_""","""_tForward_""")")
            }
            }
            $$$GENERATE(" Quit """"")
                
        } else {
            
            #; The specified class must have an XDATA Block named UrlMap
            Set tSC=$$$ERROR($$$XDataBlockMissing,tClassName,"UrlMap")
        }
        
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    
    Quit tSC
}

/// Render a %Status as JSON (in the form of an array of objects representing each status value).
ClassMethod StatusToProxyObject(pSC As %Status, ByRef pJSON As %ZEN.proxyObject) As %Status [ Final ]
{
    #dim tStatus As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Try {
        
        #dim tErrors
        #dim tIndex As %Integer
        
        Set pJSON = ##class(%ZEN.proxyObject).%New()
        Set pJSON.errors = ##class(%ListOfDataTypes).%New()
        Set pJSON.summary = $system.Status.GetErrorText(pSC)

        #; Now, decompose the status and render as JSON
        Do $system.Status.DecomposeStatus(pSC, .tErrors)

        For tIndex = 1:1:$Get(tErrors) {
            
            #dim tObj As %ZEN.proxyObject
            #dim tIndex2 As %Integer

            #; Compose an error object          
            Set tObj = ##class(%ZEN.proxyObject).%New()         
            Set tObj.error = tErrors(tIndex)
            Set tObj.code = $Get(tErrors(tIndex,"code"))
            Set tObj.domain = $Get(tErrors(tIndex,"domain"))

            #; Try to map the error code to it's mnemonic; e.g. 5809 becomes LoadObjectNotFound         
            Set tObj.id = ..mnemonicForStatusCode(tObj.code)
            
            #; Process any parameters
            If +$Get(tErrors(tIndex,"param"))>0 {
                
                #; This will be a list
                Set tObj.params = ##class(%ListOfDataTypes).%New()
                
                For tIndex2 = 1:1:tErrors(tIndex,"param") {
                    Do tObj.params.Insert(tErrors(tIndex,"param",tIndex2))
                }
            }
            
            #; Handle any embedded status codes
            If +$Get(tErrors(tIndex,"embeddederror"))>0 {
                
                #; This will be a list of "sub" errors
                Set tObj.errors = ##class(%ListOfObjects).%New()
                
                For tIndex2 = 1:1:tErrors(tIndex,"embeddederror") {
                    
                    #dim tSubObj As %ZEN.proxyObject
                    #dim tIndex3 As %Integer
                    
                    #; Render the embedded error as JSON
                    Set tStatus = ..StatusToProxyObject(tErrors(tIndex,"embeddederror",tIndex2),.tSubObj)
                    Quit:$$$ISERR(tStatus)
                    
                    #; Merge the embedded errors into our list (there should only be one per tIndex2)
                    For tIndex3 = 1:1:tSubObj.errors.Count() {
                        Do tObj.errors.Insert(tSubObj.errors.GetAt(tIndex3))
                    }
                }
            }
            
            #; Accumulate the error(s) into a list
            Do pJSON.errors.Insert(tObj)
        }

    } Catch (e) {
        Set tStatus = e.AsStatus()
    }
    
    Quit tStatus
}

/// Render a %Status as JSON (in the form of an array of objects representing each status value).
ClassMethod StatusToJSON(pSC As %Status, ByRef pJSON As %DynamicObject) As %Status [ Final ]
{
    #dim tStatus As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Try {
        
        #dim tErrors
        #dim tIndex As %Integer
        
        Set pJSON = {}
        Set pJSON.errors = []
        Set pJSON.summary = $system.Status.GetErrorText(pSC)

        #; Now, decompose the status and render as JSON
        Do $system.Status.DecomposeStatus(pSC,.tErrors)

        For tIndex = 1:1:+$Get(tErrors) {
            
            #dim tObj As %DynamicObject
            #dim tIndex2 As %Integer

            #; Compose an error object          
            Set tObj = {}
            Set tObj.error = tErrors(tIndex)
            Set tObj.code = $Get(tErrors(tIndex,"code"))
            Set tObj.domain = $Get(tErrors(tIndex,"domain"))

            #; Try to map the error code to it's mnemonic; e.g. 5809 becomes LoadObjectNotFound         
            Set tObj.id = ..mnemonicForStatusCode(tObj.code)
            
            #; Process any parameters
            If +$Get(tErrors(tIndex,"param"))>0 {
                
                #; This will be a list
                Set tObj.params = []
                
                For tIndex2 = 1:1:tErrors(tIndex,"param") {
                    Do tObj.params.%Push(tErrors(tIndex,"param",tIndex2))
                }
            }
            
            #; Handle any embedded status codes
            If +$Get(tErrors(tIndex,"embeddederror"))>0 {
                
                #; This will be a list of "sub" errors
                Set tObj.errors = []
                
                For tIndex2 = 1:1:tErrors(tIndex,"embeddederror") {
                    
                    #dim tSubObj As %DynamicObject
                    #dim tIndex3 As %Integer
                    
                    #; Render the embedded error as JSON
                    Set tStatus = ..StatusToJSON(tErrors(tIndex,"embeddederror",tIndex2),.tSubObj)
                    Quit:$$$ISERR(tStatus)
                    
                    #; Merge the embedded errors into our list (there should only be one per tIndex2)
                    For tIndex3 = 0:1:tSubObj.errors.%Size()-1 {
                        Do tObj.errors.%Push(tSubObj.errors.%Get(tIndex3))
                    }
                }
            }
            
            #; Accumulate the error(s) into a list
            Do pJSON.errors.%Push(tObj)
        }

    } Catch (e) {
        Set tStatus = e.AsStatus()
    }
    
    Quit tStatus
}

/// Convert a status code value into it's mnemonic (if available)
ClassMethod mnemonicForStatusCode(pCode As %String) As %String [ Internal ]
{
    #dim tMnemonic As %String = ""
    #dim tGbl As %String
    #dim tDomain As %String
    
    #; Avoid a subscript error below
    If pCode="" Quit ""
    
    #; Look for <xxxx>yyyyy
    If pCode?1"<"1.an1">"1.an {
        
        #; Self-decribing
        Quit $TR(pCode,"<>","")
    }
    
    // Numeric code; we need to look them up in the msg global(s)
    For tGbl = "^CacheMsgNames","^%qCacheMsgNames" {
        If $System.Security.GetGlobalPermission(,tGbl)'["READ" {
            Continue
        }
        Set tDomain = ""
        For {
            Set tDomain = $Order(@tGbl@(tDomain))
            Quit:tDomain=""
        
            If $Data(@tGbl@(tDomain,pCode)) {
                Set tMnemonic = ^(pCode)
                Quit
            }
        }
        Quit:tMnemonic'=""
    }
    
    Quit $Select(tMnemonic="":pCode,1:tMnemonic)
}

/// This utility method sets a response header only if it currently does not have a value
ClassMethod SetResponseHeaderIfEmpty(pHeader As %String, pValue As %String)
{
    If pValue'="" {
        If %response.GetHeader(pHeader)="" Do %response.SetHeader(pHeader,pValue)
    }
}

/// This method tests the HTTP_ACCEPT header and returns true if
/// the passed content type is acceptable
ClassMethod AcceptsContentType(pType As %String) As %Boolean
{
    #dim tAcceptHdr,tOneType As %String
    #dim tI As %Integer

    #; Get the accept header
    Set tAcceptHdr=$Get(%request.CgiEnvs("HTTP_ACCEPT"),"*/*")
        
    #; Scan header pieces to see if there is any match
    For tI=1:1:$Length(tAcceptHdr,",") {
        Set tOneType=$Piece($Piece(tAcceptHdr,",",tI),";")
        If (tOneType="*/*")||(tOneType=pType) Return 1
    }
    Return 0
}

/// This is the Schema which defines the form of the dispatch map
XData Schema [ Internal ]
{
<?xml version="1.0"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" >

<xs:element name="Routes">
<xs:complexType>
<xs:choice  minOccurs="0" maxOccurs="unbounded">
<xs:element name="Route">
<xs:complexType>
<xs:attribute name="Url"    type="string" use="required"/>
<xs:attribute name="Method" type="string" use="required"/>
<xs:attribute name="Call" type="call" use="required"/>
<xs:attribute name="Cors" type="xs:boolean" use="optional" default="false"/>
</xs:complexType>
</xs:element>
<xs:element name="Map">
<xs:complexType>
<xs:attribute name="Prefix" type="string" use="required"/>
<xs:attribute name="Forward" type="forward" use="required"/>
</xs:complexType>
</xs:element>
</xs:choice>
</xs:complexType>
</xs:element>

<xs:simpleType name="call">
<xs:restriction base="xs:string">
<xs:pattern value="([%]?[a-zA-Z][a-zA-Z0-9]*(\.[a-zA-Z][a-zA-Z0-9]*)*:)?[%]?[a-zA-Z][a-zA-Z0-9]*"/>
</xs:restriction>
</xs:simpleType>

<xs:simpleType name="forward">
<xs:restriction base="xs:string">
<xs:pattern value="([%]?[a-zA-Z][a-zA-Z0-9]*(\.[a-zA-Z][a-zA-Z0-9]*)*)"/>
</xs:restriction>
</xs:simpleType>

<xs:simpleType name="string">
<xs:restriction base="xs:string">
<xs:minLength value="1"/>
</xs:restriction>
</xs:simpleType>

</xs:schema>
}

}
