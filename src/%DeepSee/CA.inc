ROUTINE %DeepSee.CA [Type=INC]
#; %DeepSee.CA.inc
#; Include file for %DeepSee Cluster Analisys


#; #Define Data			^||DeepSee.CA.Data
#; #Define Cluster		^||DeepSee.CA.Cluster
#; #Define CostGLVN		^||DeepSee.CA.Cost

#; #Define DataGLVN		^ISC.DeepSee.CA.Data
#; #Define ClusterGLVN	^ISC.DeepSee.CA.Cluster
#; #Define CostGLVN		^ISC.DeepSee.CA.Cost

#Define DataGLVN			^CacheTemp.DS.CA.Data
#Define ClusterGLVN			^CacheTemp.DS.CA.Cluster
#Define CostGLVN			^CacheTemp.DS.CA.Cost

#Define ChartGLVN			^||DeepSee.CA.ChartData
#Define LinkageGLVN			^||DeepSee.CA.Linkage
#Define ChartData(%s,%n,%x)	$$$ChartGLVN(%s,%n,%x)

#Define DSData				$$$DataGLVN
#Define GData(%ds,%i,%j)	$$$DataGLVN(%ds,%i,%j)
#Define DSCluster			$$$ClusterGLVN
#Define DSCostMatrix		$$$CostGLVN
#Define GCluster(%ds,%i,%j)	$$$ClusterGLVN(%ds,%i,%j)

#Define MyData				$$$DSData(..DSName)
#Define Data(%i,%j)			$$$GData(..DSName,%i,%j)
#Define MyCluster			$$$DSCluster(..DSName)
#Define Cluster(%i,%j)		$$$GCluster(..DSName,%i,%j)
#Define CostMatrix			$$$CostGLVN(..DSName)

#Define Count   			$$$MyData
#Define Dim					$$$DSData(..DSName,"dim")
#Define DimName(%j)			$$$DSData(..DSName,"dim",%j)
#Define NClstrs				$$$DSData(..DSName,"NClusters")
#Define ClusterSize(%k)		$$$DSCluster(..DSName,%k)
#Define Var(%i)				$$$DSData(..DSName,"var",%i)
#Define Medoid(%k)			$$$DSCluster(..DSName,"pam",%k,0)

#Define Cost(%i,%j)			$$$CostGLVN(..DSName,$s(%i>%j:%i,1:%j),$s(%i>%j:%j,1:%i))
#; #Define GetCost(%i,%j)		$$$Cost(%i,%j)
#Define GetCost(%i,%j)		$s($d($$$Cost(%i,%j))=1:$$$Cost(%i,%j),1:..dist(%i,%j))
#Define GetCluster(%i)		$$$DSData(..DSName,%i,0,0)	
#Define GetId(%i)			$$$DSData(..DSName,%i,0,1)	
#Define ById(%id)			$$$DSData(..DSName,"id",%id)	

#define edist(%i,%j)		##class(%DeepSee.extensions.clusters.AbstractCA).Distance(%i,%j,2)
#define mdist(%i,%j)		##class(%DeepSee.extensions.clusters.AbstractCA).Distance(%i,%j,1)
#define zdist(%i,%j)		##class(%DeepSee.extensions.clusters.AbstractCA).Distance(%i,%j,0)

#define RPMAX				1000001
#define randomp				$r($$$RPMAX)/($$$RPMAX-1)

#Define SubsetGLVN			^||DeepSee.CA.Subset
#define Subset(%key,%i)		$$$SubsetGLVN(%key,%i)
#define SubsetNext(%key,%i)	$o($$$SubsetGLVN(%key,%i))
#define KillSubset(%key)	k $$$SubsetGLVN(%key)
#define SubsetCount(%key)	$$$SubsetGLVN(%key,0,"count")

#; Linkage-Based Clustering
#define LHierDist(%i,%j)	$$$LinkageGLVN(2,$s(%i>%j:%i,1:%j),$s(%i>%j:%j,1:%i))
#define LSetOrder(%d,%i,%j)	set $$$LinkageGLVN(20,%d,$s(%i>%j:%i,1:%j),$s(%i>%j:%j,1:%i)) = ""
#define LGetOrder(%d,%i,%j)	set %i=$o($$$LinkageGLVN(20,%d,"")) set %j = $o($$$LinkageGLVN(20,%d,%i,""))
#define LNextOrder(%d)		$o($$$LinkageGLVN(20,%d))
#define LKillOrder(%i,%j)	set %d=$$$LHierDist(%i,%j) kill $$$LinkageGLVN(20,%d,$s(%i>%j:%i,1:%j),$s(%i>%j:%j,1:%i))
#define LState(%i)			$$$LinkageGLVN(2,%i)

#; !-Dimensional Clustering and optimizer
#define OrderedGLVN			^||DeepSee.CA.Ordered
#define GOX(%key,%i)		$$$OrderedGLVN(%key,1,%i)
#define OX(%key,%i)			$s(%key="":key(%i),1:$$$GOX(%key,%i))
#define SetOX(%key,%i,%v)	if (%key="") {set %key(%i)=%v} else {set $$$GOX(%key,%i)=%v}
#define GOS(%key,%i,%j)		$$$OrderedGLVN(%key,2,%i,%j)
#define OS(%key,%i,%j)		$s(%key="":s(%i,%j),1:$$$GOS(%key,%i,%j))
#define SetOS(%key,%i,%j,%v) if (%key="") {set s(%i,%j)=%v} else {set $$$GOS(%key,%i,%j)=%v}
#define GOR(%key,%i,%j)		$$$OrderedGLVN(%key,3,%i,%j)
#define OR(%key,%i,%j)		$s(%key="":r(%i,%j),1:$$$GOR(%key,%i,%j))
#define SetOR(%key,%i,%j,%v) if (%key="") {set r(%i,%j)=%v} else {set $$$GOR(%key,%i,%j)=%v}
