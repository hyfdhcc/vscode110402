Class %BI.WebCtxtMenu Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	d gen^%bi.SMw.SVGCtxt01
	Quit $$$OK
}

ClassMethod insCtxtMenu(ttype, ver)
{
	s %session.Data("cWidth")="160"
	s %session.Data("cHeight")="100"
	;w "alert('"_ver_"');"
	i ttype="2" {
		s %session.Data("CLIST",1) = "Add Computation"_$C(3)_"computeEditor(1)"
		s %session.Data("totalCLIST")=1
		s %session.Data("cWidth")="160"
		s %session.Data("cHeight")="100"
		i ver="1" {
			s %session.Data("CLIST",2) = "Edit Computation"_$C(3)_"computeEditor(2)"
			s %session.Data("CLIST",3) = "Delete Computation"_$C(3)_"computeEditor(3)"
			s %session.Data("totalCLIST")=3
			s %session.Data("cWidth")="160"
			s %session.Data("cHeight")="100"
		}
	}
	i ttype="3" {
		s %session.Data("CLIST",1) = "Add Metric"_$C(3)_"metricEditor(1)"
		s %session.Data("totalCLIST")=1
		s %session.Data("cWidth")="160"
		s %session.Data("cHeight")="100"
		i ver="1" {
			s %session.Data("CLIST",2) = "Edit Metric"_$C(3)_"metricEditor(2)"
			s %session.Data("CLIST",3) = "Delete Metric"_$C(3)_"metricEditor(3)"
			s %session.Data("totalCLIST")=3
			s %session.Data("cWidth")="160"
			s %session.Data("cHeight")="100"
		}
	}
	i ((ttype="5")!(ttype="6")) {
		s %session.Data("CLIST",1) = "Add Temp. Computation"_$C(3)_"computeEditor(4)"
		s %session.Data("totalCLIST")=1
		s %session.Data("cWidth")="180"
		s %session.Data("cHeight")="80"
		i ver="1" {
			s %session.Data("CLIST",2) = "Edit Temp. Computation"_$C(3)_"computeEditor(5)"
		} else {
			s %session.Data("CLIST",2) = "Edit Condition"_$C(3)_"conditionEditor(1)"
		}
		s %session.Data("CLIST",3) = "Delete Node"_$C(3)_"deleteNode()"
		s %session.Data("totalCLIST")=3
	}
	i (ttype="7") {
		s %session.Data("CLIST",1) = "Add Temp. Computation"_$C(3)_"computeEditor(4)"
		s %session.Data("CLIST",2) = "Add Temp. Metric"_$C(3)_"metricEditor(4)"
		s %session.Data("totalCLIST")=1
		s %session.Data("cWidth")="180"
		s %session.Data("cHeight")="80"
		i ver="1" {
			s %session.Data("CLIST",3) = "Edit Temp. Computation"_$C(3)_"computeEditor(5)"
		} else {
			s %session.Data("CLIST",3) = "Edit Temp. Metric"_$C(3)_"metricEditor(5)"
		}
		s %session.Data("CLIST",4) = "Delete Node"_$C(3)_"deleteNode()"
		s %session.Data("totalCLIST")=4
	}
	
	w "offsetX=document.body.scrollLeft;"
	w "offsetY=document.body.scrollTop;"
	w "aleft=event.clientX;"
	w "atop=event.clientY;"
	s mStr ="<embed id=SVGEmbed type=image/svg-xml src=""%BI.WebCtxtMenu.cls"" width="""_%session.Get("cWidth")_""" height="""_%session.Get("cHeight")_"""></embed>"
    w "lblb.innerHTML='"_mStr_"';"
    w "lblb.style.visibility = ""visible"";"
	w "lblb.style.position = ""absolute"";"
	w "lblb.style.left = (aleft)+offsetX;"
	w "lblb.style.top = (atop)+offsetY;"
}

}
