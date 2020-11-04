Include %DeepSee

/// Projection class used by the <class>%DeepSee.CubeDefinition</class> class.
/// This class takes care of any work that needs to happen when
/// a cube definition is created (compiled) or deleted.
/// This class should be considered INTERNAL.
Class %DeepSee.CubeProjection Extends %Projection.AbstractProjection [ System = 3 ]
{

ClassMethod CreateProjection(pClassName As %String, ByRef parameters As %String) As %Status
{
 	Set tSC=$$$OK
	Try {
		If ($$$comClassDefined(pClassName)) {
			Set tAbstract = +$$$comClassKeyGet(pClassName,$$$cCLASSabstract)
			If ('tAbstract && (pClassName'="%DeepSee.CubeDefinition")) {

				Set tCubeName = $zobjclassmethod(pClassName,"%GetCubeName")
				Set tCubeNameU = $ZCVT(tCubeName,"U")

				#; Add this cube to the (local) index of Cubes
				If (tCubeNameU '= "") {
					Set tRegClass = $G($$$DeepSeeMetaGLVN("cubes",tCubeNameU))
					If (tRegClass = "") {
						Set $$$DeepSeeMetaGLVN("cubes",tCubeNameU) = pClassName
						Set $$$DeepSeeMetaGLVN("classes",pClassName) = tCubeName
					}
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
			If ('tAbstract && (pClassName'="%DeepSee.CubeDefinition")) {

				#; Remove this cube from the list of Cubes
				Set tCubeName = $G($$$DeepSeeMetaGLVN("classes",pClassName))
				Set tCubeNameU = $ZCVT(tCubeName,"U")

				#; make sure we are the right cube
				If ((tCubeNameU'="")&&(pClassName = $G($$$DeepSeeMetaGLVN("cubes",tCubeNameU)))) {
					#; remember current cube name and sync time (for recompile)
					If (recompile) {
						Set ^||%Cls(pClassName,"cube") = tCubeName
						Set tLastTimeStamp = $G($$$DeepSeeMetaGLVN("cubes",tCubeNameU,"dstime"))
						If (tLastTimeStamp'="") {
							Set ^||%Cls(pClassName,"dstime") = tLastTimeStamp
						}

						// remember current meta data
						Kill $$$DeepSeeMetaGLVN("prior",tCubeNameU)
						Merge $$$DeepSeeMetaGLVN("prior",tCubeNameU) = $$$DeepSeeMetaGLVN("cubes",tCubeNameU)
					}

					Kill $$$DeepSeeMetaGLVN("classes",pClassName)
					Kill:tCubeNameU'="" $$$DeepSeeMetaGLVN("cubes",tCubeNameU)

					#; kill cache
					If ('recompile) {
						Set tSC = ##class(%DeepSee.Query.Engine).%CubeRemoved(tCubeName,pClassName)
						Quit:$$$ISERR(tSC)
					}
					
					// BDB267: delete iKnow domains managed by this cube if not recompiling.
					// when recompiling, this will be taken care of by
					// %DeepSee.CubeDefinition.%GetModel()
					if ('recompile) {
						set tMsrPropName = ""
						for {
							set tMsrPropName = $order($$$DeepSeeMetaGLVN("prior", tCubeNameU, "fact", "prop", tMsrPropName))
							quit:tMsrPropName=""
						
							set tMeasure = $g($$$DeepSeeMetaGLVN("prior", tCubeNameU, "fact", "prop", tMsrPropName, "msrname"))
							set tIndexType = $g($$$DeepSeeMetaGLVN("prior", tCubeNameU, "fact", "prop", tMsrPropName, "index"))
							continue:$piece(tIndexType,":",1)'="iKnow"
						
							// skip iKnow-managed domains
							continue:$piece(tIndexType,":",2)="domain"
						
							// derive domain name
							set tDomainName = $piece(tIndexType,":",3)
							set:tDomainName="" tDomainName = ##class(%iKnow.DeepSee.CubeUtils).GetDeepSeeDomainName(tCubeNameU,tMeasure)
						
							set tSC = ##class(%iKnow.DeepSee.CubeUtils).DropDomain(tDomainName)
							quit:$$$ISERR(tSC)
						}
						quit:$$$ISERR(tSC)
					}
					
					// +DTB130 - Clean up the ^DeepSee.Cubes("versionIndex")
					If ##class(%DeepSee.CubeVersion.Utils).%IsVersion(tCubeNameU,.tGenericCubeName,.tVersion) {
						If ('recompile) {
							If (##class(%DeepSee.CubeVersion.Utils).%IsActiveVersion(tCubeNameU)) {
								Kill $$$DeepSeeMetaGLVN("versionIndex","versions",$$$UPPER(tGenericCubeName),"activeVersion")
							}
							If (##class(%DeepSee.CubeVersion.Utils).%IsPendingVersion(tCubeNameU)) {
								Kill $$$DeepSeeMetaGLVN("versionIndex","versions",$$$UPPER(tGenericCubeName),"pendingVersion")
							}
							
							Kill $$$DeepSeeMetaGLVN("versionIndex","versions",$$$UPPER(tGenericCubeName),tVersion)
							Kill $$$DeepSeeMetaGLVN("versionIndex","versionOf",tCubeNameU)
						}
					}
					// -DTB130
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
