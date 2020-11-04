Class %BI.WebScheduler2 [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod LoadTheTask(currTask)
{
	d LoadTheTask^%bi.SWr.WebScheduler2(currTask)
}

ClassMethod DoDaTest()
{
	s dd=$G(%session.Data("currUserID"))
	s dd=$P(dd,$C(6),1)
	w "alert("_dd_");"
}

ClassMethod DodaSetID(usr)
{
	s %session.Data("currUserID")=usr
}

ClassMethod ANewTask()
{
	d ANewTask^%bi.SWr.WebScheduler2()
}

}
