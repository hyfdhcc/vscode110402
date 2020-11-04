Include %sySystem

Class SYS.ApplicationError [ Abstract ]
{

/// Deletes all application errors for the dates passed in for a given namespace.
/// Parameters:<br>
/// Namespace - Namespace to delete errors in<br>
/// DateList - Comma separated list of dates to delete, "6/4/2012,6/5/2012"<br>
ClassMethod DeleteByDate(Namespace As %String, DateList As %String) As %Status
{
}

/// Deletes the application errors passed in for a given namespace and a given date.
/// The input parameters are the namespace name, the date and a list of error numbers.
/// 
ClassMethod DeleteByError(Nsp As %String, Date As %String, ErrorList As %String) As %Status
{
}

/// Deletes all application errors for all dates for the namespaces passed in.
/// The input parameter is a list of namespaces.
/// 
ClassMethod DeleteByNamespace(NspList As %String) As %Status
{
}

/// Read the comment in a selected error
ClassMethod GetComment(Namespace As %String, Date As %String, Error As %Integer = 0, ByRef Comment As %String, ByRef CommentDate As %String) As %Status
{
}

/// Set a comment into the selected error
ClassMethod SetComment(Namespace As %String, Date As %String, Error As %Integer = 0, Comment As %String) As %Status
{
}

/// Returns the dates when application errors occurred for a given namespace.
/// 
Query DateList(Namespace As %String) As %Query(ROWSPEC = "Date:%Date,Qty:%Integer")
{
}

ClassMethod DateListExecute(ByRef qHandle As %Binary, Namespace As %String) As %Status
{
}

ClassMethod DateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DateListExecute ]
{
}

ClassMethod DateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DateListExecute ]
{
}

/// Returns the logged Expressions and their corresponding Values (top level) for a given Namespace on a given Date for a particular Error.
/// The Date has to be in display format (e.g. 1/1/09).
/// Type: 0 = Expressions
///      -1 = Stack Levels
///      -2 = Collapsed stack levels
///       i = Variables of Stack Level #i
/// 
Query ErrorDetail(Namespace As %String, Date As %String, Error As %Integer, Type As %Integer = 0) As %Query(ROWSPEC = "Column1:%String,Column2:%String,Column3:%String,Column4:%String")
{
}

ClassMethod ErrorDetailExecute(ByRef qHandle As %Binary, Namespace As %String, Date As %String, Error As %Integer, Type As %Integer) As %Status
{
}

ClassMethod ErrorDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ErrorDetailExecute ]
{
}

ClassMethod ErrorDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ErrorDetailExecute ]
{
}

/// Returns the errors logged for a given Namespace on a given Date.
/// The Date has to be in display format (e.g. 1/1/09).
/// 
Query ErrorList(Namespace As %String, Date As %String) As %Query(ROWSPEC = "Error #:%Integer,Error message:%String,Time:%String,Process:%String,DisplayPID:%String,Username:%String,Code line:%String")
{
}

ClassMethod ErrorListExecute(ByRef qHandle As %Binary, Namespace As %String, Date As %String) As %Status
{
}

ClassMethod ErrorListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ErrorListExecute ]
{
}

ClassMethod ErrorListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ErrorListExecute ]
{
}

/// Returns the Namespaces that contain application errors.
/// 
Query NamespaceList(ListType As %Integer) As %Query(ROWSPEC = "Namespace:%String:Namespace")
{
}

/// ListType = 0 - All namespaces
///            1 - Remote namespaces only
///            2 - Local namespaces only
ClassMethod NamespaceListExecute(ByRef qHandle As %Binary, ListType As %Integer = 0) As %Status
{
}

ClassMethod NamespaceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NamespaceListExecute ]
{
}

ClassMethod NamespaceListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NamespaceListExecute ]
{
}

}
