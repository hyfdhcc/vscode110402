Include %DeepSee

/// Projection class used by the <class>%DeepSee.SubjectArea</class> class.
/// This class takes care of any work that needs to happen when
/// a subject area is created (compiled) or deleted.
/// This class should be consider INTERNAL.
Class %DeepSee.SubjectAreaProjection Extends %Projection.AbstractProjection [ System = 3 ]
{

ClassMethod CreateProjection(pClassName As %String, ByRef parameters As %String) As %Status
{
 	Set tSC=$$$OK
	Try {
		If ($$$comClassDefined(pClassName)) {
			Set tAbstract = +$$$comClassKeyGet(pClassName,$$$cCLASSabstract)
			If ('tAbstract && (pClassName'="%DeepSee.SubjectArea")) {
				Set tCubeName = $zobjclassmethod(pClassName,"%GetCubeName")
				Set tCubeNameU = $ZCVT(tCubeName,"U")

				#; Add this cube to the (local) index of Cubes
				If (tCubeNameU '= "") {
					Set $$$DeepSeeMetaGLVN("cubes",tCubeNameU) = pClassName
					Set $$$DeepSeeMetaGLVN("classes",pClassName) = tCubeName
				}
			}
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

ClassMethod RemoveProjection(pClassName As %String, ByRef parameters As %String, recompile As %Boolean) As %Status
{
 	Set tSC=$$$OK
	Try {
		If ($$$comClassDefined(pClassName)) {
			Set tAbstract = +$$$comClassKeyGet(pClassName,$$$cCLASSabstract)
			If ('tAbstract && (pClassName'="%DeepSee.SubjectArea")) {
				#; Remove this subject area from the list of Cubes
				Set tCubeName = $G($$$DeepSeeMetaGLVN("classes",pClassName))
				Set tCubeNameU = $ZCVT(tCubeName,"U")

				#; make sure we are the right subject area
				If ((tCubeNameU'="")&&(pClassName = $G($$$DeepSeeMetaGLVN("cubes",tCubeNameU)))) {
					Kill $$$DeepSeeMetaGLVN("classes",pClassName)
					Kill:tCubeName'="" $$$DeepSeeMetaGLVN("cubes",tCubeNameU)
				}
			}
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
