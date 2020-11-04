/// This class represents detailed system metrics captured for global disk activity. Each 
/// property is a different metric. A class may be instantiated by calling the class method 
/// 'Sample', and then the current value of each property can be accessed.
/// <br><br>
/// For example:
/// <example>
/// s ref=##class(SYS.Stats.Disk).Sample()
/// w ref.LogDir ; display number of logical reads for directory blocks
/// </example>
/// <br>
/// Note that in the ^GLOSTAT utility, the numbers displayed as "Logical Block Requests" are 
/// the total of Logical Reads and Physical Reads for a category. 
///  
/// Individual counts for disk blocks read and written
Class SYS.Stats.Disk Extends SYS.WSMon.wsResource [ System = 4 ]
{

/// Logical reads of Global Directory blocks.
Property LogDir As %Integer;

/// Physical reads of Global Directory blocks.
Property PhyDirRd As %Integer;

/// Physical writes of Global Directory blocks.
Property PhyDirWt As %Integer;

/// Logical reads of Upper-level Pointer blocks.
Property LogUptr As %Integer;

/// Physical reads of Upper-level Pointer blocks.
Property PhyUptrRd As %Integer;

/// Physical writes of Upper-level Pointer blocks
Property PhyUptrWt As %Integer;

/// Logical reads of Bottom-level Pointer blocks.
Property LogBptr As %Integer;

/// Physical reads of Bottom-level Pointer blocks.
Property PhyBptrRd As %Integer;

/// Physical writes of Bottom-level Pointer blocks.
Property PhyBptrWt As %Integer;

/// Logical reads of Data & Big String Data blocks.
Property LogData As %Integer;

/// Physical reads of Data & Big String Data blocks.
Property PhyDataRd As %Integer;

/// Physical writes of Data & Big String Data blocks.
Property PhyDataWt As %Integer;

/// Logical reads of Big Data blocks.
Property LogBdata As %Integer;

/// Physical reads of Big Data blocks.
Property PhyBdataRd As %Integer;

/// Physical writes of Big Data blocks.
Property PhyBdataWt As %Integer;

/// Logical reads of Map blocks.
Property LogMap As %Integer;

/// Physical reads of Map blocks.
Property PhyMapRd As %Integer;

/// Physical writes of Map blocks.
Property PhyMapWt As %Integer;

/// Logical reads of Other blocks (may include incremental backup or storage allocation information).
Property LogOther As %Integer;

/// Physical reads of Other blocks.
Property PhyOtherRd As %Integer;

/// Physical writes of Other blocks.
Property PhyOtherWt As %Integer;

/// Instantiate the class and fill in current values for all properties.
ClassMethod Sample() As SYS.Stats.Disk
{
}

}
