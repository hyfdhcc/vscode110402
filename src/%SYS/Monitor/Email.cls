Include (%syMonitor, %syPidtab, %sySystem, %occErrors)

Class %SYS.Monitor.Email Extends %RegisteredObject [ LegacyInstanceContext, ProcedureBlock, System = 3 ]
{

/// Mailer
Property Mailer As %Net.SMTP;

/// Mail message
Property Msg As %Net.MailMessage;

/// Initialize the email. Check the argument Status: 1=success, 0=failure.
Method Initialize() As %Status
{
	s $zt="RunErr"

	// Set the email properties
	s recipients = ##class(%Monitor.Manager).AppRecipients()
	s server = ##class(%Monitor.Manager).AppSmtpServer()
	i (recipients = "") || (server = "") s $ze = "Email not configured" goto RunErr
	s ..Mailer = ##class(%Net.SMTP).%New()
	s ..Mailer.smtpserver = server

	// Do smtp authorization if configured
	if ##class(%Monitor.Manager).AppSmtpUserName()'="" {
	set auth=##class(%Net.Authenticator).%New() ; use default authentication list
	set auth.UserName=##class(%Monitor.Manager).AppSmtpUserName()
	set auth.Password=##class(%Monitor.Manager).AppSmtpPassword()
	set ..Mailer.authenticator=auth
	}

	// Create a Message object and fill in From, To, Subject
	s charset="UTF-8"
	s ..Msg = ##class(%Net.MailMessage).%New(charset)
	s ..Msg.From=##class(%Monitor.Manager).AppEmailSender()

	f i=1:1:$ll(recipients) do ..Msg.To.Insert($list(recipients,i))

	Q $$$OK
RunErr
	s $zt=""
	Q $$$ERROR($$$CacheError,$ze)
}

/// Sends message via configured email.
Method SendEmail(msg As %String) As %Status
{
	s $zt="RunErr"

	i '##class(%Monitor.Manager).AppEnableEmail() s $ze = "Email not enabled" goto RunErr
	s ..Msg.Subject = "Cache Application Monitor Alert"
	s dt=$zdt($h,2)
	d ..Msg.TextData.Clear()
	// Add message content
	d ..Msg.TextData.WriteLine(msg)
	// Send the message and close objects
	d ..Mailer.Send(..Msg)
	Q $$$OK
RunErr
	s $zt=""
	Q $$$ERROR($$$CacheError,$ze)
}

Method %OnNew(initval As %CacheString = "") As %Status [ Private ]
{
	s status = ..Initialize()
 	Q status
}

}
