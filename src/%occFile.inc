ROUTINE %occFile [Type=INC]
#define FileExists(%file)	($zu(140,4,%file)=0)
#define FileExistsRet(%file) $zu(140,4,%file)
#define FileReadOnly(%file)	($zu(140,12,%file,2)'=0)
#define FileWritable(%file)	($zu(140,12,%file,2)=0)
#define FileCreateDirectory(%file)	('$zu(140,9,%file))
#define FileCreateDirectoryRet(%file) $zu(140,9,%file)
#define FileCreateDirectoryChain(%file)	 ('$zu(140,9,%file,1))
#define FileCreateDirectoryChainRet(%file) $zu(140,9,%file,1)
#define FileDirectoryExists(%file)	($zu(12,%file,2)'="")
#define FileNormalizeFilename(%file)	$zu(12,%file,0,1)
#define FileNormalizeDirectory(%file)	$zu(12,%file,1,1)
#define FileDelete(%file)	('$zu(140,5,$select($$$isVMS&&(%file'[";"):%file_";*",1:%file)))
#define FileDeleteRet(%file)	$zu(140,5,$select($$$isVMS&&(%file'[";"):%file_";*",1:%file))
#define FileRemoveDirectory(%file)	('$zu(140,10,%file))
#define FileRemoveDirectoryRet(%file)	$zu(140,10,%file)
#define FileRename(%old,%new)	('$zu(140,6,%old,%new))
#define FileRenameRet(%old,%new)	$zu(140,6,%old,%new)
#define FileCopy(%from,%to)	('$zu(140,11,%from,%to))
#define FileCopyRet(%from,%to)	$zu(140,11,%from,%to)
#define FileCurrentDir	$zu(168)
#define FileSetCurrentDir(%dir)	$zu(168,%dir)
#define FileMgrDir	$zu(12)
#define FileSize(%file)	$zu(140,1,%file)
#def1arg FileDateCreated(%arg)	$zu(140,3,%arg)
#def1arg FileDateModified(%arg)	$zu(140,2,%arg)
#define FileAttributes(%file)	$zu(140,7,%file)
#define FileSetAttributes(%file,%attr)	($zu(140,8,%file,%attr)=1)
#define FileSetAttributesRet(%file,%attr)	$zu(140,8,%file,%attr)
#define FileVMSRecordFormat(%file)	$zu(140,7,%file,1)
#define	FileSetGroupName(%file,%group)	$zu(140,15,%file,%group)