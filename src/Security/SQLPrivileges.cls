Include (%sySecurity, %sySystem, %syAudit, %occSystemMessages)

/// Define the SQL Privilege mapping in the ^SYS global
/// Mapping was added for SQL Privileges to take advantage of XML export
Class Security.SQLPrivileges Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, LegacyInstanceContext, StorageStrategy = SQLStorage, System = 4 ]
{

Index IDKey On (Namespace, SQLObject, Privilege, Grantee, Grantor) [ IdKey ];

/// Namespace the privilege is defined in
Property Namespace As %String(MAXLEN = 256) [ Required ];

/// ObjectType,ObjectName e.g. "1,Sample.Person" or "3,Sample.PersonView"
Property SQLObject As %String(MAXLEN = 256) [ Required ];

/// Privilege assigned to the user/role
Property Privilege As %String(DISPLAYLIST = ",%ALTER,INSERT,UPDATE,DELETE,SELECT,REFERENCES,EXECUTE", MAXLEN = 1, VALUELIST = ",a,i,u,d,s,r,e") [ Required ];

/// Grantee - user/role the privilege was granted to
Property Grantee As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Grantor - user/role that granted the privilege
Property Grantor As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Grantable - 1/0, can this privilege be granted by the user
Property Grantable As %TinyInt(VALUELIST = ",0,1") [ Required ];

/// SQL Privilege resource string
Property SQLPrivString As %String(MAXLEN = 500, XMLPROJECTION = "NONE") [ Calculated, SqlComputeCode = { set {*}={SQLObject}_"||"_{Privilege}_"||"_{Grantee}_"||"_{Grantor}}, SqlComputed ];

/// This method exports SQL Object Privilege records to a file in xml format.<br>
/// Parameters:<br>
/// Filename -  Output file name<br>
/// NumExported (byref) -  Returns number of records exported.<br>
ClassMethod Export(FileName As %String = "SQLPrivilegesExport.xml", ByRef NumExported As %Integer = 0) As %Status
{
}

/// Import SQLPrivilege records from an xml file.<br>
/// Parameters:<br>
/// FileName - Filename to import Role records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String, ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Given a User or Role name, return the ID information for the privileges that have been directly granted to the user or role
Query DirectPrivileges(UserRole As %String) As %SQLQuery
{
SELECT Namespace,SQLObject,Privilege,Grantee,Grantor,Grantable FROM SQLPrivileges
 WHERE (Grantee = :UserRole)
}

/// Return the ID information for all SQL Object Privileges
Query List() As %SQLQuery
{
SELECT Namespace,SQLObject,Privilege,Grantee,Grantor,Grantable FROM SQLPrivileges
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="GrantableIndex">
<Condition>{Grantable}=1</Condition>
<ConditionFields>Grantable</ConditionFields>
<Data name="Grantable"/>
<Global>^*</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<Subscript name="1">
<AccessType>Global</AccessType>
<Expression>$e(("^|""^^"_$zu(203,1)_"""|"_$zu(203,3)),2,*)</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Security"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SQL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>"priv"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Namespace}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{Grantable}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SQLObject}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{Privilege}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{Grantee}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{Grantor}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="Grantable"/>
<Global>^*</Global>
<PopulationType>full</PopulationType>
<Subscript name="1">
<AccessType>Global</AccessType>
<Expression>$e(("^|""^^"_$zu(203,1)_"""|"_$zu(203,3)),2,*)</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Security"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SQL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>"priv"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Namespace}</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SQLObject}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{Privilege}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{Grantee}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{Grantor}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="mIndex">
<Global>^*</Global>
<PopulationType>full</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Namespace</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>$p({L8},"||",1)</Expression>
<Field>SQLObject</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>$p({L8},"||",2)</Expression>
<Field>Privilege</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>Grantee</Field>
</RowIdSpec>
<RowIdSpec name="5">
<Expression>$p({L8},"||",4)</Expression>
<Field>Grantor</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Global</AccessType>
<Expression>$e(("^|""^^"_$zu(203,1)_"""|"_$zu(203,3)),2,*)</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Security"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SQL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>"priv"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Namespace}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"m"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{Grantee}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SQLObject}_"||"_{Privilege}_"||"_{Grantee}_"||"_{Grantor}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^Security.SQLPrivilegesS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
