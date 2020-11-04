ROUTINE %occOID [Type=INC]
#; define OID maccros
  
#;
#define oidPrimary(%oid)			$listget(%oid)
#define oidClassName(%oid)		$listget(%oid,2)
#define oidSysAd1(%oid)			$listget(%oid,3)
#define idCurrent					$listget(i%"%%OID")
 
#define oidCompose(%primary,%class)     $select(%primary="":"",1:$listbuild(%primary_"",%class))
#define oidComposeAd1(%primary,%class,%ad1) $select(%primary="":"",1:$listbuild(%primary_"",%class,%ad1))
 
#define oidForm(%primary)               $select(%primary="":"",1:$listbuild(%primary_""))
 
#define oidInsertClassName(%oid,%class) $select(%oid="":"",1:$listbuild($listget(%oid),%class)_$select($listget(%oid,3)'="":$listbuild($list(%oid,3)),1:""))
#define oidInsertAd1(%oid,%ad1)         $select(%oid="":"",1:$listbuild($listget(%oid),$listget(%oid,2),%ad1))
 
#define oidRemoveClassName(%oid)        $select(%oid="":"",1:$listbuild($listget(%oid))_$select($listget(%oid,3)'="":$listbuild(,$list(%oid,3)),1:""))
#define oidRemoveAd1(%oid)				$list(%oid,1,2)
#;
#define QoidForm(%primary)              "$select("_%primary_"="""":"""",1:$listbuild("_%primary_"_""""))"
#;
  