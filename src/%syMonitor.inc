ROUTINE %syMonitor [Type=INC]
 ;%syMonitor.INC    Monitor definitions file, SAP1360 10/10/10
 
 ;Macro definitions shared by various monitor routines
 
#ifndef %syMonitor
#define %syMonitor
 
#; HEALTHMONITOR Run State
#define NotRunning	-1
#define Idle	0
#define	Startwait	1
#define GetSensors	2
#define GetSensorsNoChart	3


#; HEALTHMONITOR Rule Types
#define Trend	1
#define SingleVariable	2
#; Mirror defines
#define	MirrorPrimary	1
#define	MirrorBackup 2
#define	MirrorNone 0
#define MirrorRestart 3
#; HEALTHMONITOR rule codes
#define MaxValue	4
#define WarnValue	5
#define RisingFallingTrend	10

#; Monitor Events
#define MONITOR	"^ISCMONITOR"
#define MONITORREFRESH "^ISCMONITORREFRESH"
#define MONITORHALT "^ISCMONITORHALT"
#; System Monitor Events
#define SYSTEMMONITORCMD "^ISCSYSTEMMONITORCMD"
#define SYSTEMMONITORSENSOR "^ISCSYSTEMMONITORSENSOR"
#; System Monitor Commands
#define SYSTEMMONITORHALT 1
#define SYSTEMMONITORREFRESH 2
#define SYSTEMMONITORSTATE 3
#define SYSTEMMONITORSTART 4
#define SYSTEMMONITORSTOP 5
#; Application Monitor Events
#define APPMONITOR	"^APPMONITOR"
#define APPMONITORREFRESH "^APPMONITORREFRESH"
#; System Sensors defines
#define	CYCLES 6
#define LOGCON(%msg,%sev) do $ZU(9,"","SYSTEM MONITOR: "_%msg,0,%sev)
#; System locked defines
#define	SYSMONLOCKED '##class(%SYS.Monitor).Lock()
#; Current HEALTHMONITOR control version.
#define	CurrentHEALTHMONITORVersion	1

#; System Monitor Component Class Types.
#define SENSORCLASS	1
#define ASYNCSENSORCLASS	2
#define	SUBSCRIBERCLASS	3
#define	NOTIFYCLASS	4
#define	NOTIFYFILTERCLASS	5
#; Monitor Alerts
#define COUNT	1
#define TIME	2
#define	SCRUTINY	1
#define	TROUBLED	2
#define	FAILED		3
#; System Monitor state
#define	SETHEALTH(%x)	$system.Monitor.SetState(%x)
#define	GETHEALTH	$system.Monitor.State()
#define	CLEARSTATE	$system.Monitor.Clear()
#define	CLEARALERTS	$system.Monitor.ClearAlerts()
#define	GETALERTS	$system.Monitor.Alerts()
#define	GREEN	0
#define	YELLOW	1
#define	RED	2
#; System Monitor defaults
#define	DEBUGLEVEL	0
#define	KEEPALERTS	5
#define	SAMPLEINTERVAL	30
#; Monitor Notifications
#define	NOTIFYSEV	1
#define	NOTIFYMSG	2
#; HEALTHMONITOR Start wait time - 10 minutes
#define HEALTHSTARTWAIT	10
#; HEALTHMONITOR sampling interval - 30 seconds
#define HEALTHINTERVAL	30

#; System Monitor Metrics Types.
#define STATISTIC	1
#define	SMMILLSECS	2
#define	SMSECS	3
#define	SMKB	4
#define	SMBYTES	5
#define	SMCOUNTER	6
#endif %syMonitor
