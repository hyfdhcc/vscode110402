/// <class>Scanner</class> is a utility class for intializing and manipulating inventory scans, represented by <class>Inventory.Scan</class>.
Class Inventory.Scanner Extends %RegisteredObject
{

ClassMethod DeleteAllScans() As %Status
{
}

/// Run an inventory scan of the current installation,
/// returning the scan result.
ClassMethod RunScan(description As %String) As Scan
{
}

/// Create a tree of <class>Component</class> objects by starting with a <class>DirectoryComponent</class> for
/// directory <var>dir</var>.
/// 
ClassMethod ScanDirectory(dir As %String) As Component
{
}

}
