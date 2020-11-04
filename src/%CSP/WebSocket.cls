Include (%occInclude, %occErrors, %cspInclude)

/// The <CLASS>%CSP.WebSocket</CLASS> object serves as an event handler for communication between client and
/// server using the WebSocket protocol (<B>RFC 6455</B>).  All WebSocket servers derive from %CSP.WebSocket.
Class %CSP.WebSocket Extends (%RegisteredObject, %CSP.Page) [ ServerOnly = 1 ]
{

Parameter UseSession = 0;

Parameter NOCHARSETCONVERT = 1;

/// This property determines whether the communication between the client and WebSocket server should be over a dedicated Gateway
/// conection or over a pool of shared connections.  It may be set to one of the following:
/// <br><ul>
/// <li><b>SharedConnection=0</b> - The WebSocket server communicates with the client via a dedicated Gateway connection. In this mode of operation the hosting connection is effectively 'private' to the application session.</li>
/// <li><b>SharedConnection=1</b> - The WebSocket server communicates asynchronously with the client via a fixed number of shared Gateway connections.</li>
/// </ul>
Property SharedConnection As %Boolean [ InitialExpression = 0 ];

/// This property determines whether formal data framing should occur between the CSP Gateway and Cache
/// <br><ul>
/// <li><b>NoDataFraming=0</b> - Use the READ and WRITE methods in this class to manage I/O with the WebSocket.</li>
/// <li><b>NoDataFraming=1</b> - Use the basic Cache READ and WRITE commands to manage I/O with the WebSocket (<b>SharedConnection</b> cannot be set with this mode).</li>
/// </ul>
Property NoDataFraming As %Boolean [ InitialExpression = 0 ];

/// This property determines whether the data streams transmitted between the client and server should be treated as binary.
/// The default setting is to treat the incoming and outgoing data as UTF-8 encoded text.
/// <br><br>
/// This property may be set to one of the following:
/// <br><ul>
/// <li><b>BinaryData=0</b> - UTF-8 encoded text.</li>
/// <li><b>BinaryData=1</b> - Binary Data.</li>
/// </ul>
Property BinaryData As %Boolean [ InitialExpression = 0 ];

/// The unique identity of this WebSocket.
Property WebSocketID As %String;

/// The CSP Session ID from which this WebSocket was created.
Property SessionId As %String;

/// The address through which a WebSocket operating asynchronously (<property>SharedConnection=1</property>) can communicate with the hosting CSP Gateway.
Property GWClientAddress As %String;

/// The <var>AtEnd</var> property is set to true (1) when, during a read, 
/// the WebSocket server has reached the end of the current data frame.
Property AtEnd As %Boolean [ InitialExpression = 1 ];

/// The amount of client data waiting to be read.
Property BytesAvailable As %Integer [ InitialExpression = 0, Private ];

/// The type of the Data Frame waiting to be read.
Property DataFrameType As %Integer [ InitialExpression = 0, Private ];

/// The flag indicating that WebSocket data framing should be used for write operations.
Property WSDataFraming As %Integer [ InitialExpression = 0, Private ];

/// The version of the transmission protocol between the CSP Gateway and this Cache Class.
Property WSClassProtocolVersion As %Integer [ InitialExpression = 2, Private ];

/// Event handler for the <b>PreServer</b> event: this is invoked before
/// starting the WebSockets Server.
/// Changes to the <property>SharedConnection</property> flag must be made here.
Method OnPreServer() As %Status
{
	Quit $$$OK
}

/// Event handler for the <b>PostServer</b> event: this is invoked after
/// closing the WebSockets Server.
Method OnPostServer() As %Status
{
	Quit $$$OK
}

/// The WebSocket Server.  Use the <Method>Read</Method> and <Method>Write</Method> methods
/// to receive data from, and send data to, the client.
/// Call the <Method>EndServer</Method> method to gracefully terminate the WebSocket Server.
/// A WebSocket operating asynchronously (<property>SharedConnection=1</property>) can exit this method (using <b>Quit</B>) and subsequently open the WebSocket using the <Method>OpenServer</Method> method.
Method Server() As %Status
{
	Set status=..EndServer()
	Quit $$$OK
}

/// Internal method to initialize the WebSocket Class.
Method Initialize(WebSocketID As %String = "", GWClientAddress As %String = "") As %Status
{
	Set $ZT="InitializeError"
	Set ..WebSocketID = WebSocketID
	Set ..GWClientAddress = GWClientAddress
	Quit $$$OK
InitializeError	
	#; No interrupts during cleanup or error processing
	$$$SetExternalInterrupts(0)
	Set $ZTrap="InitializeHalt"
	Hang 5
	Close 0
InitializeHalt 
	Halt
}

/// Internal method to initialize the WebSocket Server.
Method InitializeServer() As %Status
{
	Set $ZT="InitializeServerError"
	Set ..WSDataFraming = 0
	If ..NoDataFraming>0 Set ..SharedConnection=0
	Set SharedConnection = ..SharedConnection
	Set ..SharedConnection = 0
	Set data="CacheSP: p=0;chd=1;ato=3600;"_$Char(13,10)
	Set data=data_"HTTP/1.1 200 OK"_$Char(13,10)
	Set data=data_"Content-type: text/html"_$Char(13,10)
	Set data=data_"Connection: close"_$Char(13,10)
	Set data=data_"WSClassProtocolVersion: "_..WSClassProtocolVersion_$Char(13,10)
	Set data=data_"SharedConnection: "_SharedConnection_$Char(13,10)
	Set data=data_"NoDataFraming: "_..NoDataFraming_$Char(13,10)
	Set data=data_"BinaryData: "_..BinaryData_$Char(13,10)
	Set data=data_$Char(13,10)
	Set data=data_"WebSocket Server"_$Char(13,10)
	Set status=..Write(data)
	Do $ZU(166,1)
	Set data="CacheSP: p=0;chd=1;ato=3600;"_$Char(13,10)
	Set status=..Write(data)
	Do $ZU(166,1)
	Set ..SharedConnection = SharedConnection
	Set ..WSDataFraming = 1
	Set status = ..SaveServer()
	If ..NoDataFraming = 2 {
		#; Turn off Cache data framing (sectioned write)
		Use 0:(::"-B")
	}
	Quit $$$OK
InitializeServerError	
	#; No interrupts during cleanup or error processing
	$$$SetExternalInterrupts(0)
	Set $ZTrap="InitializeServerHalt"
	Hang 5
	Close 0
InitializeServerHalt 
	Halt
}

/// Internal method to save the WebSocket Server.
Method SaveServer() As %Status [ Private ]
{
	If ..WebSocketID = "" {
		Quit 0
	}
	Set ^CacheTemp.cspWebSockets("SERVER", ..WebSocketID, "SessionId")=..SessionId
	Set ^CacheTemp.cspWebSockets("SERVER", ..WebSocketID, "GWClientAddress")=..GWClientAddress
	Set ^CacheTemp.cspWebSockets("SERVER", ..WebSocketID, "SharedConnection")=..SharedConnection
	Set ^CacheTemp.cspWebSockets("SERVER", ..WebSocketID, "WSDataFraming")=..WSDataFraming

	Quit $$$OK
}

/// Internal method to delete the WebSocket Server.
Method DeleteServer() As %Status [ Private ]
{
	If ..WebSocketID = "" {
		Quit 0
	}
	Kill ^CacheTemp.cspWebSockets("SERVER", ..WebSocketID)
	Kill ^CacheTemp.cspWebSockets("READ", ..WebSocketID)
	Kill ^CacheTemp.cspWebSockets("DATA", ..WebSocketID)
	Quit $$$OK
}

/// Method to open an existing WebSocket Server.
/// Only a WebSocket operating asynchronously (<property>SharedConnection=1</property>) can be accessed using this method.
Method OpenServer(WebSocketID As %String = "") As %Status
{
	If WebSocketID = "" {
		Quit 0
	}
	Set ..WebSocketID=WebSocketID
	Set ..SessionId = $Get(^CacheTemp.cspWebSockets("SERVER", ..WebSocketID, "SessionId"))
	Set ..GWClientAddress = $Get(^CacheTemp.cspWebSockets("SERVER", ..WebSocketID, "GWClientAddress"))
	Set ..SharedConnection = $Get(^CacheTemp.cspWebSockets("SERVER", ..WebSocketID, "SharedConnection"))
	Set ..WSDataFraming = $Get(^CacheTemp.cspWebSockets("SERVER", ..WebSocketID, "WSDataFraming"))

	Quit $$$OK
}

/// Gracefully terminate the WebSocket Server.
Method EndServer() As %Status
{
	If (..SharedConnection = 1) {
		Set status=$$CSPGWClientRequest^%SYS.cspServer3(..GWClientAddress,"WSX "_..WebSocketID,-5,.response)
		Set status=..OnPostServer()
	}
	Set status=..DeleteServer()
	Quit $$$OK
}

/// Reads up to len characters from the client.
/// If the call is successful the status (sc) will be returned as $$$OK, otherwise an error code of $$$CSPWebSocketTimeout 
/// indicates a timeout and $$$CSPWebSocketClosed indicates that the client has terminated the WebSocket.
Method Read(ByRef len As %Integer = 32656, ByRef sc As %Status, timeout As %Integer = 86400) As %String
{
	Set $ZTrap="ReadError"
	If len<1 Set len=32656
	If (..SharedConnection = 1) {
		Set data1=..ReadAsync(.len, .sc, timeout)
		Set len=$Length(data1)
		Quit data1
	}
	If ..BytesAvailable Goto ReadData
	Set ..BytesAvailable=0,..AtEnd=0
	Read header#5:timeout
	If $Test=0 {
		Set len=0
		Set sc=$$$ERROR($$$CSPWebSocketTimeout,"WebSocket Read Operation timed-out")
		Set ..AtEnd=1
		Quit ""
	}
	Set ..DataFrameType=$Extract(header,5)
	If ..DataFrameType = 9 {
		Set len=0
		Set sc=$$$ERROR($$$CSPWebSocketClosed,"WebSocket Closed by the Client")
		Set ..AtEnd=1
		Quit ""
	}
	Set header=$Extract(header, 1, 4)
	Set size=$ZLA(header)-1 If size<0 Set size=0
	Set ..BytesAvailable=size
ReadData
	If ..BytesAvailable > len {
		Set size=len
		Set ..BytesAvailable=..BytesAvailable-len
	}
	else {
		Set size=..BytesAvailable
		Set ..BytesAvailable=0
	}
	If '..BytesAvailable Set ..AtEnd=1
	If size=0 Set len=0,sc=$$$OK Quit ""
	Read data#size
	Set len=size
	Set sc=$$$OK
	If ((..DataFrameType = 8) ! (..BinaryData = 1)) {
		Set data1=data
	}
	Else {
		Try { Set data1=$zconvert(data,"I","UTF8") } Catch { Set data1=data }
	}
	Set len=$Length(data1)
	Quit data1
ReadError	
	#; No interrupts during cleanup or error processing
	Do event^%SYS.cspServer2("WebSocket Read Error: "_$ZError)
	$$$SetExternalInterrupts(0)
	Set $ZTrap="ReadHalt"
	Hang 5
	Close 0
ReadHalt 
	Halt
}

Method ReadAsync(ByRef len As %Integer = 32656, ByRef sc As %Status, timeout As %Integer = 86400) As %String [ Private ]
{
	Set $ZTrap="ReadAsyncError"
	Set ..AtEnd=0
	Set to=0
	Set ^CacheTemp.cspWebSockets("READ",..WebSocketID)=$Job
	Set data="",chunk="",to=0
ReadAsyncLoop ; Look for data to read
	Set $ZTrap="ReadAsyncError"
	Lock +^CacheTemp.cspWebSockets("DATA",..WebSocketID)
	Set n=$Order(^CacheTemp.cspWebSockets("DATA",..WebSocketID,""))
	If n'="" {
		Set chunk=$Get(^CacheTemp.cspWebSockets("DATA",..WebSocketID,n))
		If $Data(^CacheTemp.cspWebSockets("DATA",..WebSocketID,n,"close")) {
			Set data="",len=0
			Set sc=$$$ERROR($$$CSPWebSocketClosed,"WebSocket Closed by the Client")
			Set ..AtEnd=1
			Goto ReadAsyncExit
		}
		If $Length(chunk)>len {
			Set data = $Extract(chunk, 1, len)
			Set ^CacheTemp.cspWebSockets("DATA",..WebSocketID,n)=$Extract(chunk, len + 1, *)
		}
		else {
			Set data = chunk
			Kill ^CacheTemp.cspWebSockets("DATA",..WebSocketID,n)
			If $Order(^CacheTemp.cspWebSockets("DATA",..WebSocketID,""))="" Set ..AtEnd=1
		}
		Lock -^CacheTemp.cspWebSockets("DATA",..WebSocketID)
		Set len=$Length(data)
		Set sc=$$$OK
		Goto ReadAsyncExit
	}
	Lock -^CacheTemp.cspWebSockets("DATA",..WebSocketID)
	if (to) {
		Set data="",len=0
		Set sc=$$$ERROR($$$CSPWebSocketTimeout,"WebSocket Read Operation timed-out")
		Set ..AtEnd=1
		Goto ReadAsyncExit
	}
ReadAsyncWait ; Wait for next command
	#; Turn on interrupts while waiting for requests to process
	$$$SetExternalInterrupts(1)
	#; Wait on a read so we quickly see Gateway disconnects
	Hang timeout
	Set to=1
	Goto ReadAsyncLoop
ReadAsyncError ; Error
	Set $ZTrap=""
	If $ZError["<EXTERNAL INTERRUPT>" Set to=1 Goto ReadAsyncLoop
	Do event^%SYS.cspServer2("WebSocket Asynchronous Read Error: "_$ZError)
	Set sc=$$$ERROR($$$CSPWebSocketClosed,"WebSocket Read Operation Error")
	Set data=""
ReadAsyncExit ; Error
	Kill ^CacheTemp.cspWebSockets("READ",..WebSocketID)
	Quit data
}

/// Write to the client.
Method Write(data As %String) As %Status
{
	Set $ZTrap="WriteError"
	If ..BinaryData = 1 {
		Set data1 = data
	}
	Else {
		Try { Set data1=$zconvert(data,"O","UTF8") } Catch { Set data1=data }
	}
	If ..WSClassProtocolVersion > 1 & ..WSDataFraming = 1 {
		Set head=$ZLChar($Length(data1))
		If ..BinaryData = 1 {
			Set head=head_"8"
		}
		Else {
			Set head=head_"7"
		}
	}
	Else {
		Set head=""
	}
	If (..SharedConnection = 1) {
		Set status=$$CSPGWClientRequest^%SYS.cspServer3(..GWClientAddress,"WSW "_..WebSocketID_" "_head_data1,-5,.response)
	}
	else {
		Write head_data1,*-3
	}
	Quit $$$OK
WriteError	
	#; No interrupts during cleanup or error processing
	Do event^%SYS.cspServer2("WebSocket Write Error: "_$ZError)
	$$$SetExternalInterrupts(0)
	Set $ZTrap="WriteHalt"
	Hang 5
	Close 0
WriteHalt 
	Halt
}

/// Internal handling of page processing
ClassMethod Page(skipheader As %Boolean = 1) As %Status [ Internal, ServerOnly = 1 ]
{
	Set websocketid = $Get(%request.CgiEnvs("HTTP_WEBSOCKET_ID"))
	Set gwclientaddress = $Get(%request.CgiEnvs("HTTP_GWCLIENT_ADDRESS"))
	Try {
		Set WS=..%New()
		Set WS.SessionId=%session.SessionId
		Set %Status=WS.Initialize(websocketid, gwclientaddress)
		Set %Status=WS.OnPreServer()
		Set %Status=WS.InitializeServer()
		If (WS.SharedConnection = 0) {
			#; Synchronous mode: WebSocket will remain permanently attached to this connection 
			Set %Status=WS.Server()
			Set %Status=WS.OnPostServer()
			Halt
		}
		else {
			#; Asynchronous mode: WebSocket will start in a separate process (which can be halted)
			Set WSClass=$P(%request.URL, "/", $Length(%request.URL, "/"))
			Set WSNameSpace=$P(%request.URL, "/", $Length(%request.URL, "/") - 1)
			Set WSClass=$Piece(WSClass, ".", 1, $Length(WSClass, ".") - 1)
			Job CSPGWAsyncWebSocket^%SYS.cspServer3(WSClass, websocketid)
		}
	}
	Catch {
		Do ERROR^%SYS.cspServer2($ZE_" (CSP: Error invoking WebSocket methods)")
		HALT
	}
}

/// Internal handling of error
ClassMethod Error(skipheader As %Boolean = 1) As %Status [ Internal, ServerOnly = 1 ]
{
	Set sc=$get(%request.Data("Error:ErrorCode",1))
	If sc=""||(sc=$$$OK) Set sc=$$$ERROR($$$GeneralError,"Unknown error")
	Set data="CacheSP: p=0;chd=1;ato=3600;"_$Char(13,10)
	Set data=data_"HTTP/1.1 404 Not Found"_$Char(13,10)
	Set data=data_"Content-type: text/html"_$Char(13,10)
	Set data=data_"Connection: close"_$Char(13,10)
	Set data=data_$Char(13,10)
	Write data
	Set EscapeObj = ##class(%CSP.HTMLEscape).%New()
	Do $system.OBJ.DisplayError(sc)
	Kill EscapeObj
	Write $Char(13,10)
	Do $$$ZuNoFlushOpOnWebServerTCPDevice
	Write "CacheSP: p=0;chd=1;ato=3600;"_$Char(13,10)
	Do $$$ZuFinishOpOnWebServerTCPDevice
    Quit $$$OK
}

/// Internal handling of login
ClassMethod Login(skipheader As %Boolean = 1) As %Status [ Internal, ServerOnly = 1 ]
{
	Quit ..Error(.skipheader)
}

}
