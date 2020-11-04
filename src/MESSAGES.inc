ROUTINE MESSAGES [Type=INC]
 
#;=======================Maintenance========================*/
#;SML1013 03/28/08 Simon Li, Check offset and right link in bigstring block.
#;SML855  05/09/07 Simon Li, Check collate field in pointer and data blocks.
#;JO2057  7/17/06 Jeffrey Orlin, add StoredNextPtrIsWrong
#;LFT1116 8/15/03 Laura Tillem, add NotBigStringDataType and BlankLine
#;TCS001  6/18/03 Jeffrey Orlin, add ^%DB db size validation msgs 345 & 346
#;LFT1042 10/8/02 Laura Tillem, replace never used CacheTempAlreadyDefined 
#;                with GlobalAlreadyDefined
#;LFT975  8/02/02 Laura Tillem, add dismount message
#;LFT985  4/11/02 Laura Tillem, add map repair messages
#;LFT977  3/04/02 Laura Tillem, add %DMCONFIG messages, 336-340
#;STC278  8/15/01 Steve Clay, reserved #1024-2048 for Audit System
#;LFT948  7/10/01 Laura Tillem, add CreateGlobal messages, 333-335
#;LFT940  6/28/01 Laura Tillem, add DatabaseError,BlockNotInUse,
#;                change text of DatabaseNotAvailable from 
#;                "The database cannot be mounted."
#;LFT939  5/16/01 Laura Tillem, add SetCollationType message
#;STC273  4/28/01 Steve Clay, Initial version
#;=====================End Maintenance======================*/
 
#; This file is used to create the MESSAGES.INC file
 
#;The following is the 3 letter name (CAPS) for the locale which this file is defining.
 
#;locale "ENU"
 
#; --------------
#; DKIO errors: retain these exact error numbers to correspond with dkio.c
#; --------------
#define VolExists			1	
#define MapBlockReadFailed		2	
#define ErrWritingMapBlock		3	
#define CannotReadGloDirMapBlk		4	
#define CannotWriteGloDirMapBlk		5	
#define CannotWriteGloDirBlk		6	
#; open numbers 7-12  save for DKIO errors
#define CannotOpenNextVolume		13	
#define CannotReadNextVolMapBlk		14	
#define DirectoryNameTooLong		15	
#define NumMapsInvalid			16	
#define DatabaseSizeOutOfRange		17	
#define FailedToCreateNewVol		18	
#define AlreadyMounted			19	
#define FileExists			20	
#define FileCreateInProgress		21	
#define CurrentNumMapsTooSmall		22	
#define CannotExpandFile		23	
#define FileClusterMounted		24	
#define CannotAllocateCFN		25	
#define IncompatibleMountReq		26	
#define MgrCannotBeClusterMnt		27	
#define DatabaseInTransition		28	
#; open number 29  Save for DKIO error
#define SystemNotPartOfCluster		30	
#define CannotChangeModeOfMntDB		31	
#define NotSpaceForNewVol		32	
#define VolOverSysFileSizeLimit		33	
#define UnkErrWritingToNewVol		34	
#define DatabaseExpanding		35	
#define DatabaseNotMountable		36	
#define DBMountedElsewhere		37	
#define NoRoomInSecVolTable		38	
#define VolIsReadonly			39	
#define NoDeleteClusterMntDB		40	
#define DirectoryNotFound		41	
#define DatabaseNameInvalid		42	
#define WDFailedToSetRWFlag		43	
#define ExpansionFailedToStart		44	
#define SomeDBFilesNotDeleted		45	
#; open numbers 46-50 save for DKIO errors
#define UnkAndUnexpectedError		51	
#define InvalidArgument			52	
#define CannotOpenTarget		53	
#define CannotReadTarget		54	
#define CannotWriteToTarget		55	
#define DatabaseBeingRestored		56	
#define DatabaseDoesNotExist		57	
#define ReqTooManyBitmapBlks		58	
#define AllocateBitmapBlksFail		59	
#define TaskNeedsDismount		60	
#define TaskNeedsPrivateMount		61	
#define GlobalDirMustBeEmpty		62	
#define CannotCluMntCacheTemp		63	
#define CannotDismountCacheTemp		64	
#define CannotReinitMountedDatabase	65
#; open numbers 66-69 save for DKIO errors and more available above
#; These are the other o/s type DKIO messages
#define ErrorWhileFormatting		70	
#define NotOwner			71	
#define NoSuchRawDevice			72	
#define NoSuchDirectory			73	
#define IOError				74	
#define NoSuchDeviceOrAddress		75	
#define AccessToFileDenied		76	
#define DeviceOrResourceBusy		77	
#define UCFileExists			78	
#define NoSuchDeviceOrWrongUse		79	
#define FileTableOverflow		80	
#define TooManyOpenFiles		81	
#define ReadOnlyFileSystem		82	
#define ErrorCodeIs			83	
#;
#; end of DKIO messages
#; INTEGRIT messages
#; --------------
#define TopPointerLevelKB		101	
#define BottomPointerLevelKB		102	
#define PointerLevelKB			103	
#define TopBottomPointerLevelKB		104	
#define DataLevelKB			105	
#define TotalBlocksKB			106	
#define ElapsedTime			107	
#define ErrorTypeWithPtr		108	
#define ErrorWhile			109	
#define WrongLinkBlock			110	
#define NoView				111	
#define WhichIsFirst			112	
#define WhichHasLeft			113	
#define PtrBlkDegraded			114	
#define LowerDegraded			115	
#define FirstNodeRefTooLong		116	
#define FirstNodePtrWrong		117	
#define FirstNodeDoesNot		118	
#define FollowLastRef			119	
#define EqualExpectedRef		120	
#define LastLowerBlk			121	
#define WhichPntLower			122	
#define GlobalNotOK			123	
#define GlobalOK			124	
#define LowerWrongType			125	
#define ExpectedType			126	
#define PtrDidExpect			127	
#define PtrDidNotExpect			128	
#define BigButTypeInfo			129	
#define BigButBigCount			130	
#define SaysDoesNot			131	
#define SaysDoes			132	
#define LowerBlkInfoWrong		133	
#define LenZeroButIsRightLink		134	
#define LenPosButNoRightLink		135	
#define RefTooLong			136	
#define RefDescribed			137	
#define DoesNotFollowLastNode		138	 
#define DoesNotMatchNextLen		139	
#define LowerBlkHasNextLen		140	
#define LowerBlkHasNextOff		141	
#define ButNotData			142	
#define ButNotBigDB			143	
#define FoundSeekingBigStrings		144	
#define DataBlkBigCountIs		145	
#define ButBlkTypeSays			146	
#define ShouldBeBigStrings		147	
#define ShouldNotBeBigStrings		148	
#define DataBlkSyntaxError		150	
#define BigStringInfo			151	
#define MapBlkLabelError		152	
#define LowerBlkNotInMapBlk		153	
#define BigStringInBlk			154	
#define NotAllocInMapBlk		155	
#define PtrBlkEmpty			156	
#define LowerRtLinkRefDoesNot		157	
#define MatchExpectedNextRef		158	
#define ExpLastNodeCollateEarlier	159	
#define ExpectEqual			160	
#define LowerRtLinkRefIs		161	
#define PtrBlkNextRefIs			162	
#define PtrNodeRefDoesNotMatch		163	
#define FirstNodeOfLowerBlk		164	
#define LowerBlkFirstNodeIs		165	
#define BigDBRefShouldMatch		166	
#define RefNotMatchFirstBytes		167	
#define NotMatchNextPtrNode		168	
#define PtrNodeSaysBlkNumberIs		169	
#define OutOfRangeOfDataBase		170	
#define PtrBlkHasRightLink		171	
#define NotPresentOnDisk		172	
#define NotPtrBlkType			173	
#define TopBlkHasNoTopPtrBlkType	174	
#define LowerPtrBlkHasTopPtrBlkType	175	
#define BigStringsInBlkMB		176	
#define BigStringsInBlkKB		177	
#define DBNotAvailableBecause		178	
#define UnexpectedError			179	
#define ReportValue			180	
#define FurtherDirCheckAborted		181	
#define FurtherGloCheckAborted		182	
#define ContCheckWithNextPtrBlk		183	
#; REPAIR messages
#define DatabaseNotAvailable		184	
#define InsertedAtEnd			185	
#define ShouldNodeBeInThisBlock		186	
#define InsertedAtFront			187	
#define ChangeOtherBlocks		188	
#define InsertedAsNewNode		189	
#define OldNodesMovedUp			190      
#define NodeAlreadyExists		191	
#define NotEnoughRoomInBlock		192	
#define OldNodesMovedDown		193	
#define DeletedAtFront			194	
#define TypeInvalidForRepair		195	
#define OffsetImproper			196	
#define TopPointerLevelMB		197	
#define BottomPointerLevelMB		198	
#define PointerLevelMB			199	
#define TopBottomPointerLevelMB		200	
#define DataLevelMB			201     
#define TotalBlocksMB			202	
#define LowerBlkHasRightLink		203	
#define MapFreeCountOff			204	
#define IntegrityJobNotStarted		205	
#define StopIntegrityCheck		206	
#define StopDirectoryCheck		207	
#define StopGlobalCheck			208	
#define NotBigStringDataType		209
#define BlankLine			210
#; JO2057+
#; [more] INTEGRIT messages
#; --------------
#define StoredNextPtrIsWrong		250
#;SML855
#define MismatchCollate		252
#;SML1013+
#define BadOffsetInBigStringBlock	253
#define BadRightLinkInBigStringBlock	254
#;SML1013-
#; JO2057-
#;-----------------------------------------------------------------------------------------
#; general errors
#;-----------------------------------------------------------------------------------------
#define DatabaseNotMounted		300	
#define DatabaseHasDegradation		301	
#define DatabaseReadOnly		302	
#define PrimaryVolumeExists		303	
#define SecondaryVolumeExists		304	
#define ChooseDiffPrimaryLocation	305	
#define ChooseDiffSecondaryLocation	306	
#define CreatedButFailureToMountIs	307	
#define GlobalNotFound			308	
#define GlobalAlreadyDefined		309	
#define CacheTempCannotBeMgrDB		310	
#define FailedToDesignateCacheTemp	311	
#define FailedCacheTempSfnLookup	312	
#define ModifyFailedBecause		313	
#define NotADatabaseFile		314	
#define CreatedButNotFormatted		315	
#define CannotDeleteDatabaseBecause	316	
#define CannotDeleteDatabase		317	
#define NoLongStringInserts		318	
#define FailureToMountIs		317	
#define ErrorReclaimingRtnBlocks	318	
#define CompletedReclaimingRtnBlocks	319	
#define CreateFailedBecause		320	
#define FailedToSetKeepType		321	
#define NoNetworkForClusterMount	322	
#define ClusterMountFailed		323	
#define CorruptGlobalDirectory		324	
#define FailedToSetJournalType		325	
#define FailedToSetProtectState		326	
#define NoBuffersOfRequiredSize		327	
#define FailedToSetCollationType	328	
#define DatabaseError			329	
#define BlockNotInUse			330	
#define BadBlockVariable		331
#define BigStringBlockUseDump		332
#define GlobalExists			333
#define CannotCreateGlobal		334
#define GlobalIsRemote			335
#define NotALegalName			336
#define CannotWriteConfigFile		337
#define	InputFileError			338
#define CorruptConfigFile		339
#define FileNotFound			340
#define BlockNumberTooHigh		341
#define NotAMapBlock			342
#define MapBlockNumberIncorrect		343
#define 2kNotSupported			344
#define CannotDismountManagerDB		345
#define CannotModifyProperty		346
#define SizeMustBeGreaterOrEqual	347
#define	BadParameter			348
#define CannotAddVolUnlessDBExists	349
 
#;      ;TMS001+
#define InvalidDBSize                   350
#define CreateDBSizeNotAllowed          351
#;      ;TMS001-
 
#define NO				400	
#define YES				401	
#define NOAbreviated			402	
#define YESAbreviated			403	
#define YESNOAnswer			404	
 
#;-----------------------------------------------------------------------------------------
#; Used to help find untranslated messages
#;-----------------------------------------------------------------------------------------
#define UntranslatedMessage		1000	
 
#;-----------------------------------------------------------------------------------------
#; STC278 - Reserve 1024-2048 for Audit system
#;-----------------------------------------------------------------------------------------
#define AUDITMESSAGEOFFSET		1024		
#; Bits 0-31
#define AUDITON				1024		
#define AUDITSUSPEND			1025		
#define AUDITPAUSE			1026		
#define AUDITRESUME			1027		
 
#define AUDITCONSOLELOG			1030		
#define AUDITRETRY			1031		
#define AUDITHALT			1032		
 
#; Bits 32-63. USEREVENTS must be #32
#define AUDITUSEREVENTS			1056		
#define AUDITLOGIN			1057		
#define AUDITLOGOUT			1058		
 
#define AUDITSYSTEMEVENTCHG		1077		
#define AUDITPROCESSEVENTCHG		1078		
 
#; Bits 64-127
#define AUDITPMODE			1088		
#define AUDITDIRECTMODE			1089		
#define AUDITNSPCHG			1090		
 
#define AUDITLOCATION			2000		
#define AUDITINITIALIZE			2001		