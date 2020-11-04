Include (Wserver, %sySystem)

/// Extended Cache Protocol 
/// Notes:<br>
/// <ul>
/// <li>A Server Connection is a connection from this system as a client to a remote server.
/// <li>A Client Connection is a connection from a remote client to this system as a server.
/// </ul>
Class SYS.ECP [ Abstract ]
{

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// Asks the user to enter a remote directory nameand returns the SFN of
/// that database or 0 if they didn't chose one. (sfn #0 cannot be a remote directory).
ClassMethod AskUserForRemoteDir() As %Integer [ Internal ]
{
}

/// Changes an ECP connection state to not connected.
/// Connection name is as specified in the network panel.
/// Returns zero if the connection name is invalid
ClassMethod ChangeToNotConnected(ConnectionName As %String) As %Boolean
{
}

/// Display the list of database remote databases this client has "mounted"
ClassMethod DisplayDatabases()
{
}

/// Returns the state of an ECP Client Connection.<br>
/// Connection name is as specified in the network panel.<br>
/// Return value:<br>
/// <li>-1 - Invalid connection name
/// <li> 0 - Free
/// <li> 1 - Normal
/// <li> 2 - Trouble
/// <li> 3 - Recovering
/// <li> 4 - Restart
ClassMethod GetClientConnState(ConnectionName As %String) As %Integer
{
}

/// Returns the state of an ECP Server Connection.<br>
/// Connection name is as specified in the network panel.<br>
/// Return value:<br>
/// <li>-2 - Invalid connection name
/// <li>-1 - Invalid
/// <li> 0 - Initializing
/// <li> 1 - Not Connected
/// <li> 2 - Connection in Progress
/// <li> 3 - Connection Failed
/// <li> 4 - Disabled
/// <li> 5 - Normal
/// <li> 6 - Trouble
/// <li> 7 - Recovery
ClassMethod GetServerConnState(ConnectionName As %String) As %Integer
{
}

/// <b>dbname</b> is a mounted remote database in the form 
/// ^&lt;sys&gt;^&lt;directory&gt;. This method returns the sfn of the 
/// database or "0,&lt;error text&gt;" if the database does not appear to be
/// a valid remote database for the specified system.
/// 
ClassMethod GetSFNFromName(dbname As %String) [ Internal ]
{
}

/// Performs <var>Action</var> on an ECP Server Connection.<br>
/// Connection name is as specified in the network panel.<br>
/// <var>Action</var>:<br>
/// <li>1 - Change to Not Connected
/// <li>2 - Change to Disabled
/// <li>3 - Change to Normal
ClassMethod ServerAction(ConnectionName As %String, Action As %Integer) As %Status
{
}

/// Return the DB name for CACHETEMP which is where we store the blocks
/// that form the client cache of a ECP server.
ClassMethod StorageDBName() As %String [ Internal ]
{
}

Query ClientList() As %Query(ROWSPEC = "Client Name:%String,Status:%String,IP Address:%String,IP Port:%Integer")
{
}

ClassMethod ClientListExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod ClientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ClientListExecute ]
{
}

ClassMethod ClientListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ClientListExecute ]
{
}

Query ServerList() As %Query(ROWSPEC = "Server Name:%String,Host Name:%String,Status:%String,IP Address:%String,IP Port:%Integer")
{
}

ClassMethod ServerListExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod ServerListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ServerListExecute ]
{
}

ClassMethod ServerListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ServerListExecute ]
{
}

}
