Include (%syCluster, %sySystem, %syJrninc)

/// Cluster-specific
Class SYS.Cluster Extends %RegisteredObject
{

/// Clear a switch cluster wide (NOT including local system)
ClassMethod ClearSwitch(switch As %Integer) As %Status [ Internal ]
{
}

/// Clear a switch on slave nodes only (NOT including local system)
ClassMethod ClearSwitchSlaves(switch As %Integer) As %Status [ Internal ]
{
}

/// Information on live member systems of current Cache cluster <p>
/// Format of the return value: <p>
///   port,ip,csn;... <p>
/// where <ul><li>
///   port - Default Port Number of the Cache cluster member </li><li>
///   ip - IP address of the Cache cluster member </li><li>
///   csn - Cluster System Number of the Cache cluster member </li></ul>
/// The first (port,IP,csn) value set always refers to the local system.<p>
/// On a non-clustered system, returns its Default Port Number only.
ClassMethod MembersInfo() As %CacheString [ Internal ]
{
}

/// Set a switch cluster wide (NOT including local system)
ClassMethod SetSwitch(switch As %Integer) As %Status [ Internal ]
{
}

ClassMethod SetSwitchSlaves(switch As %Integer) As %Status [ Internal ]
{
}

/// Swap the Hostname and IP fields in a CluNodeInfoD-delimited node info string
/// <em>if</em> Hostname does NOT contain commas, the delimiter we will use.
/// On exit, also convert the delimiter from CluNodeInfoD to comma.
/// NOTE: This method is deprecated. Use %SYS.ClusterInfo instead.
ClassMethod NodeInfoConvert(NodeInfo As %String) As %String [ CodeMode = expression, Internal ]
{
}

/// Return by reference the info piece about the cluster node of the given CSN,
/// converted to a comma-delimited string (for backward compatibility) <br>
/// Return code: <ul><li>
/// 0 if there no cluster node of CSN (that is alive at the moment) - NodeInfo is undefined; </li><li>
/// 1 if the cluster node of CSN is the first piece (meaning it is the local node); </li><li> 
/// n>1 if the cluster node of CSN is the n-th piece (n has no particular meaning).</li></ul>
/// NOTE: This method is deprecated. Use %SYS.ClusterInfo instead.
ClassMethod FindNode(CSN As %Integer, ByRef NodeInfo As %String) As %Integer [ CodeMode = expression, Internal ]
{
}

/// Return by reference an array of info pieces about all cluster nodes (that are currently alive) <br>
/// The array NodeInfo is indexed by csn, with the value of each element being 
/// a comma-delimited string containing the info about the node of csn.<br>
/// The value of the top node NodeInfo is the csn of the local node <br>
/// Return code: the number of nodes in the cluster (that are alive at the moment)
/// NOTE: This method is deprecated. Use %SYS.ClusterInfo instead.
ClassMethod GetNodes(ByRef NodeInfo As %String, NoConvert As %Boolean = 0, SkipSelf As %Boolean = 0) As %Integer [ CodeMode = expression, Internal ]
{
}

/// Returns info about member nodes of the cluster
/// If SkipSelf = 1, skip the node where the query is run
/// NOTE: This query is deprecated. Use %SYS.ClusterInfo instead.
Query NodeList(SkipSelf As %Boolean = 0) As %Query(ROWSPEC = "CSN:%Integer,IP:%String,Port:%Integer,MGR Dir:%String,Journal Offset:%Integer,Journal File:%String,Journal File Count:%Integer,Transaction Offset:%Integer,Transaction File:%String,Transaction File Count:%Integer,Host Name:%String,Prev Journal Offset:%Integer,Prev Journal File Count:%Integer,Prev Journal File:%String,Journal WDPass:%Integer")
{
}

ClassMethod NodeListExecute(ByRef qHandle As %Binary, SkipSelf As %Boolean = 0) As %Status [ CodeMode = expression ]
{
}

ClassMethod NodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ CodeMode = expression ]
{
}

ClassMethod NodeListClose(ByRef qHandle As %Binary) As %Status
{
}

/// Returns info about cluster journal markers
Query JournalMarkers(LogFile As %SysPath = "") As %Query(ROWSPEC = "Time:%TimeStamp,File Offset:%Integer,File Name:%SysPath,Type:%Integer,Text:%String")
{
}

ClassMethod JournalMarkersExecute(ByRef qHandle As %Binary, LogFile As %SysPath = "") As %Status
{
}

ClassMethod JournalMarkersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
}

ClassMethod JournalMarkersClose(ByRef qHandle As %Binary) As %Status
{
}

}
