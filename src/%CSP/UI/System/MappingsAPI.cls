Include (%systemInclude, %sqlui, %syConfig)

/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>Defines the main API for working with global/routine/package mappings.
/// This class is used internally by Cache system management utilities and is
/// not meant to be used by application developers.<br>
/// The "modified" mappings will only be Activiated
/// when user is ready and clicked the "Save Changes" button. 
Class %CSP.UI.System.MappingsAPI [ Abstract, System = 4 ]
{

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// Are there changes in the change list?
ClassMethod HasChanges(Namespace As %String, pType As %String) As %Boolean
{
 s tSC=##Class(Config.CPF).FileToName(,,,.CPFMapName)
 q ($D($$$CONFIG3(CPFMapName,$case(pType,"Gbl":"MapGlobals","Rtn":"MapRoutines","Prj":"MapPackages"),Namespace))'=10)
}

/// Remove all items in the change list for this namespace
ClassMethod ClearChangeList(Namespace As %String, pType As %String) As %Status
{
	i '..HasChanges(Namespace,pType) q $$$OK
	s tSC=##Class(Config.CPF).FileToName(.CPFFile,.CPFName,.CPFMapFile,.CPFMapName)
	s Index=$case(pType,"Gbl":"MapGlobals","Rtn":"MapRoutines","Prj":"MapPackages")
	tstart
	k $$$CONFIG3(CPFMapName,Index,Namespace)
	m $$$CONFIG3(CPFMapName,Index,Namespace)=$$$CONFIG3(CPFName,Index,Namespace)
	tcommit
	Quit $$$OK
}

/// Save items in the Change List
ClassMethod SaveChangeList(Namespace As %String, MapType As %String) As %Status
{
	s $zt="Error"
	i '..HasChanges(Namespace,MapType) q $$$OK
	s tSC=##Class(Config.CPF).FileToName(.CPFFile,.CPFName,.CPFMapFile,.CPFMapName)
	s Index=$case(MapType,"Gbl":"MapGlobals","Rtn":"MapRoutines","Prj":"MapPackages")
	tstart
	k $$$CONFIG3(CPFName,Index,Namespace)
#;Kill off changes flag before we copy
	zk $$$CONFIG3(CPFMapName,Index,Namespace)
	m $$$CONFIG3(CPFName,Index,Namespace)=$$$CONFIG3(CPFMapName,Index,Namespace)
	tcommit

	s tSC=##Class(Config.CPF).Write()
	i '$$$ISOK(tSC) q tSC
	s tSC=$classmethod("Config."_Index,"MoveToActive",Namespace)
	i '$$$ISOK(tSC) q tSC
#;SML1081 ; pass namespace if needed.
	s tSC=##Class(Config.Namespaces).Load(Namespace)

	q tSC
Error s $zt=""
  trollback 1
  q $$$ERROR($$$CacheError,$ze)
}

}
