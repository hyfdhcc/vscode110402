Class %Monitor.System.Freespace Extends %Monitor.System.Adaptor [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
RFD509  3/08/10 Rob Davis, handle "TB" suffix on size conversions
SAP1042	5/30/08 Steve Pettibone, make DBName the dataset.
SAP978 02/19/08 Steve Pettibone, add diskfreespace, maxsize, cursize
SAP615 06/14/06 Steve Pettibone, properly close Rspec
SAP335 02/22/05 Steve Pettibone, switch namespaces
LFT1316 11/11/4 Laura Tillem, %SYSTEM -> SYS.Database
SAP244 10/18/04 Steve Pettibone, use %Monitor.Numeric type
-------------------End Documentation----------------------------------
*/
Parameter APPLICATION [ Internal ] = "CACHE";

Parameter INDEX [ Internal ] = "DBName";

/// Name of dataset
Property DBName As %Monitor.String;

/// Name of directory
Property Directory As %Monitor.String;

/// Maximum size (MB. -1 indicates Unlimited).
Property MaxSize As %Monitor.Integer;

/// Current size (MB)
Property CurSize As %Monitor.Integer;

/// Freespace available (MB)
Property FreeSpace As %Monitor.Integer;

/// Disk space available (MB)
Property DiskFreeSpace As %Monitor.Integer;

Property Rspec As %Library.ResultSet [ Internal ];

Property NSpace As %String [ Internal ];

/// Initialize routine metrics.
Method Initialize() As %Status
{
	s ..NSpace=$ZNSPACE
	s $ZNSPACE = "%SYS"
	s ..Rspec = ##class(%Library.ResultSet).%New("SYS.Database:FreeSpace")
	d ..Rspec.Execute("*",0)
	s $ZNSPACE = ..NSpace
	Quit $$$OK
}

/// Get routine metric sample.<br>
/// A return code of $$$OK indicates there is a new sample instance.<br>
/// A return code of 0 indicates there is no sample instance.
Method GetSample() As %Status
{
	s $zt="RunErr"
#;	convert all sizes from SYS.Database query to MB
	#define MBYTES(%v)  $s($f(%v,"TB"):+%v*1000000,$f(%v,"GB"):+%v*1000,1:+%v)
	
	// Get freespace data
	s $ZNSPACE = "%SYS"
	Set stat = ..Rspec.Next(.sc)
	If 'stat g End
	If '$SYSTEM.Status.IsOK(sc) Quit sc
	Set ..Directory = ..Rspec.Get("Directory")
	s DBlist=""
	s Status=$$DatasetsByDirectory^%SYS.CONFIG("",..Directory,.DBlist)
	i DBlist="" {
		s ..DBName = ..Directory
	} else {
		s ..DBName = $li(DBlist,1)
	}
#;	Maximum size of DB
	s val = ..Rspec.Get("MaxSize")
	i val = "Unlimited" {
		s ..MaxSize = -1
	} else {
		s ..MaxSize=$$$MBYTES(val)
	}
#;	Current size of DB
	s val = ..Rspec.Get("Size")
	s ..CurSize=$$$MBYTES(val)
#;	Available DB freespace
	s val = ..Rspec.Get("Available")
	s ..FreeSpace=$$$MBYTES(val)
#;	Available diskspace
	s val = ..Rspec.Get("DiskFreeSpace")
	s ..DiskFreeSpace=$$$MBYTES(val)
	s $ZNSPACE = ..NSpace
	Q $$$OK
End
    s ..Rspec = ""
	s $ZNSPACE = ..NSpace
	Q 0
RunErr
	s $zt=""
	Q $$$ERROR($$$CacheError,$ze)
}

}
