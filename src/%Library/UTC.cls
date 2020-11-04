Class %Library.UTC Extends %DataType [ ClientDataType = TIMESTAMP, OdbcType = TIMESTAMP, SqlCategory = TIMESTAMP, System = 2 ]
{

ClassMethod LogicalToDisplay(%val As %TimeStamp) As %TimeStamp [ CodeMode = expression ]
{
..ConvertUTCtoLocal(%val)
}

ClassMethod DisplayToLogical(%val As %TimeStamp) As %TimeStamp [ CodeMode = expression ]
{
..ConvertLocaltoUTC(%val)
}

ClassMethod LogicalToOdbc(%val As %TimeStamp) As %TimeStamp [ CodeMode = expression ]
{
..ConvertUTCtoLocal(%val)
}

ClassMethod OdbcToLogical(%val As %TimeStamp) As %TimeStamp [ CodeMode = expression ]
{
..ConvertLocaltoUTC(%val)
}

ClassMethod StorageToLogical(%val As %TimeStamp) As %TimeStamp [ CodeMode = expression ]
{
..Normalize(%val)
}

/// Convert timstamp to horolog value
ClassMethod ConvertTimeStampToHorolog(%timestamp As %TimeStamp) As %String [ CodeMode = expression ]
{
$zdatetimeh(%timestamp,3,,,,,,,,0)
}

/// Convert horolog to timstamp value
ClassMethod ConvertHorologToTimeStamp(%horolog As %String) As %TimeStamp [ CodeMode = expression ]
{
$zdatetime(%horolog,3,,3)
}

/// Return the current UTC timestamp
ClassMethod NowUTC() As %TimeStamp [ CodeMode = expression ]
{
..ConvertHorologToTimeStamp($ztimestamp)
}

/// Return the current local timestamp
ClassMethod NowLocal() As %TimeStamp [ CodeMode = expression ]
{
..ConvertUTCtoLocal(..NowUTC())
}

/// Convert UTC timestamp to local timestamp
ClassMethod ConvertUTCtoLocal(%timestamp As %TimeStamp) As %TimeStamp [ CodeMode = expression ]
{
$s(%timestamp="":"",1:..ConvertHorologToTimeStamp($zdth(..ConvertTimeStampToHorolog(%timestamp),-3)))
}

/// Convert local timestamp to UTC timestamp
ClassMethod ConvertLocaltoUTC(%timestamp As %TimeStamp) As %TimeStamp [ CodeMode = expression ]
{
$s(%timestamp="":"",1:..ConvertHorologToTimeStamp($zdt(..ConvertTimeStampToHorolog(%timestamp),-3)))
}

/// Compare two timestamps, return 0 if euqal, >0 if %t1 is later, <0 if %t2 is later
ClassMethod Compare(%t1 As %TimeStamp, %t2 As %TimeStamp) As %Integer [ CodeMode = expression ]
{
..Diff(%t1,%t2)
}

/// Return the number of seconds difference between two timestamps.
/// if '%later' is earlier than '%earlier' then the result is a negative number.
ClassMethod Diff(%later As %TimeStamp, %earlier As %TimeStamp) As %Integer
{
	set laterH=..ConvertTimeStampToHorolog(%later)
	set earlierH=..ConvertTimeStampToHorolog(%earlier)
	quit ($p(laterH,",",1)-$p(earlierH,",",1))*(24*3600)+$p(laterH,",",2)-$p(earlierH,",",2)
}

/// Strip off trailing zeros and trailing dot for normalized form
ClassMethod Normalize(%val As %CacheString) As %TimeStamp [ ServerOnly = 1 ]
{
	if $p(%val,":",3)'["." quit %val
	for i=1:1:3 quit:$e(%val,*)'="0"  set %val=$e(%val,1,*-1)
	if $e(%val,*)="." set %val=$e(%val,1,*-1)
	quit %val
}

}
