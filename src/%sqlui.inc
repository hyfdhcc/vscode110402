ROUTINE %sqlui [Type=INC]
#define CSPUIVersion 1.01
#; for localizing text in CSP pages
#def1arg LocalizeText(%args)    $$FormatMessage^%occMessages(%response.Language,%args)
#define ChangeNamespace      	Do ##class(%CSP.Util.AutoPage).ChangeNamespace($G(%request.Data("$NAMESPACE",1)))
#define HTMLErrorMsg(%a)		##class(%CSP.Page).EscapeHTML($System.Status.GetErrorText(%a))
#define GetDBEncKeyID      		$System.Security.System.GetDBEncKeyID()
#define gsD1					$c(22,35,1)
#; for setting up DocLocalized Zen pages on SMP
#define setPropertyDocLabel(%property)        If $G(P(%property,"label")) '= "" Set %page.%GetComponentById(%property).label = P(%property,"label")
#define setPropertyDocHint(%property)         If $G(P(%property,"hint")) '= "" Set %page.%GetComponentById(%property).hint = P(%property,"hint")
#define setPropertyDocValue(%property)        Set %page.%GetComponentById(%property).value = $G(P(%property))
#; for setting up Zen style links
#define GetHomePage				##class(%CSP.UI.Portal.Template).%GetHomePage()
#define GetDefaultNamespace		##class(%CSP.Util.TitlePane).GetDefaultNamespace()

#; use the following in SMP pages, especially in SMP Zen pages
#define CacheTempMgt			^|"%SYS"|CacheTemp.MgtPortalSettings
#define SQLMaxTreeLoad			$G($$$CacheTempMgt($Username,"SQLMAXTREELOAD"),10000)

#; use the following in SMP CSP pages to redirect to Home page
#define BackToHome 				If $System.CLS.IsMthd("%CSP.Portal.Home","Page") Set %response.Redirect = ..Link("/csp/sys/%25CSP.Portal.Home.zen")

#define SetRefreshTimer	If $G($$$CacheTempMgt($Username,..%GetPageName(),"AutoRefreshState")) = 1 Set ..%GetComponentById("refreshTimer").timeout = +$G($$$CacheTempMgt($Username,..%GetPageName(),"AutoRefreshRate"),10)*1000

#; use the following in SMP to log audit
#define SMPEventSource			"%System"
#define SMPEventType			"%SMPExplorer"
#define SMPEventChange			"Change"
#define SMPEventExecute			"ExecuteQuery"
#define SMPEventExport			"Export"
#define SMPEventImport			"Import"
#define SMPEventView			"ViewContents"
#define EventDescription		..%GetPageName()
#define CRLF					$C(13,10)
#define SMPAuditChange			Set EventData=$E(EventData,1,$$$MAXEVENTDATALEN) Do $SYSTEM.Security.Audit($$$SMPEventSource,$$$SMPEventType,$$$SMPEventChange,EventData,EventDesc)
#define SMPAuditExport			Set EventData=$E(EventData,1,$$$MAXEVENTDATALEN) Do $SYSTEM.Security.Audit($$$SMPEventSource,$$$SMPEventType,$$$SMPEventExport,EventData,EventDesc)
#define SMPAuditImport			Set EventData=$E(EventData,1,$$$MAXEVENTDATALEN) Do $SYSTEM.Security.Audit($$$SMPEventSource,$$$SMPEventType,$$$SMPEventImport,EventData,EventDesc)
#define SMPAuditView			Set EventData=$E(EventData,1,$$$MAXEVENTDATALEN) Do $SYSTEM.Security.Audit($$$SMPEventSource,$$$SMPEventType,$$$SMPEventView,EventData,EventDesc)
#define SMPAuditExecute			Set EventData=$E(EventData,1,$$$MAXEVENTDATALEN) Do $SYSTEM.Security.Audit($$$SMPEventSource,$$$SMPEventType,$$$SMPEventExecute,EventData,EventDesc)
#define PatEventRows			##class(%CSP.UI.System.AuditUtils).PatEventDataRows