Class %BI.WebRoleMtns Extends (%CSP.Page, %BI.CSPsuper) [ ClassType = "", Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod GetModuleData(RID, RTxt)
{
 	
	s fill=16
	s count=1
			
	w "frmRole.txtNameR.value= '"_RTxt_"';"
	w "frmRole.btnUpAdd.value='Update';"
	
	s Pid=##class(%CSP.Page).QuoteJS($LG(^BI.RolesD(RID),2))
	if (Pid '="")
	{
		s PNam= $LG(^BI.RolesD(Pid),1)
	
		w "frmRole.txtPRole.value="_PNam_";"
	}
	else
	{
		w "frmRole.txtPRole.value= '';"		
	}
	//This is for the module tab contents
	d SessionMod^%bi.SWrCSP.RoleMtns(RID)  //clear
		
	
	w "ModuleId.innerHTML=""<table width='100%' border='1' bordercolor='#CCCCCC' cellspacing='0' cellpadding='0'>"
	w "<tr class='grpListFontHdr'><td width='32%' bgcolor='#666666'>Modules</td><td width='50%' bgcolor='#666666'>Menu Label</td><td width='18%' bgcolor='#666666'>"_$$$Text("Grant Access")_"</td></tr>"
		while (count'> fill) 
		{
			s MLabel=$p(^BI.RolesD(RID,"M",count),$C(3),1)
			s MBox=$P(^BI.RolesD(RID,"M",count),$C(3),2)
			s Txt="T"_count
			s Box="B"_count
			;w "alert("_Txt_");"
			w "<tr><td width='32%' class='GreyOut'>"_%session.Get(count)_"</td><td><input type=text name="_Txt_" value='"_MLabel_"' OnBlur='Change("_RID_","_Txt_","_count_")' style=width:100%;border:0;font-size:10px;font-family:Verdana, Arial, Helvetica, sans-serif></td>"
			w "<td width='18%' align='center'>"
			if MBox=-1{
			w "<input type='checkbox' name='"_Box_"' value='0' checked OnBlur='Change2("_RID_","_Box_","_count_")'></td></tr>"
			}else{
			w "<input type='checkbox' name='"_Box_"' value='-1' OnBlur='Change2("_RID_","_Box_","_count_")'></td></tr>"	
			}
			;w "alert("_Txt_")"
			s count=$i(count)
			
				}
	   w "</table>"";"
}

ClassMethod GetSubjectData(RID)
{
	
	if RID'=""
	{
		s RTxt=##class(%CSP.Page).QuoteJS($LG(^BI.RolesD(RID),1))
		s LicMx=##class(%CSP.Page).QuoteJS($LG(^BI.RolesD(RID),3))
		s minRow=##class(%CSP.Page).QuoteJS($LG(^BI.RolesD(RID),4))
		
		s mdLg=$LG(^BI.RolesD(RID),5)
		
		d GetIDName^%bi.SWr.WebSCMod(mdLg)
		w "frmRole.txtNameR.value="_RTxt_";"
		w "frmRole.txtMaxLic.value="_LicMx_";"
		w "frmRole.txtMinRow.value="_minRow_";"
		s Pid=$LG(^BI.RolesD(RID),2)
		w "frmRole.btnUpAdd.value='"_$$$Text("Update")_"';"
	}	
	
	/*HidObj=document.getElementById('hidemodLog0n')
	HidObj.value="""_mdLg_""";"
	*/
	//w "frmRole.btnUpAdd.value='Update';"
	
	
	if ($G(Pid) '="")
	{
		//s PNam= $LG(^BI.RolesD(Pid),1)
		d lookPar^%bi.SWrCSP.RoleMtns(Pid)
		//w "frmRole.txtPRole.value= '"_PNam_"';"
	}
	else
	{
		w "Parid='';"
	}
	d SessionMod^%bi.SWrCSP.RoleMtns(RID)
	//Display for the Subject Tab
	
	w "SubjectId.innerHTML=""<table width=100% height=100% cellspacing='2' cellpadding='2'><tr><td valign=top><table class='tblGrid' width='100%' cellspacing='1' cellpadding='1'>"
	w "<tr class='grpListFontHdr'><td width='50%' bgcolor='#666666'>"_$$$Text("Subject Areas")_"</td><td width='32%' bgcolor='#666666'>"_$$$Text("Class")_"</td><td width='18%' bgcolor='#666666'>"_$$$Text("Grant Access")_"</td></tr>" //Subject Area,Class,Grant Access
	
		s Total=$G(^SYS("BI","DM","Data"))
		
		
		s %session.Data("STotal")=Total
		s i=1 
		s modC=1
		//d gRoleDM^%bi.SWrCSP.RoleMtns(%session.Get("RID"))
		while (i'>Total){
			if ($D(^SYS("BI","DM","Data",i))'=0)
			{
			s STxt="ST"_i
			s SBox="SB"_i
			s SubArea= $p(^SYS("BI","DM","Data",i),$C(3),1)
			s subCls= $p(^SYS("BI","DM","Data",i),$C(3),2)
			
				if (modC # 2=0)
				{
					s ColC="trE"
				}
				else
				{
					s ColC="trO"
				}
				s modC=$i(modC)
			//d gRoleDM^%bi.SWrCSP.RoleMtns(%session.Get("RID"))
			
			 //s ^TMPDAN = $G(OLIST(i))_":"_$G(i)_":"_$G(X)
			//s SubArea=$p(OLIST(i),X,2)
			//s subCls=$p(OLIST(i),X,3)
			
			w "<tr class='"_ColC_"'><td width='50%' >"_SubArea_"</td>"	
			w "<td width='32%'><input class='"_ColC_"' type=text name="_STxt_" value='"_subCls_"' style=width:100%;border:0;font-size:10px;font-family:Verdana, Arial, Helvetica, sans-serif></td>"
			w "<td width='18%' align='center'>"
			if ($G(%session.Data("RID"))'=""),($D(^SYS("BI","DM","UGRP",%session.Get("RID"),i))=1)
			{
				 w "<input type='checkbox' name='"_SBox_"' id='"_SBox_"' checked></td>"

			}
			else
			{
				w "<input type='checkbox' name='"_SBox_"' id='"_SBox_"'></td>"
			}
			}
			s i=$i(i)
		
		
		}
	w "</tr></table></td></tr></table>"";"
}

ClassMethod GetDetailData()
{
	
	
	
    w "DetailId.innerHTML=""<table width=100% height=100% cellspacing='2' cellpadding='2'><tr><td valign=top><table class='tblGrid' width='100%' cellspacing='1' cellpadding='1'>"
  	w "<tr class='grpListFontHdr'><td width='50%' bgcolor='#666666'>"_$$$Text("Detail Listings")_"</td><td width='32%' bgcolor='#666666'>"_$$$Text("Class")_"</td><td width='18%' bgcolor='#666666'>"_$$$Text("Grant Access")_"</td></tr>"
	
		s Total=$G(^BI.DetailListD)
		
		s i=1 
		s al=1
		s modC=1
		while (i'>Total)
		{
			if ($D(^BI.DetailListD(i))'=0)
			{
				s DTxt="DT"_i
				s DBox="DB"_i
				
				if (modC # 2=0)
				{
					s ColC="trE"
				}
				else
				{
					s ColC="trO"
				}
				s modC=$i(modC)
				
				d gRoleDL^%bi.SMr.QueryCom3(%session.Get("RID"))
				
				//s DetDat=$G(^BI.DetailListD(i))
				//s DetArea= $LG(DetDat,1)
				//s DetCls= $LG(DetDat,2)
				
							
				s DetArea=$p(OLIST(al),$C(3),2) 
				s DetClas=$p(OLIST(al),$C(3),3)
				
				w "<tr class='"_ColC_"'><td width='50%' >"_DetArea_"</td>"	
				w "<td width='32%'><input class='"_ColC_"' type=text name="_DTxt_" value='"_DetClas_"' style=width:100%;border:0;font-size:10px;font-family:Verdana, Arial, Helvetica, sans-serif></td>"
				w "<td width='18%' align='center'>"
				if ($p(OLIST(al),$C(3),4)=1)  
				{
					w "<input type='checkbox' name='"_DBox_"' checked></td></tr>"
				}
				else
				{
					w "<input type='checkbox' name='"_DBox_"'></td></tr>"	
				}
				s al=$i(al)
			}
			s i=$i(i)
		}
		
	w "</table></td></tr></table>"";"
}

ClassMethod GetMemberData()
{
	d GetMember^%bi.SWrCSP.RoleMtns
}

ClassMethod GetClassETLData()
{
}

ClassMethod QTree(reco)
{
	//set the arrays
	s treeIcon="['<IMG ALIGN=TOP SRC=treeDnD/Theme_XP2/page.gif>','<IMG ALIGN=TOP SRC=treeDnD/Theme_XP2/page.gif>']"
	s rs=##class(%ResultSet).%New("%BI.Roles:AllRoles")
	do rs.Execute()
	while rs.Next() 
	{
		set Description=rs.Get("Description"),id=rs.Get("ID"),Parent=rs.Get("ParentRole")
		if (Parent="")
		{
			s O(id) = "["_treeIcon_",'"_Description_"',null,'"_id_"'"
			
		}
		else
		{
			s O(id) = ",["_treeIcon_",'"_Description_"',null,'"_id_"'"
			
		}
		
	}
	
	s OTree=""
	s OT=""
	s ls=##class(%ResultSet).%New("%BI.Roles:AllRoles")
	//w "alert('OTree"_OTree_"');"
	do ls.Execute()
	while ls.Next()
	{
		
		set DescriptionL=ls.Get("Description"),idL=ls.Get("ID"),ParentL=ls.Get("ParentRole")
		if (ParentL="")
		{
			
			s OTree= OTree_O(idL)
			
			set es=##class(%ResultSet).%New("%BI.Roles:AllRoles")
			do es.Execute()
 			while es.Next()
 			{
	 			set DescriptionE=es.Get("Description"),idE=es.Get("ID"),ParentE=es.Get("ParentRole")
	 			if (ParentE'="")&&(ParentE=idL)
	 			{
		 			
		 			s OT= OTree_O(idE)
		 			d MenuT^%bi.SWrCSP.RoleMtns(idE,ParentE,DescriptionE,OTree)	
		 			s %session.Data("MenuTrac")=0
		 			s OT=OT_"]"
		 			
					//w "alert('OT"_OT_"');"
					s OTree=OT
	 			}
	 			
	 			
	 		}	
	 		
	 		s OTree= OTree_"],"
		}
		
	}
	//to draw the tree 
	
	if (reco=1)
	{
	w "<script language=javascript>"
	//w "alert(Final'"_OTree_"');" 
	w "dblFuncName = 'getValSet()';"
	w "var Menu = ["_OTree_"];"
	w "</script>"
	}
	else
	{
		w "Menu = ["_OTree_"];"
	}
}

ClassMethod QTree1()
{
    w "<script language=javascript>"
	w "dblFuncName = 'getValSet()';"
	w "var Menu = ["
 s treeIcon="['<IMG ALIGN=TOP SRC=treeDnD/Theme_XP2/page.gif>','<IMG ALIGN=TOP SRC=treeDnD/Theme_XP2/page.gif>']"
 // List out all the roles.
 set rs=##class(%ResultSet).%New("%BI.Roles:AllRoles")
 do rs.Execute()
 while rs.Next() 
 {
	set Description=rs.Get("Description"),id=rs.Get("ID"),Parent=rs.Get("ParentRole")
	if (Parent="")
	{
		
		w "["_treeIcon_",'"_Description_"',null,'"_id_"'"
	
		set ls=##class(%ResultSet).%New("%BI.Roles:AllRoles")
		
		do ls.Execute()
 		while ls.Next()
 		{
	 		set DescriptionL=ls.Get("Description"),idL=ls.Get("ID"),ParentL=ls.Get("ParentRole")

	 		if (ParentL'="") && (ParentL=id)
	 		{
		 		w ",["_treeIcon_",'"_DescriptionL_"',null,'"_idL_"']"		
	 		}		
	 	} 
		w "],"
	}
 }
 	w "];"
	w "</script>"
}

ClassMethod Update(daNam, daPa, maxlic, MinRow, MdLog, etlStr)
{
	d UpdateNow^%bi.SWrCSP.RoleMtns(daNam,daPa,maxlic,MinRow,MdLog,etlStr)
}

ClassMethod NameToSession(NameC)
{
	s N=NameC
	
	d NameToSession^%bi.SWrCSP.RoleMtns(N)
}

ClassMethod TempUp(NVal, RID, No)
{
	s NVal=NVal
	s RID=RID
	s No=No	
	d TempUp^%bi.SWrCSP.RoleMtns(NVal,RID,No)
	
	//w "alert('"_%session.Get("UpVal")_"');"
	//w "alert('"_%session.Get("TxId")_"');"
}

ClassMethod TempBoxUp(NBox, RID, BoxNo)
{
	
	s NBox=NBox
	s RID=RID
	s BoxNo=BoxNo
	d TempBoxUp^%bi.SWrCSP.RoleMtns(NBox,RID,BoxNo)
}

ClassMethod Add(daNam, daPa, KeepSave, daMaxLic, daMinRow, MdLog, etlStr)
{
	d AddNew^%bi.SWrCSP.RoleMtns(daNam,daPa,KeepSave,daMaxLic,daMinRow,MdLog,etlStr)
}

ClassMethod FirstDisplay()
{
  // This are for the initial module tab display
	d FirstDisplaySession^%bi.SWrCSP.RoleMtns	
	
	//s count=1
	//s fill=16
	
 /*w "ModuleId.innerHTML=""<table width='100%' border='1' bordercolor='#CCCCCC' cellspacing='0' cellpadding='0' style=border:1px>"
	w "<tr class='grpListFontHdr'><td width='32%' bgcolor='#666666'>Modules</td><td width='50%' bgcolor='#666666'>Menu Label</td><td width='18%' bgcolor='#666666'>Grant Access</td></tr>"
	
	while (count'> 16) 
		{
			s Txt="T"_count
			s Box="B"_count
			w "<tr><td width='32%' class='GreyOut'>"_%session.Get(count)_"</td><td><input type=text name="_Txt_" value='"_%session.Get(count)_"' style=width:100%;border:1;font-size:10px;font-family:Verdana, Arial, Helvetica, sans-serif></td>"
			w "<td width='18%' align='center'>"
			w "<input type='checkbox' name='"_Box_"' value='0' OnClick='GivVal("_Box_")'></td></tr>"	
			
			
			s count=$i(count)
			
				}
	   w "</table>"";"*/
	   
	   //This are for initial display of the Subject Area
	 
	do loadTheTrans^%bi.SWrt.WebTranslation(6) 
	   
	;w "SubjectId.innerHTML=""<table width=100% height=100% cellspacing='2' cellpadding='2'><tr><td valign=top><table width='100%' border='0' cellspacing='1' cellpadding='1'>"
	;w "<tr class='grpListFontHdr'><td width='50%' bgcolor='#666666'>"_$LG(modTrans,10)_"</td><td width='32%' bgcolor='#666666'>"_$LG(modTrans,12)_"</td><td width='18%' bgcolor='#666666'>"_$LG(modTrans,13)_"</td></tr>"
	;w "</tr></table></td></tr></table>"";"  
	d ##class(%BI.WebRoleMtns).GetSubjectData("")
	
	//This is for the initial display of the Detail Listings
	
	;w "DetailId.innerHTML=""<table width=100% height=100% cellspacing='2' cellpadding='2'><tr><td valign=top><table width='100%' border='0' cellspacing='1' cellpadding='1'>"
	;w "<tr class='grpListFontHdr'><td width='50%' bgcolor='#666666'>"_$LG(modTrans,11)_"</td><td width='32%' bgcolor='#666666'>"_$LG(modTrans,12)_"</td><td width='18%' bgcolor='#666666'>"_$LG(modTrans,13)_"</td></tr>"
	;w "</tr></table></td></tr></table>"";"
	d ##class(%BI.WebRoleMtns).GetDetailData()
	
	// this for web module innitial display
	
	/*w "WebModule.innerHTML=""<table width='100%' border='1' bordercolor='#CCCCCC' cellspacing='2' cellpadding='2'>"
	w "<tr class='grpListFontHdr'><td width='50%' bgcolor='#666666'>Modules</td><td width='25%' bgcolor='#666666'>Yes</td><td width='25%' bgcolor='#666666'>Not</td></tr>"
	w "<tr><td height=357><div class='bdrstyle' id='moduletree'></div></td>"
	w "<td><div></div></td>"
	w "<td><div></div></td></tr>"

			
    w "</table>"";"*/
}

ClassMethod Collect(New, NewBox)
{
	s new=New
	s newBox=NewBox
	//w "alert('"_new_"');"
	//w "alert("_%session.Get("TracVal")_");"
   if %session.Get("TracVal")=0
   {
		s newV=""
		s box=""
		s newV=new_","
		s box=newBox_","
		s %session.Data("TracVal")=1
		s %session.Data("new")=newV
		s %session.Data("newBox")=box
		//w "alert('"_%session.Get("new")_"');"
		
		
			
	}else{
		//w "alert('"_%session.Get("TracVal")_"');"
		s newV=%session.Get("new")_new_","
		s %session.Data("new")=newV
		s box=%session.Get("newBox")_newBox_","
		s %session.Data("newBox")=box
	}
}

ClassMethod CollectW(NewWV, NewWB)
{
	if (%session.Get("TracValW")=0)
	{
	s WnewV=""
		s Wbox=""
		s WnewV=NewWV_","
		s Wbox=NewWB_","
		s %session.Data("TracVal")=1
		s %session.Data("Wnew")=WnewV
		s %session.Data("WnewBox")=Wbox	
	}
	else
	{
		s WnewV=%session.Get("Wnew")_NewWV_","
		s %session.Data("Wnew")=WnewV
		s Wbox=%session.Get("WnewBox")_NewWB_","
		s %session.Data("WnewBox")=Wbox
	}
}

ClassMethod CollectSub(NewSB)
{
	
	//start collecting	
	//w "alert('"_NewSB_"');"
	s %session.Data("sBox")=NewSB
	/*if %session.Get("TracSub")=0
	{
		
		s sBox=""
		s sBox=NSB_","
		s %session.Data("TracSub")=1
		s %session.Data("sBox")=sBox
		w "alert('"_%session.Get("sBox")_"');"	
	}
	else
	{
		
		s sBox=%session.Get("sBox")_NSB_","
		s %session.Data("sBox")=sBox	
		w "alert('"_%session.Get("sBox")_"');"
	}*/
	//w "alert('Finally"_%session.Get("sBox")_"');"
}

ClassMethod CollectDet(ColDet)
{
	
			
	//start collecting	
	
 s %session.Data("DetBox")=ColDet
}

ClassMethod CollectWeb(NewTx, NewBx)
{
	s Nbx=NewBx
	if (Nbx="true")
	{
		s Nbx=-1	
	}else{
		s Nbx=0
		}	
		
	if %session.Get("TracWeb")=0
	{
		s dWTx=""
		s dWTx=NewTx_"|"_Nbx_","
		s %session.Data("TracWeb")=1	
		s %session.Data("NewWebDat")=dWTx
	}	
	else {
		s dWTx=%session.Get("NewWebDat")_NewTx_"|"_Nbx_","
		s %session.Data("NewWebDat")=dWTx	
	}
}

ClassMethod DeleteRole()
{
	if (%session.Get("RID")'=1)
	{
		if ($G(%session.Data("RID"))="") w "alert('"_$$$Text("Error Deleting Role","%BI")_"');" q 
		
		//Before deleting a role , delete the child ParentRole property if exist !!!
		s ord = $O(^BI.RolesD(""))
		while ord'="" {
			if +ord=ord // to grab only the number id
			{
				s obj = ##class(%BI.Roles).%OpenId(ord)
				if (obj.ParentRole'=""),(obj.ParentRole.%Id() = %session.Get("RID")){
					s obj.ParentRole = ""
					d obj.%Save()
				}
			}
			s ord = $O(^BI.RolesD(ord))
		}
		d ##class(%BI.Roles).%DeleteId(%session.Get("RID"))	
		
		d delUGrp^%bi.SMr.DataMart1(1,%session.Get("RID"))
		d delUGrp^%bi.SMr.DataMart1(2,%session.Get("RID"))
		k ^BI.DetailListD(1,"ROLE",%session.Get("RID"))
		k ^BI.DetailListD(2,"ROLE",%session.Get("RID"))
	}
	else
	{
		w "alert('"_$$$Text("Deletion of this Role is prohibited","%BI")_"');"	
	}
	
	//d DeleteRole^%bi.SWrCSP.RoleMtns
}

ClassMethod GetdT()
{
	//s dT=^BI.DetailListD
	w "var dT ='"_^BI.DetailListD_"'"
	//w "alert('"_dT_"');"
	//w "alert('"_^BI.DetailListD_"');"
}

ClassMethod Pon(NR)
{
	if (NR=""){
	w "alert('"_$$$Text("Please Enter A Name For the New Role","%BI")_"');"
	}
}

ClassMethod StoreP(valTxt, valSet)
{
	s %session.Data("TracPa")=1
	d StoreParent^%bi.SWrCSP.RoleMtns(valTxt,valSet)
}

ClassMethod CollectSubTotal()
{
	s m=^SYS("BI","DM","Data")	
	w "m="_m_";"
}

ClassMethod CollectDetTotal()
{
	
	s m=^BI.DetailListD
	w "m="_m_";"
	//w "alert('m="_m_"');"
}

ClassMethod CollectTotal()
{
	s CT= $$TotalMod^%bi.SWr.InitModuleAcc()  //18^BI.WebModuleAccess("T")
	s %session.Data("Mlv1")=CT
	s %session.Data("Mlv2")=""
	s %session.Data("Mlv3")=""
	f i=1:1:CT  //find out how many lv2
 	{
	 	if ($D(^BI.WebModuleAccess(i,1))'=0)
	 	{
		 	s c=1
			while($D(^BI.WebModuleAccess(i,c))'=0)
			{
				s cT=c
				s c=$i(c)
			}
			
			if (%session.Get("Mlv2")="")
			{
				s %session.Data("Mlv2")=i_","_cT	
			}
			else
			{
				s %session.Data("Mlv2")=%session.Get("Mlv2")_"||"_i_","_cT	
			}
			
			s t=1
			while (t'>cT)
			{
				if ($D(^BI.WebModuleAccess(i,t,1))'=0)
				{	
					s g=1
					while ($D(^BI.WebModuleAccess(i,t,g))'=0)
					{
						if (%session.Get("Mlv3")="")
						{
							s %session.Data("Mlv3")=i_"g"_t_"g"_g	
						}
						else
						{
							s %session.Data("Mlv3")=%session.Get("Mlv3")_"|"_i_"g"_t_"g"_g
						}
						s g=$i(g)
					}	
				}
				
				s t=$i(t)	
			}
	 	}
	 	
	}
	//w "Ctotal='"_CT_"';"
	//w "alert('lv2="_%session.Get("Mlv2")_"');"
	//w "alert('lv3="_%session.Get("Mlv3")_"');"
	d CollectTree^%bi.SWrCSP.RoleMtns()
}

ClassMethod DisplayParentName(h)
{
	
	s PRName=$LG(^BI.RolesD(h),1)
	//w "alert('Hello"_h_"');"
	w "frmRole.txtPRole.value='"_PRName_"';"
}

ClassMethod ChkValid()
{
	s V=""
	/*while(i'>m)
	{
		
		if ($D(^SYS("BI","DM","Data",i))'=0)
		{
			s deV=1	
		}
		else
		{
			s deV=0		
		}
		
		if (V="")
		{
			s V=deV
		}
		else
		{
			s V=V_","_deV
		}
		
		s i=$i(i)
		*/
		
		s dacon=""
		s dasuba=$o(^SYS("BI","DM","Data",dacon))
		while (dasuba'="")
		{
			if (V="")
			{
				s V=dasuba	
			}
			else
			{
				s V=V_","_dasuba
			}
			s dasuba=$o(^SYS("BI","DM","Data",dasuba))	
		}
			
			
		
		
	
	w "V='"_V_"';"
}

ClassMethod ChkX(m)
{
	s c=1
	s Xs=""
	w "Xs='"
	while (c'>m)
	{
		s Xsit=$D(^BI.DetailListD(c))
		if (Xsit'=0)
		{
			s Xsit=1	
		}
		if (Xs="")
		{
			s Xs=Xsit
			w Xs
		}
		else
		{
			;s Xs=Xs_","_Xsit
			w ","_Xsit
		}
		
		s c =$i(c)
	}
	w "';"
	;w "Xs='"_Xs_"';" //commented to solve max string 16Oct09
}

ClassMethod GetWebMod(RID, RTxt)
{
	//s fill=13
	s count=1
			
	w "WebModule.innerHTML=""<table width='100%' border='1' bordercolor='#CCCCCC' cellspacing='1' cellpadding='1' class=bdrStyle>"
	w "<tr class='grpListFontHdr'><td width='32%' bgcolor='#666666'>Modules</td><td width='50%' bgcolor='#666666'>Menu Label</td><td width='18%' bgcolor='#666666'>Grant Access</td></tr>"
		while (count'> 16) 
		{	if ($D(^BI.RolesD(RID,"W",count))=0)
			{
				s MLabel=$G(%session.Data(count,"Web"))
				s MBox=0	
			}else{
				s MLabel=$Piece(^BI.RolesD(RID,"W",count),$C(3),1)
				s MBox=$Piece(^BI.RolesD(RID,"W",count),$C(3),2)
			}
			s Txt="Tx"_count
			s Box="Bx"_count
			if ($D(MLabel)'=0) && ($D(MBox)'=0)
			{
			//w "alert('"_MBox_"');"
			w "<tr><td width='32%' class='GreyOut'>"_$G(%session.Data(count,"Web"))_"</td><td><input type=text name="_Txt_" value='"_MLabel_"' style=width:100%;border:0;font-size:10px;font-family:Verdana, Arial, Helvetica, sans-serif></td>"
			w "<td width='18%' align='center'>"
			if MBox=-1{
			w "<input type='checkbox' name='"_Box_"' value='0' checked></td></tr>"
			}else{
			w "<input type='checkbox' name='"_Box_"' value='-1'></td></tr>"	
			}
			;w "alert("_Txt_")"
			}else{
				w "<tr><td width='32%' class='GreyOut'>"_$G(%session.Data(count,"Web"))_"</td><td><input type=text name="_Txt_" value='"_$G(%session.Data(count,"Web"))_"' style=width:100%;border:0;font-size:10px;font-family:Verdana, Arial, Helvetica, sans-serif></td>"	
				w "<input type='checkbox' name='"_Box_"' value='-1'></td></tr>"
			}
			s count=$i(count)
			
		}
	   w "</table>"";"
}

ClassMethod MTree()
{
	
	if ($D(^BI.WebModuleAccess)=0)
	{
		d FirstLoad^%bi.SWr.InitModuleAcc
	}
	s TotMod= $$TotalMod^%bi.SWr.InitModuleAcc()  //18 //^BI.WebModuleAccess("T")
	
	f a=1:1:TotMod
	{		
		if ($D(^BI.WebModuleAccess(a,1))'=0)
		{	
			s b=1
			while($D(^BI.WebModuleAccess(a,b))'=0)
			{
				s ltch=b
				s b=$i(b)
			}	
				
		f c=1:1:ltch
		{
			if ($D(^BI.WebModuleAccess(a,c,1))'=0) //here
			{
				s t=1
		
				while ($D(^BI.WebModuleAccess(a,c,t))'=0) 
					{
						s cid=a_"g"_c_"g"_t
						s Mc=^BI.WebModuleAccess(a,c,t)
				
						if (t=1)
						{
							s MChild="['<input type=checkbox id=ch"_cid_">','"_Mc_"',null,'"_cid_"'],"
						}	
						else
						{
							s MChild=MChild_"['<input type=checkbox id=ch"_cid_">','"_Mc_"',null,'"_cid_"'],"
						}
						s t=$i(t)
					}
			}
				
				s lvC=a_"g"_c	
				s checkIco="['<input type=checkbox id=ch"_lvC_" onclick=SetChk2("""_lvC_""")>','<input type=checkbox id=chk"_lvC_" onclick=SetCh2("""_lvC_""")>']"
				s PM=^BI.WebModuleAccess(a,c)
				
				if (c=1) && ($D(^BI.WebModuleAccess(a,c,1))'=0)
					{
						s ^BI.WModParent(lvC)=""
						s Mod="["_checkIco_",'"_PM_"',null,'"_lvC_"',"_MChild_"],"
					}
				elseif ($D(^BI.WebModuleAccess(a,c,1))=0)
					{
						s checkIco="['<input type=checkbox id=ch"_lvC_">']"
						s Mod=Mod_"["_checkIco_",'"_PM_"',null,'"_lvC_"'],"	
					}
				elseif (c=1) && ($D(^BI.WebModuleAccess(a,c,1))=0)
					{
						s checkIco="['<input type=checkbox id=ch"_lvC_">']"
						s Mod="["_checkIco_",'"_PM_"',null,'"_lvC_"'],"	
					}	
				else 
					{
						s ^BI.WModParent(lvC)=""
						s Mod=Mod_"["_checkIco_",'"_PM_"',null,'"_lvC_"',"_MChild_"],"	
					}	
					
		}
	}
		
			s GPM=^BI.WebModuleAccess(a)
			s checkIcoG="['<input type=checkbox id=ch"_a_" onclick=SetChk("_a_")>','<input type=checkbox id=chk"_a_" onclick=SetCh("_a_")>']" 
			if (a=1) && ($D(^BI.WebModuleAccess(a,1))'=0)
			{
				s ^BI.WModParent(a)=""
				s GMod="["_checkIcoG_",'"_GPM_"',null,'"_a_"',"_Mod_"],"
			}
			elseif (a'=1) && ($D(^BI.WebModuleAccess(a,1))=0)
			{
				s checkIcoG="['<input type=checkbox id=ch"_a_">']"
				s GMod=GMod_"["_checkIcoG_",'"_GPM_"',null,'"_a_"'],"
			}
			elseif (a=1) && ($D(^BI.WebModuleAccess(a,1))=0)
			{
				s checkIcoG="['<input type=checkbox id=ch"_a_">']"
				s GMod="["_checkIcoG_",'"_GPM_"',null,'"_a_"'],"	
			}
			elseif (a'=1) && ($D(^BI.WebModuleAccess(a,1))'=0)
			{
				s ^BI.WModParent(a)=""
				s GMod=GMod_"["_checkIcoG_",'"_GPM_"',null,'"_a_"',"_Mod_"],"		
			}
			
			s Mod=""
	}
	
	
	
	
	w "<script language=javascript>"
	w "var ModTree = ["_GMod_"];"
	w "</script>"
}

ClassMethod NTree()
{
	s DaTree=""
	d NTree2^%bi.SWrCSP.RoleMtns(DaTree)
		
	
	w "<script language=javascript>"
	//w "alert('"_AA_"');"
	w "var ModTree = ["_DaTree_"];"
	w "</script>"
}

ClassMethod AccYes(hV, hT)
{
	s V=$L(hV,"g")
	s chV="ch"_hV
	//if (V'=2)
	//{
		s TempSAccYes=%session.Get("AccYes")
		
		if (%session.Get("APM")="")
		{
			s %session.Data("APM")=hT	
		}
		else
		{
			s %session.Data("APM")=%session.Get("APM")_hT	
		}
		
		if (TempSAccYes'="")
		{
			s %session.Data("AccYes")=TempSAccYes_","_hT
		}
		else
		{
			s %session.Data("AccYes")=hT
		}
		//w "eval("_chV_");"
		w "frmRole."_chV_".checked=1;"
	
		//w "eval(ChSel);"
		//w "ChSel.Checked"
		d AccYes^%bi.SWrCSP.RoleMtns()	
	//	}
}

ClassMethod AccNot(hV, hT)
{
	s TempSAccNot=%session.Get("AccNot")
	
	if (TempSAccNot'="")
	{
		s %session.Data("AccNot")=TempSAccNot_","_hT
	}
	else
	{
		s %session.Data("AccNot")=hT
	}
	d AccNot^%bi.SWrCSP.RoleMtns()
}

ClassMethod chfollow(pid)
{
	d chfollow^%bi.SWrCSP.RoleMtns(pid)
}

ClassMethod DReload()
{
	d FirstDisplaySession^%bi.SWrCSP.RoleMtns()
}

ClassMethod ThisUAcc(RtoSav)
{
	
		s %session.Data("RedToSav")=RtoSav
}

ClassMethod GetNewTreeMod(rid)
{
	d GetNewTreeMod^%bi.SWrCSP.RoleMtns(rid)
}

ClassMethod GetTreeMod(set)
{
	if ($D(^BI.RolesD(set,"C"))=0)
	{
		w "DisplayNone()"
	}
	else
	{
		s y=1
		s z=$G(^BI.RolesD(set,"C"))
		while(y'>z)
		{
			s Cva=^BI.RolesD(set,"C",y)
			s CvaId=$p(Cva,$C(3),1)
			s CvaStat=$p(Cva,$C(3),2)
			if (CvaStat="true")
			{
				s Stat=1	
			}
			else
			{
				s Stat=0
			}
			w "eval(""CvaId='ch"_CvaId_"'"");"
			
			w "dSelT=document.getElementById(CvaId);"
			w "dSelT.checked="_Stat_";"
			
			if ($d(^BI.WModParent(CvaId))'=0)
			{
				w "eval(""CvaId='chk"_CvaId_"'"");"
				w "dSelC=document.getElementById(CvaId);"
				w "dSelC.checked="_Stat_";"	
			}
			
			s y=$i(y)	
		} 
	}
}

ClassMethod DisplayRoles()
{
	
	d RedrawRole^%bi.SWrCSP.RoleMtns()
}

ClassMethod ChkAll(c)
{
	d FindChd^%bi.SWrCSP.RoleMtns(c)
}

ClassMethod ChkAll2(c, stat)
{
	
	d FdChd2^%bi.SWrCSP.RoleMtns(c,stat)
}

ClassMethod GettheP(p)
{
	s Pc=1
	s RP=0
	s rs=##class(%ResultSet).%New("%BI.Roles:AllRoles")
	do rs.Execute()
	while rs.Next() 
	{
		s ID= rs.Get("ID")
		if (ID=p)
		{
			s RP=Pc	
		}
		s Pc=$i(Pc)	
	}
	w "Rp='"_RP_"';"
}

ClassMethod DisplayRole()
{
	d RedrawRole^%bi.SWrCSP.RoleMtns()
}

ClassMethod ReDisplayRole()
{
	d RedrawRoleAg^%bi.SWrCSP.RoleMtns()
}

ClassMethod ReloadParDr()
{
	d teLoadPar^%bi.SWrCSP.RoleMtns()
}

ClassMethod GetChId()
{
	d GetChId^%bi.SWrCSP.RoleMtns
}

ClassMethod SRoleTree(TrVal)
{
	d SRoleTree^%bi.SWrCSP.RoleMtns(TrVal)
}

ClassMethod SDaParentRol(daPa)
{
	s %session.Data("ParRole")=daPa
}

ClassMethod GetVal(ID, Parid, RID)
{
	w "document.getElementById('selectPar').innerHTML = """
	d LoadPar^%bi.SWrCSP.RoleMtns(ID)
	w """;"
	d ..GetSubjectData(ID)
	d ..GettheP(Parid)
}

ClassMethod CheckRoleName(NR)
{
	q $$checkRoleName^%bi.SWrCSP.RoleMtns(NR)
}

Storage Default
{
<Data name="WebRoleMtnsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^BI.WebRoleMtnsD</DataLocation>
<DefaultData>WebRoleMtnsDefaultData</DefaultData>
<IdLocation>^BI.WebRoleMtnsD</IdLocation>
<IndexLocation>^BI.WebRoleMtnsI</IndexLocation>
<StreamLocation>^BI.WebRoleMtnsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
