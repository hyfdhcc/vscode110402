/// EMS.SQLSecurityMessage is used to transmit SQL Security updates originating
/// from the Enterprise Manager distributed SQL Security API.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class."
Class EMS.SQLSecurityMessage Extends EMS.MessageContent
{

// SQL command strings to be executed.  Currently only one.

Property Commands As array Of %String(MAXLEN = "");

// Number of commands.  Initially, always 1.

Property NumberOfCommands As %Integer [ InitialExpression = 1 ];

// Namespace to for grant/revoke commands which apply to items in the namespace. 

Property Namespace As %String;

// User who issued the SQL Distributed Security API command.

Property IssuingUser As %String;

}
