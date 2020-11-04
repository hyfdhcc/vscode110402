Include %occStream

/// Temporary character stream. Any calls to save this just return without doing any work.
Class %Stream.TmpCharacter Extends %Stream.Object [ ClientDataType = CHARACTERSTREAM, OdbcType = LONGVARCHAR, System = 2 ]
{

Property Mode As %Integer [ InitialExpression = 0, Private ];

/// Number of characters that we are storing in each global node
/// If this includes a ',' then format size on non-long string then size on long string enabled system
Parameter BUFFERLEN = "32656,32656";

/// Where we write the temp data to
Property TempGbl As %String [ Private, Transient ];

/// Maximum subscript in data we are reading
Property MaxNodeNo As %Integer [ InitialExpression = 0, Private, Transient ];

/// The current node we are reading from
Property NodeNo As %String(MAXLEN = 5000) [ InitialExpression = 0, Private, Transient ];

Property Buffer As %Binary(MAXLEN = "") [ Private, Transient ];

Property rollback As %String [ MultiDimensional, Private ];

Property Position As %Integer [ InitialExpression = 1, Private, Transient ];

Property IOSize As %Integer [ InitialExpression = 0, Private ];

/// Type of line terminator we use for this stream, defaults to Cr/Lf. Maximum length is 10 characters.
Property LineTerminator As %String(MAXLEN = 10) [ InitialExpression = {$char(13,10)}, Transient ];

/// If true then remove the permanent global as well as any temp global when this object is closed
/// If you call %Save on a stream where RemoveOnClose is true it will set this to false as if you
/// explicitly save the stream you no longer want it to be removed when the object is closed. In order
/// to make sure %Save always runs the logic to reset the flag setting this to true 
/// causes %IsModified/%ObjectModified to return true.
Property RemoveOnClose As %Boolean [ InitialExpression = 0, Transient ];

Method %NormalizeObject() As %Status [ CodeMode = expression ]
{
$$$OK
}

Method %ValidateObject(force As %Integer = 0) As %Status [ CodeMode = expression ]
{
$$$OK
}

Property mLastModified As %String [ Private, Transient ];

/// Returns true if this is a "NULL" stream; that is, a stream which has never 
/// been written to and saved. This is used by the Cach&eacute; ODBC server.
Method IsNull() As %Boolean [ CodeMode = call ]
{
..%IsNull()
}

/// Returns true if this is a "NULL" stream; that is, a stream which has never 
/// been written to and saved. This is used by the Cach&eacute; ODBC server.
Method %IsNull() As %Boolean [ CodeMode = expression ]
{
..Mode=$$$modeREADNODATA
}

Method LastModifiedGet() As %TimeStamp [ CodeMode = expression, Final ]
{
$zdt($select(i%mLastModified="":$ZTimeStamp,1:i%mLastModified),3)
}

Method %OnNew(initval As %String = "") As %Status [ Private ]
{
	Set i%%Location=$select(initval="":$$$streamGlobal,1:initval)
	Quit $$$OK
}

Method %OnClose() As %Status [ Private ]
{
	If i%RemoveOnClose,i%Id'="",$data(@i%%Location@(i%Id)) Kill ^(i%Id)
	If i%TempGbl'="" {
		If $data(@i%TempGbl) Kill @i%TempGbl
		If '$$$streamTmpGlobalDefault,..%Concurrency {
			Set lockref = ..%GetLockReference(i%%Location,i%Id)
			If lockref'="" lock -@(lockref)#"I"
		}
		Set i%TempGbl=""
	}
	If ..%Locked { Do ..%UnlockStream(1) }
	Quit $$$OK
}

Method %LoadData(id As %String) As %Status [ Private ]
{
	Set i%%Location=$$$streamGlobal
	$$$streamInitTmpGlobal
}

Method %OnRollBack() As %Status [ Private ]
{
	If $data(i%rollback) {
		Set i%Buffer=i%rollback("Buffer"),i%Mode=i%rollback("Mode"),i%MaxNodeNo=i%rollback("MaxNodeNo")
		Set batch=$zu(68,25,1),journal=$zu(139,1)
		If i%TempGbl="" {
			$$$streamInitTmpGlobal
		} Else {
			Kill @i%TempGbl
		}
		For i=1:1:i%MaxNodeNo Set @i%TempGbl@(i)=@i%%Location@(i%Id,i)
		Kill i%rollback
		Do:batch=0 $zu(68,25,0) Do:journal=0 $zu(139,0)
	}
	Quit $$$OK
}

Method %SaveData(ByRef sid As %String) As %Status [ Private ]
{
	Quit $$$OK
}

ClassMethod %DeleteData(streamvalue As %String, concurrency As %Integer) As %Status [ Private ]
{
	Quit $$$OK
}

/// Returns the global reference used to lock the current stream object
/// Throws %Exception.AbstractException
ClassMethod %GetLockReference(pLocation As %String(MAXLEN="") = "", pId As %String(MAXLEN="") = "") As %String(MAXLEN="") [ Private ]
{
	if (pId '= "") && (pLocation '= "") { quit $na(@pLocation@(pId)) }
	quit ""
}

Method %OnConstructClone(object As %RegisteredObject, deep As %Boolean = 0, ByRef cloned As %String) As %Status [ Private ]
{
	Set mode=i%Mode
	If mode=$$$modeREADNODATA Quit $$$OK
	try {
		Set i%TempGbl="",i%Id="",i%%Locked=0,concurrency=i%%Concurrency,i%%Concurrency=0
		if mode = $$$modeREADNOTCHANGED||(mode=$$$modeWRITEJUSTSAVED) {
			set glv=$na(@(object.%Location)@(object.Id))
			If mode=$$$modeWRITEJUSTSAVED Set i%MaxNodeNo=+$get(@glv)
		} else {
			set glv = object.TempGbl
		}
		If glv'="",i%MaxNodeNo>0 {
			Do ..SetupTmpGbl()
			Set batch=$zu(68,25,1),journal=$zu(139,1)
			For i=1:1:i%MaxNodeNo Set @i%TempGbl@(i)=@glv@(i)
			Do:batch=0 $zu(68,25,0) Do:journal=0 $zu(139,0)
		}
		If mode=$$$modeREADNOTCHANGED||(mode=$$$modeWRITEJUSTSAVED) Set i%Mode=$$$modeREADCHANGED
		set tStatus = $$$OK
	} catch tExceptionOuter {
		set tStatus = tExceptionOuter.AsStatus()
	}
	Set i%%Concurrency=concurrency
	Quit tStatus
}

Method Read(ByRef len As %Integer, ByRef sc As %Status) As %CacheString
{
	Set sc=$$$OK,haslen=$data(len)#10,out=""
	Set mode=i%Mode
	If mode=$$$modeREADNODATA Set i%AtEnd=1,len=-1 Quit ""
	#; Mode $$$modeWRITE: in middle of Write with no rewind; automatically rewind
	If mode=$$$modeWRITE||(mode=$$$modeWRITEJUSTSAVED) Set sc=..Rewind() If $$$ISERR(sc) Quit ""
	If i%AtEnd Set len=-1 Quit ""
	
	If 'haslen||(len>$$$MaxLocalLength) Set len=$$$MaxLocalLength
	try {
		#; try to read from i%Buffer
		Set done=0
		For {
			#; do we need to read another chunk from global
			If i%Position>$length(i%Buffer),..ReadIntoBuffer()=0 Quit
			Set needed=len-$length(out)
			If i%Position=1,needed'<$length(i%Buffer) {
				Set out=out_i%Buffer
			} Else {
				Set out=out_$extract(i%Buffer,i%Position,i%Position+needed-1)
			}
			Set i%Position=i%Position+needed
			If ('haslen&&(out'=""))||($length(out)'<len) Quit
		}
		#; Fill the buffer here so we can set AtEnd flag without another round trip
		If 'i%AtEnd,i%Position>$length(i%Buffer) Do ..CheckAtEnd()
	
		#;if we are at the end with no data return -1
		Set len=$select((i%AtEnd=1)&($length(out)=0):-1,1:$length(out))
	} catch tException {
		set sc = tException.AsStatus()
		RETURN $g(out)	// out may be <UNDEFINED> if the error was <STORE>
	}
	Quit out
}

Method ReadLine(ByRef len As %Integer = 32000, ByRef sc As %Status, ByRef eol As %Boolean) As %CacheString
{
	Set sc=$$$OK,eol=0
	Set mode=i%Mode
	If mode=$$$modeREADNODATA Set i%AtEnd=1,len=-1 Quit ""
		
	#; Mode $$$modeWRITE: in middle of Write with no rewind; automatically rewind
	If mode=$$$modeWRITE||(mode=$$$modeWRITEJUSTSAVED) Set sc=..Rewind() If $$$ISERR(sc) Quit ""
	If i%AtEnd Set len=-1 Quit ""
	#; try to read from i%Buffer
	Set done=0,out="",terminator=..LineTerminator
	#; Leave space to add the terminator at the end of the buffer
	Set:len>($$$MaxLocalLength-$length(terminator)) len=$$$MaxLocalLength-$length(terminator)
	try {
		For {
			#; do we need to read another chunk from global
			If i%Position>$length(i%Buffer),..ReadIntoBuffer()=0 Quit
			If out="" {
				Set found=$find(i%Buffer,terminator,i%Position)
				If found,found-i%Position'>(len+$length(terminator)) {
					Set out=$extract(i%Buffer,i%Position,found-$length(terminator)-1)
					Set i%Position=found
					Set eol=1
					Quit
				} Else {
					Set out=$extract(i%Buffer,i%Position,i%Position+len-1)
					Set i%Position=i%Position+len
					If $length(out)'<len Quit
				}
			} Else {
				#; Need to allow for the line terminator to be at the end of the current read section
				Set needed=len-$length(out),out=out_$extract(i%Buffer,i%Position,i%Position+needed-1+$length(terminator))
				Set found=$find(out,terminator)
				If found {
					#; Set the current position just after the terminator, set the output to the text just before the terminator
					#; (len-needed) give me the previous length of 'out' before we appended more data to it.
					Set i%Position=i%Position+found-1-(len-needed)
					Set out=$extract(out,1,found-$length(terminator)-1)
					Set eol=1
					Quit
				} Else {
					Set i%Position=i%Position+needed
					If $length(out)'<len Quit
				}
			}
		}
		#; See if we are at the end to avoid a round trip
		If 'i%AtEnd,i%Position>$length(i%Buffer) Do ..CheckAtEnd()
	} catch tException {
		Set sc=tException.AsStatus()
		Return ""
	}
	#;if we are at the end with no data return -1
	If i%AtEnd=1,out="" {
		Set len=-1
		Return ""
	} ElseIf $length(out)>len {
		Return $extract(out,1,len)
	} Else {
		Set len=$length(out)
		Return out
	}
}

/// This reads from the stream until it find the <property>LineTerminator</property> and returns
/// this as a stream. If the stream does not contain the line terminator this can potentially be the
/// entire stream.
Method ReadLineIntoStream(ByRef sc As %Status) As %Stream.Object
{
	Set sc=$$$OK,stream=..%New()
	Set mode=i%Mode
	If mode=$$$modeREADNODATA Set i%AtEnd=1 Quit stream
	
	#; Mode $$$modeWRITE: in middle of Write with no rewind; automatically rewind
	If mode=$$$modeWRITE||(mode=$$$modeWRITEJUSTSAVED) Set sc=..Rewind() If $$$ISERR(sc) Quit ""
	If i%AtEnd Set len=-1 Quit ""

	#; try to read from i%Buffer
	Set done=0,out="",terminator=..LineTerminator
	try {
		For  Do  Quit:done
		#; do we need to read another chunk from global
		. If i%Position>$L(i%Buffer),..ReadIntoBuffer()=0 Set done=1 Quit
		#; Need to allow for the line terminator to be at the end of the current read section
		. Set needed=$$$MaxStringLength-$L(out),out=out_$E(i%Buffer,i%Position,i%Position+needed-1+$L(terminator))
		. Set found=$F(out,terminator)
		. If found Do  Quit
		#; Set the current position just after the terminator, set the output to the text just before the terminator
		#; (len-needed) give me the previous length of 'out' before we appended more data to it.
		. . Set i%Position=i%Position+found-1-($$$MaxStringLength-needed)
		. . Set out=$E(out,1,found-$L(terminator)-1)
		. . Set done=1
		. Set i%Position=i%Position+needed
		. Do stream.Write($extract(out,1,$length(out)-$length(terminator)+1)) Set out=$extract(out,$length(out)-$length(terminator)+2,*)
		#; See if we are at the end to avoid a round trip
		If 'i%AtEnd,i%Position>$length(i%Buffer) Do ..CheckAtEnd()
		Do:out'="" stream.Write(out)
	} catch tException {
		set sc = tException.AsStatus()
	}
	Quit stream
}

Method Write(data As %CacheString = "") As %Status
{
	#; Mode = $$$modeREADNODATA,$$$modeREADNOTCHANGED: set up for write, rewind
	Set mode=i%Mode
	If mode'=$$$modeWRITE {
		If mode=$$$modeWRITEJUSTSAVED {
			Set sc=..MoveToEnd() If $$$ISERR(sc) Quit sc
		} Else {
			If mode'=$$$modeREADNODATA,i%TempGbl'="" {
				Set batch=$zu(68,25,1),journal=$zu(139,1)
				Kill @i%TempGbl
				Do:batch=0 $zu(68,25,0) Do:journal=0 $zu(139,0)
			}
			Set i%Mode=$$$modeWRITE,i%IOSize=0,i%MaxNodeNo=0,i%NodeNo=0,i%Buffer="",i%Position=1
		}
	}
	
	#; a write is never at the end
	Set datalen=$length(data),i%AtEnd=0,i%IOSize=i%IOSize+datalen,i%mLastModified=$ZTimeStamp
	
	#; if it fits, append data to Buffer
	Set bufferlen=..#BUFFERLEN
	If bufferlen["," Set bufferlen=+$piece(bufferlen,",",$select($$$MaxLocalLength>32767:2,1:1))
	Set bufneed=bufferlen-$Length(i%Buffer)
	If bufneed>datalen {
		Set i%Buffer=i%Buffer_data
	} Else {
		#; otherwise store Buffer to global
		If i%TempGbl="" Do ..SetupTmpGbl()
		Set batch=$zu(68,25,1),journal=$zu(139,1)
		If bufneed=bufferlen {
			If bufneed=datalen {
				Set @i%TempGbl@($increment(i%MaxNodeNo))=..%LogicalToStorage(data)
			} Else {
				Set @i%TempGbl@($increment(i%MaxNodeNo))=..%LogicalToStorage($extract(data,1,bufneed))
			}
		} Else {
			Set @i%TempGbl@($increment(i%MaxNodeNo))=..%LogicalToStorage(i%Buffer_$extract(data,1,bufneed))
		}
		While datalen-bufneed'<bufferlen {
			Set ^($increment(i%MaxNodeNo))=..%LogicalToStorage($extract(data,bufneed+1,bufneed+bufferlen)),bufneed=bufneed+bufferlen
		}
		Do:batch=0 $zu(68,25,0) Do:journal=0 $zu(139,0)
		Set i%Buffer=$extract(data,bufneed+1,*)
	}
	Quit $$$OK
}

/// Setup the TempGbl location of where we will write the temp stream to
Method SetupTmpGbl() [ Private ]
{
	$$$streamInitTmpGlobal
	Set i%%Location="^||%Stream.tmp"
}

/// Appends the string <var>data</var> along with a line terminator to the stream and advances the 
/// current stream position by the number of characters in <var>data</var> plus the line terminator.
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
Method WriteLine(data As %CacheString = "") As %Status
{
	If $length(data)+$length(..LineTerminator)>$$$MaxLocalLength {
		Set sc=..Write(data)
		If $$$ISOK(sc) Set sc=..Write(..LineTerminator)
	} Else {
		Set sc=..Write(data_..LineTerminator)
	}
	Quit sc
}

Method MoveToEnd() As %Status
{
	#; If no data or in write mode already nothing to do
	Set mode=i%Mode
	If (mode=$$$modeREADNODATA)||(mode=$$$modeWRITE) Quit $$$OK
	
	#; Copy the permanent data into temporary structure ready for appending
	If mode=$$$modeREADNOTCHANGED||(mode=$$$modeWRITEJUSTSAVED) {
		Set batch=$zu(68,25,1),journal=$zu(139,1)
		If i%TempGbl="" $$$streamInitTmpGlobal
		Set tempgbl=i%TempGbl,location=i%%Location,id=i%Id
		If mode=$$$modeWRITEJUSTSAVED Set i%MaxNodeNo=+$get(@location@(id))
		For i=1:1:i%MaxNodeNo-1 Set @tempgbl@(i)=@location@(id,i)
		If i%MaxNodeNo>0 {
			Set data=..%StorageToLogical(@location@(id,i%MaxNodeNo))
			Set bufferlen=..#BUFFERLEN
			If bufferlen["," Set bufferlen=+$piece(bufferlen,",",$select($$$MaxLocalLength>32767:2,1:1))
			If $length(data)<bufferlen {
				Set i%Buffer=data,i%MaxNodeNo=i%MaxNodeNo-1
			} Else {
				Set @tempgbl@(i%MaxNodeNo)=..%LogicalToStorage(data)
				Set i%Buffer=""
			}
		} Else {
			Set i%Buffer=""
		}
		Do $zu(68,25,batch),$zu(139,journal)
	} ElseIf mode'=$$$modeREADBUFFER {
		Set i%Buffer=""
	}
	#; a write is never at the end
	Set i%Mode=$$$modeWRITE,i%AtEnd=0
	
	Quit $$$OK
}

Method Rewind() As %Status
{
	Set mode=i%Mode
	If mode=$$$modeWRITEJUSTSAVED {
		Set i%MaxNodeNo=+$get(@i%%Location@(i%Id))
		Set i%NodeNo=0,i%Buffer="",i%Mode=$$$modeREADNOTCHANGED
	} ElseIf mode=$$$modeWRITE {
		#; If we have not written anything yet we can keep the data in the buffer
		If i%TempGbl'="" {
			If i%Buffer'="" Set sc=..Flush() If $$$ISERR(sc) Quit sc
			Set i%NodeNo=0,i%Buffer="",i%Mode=$$$modeREADCHANGED
		} Else {
			Set i%Mode=$$$modeREADBUFFER
		}
	} ElseIf mode'=$$$modeREADBUFFER {
		Set i%NodeNo=0,i%Buffer=""
	}
	Set i%Position=1,i%AtEnd=$select(i%Mode=$$$modeREADNODATA:1,1:0)
	Quit $$$OK
}

Method Flush() As %Status
{
	If i%Mode'=$$$modeWRITE Quit $$$OK
	If i%Buffer="" Quit $$$OK
	#; Turn on batch mode so writing stream does not kill the cache
	If i%TempGbl="" Do ..SetupTmpGbl()
	Set batch=$zu(68,25,1),journal=$zu(139,1)
	Set bufferlen=..#BUFFERLEN
	If bufferlen["," Set bufferlen=+$piece(bufferlen,",",$select($$$MaxLocalLength>32768:2,1:1))
	While i%Buffer'="" {
		#; Move to next node, write data
		Set @i%TempGbl@($increment(i%MaxNodeNo))=..%LogicalToStorage($extract(i%Buffer,1,bufferlen))
		Set i%Buffer=$extract(i%Buffer,bufferlen+1,*)
	}
	Do:batch=0 $zu(68,25,0) Do:journal=0 $zu(139,0)
	Quit $$$OK
}

// Size attribute

/// Return the current size of the data stream. 
Method SizeGet() As %Integer [ CodeMode = expression ]
{
i%IOSize
}

/// Check if we are at the end of the global, but do not read the next buffer
Method CheckAtEnd() [ Private ]
{
	#; Are we at the end
	If i%NodeNo'<i%MaxNodeNo {
		Set i%AtEnd=1,i%NodeNo=0
		Do:..%Locked ..%UnlockStream(1)
	}
}

/// Reads the next node into Buffer.
/// <p>Returns 0 if there is no more data.
Method ReadIntoBuffer() As %Boolean [ Private ]
{
	#; Are we at the end
	If i%NodeNo'<i%MaxNodeNo {
		Set i%AtEnd=1,i%NodeNo=0
		Do:..%Locked ..%UnlockStream(1)
		Quit 0
	}
	Set i%Position=1
	#; Turn on batch mode so reading stream does not kill the cache
	Set batch=$zu(68,25,1)
	If i%Mode=$$$modeREADNOTCHANGED {
		If ('..%Locked) && (..%Concurrency) { Do ..%LockStream() }
		Set i%Buffer=..%StorageToLogical(@i%%Location@(i%Id,$increment(i%NodeNo)))
	} Else {
		Set i%Buffer=..%StorageToLogical(@i%TempGbl@($increment(i%NodeNo)))
	}
	Do:batch=0 $zu(68,25,0)
	Quit 1
}

Method CopyFrom(source As %Stream.Object) As %Status
{
	Quit:source=$$$NULLOREF $$$ERROR($$$OrefInvalid,"")
	Set sc=$$$OK
	#; Optimise for copy from one global to another
	If $classname(source)=$classname() {
		Set mode=source.Mode
		Set sourceGlvn=$S(mode=$$$modeREADCHANGED||(mode=$$$modeWRITE):source.TempGbl,mode=$$$modeREADNODATA||(mode=$$$modeREADBUFFER):"",1:$na(@(source.%Location)@(source.Id)))
		If mode=$$$modeWRITEJUSTSAVED {
			Set sourcemaxnodeno=+$get(@sourceGlvn)
		} Else {
			Set sourcemaxnodeno=source.MaxNodeNo
		}	

		#; Update the last modified timestamp
		Set i%mLastModified=$ZTimeStamp
		If i%Mode=$$$modeWRITEJUSTSAVED {
			Set sc=..MoveToEnd() If $$$ISERR(sc) Quit sc
		}
		If i%Mode'=$$$modeWRITE {
			#; Copy the data and setup the properties
			Set i%MaxNodeNo=sourcemaxnodeno
			Set tempgbl=i%TempGbl
			#; clear temp to prepare for write to same location as last write
			If tempgbl="" {
				If sourcemaxnodeno>0 Do ..SetupTmpGbl() Set tempgbl=i%TempGbl
				Set batch=$zu(68,25,1),journal=$zu(139,1)
			} Else {
				Set batch=$zu(68,25,1),journal=$zu(139,1)
				If $data(@tempgbl) Kill @tempgbl
			}
			Try {
				For i=1:1:sourcemaxnodeno Set @tempgbl@(i)=@sourceGlvn@(i)
			} Catch exception {
				Do $zu(68,25,batch),$zu(139,journal)
				Throw exception
			}
			Do:batch=0 $zu(68,25,0) Do:journal=0 $zu(139,0)
			Set i%Mode=$$$modeWRITE,i%IOSize=source.Size
			Set i%Buffer=$select(mode=$$$modeREADNOTCHANGED||(mode=$$$modeREADCHANGED):"",1:source.Buffer)
		} Else {
			#; Else we can blast through the global which is faster than the generic
			#; copy mechanism, and add the new information to the end of the current data.
			Set buffer=i%Buffer,maxnodeno=i%MaxNodeNo
			Set tempgbl=i%TempGbl
			Set bufferlen=..#BUFFERLEN
			If bufferlen["," Set bufferlen=+$piece(bufferlen,",",$select($$$MaxLocalLength>32767:2,1:1))
			Set batch=$zu(68,25,1),journal=$zu(139,1)
			Try {
				For i=1:1:sourcemaxnodeno,0 {
					If i=0 {
						Set data=$select(mode=$$$modeREADNOTCHANGED||(mode=$$$modeREADCHANGED):"",1:source.Buffer)
					} Else {
						Set data=..%StorageToLogical(@sourceGlvn@(i))
					}
					Set datalen=$length(data)
					If $length(buffer)+datalen<bufferlen {
						Set buffer=buffer_data
					} Else {
						#; otherwise store Buffer to global
						If tempgbl="" Do ..SetupTmpGbl() Set tempgbl=i%TempGbl
						#; If buffer big enough on its own to write a chunk output these
						Set currpos=1
						While $length(buffer)-currpos+1>=bufferlen {
							Set @tempgbl@($increment(maxnodeno))=..%LogicalToStorage($extract(buffer,currpos,currpos+bufferlen-1)),currpos=currpos+bufferlen
						}
						If currpos'=1 Set buffer=$extract(buffer,currpos,*)
						If buffer="" {
							Set currpos=bufferlen
							If datalen=bufferlen {
								Set @tempgbl@($increment(maxnodeno))=..%LogicalToStorage(data)
							} Else {
								Set @tempgbl@($increment(maxnodeno))=..%LogicalToStorage($extract(data,1,bufferlen))
							}
						} Else {
							Set currpos=bufferlen-$length(buffer)
							Set @tempgbl@($increment(maxnodeno))=..%LogicalToStorage(buffer_$extract(data,1,currpos))
						}
						While datalen-currpos>=bufferlen {
							Set @tempgbl@($increment(maxnodeno))=..%LogicalToStorage($extract(data,currpos+1,currpos+bufferlen)),currpos=currpos+bufferlen
						}
						Set buffer=$extract(data,currpos+1,*)
					}
				}
			} Catch exception {
				Do $zu(68,25,batch),$zu(139,journal)
				Throw exception
			}
			Do $zu(68,25,batch),$zu(139,journal)
			Set i%IOSize=i%IOSize+source.Size,i%Buffer=buffer,i%MaxNodeNo=maxnodeno
		}
	} Else {
		#; Else use the generic copy mechanism
		Set sc=##class(%Stream.Object)$this.CopyFrom(source)
	}

	If $$$ISERR(sc) Quit sc

	#; Now copy the LineTerminator attribute
	If source.%Extends("%Stream.GlobalCharacter") || source.%Extends("%Library.AbstractStream") || source.%Extends("%IO.IParts.LineIO") || (source.%Extends("%CSP.Stream")) {
		Set ..LineTerminator=source.LineTerminator
	}

	Quit sc
}

Method OutputToDevice(ByRef len As %Integer = -1) As %Status
{
	Set $Ztrap="OutputError"
	If (i%Mode=$$$modeREADNODATA) Set i%AtEnd=1,len=-1 Quit $$$OK
	If len=0 Quit $$$OK
	If i%Position=1,i%NodeNo=0,len=..Size Set len=-1
	Set sc=$$$OK
	try {
		If len=-1 {
			#; Note that Rewind turns off WRITE mode so we do not need to test for this
			Do ..Rewind()
			If i%MaxNodeNo {
				#; Turn on batch mode so reading stream does not kill the cache
				Set batch=$zu(68,25,1)
				Set glvn=$S(i%Mode=$$$modeREADCHANGED:i%TempGbl,i%Mode=$$$modeREADNOTCHANGED:$na(@i%%Location@(i%Id)))
				Write ..%StorageToLogical(@glvn@(1))
				For i=2:1:i%MaxNodeNo Write ..%StorageToLogical(^(i))
				Do:batch=0 $zu(68,25,0)
			}
			If i%Mode=$$$modeREADBUFFER Write i%Buffer
			Set len=..Size
	
		#; Else write out just part of the global
		} Else {
			#; Mode $$$modeWRITE: in middle of Write with no rewind; automatically rewind
			If i%Mode=$$$modeWRITE||(i%Mode=$$$modeWRITEJUSTSAVED) Do ..Rewind()

			Set written=0

			#; If they only want less than in the current buffer so give it to them
			If len<($L(i%Buffer)-i%Position+2) {
				Write $E(i%Buffer,i%Position,i%Position+len-1)
				Set i%Position=i%Position+len
				Set written=len
			} ElseIf i%Mode=$$$modeREADBUFFER {
				Write $extract(i%Buffer,i%Position,*)
				Set i%Position=$length(i%Buffer)+1,i%AtEnd=1
			#; Else they want more than in the buffer
			} Else {
				#; Output the buffer to start with
				Write $E(i%Buffer,i%Position,*)
				Set written=written+$L(i%Buffer)-i%Position+1

				Set glvn=$S(i%Mode=$$$modeREADCHANGED:i%TempGbl,i%Mode=$$$modeREADNOTCHANGED:$na(@i%%Location@(i%Id)))
				Set node=i%NodeNo
				#; Turn on batch mode so reading stream does not kill the cache
				Set batch=$zu(68,25,1)
				For  Set node=$O(@glvn@(node),1,data) Quit:node=""  Set data=..%StorageToLogical(data) Quit:written+$L(data)>len  Write data Set written=written+$L(data)
				Do:batch=0 $zu(68,25,0)
				Set i%NodeNo=$S(node="":0,1:node)

				#; End of stream
				If node="" {
					Set i%AtEnd=1,i%Buffer="",i%Position=1
				} Else {
					#; Now write out the final data
					Write $extract(data,1,len-written)
					Set i%Buffer=data
					Set i%Position=len-written+1
					Set written=len
				}
			}

			#; Check if we are at the end
			If 'i%AtEnd,i%Position>$length(i%Buffer) Do ..CheckAtEnd()

			#;if we are at the end with no data return -1
			Set len=$S((i%AtEnd=1)&(written=0):-1,1:written)
		}
	} catch tException {
		set sc = tException.AsStatus()
	}
	Quit sc
OutputError	Set $ztrap=""
	Quit $$$ERROR($$$CacheError,$ZE)
}

Method Clear(permanent As %Boolean = 1) As %Status
{
	If i%Mode=$$$modeREADNODATA Quit $$$OK
	Set i%mLastModified=$ZTimeStamp
	Set batch=$zu(68,25,1),journal=$zu(139,1)
	If i%TempGbl'="" {
		If $data(@i%TempGbl) Kill @i%TempGbl
		If '$$$streamTmpGlobalDefault,..%Concurrency {
			Set tLockRef = ..%GetLockReference(i%%Location,i%Id)
			lock -@(tLockRef)#"I"
		}
		Set i%TempGbl=""
	}
	Do:journal=0 $zu(139,0)
	If permanent {
		If i%Id'="" {
			If $data(@i%%Location@(i%Id)) Kill ^(i%Id)
			Set i%Id=""
		}
		Set i%Mode=$$$modeREADNODATA,i%MaxNodeNo=0
		Set i%"%%OID"=..%Oid()
	} Else {
		Set i%Mode=$$$modeREADNOTCHANGED,maxnode=0
		If i%Id'="",$data(@i%%Location@(i%Id),maxnode)#10=0 Set maxnode=+$order(^(i%Id,""),-1)
		Set i%MaxNodeNo=maxnode
	}
	Set i%Buffer="",i%Position=1,i%NodeNo=0,i%IOSize=0,i%AtEnd=1
	Do:batch=0 $zu(68,25,0)
	Quit $$$OK
}

ClassMethod %Exists(soid As %ObjectIdentity) As %Boolean
{
	Set location=$$$oidSysAd1(soid)
	If $ascii(location)=0 Set location=$list($extract(location,2,*))
	If location="" Set location=$$$streamGlobal
	Set loctmp=$$$oidPrimary(soid)
	If location=""||(loctmp="") Quit 0
	Quit ''$data(@location@(loctmp))
}

Method %ObjectModified() As %Integer [ ServerOnly = 1 ]
{
	Quit $select(i%RemoveOnClose:1,1:$case(i%Mode,$$$modeREADNOTCHANGED:0,$$$modeREADNODATA:0,$$$modeWRITEJUSTSAVED:0,:1))
}

Method %IsModified() As %Integer
{
	Quit $select(i%RemoveOnClose:1,1:$case(i%Mode,$$$modeREADNOTCHANGED:0,$$$modeREADNODATA:0,$$$modeWRITEJUSTSAVED:0,:1))
}

ClassMethod %LogicalToStorage(val As %String) As %String [ Private ]
{
	Quit val
}

ClassMethod %StorageToLogical(val As %String) As %String [ Private ]
{
	Quit val
}

/// Callback for searchable stream
Method BuildValueArray(ByRef subvalue As %String) As %Status [ Private ]
{
	Quit $$$OK
}

ClassMethod %ObjectIsNull(soid As %ObjectIdentity) As %Boolean
{
	If soid=$$$NULLOID Quit 1
	If $isobject(soid)=1 Quit soid.%IsNull()
	Set class=$$$oidClassName(soid)
	If class'="" {
		Set class=$$$NormalizeClassname(class) If $classname()'=class Quit $classmethod(class,"%ObjectIsNull",soid)
	}
	Quit '..%Exists(soid)
}

}
