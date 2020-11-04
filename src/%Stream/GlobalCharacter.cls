/// Stream class that stores character data in global nodes.
Class %Stream.GlobalCharacter Extends TmpCharacter [ System = 2 ]
{

Method %LoadData(id As %String) As %Status [ Private ]
{
	Set i%Id=id,i%NodeNo=0
	If i%%Location="" Set i%%Location=$$$streamGlobal

	If id="" {
		Set i%Mode=$$$modeREADNODATA,i%AtEnd=1,i%IOSize=0,i%MaxNodeNo=0
	} Else {
		#; Turn on batch mode so reading stream does not kill the cache
		Set batch=$zu(68,25,1)
		Set maxnode="",size=0,location=i%%Location
		If $data(@location@(id),maxnode)=10 Set maxnode=+$order(^(id,""),-1)
		#; read size from "0" node, if present, if not calculate it
		If maxnode'="",'$data(@location@(id,0),size) {
			Set size=0 For i=1:1:maxnode Set size=size+$length(^(i))
		}
		Set i%IOSize=size,i%AtEnd='size,i%Mode=$select(maxnode="":$$$modeREADNODATA,1:$$$modeREADNOTCHANGED),i%MaxNodeNo=+maxnode
		Do:batch=0 $zu(68,25,0)
	}
	Quit $$$OK
}

Method %SaveData(ByRef sid As %String) As %Status [ Private ]
{
	set tStatus = $$$OK, tLocked = 0
	#; save the stream;
	Set mode=i%Mode
	If mode=$$$modeREADNODATA||(mode=$$$modeREADNOTCHANGED)||(mode=$$$modeWRITEJUSTSAVED) Quit $$$OK
	try {
		#; Before changing anything we need to remember what the current state is in case of a rollback
		Kill i%rollback Set i%rollback("Buffer")=i%Buffer,i%rollback("Mode")=mode,i%rollback("MaxNodeNo")=i%MaxNodeNo
	
		#; Turn on batch mode so reading stream does not kill the cache
		Set batch=$zu(68,25,1)
		If mode=$$$modeWRITE||(mode=$$$modeREADBUFFER) { Set buffer=i%Buffer } Else { Set buffer="" }
		If i%%Location="" Set i%%Location=$$$streamGlobal
		Set location=i%%Location
		#; kill original data and save size in "0" node
		Set bufferlen=..#BUFFERLEN
		If bufferlen["," Set bufferlen=+$piece(bufferlen,",",$select($$$MaxLocalLength>32768:2,1:1))
		Set maxnodeno=i%MaxNodeNo+($length(buffer)+bufferlen-1\bufferlen),killdest=0
		#; allocate new stream no if needed
		If $$$streamTmpGlobalDefault {
			If i%Id="" {
				Set i%Id=$increment(@location)
			} Else {
				Set killdest=1
			}
			if ..%Concurrency {
				set tLockRef = ..%GetLockReference(location,i%Id)
				if tLockRef '= "" {
					lock +@(tLockRef):$$$LockTimeout if $test { set tLocked = 1 } else { set tLocked = 0 throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$LockFailedToAcquireExclusive,tLockRef)) }
				}
			}
			If killdest Do ..BuildValueArray(.subvalue)
		} ElseIf ..%Concurrency {
			#; Make sure we unlock when we are done, lock originally taken out in Write method
			set tLockRef = ..%GetLockReference(location,i%Id)
			If tLockRef'="" Set tLocked=1
		}
		Set sid=i%Id
		If killdest {
			If $data(@location@(sid)) Kill ^(sid)
			Set ^(sid)=maxnodeno,^(sid,0)=i%IOSize
		} Else {
			Set @location@(sid)=maxnodeno,^(sid,0)=i%IOSize
		}
		Set maxnodeno=i%MaxNodeNo
		Set movedata=0
		If i%TempGbl'="",$$$streamTmpGlobalDefault {
			Set tmpgbl=i%TempGbl,movedata=1
			For i=1:1:maxnodeno Set @location@(sid,i)=@tmpgbl@(i)
		}
		
		#; If in WRITE mode have to write out buffer, do not update i%MaxNodeNo here as we keep the temporary stream
		While buffer'="" {
			Set @location@(sid,$increment(maxnodeno))=..%LogicalToStorage($extract(buffer,1,bufferlen))
			Set buffer=$extract(buffer,bufferlen+1,*)
		}

		#; If we did not move the temp data we have to setup so next write will copy the permanent data to temp storage
		If 'movedata {
			#; Clear i%TempGbl so permanent location is not removed on stream close
			Set i%TempGbl=""
			If mode=$$$modeREADBUFFER {
				#; Can leave all settings the same
			} ElseIf mode=$$$modeWRITE {
				Set i%Mode=$$$modeWRITEJUSTSAVED
				Set i%NodeNo=0,i%Position=1,i%Buffer="",i%AtEnd=0
			} Else {
				#; As data did not move we must update i%MaxNodeNo as this is the max on disk
				Set i%MaxNodeNo=maxnodeno
				Set i%Mode=$$$modeREADNOTCHANGED
			}
		}

		#; Save the subvalue array for index updates
		If $data(subvalue) Merge ^||%isc.strv(..%Oid())=subvalue

		if tLocked { lock -@(tLockRef)#"I" }
		Do:batch=0 $zu(68,25,0)
	}
	catch tException {
		if $Get(tLocked) { lock -@(tLockRef)#"I" }
		set tStatus = tException.AsStatus()
	}
	Quit tStatus
}

ClassMethod %DeleteData(streamvalue As %String, concurrency As %Integer) As %Status [ Private ]
{
	Set root=$$$oidSysAd1(streamvalue)
	If $ascii(root)=0 Set root=$extract(root,2,*),root=$list(root)
	If root="" Set root=$$$streamGlobal
	Set node = $$$oidPrimary(streamvalue)
	Quit:(root="")||(node="") $$$OK
	if concurrency {
		set tLockRef = ..%GetLockReference(root,node)
		if tLockRef '= "" {
			lock +@(tLockRef):$$$LockTimeout if $test { set tLocked = 1 } else { quit $$$ERROR($$$LockFailedToAcquireExclusive,tLockRef) }
		}
	}
	else { set tLocked = 0 }
	Kill @root@(node)
	if tLocked { lock -@(tLockRef)#"I" }
	Quit $$$OK
}

/// Setup the TempGbl location of where we will write the temp stream to
Method SetupTmpGbl() [ Private ]
{
	If i%%Location="" Set i%%Location=$$$streamGlobal
	#; Optimistically write temp stream to permanent destination if location of stream is not the default and this is a new stream
	If i%%Location=$$$streamGlobal||(i%Id'="") {
		$$$streamInitTmpGlobal
	} Else {
		Set batch=$zu(68,25,1)
		Set i%Id=$increment(@i%%Location),tLocked=1
		if ..%Concurrency {
			set tLockRef = ..%GetLockReference(i%%Location,i%Id)
			if tLockRef '= "" {
				lock +@(tLockRef):$$$LockTimeout Set tLocked=$test
			}
		}
		If 'tLocked {
			$$$streamInitTmpGlobal
		} Else {
			Set i%TempGbl=$name(@i%%Location@(i%Id))
			Set journal=$zu(139,1)
			#; Dummy initial node count and size values to avoid block insert later, these will be overwritten on %Save by real values
			Set @i%TempGbl=0,^(i%Id,0)=999
			Do:journal=0 $zu(139,0)
		}
		Do:batch=0 $zu(68,25,0)
	}
}

Method CopyFromAndSave(source As %Stream.Object) As %Status
{
	Set sc=$$$OK
	
	#; Optimise for copy from one global to another
	If $classname(source)=$classname() {
		Set mode=source.Mode
		Set sourceGlvn=$S(mode=$$$modeREADCHANGED||(mode=$$$modeWRITE):source.TempGbl,mode=$$$modeREADNODATA||(mode=$$$modeREADBUFFER):"",1:$na(@(source.%Location)@(source.Id)))
		If mode=$$$modeWRITEJUSTSAVED {
			Set maxnodeno=+$get(@sourceGlvn)
		} Else {
			Set maxnodeno=source.MaxNodeNo
		}
		#; Update the last modified timestamp
		Set i%mLastModified=$ZTimeStamp

		#; Turn on batch mode so reading stream does not kill the cache
		Set batch=$zu(68,25,1)
		If i%TempGbl'="" {
			Set journal=$zu(139,1)
			Kill @i%TempGbl
			Do:journal=0 $zu(139,0)
			If '$$$streamTmpGlobalDefault,..%Concurrency {
				Set lockref = ..%GetLockReference(i%%Location,i%Id)
				If lockref'="" lock -@(lockref)#"I"
			}
			Set i%TempGbl=""
		}

		#; allocate new stream no if needed
		If i%Id="" Set i%Id=$increment(@i%%Location)
		If mode=$$$modeWRITE||(mode=$$$modeREADBUFFER) { Set buffer=source.Buffer } Else { Set buffer="" }

		#; kill original data and save size in "0" node
		Set bufferlen=..#BUFFERLEN
		If bufferlen["," Set bufferlen=+$piece(bufferlen,",",$select($$$MaxLocalLength>32768:2,1:1))
	
		Set location=i%%Location,id=i%Id
		If $data(@location@(id)) Kill ^(id)
		For i=1:1:maxnodeno Set @location@(id,i)=@sourceGlvn@(i)
		
		#; If in WRITE mode have to write out buffer
		While buffer'="" {	
			Set @location@(id,$increment(maxnodeno))=..%LogicalToStorage($extract(buffer,1,bufferlen))
			Set buffer=$extract(buffer,bufferlen+1,*)
		}
		Set i%MaxNodeNo=maxnodeno
		Set @location@(id)=maxnodeno,^(id,0)=source.Size
		Do:batch=0 $zu(68,25,0)
		Set i%Mode=$$$modeREADNOTCHANGED,i%IOSize=source.Size,i%Buffer=""
		#; Now copy the LineTerminator attribute
		Set ..LineTerminator=source.LineTerminator
		Set i%"%%OID"=..%Oid()

	} Else {
		Set sc=..Rewind() Quit:$$$ISERR(sc) sc
		Set sc=..CopyFrom(source) Quit:$$$ISERR(sc) sc
		Set sc=..%Save()
	}
	
	Quit sc
}

/// Return the size of the stream pointed to by soid
ClassMethod %ObjectSizeInternal(soid As %ObjectIdentity) As %Integer [ Private ]
{
	Set size=0
	Set location=$$$oidSysAd1(soid)
	Set:$ascii(location)=0 location=$list($extract(location,2,*))
	Set:location="" location=$$$streamGlobal
	Set loctmp=$$$oidPrimary(soid)
	Quit:location=""||(loctmp="") 0
		#; read size from "0" node, if present
	If $data(@location@(loctmp,0),size)#10=0 {
		Set size=##class(%Stream.Object)$this.%ObjectSizeInternal(soid)
	}
	Quit size
}

ClassMethod %LOBPrefetchInternal(soid As %ObjectIdentity, prefetchsize As %Integer, ByRef data As %String) As %Integer [ Private ]
{
	Set location=$$$oidSysAd1(soid)
	If $ascii(location)=0 { Set location=$list($extract(location,2,*)) }
	Set:location="" location=$$$streamGlobal
	Set loctmp=$$$oidPrimary(soid)
	Quit:location=""||(loctmp="") 0
		#; read size from "0" node, if present
	If $data(@location@(loctmp,0),size)#10=0 {
		Quit ##class(%Stream.Object)$this.%LOBPrefetchInternal(soid,prefetchsize,.data)
	}
	Quit:size>prefetchsize 0
	Set:$data(@location@(loctmp),maxnode)#10=0 maxnode=+$order(^(loctmp,""),-1)
	For i=1:1:maxnode {
		Set data=data_@location@(loctmp,i)
	}
	Quit $select(size=0:3,..IsCharacter():1,1:2)
}

}
