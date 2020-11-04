Include (%sySite, %sySystem, %syLock, %syINET)

/// Interface to remove locks and query and adjust lock table parameters.<br>
/// Use <class>%SYS.LockQuery</class> to query the contents of the lock table.<br>
/// <br>
Class SYS.Lock Extends %SYSTEM.Help [ Abstract, Final, SqlTableName = "", StorageStrategy = "", System = 4 ]
{

/// Convert a remote client system name to internal system number.
/// This is used by LOCKTAB as well as by this class.
ClassMethod ClientSysNameToSysNum(SysName As %String = "") As %Integer [ Internal ]
{
}

/// Convert a remote client system number to client system name.
/// This is used by LOCKTAB as well as by this class.
ClassMethod ClientSysNumToSysName(SysNum As %Integer = 0) As %String [ Internal ]
{
}

/// Remove all locks from lock table.<br>
/// This returns number of locks been removed from lock table.<br>
/// The argument 'id' specified the category of lock entries to be deleted. See the 'Filter Specification' at the top of <class>%SYS.LockQuery</class>.<br>
/// Example:
/// <example>
/// // Delete all locks in lock table.
/// Set rc=##Class(SYS.Lock).DeleteAllLocks()
///  
/// // Delete locks owned by process 2004.
/// Set rc=##Class(SYS.Lock).DeleteAllLocks(2004)
///  
/// // Delete locks owned by remote client system named 'SystemA'.
/// Set rc=##Class(SYS.Lock).DeleteAllLocks("CSystemA")
///  
/// // Delete locks owned by remote client systems.
/// Set rc=##Class(SYS.Lock).DeleteAllLocks("N")
///  
/// // Delete locks owned by remote DDP clients.
/// Set rc=##Class(SYS.Lock).DeleteAllLocks("NDDP")
/// </example>
ClassMethod DeleteAllLocks(id As %String = "") As %Status
{
}

/// Delete One Lock item in the lock table.<br>
/// This returns 1 if the lock delete operation succeeds, otherwise returns 0.
/// <ul><li>'LockRef' - could be a lock reference string or a DelKey depends on the 'LockRefType' parameter.</li>
/// <li>'id' - the owner of the lock entry to be deleted. See the 'Filter Specification' at the top of <class>%SYS.LockQuery</class> for the 'id'.</li>
/// <li>'LockRefType' - 0: the 'LockRef' is lock reference string, this is the default value. 1: the 'LockRef' is the DelKey for deleting the lock entry.</li></ul>
/// The 'DelKey' is usually used when the lock's 'DelKey' value is retrieved from a query.<br>
/// <br>
/// Example:
/// <example>
/// // Delete ^|"^^c:\cachesys\mgr\user"|a(1) lock.
/// Set rc=##Class(SYS.Lock).DeleteOneLock("^|""^^c:\cachesys\mgr\user""|a(1)")
///  
/// // Delete ^|"^^c:\cachesys\mgr\user"|a(1) lock owned by process 2004.
/// Set rc=##Class(SYS.Lock).DeleteOneLock("^|""^^c:\cachesys\mgr\user""|a(1)",2004)
///  
/// // Look through the lock table and remove all locks
/// // to the directory with System File Number equal 2.
/// Set Rset=##class(%ResultSet).%New("%SYS.LockQuery:List")
/// Do Rset.Execute("")
/// While Rset.Next() {
///     If Rset.Data("Sfn")=2 {
///         s rc=##Class(SYS.Lock).DeleteOneLock(Rset.Data("DelKey"),"",1)
///     }
/// }
/// 
/// </example>
ClassMethod DeleteOneLock(LockRef As %String, id As %String = "", LockRefType As %Integer = 0) As %Integer
{
}

/// Get lock space information.<br>
/// This method returns three numbers and they are separated by ',' in the following format: <br>
/// <br>
/// "AvailableSpace,UsableSpace,UsedSpace"<br>
/// <br>
/// The amounts are number of bytes.<br>
/// <var>AvailableSpace</var>: Available memory for lock, it is total configured lock memory minus <var>UsedSpace</var>.<br>
/// <var>UsableSpace</var>: Estimated size of memory could be used; some of the <var>AvailableSpace</var> is reserved for each process. They include two LRB, one LHB and one lock reference string.
/// They could not be used by other processes until the job released it to the free pool. So the <var>UsableSpace</var> is less than the <var>AvailableSpace</var>.<br>
/// <var>UsedSpace</var>: Currently used memory space by lock.
/// 
ClassMethod GetLockSpaceInfo() As %String
{
}

/// Get lock system number and name translation table.
ClassMethod GetLockSysNameTable(ByRef SYSTEMS As %String, ByRef BYTES2 As %String, ByRef SYSN2 As %String) As %Status [ Internal, Private ]
{
}

/// Get the maximum number of bytes been configured for lock system to use.<br>
/// The value returned is in number of bytes.
ClassMethod GetMaxLockTableSize() As %Integer
{
}

/// Get node information.<br>
/// This method returns the node information of current system.<br>
/// This returns the following information who are separated by $C(0) in sequence.<br>
/// <br>
/// 1) Node Name - node name of the current system.<br>
/// 2) Joined Cluster - 1: this system is a cluster member, 0: otherwise.<br>
/// 3) Cluster Master - 1: this system is a cluster master node, 0: otherwise.<br>
/// 4) Cluster Master Node Name - The Node Name of the cluster master node.<br>
/// <br>
/// 
ClassMethod GetNodeInfo() As %String
{
}

/// Set new maximum number of bytes for lock system to use.<br>
/// The 'NewSize' is in bytes, it will be round up to 64 KB.
ClassMethod SetMaxLockTableSize(NewSize As %Integer) As %Integer
{
}

/// Translate the input ID string and return three values.
/// 1) pid : The process ID, 0 - all processes.
/// 2) clin: The remote client system number, -1 - all remote system.
/// 3) ntype: The network protocol from remote client, 100 - all network protocol.
/// 4) svrn: The remote server system number, -1 - all remote system.
/// 
ClassMethod TranslateID(id As %String) As %String [ Internal, Private ]
{
}

Storage Default
{
<Data name="LockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Mode</Value>
</Value>
<Value name="3">
<Value>Owner</Value>
</Value>
<Value name="4">
<Value>Counts</Value>
</Value>
<Value name="5">
<Value>LockCount</Value>
</Value>
<Value name="6">
<Value>LockMode</Value>
</Value>
<Value name="7">
<Value>LockOwner</Value>
</Value>
<Value name="8">
<Value>LockFlags</Value>
</Value>
<Value name="9">
<Value>LockReference</Value>
</Value>
<Value name="10">
<Value>LockInDelockPending</Value>
</Value>
<Value name="11">
<Value>LockInLockPending</Value>
</Value>
<Value name="12">
<Value>LockIsLost</Value>
</Value>
<Value name="13">
<Value>LockWaiters</Value>
</Value>
<Value name="14">
<Value>Flags</Value>
</Value>
<Value name="15">
<Value>ReferenceString</Value>
</Value>
<Value name="16">
<Value>Waiters</Value>
</Value>
<Value name="17">
<Value>OwnerSys</Value>
</Value>
<Value name="18">
<Value>SysFileNumber</Value>
</Value>
</Data>
<DataLocation>^SYS.LockD</DataLocation>
<DefaultData>LockDefaultData</DefaultData>
<IdLocation>^SYS.LockD</IdLocation>
<IndexLocation>^SYS.LockI</IndexLocation>
<StreamLocation>^SYS.LockS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
