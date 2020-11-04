Class TCPProvider.TCPListener Extends %RegisteredObject [ System = 3 ]
{

Parameter RECEIVED [ Final ] = "Received: ";

Parameter SENT [ Final ] = "Sent: ";

Property LogFile As %String;

Method OnConnect()
{
}

Method OnMessage(messageLength As %Integer)
{
}

Method OnLongMessage(messageLength As %Integer)
{
}

Method OnDisconnect()
{
}

Method SetLogFile(logFileName As %String) [ Final ]
{
}

Method Log(message As %String, type As %String) [ Final ]
{
}

}
