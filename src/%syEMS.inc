ROUTINE %syEMS [Type=INC]
#include %occSystemMessages
#include %syDatabase
#include %sySecurity
#if 0   /*=======================Maintenance========================*/
#;RFD879  05/06/13 Rob Davis, Fix EMS Security global macros
#;RFD768  08/16/12 Rob Davis, More EMS code cleanup in /projects/ems
#;JO2517  05/22/12 Jeffrey Orlin, changes to support mirroring
#;RFD726  03/08/12 Rob Davis, add audit data info for workspace updates
#;RFD705  01/21/12 Rob Davis, rework remote startup/shutdown functions to use ISCAgent,
#;RFD703  01/19/12 Rob Davis, add support for remote start/stop
#;RFD700  12/26/11 Rob Davis, add EMSPurgeRevisions Task
#;STC2004 10/18/11 Steve Clay, Define EMS account names in %syEMS
#;RJW1955 09/29/11 Ron Watt, Fix EMS database macro usage
#;RJW1933 09/01/11 Ron Watt, EMS Instance Specific settings must vary by version.
#;KJK098  08/24/11 Kurt Klinzing, Changes for using X509 security with EMS
#;JO2452   8/11/11 Jeffrey Orlin, change EMSMirrorSetMembersBit -> EMSMapMirrorsBit
#;                 and EMSMirrorBit to EMSMirrorsBit
#;RJW1911 06/21/11 Ron Watt, Changes to a group's journal paths should not create directories on EMS machine's file system
#;STC1919 03/07/11 Steve Clay, EMS Synchronous changes
#;RJW1875 2/23/11 Ron Watt, Instance specific overrides for configuration properties in EMS.
#;STC1747 03/22/10 Steve Clay, initial version
#endif  /*=====================End Maintenance======================*/
#define EMSMappedGlobal ^|"^^"_$zu(12)|SYS

#define IsEMSServerInstance 0
#define IsEMSServerContext 0
#define IsAnyGroupActive 0
#define	EMSCurrentGroupName ""
#define BACKETN d:+$g(^%EMSTrace)>=0 BACK^%ETN
#define EMSAuditGbl  ^|"^^"_$$$GetAuditDatabase|EMSAuditD
