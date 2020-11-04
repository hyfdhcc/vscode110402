/// Static configuration elements for the destination system.  An instance 
/// of this class is referenced by each <CLASS>Destination</CLASS> object.
/// The Configuration object cannot be changed while the system is running.
/// The configuration elements in this are primary concerned with defining
/// the source system to connect to.  The <CLASS>RunParameters</CLASS>
/// defines the performance characteristics and what should be checked, and
/// <CLASS>Workflow</CLASS> defines the strategy for performing the check.
/// 
Class SYS.DataCheck.Configuration Extends %Persistent
{

/// Name of the DataCheck Destination system that uses this object.
/// Set upon creating the destination object and should not be changed.
/// 
Property SystemName As SystemName [ Required ];

Index IdIndex On SystemName [ IdKey ];

/// Hostname or IP address of source system.
/// Not used when DataCheck is configured to check a mirror
Property Host As %String(MAXLEN = 250);

/// Port of source system.
/// Not used when DataCheck is configured to check a mirror
Property Port As %Integer [ InitialExpression = 1972 ];

/// Mapping from source database paths to destination database paths.
/// Keyed by source database path; value is destination database path.
/// Not used when DataCheck is configured to check a mirror.
Property DBXMap As array Of LocalDatabase;

/// Optional name of SSL configuration to use for secure connection.
/// Not used when DataCheck is configured to check a mirror
Property SSLConfig As %String;

/// If true, detailed messages will by logged
Property Debug As %Integer [ InitialExpression = 0, Internal ];

/// Mirror member to connect to.  This property is not intended to be changed once created.
Property SourceMirrorMember As %String;

/// For DataCheck configured to check a mirror, pause DataCheck if either 
/// the source or the destination system is the backup failover member
/// and the backup is not marked as active.
Property PauseCheckingBackupWhenNotActive As %Boolean [ InitialExpression = 1 ];

/// For DataCheck configured to check a mirror, sets requirements about the state
/// of the <property>SourceMirrorMember</property>
/// <li>-1 - Wait until SourceMirrorMember is no longer primary</li>
/// <li> 0 - No Requirement </li>
/// <li> 1 - Wait until SourceMirrorMember is primary</li>
Property PrimarySourceRequirement As %Integer [ InitialExpression = 0 ];

/// Resets this configuration based on the shadow configuration specified
/// by 'shadowname'.
Method ImportFromShadowDestination(shadowname As %String) As %Status
{
}

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
}

Storage Default
{
<Data name="ConfigurationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Host</Value>
</Value>
<Value name="3">
<Value>Port</Value>
</Value>
<Value name="4">
<Value>SSLConfig</Value>
</Value>
<Value name="5">
<Value>Debug</Value>
</Value>
<Value name="6">
<Value>NamedMirrorMember</Value>
</Value>
<Value name="7">
<Value>MirrorSourceOption</Value>
</Value>
<Value name="8">
<Value>SourceMirrorMember</Value>
</Value>
<Value name="9">
<Value>PauseCheckingBackupWhenNotActive</Value>
</Value>
<Value name="10">
<Value>PrimarySourceRequirement</Value>
</Value>
</Data>
<Data name="DBXMap">
<Attribute>DBXMap</Attribute>
<Structure>subnode</Structure>
<Subscript>"DBXMap"</Subscript>
</Data>
<DataLocation>^SYS.DataCheck.ConfigurationD</DataLocation>
<DefaultData>ConfigurationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.DataCheck.ConfigurationD</IdLocation>
<IndexLocation>^SYS.DataCheck.ConfigurationI</IndexLocation>
<StreamLocation>^SYS.DataCheck.ConfigurationS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
