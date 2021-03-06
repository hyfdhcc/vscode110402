Class %Collection.MV.ListOfObj Extends %Collection.ListOfObj [ System = 2 ]
{

Parameter IdCollection As BOOLEAN = 1;

/// Serialize() constructs a serialized form of the collection as a string
Method Serialize(force As %Integer = 0) As %String(MAXLEN="")
{
	#; $Piece delimited string of list of objects without extentname in the oid
	Set list="",owner=$zobjref(i%Owner),storage=i%Storage
	For key=1:1:+$order($zobjval(owner,storage,0,3,storage,""),-1) {
		set id = ..GetObjectIdAt(key,.force), list = $select(key=1:id,1:list_$mvv(2)_id)
	}
	Quit list
}

Method DeSerialize(serialized As %String(MAXLEN="")) As %Status
{
	Set ptr=0,key=0,changed=0,owner=$zobjref(i%Owner),storage=i%Storage,orefstorage=i%OrefStorage,oldcount=+$order($zobjval(owner,storage,0,3,storage,""),-1)
	If oldcount'=$length(serialized,$mvv(2)) {
		Set changed=1,sc=..Clear()
		If $$$ISERR(sc) Quit sc
	    For i=1:1:$length(serialized,$mvv(2)) {
		    Set $zobjval(owner,storage,0,3,storage,$increment(key))=$piece(serialized,$mvv(2),i),$zobjval(owner,orefstorage,0,3,orefstorage,key)=$$$NULLOREF
	    }
	} Else {
		If i%ReadOnly Quit $$$ERROR($$$ReadOnlyCollection)
	    For i=1:1:$length(serialized,$mvv(2)) {
		    Set item=$piece(serialized,$mvv(2),i)
		    If $zobjval(owner,storage,0,3,storage,$increment(key))'=item {
		    	Set $zobjval(owner,storage,0,3,storage,key)=item,$zobjval(owner,orefstorage,0,3,orefstorage,key)=$$$NULLOREF,changed=1
		    }
	    }
	}
	If changed Set $zobjmod(owner,i%OrefStorage)=1
    Quit $$$OK
}

}
