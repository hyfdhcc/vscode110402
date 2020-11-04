ROUTINE %LMF [Type=INC]
#;LMF     ;Include file for License (LMF*) utilities.	;RJW2386 10/29/12
#ifndef LMFINC
#define LMFINC
  
#if 0   /*=======================Maintenance========================*/
#;RJW2386 12/16/15 Ron Watt, Add license feature bits to enable sharding. 
#;RJW2076 10/29/12 Ron Watt, $System.License.CheckKeyForUpgrade() method to prevent upgrade problems
#;RJW2038 07/31/12 Ron Watt, Add DeepSee Visual Reporting license bits.
#;RJW2024 07/02/12 Ron Watt, Extreme Licensing may have unlimited users 
#;RJW2025 06/27/12 Ron Watt, New license feature for DeepSee Reports
#;RFD687  10/28/11 Rob Davis, add Real Time Elite product
#;RJW1966 10/27/11 Ron Watt, Provide support for input of TrakCare license key in SMP.
#;RJW1963 10/25/11 Ron Watt, Add HealthShare Foundation and C-Type features to Cache license key. 
#;RJW1914 06/22/11 Ron Watt, Support 2011 revisions to DeepSee licensing.
#;RJW1841 08/11/10 Ron Watt, Revise license Id format rule.
#;RJW1731 08/11/09, Ron Watt, License feature macro definitions for documentation
#;RJW1528 02/14/08, Ron Watt, DecodeW^%SYS.LICENSE should report errors.
#;RJW1185 09/23/05, Ron Watt, Add Real Time and Web add on capability to cache license keys
#;RJW1013 01/07/05 Ron Watt, %System.License.SaveLicenseKey() 
#;RJW516 12/13/01, Ron Watt, Add capability query functions to ^%LICENSE.
#;RJW503 11/21/01, Ron Watt,  Activate new license key format.
#;RJW490 09/20/01, Ron Watt, New license model for Cache 4.2.
#;RJW489 06/21/01, Ron Watt, Fix <UNDEF> in license server returning multiuser clients license.
#;SML104 03/30/01 Simon Li, Fix fail over problem when master server is powered down.
#;RJW408 09/05/00, Ron Watt, New metered CSP licensing functions.
#;RJW411 07/24/00 Ron Watt: Add support for Premier and Corporate license types.
#;RJW144 05/28/98 Ron Watt: Background license changes.
#endif  /*=====================End Maintenance======================*/
 
#;define lmfdebug
#;define dsm_build
#if 1	;RJW490, RJW503+
#define USEV42KEY
#;      ;RJW516+
#define KEYPOSCAPACITY 1
#define	KEYPOSCUSTOMER 2
#define KEYPOSORDER 3
#define KEYPOSEXPIRATION 4
#define KEYPOSPAK 5
#define KEYPOSMACHINEID 6
#define	KEYOFFPRODUCT 1
#define KEYOFFTYPE 2
#define KEYOFFSERVER 3
#define KEYOFFPLATFORM 4,5
#define	KEYOFFUNITS 6,11
#define KEYOFFENFORCED 12,17
#define	KEYCPULICENSED 18,22
#define KEYCPUENFORCED 23,27
#define	KEYMINLENGTH 38
#define KEYFEATURES 39,46
#define	KEYPRODUCTNAMES "Evaluation,Entree,Elite,Executive,Enterprise,Edge,Extreme,Real Time Elite"
#define	KEYLICENSENAMES "Concurrent User,Named User,Power Unit,Real Time"
#define	KEYSERVERNAMES "Single,Single,Multi"
#;      ;RJW516-
#endif	;RJW490-
#;	RJW1013+
#define KEYTAGCAPACITY "LicenseCapacity"
#define	KEYTAGCUSTOMER "CustomerName"
#define KEYTAGORDER "OrderNumber"
#define KEYTAGEXPIRATION "ExpirationDate"
#define KEYTAGPAK "AuthorizationKey"
#define KEYTAGMACHINEID "MachineID"
#define KEYTAGECAPACITY "LicenseCapacity="
#define	KEYTAGECUSTOMER "CustomerName="
#define KEYTAGEORDER "OrderNumber="
#define KEYTAGEEXPIRATION "ExpirationDate="
#define KEYTAGEPAK "AuthorizationKey="
#define KEYTAGEMACHINEID "MachineID="
#define KEYTAGSTRAKCARE $lb("Foundation Product=","Facility Name=","Facility Class=","Concurrent Users=","AddOn:Billing=","AddOn:Emergency Department=","AddOn:Maternity=","AddOn:Operating Theater=","AddOn:Active Decision Support=","AddOn:Radiology=","AddOn:Allied Health=","AddOn:Prescribing & Pharmacy=","AddOn:Business Intelligence=","AddOn:EPR connectivity=","AddOn:Lab Instruments=")
#;	RJW1013-
#define USEENCRYPT
#define CSPPOSVERSION 1
#define CSPPOSLBD 2
#define CSPPOSLMR 3
#define CSPPOSCMR 4
#define CSPPOSORD 5
#define CSPPOSCUS 6
#define CSPPOSPAK 7
#define CSPSUBLBD 3
#define CSPSUBLMR 2
#define CSPSUBCMR 1
#define CSPSUBORD 4
#define CSPSUBCUS 5
#define CSPSUBPAK 6
#define CSPVERSION 1
#;      ;RJW408-
#;      ;RJW411+
#define EPL3
#;      ;RJW411-
#;      ;SML104+
#define SETWAKEBACKUP  d $zu(69,25,1)
#define CLRWAKEBACKUP  d $zu(69,25,0)
#define CHKWAKEBACKUP  $zu(69,25)
#;      ;SML104-
#; RJW1731+
#; License feature tests.  Returns 1 if authorized, 0 if not.
#define LicenseFeatureWebAddon ##class(%SYSTEM.License).GetFeature(0)
#define LicenseFeatureEnsemble ##class(%SYSTEM.License).GetFeature(1)
#define LicenseFeatureShadowing ##class(%SYSTEM.License).GetFeature(2)
#define LicenseFeatureBIUser ##class(%SYSTEM.License).GetFeature(3)
#define LicenseFeatureBIDevelopment ##class(%SYSTEM.License).GetFeature(4)
#define LicenseFeatureHealthShare ##class(%SYSTEM.License).GetFeature(5)
#define LicenseFeatureTrakCare ##class(%SYSTEM.License).GetFeature(6)
#define LicenseFeatureIPNeutral ##class(%SYSTEM.License).GetFeature(7)
#define LicenseFeatureDeepSeeRun ##class(%SYSTEM.License).GetFeature(8)
#define LicenseFeatureDeepSeeAnalyze ##class(%SYSTEM.License).GetFeature(9)
#define LicenseFeatureDeepSeeModel ##class(%SYSTEM.License).GetFeature(10)
#define LicenseFeatureiKnow ##class(%SYSTEM.License).GetFeature(11)
#define LicenseFeatureHealthShareFoundation ##class(%SYSTEM.License).GetFeature(12)
#define LicenseFeatureCType ##class(%SYSTEM.License).GetFeature(13)
#define LicenseFeatureDeepSeeVRExecution ##class(%SYSTEM.License).GetFeature(14)
#define LicenseFeatureExtremeNoUserLimit ##class(%SYSTEM.License).GetFeature(15)
#define LicenseFeatureDeepSeeVRFormatDef ##class(%SYSTEM.License).GetFeature(16)
#define LicenseFeatureDeepSeeVRDataDef ##class(%SYSTEM.License).GetFeature(17)
#define LicenseFeatureShardMasterServer ##class(%SYSTEM.License).GetFeature(18)
#define LicenseFeatureShardWorkerServer ##class(%SYSTEM.License).GetFeature(19)
#; Feature bit values
#define LicenseBitWebAddOn 0
#define LicenseBitEnsemble 1
#define LicenseBitShadowing 2
#define LicenseBitBIUser 3
#define LicenseBitBIDevelopment 4
#define LicenseBitHealthShare 5
#define LicenseBitTrakCare 6
#define LicenseBitIPNeutral 7
#;	RJW1731-
#;	RJW1914+
#define LicenseBitDeepSeeRun 8
#define LicenseBitDeepSeeAnalyze 9
#define LicenseBitDeepSeeModel 10
#define LicenseBitiKnow 11
#;	RJW1914-
#define LicenseBitHealthShareFoundation 12
#define LicenseBitCType 13
#define LicenseBitDeepSeeVRExecution 14
#define LicenseBitExtremeNoUserLimit 15
#define LicenseBitDeepSeeVRFormatDef 16
#define LicenseBitDeepSeeVRDataDef 17
#define LicenseBitShardMasterServer 18
#define LicenseBitShardWorkerServer 19
#define FeatureBitNames "WebAddOn,Ensemble,Shadowing,BIUser,BIDevelopment,HealthShare,TrakCare,IPNeutral,DeepSeeRun,DeepSeeAnalyze,DeepSeeModel,iKnow,HealthShareFoundation,CType,DeepSeeVRExecution,ExtremeNoUserLimit,DeepSeeVRFormatDef,DeepSeeVRDataDef,ShardMasterServer,ShardWorkerServer"
#endif  /* LMFINC */
