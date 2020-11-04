ROUTINE %occTransaction [Type=INC]
#; Cache' Objects - Transaction Macros
#define txSTATUS                        		%objtxSTATUS
#define txID									%objtxID
#define txSYSTRANID								%objtxTID
#define txLISTroot                      		%objtxLIST
#define txOIDASSIGNEDroot               		%objtxOIDASSIGNED
#define txOIDUNASSIGNEDroot             		%objtxOIDUNASSIGNED
#define txMODIFIEDroot                  		%objtxMODIFIED
  
#define txLIST(%oref)                   		%objtxLIST(+%oref)
#define txOIDASSIGNED(%oref)            		%objtxOIDASSIGNED(+%oref)
#define txOIDUNASSIGNED(%oref)          		%objtxOIDUNASSIGNED(+%oref)
#define txMODIFIED(%oref)               		%objtxMODIFIED(+%oref)
#define txPROPERTY(%oref,%property)				%objtxLIST(+%oref,%property)
 
#define txSIDlocal								##class(%SYS.System).InstanceGUID()
#define txNSIDlocal								$namespace
	#; System ID and Namespace ID from which this filing operation was triggered. This is the local system/namespace
	#; except when synchronizing from another system/namespace.
#define txSID									%objtxSID
#define txNSID									%objtxNSID
#define txGetSID								$g($$$txSID,$$$txSIDlocal)
#define txGetNSID								$g($$$txNSID,$$$txNSIDlocal)
	#; originating system id/namespace. This is the name of the system where this journaled filing op originated
	#; it is the local system/namespace except when synchronizing. In that case these are set to the corresponding values
	#; from the sync set.
#define txOSID									%objtxOSID
#define txONSID									%objtxONSID
#define txGetOSID								$g($$$txOSID,$$$txSIDlocal)
#define txGetONSID								$g($$$txONSID,$$$txNSIDlocal)
 
	#; No transaction active test
#define txNOTINTRAN                     		+$g(%objtxSTATUS)=0
	#; In tran but TP is OFF
#define txOFF                           		$g(%objtxSTATUS)=1
	#; In a transaction and TP is ON
#define txON                            		$g(%objtxSTATUS)=2
 
#define txGetSYSTRANID	($s($TLEVEL:##class(%SYS.Journal.Transaction).GetVirtualLocation(),1:""))
 
#define txNewJournalTran						i $$$txGetSYSTRANID'=$g($$$txSYSTRANID,0) { l +^OBJ.JournalT("NEW") s $$$txID=$i(^OBJ.JournalT) l +^OBJ.JournalT($$$txID) l -^OBJ.JournalT($$$txID) s $$$txSYSTRANID=$$$txGetSYSTRANID,^OBJ.JournalT($$$txID)=$lb("",$$$txSYSTRANID) l -^OBJ.JournalT("NEW")#"I" }
	#; Add an object to the transaction
#define txAddObject(%oref)						s:$$$txON $$$txLIST(%oref)=%oref
	#; Initialize the transaction state
#define txInitialize							k $$$txSTATUS,$$$txLISTroot,$$$txOIDASSIGNEDroot,$$$txOIDUNASSIGNEDroot,$$$txMODIFIEDroot k:'$TLevel $$$txSYSTRANID,$$$txID
	#; Begin a new transaction
#define txBeginTran								$$$txInitialize i '$zu(115,9) { s $$$txSTATUS=1 } else { TStart  s $$$txSTATUS=2 }
#define txBeginTranJrn							$$$txInitialize i '$zu(115,9) { s $$$txSTATUS=1 } else { TStart  $$$txNewJournalTran s $$$txSTATUS=2 }
	#; Begin a new transaction and add an object to it
#define txBeginTranObject(%oref)				$$$txInitialize i '$zu(115,9) { s $$$txSTATUS=1 } else { TStart  s $$$txSTATUS=2,$$$txLIST(%oref)=%oref }
#define txBeginTranObjectJrn(%oref)				$$$txInitialize i '$zu(115,9) { s $$$txSTATUS=1 } else { TStart  s $$$txSTATUS=2,$$$txLIST(%oref)=%oref $$$txNewJournalTran }
	#; Commit a transaction
#define txCommit								i $$$txOFF { k $$$txSTATUS } else { If $Tlevel { TCommit  } $$$txInitialize }
#define txCommitJrn								i $$$txOFF { k $$$txSTATUS } else { If $Tlevel { TCommit  } $$$txInitialize }
	#; Journal a filing operation
#define txJournal(%class,%jid,%id,%fileop)				$$$txNewJournalTran s %jid=$Increment(^OBJ.JournalT),^OBJ.JournalT($$$txID,%jid)=$lb(%id,%fileop,%class,$$$txGetSID,$$$txGetNSID,$$$txGetOSID,$$$txGetONSID,$$$txSYSTRANID)
	#;		The following macros are for journaling when an instance context is required
#define txJournalSave(%class,%jid,%id,%fileop,%guid)	$$$txNewJournalTran s %jid=$Increment(^OBJ.JournalT),^OBJ.JournalT($$$txID,%jid)=$lb(%id,%fileop,%class,$$$txGetSID,$$$txGetNSID,$$$txGetOSID,$$$txGetONSID,$$$txSYSTRANID,%guid) s:%guid'="" ^OBJ.GUID(0,%guid,%jid)=%fileop
#define txJournalDelete(%class,%jid,%id,%guid)			$$$txNewJournalTran s %jid=$Increment(^OBJ.JournalT),^OBJ.JournalT($$$txID,%jid)=$lb(%id,2,%class,$$$txGetSID,$$$txGetNSID,$$$txGetOSID,$$$txGetONSID,$$$txSYSTRANID,%guid)  if %guid'="" { s ^OBJ.GUID(0,%guid,%jid)=2 kill ^OBJ.GUID(1,%jid) }
	#; These macros journal not only the entry in the transaction journal but the complete object in the object journal
#define txJournalObjectDelete(%class,%jid,%id,%guid,%oref,%versionptr)		$$$txNewJournalTran s %jid=$Increment(^OBJ.JournalT),%versionptr=$method(%oref,"%JournalObject",$$$txID,%jid,2),^OBJ.JournalT($$$txID,%jid)=$lb(%id,2,%class,$$$txGetSID,$$$txGetNSID,$$$txGetOSID,$$$txGetONSID,$$$txSYSTRANID,%guid,%versionptr) if %guid'="" { s ^OBJ.GUID(0,%guid,%jid)=2 kill ^OBJ.GUID(1,%jid) }
#define txJournalObjectSave(%class,%jid,%id,%fileop,%guid,%oref,%versionptr)	$$$txNewJournalTran s %jid=$Increment(^OBJ.JournalT),%versionptr=$method(%oref,"%JournalObject",$$$txID,%jid,%fileop),^OBJ.JournalT($$$txID,%jid)=$lb(%id,%fileop,%class,$$$txGetSID,$$$txGetNSID,$$$txGetOSID,$$$txGetONSID,$$$txSYSTRANID,%guid,%versionptr) s:%guid'="" ^OBJ.GUID(0,%guid,%jid)=%fileop
	#; and these specifically for use in SQL triggers
#define txJournalSQLDelete(%class,%jid,%id,%guid,%oref,%versionptr)		$$$txNewJournalTran s %jid=$Increment(^OBJ.JournalT),%versionptr=$method(%oref,"%JournalObject",$$$txID,%jid,2,1,""),^OBJ.JournalT($$$txID,%jid)=$lb(%id,2,%class,$$$txGetSID,$$$txGetNSID,$$$txGetOSID,$$$txGetONSID,$$$txSYSTRANID,%guid,%versionptr) if %guid'="" { s ^OBJ.GUID(0,%guid,%jid)=2 kill ^OBJ.GUID(1,%jid) }
#define txJournalSQLSave(%class,%jid,%id,%fileop,%guid,%oref,%versionptr)	$$$txNewJournalTran s %jid=$Increment(^OBJ.JournalT),%versionptr=$method(%oref,"%JournalObject",$$$txID,%jid,%fileop,1,$Get(%e)),^OBJ.JournalT($$$txID,%jid)=$lb(%id,%fileop,%class,$$$txGetSID,$$$txGetNSID,$$$txGetOSID,$$$txGetONSID,$$$txSYSTRANID,%guid,%versionptr) s:%guid'="" ^OBJ.GUID(0,%guid,%jid)=%fileop
 
 	#; Rollback a transaction
#define txRollback(%sc)							i $$$txON { s %sc=$$$ADDSC(%sc,$$%TRollBack^%occTransaction()) k $$$txSYSTRANID,$$$txID } else { k $$$txSTATUS }
#define txRollbackJrn(%sc)						i $$$txON { s %sc=$$$ADDSC(%sc,$$%TRollBack^%occTransaction()) k $$$txSYSTRANID,$$$txID } else { k $$$txSTATUS }
	#; Remove an object from the transaction
#define txRemoveObject(%oref)					k:$$$txON $$$txLIST(%oref),$$$txMODIFIED(%oref)
 
#define txAssignOID(%oref)						s:$$$txON $$$txOIDASSIGNED(%oref)=""
#define txSaveModStateIfModified(%oref)			i ($$$txON)&&(%oref.%IsModified()) { Set $$$txMODIFIED(%oref)=$system.CLS.GetModifiedBits(%oref) }
#define txSaveModState(%oref)					i $$$txON { Set $$$txMODIFIED(%oref)=$system.CLS.GetModifiedBits(%oref) }
#define txUnAssignOID(%oref,%oid)				s:$$$txON $$$txOIDUNASSIGNED(%oref)=%oid,$$$txLIST(%oref)=%oref
#define txUnAssignOIDSaveModState(%oref,%oid)	i $$$txON { s $$$txOIDUNASSIGNED(%oref)=%oid,$$$txLIST(%oref)=%oref Set $$$txMODIFIED(%oref)=$system.CLS.GetModifiedBits(%oref) }

#define DSTIME(%class,%id,%fileop)						set ^OBJ.DSTIME(%class,$Get(^OBJ.DSTIME,0),%id)=%fileop

/// DSTIMEH is the macro for DSTIME=TIME. Arguments are:
///	%class - the type class of the object identified by %id
/// %id	- the object id
///	%fileop - 0, 1, 2 meaning INSERT, UPDATE, DELETE
///	%interval - the time interval (DSTIMEINTERVAL parameter)
/// %time - a local variable to use in the DSTIME computation
/// %ts - a local variable to use in the DSTIME computation
#define DSTIMEH(%class,%id,%fileop,%interval,%time,%ts)	set %time=$zts,%ts=$p(%time,",",2),%time=(%time*86400+%ts)\%interval*%interval,^OBJ.DSTIME(%class,%time,%id)=%fileop