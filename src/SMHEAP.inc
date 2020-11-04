ROUTINE SMHEAP [Type=INC]
#ifndef SMHEAPINC
#define SMHEAPINC
#if	0 /*=======================Maintenance========================
SML1691 4/11/13 Simon Li, Synch SMHEAP.inc with smheap.h.
SML846
		=====================End Maintenance======================*/
#endif
  
#; Internal ID, all the SMH pages allocated for SMT and GST is counted in this category.
#define	CIDInternal       0
#; Used for system internal when very small amount of memory is needed and it is not classified as any other ConsumerID.
#define	CIDMisc           1
#; Audit system.
#define	CIDAudit          2
#; Class hash table and control blocks.
#define	CIDClass          3
#; Structures for Database extension for multi-volume DB.
#define	CIDDBExtension    4
#; DDP network.
#define	CIDDDP            5
#; Event system.
#define	CIDEvent          6
#; Global mapping and SLM mapping.
#define	CIDGlobalMapping  7
#; License upgrade.
#define	CIDLicense        8
#; Lock system.
#define	CIDLock           9
#; NLS tables.
#define	CIDNLS            10
#; Performance monitor.
#define	CIDPerfMon        11
#; Process table.
#define	CIDPIDTable       12
#; Routine buffer in use tables.
#define	CIDRoutineInuse   13
#; Security system.
#define	CIDSecurity       14
#; Shadowing system.
#define	CIDShadow         15
#; Shared system DLL list.
#define	CIDSystemDLL      16
#; TTY hash tables.
#define	CIDTTYHash        17
#; Text string for DB Names and directory Path.
#define	CIDDBNames	    18
#; i.Know KB/LB
#define CIDiKnow           19
#; ECP expansion.
#define CIDECP		    20
#; Expand daemon.
#define	CIDExpand	    21
#; IPQs
#define CIDIPQ          22
#; WARNING!!!, you need to update MaxConsumerID when you add a new ConsumerID.
#define	MaxConsumerID     22 /** Number of the ConsumerID defined. */
 