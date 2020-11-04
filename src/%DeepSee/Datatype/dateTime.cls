Include %DeepSee

/// Used to represent dates within DeepSee.
/// This datatype can contain a complete $H value with days and seconds.
Class %DeepSee.Datatype.dateTime Extends %Library.Date [ System = 3 ]
{

/// Converts <var>%val</var> to a normalized value.
ClassMethod Normalize(%val As %CacheString) As %Date [ CodeMode = expression, ServerOnly = 1 ]
{
%val
}

/// Validate $H value, ignore parameters.
ClassMethod IsValid(%val As %CacheString) As %Status [ ServerOnly = 1 ]
{
	// $ZDT will accept bogus dates, such as "ABC"; test for this
	Set tDay = $P(%val,",",1)
	Set tSec = $P(%val,",",2)
	If ((tDay'="")&&('$IsValidNum(tDay)||(tDay<=0))) {	// DTB311 - Reject negative and 0
		Quit $$$ERROR($$$DTNotNum,%val)
	}
	If ((tSec'="")&&'$IsValidNum(tSec)) {
		Quit $$$ERROR($$$DTNotNum,%val)
	}
	
	QUIT $S($ZDT(%val,3,,,,,,,,,"X")'="X":$$$OK,1:$$$ERROR($$$DTNotNum,%val))
}

}
