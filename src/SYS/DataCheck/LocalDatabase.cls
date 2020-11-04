/// A local database specification.  It takes one of the following forms
/// 
/// <li>A physical path local to this system</li>
/// <li>Mirror Database Name of the form :mirror:<i>mirrorname</i>:<i>mirrorDBname</i>
///         for mirror-based DataCheck.</li>
Class SYS.DataCheck.LocalDatabase Extends %String [ OdbcType = VARCHAR, SqlCategory = STRING ]
{

Parameter COLLATION = "EXACT";

ClassMethod Normalize(%val As %String) As %String [ CodeMode = expression, Internal ]
{
$select(##class(SYS.DataCheck.LocalDatabase).IsPath(%val):##class(%File).NormalizeDirectory(%val),1:%val)
}

ClassMethod IsValid(%val As %CacheString) As %Status
{
	if ##class(SYS.DataCheck.LocalDatabase).IsPath(%val) && ($length(%val)>$zutil(40,0,78)) {
		quit $$$ERROR($$$DirectoryNameTooLong)
	}
	quit $$$OK
}

ClassMethod IsPath(%val) [ CodeMode = expression, Internal ]
{
($extract(%val,1,8)'=":mirror:")
}

ClassMethod IsMirrorDBName(%val) [ CodeMode = expression, Internal ]
{
($extract(%val,1,8)=":mirror:")
}

ClassMethod GetPath(%val) As %String [ Internal ]
{
	set path=""
	if ($extract(%val,1,8)=":mirror:") {
		set sfn=-1
		do {
			set db=$system.Mirror.GetNextDBBySFN(sfn)
			if $p(db,"^",2)=%val {
				set path=$p(db,"^",3)
				quit
			}
			set sfn=+db
		} while sfn'<0
	} else {
		set path=%val
	}
	if path'="" {
		set path=##class(%File).NormalizeDirectory(path)
	}
	quit path
}

}
