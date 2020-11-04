Include %occInclude

IncludeGenerator %occInclude

/// Use this Class to define application metrics for SYS.History. User classes inherit from 
/// this class and can then define %Numeric properties to create user-defined metrics, which get 
/// collected and summarized like the other SYS.History system metrics. The Sample() method must be 
/// coded to collect all user-defined properties.
/// <br><br>
/// Classes defined using this as a parent class will get included as an embedded object in
/// the SYS.History.User (or UserPerf or UserSys), and the UserHourly and UserDaily persistent classes.
/// <br><br>
/// User written classes must be in the %SYS namespace, and begin with "Z" or "z" to prevent naming 
/// conflicts with system classes. All properties of the user-defined class must be %Numeric. This is 
/// because the same classes get embedded in the Hourly/Daily summaries and the summary functions may 
/// create decimal digits. All of the options for the user-defined classes are defined in the Parameters
/// of this class.
/// <br><br>
/// WARNING: User-defined metics classes become embedded objects in persistent data, and some care must
/// be taken by the user if definitions change after data has been collected. The 'schema evolution' feature
/// of Cache Objects allows you to safely add new objects and properties. But deleting objects can result
/// in 'orphaned' data, and re-defining existing objects can cause data to be misinterpretted. 
Class SYS.History.Adaptor Extends %SerialObject [ System = 3 ]
{

/// Parameter used to select which SYS.History.User* class is used to collect the interval
/// data for this class. Choices are "User", "UserPerf" or "UserSys. This user class will be
/// added as an embedded object to the selected class. These classes correspond to the classes 
/// %Monitor.System.HistoryUser, %Monitor.System.HistoryPerf and %Monitor.System.HistorySys.
/// "UserPerf" and "UserSys" will collect user-defined metrics at the same intervals and with 
/// the same identifying timestamp as the PerfData and SysData classes, so that results may be
/// correlated to those metrics. "User" is only for user-defined data and %Monitor.System.HistoryUser
/// can be set to a different (and non-related) timer interval.
Parameter INTERVAL = "User";

/// This parameter provides a string which is used as the Property name for the embedded
/// objects in the persistent classes. It's recommended that this name be fairly short, since
/// it appears as a prefix for SQL projected tables and properties. It must also be unique for each
/// user-defined class. The class name (without the Package name) will be used if nothing is specified.
Parameter PROPERTY;

/// A comma-delimited list of functions used to calculate Hourly summaries for this class.
/// This may be any of "Avg", "Max", "Min", StDev", Med", or "Tot". Or, it may be "None".
Parameter HOURLYSUM = "Avg,Max,StDev";

/// A comma-delimited list of functions used to calculate Daily summaries for this class.
/// This may be any of "Avg", "Max", "Min", StDev", Med", or "Tot". Or, it may be "None".
Parameter DAILYSUM = "Avg,Max,StDev";

/// Set this parameter to "1" to indicate that the user-defined class will be collected as a
/// %ArrayOfObjects. This allows for multiple instances of the class for each sample. 
/// The user-written Sample() method is responsible for creating the %ArrayOfObjects
/// and the keys which identify the instances of the class.
Parameter ARRAY = 0;

/// If the class is collected as a %ArrayOfObjects, then there are two choices for the Hourly
/// and Daily summaries of the interval data. The default (ARRAYSUM=1) is to calculate a single
/// value of all instances for each summary function (Avg, Max, etc). If ARRAYSUM=0, then each
/// instance will be calculated separately, and the name of the function will be concatenated to
/// the user-defined key to generate a key for the summary instance (see the summaries for
/// SYS.History.Database for an example of how this option looks). 
Parameter ARRAYSUM = 1;

/// This parameter is used to indicate that the properties in this user-defined class 
/// should be collected as delta values. This is generally used when the metrics are
/// "counters", where the values keep increasing and you want to capture the difference
/// between each sample rather than the actual value of each sample.
Parameter DELTA = 0;

/// The Projection adds this class as an embedded object to the SYS.History.User* persistent
/// classes; User (or UserPerf or UserSys), UserHourly, and UserDaily.
Projection AddObject As SYS.History.Projection [ Internal ];

/// ** USER MUST IMPLEMENT THIS CLASS **
/// This method is called to instantiate the user-defined class and provide values for all 
/// properties. If the application namespace must be accessed to fetch the values, then the code
/// may switch namespaces to collect the data, and then MUST switch back to %SYS.
/// <br><br>
/// The application may return either a single instance of their class or a %ArrayOfObjects
/// of that class, depending on how the ARRAY parameter is defined. 
ClassMethod Sample() As %SerialObject
{
}

Storage Default
{
<StreamLocation>^SYS.History.AdaptorS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
