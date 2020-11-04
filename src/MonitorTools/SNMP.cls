Include SYSTEM

/// System class methods to support SNMP. Allow users to extend the
/// Cache MIB and use the SNMP agent for their own MIBs, using the
/// definitions created by the %Monitor framework.
Class MonitorTools.SNMP Extends %RegisteredObject [ System = 4 ]
{

/// Create a MIB file (and an internal SNMP reference structure) for 
/// an Extension Application, based on the Monitor Framework metadata. 
/// <br><br>
/// All MIB definitions are modeled after the Cache MIB. That is, 
/// the standard iso.org.dod.internet.private.enterprises
/// subtree (i.e. 1.3.6.1.4.1), followed by the enterprise specific hierarchy 
/// entID.appID.objects.table.row.item.config.index. 
/// For example, the size of a database would be encoded as:
/// 1.3.6.1.4.1.16563.1.1.3.1.6.4.84.69.83.84.1
/// iso.org.dod.internet.private.enterprises.intersystems.cache
/// .objects.DBtab.DBrow.DBsize.TEST(config).1(DBindex)
/// <br><br>
/// Note that most of the default parameter values reflect the actual Cache MIB. They
/// are supplied as examples and should not be used for Extension Applications.
/// <br><br>
/// Parameters are:
/// <br><br>
/// <b>AppName</b>  -  the Application name as defined in the Monitor Framework. 
/// Used as the MIB Module name, it must begin with an uppercase letter and contain no punctuation.
/// <br>
/// <b>Namespace</b>  -  the namespace where the application exists
/// <br>
/// <b>EntID</b>  -  the company ID number as assigned by the IANA
/// <br>
/// <b>AppID</b>  -  the application ID number as assigned by the company
/// <br>
/// <b>Company</b>  -  the company name (lower case and no spaces or punctuation) associated with the IANA number.
/// This is used as the identifier for the 'enterprises' object.
/// <br>
/// <b>Prefix</b>  -  a short, 3 to 5 character, lower case (no spaces or punctuation) prefix to be used for all SNMP objects
/// <br>
/// <b>CompanyShort</b>  -  a short, lower case (no spaces or punctuation) prefix for the company name. This
/// is appended to the AppName to create a product OID name
/// <br>
/// <b>MIBname</b>  -  the name of the MIB. This is also used as the file name (with .mib)
/// <br>
/// <b>Contact</b>  -  comma-delimited string(s) containing address and contact info.
/// <br>
/// <b>List</b>  -  flag which causes progress information to be output.
/// 
ClassMethod CreateMIB(AppName As %String = "Cache", Namespace As %String = "%SYS", EntID As %Integer = 16563, AppID As %Integer = 1, Company As %String = "intersystems", Prefix As %String = "cache", CompanyShort As %String = "isc", MIBname As %String = "ISC-CACHE", Contact As %String = "1 Memorial Drive, Cambridge MA 02142, Subject: ISC-CACHE.mib", List As %Boolean = 1) As %Status
{
}

/// Delete the internal representation of the MIB for an Extension Application.
/// This will cause the Cache SNMP agent to no longer register and support the MIB
/// for this application.
/// <br><br>
/// Parameters are:
/// <br><br>
/// <b>EntID</b> - the IANA enterprise ID number for the company (e.g. 16536 for Intersystems)
/// <br><br>
/// <b>AppID</b> - the application ID number assigned by the company (e.g. 1 for Cache).
ClassMethod DeleteMIB(EntID As %Integer, AppID As %Integer) As %Status
{
}

/// 
/// Turn on debug mode for Cache SNMP sub-agent
/// Output detailed transaction messages to the SNMP log file
/// Normal value should be 1, but a higher value (2) will show 
/// some more detail. Return value is previous value of debug flag.
/// 
ClassMethod Debug(Flag As %Integer) As %Integer [ Internal ]
{
}

/// Prompt for input and run CreateMIB
///  
ClassMethod Ask() As %Status [ Internal ]
{
}

}
