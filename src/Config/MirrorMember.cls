Include (%syConfig, %syJrninc, %syMirror)

/// This class allows you to modify and view the [MirrorMember] section of the CPF file through
/// programatic APIs. While properties are usually modified through the System Management
/// portal, there may be some occasion where modifying them through the API's is best
/// for your system. In all the Config methods, if you do not specify the CPFFile parameter,
/// the currently active CPF file is used. If you wish to modify a CPF file which is not
/// the currently active one, then specify the CPFFile you wish to modify in the method call.<br>
/// The Flags parameter does not normally need to be specified; the defaults are usually
/// sufficient for most cases.<br>
/// You can use either the provided API's (Get/Modify) to modify the properties by passing 
/// in the correct parameters, or use Object sytax to open and directly manipulate the config
/// objects.
/// <br>
/// <br>
/// EXAMPLE:<br>
/// <br>
/// <pre>
/// ; Use class methods to modify properties
/// %SYS>s Status=##Class(Config.MirrorMember).Get(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties("SystemName")
/// Properties("SystemName")="Mirror5"
/// %STS>s Properties("SystemName")="Mirror6"
/// %SYS>s Status=##Class(Config.MirrorMember).Modify(.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// ; Now use Objects to modify properties
/// %SYS>s Obj=##Class(Config.MirrorMember).Open()
/// %SYS>w Obj.SystemName
/// Mirror6
/// %SYS>s Obj.SystemName="Mirror7"
/// %SYS>s Status=Obj.%Save()
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// </pre>
Class Config.MirrorMember Extends (%Persistent, Config.CommonSingleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

/// List of properties which may or may not be in the CPF file.<br>
/// They have a corresponding %Boolean property to determine if they
/// are in the file or not. For example, the property "DebugFlags" 
/// has a %Boolean "DebugFlagsPresent" property associated with it.
/// <br>
Parameter PROPERTIESMAYBEINCPF = "DebugFlags,DDNSKey";

Parameter EMSSERVICE [ Internal ] = "Mirror";

Property AgentAddress As %NetworkAddress;

Property AsyncMemberGUID As %String;

/// AsyncMemberType indicates the async member is a disaster recovery (DR), read-only reporting or read-write reporting async member.<br>
/// 0 - Disaster Recovery (DR). This is a disaster recovery async member, all its mirrored databases are read-only mirrored databases.<br>
/// 1 - Read-Only Reporting. This is a reporting async member, all its mirrored databases could be read-only or read-write databases, the default is read-only when the database is
/// created.<br>
/// 2 - Read-Write Reporting. This is a reporting async member, all its mirrored databases could be read-only or read-write databases, the default is read-write when the database is
/// created.<br>
Property AsyncMemberType As %Integer(MAXVAL = 2, MINVAL = 0) [ InitialExpression = 0 ];

/// AsyncUseSystemPurgeInterval when set indicates that the async member should
/// purge mirror journal files according to the same criteria it uses for purging
/// local journal files (eg. after a certain number of days or a certain number
/// of backups). When this parameter is missing, or clear, the default state, mirror
/// journal files are purged as soon as they are no longer needed because they
/// have been replayed to the local databases and/or sent on to the various clients
/// that connect (if this is a relay member).
Property AsyncUseSystemPurgeInterval As %Boolean [ InitialExpression = 0 ];

Property DebugFlags As %String [ Internal ];

Property DebugFlagsPresent As %Boolean [ InitialExpression = 0, Internal ];

Property DDNSKey As %SysPath [ Internal ];

Property DDNSKeyPresent As %Boolean [ InitialExpression = 0, Internal ];

/// Flag indicating whether this system processes its mirror configuration
/// at startup. When set to NO, the mirror configuration is ignored and the
/// system is not considered a mirror member. This can be used if there is a 
/// problem in the configuration which prevents the system from starting or
/// as part of removing a system from the mirror as if a system is the primary
/// it needs to be restarted but we also need to block the system from joining
/// the mirror when it restarts and becoming the primary again.
Property JoinMirror As %Boolean [ InitialExpression = 0 ];

/// This is the name by which the system is known in the mirror (the mirror 
/// member name). The name is converted to uppercase before storing. 
/// The following characters are not permitted in mirror system names:
/// <br>
/// &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: # , ; = ^ ~ " &ltspace&gt &lttab&gt 
/// <br>
/// The following character sequences are not allowed in mirror system names:
/// <br>
/// &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;/*  
/// <br>
/// 
/// Mirror system names must be unique across all
/// mirror members as some mirror members (eg. relay and async members) may
/// participate in multiple mirrors and they will have the same system name
/// in all of the mirrors.
Property SystemName As %String(MAXLEN = 32, MINLEN = 0);

/// ValidatedMember is set when a node joins an existing mirror and
/// has verified that it is listed in the [MirrorSetMembers] list of 
/// all the other (Validated) mirror members. Until ValidatedMember is 
/// set a node cannot become the primary. This is important because the 
/// existing mirror members don't know to look for this node (yet) when 
/// deciding whether they should be the primary or not because generally a
/// node is configured to be a mirror member before it is added to the
/// existing nodes.
Property ValidatedMember As %Boolean [ InitialExpression = 0, Internal ];

/// When the mirror is configured to keep a virtual ip address assigned
/// to the primary, this is the local interface which hosts the IP address.<br><br>
/// Consult the documentation for the format specific to the operating system.<br><br>
Property VirtualAddressInterface As %String(MAXLEN = 255);

/// Returns TRUE/FALSE for whether this node is configured as an async
/// or relay member in the configuration.
ClassMethod isAsyncMember(ByRef CPFFile As %String = "") As %Boolean
{
}

Method SystemNameSet(Val) As %Status [ Internal ]
{
}

/// Load the MirrorMember info.<br>
///    Currently this can only be called once, during STU. STU kills off
///    the ^SYS("MIRRORSET") tree and if there's data there when we're called,
///    we exit. 
/// <br>
/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from STU.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
/// 2 - Delete<br>
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

/// Check the required security settings<br>
/// Returns $$$ERROR(reason) if we fail to look up the security
/// setting. Otherwise returns $$$OK and sets the passed 'enabled' 
/// variable to True/False.
ClassMethod CheckSecurity(ByRef enabled As %Boolean) As %Status
{
}

/// This is called from %Save().<br>
/// Any error returned from this will cause the object to not be saved.<br>
Method %OnValidateObject() As %Status [ Internal ]
{
}

/// Called from %OnBeforeSave. Provides a way for a specific class to override the 
/// EMS.Restricted() check when the Instance is managed. Used when a few properties in
/// a class (like Config.SQL.JDBCGatewayPort) are not managed by EMS.
Method EMSAllowEdit(insert As %Boolean) As %Boolean [ Internal ]
{
}

/// Returns AsyncMemberGUID of the async or relay member
Method GetAsyncMemberGUID() As %String
{
}

/// Check if this mirror member allow user to clear the FailoverDB flag in mirrored databases.<br>
/// Only the non-DR async member allow user to clear the FailverDB flag in mirrored databases.
ClassMethod AllowClearFailoverDBFlag(ByRef CPFFile As %String = "") As %Boolean
{
}

/// Check if this mirror member is a Disaster Recovery (DR) async member.<br>
ClassMethod IsDRMember(ByRef CPFFile As %String = "") As %Boolean
{
}

/// Check if this mirror member is a read-only reporting async member.<br>
ClassMethod IsReadOnlyReportingMember(ByRef CPFFile As %String = "") As %Boolean
{
}

/// Check if this mirror member is a read-write reporting async member.<br>
ClassMethod IsReadWriteReportingMember(ByRef CPFFile As %String = "") As %Boolean
{
}

/// Subroutine of this class and  ^MIRROR when the "type" of a mirror
/// being tracked by an async member is changed from read-only to
/// read-write. This scans through all the mounted databases looking
/// for mirrored databases and clears the FailoverDB flag so
/// that they can be mounted read/write locally. This should be done with
/// care as once this flag is cleared these databases can no longer be
/// activated for use in the mirror. This means that they cannot be moved,
/// even within the async member, as a moved mirrored db needs to be activated
/// before it can be used. A new copy would have to be made off of a failover
/// node in order to be activated. The mirrored databases have not been activated
/// will be skipped, they could be cleared when they are activated.
ClassMethod ClearFailoverDBForNonDRAsyncMember() As %Status [ Internal ]
{
}

/// Return whether the async member is allowed to add a new mirror set to be tracked.
ClassMethod AllowNewMirrorSet(ByRef CPFFile As %String = "") As %Boolean
{
}

Storage Default
{
<Data name="MirrorMemberDefaultData">
<Value name="1">
<Value>AgentAddress</Value>
</Value>
<Value name="2">
<Value>AsyncMemberGUID</Value>
</Value>
<Value name="3">
<Value>AsyncMemberType</Value>
</Value>
<Value name="4">
<Value>AsyncUseSystemPurgeInterval</Value>
</Value>
<Value name="5">
<Value>Comments</Value>
</Value>
<Value name="6">
<Value>DDNSKey</Value>
</Value>
<Value name="7">
<Value>DDNSKeyPresent</Value>
</Value>
<Value name="8">
<Value>DebugFlags</Value>
</Value>
<Value name="9">
<Value>DebugFlagsPresent</Value>
</Value>
<Value name="10">
<Value>JoinMirror</Value>
</Value>
<Value name="11">
<Value>SystemName</Value>
</Value>
<Value name="12">
<Value>ValidatedMember</Value>
</Value>
<Value name="13">
<Value>VirtualAddressInterface</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>MirrorMemberDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
