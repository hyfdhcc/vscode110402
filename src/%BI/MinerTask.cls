Include (%occInclude, %occReference2)

Class %BI.MinerTask [ Abstract, ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter CacheVersion = 5.0;

ClassMethod BuildAll() [ ProcedureBlock = 0 ]
{
 set classes=##class(%ResultSet).%New("%CompiledClass:ClassInfo")
 set ok=classes.Execute("&")
 for  quit:'classes.Next()  set Class=classes.Get("Name") do
 . if '$$$METHrunnable($$$MGINFO,Class,"HiRebuild") quit
 . if Class?1"%BI.".e quit
 . s sc=$zobjclassmethod(Class,"HiRebuild",0) 
 do classes.Close()
}

}
