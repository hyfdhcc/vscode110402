ROUTINE %syDataMove [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;SML1995 12/23/14 Simon Li, Support DataMove for routines and classes, remove 'Type' property in DataMove.Range class.
#;SML1968 11/04/14 Simon Li, Support %-global for DataMove.
#;STC2253 10/13/13 Steve Clay, Data Move implementation
#endif  /*=====================End Maintenance======================*/
#;/* Revision: $Id: //dev/latest/databases/sys/inc/_syDataMove.inc#31 $ ($Change: 1241349 $) */

#define SYNCJOURNAL d $$$JRNFLUSHBUF /*Force journal to disk*/
#define ADDSTATUS(%Status,%NewStatus) s %Status=$$$ADDSC(%Status,%NewStatus)
#define CRLF $c(13,10)
#define MoveGlobalsVersion "1.0"
#define MoveGlobalsMaxGblSize 37 
#define StorageNode        ^|"%SYS"|SYS
#define StorageSubscript   "DataMove"
#define VersionOff     1
#define MaxGblSizeOff  2
#define GetVersion               $li($$$StorageNode($$$StorageSubscript),$$$VersionOff)
#define SetVersion(%Version)     i '$d($$$StorageNode($$$StorageSubscript)) s $li($$$StorageNode($$$StorageSubscript),$$$VersionOff)=%Version
#define GetMaxGblSize               $li($$$StorageNode($$$StorageSubscript),$$$MaxGblSizeOff)
#define SetMaxGblSize(%MaxGblSize)    i '$d($$$StorageNode($$$StorageSubscript)) s $li($$$StorageNode($$$StorageSubscript),$$$MaxGblSizeOff)=%MaxGblSize

#define UpdateTime       1 /*UpdateTime*/
#define EndTimeOff        2 /*EndTime*/
#define FlagsOff          3 /*Flags*/
#define LogFileOff        4 /*LogFile*/
#define MBCopiedOff       5 /*MBCopied*/
#define MBToCopyOff       6 /*MBToCopy*/
#define NameOff           7 /*Name*/
#define PctCopiedOff      8 /*PctCopied */
#define PidOff            9 /*Pid*/
#define StartTimeOff     10 /*StartTime*/
#define StateOff         11 /*State*/
#;The main info data
#;Done and NotStarted must be the first two here (1 and 2).
#define   Done             1 /*Done*/
#define   NotStarted       2 /*NotStarted*/
#define   Started          3 /*Started*/
#define   Size			   4 /*Size*/
#define   SizeDone		   5 /*SizeDone*/
#define   Copy             6 /*Copy*/
#define   CopyDone         7 /*Copy*/
#define   JrnApply         8 /*JrnApply*/
#define   JrnApplyDone     9 /*JrnApply*/
#;define   FreezeSystem   10 /*FreezeSystem*/
#define   CPFUpdate       11 /*CPFUpdate*/
#define   CPFUpdateDone   12 /*CPFUpdated*/
#define   NSPActivate     13 /*NSPActivating*/
#define   NSPActivateDone 14 /*NSPActivated*/
#define   DeleteSrcGlobals 15 /*DeleteSrcGlobals*/
#define   DeleteSrcGlobalsDone      16 /*DeleteSrcGlobalsDone*/
#define   Rollback        17 /*Rollback*/
#define StatusOff        12 /*Status*/
#define StopOff          13 /*Stop*/
#define    StopNone      0 /*StopNone*/
#define    StopUser      1 /*StopUser*/
#define    StopErrorRecoverable 2 /*StopErrorRecoverable*/
#define    StopErrorUnRecoverable 3 /*StopErrorUnRecoverable*/
#define TransOpenOff     14 /*TransOpen*/
#define UsernameOff      15 /*Username*/

#define SuspendOff       23 /*Suspend*/

#define StateNotStarted 0 /*StateNotStarted*/
#define StateRunning    1 /*StateRunning*/
#define StateDone       2 /*StateDone*/
#define StateError      3 /*StateError*/

#;^SYS("DataMove",Name,"Info")=$lb()
#define RootNode(%Name)			      $$$StorageNode($$$StorageSubscript,%Name)
#define InfoNode(%Name)               $$$StorageNode($$$StorageSubscript,%Name,"Info")
#define SetUpdateTime(%Name,%Desc)    s $li($$$InfoNode(%Name),$$$UpdateTimeOff)=%Desc
#define GetUpdateTime(%Name)          $li($$$InfoNode(%Name),$$$UpdateTimeOff)
#define SetEndTime(%Name,%Time)       s $li($$$InfoNode(%Name),$$$EndTimeOff)=%Time
#define GetEndTime(%Name)             $li($$$InfoNode(%Name),$$$EndTimeOff)
#define SetFlags(%Name,%Flags)        s $li($$$InfoNode(%Name),$$$FlagsOff)=%Flags
#define GetFlags(%Name)               $li($$$InfoNode(%Name),$$$FlagsOff)
#define SetLogFile(%Name,%LogFile)    s $li($$$InfoNode(%Name),$$$LogFileOff)=%LogFile
#define GetLogFile(%Name)             $li($$$InfoNode(%Name),$$$LogFileOff)
#define SetMBCopied(%Name)            s %1Global="",Total=0 ; ^^^^f { s %1Global=$$$GetNextGlobal(%Name,%1Global) q:%1Global=""  s Total=Total+$$$GetGblMBCopied(%Name,XXX,%1Global) } s $li($$$InfoNode(%Name),$$$MBCopiedOff)=Total i +$$$GetMBToCopy(%Name)=0 {$$$SetPctCopied(%Name,0)} else {$$$SetPctCopied(%Name,$fn($$$GetMBCopied(%Name)/$$$GetMBToCopy(%Name)*100,"",0))} $$$SYNCJOURNAL
#define GetMBCopied(%Name)            $li($$$InfoNode(%Name),$$$MBCopiedOff)
#define SetMBToCopy(%Name)            s %1Global="",Total=0 ;^^^f { s %1Global=$$$GetNextGlobal(%Name,%1Global) q:%1Global=""  s Total=Total+$$$GetGblMBToCopy(%Name,XXX,%1Global) } s $li($$$InfoNode(%Name),$$$MBToCopyOff)=Total $$$SYNCJOURNAL
#define GetMBToCopy(%Name)            $li($$$InfoNode(%Name),$$$MBToCopyOff)
#define GetName(%Name)                $li($$$InfoNode(%Name),$$$NameOff)
#define SetPctCopied(%Name,%Pct)      s $li($$$InfoNode(%Name),$$$PctCopiedOff)=%Pct
#define GetPctCopied(%Name)           $li($$$InfoNode(%Name),$$$PctCopiedOff)
#define SetPid(%Name,%Pid)            s $li($$$InfoNode(%Name),$$$PidOff)=$s($$$ISVMS:$zh(%Pid),1:%Pid)
#define GetPid(%Name)                 $s($$$ISVMS:$zh($li($$$InfoNode(%Name),$$$PidOff)_""),1:$li($$$InfoNode(%Name),$$$PidOff))
#define SetStartTime(%Name,%Time)     s $li($$$InfoNode(%Name),$$$StartTimeOff)=%Time
#define GetStartTime(%Name)           $li($$$InfoNode(%Name),$$$StartTimeOff)
#;Setting the state is critical, make sure we get it flushed to the journal file
#define SetState(%Name,%State)        s $li($$$InfoNode(%Name),$$$StateOff)=%State  $$$SYNCJOURNAL
#define GetState(%Name)               +$li($$$InfoNode(%Name),$$$StateOff)
#;If the current status is not $$$OK, don't overwrite it, but log it. The restart version
#;just sets it to the passed status without logging, it is used if the operation is restarted.
#define SetStatus(%Name,%Status)      i $$$ISOK($$$GetStatus(%Name)) {s $li($$$InfoNode(%Name),$$$StatusOff)=%Status} i '$$$ISOK(%Status) {$$$SetLog(Name,$System.Status.GetErrorText(%Status))} $$$SYNCJOURNAL
#define SetStatusZEN(%Name,%Status)   i $$$ISOK($$$GetStatus(%Name)) {s $li($$$InfoNode(%Name),$$$StatusOff)=%Status} i '$$$ISOK(%Status) {$$$SetLogZEN(Name,$System.Status.GetErrorText(%Status))} $$$SYNCJOURNAL
#define SetStatusRestart(%Name,%Status) s $li($$$InfoNode(%Name),$$$StatusOff)=%Status $$$SYNCJOURNAL
#define SetStatusNoLog(%Name,%Status) i $$$ISOK($$$GetStatus(%Name)) {s $li($$$InfoNode(%Name),$$$StatusOff)=%Status} $$$SYNCJOURNAL
#define GetStatus(%Name)              $li($$$InfoNode(%Name),$$$StatusOff)
#define SetStop(%Name,%Stop)          s $li($$$InfoNode(%Name),$$$StopOff)=%Stop $$$SYNCJOURNAL
#define GetStop(%Name)                +$li($$$InfoNode(%Name),$$$StopOff)
#define SetSuspend(%Name,%Suspend)    s $li($$$InfoNode(%Name),$$$SuspendOff)=%Suspend $$$SYNCJOURNAL
#define GetSuspend(%Name)             +$li($$$InfoNode(%Name),$$$SuspendOff)
#define SetTransOpen(%Name,%Trans)    s $li($$$InfoNode(%Name),$$$TransOpenOff)=%Trans
#define GetTransOpen(%Name)           $li($$$InfoNode(%Name),$$$TransOpenOff)
#define SetUsername(%Name,%User)      s $li($$$InfoNode(%Name),$$$UsernameOff)=%User
#define GetUsername(%Name)            $li($$$InfoNode(%Name),$$$UsernameOff)

#;We display these records in reverse $order so most recent are first
#;define GetNextData(%Name) $o($$$StorageNode($$$StorageSubscript,%StartTime),-1)
#;define GetPrevData(%Name) $o($$$StorageNode($$$StorageSubscript,%StartTime),1)

#;Defines for each range
#define RngDstDBOff      1 /*DstDB*/
#define RngDstDirOff     2 /*DstDir*/
#define RngFlagsOff      3 /*Flags*/
#define    RngWildCardBit    1 /*WildCard*/
#define    RngRangeBit       2 /*Range*/
#define    RngNoDeleteSrcBit 4 /*NoDeleteSrc*/
#define RngJRNCUROff	 4 /*JRNCUR*/
#define RngJRNFileOff	 5 /*JrnFile*/
#define RngJRNMBToRestoreOff 6/*JRNMBToRestore*/
#define RngRange         7 /*Range*/
#define RngSrcDBOff      8 /*SrcDB*/
#define RngSrcDirOff     9 /*SrcDir*/
#define RngTypeOff      10 /*Type*/
#;SML1995+
#;^SYS("DataMove",Name,"Ranges",SrcDB,DstDB,Range)=$lb()
#define RangeNode(%Name,%SrcDB,%DstDB,%Range)             $$$StorageNode($$$StorageSubscript,%Name,"Ranges",%SrcDB,%DstDB,%Range)
#define SetRngDstDB(%Name,%SrcDB,%DstDB,%Range,%DB)       s $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngDstDBOff)=%DB
#define GetRngDstDB(%Name,%SrcDB,%DstDB,%Range)           $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngDstDBOff)
#define SetRngDstDir(%Name,%SrcDB,%DstDB,%Range,%Dir)     s $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngDstDirOff)=%Dir
#define GetRngDstDir(%Name,%SrcDB,%DstDB,%Range)          $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngDstDirOff)
#define SetRngFlags(%Name,%SrcDB,%DstDB,%Range,%Flags)    s $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngFlagsOff)=%Flags
#define GetRngFlags(%Name,%SrcDB,%DstDB,%Range)           $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngFlagsOff)
#define SetRngJRNCUR(%Name,%SrcDB,%DstDB,%Range,%JRNCUR)  s $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngJRNCUROff)=%JRNCUR $$$SYNCJOURNAL
#define GetRngJRNCUR(%Name,%SrcDB,%DstDB,%Range)          $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngJRNCUROff)
#define SetRngJRNFile(%Name,%SrcDB,%DstDB,%Range,%File)   s $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngJRNFileOff)=%File $$$SYNCJOURNAL
#define GetRngJRNFile(%Name,%SrcDB,%DstDB,%Range)         $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngJRNFILEOff)
#define SetRngJRNMBToRestore(%Name,%SrcDB,%DstDB,%Range,%MB) s $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngJRNMBToRestoreOff)=%MB $$$SYNCJOURNAL
#define GetRngJRNMBToRestore(%Name,%SrcDB,%DstDB,%Range)  $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngJRNMBToRestoreOff)
#define SetRngRange(%Name,%SrcDB,%DstDB,%Range)           s $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngRangeOff)=%Range
#define GetRngRange(%Name,%SrcDB,%DstDB,%Range)           $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngRangeOff)
#define SetRngSrcDB(%Name,%SrcDB,%DstDB,%Range,%DB)       s $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngSrcDBOff)=%DB
#define GetRngSrcDB(%Name,%SrcDB,%DstDB,%Range)           $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngSrcDBOff)
#define SetRngSrcDir(%Name,%SrcDB,%DstDB,%Range,%Dir)     s $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngSrcDirOff)=%Dir
#define GetRngSrcDir(%Name,%SrcDB,%DstDB,%Range)          $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngSrcDirOff)
#;#define SetRngTypeDir(%Name,%SrcDB,%DstDB,%Range)   s $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Range),$$$RngTypeOff)=%Type
#;#define GetRngTypeDir(%Name,%SrcDB,%DstDB,%Type,%Range)         $li($$$RangeNode(%Name,%SrcDB,%DstDB,%Type,%Range),$$$RngTypeOff)

#define GetNextRange(%Name,%SrcDB,%DstDB,%Range)          $o($$$RangeNode(%Name,%SrcDB,%DstDB,%Range))
#;SML1995-

#;Defines for each global
#define GblCollationOff   1 /*Collation*/
#define GblCurNodeOff     2 /*CurNode*/
#define GblEncodeRuleOff  3 /*EncodeRule*/
#define GblEndKeyOff      4 /*EndKey*/
#define GblEndNodeOff     5 /*EndNode*/
#define GblEndTimeOff     6 /*EndTime*/
#define GblGlobalNameOff  7 /*GlobalName*/
#define GblGlobalRangeOff 8 /*GlobalRange*/
#define GblKeepValOff     9 /*KeepVal*/
#define GblMBCopiedOff   10 /*MBCopied*/
#define GblMBToCopyOff   11 /*MBToCopy*/
#define GblPctCopiedOff  12 /*Percent Copied*/
#define GblPidOff        13 /*Pid*/
#define GblSLMOff        14 /*SLM*/
#define GblStartKeyOff   15 /*StartKey*/
#define GblStartNodeOff  16 /*StartNode*/
#define GblStartTimeOff  17 /*StartTime*/
#define GblStateOff      18 /*State*/
#define     GblDone       1 /*GblDone*/
#define     GblNotStarted 2 /*GblNotstarted */
#define     GblCopying    4 /*GblCopying*/
#define GblStatusOff     19 /*Status*/
#;SML1995+
#;^SYS("DataMove",Name,"Ranges",SrcDB,DstDB,Range,Global)=$lb()
#define GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global)            $$$StorageNode($$$StorageSubscript,%Name,"Ranges",%SrcDB,%DstDB,%Range,"Globals",%Global)
#define SetGblCollation(%Name,%SrcDB,%DstDB,%Range,%Global,%Collation)   s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblCollationOff)=%Collation $$$SYNCJOURNAL
#define GetGblCollation(%Name,%SrcDB,%DstDB,%Range,%Global)         $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblCollationOff)
#define SetGblCurNode(%Name,%SrcDB,%DstDB,%Range,%Global,%Node)   s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblCurNodeOff)=%Node $$$SYNCJOURNAL
#define GetGblCurNode(%Name,%SrcDB,%DstDB,%Range,%Global)         $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblCurNodeOff)
#define SetGblEncodeRule(%Name,%SrcDB,%DstDB,%Range,%Global,%EncodeRule)   s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblEncodeRuleOff)=%Node $$$SYNCJOURNAL
#define GetGblEncodeRule(%Name,%SrcDB,%DstDB,%Range,%Global)         $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblEncodeRuleOff)
#define SetGblEndKey(%Name,%SrcDB,%DstDB,%Range,%Global,%EndKey)   s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblEndKeyOff)=%EndKey $$$SYNCJOURNAL
#define GetGblEndKey(%Name,%SrcDB,%DstDB,%Range,%Global)         $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblEndKeyOff)
#define SetGblEndNode(%Name,%SrcDB,%DstDB,%Range,%Global,%EndNode)   s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblEndNodeOff)=%EndNode $$$SYNCJOURNAL
#define GetGblEndNode(%Name,%SrcDB,%DstDB,%Range,%Global)         $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblEndNodeOff)
#define SetGblEndTime(%Name,%SrcDB,%DstDB,%Range,%Global,%Time)   s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblEndTimeOff)=%Time
#define GetGblEndTime(%Name,%SrcDB,%DstDB,%Range,%Global)         $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblEndTimeOff)
#define SetGblGlobalName(%Name,%SrcDB,%DstDB,%Range,%Global,%GlobalName)          s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblGlobalNameOff)=%GlobalName
#define GetGblGlobalName(%Name,%SrcDB,%DstDB,%Range,%Global)          $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblGlobalNameOff)
#define SetGblGlobalRange(%Name,%SrcDB,%DstDB,%Range,%Global,%GlobalRange)          s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblGlobalRangeOff)=%GlobalRange
#define GetGblGlobalRange(%Name,%SrcDB,%DstDB,%Range,%Global)          $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblGlobalRangeOff)
#define SetGblMBCopied(%Name,%SrcDB,%DstDB,%Range,%Global,%Bytes) s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblMBCopiedOff)=$fn(%Bytes/(1024*1024),"",2) $$$SYNCJOURNAL
#define GetGblMBCopied(%Name,%SrcDB,%DstDB,%Range,%Global)        +$li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblMBCopiedOff)
#define SetGblMBToCopy(%Name,%SrcDB,%DstDB,%Range,%Global,%MB)    s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblMBToCopyOff)=%MB $$$SYNCJOURNAL
#define GetGblMBToCopy(%Name,%SrcDB,%DstDB,%Range,%Global)        +$li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblMBToCopyOff)
#define SetGblPctCopied(%Name,%SrcDB,%DstDB,%Range,%Global,%Pct)  s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblPctCopiedOff)=%Pct $$$SYNCJOURNAL
#define GetGblPctCopied(%Name,%SrcDB,%DstDB,%Range,%Global)       +$li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblPctCopiedOff)
#define SetGblPid(%Name,%SrcDB,%DstDB,%Range,%Global,%Pid)        s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblPidOff)=%Pid
#define GetGblPid(%Name,%SrcDB,%DstDB,%Range,%Global)             $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblPidOff)
#define SetGblSLM(%Name,%SrcDB,%DstDB,%Range,%Global,%SLM)        s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblSLMOff)=%SLM
#define GetGblSLM(%Name,%SrcDB,%DstDB,%Range,%Global)             $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblSLMOff)
#define SetGblStartKey(%Name,%SrcDB,%DstDB,%Range,%Global,%StartKey) s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblStartKeyOff)=%StartKey
#define GetGblStartKey(%Name,%SrcDB,%DstDB,%Range,%Global)       $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblStartKeyOff)
#define SetGblStartNode(%Name,%SrcDB,%DstDB,%Range,%Global,%StartNode) s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblStartNodeOff)=%StartNode
#define GetGblStartNode(%Name,%SrcDB,%DstDB,%Range,%Global)       $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblStartNodeOff)
#define SetGblStartTime(%Name,%SrcDB,%DstDB,%Range,%Global,%Time) s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblStartTimeOff)=%Time
#define GetGblStartTime(%Name,%SrcDB,%DstDB,%Range,%Global)       $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblStartTimeOff)
#define SetGblState(%Name,%SrcDB,%DstDB,%Range,%Global,%State)    s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblStateOff)=%State $$$SYNCJOURNAL
#define GetGblState(%Name,%SrcDB,%DstDB,%Range,%Global)           +$li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblStateOff)
#define SetGblStatus(%Name,%SrcDB,%DstDB,%Range,%Global,%Status)  s $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblStatusOff)=%Status  i '$$$ISOK(%Status) {$$$SetLog(%Name,$System.Status.GetErrorText(%Status))} $$$SYNCJOURNAL
#define GetGblStatus(%Name,%SrcDB,%DstDB,%Range,%Global)          $li($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global),$$$GblStatusOff) 

#define GetNextGlobal(%Name,%SrcDB,%DstDB,%Range,%Global)         $o($$$GlobalNode(%Name,%SrcDB,%DstDB,%Range,%Global))
#;SML1995-

#;Defines for the log data. Note that this can be updated by multiple processes
#;at the same time, so we need to get a $increment as a placeholder.
#define LogTime 1
#define LogData 2
#define LogNode(%Name,%Log)         $$$StorageNode($$$StorageSubscript,%Name,"Log",%Log)
#define SetLog(%Name,%Msg) s $$$StorageNode($$$StorageSubscript,%Name,"Log",$i($$$StorageNode($$$StorageSubscript,%Name,"Log")))=$lb($ztimestamp,%Msg)
#;This is called when we are using ZEN
#;define SetLogZEN(%Name,%Msg)	   s ^||ISC.DataMove=$i($$$StorageNode($$$StorageSubscript,%Name,"Log")) s $$$StorageNode($$$StorageSubscript,%Name,"Log",^||ISC.DataMove)=$lb($ztimestamp,%Msg)  k ^||ISC.DataMove
#define GetLogTime(%Name,%Log) $li($$$LogNode(%Name,%Log),$$$LogTime)
#define GetLogData(%Name,%Log) $li($$$LogNode(%Name,%Log),$$$LogData)
#define GetNextLog(%Name,%Log) $o($$$LogNode(%Name,%Log))

#;Used to write to the log file from class methods. Use the WriteLogFile Method when in an instance method. 
#define WriteLogFile(%Name,%Msg) $$$SetLog(%Name,%Msg)

#;Defines for the accumulated Journal size records
#define JRNSizeTime 1
#define JRNSizeMB   2
#define JRNNode(%Name,%Index)        $$$StorageNode($$$StorageSubscript,%Name,"JRNSize",%Index)
#define SetJRNSize(%Name,%Size)      s $$$StorageNode($$$StorageSubscript,%Name,"JRNSize",$i($$$StorageNode($$$StorageSubscript,%Name,"JRNSize")))=$lb($ztimestamp,%Size)
#define GetJRNSizeTime(%Name,%Index) $li($$$JRNNode(%Name,%Index),$$$JRNSizeTime)
#define GetJRNSizeMB(%Name,%Index)   $li($$$JRNNode(%Name,%Index),$$$JRNSizeMB)
#define GetNextJRNSize(%Name,%Index) $o($$$JRNNode(%Name,%Index))

#;Defines for the CPFFile
#define CPFData         1
#define CPFFileMapFlag     1
#define PrevCPFFileMapFlag 2
#define CPFFileMaps     "CPFFileMaps"
#define PrevCPFFileMaps "PrevCPFFileMaps"
#define SaveCPFFile(%CPFFile,%Name) %CPFFile_"_DataMove_"_$tr(%Name,":",".")
#define NewCPFFile(%CPFFile,%Name) $p(%CPFFile,".")_"new."_$p(%CPFFile,".",2,*)

#define CPFNode(%Name,%Type,%Index)     $$$StorageNode($$$StorageSubscript,%Name,%Type,%Index)
#define SetCPFData(%Name,%Type,%Data)   s $$$StorageNode($$$StorageSubscript,%Name,%Type,$i($$$StorageNode($$$StorageSubscript,%Name,%Type)))=$lb(%Data)
#define GetCPFData(%Name,%Type,%Index)  $li($$$CPFNode(%Name,%Type,%Index),$$$CPFData)
#define GetNextCPF(%Name,%Type,%Index)  $o($$$CPFNode(%Name,%Type,%Index))

#;Definitions for Datamove Flags properties
#define BitNoSrcJournal               1
#define BitNoWorkerJobs             512
#;Not yet used
#define BitIgnoreOpenTransactions  1024
#define BitSplitNamespace         16384

#;Flags for method ApplyJournal
#define BitSetSwitch13 1	

#define MGBLSystemDBs ",CACHELIB,CACHEAUDIT,"
#define MGBLSystemNS ",%SYS,%CACHELIB,"
#;SML1968 ; Handle explicit global reference.
#define EncodeKey(%GblRef,%Rule,%Key) i $e(%GblRef)'="^" {s ISCNewGblRef="^"_%GblRef,%Key=%GblRef} else {s ISCNewGblRef=%GblRef,%Key=$e(%GblRef,2,*)} s:$e(%Key)="|" %Key=$p(%Key,"|",3) s %Key=$p(%Key,"(") f i=1:1:$ql(ISCNewGblRef) { s %Key=%Key_$c(0)_$zu(70,2,$qs(ISCNewGblRef,i),+%Rule)}

#define CheckDir(%x) CheckDir%x(Select,Data) q:(Select="*") 1  q:Data="" 1  q:(","_$zcvt(Select,"L")_",")[(","_$zcvt(Data,"L")_",") 1  q:Select'["*" 0  n Found,Field s Found=0 f i=1:1:$l(Select,",") { s Field=$p(Select,",",i) Continue:$e(Field,$l(Field))'="*"  s Field=$zcvt($p(Field,"*",1),"L") i Field=$e($zcvt(Data,"L"),1,$l(Field)) s Found=1 q} q Found
#define CheckNum(%x) CheckNum%x(Select,Data) q:(Select="*") 1  n i,Found s Found=0 f i=1:1 { q:$p(Data,",",i)=""  i (","_Select_",")[(","_$p(Data,",",i)_",") s Found=1 } q Found

#;Functions
#define LockApplyJournals        "ApplyJournals"
#define LockCalculateMBToCopy    "CalculateMBToCopy"
#define LockDataMove             "DataMove"
#define LockDeleteSrcGlobals     "DeleteSrcGlobals"
#define LockDeleteDstGlobals     "DeleteSrcGlobals"
#define LockDumpLogToFile        "DumpLogToFile"
#define LockMoveGlobals          "MoveGlobals"
#define LockRollback             "Rollback"  
#define LockRun			         "Run"
#define LockCPFUpdate            "CPFUpdate"
#define LockNSPActivate          "NSPActivate"

#;Need to set %copied to 100 if mbcopied>mbto copy, and done!^^^^
#define CalculatePct(%PctCopied,%MBCopied,%MBToCopy) i %MBCopied=0 { s %PctCopied=0 } else { i %MBCopied>%MBToCopy {s %PctCopied=99} else { s %PctCopied=$fn(%MBCopied/%MBToCopy*100,"",2)}}

#;SML1995
#define CalculateGblPct(%Name,%SrcDB,%DstDB,%Range,%Global) i $$$GetGblMBCopied(%Name,%SrcDB,%DstDB,%Range,%Global) = 0 { $$$SetGblPctCopied(%Name,%SrcDB,%DstDB,%Range,%Global,0) } else { i $$$GetGblMBCopied(%Name,%SrcDB,%DstDB,%Range,%Global)>$$$GetGblMBToCopy(%Name,%SrcDB,%DstDB,%Range,%Global) { $$$SetGblPctCopied(%Name,%SrcDB,%DstDB,%Range,%Global,100)} else { $$$SetGblPctCopied(%Name,%SrcDB,%DstDB,%Range,%Global,$fn($$$GetGblMBCopied(%Name,%SrcDB,%DstDB,%Range,%Global)/$$$GetGblMBToCopy(%Name,%SrcDB,%DstDB,%Range,%Global)*100,"",2)) }}

#;Clear the status value in the main object. Only used to initial Status at the beginning of each call.
#;^^^May want to log the error to the log
#define ClearStatus s ..Status=$$$OK s %StatusXyZ123=..%Save(0) i '$$$ISOK(%StatusXyZ123) { q %StatusXyZ123 } else {k %StatusXyZ123}

#;These are operation which can get run in the background through the DispatchJob() method.
#;They use the GetWorkState() method to determine when they are done.
#;The ResetState list is the list of these methods which can be called multiple times, and need to have
#;their State reset to NotStarted before they get jobbed off.
#define DispatchJobMethodList ",ApplyJournals,CalculateMBToCopy,DeleteDstGlobals,DeleteSrcGlobals,MoveGlobals,Rollback,Run,ValidateSizes,"
#define DispatchJobMethodListResetState ",ApplyJournals,CalculateMBToCopy,ValidateSizes,"

#define DispatchMethodList ",ApplyJournals,CalculateMBCopied,CalculateMBToCopy,ChangeState,CheckDstDBs,CheckDstDBSizes,CheckDstGlobals,CheckDstGlobalsForExistence,CheckSrcDBs,CheckSystemState,CPFUpdate,Create,CreateDstDBs,CreateRanges,Delete,DeleteDstGlobals,DeleteRanges,DeleteSrcGlobals,FindGlobals,Finish,Get,GetWorkState,Initialize,Modify,ModifyDstGlobalsKeepVal,MoveGlobals,NSPActivate,Resume,Rollback,Run,RunEM,SetSwitch10,Stop,StopMove,Suspend,Validate,ValidateSizes,"
 
