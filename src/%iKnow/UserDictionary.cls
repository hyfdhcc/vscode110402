Include %IKInclude

/// <p>This class represents User Dictionaries, used to rewrite fragments of input data
/// specific to a particular use case.</p>
/// <p>When creating a User Dictionary, you can pass initial values for the following properties
/// to its <method>%New</method> method:
/// <ol>
/// 	<li><property>Name</property> (required)</li>
/// 	<li><property>Description</property></li>
/// </ol>
/// Check the respective property descriptions for more details.</p>
Class %iKnow.UserDictionary Extends %Persistent [ StorageStrategy = SqlStorage, System = 4 ]
{

Property Id As %Integer [ Final, ReadOnly ];

Property Name As %String [ Final, ReadOnly ];

Property Description As %String [ Final ];

/// This property is used for transient versions only
Property IsTransient As %Boolean [ InitialExpression = 0, Internal, Private, Transient ];

Index PKINDEX On Id [ IdKey, PrimaryKey, Unique ];

Index NameIndex On Name [ Unique ];

Method NextEntry(pKey As %Integer) As %Integer [ Internal ]
{
	if '..IsTransient {
		quit:..%IsModified() ""
		quit $order(^ISC.IK.Sys.UserDictEntry(i%Id, pKey))
	} else {
		quit $order(^||%IK.UserDict(pKey))
	}
}

Method GetEntry(pKey As %Integer) As %List [ Internal ]
{
	if '..IsTransient {
		quit:..%IsModified() ""
		quit:'$d(^ISC.IK.Sys.UserDictEntry(i%Id, +pKey), tData) ""
	} else {
		quit:'$d(^||%IK.UserDict(+pKey), tData) ""
	}
	quit $lb($zconvert($li(tData,1),"O","UTF8"), $zconvert($li(tData,2),"O","UTF8"))
}

/// <p>Returns a User Dictionary object by name. First, this method checks if <var>pName</var> 
/// is a name used by any saved User Dictionary object. If none found, it is used as a file
/// path for the legacy file-based User Dictionaries. If there is no file at this path,
/// "" is returned.</p>
/// <p><b>Note</b>: file-based User Dictionaries are deprecated. Please use Caché-based ones
/// by using <method>%New</method>, <method>%Save</method> and <method>AddEntry</method>.</p>
ClassMethod OpenByName(pName As %String) As %iKnow.UserDictionary
{
	set tSC = $$$OK
	try {
		set tUserDict = ..NameIndexOpen(pName)
		set:(tUserDict="") tUserDict = ..CreateFromFile(pName)
	} catch (ex) {
		set tUserDict = ""
	}
	quit $s($$$ISERR(tSC):"", 1:tUserDict)
}

/// Creates a UserDictionary instance based on a file containing comma-separated from/to
/// pairs on each line. The instance produced by this classmethod is transient and cannot
/// be saved through %Save()
ClassMethod CreateFromFile(pPath As %String) As %iKnow.UserDictionary [ Internal ]
{
	set tSC = $$$OK
	try {
		set tUserDict = ..CreateTransient(pPath)
	
		set tFile = ##class(%Stream.FileCharacter).%New()
		set tFile.Filename = pPath
		if ('tFile.FileBinarySize()) {
			set tUserDict = ""
			quit
		}
	
		while 'tFile.AtEnd {
			set tLine = tFile.ReadLine(,.tSC)
			quit:$$$ISERR(tSC)
			
			// BDB463: skip empty input
			continue:$piece(tLine,",",1)=""
			
			set ^||%IK.UserDict($i(^||%IK.UserDict)) = $lb($piece(tLine,",",1), $piece(tLine,",",2))
		}
		quit:$$$ISERR(tSC)
		
	} catch (ex) {
		set tUserDict = ""
	}
	quit $s($$$ISERR(tSC):"", 1:tUserDict)
}

ClassMethod CreateTransient(pName As %String = "") As %iKnow.UserDictionary [ Internal ]
{
	set tSC = $$$OK
	try {
		set:pName="" pName = $random(99999999)
		set tUserDict = ..%New(pName)
		set tUserDict.IsTransient = 1
		kill ^||%IK.UserDict
	} catch (ex) {
		set tUserDict = ""
	}
	quit $s($$$ISERR(tSC):"", 1:tUserDict)
}

Method %OnNew(pName As %String, pDescription As %String = "") As %Status [ Private, ServerOnly = 1 ]
{
	set tSC = $$$OK
	try {
		$$$CHECKLICENSEX(tSC)
		$$$IKCHECKPRIVADMINX(tSC)
		$$$IKCHECKNOTNULLX(pName,tSC)
		$$$IKCHECKSTRINGLENGTHX(pName,tSC)
		
		// check for name uniqueness right away, as it's a read-only propery
		// and the index is only validated after %OnBeforeSave() otherwise
		if ..NameIndexExists(pName) {
			set tSC = $$$ERROR($$$IKUserDictWithNameExists, pName)
			quit
		}
		
        set i%Name = pName
        set i%Description = pDescription
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	
	quit tSC
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	$$$IKCHECKPRIVADMIN
	quit:..IsTransient $$$ERROR($$$GeneralError, "Cannot save transient UserDict")
	
	set tSC = $$$OK
	try {
		
		if (insert) {
			
	        // if OK, fetch new ID and populate properties
    	    set i%Id = $i(^ISC.IK.Sys.UserDictD)
    	    
		} else {
		
			set tSC = ..CheckIfManaged($this)
			quit:$$$ISERR(tSC)
			
		}
        
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

Method ClearEntries() As %Status [ Internal ]
{
	$$$IKCHECKPRIVADMIN
	set tSC = $$$OK
	try {
		set tSC = ..CheckIfManaged($this)
		quit:$$$ISERR(tSC)
		
		kill ^ISC.IK.Sys.UserDictEntry(..Id)
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
	$$$IKCHECKPRIVADMIN
	set tSC = $$$OK
	try {
		set tUserDict = ..%Open(oid)
		if '$isobject(tUserDict) { set tSC = $$$ERROR($$$IKNoUserDictWithId, oid)  quit  }
		
		set tSC = ..CheckIfManaged(tUserDict)
		quit:$$$ISERR(tSC)
		
		kill ^ISC.IK.Sys.UserDictEntry(tUserDict.Id)
		
		set tUserDict=""
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

///  <p>Adds a single entry to this User Dictionary at <var>position</var>. If <var>position</var> <= 0 (default=0),
///  it is added at the bottom of the list, otherwise at the requested position, shifting
///  existing entries down if it was already taken.</p>
///  <p>These changes are saved automatically. There is no need to call <method>%Save</method></p>
Method AddEntry(pRewriteFrom As %String, pRewriteTo As %String, ByRef pPosition As %Integer = 0) As %Status
{
	$$$IKCHECKPRIVADMIN
	quit:..%IsModified()&&'..IsTransient $$$ERROR($$$IKObjectModified, "User Dictionary")
	
	set tSC = $$$OK, tTLevel = $tlevel
	try {
		$$$CHECKLICENSEX(tSC)
		$$$IKCHECKNOTNULLX(pRewriteFrom,tSC)
		$$$IKCHECKNOTNULLX(pRewriteTo,tSC)
		
		set tSC = ..CheckIfManaged($this)
		quit:$$$ISERR(tSC)
		
		if ('..IsTransient) {
			$$$IKLOCKX(..Id,^ISC.IK.Sys.UserDictD,tSC)
		}
		
		tstart
		
		set gUserDictEntry = $s(..IsTransient:"^||%IK.UserDict", 1:$name(^ISC.IK.Sys.UserDictEntry(..Id)))
		
		// if no position supplied, just take the next free slot
		if (pPosition<=0) {
			set pPosition = $o(@gUserDictEntry@(""),-1)+1
		}
	
		// shift all positions < position backwards if it was already taken
		if $d(@gUserDictEntry@(pPosition),tData) {
			kill ^||%IK.UserDictEntry
			set tPos = pPosition
			for {
				set ^||%IK.UserDictEntry(tPos+1) = tData
				kill @gUserDictEntry@(tPos)
				set tPos = tPos+1
				quit:'$data(@gUserDictEntry@(tPos),tData)
			}
			merge @gUserDictEntry = ^||%IK.UserDictEntry
			kill ^||%IK.UserDictEntry
		}
	
		set @gUserDictEntry@(pPosition) = $lb(pRewriteFrom, pRewriteTo)
		
		tcommit
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	trollback:($tlevel>tTLevel) 1
	
	if ('..IsTransient) {
		$$$IKUNLOCK(..Id,^ISC.IK.Sys.UserDictD)
	}
	
	quit tSC
}

Method AddNegationTerm(pWord As %String, Output pPosition As %Integer) As %Status
{
	quit ..AddAttribute(pWord, "UDNegation", .pPosition)
}

Method AddPositiveSentimentTerm(pWord As %String, Output pPosition As %Integer) As %Status
{
	quit ..AddAttribute(pWord, "UDPosSentiment", .pPosition)
}

Method AddNegativeSentimentTerm(pWord As %String, Output pPosition As %Integer) As %Status
{
	quit ..AddAttribute(pWord, "UDNegSentiment", .pPosition)
}

Method AddAttribute(pWord As %String, pAttribute As %String = "UDNegation", Output pPosition) As %Status [ Internal ]
{
	$$$IKCHECKPRIVADMIN
	quit:..%IsModified()&&'..IsTransient $$$ERROR($$$IKObjectModified, "User Dictionary")
	
	set tSC = $$$OK, tTLevel = $tlevel
	try {
		$$$CHECKLICENSEX(tSC)
		$$$IKCHECKNOTNULLX(pWord,tSC)
		
		set tSC = ..CheckIfManaged($this)
		quit:$$$ISERR(tSC)
		
		if ('..IsTransient) {
			$$$IKLOCKX(..Id,^ISC.IK.Sys.UserDictD,tSC)
		}
		
		tstart
		
		set gUserDictEntry = $s(..IsTransient:"^||%IK.UserDict", 1:$name(^ISC.IK.Sys.UserDictEntry(..Id)))
		
		set pPosition = $o(@gUserDictEntry@(""),-1)+1
	
		// shift all positions < position backwards if it was already taken
		if $d(@gUserDictEntry@(pPosition),tData) {
			kill ^||%IK.UserDictEntry
			set tPos = pPosition
			for {
				set ^||%IK.UserDictEntry(tPos+1) = tData
				kill @gUserDictEntry@(tPos)
				set tPos = tPos+1
				quit:'$data(@gUserDictEntry@(tPos),tData)
			}
			merge @gUserDictEntry = ^||%IK.UserDictEntry
			kill ^||%IK.UserDictEntry
		}
	
		set @gUserDictEntry@(pPosition) = $lb("@"_pWord, pAttribute)
		
		tcommit
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	trollback:($tlevel>tTLevel) 1
	
	if ('..IsTransient) {
		$$$IKUNLOCK(..Id,^ISC.IK.Sys.UserDictD)
	}
	
	quit tSC
}

///  <p>Removes the User Dictionary entry registered at <var>position</var>. This method will
///  not impact the order or position of any remaining entries.</p>
///  <p>These changes are saved automatically. There is no need to call <method>%Save</method></p>
Method RemoveEntry(pPosition As %Integer) As %Status
{
	$$$IKCHECKPRIVADMIN
	quit:..%IsModified()&&'..IsTransient $$$ERROR($$$IKObjectModified, "User Dictionary")
	
	set tSC = ..CheckIfManaged($this)
	quit:$$$ISERR(tSC) tSC
		
	if (..IsTransient) {
		kill ^||%IK.UserDict(..Id, pPosition)
	} else {
		kill ^ISC.IK.Sys.UserDictEntry(..Id, pPosition)
	}
	quit $$$OK
}

///  <p>Returns the contents of this User Dictionary in the form pResult(position) = $lb(rewriteFrom, rewriteTo).</p>
Method GetEntries(ByRef pResult) As %Status
{
	$$$IKCHECKPRIVREAD
	quit:..%IsModified()&&'..IsTransient $$$ERROR($$$IKObjectModified, "User Dictionary")
	
	set tSC = $$$OK
	try {
		$$$CHECKLICENSEX(tSC)
		
		if (..IsTransient) {
			merge pResult = ^||%IK.UserDict
		} else {
			merge pResult = ^ISC.IK.Sys.UserDictEntry(..Id)
		}
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Checks if the supplied User Dictionary instance is managed
ClassMethod CheckIfManaged(pUserDict As %iKnow.UserDictionary) As %Status [ Internal ]
{
	set tSC = $$$OK
	try {
		// transient UDs are never managed
		quit:pUserDict.IsTransient
		
		set tManager = ""
		for {
			set tManager = $order(^ISC.IK.Sys.Definition(tManager))
			quit:tManager=""
			quit:$d(^ISC.IK.Sys.Definition(tManager,"userdict",pUserDict.Id))
		}
		quit:tManager=""
		$$$IKCHECKMGRX("User Dictionary",pUserDict.Name,tManager,tSC)
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

Method %ConstructClone(deep As %Boolean = 0, ByRef cloned As %String, location As %String) As %RegisteredObject [ ServerOnly = 0 ]
{
	quit "" // not supported!
}

ClassMethod %DeleteExtent(concurrency As %Integer = -1, ByRef deletecount, ByRef instancecount, pInitializeExtent As %Integer = 1) As %Status [ ServerOnly = 0 ]
{
	quit $$$ERROR($$$MethodNotImplemented,"%iKnow.Configuration:%DeleteExtent")
}

ClassMethod %KillExtentData() As %Status [ Private, ServerOnly = 1 ]
{
	quit $$$ERROR($$$MethodNotImplemented,"%iKnow.Configuration:%KillExtentData")
}

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MainMap">
<Data name="Description">
<Piece>2</Piece>
</Data>
<Data name="Name">
<Piece>1</Piece>
</Data>
<Global>^ISC.IK.Sys.UserDictD</Global>
<Structure>list</Structure>
<Subscript name="1">
<Expression>{Id}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="NameIndex">
<Data name="Id"/>
<Global>^ISC.IK.Sys.UserDictI</Global>
<RowIdSpec name="1">
<Expression>{Id}</Expression>
<Field>Id</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>$$$UPPER({Name})</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^ISC.IK.Sys.UserDictS</StreamLocation>
<Type>%CacheSQLStorage</Type>
}

}
