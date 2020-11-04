Include %ZEN.ReportUtil

/// Zen Report Print Server definition and utility methods/queries.
Class %ZEN.Report.PrintServer Extends RenderServer [ Final, System = 4 ]
{

Parameter TYPE = 2;

ClassMethod %ServePSTransform(xmlfile As %String, xslfile As %String, ps As %String, logfile As %String, UseInstalledFop As %Boolean)
{

	Set tSC=$$$OK
	if ##class(%File).Exists(ps) {
			Quit $$$ERROR($$$GeneralError,"You cannot print to an existent file "_ps)
	}
	If $g(^%SYS("zenreport","transformerpath"))'="" {
		Set exe=^%SYS("zenreport","transformerpath")
	} elseif (UseInstalledFop  && ##class(%File).Exists($$$fopbat)) {
		if ($$$isWINDOWS)||($$$isUNIX) {
			Set exe=$$$fopbat
		} else {
			Quit $$$ERROR($$$GeneralError,"You must set ^%SYS(""zenreport"",""transformerpath"") to the location of your PDF transformer.")
		}
	} else {
		Quit $$$ERROR($$$GeneralError,"You must set ^%SYS(""zenreport"",""transformerpath"") to the location of your PDF transformer.")
	}

	// make sure we don't concatenate to log file - which confuses use
	i $g(logfile)'="" Do ##class(%File).Delete(logfile)
	
	If $g(^%SYS("zenreport","transformerconfig"))'="" {
		Set args($i(args))="-c",args($i(args))=^%SYS("zenreport","transformerconfig")
		Set config = " -c """_^%SYS("zenreport","transformerconfig")_""" "
	} ElseIf (UseInstalledFop  && ##class(%File).Exists($$$fopconfig)) {
		Set args($i(args))="-c",args($i(args))=$$$fopconfig
		Set config=" -c """_$$$fopconfig_""" "
	} Else {
		Set config=""
	}
	if '$$$isVMS {
		Set args($i(args))="-xml",args($i(args))=xmlfile
		Set args($i(args))="-xsl",args($i(args))=xslfile
		Set args($i(args))="-ps",args($i(args))=ps
		Try {
			Set rc=$zf(-100,"/stderr="""_logfile_""" /stdout="""_logfile_"""",$zu(147,exe),.args)
		} Catch {
			Set io=$IO
			Open logfile:"WN"
			Use logfile
			Write "sh: No such file '"_exe_"'"
			Use io
			Close logfile
			set rc=-1
		}
	} else {
		Do $zf(-1,"@"_$zu(147,exe)_config_" -xml """_xmlfile_""" -xsl """_xslfile_""" -ps """_ps_"""",logfile)
	}

	quit tSC
}

ClassMethod %ServeTransformAndPrint(xmlfile As %String, xslfile As %String, outfile As %String, printer As %String, logfile As %String, UseInstalledFop As %Boolean, PrintServer As %String, PrintTimeOut As %String = "")
{
	
	Set tSC=$$$OK

	If $g(^%SYS("zenreport","transformerpath"))'="" {
		Set exe=^%SYS("zenreport","transformerpath")
	} elseif (UseInstalledFop  && ##class(%File).Exists($$$fopbat)) {
		if ($$$isWINDOWS)||($$$isUNIX) {
			Set exe=$$$fopbat
		} else {
			Quit $$$ERROR($$$GeneralError,"You must set ^%SYS(""zenreport"",""transformerpath"") to the location of your PDF transformer.")
		}
	} else  {
		Quit $$$ERROR($$$GeneralError,"You must set ^%SYS(""zenreport"",""transformerpath"") to the location of your PDF transformer.")
	}

	Set tSC=$$$OK
	If $d(^%SYS("zenreport","adobepath")) {
		Set adobe=^%SYS("zenreport","adobepath")
	} Else {
		if '$$$isWINDOWS {
			Quit $$$ERROR($$$GeneralError,"You must set ^%SYS(""zenreport"",""adobepath"") to the location of your Adobe Reader or Adobe Acrobat.")
		}
	}

	// make sure we don't concatenate to log file - which confuses use
	i $g(logfile)'="" Do ##class(%File).Delete(logfile)
	
	If $g(^%SYS("zenreport","transformerconfig"))'="" {
		Set args($i(args))="-c",args($i(args))=^%SYS("zenreport","transformerconfig")
		Set config = " -c """_^%SYS("zenreport","transformerconfig")_""" "
	} ElseIf (UseInstalledFop  && ##class(%File).Exists($$$fopconfig)) {
		Set args($i(args))="-c",args($i(args))=$$$fopconfig
		Set config=" -c """_$$$fopconfig_""" "
	} Else {
		Set config=""
	}
	
	if '$$$isVMS {
		Set args($i(args))="-xml",args($i(args))=xmlfile
		Set args($i(args))="-xsl",args($i(args))=xslfile
		Set args($i(args))="-pdf",args($i(args))=outfile
		Try {
			Set rc=$zf(-100,"/stderr="""_logfile_""" /stdout="""_logfile_"""",$zu(147,exe),.args)
		} Catch {
			Set io=$IO
			Open logfile:"WN"
			Use logfile
			Write "sh: No such file '"_exe_"'"
			Use io
			Close logfile
			set rc=-1
		}
	} else {
		Do $zf(-1,"@"_$zu(147,exe)_config_" -xml """_xmlfile_""" -xsl """_xslfile_""" -pdf """_outfile_"""",logfile)
	}

	If $$$isUNIX {
		Try {
			Set rc=$zf(-100,"/async",$zu(147,adobe),"/t",outfile,printer)
		} Catch {
			Set io=$IO
			Open logfile:"WN"
			Use logfile
			Write "sh: No such file '"_adobe_"'"
			Use io
			Close logfile
			set rc=-1
		}
	} elseif $$$isWINDOWS {
		Set tSC=##class(%ZEN.Report.hotPrint).print2(outfile,printer,PrintServer,PrintTimeOut)
	} else {
		Do $zf(-2,$zu(147,adobe)_" /t """_outfile_""""_" "_printer)
	}

	Quit tSC
}

ClassMethod %PerformPrint(outfile As %String, printer As %String, PrintServer As %String, PrintTimeOut As %String = "")
{
	
	Set tSC=$$$OK
	If $d(^%SYS("zenreport","adobepath")) {
		Set adobe=^%SYS("zenreport","adobepath")
	}
	Else {
		if '$$$isWINDOWS {
			Quit $$$ERROR($$$GeneralError,"You must set ^%SYS(""zenreport"",""adobepath"") to the location of your Adobe Reader or Adobe Acrobat.")
		}
	}

	if '##class(%File).Exists(outfile) { 
        set tSC=$$$ERROR($$$GeneralError,"Output file cannot be printed because it does not exist.") 
    } else { 
		If $$$isUNIX {
			Try {
				Set rc=$zf(-100,"/async",$zu(147,adobe),"/t","/s",outfile,printer)
			} Catch {
				Set tSC=$$$ERROR($$$FileDoesNotExist,abobe)
			}
		} elseif $$$isWINDOWS {
			Set tSC=##class(%ZEN.Report.hotPrint).print2(outfile,printer,PrintServer,PrintTimeOut)
		} else {
			Do $zf(-2,$zu(147,adobe)_" /t """_outfile_""""_" "_printer)
		}
    }

	Quit tSC
}

/// Generate the command line to run the script to start up the Print Server.
ClassMethod CmdLine(pReportServer As %ZEN.Report.PrintServer, Output pCmd As %String, Output pCmdArgs) As %String
{
	/*
	Program options:
	-port nnnnn
	-numthreads nnn
	-printengine <jPDFPrint|PDFBox>
	-loglevel level
	-logfile filename
	-maxlogfilesize maximum log file size
	-logrotationcount maximum number of log files then cycles
	-numpingthreads n
	-pingport nnnn
	-key <licensekey>
	*/
	Set pCmd = ""
	Set pPredictedCmdStr = ""
	Try {
		// Directory where the script is located
		Set tCmd = $system.Util.InstallDirectory()
		For tDir = "lib", "PrintServer" {
			Set tCmd = ##class(%File).SubDirectoryName(tCmd, tDir)
		}
	
		// Script
		Set tScript = "run"
		Set pCmd = ##class(%File).NormalizeFilename(tCmd_$S($$$isWINDOWS:"\",$$$isVMS:"",1:"/")_tScript_$S($$$isWINDOWS:".bat",$$$isVMS:".com",1:""))
	
		// build the command arguments
		Set pCmdArgs = ""
	
		// Print engine
		If (pReportServer.PrintEngine="") || (pReportServer.PrintEngine="jPDFPrint") {
			Set pCmdArgs($increment(pCmdArgs)) = "-printengine"
			Set pCmdArgs($increment(pCmdArgs)) = "jPDFPrint"
			If (pReportServer.Key'="") {
				Set pCmdArgs($increment(pCmdArgs)) = "-key"
				Set pCmdArgs($increment(pCmdArgs)) = pReportServer.Key
			}
		}
		Else {
			Set pCmdArgs($increment(pCmdArgs)) = "-printengine"
			Set pCmdArgs($increment(pCmdArgs)) = pReportServer.PrintEngine
		}

		// Parameters
		Set pCmdArgs($increment(pCmdArgs)) = "-port"
		Set pCmdArgs($increment(pCmdArgs)) = +pReportServer.Port
		Set pCmdArgs($increment(pCmdArgs)) = "-numthreads"
		Set pCmdArgs($increment(pCmdArgs)) = +pReportServer.NumThreads
		Set pCmdArgs($increment(pCmdArgs)) = "-loglevel"
		Set pCmdArgs($increment(pCmdArgs)) = +pReportServer.LogLevel
		If pReportServer.LogLevel {
			If (pReportServer.LogFile'="") {
				Set pCmdArgs($increment(pCmdArgs)) = "-logfile"
				Set pCmdArgs($increment(pCmdArgs)) = pReportServer.LogFile
			}
			If (pReportServer.MaxLogFileSize'="") {
				Set pCmdArgs($increment(pCmdArgs)) = "-maxlogfilesize"
				Set pCmdArgs($increment(pCmdArgs)) = pReportServer.MaxLogFileSize
			}
			If (pReportServer.LogRotationCount'="") {
				Set pCmdArgs($increment(pCmdArgs)) = "-logrotationcount"
				Set pCmdArgs($increment(pCmdArgs)) = pReportServer.LogRotationCount
			}
		}
		Set pCmdArgs($increment(pCmdArgs)) = "-numpingthreads"
		Set pCmdArgs($increment(pCmdArgs)) = +pReportServer.NumPingThreads
		Set pCmdArgs($increment(pCmdArgs)) = "-pingport"
		Set pCmdArgs($increment(pCmdArgs)) = +pReportServer.PingPort

		// build the predicted command string (for displaying in logs, etc.)
		Set pPredictedCmdStr = pCmd
		For ctr=1:1:pCmdArgs {
			Set cmdArg = pCmdArgs(ctr)
			Set:(cmdArg[" ")||(cmdArg="") cmdArg = $char(34)_cmdArg_$char(34)
			Set pPredictedCmdStr = pPredictedCmdStr_" "_cmdArg
		}
	}
	Catch (ex) {
	}
	Quit pPredictedCmdStr
}

/// Lookup Zen Report Print Servers, get basic data plus state.
Query ByServer() As %Query(ROWSPEC = "Name,Port,PingPort,PrintEngine,State,StateEx") [ SqlProc ]
{
}

ClassMethod ByServerExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set tRS = ##class(%ResultSet).%New("%ZEN.Report.PrintServer:ByName")
		Kill ^||%ISC.ZRS
		Set tSC = tRS.Execute()
		For {
			Quit:'tRS.Next()
			If tRS.Get("ServerType")'=2 Continue // Not a Print Server
			Set name = tRS.Get("Name")
			Set ^||%ISC.ZRS(name) = $LB(name,tRS.Get("Port"),tRS.Get("PingPort"),tRS.Get("PrintEngine"))
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Set qHandle = $LB("")
	Quit tSC
}

/// Lookup all Zen Report Print Servers.
Query ByName(name As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Name,Port,PingPort,ServerType,PrintEngine") [ SqlProc ]
{
 SELECT %ID, Name, Port, PingPort, ServerType, PrintEngine
 FROM PrintServer
 WHERE ServerType='2'
 ORDER BY Name
}

/// Type must be "2" for Print Servers.
Property ServerType As %String [ InitialExpression = "2", ReadOnly ];

/// Print engine - "jPDFPrint" or "Adobe".
Property PrintEngine As %String(DISPLAYLIST = ",jPDFPrint,Adobe", VALUELIST = ",jPDFPrint,Adobe") [ InitialExpression = "jPDFPrint", Required ];

Property Key As %String;

Storage Default
{
<Data name="PrintServerDefaultData">
<Subscript>"PrintServer"</Subscript>
<Value name="1">
<Value>PrintEngine</Value>
</Value>
<Value name="2">
<Value>Key</Value>
</Value>
</Data>
<DefaultData>PrintServerDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}
