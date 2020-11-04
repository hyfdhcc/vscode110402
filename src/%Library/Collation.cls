/// This class defines the set of common index transformation (or collation) methods.
/// 
/// <p>An index transformation is used to tranform logical data values into 
/// values used by indices.
/// <p>For example, you may wish that a query by name finds 
/// the same results for both "ELVIS" and "elvis". Using a case-insensitive 
/// index transformation, such as String, will accomplish this. If you want an exact 
/// match, use Exact.
/// 
/// <p>Index transformations are specified via a property's <var>COLLATION</var> parameter. Every datatype 
/// has a default <var>COLLATION</var> value, which matches one of the methods of the 
/// <nobr><b>%Collation</b></nobr> class. 
/// The <var>COLLATION</var> parameter can be overwritten by an individual property or by 
/// a specific index definition.
/// 
/// <p>Note that changing a property's <var>COLLATION</var> value will corrupt any index values 
/// currently stored for that property and will require you to manually repopulate the 
/// index.
Class %Library.Collation [ Not ProcedureBlock, System = 2 ]
{

/***********************************************************************\
	|                                                                       |
	\***********************************************************************/
/// Converts a logical value to upper case, strips all punctuation and white space 
/// (except for ',' and '?').
/// <p>This method is included for compatability with earlier products; use 
/// <b>String</b> instead.
ClassMethod AlphaUp(%val As %String) As %String [ CodeMode = expression ]
{
$zu(28,%val,6)
}

/// Performs no transformation; the index value is exactly the logical value.
ClassMethod Exact(%val As %String) As %String [ CodeMode = expression ]
{
%val
}

/// Prepends a minus ('-') sign to the logical value.
/// <p>This method is included for compatability with earlier products; you should not 
/// need it in new applications.
ClassMethod Minus(%val As %String) As %String [ CodeMode = expression ]
{
-%val
}

/// Prepends a plus ('+') sign to the logical value.
/// <p>This method is included for compatability with earlier products; you should not 
/// need it in new applications.
ClassMethod Plus(%val As %String) As %String [ CodeMode = expression ]
{
+%val
}

/// Prepends a space (' ') character to the logical value.
/// <p>This method is included for compatability with earlier products; you should not 
/// need it in new applications.
ClassMethod Space(%val As %String) As %String [ CodeMode = expression ]
{
" "_%val
}

/// Prepends a space to force string collation and strips trailing whitespace.
/// <p>This method is used to insure that strings are collated case-sensitively and that numeric 
/// string values are collated correctly.
ClassMethod SqlString(%val As %String, maxlen As %Integer = 32768) As %String [ CodeMode = expression ]
{
$zu(28,%val,8,maxlen)
}

/// Converts a logical value to upper case, strips trailing whitespace and prepends a space
/// to force string collation.
/// <p>This method is used to insure that strings are collated case-insensitively and that numeric 
/// string values are collated correctly.
ClassMethod SqlUpper(%val As %String, maxlen As %Integer = 32768) As %String [ CodeMode = expression ]
{
$zu(28,%val,7,maxlen)
}

/// Converts a logical value to upper case, strips all punctuation and white space 
/// (except for ',').
/// <p>This method is used to insure that strings are collated case-insensitively and that numeric 
/// string values are collated correctly.
ClassMethod String(%val As %String, maxlen As %Integer = 32768) As %String [ CodeMode = expression ]
{
$zu(28,%val,9,maxlen)
}

/// Converts a logical value to upper case without removing any characters.
ClassMethod Upper(%val As %String) As %String [ CodeMode = expression ]
{
$zu(28,%val,5)
}

/// Converts a logical value to MVR collation
ClassMethod Mvr(%val As %String) As %String [ CodeMode = expression ]
{
$zu(28,%val,2)
}

/// Converts a logical value to exact colation with a defined length limit
ClassMethod Truncate(%val As %String, len As %Integer) As %String [ CodeMode = expression ]
{
$s($d(len):$e(%val,1,len),1:%val)
}

/***********************************************************************\
|												|
\***********************************************************************/
/// Compares a %TimeStamp to a %Date value with the = operator.
ClassMethod TSEQDate(ts As %TimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")=$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %TimeStamp to a %Date value with the &gt; operator.
ClassMethod TSGTDate(ts As %TimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")>$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %TimeStamp to a %Date value with the '&lt; operator.
ClassMethod TSGEDate(ts As %TimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")'<$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %TimeStamp to a %Date value with the &lt; operator.
ClassMethod TSLTDate(ts As %TimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")<$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %TimeStamp to a %Date value with the '&gt; operator.
ClassMethod TSLEDate(ts As %TimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")'>$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %TimeStamp to a %Date value with the '= operator.
ClassMethod TSNEDate(ts As %TimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")'=$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %FilemanTimeStamp to a %TimeStamp value with the = operator.
ClassMethod FMTSEQTS(fmts As %Library.FilemanTimeStamp, ts As %Library.TimeStamp) As %Boolean [ CodeMode = expression ]
{
##class(%Library.FilemanTimeStamp).LogicalToOdbc(fmts)=ts
}

/// Compares a %FilemanTimeStamp to a %TimeStamp value with the '= operator.
ClassMethod FMTSNETS(fmts As %Library.FilemanTimeStamp, ts As %Library.TimeStamp) As %Boolean [ CodeMode = expression ]
{
##class(%Library.FilemanTimeStamp).LogicalToOdbc(fmts)'=ts
}

/// Compares a %FilemanTimeStamp to a %TimeStamp value with the > operator.
ClassMethod FMTSGTTS(fmts As %Library.FilemanTimeStamp, ts As %Library.TimeStamp) As %Boolean [ CodeMode = expression ]
{
##class(%Library.FilemanTimeStamp).LogicalToOdbc(fmts)]]ts
}

/// Compares a %FilemanTimeStamp to a %TimeStamp value with the >= operator.
ClassMethod FMTSGETS(fmts As %Library.FilemanTimeStamp, ts As %Library.TimeStamp) As %Boolean [ CodeMode = expression ]
{
ts']]##class(%Library.FilemanTimeStamp).LogicalToOdbc(fmts)
}

/// Compares a %FilemanTimeStamp to a %TimeStamp value with the < operator.
ClassMethod FMTSLTTS(fmts As %Library.FilemanTimeStamp, ts As %Library.TimeStamp) As %Boolean [ CodeMode = expression ]
{
ts]]##class(%Library.FilemanTimeStamp).LogicalToOdbc(fmts)
}

/// Compares a %FilemanTimeStamp to a %TimeStamp value with the <= operator.
ClassMethod FMTSLETS(fmts As %Library.FilemanTimeStamp, ts As %Library.TimeStamp) As %Boolean [ CodeMode = expression ]
{
##class(%Library.FilemanTimeStamp).LogicalToOdbc(fmts)']]ts
}

/// Compares a %FilemanTimeStamp to a %Date value with the = operator.
ClassMethod FMTSEQDate(ts As %FilemanTimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(##class(%Library.FilemanTimeStamp).LogicalToOdbc(ts),3,,,,,,,,"e")=$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %FilemanTimeStamp to a %Date value with the &gt; operator.
ClassMethod FMTSGTDate(ts As %FilemanTimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(##class(%Library.FilemanTimeStamp).LogicalToOdbc(ts),3,,,,,,,,"e")>$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %FilemanTimeStamp to a %Date value with the '&lt; operator.
ClassMethod FMTSGEDate(ts As %FilemanTimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(##class(%Library.FilemanTimeStamp).LogicalToOdbc(ts),3,,,,,,,,"e")'<$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %FilemanTimeStamp to a %Date value with the &lt; operator.
ClassMethod FMTSLTDate(ts As %FilemanTimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(##class(%Library.FilemanTimeStamp).LogicalToOdbc(ts),3,,,,,,,,"e")<$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %FilemanTimeStamp to a %Date value with the '&gt; operator.
ClassMethod FMTSLEDate(ts As %FilemanTimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(##class(%Library.FilemanTimeStamp).LogicalToOdbc(ts),3,,,,,,,,"e")'>$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %FilemanTimeStamp to a %Date value with the '= operator.
ClassMethod FMTSNEDate(ts As %FilemanTimeStamp, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdth(##class(%Library.FilemanTimeStamp).LogicalToOdbc(ts),3,,,,,,,,"e")'=$zdth(d,3,,,,,,,,d_",0")
}

/// Compares a %FilemanDate to a %Date value with the = operator.
ClassMethod FMDEQDate(fmd As %FilemanDate, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdh(fmd+17000000,8)=d
}

/// Compares a %FilemanDate to a %Date value with the &gt; operator.
ClassMethod FMDGTDate(fmd As %FilemanDate, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdh(fmd+17000000,8)>d
}

/// Compares a %FilemanDate to a %Date value with the '&lt; operator.
ClassMethod FMDGEDate(fmd As %FilemanDate, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdh(fmd+17000000,8)'<d
}

/// Compares a %FilemanDate to a %Date value with the &lt; operator.
ClassMethod FMDLTDate(fmd As %FilemanDate, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdh(fmd+17000000,8)<d
}

/// Compares a %FilemanDate to a %Date value with the '&gt; operator.
ClassMethod FMDLEDate(fmd As %FilemanDate, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdh(fmd+17000000,8)'>d
}

/// Compares a %FilemanDate to a %Date value with the '= operator.
ClassMethod FMDNEDate(fmd As %FilemanDate, d As %Date) As %Boolean [ CodeMode = expression ]
{
$zdh(fmd+17000000,8)'=d
}

/// ----------------------
/// These methods deal with comparing %Library.FilemanDate values with %Library.TimeStamp
/// Compares a %FilemanDate to a %TimeStamp value with the = operator.
ClassMethod FMDEQTS(fmd As %FilemanDate, ts As %TimeStamp) As %Boolean [ CodeMode = expression ]
{
$zdth($zdh(fmd+17000000,8),3,,,,,,,,$zdh(fmd+17000000,8)_",0")=$zdth(ts,3,,,,,,,,"e")
}

/// Compares a %FilemanDate to a %TimeStamp value with the &gt; operator.
ClassMethod FMDGTTS(fmd As %FilemanDate, ts As %TimeStamp) As %Boolean [ CodeMode = expression ]
{
$zdth($zdh(fmd+17000000,8),3,,,,,,,,$zdh(fmd+17000000,8)_",0")>$zdth(ts,3,,,,,,,,"e")
}

/// Compares a %FilemanDate to a %TimeStamp value with the '&lt; operator.
ClassMethod FMDGETS(fmd As %FilemanDate, ts As %TimeStamp) As %Boolean [ CodeMode = expression ]
{
$zdth($zdh(fmd+17000000,8),3,,,,,,,,$zdh(fmd+17000000,8)_",0")'<$zdth(ts,3,,,,,,,,"e")
}

/// Compares a %FilemanDate to a %TimeStamp value with the &lt; operator.
ClassMethod FMDLTTS(fmd As %FilemanDate, ts As %TimeStamp) As %Boolean [ CodeMode = expression ]
{
$zdth($zdh(fmd+17000000,8),3,,,,,,,,$zdh(fmd+17000000,8)_",0")<$zdth(ts,3,,,,,,,,"e")
}

/// Compares a %FilemanDate to a %TimeStamp value with the '&gt; operator.
ClassMethod FMDLETS(fmd As %FilemanDate, ts As %TimeStamp) As %Boolean [ CodeMode = expression ]
{
$zdth($zdh(fmd+17000000,8),3,,,,,,,,$zdh(fmd+17000000,8)_",0")'>$zdth(ts,3,,,,,,,,"e")
}

/// Compares a %FilemanDate to a %TimeStamp value with the '= operator.
ClassMethod FMDNETS(fmd As %FilemanDate, ts As %TimeStamp) As %Boolean [ CodeMode = expression ]
{
$zdth($zdh(fmd+17000000,8),3,,,,,,,,$zdh(fmd+17000000,8)_",0")'=$zdth(ts,3,,,,,,,,"e")
}

/// ----------------------
/// These methods deal with comparing %MV.Date values with %Library.Date
/// The MultiValue start date is 01/01/1968<br>
/// Cache' start date is 01/01/1841<br>
/// <br>
/// To convert a Cache' date ($h) to a MultiValue date:<br>
/// MVdate = CACHEdate - 46385 <br>
/// <br>
/// To convert a MultiValue date to a Cache' date:<br>
/// CACHEdate = MVdate + 46385 <br>
/// ----------------------
/// Compares a %MV.Date to a %Date value with the = operator.
ClassMethod MVDEQDate(mvd As %MV.Date, d As %Date) As %Boolean [ CodeMode = expression ]
{
(mvd+46385)=d
}

/// Compares a %MV.Date to a %Date value with the &gt; operator.
ClassMethod MVDGTDate(mvd As %MV.Date, d As %Date) As %Boolean [ CodeMode = expression ]
{
(mvd+46385)>d
}

/// Compares a %MV.Date to a %Date value with the '&lt; operator.
ClassMethod MVDGEDate(mvd As %MV.Date, d As %Date) As %Boolean [ CodeMode = expression ]
{
(mvd+46385)'<d
}

/// Compares a %MV.Date to a %Date value with the &lt; operator.
ClassMethod MVDLTDate(mvd As %MV.Date, d As %Date) As %Boolean [ CodeMode = expression ]
{
(mvd+46385)<d
}

/// Compares a %MV.Date to a %Date value with the '&gt; operator.
ClassMethod MVDLEDate(mvd As %MV.Date, d As %Date) As %Boolean [ CodeMode = expression ]
{
(mvd+46385)'>d
}

/// Compares a %MV.Date to a %Date value with the '= operator.
ClassMethod MVDNEDate(mvd As %MV.Date, d As %Date) As %Boolean [ CodeMode = expression ]
{
(mvd+46385)'=d
}

/// ----------------------
/// These methods deal with comparing %MV.Date values with %Library.TimeStamp
/// ----------------------
/// Compares a %TimeStamp to a %MV.Date value with the = operator.
ClassMethod TSEQMVDate(ts As %TimeStamp, d As %MV.Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")=$zdth(d+46385,3,,,,,,,,d+46385_",0")
}

/// Compares a %TimeStamp to a %MV.Date value with the &gt; operator.
ClassMethod TSGTMVDate(ts As %TimeStamp, d As %MV.Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")>$zdth(d+46385,3,,,,,,,,d+46385_",0")
}

/// Compares a %TimeStamp to a %MV.Date value with the '&lt; operator.
ClassMethod TSGEMVDate(ts As %TimeStamp, d As %MV.Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")'<$zdth(d+46385,3,,,,,,,,d+46385_",0")
}

/// Compares a %TimeStamp to a %MV.Date value with the &lt; operator.
ClassMethod TSLTMVDate(ts As %TimeStamp, d As %MV.Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")<$zdth(d+46385,3,,,,,,,,d+46385_",0")
}

/// Compares a %TimeStamp to a %MV.Date value with the '&gt; operator.
ClassMethod TSLEMVDate(ts As %TimeStamp, d As %MV.Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")'>$zdth(d+46385,3,,,,,,,,d+46385_",0")
}

/// Compares a %TimeStamp to a %MV.Date value with the '= operator.
ClassMethod TSNEMVDate(ts As %TimeStamp, d As %MV.Date) As %Boolean [ CodeMode = expression ]
{
$zdth(ts,3,,,,,,,,"e")'=$zdth(d+46385,3,,,,,,,,d+46385_",0")
}

}
