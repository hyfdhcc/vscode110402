Include %DeepSee

/// Projection class used by the <class>%DeepSee.Report.reportPage</class> class.
/// This class takes care of any work that needs to happen when
/// a DeepSee report is created (compiled) or deleted.
/// This means maintaining the index of logic report names to class names.
/// This class should be consider INTERNAL.
Class %DeepSee.Report.ReportProjection Extends %Projection.AbstractProjection [ System = 3 ]
{

ClassMethod CreateProjection(pClassName As %String, ByRef parameters As %String) As %Status
{
 	Set $ZT="Trap",tSC=$$$OK
	Do {
		If ($$$comClassDefined(pClassName)) {
			Set tAbstract = +$$$comClassKeyGet(pClassName,$$$cCLASSabstract)
			If ('tAbstract && (pClassName'="%DeepSee.Report.reportPage")) {

				Set tReportName = $zobjclassmethod(pClassName,"%GetReportName")
				Set tReportNameU = $ZCVT(tReportName,"U")

				#; Add this cube to the (local) index of reports
				If (tReportNameU '= "") {
					Set tRegClass = $G(^DeepSee.Reports("reports",tReportNameU))
					If (tRegClass = "") {
						Set ^DeepSee.Reports("reports",tReportNameU) = pClassName
						Set ^DeepSee.Reports("classes",pClassName) = tReportName
					}
				}
			}
		}
	} While (0)
Exit
	Quit tSC
Trap
 	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

ClassMethod RemoveProjection(pClassName As %String, ByRef parameters As %String, recompile As %Boolean) As %Status
{
 	Set $ZT="Trap",tSC=$$$OK
	Do {
		If ($$$comClassDefined(pClassName)) {
			Set tAbstract = +$$$comClassKeyGet(pClassName,$$$cCLASSabstract)
			If ('tAbstract && (pClassName'="%DeepSee.Report.reportPage")) {

				#; Remove this report from the list of Reports
				Set tReportName = $G(^DeepSee.Reports("classes",pClassName))
				Set tReportNameU = $ZCVT(tReportName,"U")

				#; make sure we are the right report
				If ((tReportNameU'="")&&(pClassName = $G(^DeepSee.Reports("reports",tReportNameU)))) {
					Kill ^DeepSee.Reports("classes",pClassName)
					Kill:tReportName'="" ^DeepSee.Reports("reports",tReportNameU)
				}
			}
		}
	} While(0)
Exit
  	Quit tSC
Trap
 	Set $ZT="",tSC=$$$ERROR($$$CacheError,$ZE)
	Goto Exit
}

}
