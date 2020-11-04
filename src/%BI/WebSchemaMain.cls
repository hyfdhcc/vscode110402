Class %BI.WebSchemaMain [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod loadAttForm(dLstId As %Integer)
{
	d loadAttForm^%bi.SWr.WebSchemaMain(dLstId)
}

ClassMethod loadCAggregate(schemaId As %Integer)
{
	q $$loadCAggregate^%bi.SWr.WebSchemaMain(schemaId)
}

ClassMethod loadClass()
{
	d loadClass^%bi.SWr.WebSchemaMain //deprecated in schema 26may05
}

ClassMethod DispSysClassSession(DispSys, currSelClass)
{
	s %session.Data("DispSysClass")=DispSys
	d loadClassNSubject^%bi.SWr.WebSchemaMain("divschemaClass","")
}

ClassMethod loadClassNSubject(div, cls)
{
	w "<script language=javascript>"
	d loadClassNSubject^%bi.SWr.WebSchemaMain(div,cls)
	w "</script>"
}

ClassMethod CheckDispSys()
{
	w "showsystemclass.checked=false;"
	if ($g(%session.Data("DispSysClass"))=1)
	{w "showsystemclass.checked=true;"}
}

ClassMethod loadClassNSubject2(div, cls)
{
	d loadClassNSubject^%bi.SWr.WebSchemaMain(div,cls)
}

ClassMethod loadUnClass(div, cls, tot, str)
{
	
	w "<script language=javascript>"
	d loadUnClass^%bi.SWr.WebSchemaMain(div,cls,tot,str)
	w "</script>"
}

ClassMethod loadUnClass2(div, cls, tot, str)
{
	d loadUnClass^%bi.SWr.WebSchemaMain(div,cls,tot,str)
}

ClassMethod loadClsInfo(className As %String)
{
	d loadClsInfo^%bi.SWr.WebSchemaMain(className)
}

ClassMethod loadDetailLst(className As %String)
{
	d loadDetailLst^%bi.SWr.WebSchemaMain(className)
}

ClassMethod loadDimAccess(schemaId As %Integer)
{
	d loadDimAccess^%bi.SWr.WebSchemaMain(schemaId)
}

ClassMethod loadDimension(className As %String, srttyp)
{
	s %session.Data("SORTTYPE")=srttyp
	d loadDimension^%bi.SWr.WebSchemaMain(className,srttyp)
}

ClassMethod loadDLst(className As %String)
{
	d loadDLst^%bi.SWr.WebSchemaMain(className)
}

ClassMethod loadDLstField(dLstId As %Integer)
{
	d loadDLstField^%bi.SWr.WebSchemaMain(dLstId)
}

ClassMethod loadDLstGen(dLstId As %Integer)
{
	d loadDLstGen^%bi.SWr.WebSchemaMain(dLstId)
}

ClassMethod loadDLstRoles(dLstId As %Integer)
{
	d loadDLstRoles^%bi.SWr.WebSchemaMain(dLstId)
}

ClassMethod loadDrillDown(schemaId As %Integer, initial As %Integer)
{
	//d loadDrillDown^%bi.SWr.WebSchemaMain(schemaId,initial)
	d loadDrillDown^%bi.SWrt.WebSMSubject(schemaId,initial)
}

ClassMethod saveTree(schemaid)
{
	d saveTree^%bi.SWrt.WebSMSubject(schemaid)
}

ClassMethod loadRoles(schemaId As %Integer)
{
	d loadRoles^%bi.SWr.WebSchemaMain(schemaId)
}

ClassMethod loadSchema(className As %String)
{
	d loadSchema^%bi.SWr.WebSchemaMain(className)
}

ClassMethod loadSchemaDetails(id)
{
	d loadSchemaDetails^%bi.SWr.WebSchemaMain(id)
}

ClassMethod loadnewsubj(cl, nsubid)
{
	//w "alert('Ka');"
	d loadnewsubj^%bi.SWr.WebSchemaMain(cl,nsubid)
}

ClassMethod setBaseCls(baseCls)
{
	d setBaseCls^%bi.SWr.WebSchemaMain(baseCls)
}

ClassMethod AddDrillDownListSession(FromTxt, FromVal, ToTxt, ToVal)
{
	//d AddDrillDownListSession^%bi.SWr.WebSchemaMain(FromTxt,FromVal,ToTxt,ToVal)
	d AddDrillDownListSession^%bi.SWrt.WebSMSubject(FromTxt,FromVal,ToTxt,ToVal)
}

ClassMethod killDrillDown()
{
	d killDrillDown^%bi.SWr.WebSchemaMain
}

ClassMethod loadTree()
{
	d loadTree^%bi.SWr.WebSchemaMain
}

ClassMethod load2DimDetail(id)
{
	d load2DimDetail^%bi.SWrt.WebSMDimension(id)
}

ClassMethod updateSubject(id)
{
	d updateSubject^%bi.SWr.WebSchemaMain(id)
}

// load dimension

ClassMethod loadSubClass(SelectName, hilight)
{
	
	d loadSubClass^%bi.SWr.WebSchemaMain(SelectName,hilight)
}

// load CompMem

ClassMethod loadCompMem(ClassName, KE1, KE2)
{
	
	d loadCompMem^%bi.SWrt.WebSMCompMem(ClassName,KE1,KE2)
}

ClassMethod createCompMemSelect(className)
{
	//q "hallo"
	
	q $$createCompMemSelect^%bi.SWrt.WebSMCompMem(className)
}

ClassMethod aaa(ClassName)
{
	//w "alert('load ============class name hallo');"
	//d aaa^%bi.SWrt.WebSMDeltaLoad(ClassName)
}

ClassMethod loadCompMemData(Classid, val)
{
	
	d loadCompMemData^%bi.SWrt.WebSMCompMem(Classid,val)
}

ClassMethod addGlidlayout(val)
{
	
	d addGlidlayout^%bi.SWrt.WebSMDetailListing(val)
}

ClassMethod loadwidth(val)
{
	
	d loadwidth^%bi.SWrt.WebSMDetailListing(val)
}

ClassMethod loadidNameDetailList()
{
	
	q $$loadidNameDetailList^%bi.SWrt.WebSMDetailListing()
}

ClassMethod loadClassDetailListByid(id)
{
	
	q $$loadClassDetailListByid^%bi.SWrt.WebSMDetailListing(id)
}

ClassMethod loadDimTabData(id)
{
	q $$loadDimTabData^%bi.SWrt.WebSMDimension(id)
}

// WebSMListingFields

ClassMethod loadListingField(className)
{
	d loadListingField^%bi.SWrt.WebSMListingFields(className)
}

// loadLFTabData(id)

ClassMethod loadLFTabData(id)
{
	
	q $$loadLFTabData^%bi.SWrt.WebSMListingFields(id)
}

ClassMethod loadMyTree()
{
	
	q $$loadMyTree^%bi.SWrt.WebSMTree()
}

ClassMethod addDimensionClassToTree(class)
{
	
	d addDimensionClassToTree^%bi.SWrt.WebSMDimension(class)
}

ClassMethod saveDimension(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9)
{
	
	d saveDimension^%bi.SWrt.WebSMDimension(P0,P1,P2,P3,P4,P5,P6,P7,P8,P9)
}

ClassMethod addLFClassToTree(class)
{
	
	d addLFClassToTree^%bi.SWrt.WebSMListingFields(class)
}

ClassMethod getDimensionClass()
{
	
	q $$getDimensionClass^%bi.SWrt.WebSMDimension
}

ClassMethod deleteDimension(ID)
{
	
	d deleteDimension^%bi.SWrt.WebSMDimension(ID)
}

ClassMethod saveLF(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, PX)
{
	// p4 is empty
	q $$saveLF^%bi.SWrt.WebSMListingFields(P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,PX)
}

ClassMethod deleteLF(ID)
{
	// p4 is empty
	d deleteLF^%bi.SWrt.WebSMListingFields(ID)
}

ClassMethod addToLFFromD(ID)
{
	// p4 is empty
	d addToLFFromD^%bi.SWrt.WebSMDimension(ID)
}

ClassMethod addAllToLFFromD(arrID)
{
	// p4 is empty
	//s ^AlaTry("arrID")=arrID
	d addAllToLFFromD^%bi.SWrt.WebSMDimension(arrID)
}

ClassMethod loadDeltaLoad(class)
{
	q $$loadDeltaLoad^%bi.SWrt.WebSMDeltaLoad(class)
}

// modify on 11/june/05

ClassMethod saveSystem(P0, P1, P2, P3, P4, P5, P6, chkNoObj, chkAutoSQL, P7, P8, P9, P10, P11, P12, audt, P13, P14)
{
	d saveSystem^%bi.SWrt.WebSMSystem(P0,P1,P2,P3,P4,P5,P6,chkNoObj,chkAutoSQL,P7,P8, P9, P10,P11,P12,audt,P13,P14)
}

ClassMethod saveDeltaLoad(class, val)
{
	d saveDeltaLoad^%bi.SWrt.WebSMDeltaLoad(class,val)
}

ClassMethod saveCompMem(P0, P1, P2, P3, P4, P5, P6, P7, P8)
{
	q $$saveCompMem^%bi.SWrt.WebSMCompMem(P0,P1,P2,P3,P4,P5,P6,P7,P8)
}

ClassMethod deleteCompMem(P1, P2, classname)
{
	q $$deleteCompMem^%bi.SWrt.WebSMCompMem(P1,P2,classname)
}

ClassMethod saveRoleAccess(id, var)
{
	d saveRoleAccess^%bi.SWrt.WebSMSubject(id,var)
}

ClassMethod saveDimAccess(id, arr)
{
		//w "alert('dim access = "_arr_"');"
		//canot use
	//w "alert('arr = "_arr_"');"
	//d saveDimAccess^%bi.SWrt.WebSMSubject(id,arr)
	//d saveDimAccess2^%bi.SWrt.WebSMSubject(id,arr)
}

ClassMethod saveMyDim(id, arr)
{
	//w "alert('dim = "_arr_"');"
	d saveDimAccess2^%bi.SWrt.WebSMSubject(id,arr)
}

ClassMethod saveAggreagate(id, arr)
{
	d saveAggreagate^%bi.SWrt.WebSMSubject(id,arr)
}

ClassMethod saveSubjectsDetails(P0, P1, P2, P3, P4, P5, P6)
{
	d saveSubjectsDetails^%bi.SWrt.WebSMSubject(P0,P1,P2,P3,P4,P5,P6)
}

ClassMethod deleteSubjectDetails(id)
{
	d deleteSubjectDetails^%bi.SWrt.WebSMSubject(id)
}

ClassMethod getSubjectDetails(gid)
{
	d getSubjectDetails^%bi.SWrt.WebSMSubject(gid)
}

ClassMethod loadSchemaList(className)
{
	d loadSchemaList^%bi.SWr.WebSchemaMain(className)
}

ClassMethod DeleteDDSession(FileName, val)
{
	d DeleteDDSession^%bi.SWrt.WebSMSubject(FileName,val)
}

ClassMethod saveDLRoleAccess(DLid, str)
{
	d saveDLRoleAccess^%bi.SWrt.WebSMDetailListing(DLid,str)
}

ClassMethod saveDetailListing(id, PClassName, DLName, DashBoard, objHeight, objwidth, RecPerPage, rowHeight, DetBar, MrgYN, MrgFrm, MrgTo, AlwMult)
{
	q $$saveDetailListing^%bi.SWrt.WebSMDetailListing(id,PClassName,DLName,DashBoard,objHeight,objwidth,RecPerPage,rowHeight,DetBar,MrgYN,MrgFrm,MrgTo,AlwMult)
}

ClassMethod saveDataBroswer(id, arr)
{
	d saveDataBroswer^%bi.SWrt.WebSMDetailListing(id,arr)
}

ClassMethod saveGridLayout(id, arr)
{

	d saveGridLayout^%bi.SWrt.WebSMDetailListing(id,arr)
}

ClassMethod deleteGridLayout(id)
{

	d deleteGridLayout^%bi.SWrt.WebSMDetailListing(id)
}

ClassMethod loadDetailListingSetup(className)
{

	d loadDetailListingSetup^%bi.SWrt.WebSMDetailListing(className)
}

/// /////////////////////////////////////
ClassMethod loadClassDim(fir, st)
{
	
	d loadClassDim^%bi.SWrt.WebSMDimension(fir,st)
}

ClassMethod loadDependencySelect(class)
{
	q $$loadDependencySelect^%bi.SWrt.WebSMDependency(class)
}

ClassMethod saveSyn(class, val)
{
	
	d saveSyn^%bi.SWrt.WebSMDependency(class,val)
}

ClassMethod saveTime(class, val)
{
	d saveTime^%bi.SWrt.WebSMDependency(class,val)
}

ClassMethod saveDimension2(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, srttyp)
{
	
	q $$saveDimension2^%bi.SWrt.WebSMDimension(P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,srttyp)
}

ClassMethod loadToDimDetail(id)
{
	
	d loadToDimDetail^%bi.SWrt.WebSMDimension(id)
}

ClassMethod loadSelectDataType(class)
{
	q $$loadSelectDataType^%bi.SWrt.WebSMSubject(class)
}

ClassMethod loadSelectTransformationType(class)
{
	q $$loadSelectTransformationType^%bi.SWrt.WebSMSubject(class)
}

ClassMethod deleteAllSubjectArea(P0)
{
	d deleteAllSubjectArea^%bi.SWr.WebSchemaMain(P0)
}

ClassMethod deleteAllSubjectArea2(P0)
{
	d deleteAllSubjectArea2^%bi.SWr.WebSchemaMain(P0)
}

ClassMethod genDeltaDependent(P0)
{
	d genDeltaDependent^%bi.SWr.WebSchemaMain(P0)
}

ClassMethod compileSubjectArea(P0)
{
	
	d compileSubjectArea^%bi.SWr.WebSchemaMain(P0)
}

ClassMethod getStatus()
{
	
	d getStatus^%bi.SWr.WebSchemaMain
}

ClassMethod getStatusByClass(Class)
{
	d getStatusByClass^%bi.SWr.WebSchemaMain(Class)
}

ClassMethod proccessSubjectArea(P0)
{
	d proccessSubjectArea^%bi.SWr.WebSchemaMain(P0)
}

ClassMethod procSelSubjectArea(P0)
{
	d procSelSubjectArea^%bi.SWr.WebSchemaMain(P0)
}

ClassMethod SelectiveCompBuild(P0)
{
	d compileSubjectArea^%bi.SWr.WebSchemaMain(P0)
	d procSelSubjectArea^%bi.SWr.WebSchemaMain(P0)
	w "alert('Select processing completed');"
}

// loadHelpDrillDown(div,class)

ClassMethod loadHelpDrillDown(class, type)
{
	d loadHelpDrillDown^%bi.SWrt.WebSMHelpDoc(class,type)
}

ClassMethod saveHelpDoc(id, DocType, DocName, ClassName, DocId, Ico, IcoId)
{
	d saveHelpDoc^%bi.SWrt.WebSMHelpDoc(id,DocType,DocName,ClassName,DocId,Ico,IcoId)
}

ClassMethod selectHelpDoc(id)
{
	d selectHelpDoc^%bi.SWrt.WebSMHelpDoc(id)
}

ClassMethod deleteHelpDoc(id, ClassName)
{
	d deleteHelpDoc^%bi.SWrt.WebSMHelpDoc(id,ClassName)
}

ClassMethod JsCallAddNode(BaseClass, Treeid, className, pnode, bclass, preclass)
{
	q $$JsCallAddNode^%bi.SWrt.WebSMTreeEx(BaseClass,Treeid,className,pnode,bclass, preclass)
}

ClassMethod addJSCookTreeClass(Treeid, div, className, ini)
{
	//q $$addJSCookTreeClass^%bi.SWrt.WebSMTreeEx2(Treeid,div,className,ini)
	d addJSCookTreeClass^%bi.SWrt.WebSMTreeEx2(Treeid,div,className,ini)
}

ClassMethod getDL(className)
{
	q $$getDL^%bi.SWr.WebSchemaMain(className)
}

ClassMethod getLinkField(fieldClass, BaseClass)
{
	q $$getLinkField^%bi.SWr.WebSchemaMain(fieldClass,BaseClass)
}

// getDL(className)

// loadHelpDrillDown

ClassMethod loadDiaLogSelectDim(schemaId, val)
{
	
	d loadDiaLogSelectDim^%bi.SWrt.WebSMSubject(schemaId,val)
}

ClassMethod readStatusfile2Div(cls, div)
{

	d readStatusfile2Div^%bi.SWrt.WebStatus(cls,div)
}

ClassMethod ShowLF(id)
{

	d ShowLF^%bi.SWrt.WebSMListingFields(id)
}

// add in on 28/3/05

ClassMethod JsCallAddNodeTreeLeaf(BaseClass, Treeid, className, pnode, bclass, preclass, iSql, lSO)
{
	d JsCallAddNodeTreeLeaf^%bi.SWrt.WebSMTreeEx(BaseClass,Treeid,className,pnode,bclass, preclass, $G(iSql), $G(lSO))
}

// add on 22/4/05

ClassMethod loadBAMSelect()
{
	
	q $$loadBAMSelect^%bi.SWrt.WebBAM()
}

ClassMethod loadBAMTable(class)
{
	
	d loadBAMTable^%bi.SWrt.WebBAM(class)
}

ClassMethod saveBAM(class, str)
{
	
	d saveBAMlist^%bi.SWrt.WebBAM(class,str)
}

ClassMethod loadHelpDocAll(className, Lang)
{
	d loadHelpDocAll^%bi.SWrt.WebSMHelpDoc(className,Lang)
}

// new add in on 13may2005

ClassMethod loadAvaFieldsFromDim(className)
{

	d loadAvaFieldsFromDim^%bi.SWrt.WebSMDetailListing(className)
}

ClassMethod clearDimDetail()
{
	d clearDimDetail^%bi.SWrt.WebSMDimension()
}

ClassMethod SetSes(daid)
{
	//1 for normal bts tree
	//0 is for the dialog tree
	
	s %session.Data("TheTreeID")=daid
}

ClassMethod SchClass(schemacls As %String)
{
	s %session.Data("SchemaCls")=schemacls
	s P0=schemacls,P1=""
	s Val=$$CntMatch^%bi.SMr.MinerUtils1(P0,$G(P1),"")
	s %session.Data("TotalRecBTS")=Val
}

ClassMethod reVertSpace(str)
{
	s NStr=$TR(str,"|"," ")
	w "Nsrt="_NStr_";"
}

ClassMethod getPrevNCurrDim(num, className)
{
	d getPrevNCurrDim^%bi.SWrt.WebSMDimension(num,className)
}

ClassMethod LoadAddSel(typ)
{
	d LoadAddSel^%bi.SWrt.WebSMListingFields(typ)
}

ClassMethod LoadDocSel(tc)
{
	d LoadDocSel^%bi.SWrt.WebSMHelpDoc(tc)
}

ClassMethod NewCompoundMemLoad(vs)
{
	d NewCompoundMemLoad^%bi.SWrt.WebSMCompMem(vs)
}

ClassMethod RetDimDatTyp(id)
{
	d RetDimDatTyp^%bi.SWrt.WebSMDetailListing(id)
}

ClassMethod SetKPIClassSes(mcls)
{
	d SetKPIClassSes^%bi.SWrt.WebSMHelpDoc(mcls)
}

ClassMethod GetIcoName(id)
{
	d GetIcoName^%bi.SWrt.WebSMHelpDoc(id)
}

ClassMethod DSavePopUp(did, Con)
{
	d DSavePopUp^%bi.SWrt.WebSMDetailListing(did,Con)
}

ClassMethod LdCompileStat(div)
{
	s CompClsSta=%session.Get("CompileStatCls")
	if (CompClsSta'="")
	{
		d LstatCompile^%bi.SWrt.WebSchemaSubjects(CompClsSta,div)
	}
}

ClassMethod DirectSaveSelectBuild(stat, mid)
{
	d DirectSaveSelectBuild^%bi.SWrt.WebSMDimension(stat,mid)
}

ClassMethod DoMarkClass(cls)
{
	d MarkOLAP^%bi.SMr.ETL3(cls,1)
}

ClassMethod saveDynDim(cls, scr)
{
	d saveDynDim^%bi.SWrt.WebSMDeltaLoad(cls,scr)
}

ClassMethod loadDynDim(cls)
{
	q $$loadDynDim^%bi.SWrt.WebSMDeltaLoad(cls)
}

ClassMethod DetListInitRoles()
{
	d loadDetListingInitRoles^%bi.SWr.WebSchemaMain()
}

ClassMethod OpenTrace(objType, objID)
{
	d open^%bi.SWr.Trace(objType,objID,$p(%session.Get("currUserID"),$C(6),1))
}

ClassMethod SaveTrace()
{
	d save^%bi.SWr.Trace(%session.Get("SchemaCls"),%session.Get("SchemaCls"),$p(%session.Get("currUserID"),$C(6),1))
}

ClassMethod CheckSubjectName(subjectName, schemaClass)
{
	//kev may 08
	q $$checkSubjectName^%bi.SWr.WebSchemaMain(subjectName,schemaClass)
}

ClassMethod CheckDetListName(listName, schemaClass)
{
	//kev may 08
	q $$CheckDetListName^%bi.SWr.WebSchemaMain(listName,schemaClass)
}

ClassMethod CheckClassExists(checkClass, checkOrGet)
{
	//kev june 08
	q $$checkClassExists^%bi.SWr.ImportList(checkClass,checkOrGet)
}

ClassMethod getNewSchemaObjID()
{
	//kev may 08
	q $$getNewSchemaObjID^%bi.SWr.WebSchemaMain()
}

ClassMethod DoScrollSearch(schemaClass, dimobj, dimid)
{
	d DoScrollSearch^%bi.SWr.WebSchemaMain(schemaClass,dimobj,dimid)
}

ClassMethod LoadDocTab()
{
	d LoadDocTab^%bi.SWrt.WebSMHelpDoc()
}

ClassMethod CheckBTSRoleAcc(str)
{
	s ttt= $$BTSModuleCK^%bi.SWr.WebSchemaMain(str)
	w "rtn="_ttt_";"
}

}
