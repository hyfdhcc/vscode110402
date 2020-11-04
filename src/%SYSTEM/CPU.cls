/// This class holds information about available processors.
/// The number of threads (virtual or logical cpus), cores
/// and chips always reflect the situation in the current
/// partition or processor set.
Class %SYSTEM.CPU Extends (%RegisteredObject, %SYSTEM.Help) [ System = 4 ]
{

/// Architecture, eg: x86, Itanium, SPARC, PA-RISC
Property Arch As %String;

/// Chip model, eg: Pentium 4, POWER5
Property Model As %String;

/// Chip vendor, eg: Intel, Sun, IBM
Property Vendor As %String;

/// Number of threads (virtual or logical cpus)
Property nThreads As %Numeric;

/// Number of cores (depends on partition configuration)
Property nCores As %Numeric;

/// Number of chips (depends on partition configuration)
Property nChips As %Numeric;

/// Number of threads per core (physical property)
Property nThreadsPerCore As %Numeric;

/// Number of cores per chip (physical property)
Property nCoresPerChip As %Numeric;

/// Clock in MHz
Property MHz As %Numeric;

/// Is Hardware Multi-Threading supported?
Property MTSupported As %Boolean;

/// Is Hardware Multi-Threading enabled?
Property MTEnabled As %Boolean;

/// Force update and get new properties
Method Refresh() As %Status
{
	Do $zu(204,0)
	Quit ..GetProperties()
}

/// Query the system and update object properties
Method GetProperties() As %Status [ Private ]
{
 Set ..Arch=$zu(204,1)
 Set ..Model=$zu(204,2)
 Set ..Vendor=$zu(204,3)
 Set ..nThreads=$zu(204,4)
 Set ..nCores=$zu(204,5)
 Set ..nChips=$zu(204,6)
 Set ..nThreadsPerCore=$zu(204,7)
 Set ..nCoresPerChip=$zu(204,8)
 Set ..MTSupported=$zu(204,9)
 Set ..MTEnabled=$zu(204,10)
 Set ..MHz=$zu(204,11)	
 Quit $$$OK
}

Method %OnNew() As %Status
{
 Quit ..GetProperties()
}

/// Display CPU information
ClassMethod Dump()
{
  #; First refresh CPU info
  Do $ZU(204,0)
  Set len=78,dashes="",$P(dashes,"-",len+1)=""
  Set header="-- CPU Info for node "_$ZU(110)_" -"
  Write !,header,$E(dashes,$L(header)+1,len)
  For i=1:1:11 {
  	Set tag=$P("Architecture,Model,Vendor,# of threads,# of cores,# of chips,# of threads per core,# of cores per chip,MT supported,MT enabled,MHz",",",i)
  	Write !,$J(tag,22),": ",$ZU(204,i)
  }
  Write !,dashes
}

}
