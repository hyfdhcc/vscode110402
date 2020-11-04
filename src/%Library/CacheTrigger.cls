/// Trigger member superclass, for internal use only
Class %Library.CacheTrigger [ NoContext, System = 1 ]
{

ClassMethod Execute(%oper As %Integer = 0, ByRef pNew, ByRef pOld, ByRef pChanged, ByRef %ok, ByRef %msg) [ CodeMode = generator, ProcedureBlock = 0 ]
{
	set %code=0
		// don't generate any code if it not for a trigger
	if %mode="method" quit $$$OK
	set tClassType = $$$getClassType(%class)
		// If this class is not currently persistent and not noextent then we are done
	QUIT:'((tClassType=$$$cCLASSCLASSTYPEPERSISTENT)&&('$$$comClassKeyGet(%class,$$$cCLASSnoextent))) $$$OK
 	$$$comMemberKeyGetLvar(tLanguage,%class,$$$cCLASStrigger,%pqname,$$$cTRIGGERlanguage)
 	if tLanguage '= "" {
	 	set %language = tLanguage
	 	if tLanguage = $$$cMETHLANGUAGETSQL {
		 		// need to set PROCEDUREBLOCK to 1 (true)
			$$$comSubMemberKeySet(%class,$$$cCLASStrigger,%pqname,$$$cCLASSmethod,%method,$$$cMETHprocedureblock,1)
	 	}
 	}
	$$$tMetadataUses("PrecompileTriggerCode^%occTrigger(%class)")
	merge %code = $$$tMetadata("c",%pqname)
	quit $$$OK
}

}
