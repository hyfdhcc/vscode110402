Class %BI.EchoClsRoutine [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod SaveP1a(RefDI, CVT, Rhythm, BP, Height, Weight, BSA, LftVenDet, RghtVenDet)
{
	s RefDI=$g(%session.Data("EXCO"))
	d SaveP1a^%bi.SWr.EchoRoutine(RefDI,CVT,Rhythm,BP,Height,Weight,BSA,LftVenDet,RghtVenDet)
}

ClassMethod SaveP1b(RefDI, LftVenComt, LVMassIdxComt, LVMassComt, RigVenComt, RIMPComt, DpdtComt)
{
	s RefDI=$g(%session.Data("EXCO"))
	d SaveP1b^%bi.SWr.EchoRoutine(RefDI,LftVenComt,LVMassIdxComt,LVMassComt,RigVenComt,RIMPComt,DpdtComt)
}

ClassMethod SaveP2a(RefDI, Pericardium, PericardiumB, Artial, ArtialB, Ventricul, VentriculB, AOroot, AOrootB, AOPA, AOPAB, Mitral, MitralB, Aortic, AorticB, Tricuspid, TricuspidB, Pulmonary, PulmonaryB)
{
	s RefDI=$g(%session.Data("EXCO"))
	d SaveP2a^%bi.SWr.EchoRoutine(RefDI,Pericardium,PericardiumB,Artial,ArtialB,Ventricul,VentriculB,AOroot,AOrootB,AOPA,AOPAB,Mitral,MitralB,Aortic,AorticB,Tricuspid,TricuspidB,Pulmonary,PulmonaryB)
}

ClassMethod SaveP2b(RefDI, DiastolicDet)
{
	s RefDI=$g(%session.Data("EXCO"))
	d SaveP2b^%bi.SWr.EchoRoutine(RefDI,DiastolicDet)
}

ClassMethod SaveP2c(RefDI, ComtP2CombiA)
{
	s RefDI=$g(%session.Data("EXCO"))
	d SaveP2c^%bi.SWr.EchoRoutine(RefDI,ComtP2CombiA)
}

ClassMethod SaveP2d(RefDI, ComtP2CombiB)
{
	s RefDI=$g(%session.Data("EXCO"))
	d SaveP2d^%bi.SWr.EchoRoutine(RefDI,ComtP2CombiB)
}

ClassMethod SaveP2e(RefDI, ComtP2CombiC)
{
	s RefDI=$g(%session.Data("EXCO"))
	d SaveP2e^%bi.SWr.EchoRoutine(RefDI,ComtP2CombiC)
}

ClassMethod SaveP3a(RefDI, LRAtrium, Chamber, TricuspidVIn, SupVenaC)
{
	s RefDI=$g(%session.Data("EXCO"))
	d SaveP3a^%bi.SWr.EchoRoutine(RefDI,LRAtrium,Chamber,TricuspidVIn,SupVenaC)
}

ClassMethod SaveP3b(RefDI, ProstheticMitDet, ProstheticAorDet)
{
	s RefDI=$g(%session.Data("EXCO"))
	d SaveP3b^%bi.SWr.EchoRoutine(RefDI,ProstheticMitDet,ProstheticAorDet)
}

ClassMethod SaveP3c(RefDI, Tape, ComtEchoDiag, ComtEchoNotes, RoomN, IVCV)
{
	s RefDI=$g(%session.Data("EXCO"))
	d SaveP3c^%bi.SWr.EchoRoutine(RefDI,Tape,ComtEchoDiag,ComtEchoNotes,RoomN,IVCV)
}

ClassMethod MIT(MitC, MitT, MitS, MitM, MitTW)
{
	s RefDI=$g(%session.Data("EXCO"))
	d MIT^%bi.SWr.EchoRoutine(RefDI,MitC,MitT,MitS,MitM,MitTW)
}

ClassMethod HVF(HVFSV, HVFDV, HVFARV)
{
	s RefDI=$g(%session.Data("EXCO"))
	d HVF^%bi.SWr.EchoRoutine(RefDI,HVFSV,HVFDV,HVFARV)
}

ClassMethod XtrInfo(Indi, Doct, Machi, ESV3, EDV3, EF3, LVSysFx, RVHYN)
{
	s RefDI=$g(%session.Data("EXCO"))
	d XtrInfo^%bi.SWr.EchoRoutine(RefDI,Indi,Doct,Machi,ESV3,EDV3,EF3,LVSysFx,RVHYN)
}

ClassMethod SaveColc(RefDI, clr, cs)
{
	s RefDI=$g(%session.Data("EXCO"))
	d SaveColc^%bi.SWr.EchoRoutine(RefDI,clr)
	
	d SaveAllToClass^%bi.SWr.EchoRoutine(RefDI,cs)
}

ClassMethod SaveAllToClass(RefDI)
{
	d SaveAllToClass^%bi.SWr.EchoRoutine(RefDI)
}

ClassMethod LoadAllDat(RefDI, ch)
{
	//note this session is to let the print echo function 
	//to know which echoid to use.
	s %session.Data("EchoCh")=ch
	d LoadAllDat^%bi.SWr.EchoRoutine(RefDI,ch)
}

ClassMethod FirstTime(idd)
{
	d FirstTime^%bi.SWr.EchoRoutine(idd)
}

ClassMethod ViewSVG()
{
	//s EcID=%session.Get("EchoRID")
	s EcID=%session.Get("EXCO")
	d ViewSVG^%bi.SWr.EchoRoutine(EcID)
}

ClassMethod EchoPrint(cch)
{
	d EchoPrint^%bi.SWr.EchoRoutine(cch)
}

ClassMethod DoEchoLock(ref)
{
	d DoEchoLock^%bi.SWr.EchoRoutine(ref)
}

ClassMethod UnDoEchoLock(ref)
{
	k ^EchoGlobe(ref)
}

ClassMethod DCancelClean(vv)
{
	d DCancelClean^%bi.SWr.EchoRoutine(vv)
}

ClassMethod Strain(sg, EndSysStrain, PeakStrain, PosySysStrain, TeStrain, TimePeakStrain, Ech)
{
	s EcID=%session.Get("EXCO")
	d Strain^%bi.SWr.EchoRoutine(Ech,sg,EcID,EndSysStrain,PeakStrain,PosySysStrain,TeStrain,TimePeakStrain)
}

ClassMethod StrainRate(sg, PeakSysSR, TimeSysSR, PeakSRE, TimePeakSRE, PeakSRA, TimePeakSRA, Ech)
{
	s EcID=%session.Get("EXCO")
	d StrainRate^%bi.SWr.EchoRoutine(Ech,sg,EcID,PeakSysSR,TimeSysSR,PeakSRE,TimePeakSRE,PeakSRA,TimePeakSRA)
}

ClassMethod TDI(sg, TDIPeakS, TDIQRSS, TDIPeakE, TDIQRSE, TDIPeakA, TDIQRSA, QRSLVOT, QRSRVOT, IntMechDel, Ech)
{
	s EcID=%session.Get("EXCO")
	d TDI^%bi.SWr.EchoRoutine(Ech,sg,EcID,TDIPeakS,TDIQRSS,TDIPeakE,TDIQRSE,TDIPeakA,TDIQRSA,QRSLVOT,QRSRVOT,IntMechDel)
}

ClassMethod SegRemarks(sg, StRemark, Ech)
{
	s EcID=%session.Get("EXCO")
	d SegRemarks^%bi.SWr.EchoRoutine(Ech,sg,EcID,StRemark)
}

ClassMethod DelSegment(sg, cch)
{
	s EcID=%session.Get("EXCO")
	d DelSegment^%bi.SWr.EchoRoutine(EcID,sg,cch)
}

ClassMethod DLoadSelectSeg(sg, cch)
{
	s EcID=%session.Get("EXCO")
	d DLoadSelectSeg^%bi.SWr.EchoRoutine(EcID,sg,cch)
}

}
