Include (%syConfig, %syMirror, %syINET)

/// This class allows you to modify and view the [Mirrors] section of the CPF file through
/// programatic APIs. Mirrors are managed via the Enterprise Manager or the ^MIRROR
/// utility. The methods in this class which retrieve information can be called directly
/// but the configuration should not be changed via direct calls to these methods.
/// <br>
/// <br>
/// EXAMPLE:<br>
/// <br>
/// <pre>
/// ; Use class methods to retrieve properties
/// %SYS>s Status=##Class(Config.Mirrors).Get(Name,.Properties)
/// %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
/// %SYS>zw Properties
/// Properties("Enabled")=0
/// </pre>
Class Config.Mirrors Extends (%Persistent, Config.CommonMultipleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

Parameter CAPITALNAME = 1;

Parameter EMSSERVICE [ Internal ] = "Mirror";

/// Mirror names are uppercase (alphanumerics)
/// Name of the mirror, restricted to 15 uppercase alphanumeric characters. 
/// Must be unique across the mirrors managed by the EMS
Property Name As %String(MAXLEN = 15) [ Required ];

/// Internal GUID which is unique to this mirror
Property GUID As %String [ Required ];

/// ACKRequirement is now fixed at SYNCRULEAck. This is hard coded
/// in the system code. The property exists in the config in case
/// the config is retrieved by an older system (pre 2014.2) (JO2739)
Property ACKRequirement As %Integer [ InitialExpression = 2, Internal ];

/// AgentContactRequiredForTakeover is no longer used (JO2370), the value
/// has no effect on the operation of this system. The system behaves as if
/// it is set to 1.
Property AgentContactRequiredForTakeover As %Boolean [ InitialExpression = 1, Internal ];

/// An address for the arbiter node used by this mirror.<br>
/// The arbiter node is used by the failover members as an observer to provide
/// information to an active backup that allows it to take over when the agent
/// on the primary cannot be contacted (eg. the primary loses power).<br><br>
Property ArbiterNode As %String;

/// Field used internally when a site wants to disable mirror failover, 
/// generally for maintanance purposes. Manipulated via the nofailover options
/// when shutting down Cache'. This contains the mirror system name of the node
/// which is allowed to become the primary. It is cleared automatically when that
/// node starts up and becomes the primary (eg. starting it NOSTU will not clear
/// this field). This can also be set and cleared manually via ^MIRROR.
Property DefinedPrimary As %String;

/// Contains the time in milliseconds which the primary will wait for the backup
/// to acknolwdge receipt of a chunk of journal data before the primary
/// marks the backup as inactive.
Property QOSTimeout As %Integer [ InitialExpression = 8000 ];

/// Yes/No field which controls whether the client and server sides of every
/// mirror connection authenticate each other against the SSL DN information
/// stored in the [MapMirrors] section of the configuration. When this field
/// is set to Yes each mirror member must have a Mirror SSL/TLS Configuration. 
/// In order to change this from No to Yes for an existing mirror, each mirror
/// member must have an SSL configuration defined.
/// <br><br>
/// When <property>UseSSL</property> is set to Yes, this field is also set to
/// Yes and cannot be changed to No.
Property RequireAuthentication As %Boolean [ InitialExpression = 0, Internal ];

/// With the addition of the arbiter and the removal of agentcontactrequired=no
/// mode, the trouble time out is no longer configurable (JO2740). When zero, 
/// it is set internally to twice the QOS Timeout with a minimum of 5 seconds. 
Property TroubleTimeout As %Integer(MAXVAL = 2147484, MINVAL = 0) [ InitialExpression = 0, Internal ];

/// Yes/No field for whether the mirror uses to encrypt the communication 
/// between members for every mirror connection. 
/// When set to Yes the Mirror SSL configuration is used for client/server connections by this
/// node. When set to No, encryption setting are controled on a per-connection baasis via
/// <property>Config.MapMirrors.EncryptCommunication</property> and by
/// <property>Config.MapMirrors.RequireEncryption MapMirrors</property>.
/// <br><br>
/// Setting this field to Yes forces <property>RequireAuthentication</property> to be set to 
/// Yes and <property>RequireAuthentication</property> cannot be set to No while this field is
/// enabled.
/// <br><br>
/// This must be enabled when journal files are encrypted on the 
/// failover mirror members or when there are any encrypted mirrored databases.
Property UseSSL As %Boolean [ InitialExpression = 0 ];

/// Optional Virtual IP address which the mirror maintains pointing to the
/// current primary. When this is specified the failover members must be
/// configured to host the Virtual IP on one of their interfaces. This is used
/// by TCP/IP Client applications to connect to the primary mirror member.
Property VirtualAddress As %String(MAXLEN = 256, MINLEN = 0);

/// Determines whether journal data is compressed before being transmitted between failover members.
/// 0 - System Selected: The system will use compression only in configurations where it is expected to improve the response time for synchronization between the primary and backup.
/// 1 - Uncompressed: No compression will be used.
/// 2 - Compressed: Compression will be used.
Property CompressionForFailoverMembers As %Integer(MAXVAL = 2, MINVAL = 0) [ InitialExpression = 0 ];

/// Determines whether journal data is compressed before being transmitted to async members (disaster recovery and reporting).
/// 0 - System Selected: The system will use a compression strategy expected to balance network utilization with performance.
/// 1 - Uncompressed: No compression will be used.
/// 2 - Compressed: Compression will be used.
Property CompressionForAsyncMembers As %Integer(MAXVAL = 2, MINVAL = 0) [ InitialExpression = 0 ];

ClassMethod Version() As %Integer
{
}

/// Called by the Create method during import from a CPF file.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal ]
{
}

/// Delete a 'Mirrors' section from a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Name</b> - Name of the mirror to delete.<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file.<br>
/// <b>Flags</b> - Bit string of options to perform. See the <METHOD>Create</METHOD> method for values.<br>
/// <br>
/// Return values:<br>
/// <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Delete(Name As %String, ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}, Clean As %Integer = 1) As %Status
{
}

ClassMethod MoveToActive(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

Method NameSet(Val) As %Status [ Internal ]
{
}

/// Returns a mirror name which this instance has loaded or is configured to
/// load. For Failover
/// members there is only ever one entry here. For async and reporting members
/// they may join multiple mirrors and for those types of members, this method
/// serves as a $ORDER type method where it takes a mirror name (or null) and returns
/// the next (or 1st) mirror name in the configuration. It returns null when there 
/// are no other mirror names to return. <br><br>Callers who want a list of all of the
/// mirror members should probably call the %Config.Mirrors:List query directly or
/// use the <classmethod>##class(SYS.MirrorConfiguration).GetListOfMirrorNames()</classmethod> 
/// method rather
/// than calling this method over and over. This is mostly used on failover nodes to
/// get the name of the current mirror.
/// <br><br>
/// This method looks first at the loaded mirrors and if there aren't any, reads
/// the configuration to get the set of configured mirrors.
ClassMethod GetMirrorName(PrevName As %String = "") As %String
{
}

/// Load the parameters into memory and activate.<br>
/// Parameters:<br>
/// <b>Obj</b> = Handle to the object which caused the load. If "", 
/// then load everything, only called from Activate().<br>
/// If a delete operation, then Obj contains the data from the item 
/// which was deleted but the oject itself has already been deleted.<br>
/// <b>Flags</b> = Type of modification.<br>
/// 0 - Modify<br>
/// 1 - Create/Insert<br>
/// 2 - Delete<br>
/// Load the Mirror info.<br>
/// Load the [Mirror] Section of the configuration file into the
/// ^SYS("MIRRORSET") global. This is the working definition which
/// MIRRORMGR/MIRRORCOMM
/// <br><br>
/// <pre>
/// Returns: 1 - everything is ok
///          0 - something seems wrong and startup should abort
/// 
/// <br>
/// <br>
/// 
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

ClassMethod UpdateMirrorSets() As %Status [ Internal ]
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

/// List Mirrors in a CPF file.<br>
/// <br>
/// Parameters:<br>
/// <b>Names</b> - Comma separated list of Mirror names<br>
/// <var>"*"</var> - All records match<br>
/// <var>"String,String1"</var> - Any records matching one of these elements<br>
/// <var>"String*"</var> - Any record starting with "String"<br>
/// <var>"String,String1*,String2"</var> - Any record mathing one of these elements, or starting with "String1"<br>
/// <b>CPFFile</b> - Name of the CPF file to use. A null string means use the active CPF file.<br>
/// <b>Flags</b> - Currently ignored.<br>
/// <b>Format</b> <br>
/// <var>0</var> - Standard report list format<br>
/// <var>1</var> - ^CONFIG global format<br>
/// <var>2</var> - CPF file format format<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Name:%String,GUID:%String,ACKRequirement:%Integer,AgentContactRequiredForTakeover:%Boolean,DefinedPrimary:%String,QOSTimeout:%Integer,TroubleTimeout:%Integer,UseSSL:%Boolean,VirtualAddress:%String,RequireAuthentication:%Boolean,ArbiterNode:%String,CompressionForFailoverMembers:%Integer,CompressionForAsyncMembers:%Integer") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

Storage Default
{
<Data name="MirrorsDefaultData">
<Value name="1">
<Value>Comments</Value>
</Value>
<Value name="2">
<Value>Address</Value>
</Value>
<Value name="3">
<Value>DaysBeforePurge</Value>
</Value>
<Value name="4">
<Value>Enabled</Value>
</Value>
<Value name="5">
<Value>FilterRoutine</Value>
</Value>
<Value name="6">
<Value>JournalDirectory</Value>
</Value>
<Value name="7">
<Value>MaxErrors</Value>
</Value>
<Value name="8">
<Value>SSLConfig</Value>
</Value>
<Value name="9">
<Value>GUID</Value>
</Value>
<Value name="10">
<Value>ACKRequirement</Value>
</Value>
<Value name="11">
<Value>AgentContactRequiredForTakeover</Value>
</Value>
<Value name="12">
<Value>DefinedPrimary</Value>
</Value>
<Value name="13">
<Value>QOSTimeout</Value>
</Value>
<Value name="14">
<Value>TroubleTimeout</Value>
</Value>
<Value name="15">
<Value>UseSSL</Value>
</Value>
<Value name="16">
<Value>VirtualAddress</Value>
</Value>
<Value name="17">
<Value>RequireAuthentication</Value>
</Value>
<Value name="18">
<Value>ArbiterNode</Value>
</Value>
<Value name="19">
<Value>CompressionForAsyncMembers</Value>
</Value>
<Value name="20">
<Value>CompressionForFailoverMembers</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>MirrorsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

/// Return number of mirror set this member is tarcking.
ClassMethod NumberOfMirrorSet() As %Integer [ Internal ]
{
}

}
