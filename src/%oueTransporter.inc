ROUTINE %oueTransporter [Type=INC]
#; %oueTransporter.inc
resolveKey(%pExtent,pID,pDest,pUnresolved) public {
	new %tKeyVal, %tID
	if (pID = "") || (%pExtent = "") { quit "" }
		#; Check to see if this OID has already been resolved. @pDest@("r") is supposed to be killed
		#; when the transporter is received at the destination. It isn't ever set by the origination site
		#; but we support transporter "hops" - origination A->destination B->destination C. In a 'hop', the
		#; origination of 'C' is 'B'. In that case, an inadvertent export of 'r' could occur.
	if $Data(@pDest@("r",%pExtent,pID),tOID) { quit tOID }
		#; The object had better exist here. If not, we have a corrupt Transport
	set tKey = $Get(@pDest@("o",%pExtent,pID))
		#; tKey = $ListBuild(<depth>,<transporterObjectId>,<OID>,<keyname>,<keyvalue>)
	if tKey '= "" {
		set tKeyName = $List(tKey,4), %tKeyVal = $List(tKey,5)
			#; if no KeyName exists for id abstraction then what can we do?? Assume the key is the OID and the key value is the OID value
		if tKeyName = "" {
			set tOID = $ListGet(tKey,3)
			if tOID { set pUnresolved(+$ListGet(tKey,1),%pExtent,pID) = "" }
			else {
					#; and save the fact that we've done this before
				set @pDest@("r",%pExtent,pID) = tOID
			}
		}
		else {
			set tKeyExec = "$classmethod(%pExtent," _ $$$QN(tKeyName _ "Exists")_ ",$lg(%tKeyVal,1)"
			for tPtr = 2:1:$ListLength(%tKeyVal) { set tKeyExec = tKeyExec _ ",$lg(%tKeyVal," _ tPtr }
			set tKeyExec = tKeyExec _ ",.%tID)"
			if @tKeyExec {
				set tOID = $$$oidCompose(%tID,$$$oidClassName($List(tKey,3)))
					#; and save the fact that we've done this before
				set @pDest@("r",%pExtent,pID) = tOID
			}
				#; Unresolved contains a first level subscript equal to the depth flag for a referenced object
				#; A depth of 0 indicates a key entry only and that object will never resolve if it isn't already
				#; present at the destination.
			else { set tOID = "", pUnresolved(+$ListGet(tKey,1),%pExtent,pID) = "" }
		}
	}
		#; This is a corrupt transport container - the referenced key isn't even present. This reference will never resolve
	else { set tOID = "", pUnresolved(0,%pExtent,pID) = "" }
	quit tOID
}
  
resolveStream(pObject,pStreamOID,pDest, pUnresolved,pTransporter) public {
	if (pStreamOID '= "") && ($Data(@pDest@("o","%Stream.Object",pStreamOID),tKeyData)) {
		set tDestPtr = $List(tKeyData,2), tProperty = $List(tKeyData,4)
		set tStream = $zobjproperty(pObject,tProperty)
		set tSC = tStream.SyncStreamIn(pTransporter,tDestPtr,tProperty)
		set tSC = tStream.%Save()
		set tStreamOID = tStream.%Oid()
	}
	else { set tStreamOID = "" }
	quit tStreamOID
}
 