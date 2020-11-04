/// General information about a Cache instance.
Class SYS.WSMon.wsSystem Extends SYS.WSMon.wsResource [ System = 4 ]
{

/// The name given to the Cache instance.
Property Name As %String;

/// The system name where the Cache instance is installed.
Property System As %String;

/// The path and file name of the current configuration file used by this Cache instance.
Property ConfigFile As %String;

/// The path for the directory where this Cache instance is installed.
Property Directory As %String;

/// Version string ($ZV) for this Cache instance.
Property Version As %String(MAXLEN = 256);

/// The number of current users on this Cache instance.
Property CurrentUsers As %String;

/// The size of the routine cache in MB for this Cache instance .
Property RoutineCache As %Integer;

/// The size of the database cache in MB for this Cache instance.
Property DatabaseCache As %Integer;

/// The current number of licenses available on this Cache instance.
Property LicenseAvailable As %Integer;

/// The current number of licenses used on this Cache instance.
Property LicenseUsed As %Integer;

/// The high-water mark for licenses used on this Cache instance.
Property LicenseHigh As %Integer;

/// Instantiate the class and fill in current values for all properties.
ClassMethod Sample() As SYS.WSMon.wsSystem
{
}

}
