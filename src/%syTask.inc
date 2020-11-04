ROUTINE %syTask [Type=INC]
 ;%syTask.INC -Defines for $SYSTEM.Task ; HYY1601 11/19/10
 
#; /*=======================Maintenance========================*/
#; JSL4363 11/05/13 Jonathan Levinson, add PurgeZENReports
#; HYY1601 11/19/10 Huayong Yang, add PurgeBackupLog
#; RFD568 	9/22/10, Rob davis, Add CheckLogging system Task
#; STC1810 06/21/10, Steve Clay, Add Purge of ^ERRORS and logs task
#; TRW522 12/13/07, Tom Woodfin, Add Inventory Scan task
#; JB371	09/18/07 Add Purge Audit task
#; YSD1618 01/29/07, Yan Drabek, Change wording "Buttons" to "DiagnosticReport"
#; YSD1603 12/26/06, Yan Drabek, Add "Buttons" to System Management Portal
#; JB306  09/22/06, James Bourette  Localize Default Task Descriptions
#; STC471 08/19/03, Steve Clay, rename to %SyTask
#; STC404 12/18/02, Steve Clay, changed RUNONCE to ONDEMAND,
#; 					Added some fields
#; STC373 09/26/02, Steve Clay, Initial version
#; /*=====================End Maintenance======================*/
#;
#;
#ifndef %syTaskinc
#define %syTaskinc
#define TASKMGREVENT "TASKMGREVENT"
 
#;These are the $list offsets of the fields in the ^%CacheTask(0) record
#;Version must always be the first piece
#define VersionOff 1
#define SuspendOff 2
#define HistoryPurgeOff 3
#define JobTimeoutOff 4
 
#; Here is where the task info is stored
#define CacheTaskGbl ^%CacheTask
#define CacheTaskHistoryGbl ^%CacheTaskHistory
 
#;These are the default values for the ^%CacheTask(0) record
#define Version "1.2"
#define DefaultSuspend 0
#define DefaultHistoryPurge 7
#define DefaultJobTimeout 30
 
#; These are the $list offsets of the fields in the %CacheTask(name,number) record
#define SuspendedOff 1
#define PriorityOff 2
#define IsBatchOff 3
#define CallTypeOff 4
#define NameSpaceOff 5
#define RoutineOff 6
#define ParamsOff 7
#define ScheduleOff 8
#define StatusOff 9
#define ErrorOff 10
#define RescheduleOnStartOff 11
#define UICOff 12
#define DescriptionOff 13
#define EROff 14
 
#;These are the $list offsets of the schedule structure
#define TimePeriodOff 1
#define TimePeriodEveryOff 2
#define TimePeriodDayOff 3
#define DailyFrequencyOff 4
#define DailyFrequencyTimeOff 5
#define DailyIncrementOff 6
#define DailyStartTimeOff 7
#define DailyEndTimeOff 8
#define StartDateOff 9
#define EndDateOff 10
#define LastStartedOff 11
#define LastFinishedOff 12
 
#;Here is the record definition for the save/update methods in the task class 
#define SCHEDULERECORD $lb(+i%TimePeriod,i%TimePeriodEvery,i%TimePeriodDay,+i%DailyFrequency,i%DailyFrequencyTime,i%DailyIncrement,+i%DailyStartTime,+i%DailyEndTime,i%StartDate,+i%EndDate,i%LastStarted,i%LastFinished) 
#define TASKRECORD $lb(i%Suspended,i%Priority,i%IsBatch,i%CallType,i%NameSpace,i%Routine,i%Params,Schedule,i%Status,i%Error,i%RescheduleOnStart,i%UIC,i%Description,i%ER,"","","","","") 
 
#;These are the values for the CallType field
#define SubRoutineCall 0
#define FunctionCall 1
 
#;These are the legal values for the TimePeriod field
#define DAILY 0
#define WEEKLY 1
#define MONTHLY 2
#define MONTHLYSPECIAL 3 
#define RUNAFTER 4
#define ONDEMAND 5
 
#;These are the legal values for the DailyFrequency field
#define ONCE 0
#define SEVERAL 1
 
#;These are predefined values for the Status field
#define JobSuccess 1
#define JobRunning -1
#define JobUntrappedError -2
#define JobSetupError -3
#define JobTimeout -4
#define JobPostProcessError -5
 
#define JobSuccessMessage "Success"
#define JobRunningMessage "Running"
#define JobTimeoutMessage "Job Command Timeout"
 
#;The following is the list of predefined
#;system jobs
#define SecurityScanName	 "Security Scan"
 
#define SwitchJournalNumber		1
#define PurgeJournalNumber 		2
#define PurgeTaskDataNumber		3
#define IntegrityCheckNumber 	4
#;Freespace no longer used
#define FreeSpaceNumber 		5
#define SecurityScanNumber 		5
#define SendDiagnosticReport 	6
#define PurgeAuditDatabase	 	7
#define InventoryScan			8
#define PurgeErrorsAndLogNumber 9
#define CheckLoggingNumber 		10
#define PurgeBackupLogNumber 		11
#define PurgeZENReports			12
#endif ; %syTaskinc 