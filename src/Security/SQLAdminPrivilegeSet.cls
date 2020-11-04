Include (%sySecurity, %sySystem, %syAudit, %occSystemMessages)

/// Define the SQL Administrative Privilege mapping in the ^SYS global
/// Mapping was added for SQL Privileges to take advantage of XML export
/// Map Data Order:
/// 	  #;                 1 - %CREATE_FUNCTION
/// 	  #;                 2 - %DROP_FUNCTION
/// 	  #;                 3 - %CREATE_METHOD
/// 	  #;                 4 - %DROP_METHOD
/// 	  #;                 5 - %CREATE_PROCEDURE
/// 	  #;                 6 - %DROP_PROCEDURE
/// 	  #;                 7 - %CREATE_QUERY
/// 	  #;                 8 - %DROP_QUERY
/// 	  #;                 9 - %CREATE_TABLE
/// 	  #;                 10 - %ALTER_TABLE
/// 	  #;                 11 - %DROP_TABLE
/// 	  #;                 12 - %CREATE_VIEW
/// 	  #;                 13 - %ALTER_VIEW
/// 	  #;                 14 - %DROP_VIEW
/// 	  #;                 15 - %CREATE_TRIGGER
/// 	  #;                 16 - %DROP_TRIGGER
/// 	  #;                 17 - %NOCHECK
/// 	  #;                 18 - %NOTRIGGER
/// 	  #;                 19 - %NOINDEX
/// 	  #;                 20 - %NOCHECK
Class Security.SQLAdminPrivilegeSet Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, StorageStrategy = SQLStorage, System = 4 ]
{

Index IDKey On (Namespace, Grantee) [ IdKey ];

/// Namespace the privilege is defined in
Property Namespace As %String(MAXLEN = 256) [ Required ];

/// Grantee - user/role the privilege was granted to
Property Grantee As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// CreateFunction - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property CreateFunction As %TinyInt(VALUELIST = ",0,1,2");

/// DropFunction - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property DropFunction As %TinyInt(VALUELIST = ",0,1,2");

/// CreateMethod - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property CreateMethod As %TinyInt(VALUELIST = ",0,1,2");

/// DropMethod - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property DropMethod As %TinyInt(VALUELIST = ",0,1,2");

/// CreateProcedure - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property CreateProcedure As %TinyInt(VALUELIST = ",0,1,2");

/// DropProcedure - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property DropProcedure As %TinyInt(VALUELIST = ",0,1,2");

/// CreateQuery - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property CreateQuery As %TinyInt(VALUELIST = ",0,1,2");

/// DropQuery - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property DropQuery As %TinyInt(VALUELIST = ",0,1,2");

/// CreateTable - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property CreateTable As %TinyInt(VALUELIST = ",0,1,2");

/// AlterTable - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property AlterTable As %TinyInt(VALUELIST = ",0,1,2");

/// DropTable - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property DropTable As %TinyInt(VALUELIST = ",0,1,2");

/// CreateView - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property CreateView As %TinyInt(VALUELIST = ",0,1,2");

/// AlterView - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property AlterView As %TinyInt(VALUELIST = ",0,1,2");

/// DropView - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property DropView As %TinyInt(VALUELIST = ",0,1,2");

/// CreateTrigger - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property CreateTrigger As %TinyInt(VALUELIST = ",0,1,2");

/// DropTrigger - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property DropTrigger As %TinyInt(VALUELIST = ",0,1,2");

/// NoCheck - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property NoCheck As %TinyInt(VALUELIST = ",0,1,2");

/// NoTrigger - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property NoTrigger As %TinyInt(VALUELIST = ",0,1,2");

/// NoIndex - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property NoIndex As %TinyInt(VALUELIST = ",0,1,2");

/// NoLock - 0/1/2, can this privilege be granted by the user 0 - No, 1 - Yes, 2 - Yes and grantable
Property NoLock As %TinyInt(VALUELIST = ",0,1,2");

/// This method exports SQL Admin Privilege Set records to a file in xml format.<br>
/// Parameters:<br>
/// Filename -  Output file name<br>
/// NumExported (byref) -  Returns number of records exported.<br>
ClassMethod Export(FileName As %String = "SQLPrivilegesExport.xml", ByRef NumExported As %Integer = 0) As %Status
{
}

/// Import SQLAdminPrivilegeSet records from an xml file.<br>
/// Parameters:<br>
/// FileName - Filename to import Role records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String, ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Return the ID information for SQL Admin Privs Sets
Query List() As %SQLQuery
{
SELECT Namespace,Grantee FROM SQLAdminPrivilegeSet
}

/// Given a User or Role name, return the ID information for Admin Privs that have been directly granted to the user or role
Query DirectPrivileges(UserRole As %String) As %SQLQuery
{
SELECT Namespace,Grantee FROM SQLAdminPrivilegeSet
 WHERE (LOWER(Grantee) = LOWER(:UserRole))
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Master">
<Data name="AlterTable">
<Piece>10</Piece>
</Data>
<Data name="AlterView">
<Piece>13</Piece>
</Data>
<Data name="CreateFunction">
<Piece>1</Piece>
</Data>
<Data name="CreateMethod">
<Piece>3</Piece>
</Data>
<Data name="CreateProcedure">
<Piece>5</Piece>
</Data>
<Data name="CreateQuery">
<Piece>7</Piece>
</Data>
<Data name="CreateTable">
<Piece>9</Piece>
</Data>
<Data name="CreateTrigger">
<Piece>15</Piece>
</Data>
<Data name="CreateView">
<Piece>12</Piece>
</Data>
<Data name="DropFunction">
<Piece>2</Piece>
</Data>
<Data name="DropMethod">
<Piece>4</Piece>
</Data>
<Data name="DropProcedure">
<Piece>6</Piece>
</Data>
<Data name="DropQuery">
<Piece>8</Piece>
</Data>
<Data name="DropTable">
<Piece>11</Piece>
</Data>
<Data name="DropTrigger">
<Piece>16</Piece>
</Data>
<Data name="DropView">
<Piece>14</Piece>
</Data>
<Data name="NoCheck">
<Piece>17</Piece>
</Data>
<Data name="NoIndex">
<Piece>19</Piece>
</Data>
<Data name="NoLock">
<Piece>20</Piece>
</Data>
<Data name="NoTrigger">
<Piece>18</Piece>
</Data>
<Global>^*</Global>
<PopulationType>full</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Namespace</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>Grantee</Field>
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
<Expression>"syspriv"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Namespace}</Expression>
</Subscript>
<Subscript name="6">
<Expression>$zcvt({Grantee},"L")</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^Security.SQLAdminPrivilegeSetS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
