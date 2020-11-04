Class %BI.WebScheduler [ Abstract, Not ProcedureBlock, System = 4 ]
{

// General 

// -/////////////////////////////////////////////////////////////-//

// **********************saveScheduleGrp*****************************************

ClassMethod LoadGrpList()
{
	s %session.Data("Rptschid")=0
	d LoadGrpList^%bi.SWr.WebScheduler
}

// List of group tasks page (main page)

// -/////////////////////////////////////////////////////////////-//

// ****************************************************************

ClassMethod loadAllGroups()
{
	d loadAllGroups^%bi.SWr.WebScheduler
}

ClassMethod deleteGroup(toBeDel)
{
	i ($zv["5.0") { d deleteGroup^%bi.SWr.WebScheduler3(toBeDel) }
	else { d deleteGroup^%bi.SWr.WebScheduler5(toBeDel) }
}

// Group schedule property page

// -/////////////////////////////////////////////////////////////-//

// *******************************************************************

ClassMethod loadGrpTask(scheID)
{
	d loadGrpTask^%bi.SWr.WebScheduler(scheID)
}

ClassMethod valiDate(dat, time)
{
	
	//w "alert(cTime);"
	;d valiDate^%bi.SWr.WebScheduler6(dat)
	w "cDate="_$p($h,",",1)_";"
	//w "alert(cTime);"
	w "scheDate ="_$zdh(dat,4,,,,,,,"error")_";"
	//w "alert(scheDate);"
	s hour=$p(time,"|",1)*60*60
	s min=$p(time,"|",2)*60
	i $p(time,"|",3)=2 { s proTime=(12*60*60)+hour+min}
	else{s proTime=hour+min}
	w "cliTime="_proTime_";"
	w "servTime="_$p($h,",",2)_";"
}

ClassMethod createNewGroup()
{
	d createNewGroup^%bi.SWr.WebScheduler
}

ClassMethod setSaveNExit(savEx)
{
	s %session.Data("schedulerState") = savEx
}

ClassMethod saveScheduleGrp(tNm, tDes, tFreqRun, tRunCrit, tStTime, savEx)
{
	i ($zv["5.0") { d saveScheduleGrp^%bi.SWr.WebScheduler3(tNm, tDes, tFreqRun, tRunCrit, tStTime, savEx) }
	else { d saveScheduleGrp^%bi.SWr.WebScheduler5(tNm, tDes, tFreqRun, tRunCrit, tStTime, savEx)  }
}

ClassMethod saveTheSchedule()
{
	i ($zv["5.0") { d saveTheSchedule^%bi.SWr.WebScheduler3 } ;its always choose this
	else {  d saveTheSchedule^%bi.SWr.WebScheduler5 }
	/*
	// This will save the data being hold by the session into the database
	s scheID = %session.Get("scheID")
	d ..saveTheTask()
	*/
}

ClassMethod loadRunFreq()
{
	d loadRunFreq^%bi.SWr.WebScheduler
}

ClassMethod loadAddTChoice()
{
	d loadAddTChoice^%bi.SWr.WebScheduler
}

ClassMethod loadEndTime()
{
	d loadEndTime^%bi.SWr.WebScheduler
}

// Task property page

// -/////////////////////////////////////////////////////////////-//

// *****************************************************************

ClassMethod loadClasses()
{
	d loadClasses^%bi.SWr.WebScheduler
}

ClassMethod loadFunctions()
{
	d loadFunctions^%bi.SWr.WebScheduler()
}

ClassMethod loadFunctionsC(Fid)
{
	d loadFunctionsC^%bi.SWr.WebScheduler(Fid)
}

ClassMethod loadType(selType)
{
	
	d loadType^%bi.SWr.WebScheduler($G(selType))
}

ClassMethod loadChkbox()
{
	d loadChkbox^%bi.SWr.WebScheduler
}

ClassMethod LoadTask(currTask)
{
	d LoadTask^%bi.SWr.WebScheduler(currTask)
}

ClassMethod LoadTheTask(currTask)
{
	d LoadTheTask^%bi.SWr.WebScheduler(currTask)
}

ClassMethod LoadThePivotTask(daId)
{
	d LoadThePivotTask^%bi.SWr.WebScheduler(daId)
}

ClassMethod LoadTheBPMTask(daId)
{
	d LoadTheBPMTask^%bi.SWr.WebScheduler(daId)
}

ClassMethod LoadTheRptTask(daId)
{
	d LoadTheRptTask^%bi.SWr.WebScheduler(daId)
}

ClassMethod loadTaskButtons()
{
	d loadTaskButtons^%bi.SWr.WebScheduler
	/*
	s currTask = %session.Data("currTskID")
	s btnVal = "Update"
	i currTask="" {s btnVal = "Add" }
	w "<input type=""button"" name=""AddBtn"" value="""_btnVal_""" class=""submtBtn"" onClick=addATask()>"
	w "<input type=""button"" name=""cnclBtn"" value=""Clear"" class=""submtBtn"" onClick=clearFrm()>"
	*/
}

ClassMethod loadRptButtons()
{
	d loadRptButtons^%bi.SWr.WebScheduler
}

ClassMethod loadBPMButtons()
{
	d loadBPMButtons^%bi.SWr.WebScheduler
}

ClassMethod loadPivotButtons()
{
	d loadPivotButtons^%bi.SWr.WebScheduler
}

ClassMethod killTaskSession()
{
	s %session.Data("allTheTaskID")=""
}

ClassMethod loadListOfTask()
{
	d loadListOfTask^%bi.SWr.WebScheduler2
}

ClassMethod getTheTable()
{
	d getTheTable^%bi.SWr.WebScheduler
}

ClassMethod addANewTask(tskNm, tskType, tskComplxCode, tskCls, tskFunc, tskSuspend, newID)
{
	d addANewTask^%bi.SWr.WebScheduler(tskNm,tskType, tskComplxCode, tskCls, tskFunc, tskSuspend, newID)
}

ClassMethod addNewRptTask(RptTskNam, RptTskTyp, DaRpt, RptTskSubj, RptTskMsg, RptTskFilter, RptTskQ, RptTskAction, newid, RptRet, RptDesc, RptSuspend)
{
	d addNewRptTask^%bi.SWr.WebScheduler(RptTskNam,RptTskTyp,DaRpt,RptTskSubj,RptTskMsg,RptTskFilter,RptTskQ,RptTskAction,newid,RptRet,RptDesc,RptSuspend)
	/*
	d ##class(%BI.WebScheduler).killtempstorefilter()
	d ##class(%BI.WebScheduler).killQVarVal()
	d ##class(%BI.WebScheduler).KTrTas()
	d ##class(%BI.WebScheduler).CKLOC()
	*/
}

ClassMethod addNewPivotTask(PivTaskTyp, PivTaskName, PivTaskID, PivTaskActMail, PivTaskActMsg, PivTaskSubj, PivTaskDateL, PivTaskPriority, PivTaskMsg, PivTaskActType, PivSuspend, newid, PivRoleID)
{
	d addNewPivotTask^%bi.SWr.WebScheduler(PivTaskTyp,PivTaskName,PivTaskID,PivTaskActMail,PivTaskActMsg,PivTaskSubj,PivTaskDateL,PivTaskPriority,PivTaskMsg,PivTaskActType,PivSuspend,newid,PivRoleID)
}

ClassMethod addBPMTask(BPTaskTyp, BPTaskN, BPID, BPSuspend, newid)
{
	d addBPMTask^%bi.SWr.WebScheduler(BPTaskTyp,BPTaskN,BPID,BPSuspend,newid)
}

ClassMethod setSaveNExitTask(savEx)
{
	s %session.Data("scheduleTaskState") = savEx
}

ClassMethod saveTheTask()
{
	i ($zv["5.0") { d saveTheTask^%bi.SWr.WebScheduler3 }
	else  { d saveTheTask^%bi.SWr.WebScheduler5 }
}

ClassMethod deleteTask(toBeDel)
{
	i ($zv["5.0") { d deleteTask^%bi.SWr.WebScheduler3(toBeDel) }
	else { d deleteTask^%bi.SWr.WebScheduler5(toBeDel) }
}

/// Not in use yet
ClassMethod genTableList()
{
	d genTableList^%bi.SWr.WebScheduler
}

ClassMethod sortUPONETaskList(theTask)
{
	d sortUPONETaskList^%bi.SWr.WebScheduler(theTask)
}

ClassMethod sortDOWNONETaskList(theTask)
{
	d sortDOWNONETaskList^%bi.SWr.WebScheduler(theTask)
}

ClassMethod swapAndFillGap(theTask)
{
	s theTask = $$swapAndFillGap^%bi.SWr.WebScheduler(theTask)
	q theTask
}

ClassMethod RptId(RptIdn, Ttxt)
{
	//store the selected reportId
	s RptId=$p(RptIdn,$C(2),2)
	//w "alert('After="_RptId_"');"
	s %session.Data("RptId")=RptId
	s %session.Data("RptName")=Ttxt
}

ClassMethod setBaseCls(baseCls)
{
	d setBaseCls^%bi.SWr.WebScheduler(baseCls)
}

ClassMethod BuildTree(treeType)
{
 //Added by Kok Hong
	d BuildTree^%bi.SWr.WebAnalyzer(treeType)
}

ClassMethod TempStoreFilter(filterCode)
{
	d TempStoreFilter^%bi.SWr.WebScheduler(filterCode)
}

ClassMethod StTempFilter(tfill)
{
	s %session.Data("tempStoreFilter")=tfill
}

ClassMethod killtempstorefilter()
{
	s %session.Data("tempStoreFilter")=""
}

ClassMethod killQVarVal()
{
	s %session.Data("QVarVal")=""
}

ClassMethod AddNewQuery(QVarNam, QVal)
{
	if (%session.Get("QVarVal")="")
	{
		s %session.Data("QVarVal")=QVarNam_","_QVal
	}
	else 
	{
		s %session.Data("QVarVal")= %session.Get("QVarVal")_"|"_QVarNam_","_QVal	
	}
}

ClassMethod DoDisplayQ()
{
	
	d DDisplayQ^%bi.SWr.WebScheduler
}

ClassMethod CurDoDisplayQ()
{
	
	w "alert('hello');"
	/*s CurDaQ=%session.Get("QVarVal")
	s CurLenQ=$l(CurDaQ,"|")
	s i=1
	w "QVar.innerHTML=""<table width=100% height=100% cellspacing='2' cellpadding='2'><tr><td valign=top><table class='tblGrid' width='100%' cellspacing='1' cellpadding='1'>"
	while(i'>CurLenQ)
	{
		s CQN=$p(CurDaQ,"|",i)
		s CdaQnam=$p(CQN,",",1)
		w "<tr><td onclick=ShowQuery('"_i_"')>"_CdaQnam_"</td></tr>"
		
		s i=$i(i)
	}
	w "</table></td></tr></table>"";"*/
}

ClassMethod DeleteAction(act)
{
	if (%session.Get("ActVal")'="")
	{
		s lenAct=$L(%session.Get("ActVal"),"|")
		if (lenAct=1)
		{
			s %session.Data("ActVal")=""
		}
		else
		{
			s i=1
			s NwP=""
			while (i<=lenAct)
			{
				if (act'=i)
				{
					if (NwP="")
					{
						s NwP=$p(%session.Get("ActVal"),"|",i)	
					}
					else
					{
						s NwP=Nwp_"|"_$p(%session.Get("ActVal"),"|",i)
					}
						
				}
				s i=$i(i)
			}
			s %session.Data("ActVal")=NwP
		}	
	}
	d DDisAct^%bi.SWr.WebScheduler
}

ClassMethod AddAction(AtV, AtT)
{
	if (%session.Get("ActVal")="")
	{
		s %session.Data("ActVal")=AtV_","_AtT
	}
	else
	{
		s %session.Data("ActVal")=%session.Get("ActVal")_"|"_AtV_","_AtT
	}
}

ClassMethod DoDisplayAct()
{
	//w "alert('hello1');"
	d DDisAct^%bi.SWr.WebScheduler
}

ClassMethod ShQV(Qryid)
{
	s GQV=%session.Get("QVarVal")
	s locatQ=$p(GQV,"|",Qryid)
	s locName=$p(locatQ,",",1)
	s locVal=$p(locatQ,",",2)
	w "Qv='"_locVal_"';"
	//w "Qn='"_locName_"';"
	s %session.Data("SelEdit")=Qryid
}

ClassMethod KeepTr(Kt)
{
	//w "alert('"_Kt_"');"
	s %session.Data("ctskType")=Kt
	s %session.Data("TrTas")=Kt
}

ClassMethod KTrTas()
{
	s %session.Data("TrTas")=0
}

ClassMethod DelQEdit()
{
	//w "alert('In we go');"
	d DelQEdit^%bi.SWr.WebScheduler()
}

ClassMethod EditQ(EdQVal)
{
	d EditQ^%bi.SWr.WebScheduler(EdQVal)
}

ClassMethod ChgThis(Cht)
{
	d ChgThis^%bi.SWr.WebScheduler(Cht)
}

ClassMethod NewNameChg(NewName)
{
	s %session.Data("NewNameChg")=NewName
}

ClassMethod SetTodayDate()
{
	d SetTodayDate^%bi.SWr.WebScheduler
}

ClassMethod FromReporter()
{
	d FromReporter^%bi.SWr.WebScheduler2()
}

ClassMethod DoRunNow()
{
	//w "alert("_%session.Get("scheID")_");"
	i ($zv["5.0") { d DoRunNow^%bi.SWr.WebScheduler4() }
	else { d DoRunNow^%bi.SWr.WebScheduler6() }
}

ClassMethod DChkBox()
{
	d DChkBox^%bi.SWr.WebScheduler2()
}

ClassMethod DChkBox2()
{
	d DChkBox2^%bi.SWr.WebScheduler2()
}

ClassMethod CKLOC()
{
	s daLoc=$G(%session.Data("LOCFrom"))
	if (daLoc="taskGrpList.csp")
	{			
		w "window.opener.formToSession(1);"
		//w "window.opener.location.href=#server(..Link('spdScheduler.csp'))#;"
		
	}	
	//w "window.close()"
}

ClassMethod LoadGrpBldTask(tm)
{
	d LoadGrpBldTask^%bi.SWr.WebScheduler2(tm)
}

ClassMethod SetSelGrpBuild()
{
	d SetSelGrpBuild^%bi.SWr.WebScheduler2()
}

ClassMethod addNewGrpBTask(tskNm, tskType, tskSuspend, GrpTyp, newID)
{
	d addNewGrpBTask^%bi.SWr.WebScheduler2(tskNm,tskType,tskSuspend,GrpTyp,newID)
}

ClassMethod SetTaskCondNow(tsk)
{
	s %session.Data("TskCondNow")=tsk
	//s ^TT(tsk)=$G(%session.Data("taskCondi",tsk))
	s %session.Data("TCond")=$G(%session.Data("taskCondi",tsk))
}

ClassMethod SaveTaskCond(cond)
{
	s curTsk=$g(%session.Data("TskCondNow"))
	s %session.Data("taskCondi",curTsk)=cond
}

}
