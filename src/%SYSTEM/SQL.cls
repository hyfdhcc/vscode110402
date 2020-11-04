Include %msql

IncludeGenerator %msql

/// The <class>%SYSTEM.SQL</class> class provides an interface for managing
/// Cach&eacute; SQL configurations.<br>
/// <p>You can use it via the special <b>$SYSTEM</b> object:<br>
/// <p>
/// Do $SYSTEM.SQL.CurrentSettings()
/// <p>You can call help to get a list of all entry points:<br>
/// <p>
/// Do $SYSTEM.SQL.Help()
Class %SYSTEM.SQL Extends Help [ Abstract, Not ProcedureBlock, System = 4 ]
{

/// ALPHAUP returns the Alphaup collation of the passed in value.
/// <dl>
/// <dt>$SYSTEM.SQL.ALPHAUP(<i>stringexp</i>)<br>
/// <dd><i>stringexp</i> Any string expression value.<br>
/// ALPHAUP converts all alphabetic characters to upper case (i.e., the ALPHAUP format) and removes all punctuation except commas and question marks.
/// </dl>
ClassMethod ALPHAUP(stringexp As %Library.String = "") As %Library.String [ ProcedureBlock = 1 ]
{
	QUIT $$$ALPHAUP(stringexp)
}

/// MVR returns the MVR collation of the passed in value.
/// <p>
/// $SYSTEM.SQL.MVR(<i>stringexp</i>)<br>
/// <dl>
/// <dt><i>stringexp</i>
/// <dd>Any string expression value.<br>
/// </dl>
/// MVR performs collation translations needed for MultiValue
ClassMethod MVR(stringexp As %Library.String = "") As %Library.String [ ProcedureBlock = 1 ]
{
	QUIT $$$MVR(stringexp)
}

/// SQLSTRING returns the SqlString collation of the passed in value.
/// <p>
/// $SYSTEM.SQL.SQLSTRING(<i>stringexp</i>,<i>maxlen</i>)<br>
/// <dl>
/// <dt><i>stringexp</i>
/// <dd>Any string expression value.<br>
/// <dt><i>maxlen</i>
/// <dd>Optional. An integer, which specifies that the collated value will be truncated to the value of maxlen.<br>
/// SQLSTRING converts stringexp to a format that is sorted as a (case-sensitive) string. SQLSTRING strips trailing white space (spaces, tabs, and so on) from the string, then adds one leading blank space to the beginning of the string. It collates any value containing only white space (spaces, tabs, and so on) as the SQL empty string. SQL Empty string is represented as $Char(0) in ObjectScript, which collated as SqlString is " "_$Char(0).
/// </dl>
ClassMethod SQLSTRING(stringexp As %Library.String = "", maxlen As %Library.Integer) As %Library.String [ ProcedureBlock = 1 ]
{
	QUIT $$$SQLSTRINGT(stringexp,$g(maxlen,$$$MaxStringLength))
}

/// SQLUPPER returns the SqlUpper collation of the passed in value.
/// <p>
/// $SYSTEM.SQL.SQLUPPER(<i>stringexp</i>,<i>maxlen</i>)<br>
/// <dl>
/// <dt><i>stringexp</i>
/// <dd>Any string expression value.<br>
/// <dt><i>maxlen</i>
/// <dd>Optional. An integer, which specifies that the collated value will be truncated to the value of maxlen.<br>
/// </dl>
/// SQLUPPER converts stringexp to a format that is sorted as a (case-insensitive) upper-case string. SQLUPPER converts all alphabetic characters to uppercase, strips trailing white space (spaces, tabs, and so on) from the string, then adds one leading blank space to the beginning of the string. It collates any value containing only white space (spaces, tabs, and so on) as the SQL empty string. SQL Empty string is represented as $Char(0) in ObjectScript, which collated as SqlUpper is " "_$Char(0).
ClassMethod SQLUPPER(stringexp As %Library.String = "", maxlen As %Library.Integer) As %Library.String [ ProcedureBlock = 1 ]
{
	QUIT $$$SQLUPPERT(stringexp,$g(maxlen,$$$MaxStringLength))
}

/// STRING returns the String collation of the passed in value.
/// <p>
/// $SYSTEM.SQL.STRING(<i>stringexp</i>,<i>maxlen</i>)<br>
/// <dl>
/// <dt><i>stringexp</i>
/// <dd>Any string expression value.<br>
/// <dt><i>maxlen</i>
/// <dd>Optional. An integer, which specifies that the collated value will be truncated to the value of maxlen.<br>
/// STRING converts stringexp to a STRING collation format.
/// </dl>
/// STRING converts all alphabetic characters are uppercased; all punctuation characters are removed, except the comma; a single space is added to the beginning of the expression. It collates any value containing only white space (spaces, tabs, and so on) as the SQL empty string. SQL Empty string is represented as $Char(0) in ObjectScript, which collated as String is " "_$Char(0).
ClassMethod STRING(stringexp As %Library.String = "", maxlen As %Library.Integer) As %Library.String [ ProcedureBlock = 1 ]
{
	QUIT $$$STRINGT(stringexp,$g(maxlen,$$$MaxStringLength))
}

/// TRUNCATE returns the Truncate collation of the passed in value.
/// <p>
/// $SYSTEM.SQL.TRUNCATE(<i>stringexp</i>,<i>maxlen</i>)<br>
/// <dl>
/// <dt><i>stringexp</i>
/// <dd>Any string expression value.<br>
/// <dt><i>maxlen</i>
/// <dd>Optional. An integer, which specifies that the collated value will be truncated to the length of <i>maxlen</i>.
/// If <i>maxlen</i> is not specified, TRUNCATE behaves the same as EXACT.<br>
/// TRUNCATE leaves <i>stringexp</i> in the exact format it receives and is sorted as a (case-sensitive) string.  TRUNCATE simply returns the first <i>maxlen</i> characters of the expression.
/// </dl>
ClassMethod TRUNCATE(stringexp As %Library.String = "", maxlen As %Library.Integer = 32768) As %Library.String [ ProcedureBlock = 1 ]
{
	QUIT $$$TRUNCATET(stringexp,$s(maxlen:maxlen,1:32768))
}

/// UPPER returns the Upper collation of the passed in value.
/// <p>
/// $SYSTEM.SQL.UPPER(<i>stringexp</i>)<br>
/// <dl>
/// <dt><i>stringexp</i>
/// <dd>Any string expression value.<br>
/// </dl>
/// UPPER converts all alphabetic characters to upper case (i.e., the UPPER format). Note that punctuation is not changed.
ClassMethod UPPER(stringexp As %Library.String = "") As %Library.String [ ProcedureBlock = 1 ]
{
	QUIT $$$UPPER(stringexp)
}

/// ABS returns the absolute value, which is always zero or a positive number
/// <p>
/// $SYSTEM.SQL.ABS(<i>numeric-expression</i>)<br>
/// <dl>
/// <dt><i>numeric-expression</i>
/// <dd>A number whose absolute value is to be returned<br>
/// </dl>
/// ABS returns the same data type as numeric-expression. If numeric-expression is not a number (for example, the string 'abc') ABS returns 0. ABS returns NULL when passed a NULL value. 
ClassMethod ABS(val As %Library.String = "") As %Library.Float [ ProcedureBlock = 1 ]
{
	QUIT $s(val="":"",1:$zabs(+val))
}

/// CEILING is a scalar numeric function that returns the smallest integer greater than or equal to a given numeric expression
/// <p>
/// $SYSTEM.SQL.CEILING(<i>numeric-expression</i>)<br>
/// <dl>
/// <dt><i>numeric-expression</i>
/// <dd>A number whose ceiling is to be calculated<br>
/// </dl>
ClassMethod CEILING(val As %Library.String = "") As %Library.Float [ ProcedureBlock = 1 ]
{
	QUIT $s('$isvalidnum(val):"",+val[".":+$p(val,".")+(val>0),1:+val)
}

/// CONVERT is a SQL function that converts a given expression to a specified data type.<br>
/// <p>
/// $SYSTEM.SQL.CONVERT(<i>expr</i>,<i>convto</i>,<i>convfrom</i>)<br>
/// <dl>
/// <dt><i>expr</i>
/// <dd>The expression to be converted<br>
/// <dt><i>convto</i>
/// <dd>The data type to which <i>expr</i> is to be converted. Currently, only "SQL_TIMESTAMP", "SQL_TIME", "SQL_DATE", "SQL_VARCHAR", "SQL_INTEGER", and "SQL_DOUBLE" are supported<br>
/// <dt><i>convfrom</i>
/// <dd>The data type of <i>expr</i>. Currently, only "SQL_TIMESTAMP", "SQL_TIME", "SQL_DATE", "SQL_VARCHAR", "SQL_INTEGER", and "SQL_DOUBLE" are supported<br>
/// </dl>
/// CONVERT is a SQL function that converts expression <i>expr</i> from type <i>convfrom</i> to the specified data type <i>convto</i>.<br>
/// The <i>convfrom</i> value is expected to be a Logical value for SQL_DATE and SQL_TIME.
/// When converting from SQL_DATE or SQL_TIME to SQL_TIMESTAMP, the input value is expected to be a Logical Date or Time value.
/// When converting from SQL_VARCHAR to SQL_TIME, the input value is expected to be an ODBC Time formatted value.
/// When converting from SQL_VARCHAR to SQL_DATE, the input value is expected to be an ODBC Date formatted value.
/// When converting from SQL_DATE or SQL_TIME to SQL_VARCHAR, the returned value will contain the ODBC format of the date or time value.
ClassMethod CONVERT(expr As %Library.String = "", convto As %Library.String = "", convfrom As %Library.String = "") As %Library.String [ ProcedureBlock = 1 ]
{
	s convto=$$$UPPER(convto),convfrom=$$$UPPER(convfrom)
	i convto="SQL_TIMESTAMP" QUIT $s(expr="":"",convfrom="SQL_DATE":##class(%Library.Date).LogicalToOdbc(expr)_" 00:00:00",convfrom="SQL_TIME":##class(%Library.Date).LogicalToOdbc(+$H)_" "_##class(%Library.Time).LogicalToOdbc(expr),1:expr)
	i convto="SQL_TIME" QUIT $s(expr="":"",convfrom="SQL_TIMESTAMP":$p($zdth(expr,3,,,,,,,,""),",",2),convfrom="SQL_VARCHAR":$zth(expr,,""),1:+expr\1)
	i convto="SQL_DATE" QUIT $s(expr="":"",convfrom="SQL_TIMESTAMP":$zdh(expr,3,,,,,,,""),convfrom="SQL_VARCHAR":$zdh(expr,3,,,,,,,""),1:+expr\1)
	i convto="SQL_VARCHAR" QUIT $s(convfrom="SQL_DATE":##class(%Library.Date).LogicalToOdbc(expr),convfrom="SQL_TIME":##class(%Library.Time).LogicalToOdbc(expr),1:expr)
	i convto="SQL_INTEGER" QUIT $s(expr="":"",1:+expr\1)
	i convto="SQL_DOUBLE" QUIT $s(expr="":"",1:$double(expr))
	QUIT ""
}

/// DATE is a date/time function that returns the date portion of the given date or timestamp expression
/// <p>
/// $SYSTEM.SQL.DATE(<i>exp</i>)<br>
/// <dl>
/// <dt><i>exp</i>
/// <dd>An expression that is a logical %Library.Date, %Library.TimeStamp, %Library.Integer, or %Library.String value that represents a logical %Date or logical %TimeStamp value.<br>
/// </dl>
/// If "" (null) is passed in, "" (null) is returned.  If <i>exp</i> is not numeric, it is assuemed the expression is in %TimeStamp logical format.
/// Note, that if a string value is passed in as <i>exp</i>, it is expected that the value is a logical %TimeStamp format, and not $Horolog format.  To convert $Horolog to DATE, use $SYSTEM.SQL.DATE(+$HOROLOG),<br>
ClassMethod DATE(exp As %Library.String = "") As %Library.Date [ ProcedureBlock = 1 ]
{
	QUIT $s(exp="":"",$isvalidnum(exp):+exp\1,1:$zdh(exp,3,,,,,,,0))
}

/// DATEADD is a general date/time function that returns a date calculated by adding a certain number of date parts (such as hours or days) to a specified timestamp
/// <p>
/// $SYSTEM.SQL.DATEADD(<i>datepart</i>,<i>numeric-exp</i>,<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>datepart</i>
/// <dd>The full name or abbreviation of a date or time part.<br>
/// The following date parts are supported for DATEADD<br>
///     year		yy		yyyy<br>
///     quarter         qq		q<br>
///     month           mm		m<br>
///     week            wk		ww<br>
///     dayofyear       dy		y<br>
///     day             dd		d<br>
///     hour            hh		<br>
///     minute          mi		n<br>
///     second          ss		s<br>
///     millisecond     ms<br>
/// <dt><i>numeric-exp</i>
/// <dd>A numeric expression of any number type. The value is truncated to an integer. 
/// The value indicates the number of dateparts that will be added to <i>dateexp</i>.<br>
/// <dt><i>dateexp</i>
/// <dd>The date/time expression that will be modified.<br>
/// The <i>dateexp</i> parameter can be in any of the following formats, and may include or omit fractional seconds:
/// <ul>
/// <li> A Caché %Date logical value (+$H)</li>
/// <li> A Caché %TimeStamp logical value (YYYY-MM-DD HH:MM:SS)</li>
/// <li> A Caché %String (or compatible) value</li>
/// The Caché %String (or compatible) value can be in any of the following formats:<br>
///  99999,99999 ($H format)<br>
///  Sybase/SQL-Server-date Sybase/SQL-Server-time<br>
///  Sybase/SQL-Server-time Sybase/SQL-Server-date<br>
///  Sybase/SQL-Server-date (default time is 00:00:00)<br>
///  Sybase/SQL-Server-time (default date is 01/01/1900)<br>
/// Sybase/SQL-Server-date is one of these five formats:<br>
/// mm<i>delimiter</i>dd<i>delimiter</i>[yy]yy<br>
/// dd Mmm[mm][,][yy]yy<br>
/// dd [yy]yy Mmm[mm]<br>
/// yyyy Mmm[mm] dd<br>
/// yyyy [dd] Mmm[mm]<br>
/// where <i>delimiter</i> is a slash (/), hyphen (-), or period (.).<br>
/// Sybase/SQL-Server-time represents one of these three formats:<br>
/// HH:MM[:SS:SSS][{AM|PM}]<br>
/// HH:MM[:SS.S]<br>
/// HH['']{AM|PM}<br>
/// </ul>
/// If the year is given as two digits, Caché checks the sliding window to interpret the date. The system default for the sliding window can be set via the %DATE utility, which is documented only in the "Legacy Documentation" chapter in Using InterSystems Documentation.
/// </dl>
ClassMethod DATEADD(datepart As %Library.String = "", val As %Library.Numeric = "", dateexp As %Library.String = "") As %Library.TimeStamp [ ProcedureBlock = 1, PublicList = SQLCODE ]
{
	new %msg,SQLCODE
	QUIT $$dateadd^%qarfunc(datepart,val,dateexp)
}

/// DATEDIFF is a general date/time function that returns the interval between two dates
/// <p>$SYSTEM.SQL.DATEDIFF(<i>datepart</i>,<i>startdate</i>,<i>enddate</i>)<br>
/// <dl>
/// <dt><i>datepart</i>
/// <dd>The date part in which the interval is to be measured.<br>
/// The following date parts are supported for DATEDIFF<br>
///     year		yy		yyyy<br>
///     month           mm		m<br>
///     week            wk		ww<br>
///     day             dd		d<br>
///     hour            hh		<br>
///     minute          mi		n<br>
///     second          ss		s<br>
///     millisecond     ms<br>
/// <dt><i>startdate</i>
/// <dd>The starting date for the interval.<br>
/// <dt><i>enddate</i>
/// <dd>The ending date for the interval.
/// </dl>
/// Startdate is subtracted from enddate to determine how many datepart intervals are between the two dates.<br>
/// The <i>startdate</i> and <i>enddate</i> parameters can be in any of the following formats:
/// <ul>
/// <li> A Cach&eacute; %Date logical value (+$H)</li>
/// <li> A Cach&eacute; %TimeStamp logical value (YYYY-MM-DD HH:MM:SS)</li>
/// <li> A Cach&eacute; %String (or compatible) value</li>
/// <li>The Cach&eacute; %String (or compatible) value can be in any of the following formats, and may include or omit fractional seconds:</li><br>
///  99999,99999 ($HOROLOG format)<br>
///  Sybase/SQL-Server-date Sybase/SQL-Server-time<br>
///  Sybase/SQL-Server-time Sybase/SQL-Server-date<br>
///  Sybase/SQL-Server-date (default time is 00:00:00)<br>
///  Sybase/SQL-Server-time (default date is 01/01/1900)<br>
/// <li>Sybase/SQL-Server-date is one of these five formats:</li><br>
/// mm<i>delimiter</i>dd<i>delimiter</i>[yy]yy<br>
/// dd Mmm[mm][,][yy]yy<br>
/// dd [yy]yy Mmm[mm]<br>
/// yyyy Mmm[mm] dd<br>
/// yyyy [dd] Mmm[mm]<br>
/// where <i>delimiter</i> is a slash (/), hyphen (-), or period (.).
/// <li>Sybase/SQL-Server-time represents one of these three formats:</li><br>
/// HH:MM[:SS:SSS][{AM|PM}]<br>
/// HH:MM[:SS.S]<br>
/// HH['']{AM|PM}<br>
/// </ul>
/// If the year is given as two digits, Cach&eacute; checks the sliding window to interpret the date. The system default for the sliding window can be set via the %DATE utility, which is documented only in the "Legacy Documentation" chapter in Using InterSystems Documentation.
ClassMethod DATEDIFF(datepart As %Library.String = "", startdate As %Library.String = "", enddate As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1, PublicList = SQLCODE ]
{
	new %msg,SQLCODE
	QUIT $$datediff^%qarfunc(datepart,startdate,enddate)
}

/// DATENAME is a general date/time function that returns a CHARACTER STRING containing the name of the specified date part of a date/time value.
/// <p>
/// $SYSTEM.SQL.DATENAME(<i>datepart</i>,<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>datepart</i>
/// <dd>The type of date part that the returned value will represent.<br>
/// The following date parts are supported for DATENAME<br>
///     year		yy		yyyy<br>
///     quarter         qq		q<br>
///     month           mm		m<br>
///     week            wk		ww<br>
/// 	weekday		dw<br>
///     dayofyear       dy		y<br>
///     day             dd		d<br>
///     hour            hh		<br>
///     minute          mi		n<br>
///     second          ss		s<br>
///     millisecond     ms<br>
/// <dt><i>dateexp</i>
/// <dd>A date/time expression from which the date part is to be returned.
/// </dl>
/// The <i>dateexp</i> parameter can be in any of the following formats:
/// <ul>
/// <li> A Cach&eacute; %Date logical value (+$H)</li>
/// <li> A Cach&eacute; %TimeStamp logical value (YYYY-MM-DD HH:MM:SS)</li>
/// <li> A Cach&eacute; %String (or compatible) value</li>
/// <li>The Cach&eacute; %String (or compatible) value can be in any of the following formats, and may include or omit fractional seconds:</li><br>
///  99999,99999 ($HOROLOG format)<br>
///  Sybase/SQL-Server-date Sybase/SQL-Server-time<br>
///  Sybase/SQL-Server-time Sybase/SQL-Server-date<br>
///  Sybase/SQL-Server-date (default time is 00:00:00)<br>
///  Sybase/SQL-Server-time (default date is 01/01/1900)<br>
/// <li>Sybase/SQL-Server-date is one of these five formats:</li><br>
/// mm<i>delimiter</i>dd<i>delimiter</i>[yy]yy<br>
/// dd Mmm[mm][,][yy]yy<br>
/// dd [yy]yy Mmm[mm]<br>
/// yyyy Mmm[mm] dd<br>
/// yyyy [dd] Mmm[mm]<br>
/// where <i>delimiter</i> is a slash (/), hyphen (-), or period (.).
/// <li>Sybase/SQL-Server-time represents one of these three formats:</li><br>
/// HH:MM[:SS:SSS][{AM|PM}]<br>
/// HH:MM[:SS.S]<br>
/// HH['']{AM|PM}<br>
/// </ul>
/// If the year is given as two digits, Cach&eacute; checks the sliding window to interpret the date. The system default for the sliding window can be set via the %DATE utility, which is documented only in the "Legacy Documentation" chapter in Using InterSystems Documentation.
ClassMethod DATENAME(datepart As %Library.String = "", dateexp As %Library.String = "") As %Library.String [ ProcedureBlock = 1, PublicList = SQLCODE ]
{
	new %msg,SQLCODE
	QUIT $$datename^%qarfunc(datepart,dateexp)
}

/// DATEPART is a general date/time function that returns an INTEGER representing the specified date/time part of the specified date/time expression.
/// <p>
/// $SYSTEM.SQL.DATEPART(<i>datepart</i>,<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>datepart</i>
/// <dd>The type of date part that the returned value will represent.<br>
/// The following date parts are supported for DATEPART<br>
///     year		yy		yyyy<br>
///     quarter         qq		q<br>
///     month           mm		m<br>
///     week            wk		ww<br>
/// 	weekday		dw<br>
///     dayofyear       dy		y<br>
///     day             dd		d<br>
///     hour            hh		<br>
///     minute          mi		n<br>
///     second          ss		s<br>
///     millisecond     ms<br>
///     sqltimestamp	sts<br>
/// The sqltimestamp (abbreviated sts) datepart value is for use only with DATEPART. Do not attempt to use this parameter value in other contexts
/// <dt><i>dateexp</i>
/// <dd>A date/time expression from which the date part is to be returned.
/// </dl>
/// <i>dateexp</i> must contain a value of type datepart.<br>
/// The <i>dateexp</i> parameter can be in any of the following formats:
/// <ul>
/// <li> A Cach&eacute; %Date logical value (+$H)</li>
/// <li> A Cach&eacute; %TimeStamp logical value (YYYY-MM-DD HH:MM:SS)</li>
/// <li> A Cach&eacute; %String (or compatible) value</li>
/// <li>The Cach&eacute; %String (or compatible) value can be in any of the following formats, and may include or omit fractional seconds:</li><br>
///  99999,99999 ($HOROLOG format)<br>
///  Sybase/SQL-Server-date Sybase/SQL-Server-time<br>
///  Sybase/SQL-Server-time Sybase/SQL-Server-date<br>
///  Sybase/SQL-Server-date (default time is 00:00:00)<br>
///  Sybase/SQL-Server-time (default date is 01/01/1900)<br>
/// <li>Sybase/SQL-Server-date is one of these five formats:</li><br>
/// mm<i>delimiter</i>dd<i>delimiter</i>[yy]yy<br>
/// dd Mmm[mm][,][yy]yy<br>
/// dd [yy]yy Mmm[mm]<br>
/// yyyy Mmm[mm] dd<br>
/// yyyy [dd] Mmm[mm]<br>
/// where <i>delimiter</i> is a slash (/), hyphen (-), or period (.).
/// <li>Sybase/SQL-Server-time represents one of these three formats:</li><br>
/// HH:MM[:SS:SSS][{AM|PM}]<br>
/// HH:MM[:SS.S]<br>
/// HH['']{AM|PM}<br>
/// </ul>
/// If the year is given as two digits, Cach&eacute; checks the sliding window to interpret the date. The system default for the sliding window can be set via the %DATE utility, which is documented only in the "Legacy Documentation" chapter in Using InterSystems Documentation.
ClassMethod DATEPART(datepart As %Library.String = "", dateexp As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1, PublicList = SQLCODE ]
{
	new %msg,SQLCODE
	QUIT $$datepart^%qarfunc(datepart,dateexp)
}

/// DAYNAME is a date/time function that returns a character string containing the name of the day in a given date expression.
/// <p>
/// $SYSTEM.SQL.DAYNAME(<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>dateexp</i>
/// <dd>An expression that is a logical %Library.Date value or timestamp literal.<br>
/// </dl>
/// The <i>startdate</i> and <i>enddate</i> parameters can be in any of the following formats:
/// <ul>
/// <li> A Cach&eacute; %Date logical value (+$H)</li>
/// <li> A Cach&eacute; %TimeStamp logical value (YYYY-MM-DD HH:MM:SS)</li>
/// <li> A Cach&eacute; %String (or compatible) value</li>
/// <li>The Cach&eacute; %String (or compatible) value can be in any of the following formats, and may include or omit fractional seconds:</li><br>
///  99999,99999 ($HOROLOG format)<br>
///  Sybase/SQL-Server-date Sybase/SQL-Server-time<br>
///  Sybase/SQL-Server-time Sybase/SQL-Server-date<br>
///  Sybase/SQL-Server-date (default time is 00:00:00)<br>
///  Sybase/SQL-Server-time (default date is 01/01/1900)<br>
/// <li>Sybase/SQL-Server-date is one of these five formats:</li><br>
/// mm<i>delimiter</i>dd<i>delimiter</i>[yy]yy<br>
/// dd Mmm[mm][,][yy]yy<br>
/// dd [yy]yy Mmm[mm]<br>
/// yyyy Mmm[mm] dd<br>
/// yyyy [dd] Mmm[mm]<br>
/// where <i>delimiter</i> is a slash (/), hyphen (-), or period (.).
/// <li>Sybase/SQL-Server-time represents one of these three formats:</li><br>
/// HH:MM[:SS:SSS][{AM|PM}]<br>
/// HH:MM[:SS.S]<br>
/// HH['']{AM|PM}<br>
/// </ul>
/// If the year is given as two digits, Cach&eacute; checks the sliding window to interpret the date. The system default for the sliding window can be set via the %DATE utility, which is documented only in the "Legacy Documentation" chapter in Using InterSystems Documentation.
/// 
ClassMethod DAYNAME(dateexp As %Library.String = "") As %Library.String [ ProcedureBlock = 1 ]
{
	QUIT $s(dateexp="":"",dateexp=+dateexp:$zd(dateexp,12,,,,,-672045),1:$zd($zdh($p(dateexp," "),3,,,,,-672045),12))
}

/// DAYOFMONTH is a date/time function that returns an integer from 1 to 31 that corresponds to the day of the month in a given date expression.
/// <p>
/// $SYSTEM.SQL.DAYOFMONTH(<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>dateexp</i>
/// <dd>An expression that is a logical %Library.Date value or timestamp literal.<br>
/// </dl>
ClassMethod DAYOFMONTH(dateexp As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1 ]
{
	QUIT $s(dateexp="":"",dateexp=+dateexp:+$zd(dateexp,2,,,,,-672045),1:$s(+$p(dateexp,"-",3):+$p(dateexp,"-",3),1:""))
}

/// DAYOFWEEK is a date/time function that returns an integer from 1 to 7 that corresponds to the day of the week in a given date expression.
/// <p>
/// $SYSTEM.SQL.DAYOFWEEK(<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>dateexp</i>
/// <dd>An expression that is a logical %Library.Date value, an $Horolog value, or timestamp literal.<br>
/// </dl>
/// The returned values represent these days: 1 - Sunday, 2 - Monday, 3 - Tuesday, 4 - Wednesday, 5 - Thursday, 6 - Friday, 7 - Saturday<br>
/// The Cach&eacute; default is that Sunday is the first day of the week.<br>
/// This default can be overridden by specifying SET ^%SYS("sql","sys","day of week")=n, where n values are 1=Monday through 7=Sunday.<br>
/// Thus, to reset the Cach&eacute; default specify SET ^%SYS("sql","sys","day of week")=7.<br>
/// The day of week setting can also be defined on a per-namespace basis by adding an additional namespace subscript, for example:<br>
/// SET ^%SYS("sql","sys","day of week","USER")=n, where n values are 1=Monday through 7=Sunday.<br>
/// Cach&eacute; also supports the ISO 8601 standard for determining the day of the week, week of the year, and other date settings. 
/// This standard is principally used in European countries. The ISO 8601 standard begins counting the days of the week with Monday. 
/// To activate ISO 8601, SET ^%SYS("sql","sys","week ISO8601")=1; to deactivate, set it to 0. 
/// If week ISO8601 is activated and Cach&eacute; day of week is undefined or set to the default (7=Sunday), the ISO 8601 standard overrides the Cach&eacute; default. 
/// If Cach&eacute; day of week is set to any other value, it overrides week ISO8601 for DAYOFWEEK.
ClassMethod DAYOFWEEK(dateexp As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1, PublicList = SQLCODE ]
{
	new %msg,SQLCODE
	QUIT $s(dateexp="":"",dateexp=+dateexp||(dateexp?1.7N1","1.5N)||(dateexp?1.7N1","1.5N1".".N):$$DayOfWeek^%qarfunc(dateexp),1:$$DayOfWeek^%qarfunc($zdh($p(dateexp," "),3)))
}

/// DAYOFYEAR is a date/time function that returns an integer from 1 to 366 that corresponds to the day of the year in a given date expression.
/// <p>
/// $SYSTEM.SQL.DAYOFYEAR(<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>dateexp</i>
/// <dd>An expression that is a logical %Library.Date value or timestamp literal.<br>
/// </dl>
ClassMethod DAYOFYEAR(dateexp As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1 ]
{
	QUIT $s(dateexp="":"",dateexp=+dateexp:+$zd(dateexp,14,,,,,-672045),1:+$zd($zdh(dateexp,3,,,,,-672045),14,,,,,-672045))
}

/// FLOOR is a numeric function that returns the largest integer less than or equal to a given numeric expression
/// <p>
/// $SYSTEM.SQL.FLOOR(<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>numeric-exp</i>
/// <dd>A number whose floor is to be calculated.<br>
/// </dl>
ClassMethod FLOOR(val As %Library.Numeric = "") As %Library.Integer [ ProcedureBlock = 1 ]
{
	QUIT $s('$isvalidnum(val):"",val[".":+$p(val,".")-(val<0),1:val)
}

/// HOUR is a date/time function that returns an integer from 0 to 23 that corresponds to the hour component in a given date-time expression.
/// <p>
/// $SYSTEM.SQL.HOUR(<i>timeexp</i>)<br>
/// <dl>
/// <dt><i>timeexp</i>
/// <dd>An expression that is a logical %Library.Time value or timestamp literal.<br>
/// </dl>
ClassMethod HOUR(timeexp As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1 ]
{
	QUIT $s(timeexp="":"",timeexp=+timeexp:+$p($zt(timeexp,1),$zu(122,9)),1:+$p($p(timeexp," ",2),$zu(122,9),1))
}

/// INSTR is a function that searches <i>string</i> for <i>substring</i> and returns an integer indicating the position of the character in <i>string</i> that is the first character of this <i>occurrence</i>.
/// <p>
/// $SYSTEM.SQL.INSTR(<i>string</i>,<i>substring</i>,<i>position</i>,<i>occurrence</i>)<br>
/// <dl>
/// <dt><i>string</i>
/// <dd>The string to search in.<br>
/// <dt><i>substring</i>
/// <dd>The string to search for in <i>string</i>.<br>
/// <dt><i>position</i>
/// <dd>A nonzero integer indicating the character of <i>string</i> where Cach&eacute; begins the search.  If <i>position</i> is negative, then Cach&eacute; counts backward from the end of <i>string</i> and then searches backward from the resulting <i>position</i>.<br>
/// <dt><i>occurrence</i>
/// <dd>An integer indicating which occurrence of <i>substring</i> Cach&eacute; should search for.  If <i>occurrence</i> is greater than 1, then Cach&eacute; searches for the second occurrence beginning with the second character in the first occurrence of <i>string</i>, and so forth.  An <i>occurrence</i> of less than 1 is treated the same as 1.<br>
/// </dl>
ClassMethod INSTR(string As %Library.String = "", substring As %Library.String = "", position As %Library.Integer = 1, occurrence As %Library.Integer = 1) As %Library.Integer [ ProcedureBlock = 1 ]
{
	QUIT $$instr^%qarfunc(string,substring,position,occurrence)
}

/// LASTDAY is a scalar date/time function that returns the date of the last day of the month for a given date expression.
/// <p>
/// $SYSTEM.SQL.LASTDAY(<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>dateexp</i>
/// <dd>A date integer (in $HOROLOG format) or a datetime string. A datetime string is of the format:  yyyy-mm-dd hh:mm:ss  The time portion of this string is optional.
/// </dl>
/// LASTDAY returns the date of the last day of the specified month as an integer in $HOROLOG format. Leap years differences are calculated.
/// <p>LASTDAY returns 0 when an invalid date is specified: a year earlier than 1841; the day or month as zero; the month greater than 12; or the day larger than the number of days in that month on that year.<br>
ClassMethod LASTDAY(dateexp As %Library.String = "") As %Library.Date [ ProcedureBlock = 1, PublicList = SQLCODE ]
{
	new %msg,SQLCODE
	QUIT $$lastday^%qarfunc(dateexp)
}

/// MINUTE is a date/time function that returns an integer from 0 to 59 that corresponds to the minute component in a given date-time expression.
/// <p>
/// $SYSTEM.SQL.MINUTE(<i>timeexp</i>)<br>
/// <dl>
/// <dt><i>timeexp</i>
/// <dd>An expression that is a logical %Library.Time value or timestamp literal.<br>
/// </dl>
ClassMethod MINUTE(timeexp As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1 ]
{
	QUIT $s(timeexp="":"",timeexp=+timeexp:+$p($zt(timeexp,1),$zu(122,9),2),1:+$p($p(timeexp," ",2),$zu(122,9),2))
}

/// MONTH is a date/time function that returns an integer from 1 to 12 that corresponds to the month in a given date expression.
/// <p>
/// $SYSTEM.SQL.MONTH(<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>dateexp</i>
/// <dd>An expression that is a logical %Library.Date value or timestamp literal.<br>
/// </dl>
ClassMethod MONTH(dateexp As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1 ]
{
	QUIT $s(dateexp="":"",dateexp=+dateexp:+$p($zd(dateexp,1),$zu(122,8)),1:+$p(dateexp,"-",2))
}

/// MONTHNAME is a date/time function that returns a character string containing the name of the month in a given date expression.
/// <p>
/// $SYSTEM.SQL.MONTHNAME(<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>dateexp</i>
/// <dd>An expression that is a logical %Library.Date value or timestamp literal.<br>
/// </dl>
ClassMethod MONTHNAME(dateexp As %Library.String = "") As %Library.String [ ProcedureBlock = 1 ]
{
	QUIT $s(dateexp="":"",dateexp=+dateexp:$p($zd(dateexp,9)," "),1:$p($zd($zdh($p(dateexp," "),3),9)," "))
}

/// QUARTER is a date/time function that returns an integer from 1 to 4 that corresponds to the quarter of the year in a given date expression.
/// <p>
/// $SYSTEM.SQL.QUARTER(<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>dateexp</i>
/// <dd>An expression that is a logical %Library.Date value or timestamp literal.<br>
/// </dl>
ClassMethod QUARTER(dateexp As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1 ]
{
	QUIT $s(dateexp="":"",dateexp=+dateexp:$s(+$zd(dateexp,1)<4:1,+$zd(dateexp,1)<7:2,+$zd(dateexp,1)<10:3,1:4),1:$s(+$p(dateexp,"-",2)<4:1,+$p(dateexp,"-",2)<7:2,+$p(dateexp,"-",2)<10:3,1:4))
}

/// SECOND is a date/time function that returns an integer from 0 to 59 that corresponds to the second component in a given date-time expression.
/// <p>
/// $SYSTEM.SQL.SECOND(<i>timeexp</i>)<br>
/// <dl>
/// <dt><i>timeexp</i>
/// <dd>An expression that is a logical %Library.Time value or timestamp literal.<br>
/// </dl>
ClassMethod SECOND(timeexp As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1 ]
{
	QUIT $s(timeexp="":"",timeexp=+timeexp:+$p($zt(timeexp,1),$zu(122,9),3),1:+$p($p(timeexp," ",2),$zu(122,9),3))
}

/// TOCHAR is a general SQL string function that converts a given date, timestamp, or number value to a string.
/// <p>
/// $SYSTEM.SQL.TOCHAR(<i>expr</i>,<i>format</i>)<br>
/// <dl>
/// <dt><i>expr</i>
/// <dd>A Logical %Date, logical %TimeStamp, logical %Time value, $Horolog, or number expression to be converted.<br>
/// <dt><i>format</i>
/// <dd>A date or number format specifying the format for the <i>expr</i> conversion. 
/// If <i>format</i> contains the characters "Y", "MM", "RR", "DD", "J", "HH", "MI", "SS", "MON", "MONTH", "AM", "PM", or "D", <i>expr</i> is assumed to be a %Date, %TimeStamp, or $Horolog value.<br>
/// If <i>format</i> contains he characters "HH", "MI", "SS", "AM", or "PM" and it does not contain a date format, <i>expr</i> is assumed to be a %Time value.<br>
/// Otherwise, it is a numeric value.<br>
/// </dl>
/// The first use of TOCHAR is to convert a date, time, or datetime expression to a string.<br>
/// The second use of TOCHAR is to convert a number to a string.<br>
/// See the TO_CHAR Documentation in the <i>Cach&eacute; SQL Reference</i> for complete details.<br>
ClassMethod TOCHAR(expr As %Library.String = "", format As %Library.String = "") As %Library.String [ ProcedureBlock = 1, PublicList = SQLCODE ]
{
	new %msg,SQLCODE
	QUIT $$tochar^%qarfunc(expr,format)
}

/// TODATE is a general SQL string function that converts a given string expression to a value of DATE data type.
/// <p>
/// $SYSTEM.SQL.TODATE(<i>expr</i>,<i>format</i>)<br>
/// <dl>
/// <dt><i>expr</i>
/// <dd>The expression to be converted. The expression can be a string date expression, the name of a column, or a value where the underlying format is of type CHAR or VARCHAR. It can also be an integer between 1 and 2980013.<br>
/// <dt><i>format</i>
/// <dd>A date format specifying the format for <i>expr</i>. If 'J' is specified, <i>expr</i> must be an integer. If format is omitted, 'DD MON YYYY' is the default value.<br>
/// </dl>
/// The use of TODATE is to specify the input format of a string value containing a date to be converted to a Logical %Date value. The format of <i>expr</i> is specified in the format parameter. <i>format</i> will be used as a key to translate <i>expr</i> into a valid %Date logical value.
/// <p>
/// See the TO_DATE Documentation in the <i>Cach&eacute; SQL Reference</i> for complete details.
ClassMethod TODATE(dateexp As %Library.String = "", format As %Library.String = "") As %Library.String [ ProcedureBlock = 1, PublicList = SQLCODE ]
{
	new %msg,SQLCODE
	QUIT $$todate^%qarfunc(dateexp,format)
}

/// TOTIMESTAMP is a general SQL string function that converts a given string expression to a value of TIMESTAMP data type.
/// <p>
/// $SYSTEM.SQL.TOTIMESTAMP(<i>stringexp</i>,<i>format</i>)<br>
/// <dl>
/// <dt><i>stringexp</i>
/// <dd>The expression to be converted. The expression can be a string datetime expression, the name of a column, or a value where the underlying format is of type CHAR or VARCHAR.<br>
/// <dt><i>format</i>
/// <dd>A datetime format code specifying the format for <i>stringexp</i>.  If format is omitted, 'DD MON YYYY HH:MM:SS' is the default value.<br>
/// </dl>
/// The use of TOTIMESTAMP is to specify the input format of a string value containing a datetime to be converted to a Logical %TimeStamp value. The format of <i>stringexp</i> is specified in the format parameter. <i>format</i> will be used as a key to translate <i>stringexp</i> into a valid %TimeStamp logical value.
/// If an error occurs during the execution of TOTIMESTAMP, the function will return a value of 0 and an error message will be defined in the %msg variable.
/// <p>
/// See the TO_TIMESTAMP Documentation in the <i>Cach&eacute; SQL Reference</i> for complete details.
ClassMethod TOTIMESTAMP(stringexp As %Library.String = "", format As %Library.String = "") As %Library.String [ ProcedureBlock = 1, PublicList = SQLCODE ]
{
	new %msg,SQLCODE
	try { s return=$$totimestamp^%qarfunc(stringexp,format) }
	catch { set:$g(%msg)="" %msg="Unexpected error occurred on call to $SYSTEM.SQL.TIMESTAMP("""_stringexp_""","""_format_"""):  "_$ze set return=0 }
	QUIT return
}

/// WEEK is a date/time function that returns an integer from 1 to 53 that corresponds to the week of the year in a given date expression.
/// <p>
/// $SYSTEM.SQL.WEEK(<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>dateexp</i>
/// <dd>An expression that is a logical %Library.Date value or timestamp literal.<br>
/// </dl>
ClassMethod WEEK(dateexp As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1, PublicList = SQLCODE ]
{
	new %msg,SQLCODE
	QUIT $s(dateexp="":"",dateexp?1.7n:$$WeekOfYear^%qarfunc(dateexp),dateexp?4n1"-"1.2n1"-"1.2n0.1" ".e:$$WeekOfYear^%qarfunc($zdh($p(dateexp," "),3)),1:$$WeekOfYear^%qarfunc($zdh(dateexp,-1)))
}

/// YEAR is a date/time function that returns an integer in the range 1840-9999 that indicates the year in a given date expression.
/// <p>
/// $SYSTEM.SQL.YEAR(<i>dateexp</i>)<br>
/// <dl>
/// <dt><i>dateexp</i>
/// <dd>An expression that is a logical %Library.Date value or timestamp literal.<br>
/// </dl>
ClassMethod YEAR(dateexp As %Library.String = "") As %Library.Integer [ ProcedureBlock = 1 ]
{
	QUIT $s(dateexp="":"",dateexp=+dateexp:+$zd(dateexp,3),1:+dateexp)
}

/// Displays all the current SQL settings to the current device.
ClassMethod CurrentSettings() As %Library.String
{
	Do CurrentSettings^%apiSQL
	Quit ""
}

/// Execute an SQL statement and return the result object.
/// <br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>SQL</i>
/// <dd>SQL statement to execute. This can be an array of SQL statement lines with the base node set to the number of lines or it can be a single string.</i>.
/// <dt><i>SelectMode</i>
/// <dd>The statement SELECTMODE - LOGICAL, ODBC or DISPLAY.<br>
/// Can also be specified as 0, 1, or 2.
/// <dt><i>Dialect</i>
/// <dd>The SQL dialect used for this SQL statement.  Valid values are CACHE, MSSQLSERVER, MSSQL, and SYBASE.
/// The default is CACHE. Support for MSSQLSERVER and SYBASE dialects is limited to a subset of the TSQL grammar supported by the Cache TSQL language mode.
/// <dt><i>ObjectSelectMode</i>
/// <dd>The statement %ObjectSelectMode value - 0 or 1. Refer to <class>%SQL.Statement</class> for more information on ObjectSelectMode.<br>
/// <dd>
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>set result=$SYSTEM.SQL.Execute("select top 5 name,dob,ssn from sample.person order by name")</li>
/// <li>set result=$SYSTEM.SQL.Execute("select top 5 name,dob,ssn,home_street,,home_city + ', ' + home_state + ' ' + home_zip from sample.person order by name",1,"MSSQL")</li>
/// <li>set sql=2,sql(1)="select top 5 name,dob,ssn from sample.person"<br>
/// set sql(2)=" order by name"<br>
/// set result=$SYSTEM.SQL.Execute(.sql)</li>
/// <li>set result=$SYSTEM.SQL.Execute("")</li>
/// <li>set result=$SYSTEM.SQL.Execute("insert into sample.person (name,dob,ssn) values ('Doe,John Q.','02/29/1952','111-22-3333')",2)</li>
/// </ul>
/// </dl>
ClassMethod Execute(ByRef SQL As %String(MAXLEN=""), SelectMode As %String = {$zu(115,5)}, Dialect As %String = "", ObjectSelectMode As %Integer = 0) As %SQL.StatementResult [ ProcedureBlock = 1 ]
{
	new %msg,%protocol
	try {
		if SelectMode '= +SelectMode { set SelectMode = $Case($$$ucase(SelectMode), "LOGICAL": 0, "ODBC": 1, "DISPLAY": 2, : 99) }
		if '$Find("|0|1|2",SelectMode) { throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$DTValueList,SelectMode,"0|1|2")) }
		set tStatement = ##class(%SQL.Statement).%New(SelectMode,,.Dialect)
		set tStatement.%ObjectSelectMode = ObjectSelectMode
		do tStatement.prepare(.SQL)
		set tResult = tStatement.%Execute()
	}
	catch tException {
		set tResult = ##class(%SQL.StatementResult).%New()
		set tResult.%SQLCODE = tException.AsSQLCODE()
		set tResult.%Message = tException.AsSQLMessage()
	}
	quit tResult
}

/// Execute an xDBC or %SQL.Statement Cached Query from the command line for debugging purposes.<br>
/// <br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>pCQName</i>
/// <dd>Name of the cached query class to execute.  This can be the entire class name, like %sqlcq.SAMPLES.cls5, or the short version of the name like cls5.<br>
/// <dt><i>pNumRowsToDisplay</i>
/// <dd>The number of rows for the select query to output.  The default is 10.<br>
/// <dt><i>pArgs...</i>
/// <dd>The input arguments to the query.  If the statement has input arguments and you don't pass them in here, the caller will be promoted for the input values.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <pre>
/// <li>SAMPLES>do $SYSTEM.SQL.ExecuteCachedQuery("%sqlcq.SAMPLES.cls8",2)
/// 
/// Device: 
/// Right margin: 225 => 
/// 
/// 
/// Executing xDBC Cached Query: %sqlcq.SAMPLES.cls8
/// Query text:
///    select Name , SSN , DOB from Sample . Person where Age > :%qpar(1)
/// 
/// Result Metadata:
///      Column: 1  Sample.Person.Name VARCHAR(50) NOT NULLABLE
///      Column: 2  Sample.Person.SSN VARCHAR(50) NOT NULLABLE isUnique isKeyColumn
///      Column: 3  Sample.Person.DOB DATE NULLABLE
/// 
/// Parameter Metadata:
///      Parameter: 1  %qpar(1) INTEGER NULLABLE
/// 
/// This statement has 1 parameter
/// Enter the value for parameter '1': 20
/// 
/// SQLCODE(Open)=0
/// 
/// Row 1:
///      --- Cursor Variables ---
///      %qscd(1,1) = 1
///      %qscd(1,3) = 0
///      %qscd(1,4) = <NULL>
///      %qscd(1,5) = 20
///      %qscd(1,6) = 12
///      %qscd(1,7) = $lb("","Nagel,Molly B.","894-47-5000",54195,$lb("7425 Main Place","Newton","MN",81696),$lb("5436 Oak Court","Reston","VT",55529),"",$lb("Red","Yellow"))
///      %qscd(1,8) = 54195
///      %qscd(1,9) = 25
///      --- Output Variables ---
///      %datax(1,1) = Nagel,Molly B.
///      %datax(1,2) = 894-47-5000
///      %datax(1,3) = 1989-05-19
/// 
/// Row 2:
///      --- Cursor Variables ---
///      %qscd(1,1) = 2
///      %qscd(1,3) = 0
///      %qscd(1,4) = <NULL>
///      %qscd(1,5) = 20
///      %qscd(1,6) = 16
///      %qscd(1,7) = $lb("","Ubertini,Angelo Y.","428-10-1982",54168,$lb("7812 Main Street","Washington","AZ",18420),$lb("2848 Second Blvd","Miami","TX",97018),"","")
///      %qscd(1,8) = 54168
///      %qscd(1,9) = 25
///      --- Output Variables ---
///      %datax(1,1) = Ubertini,Angelo Y.
///      %datax(1,2) = 428-10-1982
///      %datax(1,3) = 1989-04-22
/// 
/// 32 rows retrieved (2 displayed) in 2.649951 seconds
/// SQLCODE(LastFetch)=100
/// SQLCODE(Close)=0</li>
/// 
/// </pre>
/// <pre>
/// <li>SAMPLES>do $SYSTEM.SQL.ExecuteCachedQuery(".cls7")
/// 
/// Device: 
/// Right margin: 225 => 
/// 
/// 
/// Executing %SQL.Statement Cached Query: %sqlcq.SAMPLES.cls7
/// Query text:
///     DELETE FROM sample . person WHERE age IN ( ? , ? , ? )
/// 
/// Parameter Metadata:
///      Parameter: 1  %qpar(1) INTEGER NOT NULLABLE
///      Parameter: 2  %qpar(2) INTEGER NOT NULLABLE
///      Parameter: 3  %qpar(3) INTEGER NOT NULLABLE
/// 
/// This statement has 3 parameters
/// Enter the value for parameter '1': 33
/// Enter the value for parameter '2': 44
/// Enter the value for parameter '3': 55
/// 
///  SQLCODE(%Execute)=0
/// 
/// 
/// 1 rows affected by INSERT/UPDATE/DELETE or other statement.  Execution time: 4.201253 seconds</li>
/// </pre>
/// </ul>
/// </dl>
/// <p><b>Notes</b>:
/// <ul>
/// <li> - Only cached queries created through ODBC, JDBC, or %SQL.Statement are supported</li>
/// <li> - The cached query must have been created with a client from version 5.2 or newer</li>
/// <li> - SQL Privilege checking is NOT performed for $SYSTEM.SQL.ExecuteCachedQuery</li>
/// <li> - As this is intended as a developer debugging tool, there is no locking of the cached query to prevent a Purge of the cached query during $SYSTEM.SQL.ExecuteCachedQuery.</li>
/// </ul>
/// </dl>
ClassMethod ExecuteCachedQuery(pCQName As %String = "", pNumRowsToDisplay As %Integer = 10, pArgs... As %String) [ ProcedureBlock = 1, PublicList = (IO, IOBS, IOF, IOM, IOPAR, IOSL, IOST, IOT, MSYS, POP, RMSDF, SQLCODE), ServerOnly = 1 ]
{
	#dim tCQInfo,tMeta,tParmMeta,tColMeta As %List
	#dim %qacn,i,ii,tArgParamStart,tCnt,tCQType,tIsSelect,tNumArgs As %Integer
	#dim %datax,tHash,tCQRtn,tCurrentDevice,tOut As %String
	#dim tZH As %Numeric
	
	new %ANS,%col,%datax,%qacn,%qpar,%qref,%ROWCOUNT,%ROWID,SQLCODE
	new IO,IOBS,IOF,IOM,IOPAR,IOSL,IOST,IOT,MSYS,POP,RMSDF	// From ^%IS

	try {
		if pCQName="" {
			write !!,$$$Text("Enter then name of the class for an xDBC cached query","%SQL.Function")
			write !,$$$Text("Cached Query: ","%SQL.Function") read pCQName
		}
		QUIT:pCQName=""
		if pCQName?0.1"."1"cls"1.N {	// turn a cached query name of cls# into the full name, like %sqlcq.SAMPLES.cls5
			set pCQName=$$$CQPackage_$s($e(pCQName)=".":"",1:".")_pCQName
		}
		if '$d($$$CQ("QueryRoutine",pCQName),tCQInfo) {
			write !!,$$$FormatText($$$Text("Cached Query with class name %1 does not exist","%SQL.Function"),pCQName)
			QUIT
		}
		set tCQType=$lg(tCQInfo)
		if tCQType=10 {
			write !!,$$$Text("ExecuteCachedQuery is only supported for xDBC and %SQL.Statement type cached queries","%SQL.Function")
			QUIT
		}
		set tCurrentDevice=$i
		do OUT^%IS
		use:IO'=tCurrentDevice IO
		set %qacn=1		//  must be set
		set tHash=$li(tCQInfo,2)
		set tMeta=$$$CQ("Query",tCQType,tHash,pCQName,0)
		set tCQRtn=pCQName_".1"
		if tCQType=8 { write !!,$$$FormatText($$$Text("Executing %SQL.Statement Cached Query: %1","%SQL.Function"),pCQName) }
		elseif tCQType=9 { write !!,$$$FormatText($$$Text("Executing xDBC Cached Query: %1","%SQL.Function"),pCQName) }
		write !,$$$Text("Query text:","%SQL.Function")
		for i=1:1:$g($$$CQ("QueryText",pCQName,0)) write !?3,$g($$$CQ("QueryText",pCQName,i))
		set tIsSelect=($$$UPPER($e($zstrip($g($$$CQ("QueryText",pCQName,1)),"<W"),1,6))="SELECT")
		if tCQType=8 {	// %SQL.Statement
			if tIsSelect {
				set tNumArgs=$lg($$$CQ("Query",tCQType,tHash,pCQName,"parameters"))
			} 
			else {
				set tNumArgs=$lg($$$CQ("Query",tCQType,tHash,pCQName,0))
			}
		}
		elseif tCQType=9 {	// xDBC
			if tIsSelect {
				set tNumArgs=$li(tMeta,2+($li(tMeta)*10)),tArgParamStart=3+($li(tMeta)*10)
			} 
			else { set tNumArgs=$li(tMeta,1),tArgParamStart=2 }
		}
		if $d(pArgs) {	// Caller passed in the Arguments
			for i=1:1:tNumArgs { set:$d(pArgs(i)) %qpar(i)=pArgs(i) }
		}
		if tIsSelect {
			write !!,$$$Text("Result Metadata:","%SQL.Function")
			for i=1:1:$lg(tMeta) {
				write !?5,$$$FormatText($$$Text("Column: %1","%SQL.Function"),i)
				set tColMeta=$li(tMeta,((i-1)*10)+2,((i-1)*10)+12)
				set tOut=$lg(tColMeta,8)_$e(".",$lg(tColMeta,8)'="")_$lg(tColMeta,7)_$e(".",$lg(tColMeta,7)'="")_$lg(tColMeta,1)_" "_$$GetODBCTypeString^%ourODBC($lg(tColMeta,2),$lg(tColMeta,3),$lg(tColMeta,3),$lg(tColMeta,4))_" "_$s($lg(tColMeta,5):"NULLABLE",1:"NOT NULLABLE")
				set:$a($lg(tColMeta,10),1) tOut=tOut_" isAutoIncrement"
				set:$a($lg(tColMeta,10),2) tOut=tOut_" isCaseSensitive"
				set:$a($lg(tColMeta,10),3) tOut=tOut_" isCurrency"
				set:$a($lg(tColMeta,10),4) tOut=tOut_" isReadOnly"
				set:$a($lg(tColMeta,10),5) tOut=tOut_" isRowVersion"
				set:$a($lg(tColMeta,10),6) tOut=tOut_" isUnique"
				set:$a($lg(tColMeta,10),7) tOut=tOut_" isAliased"
				set:$a($lg(tColMeta,10),8) tOut=tOut_" isExpression"
				set:$a($lg(tColMeta,10),9) tOut=tOut_" isHidden"
				set:$a($lg(tColMeta,10),10) tOut=tOut_" isIdentity"
				set:$a($lg(tColMeta,10),11) tOut=tOut_" isKeyColumn"
				set:$a($lg(tColMeta,10),12) tOut=tOut_" isRowid"
				write "  ",tOut
			}
		}
		write !!,$$$Text("Parameter Metadata:","%SQL.Function")
		set tCnt=0
		if tCQType=9 {	// xDBC
			for i=tArgParamStart:4:$ll(tMeta) {
				set tCnt=tCnt+1
				write !?5,$$$FormatText($$$Text("Parameter: %1","%SQL.Function"),tCnt)
				set tOut="%qpar("_tCnt_") "_$$GetODBCTypeString^%ourODBC($lg(tMeta,i),$lg(tMeta,i+1),$lg(tMeta,i+1),$lg(tMeta,3))_" "_$s($lg(tMeta,4):"NULLABLE",1:"NOT NULLABLE")
				write "  ",tOut
			}
			if tNumArgs,'$d(pArgs) { do GetParamValues() }
			if tIsSelect {
				set tZH=$zh
				do %C0o^@tCQRtn
				set tZH=($zh-tZH)
				write !!,"SQLCODE(Open)=",SQLCODE
				if 'SQLCODE { write ?25,$$$FormatText($$$Text("SQL Open time: %1 seconds","%SQL.Function"),tZH) }
				if SQLCODE {
					write !!,"SQLCODE=",SQLCODE
					write:SQLCODE<0 !,"%msg = ",$g(%msg)
				}
				goto:SQLCODE close
				set tCnt=0,tFetchTime=0
				for i=1:1 {
					set tZH=$zh
					do %C0f^@tCQRtn
					set tFetchTime=tFetchTime+($zh-tZH)
					quit:SQLCODE
					set tCnt=tCnt+1
					if tCnt'>pNumRowsToDisplay {
						write !!,$$$FormatText($$$Text("Row %1:","%SQL.Function"),i)
						write !?5,$$$Text("--- Cursor Variables ---","%SQL.Function")
						set ii=""
						for  {
							set ii=$o(%qscd(%qacn,ii)) quit:ii=""
							w !?5,"%qscd(1,"_ii_") = ",$s(%qscd(%qacn,ii)="":"<NULL>",%qscd(%qacn,ii)=$c(0):"<EMPTY STRING>",$listvalid(%qscd(%qacn,ii)):$$Quote^%qcr(%qscd(%qacn,ii)),1:%qscd(%qacn,ii))
						}
						write !?5,$$$Text("--- Output Variables ---","%SQL.Function")
						set ii=""
						if $d(%col) {
							for  {
								set ii=$o(%col(ii)) quit:ii=""
								w !?5,"%col("_ii_") = ",$s(%col(ii)="":"<NULL>",%col(ii)=$c(0):"<EMPTY STRING>",1:%col(ii))
							}
						}
						else {
							for  {
								set ii=$o(%datax(1,ii)) quit:ii=""
								w !?5,"%datax(1,"_ii_") = ",$s(%datax(1,ii)="":"<NULL>",%datax(1,ii)=$c(0):"<EMPTY STRING>",1:%datax(1,ii))
							}
						}
					}
				}
				write !!,$$$FormatText($$$Text("%1 rows retrieved (%2 displayed) in %3 seconds","%SQL.Function"),tCnt,$s(tCnt<pNumRowsToDisplay:tCnt,1:pNumRowsToDisplay),tFetchTime)
				write !,"SQLCODE(LastFetch)=",SQLCODE
				set tZH=$zh
				do %C0c^@tCQRtn
				set tZH=($zh-tZH)
				write !!,"SQLCODE(Close)=",SQLCODE
				if 'SQLCODE { write ?25,$$$FormatText($$$Text("SQL Close time: %1 seconds","%SQL.Function"),tZH) }
			}
			else {	// Non-SELECT
				set tZH=$zh
				do %0Ao^@tCQRtn w !!,"SQLCODE=",SQLCODE
				set tZH=($zh-tZH)
				if SQLCODE<0 { write !,"%msg = ",$g(%msg) }
				else { write !!,$$$FormatText($$$Text("%1 rows affected by INSERT/UPDATE/DELETE or other statement.  Execution time: %2 seconds","%SQL.Function"),%ROWCOUNT,tZH) }
			}
		}
		if tCQType=8 {	// %SQL.Statement
			if tIsSelect {
				set tParmMeta=$g($$$CQ("Query",tCQType,tHash,pCQName,"parameters"))
				for i=2:6:$ll(tParmMeta) {
					set tCnt=tCnt+1
					write !?5,$$$FormatText($$$Text("Parameter: %1","%SQL.Function"),tCnt)
					set tOut="%qpar("_tCnt_") "_$$GetODBCTypeString^%ourODBC($lg(tParmMeta,i),$lg(tParmMeta,i+1),$lg(tParmMeta,i+1),$lg(tParmMeta,3))_" "_$s($lg(tParmMeta,4):"NULLABLE",1:"NOT NULLABLE")
					write "  ",tOut
				}
				if tNumArgs,'$d(pArgs) { do GetParamValues() }
				set tZH=$zh
				set zz=##class(%SQL.Statement).%New()
				set xx=$CLASSMETHOD(pCQName,"%New",$CLASSMETHOD(pCQName,"%New"),,,.%qpar)
				set tZH=($zh-tZH)
				write !!,"SQLCODE(Open)=",xx.%SQLCODE
				if 'xx.%SQLCODE { write ?25,$$$FormatText($$$Text("SQL Open time: %1 seconds","%SQL.Function"),tZH) }
				QUIT:xx.%SQLCODE  ; Open failed?
				set tCnt=0,tFetchTime=0
				for  {
					set tZH=$zh
					quit:'xx.%Next()
					set tFetchTime=tFetchTime+($zh-tZH)
					quit:xx.%SQLCODE	// no [more] data, or error
					set tCnt=tCnt+1
					if tCnt'>pNumRowsToDisplay {
						write !!,$$$FormatText($$$Text("Row %1:","%SQL.Function"),tCnt)
						do DumpObjectToArray^%occRun(xx,.dd)
						write !?5,$$$Text("--- Cursor Variables ---","%SQL.Function")
	     					for dd=1:1:dd(1) {
	     						if (dd(1,dd)["(%CursorDatad(") write !?5,$lg(tMeta,((dd-1)*10)+2)," = ",$s($e(dd(1,dd),1,*-2)="":"<NULL>",$e(dd(1,dd),1,*-2)=$c(0):"<EMPTY STRING>",1:$e(dd(1,dd),1,*-2))
	     					}
						write !?5,$$$Text("--- Output Variables ---","%SQL.Function")
	     					for dd=1:1:dd(1) {
	     						if (dd(1,dd)["(%Data(") write !?5,$lg(tMeta,((dd-1)*10)+2)," = ",$s($e(dd(1,dd),1,*-2)="":"<NULL>",$e(dd(1,dd),1,*-2)=$c(0):"<EMPTY STRING>",$listvalid($e(dd(1,dd),1,*-2)):$$Quote^%qcr($e(dd(1,dd),1,*-2)),1:$e(dd(1,dd),1,*-2))
	     					}
					}
				}
				write !!,$$$FormatText($$$Text("%1 rows retrieved (%2 displayed) in %3 seconds","%SQL.Function"),tCnt,$s(tCnt<pNumRowsToDisplay:tCnt,1:pNumRowsToDisplay),tFetchTime)
				write !,"SQLCODE(LastFetch)=",xx.%SQLCODE
				if xx.%SQLCODE<0 { write !,"%msg = "_$g(%msg) }
				kill xx
			}
			else {	// Non-SELECT
				set tParmMeta=$g($$$CQ("Query",tCQType,tHash,pCQName,0))
				for i=2:6:$ll(tParmMeta) {
					set tCnt=tCnt+1
					write !?5,$$$FormatText($$$Text("Parameter: %1","%SQL.Function"),tCnt)
					set tOut="%qpar("_tCnt_") "_$$GetODBCTypeString^%ourODBC($lg(tParmMeta,i),$lg(tParmMeta,i+1),$lg(tParmMeta,i+1),$lg(tParmMeta,3))_" "_$s($lg(tParmMeta,4):"NULLABLE",1:"NOT NULLABLE")
					write "  ",tOut
				}
				if tNumArgs,'$d(pArgs) { do GetParamValues() }
				set tZH=$zh
				set zz=##class(%SQL.Statement).%New()
				set xx=$CLASSMETHOD(pCQName,"%Execute",$CLASSMETHOD(pCQName,"%New"),.%qpar)
				set tZH=$zh-tZH
				write !!," SQLCODE(%Execute)=",xx.%SQLCODE,!
				if xx.%SQLCODE<0 { write !," %msg = ",xx.%Message }
				else { write !!,$$$FormatText($$$Text("%1 rows affected by INSERT/UPDATE/DELETE or other statement.  Execution time: %2 seconds","%SQL.Function"),xx.%ROWCOUNT,tZH) }
				kill xx
			}
		}
close		use tCurrentDevice close IO
		QUIT
	}
	catch {
		write !!,$$$FormatText($$$Text("An unexpected error occurred in $SYSTEM.SQL.ExecuteCachedQuery: %1","%SQL.Function"),$ze)
		if $d(tCurrentDevice),tCurrentDevice'=$i {
			use tCurrentDevice close IO
			write !!,$$$FormatText($$$Text("An unexpected error occurred in $SYSTEM.SQL.ExecuteCachedQuery: %1","%SQL.Function"),$ze)
		}
		
	}
	QUIT
	
GetParamValues()
	if tNumArgs=1 { write !!,$$$Text("This statement has 1 parameter","%SQL.Function") }
	elseif tNumArgs>1 { write !!,$$$FormatText($$$Text("This statement has %1 parameters","%SQL.Function"),tNumArgs) }
	for i=1:1:tNumArgs {
		write !,$$$FormatText($$$Text("Enter the value for parameter '%1': ","%SQL.Function"),i)
		read %qpar(i)
	}
}

/// Export a Cach&eacute; SQL DDL/DML script file containing User definitions, Role definitions, and/or Privileges.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>Schema</i>
/// <dd>Name of the schema in the current namespace to export the privileges for. Use "*" to specify the export of SQL Privileges 
/// for all schemas in the current namespace. The default is "*". Note that when "*" is specified, '%' schemas (such as %Dictionary)
/// are not exported. To export privileges for tables in a schema that begins with '%' you must explicitly specify that schema
/// name in <i>Schema</i>.
/// <dt><i>Table</i>
/// <dd>Name of the table/view in the specified schema to export the privileges for. Use "*" to specify the export of SQL Privileges 
/// for all table/s views in the specified schema(s). The default is "*". Note that if you "*" for <i>Schema</i> the export will
/// behave as if you entered "*" for <i>Table</i> as well. For example there is no mechanism for exporting the Person table/view
/// in each schema in the namespace.
/// <dt><i>File</i>
/// <dd>Name of the file to export the SQL statement to.
/// <dt><i>FileOpenParam</i>
/// <dd>Parameters to use when opening the <i>File</i>. The default is "WNS".
/// <dt><i>Users</i>
/// <dd>1/0 flag. Specify 1 to export the User definition. The default is 1.
/// <dt><i>Roles</i>
/// <dd>1/0 flag. Specify 1 to export the Role definition, and the GRANT statements to
/// assign the Roles to the Users and Roles they have been granted to. The default is 1.
/// <dt><i>Privileges</i>
/// <dd>1/0 flag. Specify 1 to export the Table and View privileges for the tables and views specified in the 
/// <i>Schema</i>/<i>Table</i> specification. The default is 1.
/// <dt><i>SQLSystemPrivileges</i>
/// <dd>1/0 flag. Specify 1 to export the SQL System privileges defined in the current namespace for the users and roles. The default is 1.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.Export("Sample","*","C:\PT\Sample.sql","WNS",0,0,1,1)</li>
/// <li>Do $SYSTEM.SQL.DDLImport("*","*","C:\DDT\UsersAndRoles.sql","WNS",1,1,0,0)</li>
/// </ul>
/// <p>The method returns a Status Code.<br>
/// <br>
/// A file created via $SYSTEM.SQL.Export() can be imported using one of:
/// <ul>
/// <li> Do $SYSTEM.SQL.DDLImport("CACHE",...)
/// <li> Do $SYSTEM.SQL.Cache()
/// </ul>
/// <p>The Export() method will <b>not</b> export the following users and roles -
/// <dl>
/// <dt><b>Users:</b>
/// <dd>SuperUser, Admin, UnknownUser, %System, CSPSystem, _SYSTEM, _PUBLIC
/// <dt><b>Roles:</b>
/// <dd>%All, %Developer, %Manager, %Operator, %SQL, %LegacyTerminal, %LegacyCacheDirect, %LegacySQL
/// </dl>
ClassMethod Export(Schema As %Library.String, Table As %Library.String, File As %Library.String, FileOpenParam As %Library.String = "WNS", Users As %Library.Boolean = 1, Roles As %Library.Boolean = 1, Privileges As %Library.Boolean = 1, SQLSystemPrivileges As %Library.Boolean = 1) As %Library.Status
{
	New sc
	Set sc = $$Export^%qarDDLExport(Schema,Table,File,FileOpenParam,0,Privileges,Users,Roles,SQLSystemPrivileges)
	QUIT sc
}

/// Import all DDL/DML script file in a given directory.  All files with the extension .sql in the directory will be imported.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>DDLMode</i>
/// <dd>Vendor from which the script file originated. This parameter is required.
/// Supported values are:
/// <ul>
/// <li>Informix</li>
/// <li>MSSQL</li>
/// <li>MSSQLServer - same as MSSQL</li>
/// <li>Sybase</li>
/// </ul>
/// <dt><i>directory</i>
/// <dd>The full path name of the directory to import. This parameter is required.
/// <dt><i>logfile</i>
/// <dd>The full path name of the file to report errors in. This parameter is Optional.
/// Default is <b>DDLImportDir.log</b> in the directory loaded.
/// If this parameter value is 1, a separate log file will be generated for each file loaded.  
/// The name of the log file will be the same as the file imported, but with the extension .log instead of .sql.
/// <dt><i>eosDelimiter</i>
/// <dd>End of statement delimiter. Will default to an appropriate value based 
/// on the value of <i>%DDLMode</i>. This parameter is optional.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.DDLImportDir("Informix","C:\Work\db1\,"C:\Work\db1\import.log",";")</li>
/// <li>Do $SYSTEM.SQL.DDLImportDir("Informix","C:\Work\db1\,1,";")</li>
/// </ul>
ClassMethod DDLImportDir(DDLMode As %Library.String = "", directory As %Library.String = "", logfile As %Library.String = "", eosDelimiter As %Library.String = "")
{
	set tDialect = $ListFind($$$SQLDIALECTALLUPPER,$$$UPPER(DDLMode))
	if tDialect {
			// Normalize the case of DDLMode
		set tDialect = $List($$$SQLDIALECTALL,tDialect)
		if $g(eosDelimiter)="" s eosDelimiter=$Case(tDialect,$$$SQLDIALECTINFORMIX:";",$$$SQLDIALECTORACLE:";",$$$SQLDIALECTINTERBASE:";",$$$SQLDIALECTCACHE:"GO",$$$SQLDIALECTSYBASE:"GO",$$$SQLDIALECTMSSQL:"GO",:"")
		set directory = ##class(%Library.File).NormalizeDirectory(directory)
		if logfile = "" { set logfile = directory_"DDLImportDir.log" }
		If tDialect = $$$SQLDIALECTINFORMIX { do InformixLoadDir^%qarSQLImport(directory,logfile,eosDelimiter) }
		elseif (tDialect = $$$SQLDIALECTSYBASE) || (tDialect = $$$SQLDIALECTMSSQL) {
			// (pDialect, pDirectory, pExtensions, pRecurse, pLogOption, pLogFileName, pNoSupFileName, pEOSDelimiter, pMessageMode, pEchoMode, pErrorPause)
			do ##class(%SQL.Util.Import).ImportDirectory(tDialect,directory,,,$Select(logfile=1:2,1:1),$Select(logfile=1:"",1:logfile),,eosDelimiter)
		}
		else { write !,"DDLImportDir does not support dialect = '",DDLMode,"'",! }
	}
	else { write !,"Invalid dialect = '",DDLMode,"'",! }
	QUIT
}

/// Import a DDL/DML script file.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>DDLMode</i>
/// <dd>Vendor from which the script file originated. This parameter is required.
/// Supported values are:
/// <ul>
/// <li>CACHE</li>
/// <li>FDBMS</li>
/// <li>Informix</li>
/// <li>Interbase</li>
/// <li>MSSQLServer</li>
/// <li>MySQL</li>
/// <li>Oracle</li>
/// <li>Sybase</li>
/// </ul>
/// <dt><i>SQLUser</i>
/// <dd>Cach&eacute; SQL username to import the file as. This parameter is required.
/// <dt><i>infile</i>
/// <dd>The full path name of the script file to import. This parameter is required.
/// <dt><i>outfile</i>
/// <dd>The full path name of the file to report errors in. This parameter is Optional.
/// Default is the same as the <i>infile</i> with a <b>_Errors.log</b> extension.
/// <dt><i>nosup</i>
/// <dd>TRUE(1)/FALSE(0) flag. Determines if unsupported statements from the script 
/// file should be recorded in the <i>nosupfile</i>. This parameter is optional.
/// <dt><i>nosupfile</i>
/// <dd>If nosup is true, the name of the file to log the unsupported statements in. 
/// Default is the same as the <i>infile</i> with a <b>_Unsupported.log</b> extension.
/// This parameter is optional.
/// <dt><i>deos</i>
/// <dd>End of statement delimiter. Will default to an appropriate value based 
/// on the value of <i>%DDLMode</i>. This parameter is optional.
/// <dt><i>errpause</i>
/// <dd>Number of seconds to pause after an error occurs. The default is 5 seconds.
/// This parameter is optional.
/// <dt><i>runtimemode</i>
/// <dd>Which selectmode to run the imported statement in, ODBC, DISPLAY, or LOGICAL.
/// This only applies when <i>DDLMode</i>=CACHE.  
/// If any value other than ODBC or DISPLAY is specified, LOGICAL mode is used. 
/// This parameter is optional.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.DDLImport("Sybase","_SYSTEM","C:\PT\Patient.sql")</li>
/// <li>Do $SYSTEM.SQL.DDLImport("Oracle","DAVE","C:\DDT\all_tables.sql",all.log,0,"",";",2)</li>
/// </ul>
ClassMethod DDLImport(DDLMode As %Library.String, SQLUser As %Library.String, infile As %Library.String, outfile As %Library.String, nosup As %Library.Boolean = 0, nosupfile As %Library.String, deos As %Library.String, errpause As %SmallInt = 5, runtimemode As %String = "Logical") As %Library.String
{
	new savemode
	if $g(deos)="" s deos=$Case($$$UPPER(DDLMode),"INFORMIX":";","ORACLE":";","INTERBASE":";","CACHE":"GO","SYBASE":"GO","MSSQL":"GO","MYSQL":";",:"")
	set runtimemode=$Case($$$UPPER(runtimemode),"DISPLAY":2,"ODBC":"1",:0)
	set savemode=$zu(115,5,runtimemode)
	Do DDLImport^%apiSQL(DDLMode,SQLUser,$g(infile),$g(outfile),''$g(nosup),$g(nosupfile),deos,$g(errpause))
	do $zu(115,5,savemode)
	QUIT ""
}

/// Import all DDL/DML script files in a given directory.  All files with the extension .sql in the directory will be imported.
/// The caller can optionally specify a comma delimited list of file extensions to import. Subdirectories are also recursively processed
/// if the caller specifies the pRecurse argument as 1.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>pDialect</i>
/// <dd>Vendor from which the script file originated. This parameter is required.
/// Supported values are:
/// <ul>
/// <li>MSSQL</li>
/// <li>MSSQLServer - same as MSSQL</li>
/// <li>Sybase</li>
/// </ul>
/// <dt><i>pDirectory</i>
/// <dd>The full path name of the directory to import. This parameter is required.
/// <dt><i>pLogfile</i>
/// <dd>The full path name of the file to report errors in. This parameter is Optional.
/// Default is <b>SQLImportDir.log</b> in the directory loaded.
/// If this parameter value is 1, a separate log file will be generated for each file loaded.  
/// The name of the log file will be the same as the file imported, but with the extension .log instead of .sql.
/// <dt><i>pExtensions</i>
/// <dd>A comma delimited list of file extensions to import. This parameter is optional and defaults to "sql".
/// <dt><i>eosDelimiter</i>
/// <dd>End of statement delimiter. Will default to an appropriate value based 
/// on the value of <i>%DDLMode</i>. This parameter is optional.
/// <dt><i>pRecurse</i>
/// <dd>If pRecurse is 1 then subdirectories of <i>pDirectory</i> will be recursively imported. This parameter is optional and defaults to 0.
/// <dt><i>pMessageMode</i>
/// <dd>If true then all messages reported by executing imported statements will be displayed on the current device.
/// <dt><i>pEchoMode</i>
/// <dd>If true, all statement source is displayed on the current device.
/// <dt><i>pErrorPause</i>
/// <dd>The number of seconds to pause when an error is reported. The default is five seconds.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.ImportDir("Sybase","C:\Work\db1\,"C:\Work\db1\import.log",";")</li>
/// <li>Do $SYSTEM.SQL.ImportDir("Sybase","C:\Work\db1\,"C:\Work\db1\import.log","sql,tab,sp",";",1)</li>
/// <li>Do $SYSTEM.SQL.ImportDir("Sybase","C:\Work\db1\,1,";")</li>
/// </ul>
ClassMethod ImportDir(pDialect As %Library.String = "", pDirectory As %Library.String = "", pLogfile As %Library.String = "", pExtensions As %Library.String = "sql", eosDelimiter As %Library.String = "", pRecurse As %Integer = 0, pMessageMode As %Boolean = 1, pEchoMode As %Boolean = 1, pErrorPause As %Integer = 5)
{
	set tDialect = $ListFind($$$SQLDIALECTALLUPPER,$$$UPPER(pDialect))
	if tDialect {
			// Normalize the case of DDLMode
		set tDialect = $List($$$SQLDIALECTALL,tDialect)
		if $g(eosDelimiter) = "" {
			set eosDelimiter = $case(tDialect,$$$SQLDIALECTINFORMIX:";",$$$SQLDIALECTORACLE:";",$$$SQLDIALECTINTERBASE:";",$$$SQLDIALECTCACHE:"GO",$$$SQLDIALECTSYBASE:"GO",$$$SQLDIALECTMSSQL:"GO",:"")
		}
		set directory = ##class(%Library.File).NormalizeDirectory(pDirectory)
		if pLogfile = "" { set pLogfile = directory_"SQLImportDir.log" }
		if (tDialect = $$$SQLDIALECTSYBASE) || (tDialect = $$$SQLDIALECTMSSQL) {
			do ##class(%SQL.Util.Import).ImportDirectory(tDialect,pDirectory,pExtensions,pRecurse,$Select(pLogfile=1:2,1:1),$Select(pLogfile=1:"",1:pLogfile),,eosDelimiter,pMessageMode,pEchoMode,pErrorPause)
		}
		else { write !,"ImportDir does not support dialect = '",pDialect,"'",! }
	}
	else { write !,"Invalid dialect = '",pDialect,"'",! }
	QUIT
}

/// Return the default schema name for the current process in the current namespace
/// <br>
/// <p><b>Example</b>:
/// <pre>
/// Set CurrentSchema = $SYSTEM.SQL.DefaultSchema()
/// </pre>
ClassMethod DefaultSchema() As %Library.String [ CodeMode = expression, ProcedureBlock = 1 ]
{
$$$DefaultSchema
}

/// This entry point can be used to delete a table definition.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>tablename</i>
/// <dd>Name of the SQL table to delete.
/// The name may be qualified with a schema name:
/// <i>Medical.Patient</i>.
/// If the schema name is omitted, the default schema is used.
/// <dt><i>deldata</i>
/// <dd>TRUE(1)/FALSE(0) flag which determine if the table's data is to be deleted or not.
/// If <i>deldata</i>="" or <i>undefined</i>, use system flag to determine if data
/// should be deleted.
/// <dt><i>SQLCODE</i>
/// <dd>Passed by reference. Returns SQLCODE. Contains 0 (success) or number &lt; 0 (error).
/// <dt><i>%msg</i>
/// <dd>Passed by reference. If SQLCODE&lt;0, contains error message.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.DropTable("MedLab.Patient",1,.SQLCODE,.%msg)</li>
/// <li>Do $SYSTEM.SQL.DropTable("IscPerson",1,.SQLCODE,.%msg) ; Deletes SQLUser.IscPerson</li>
/// </ul>
ClassMethod DropTable(tablename As %Library.String, deldata As %Library.Boolean = 0, ByRef SQLCODE As %Library.Integer, ByRef %msg As %Library.String) As %Library.String
{
	Do DropTable^%apiSQL($g(tablename),$g(deldata),.SQLCODE,.%msg)
	QUIT ""
}

/// This entry point can be used to delete a view definition.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>viewname</i>
/// <dd>Name of the SQL view to delete.
/// The name may be qualified with a schema name:
/// <i>Medical.PatientView</i>
/// If the schema name is omitted, the default schema is used.
/// <dt><i>SQLCODE</i>
/// <dd>Passed by reference. Returns SQLCODE. Contains 0 (success) or number &lt; 0 (error)
/// <dt><i>%msg</i>
/// <dd>Passed by reference. If SQLCODE&lt;0, contains error message.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.DropView("MedLab.PatientView",.SQLCODE,.%msg)</li>
/// <li>Do $SYSTEM.SQL.DropView("IscPersonView",.SQLCODE,.%msg) ; Deletes SQLUser.IscPerson</li>
/// </ul>
ClassMethod DropView(viewname As %Library.String, ByRef SQLCODE As %Library.Integer, ByRef %msg As %Library.String) As %Library.String
{
	Do DropView^%apiSQL($g(viewname),.SQLCODE,.%msg)
	QUIT ""
}

/// Import a Cach&eacute; or Open M with SQL FDBMS DDL script file.
ClassMethod FDBMS() As %Library.String
{
	Do FDBMS^%apiSQL
	QUIT ""
}

/// Check if user has SQL privilege for a particular action.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>Username</i>
/// <dd>Name of the user to check.  Required.
/// <dt><i>Object</i>
/// <dd>ObjectType,ObjectName of the table, view, or procedure to check the privilege of. 
/// ObjectTypes are 1 (table), 3 (view), 9 (procedure).  For example, "1,Sample.Person" or "9,SQLUser.My_Procedure".  Required.
/// <dt><i>Action</i>
/// <dd>Comma delimited string of actions letters to check privileges for.  Actions are one or more of the 
/// letters "a,s,i,u,d,r,e" (in any order) which stands for ALTER,SELECT,INSERT,UPDATE,DELETE,REFERENCES,EXECUTE.  
/// Privilege "e" is only allowed for Procedures.  CheckPriv will only return 1 if the user has privileges on all Actions specified.  Required.
/// <dt><i>Namespace</i>
/// <dd>Namespace object resides in (optional) default is current namespace
/// <dt><i>Grant</i>
/// <dd>1/0 flag - check grant privileges (optional) default is 0
/// </dl>
/// <p><b>Returns</b>:
/// <li>1 - if the Username does have the privilege</li>
/// <li>0 - if the Username does not have the privilege</li>
/// <li>%Status - if CheckPriv call is reporting an error</li>
/// <p><b>Notes:</b>
/// <li>If Username is a user with the %All role, CheckPriv will return 1 even if the Object does not exist.
/// <li>If the user calling CheckPriv is not the same as Username, the calling user must hold the %Admin_Secure:"U" privilege.
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.CheckPriv($username,"1,HHR.ProductionValues","s,i,u,d","USER",1)</li>
/// <li>Do $SYSTEM.SQL.CheckPriv("Miranda","3,SQLUser.Person","s","PRODUCT",0)</li>
/// </ul>
ClassMethod CheckPriv(Username As %String, Object As %String, Action As %String, Namespace As %String = "", Grant As %Integer = 0) As %String
{
	if $$$LOWER(Username)'=$$$LOWER($username) {
			#; If not checking for yourself, make sure user has permission to check (%Admin Secure:"U")
		If '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) {
			QUIT $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
		}
	}
	set:$g(Namespace)="" Namespace=$namespace
	set Action=$$$LOWER(Action)
	set Namespace=$$$UPPER(Namespace)
	if $tr(Action,"asiudre,","")'="" QUIT $$$ERROR($$$SystemSQLInvalidArgumentValue,"$SYSTEM.SQL.CheckPriv","Action","a,s,i,u,d,r,e")
	if $case($e(Object),1:0,3:0,9:0,:1) QUIT $$$ERROR($$$SystemSQLInvalidArgumentValue2,"$SYSTEM.SQL.CheckPriv","Object","1,3,9")
	if $e(Object)=9,Action'="e" QUIT $$$ERROR($$$SystemSQLInvalidArgumentValue3,"$SYSTEM.SQL.CheckPriv","Action","e")
	if $e(Object)'=9,Action="e" QUIT $$$ERROR($$$SystemSQLInvalidArgumentValue4,"$SYSTEM.SQL.CheckPriv","Object")
	if '##class(%SYS.Namespace).Exists(Namespace) QUIT $$$ERROR($$$NamespaceDoesNotExist,Namespace)
	QUIT $$CheckPriv^%SYS.SQLSEC(Username,Object,Action,Namespace,Grant)
}

/// Import a Cach&eacute; SQL script file.
/// For Cach&eacute; SQL script files, the default end-of-statement marker is the string GO.  The end-of-statement marker must be on a line by itself after the statement.
ClassMethod Cache() As %Library.String
{
	Do Cache^%apiSQL
	QUIT ""
}

/// Function returns the current Compile Mode setting, either Deferred or Immediate.
ClassMethod GetCompileMode() As %Library.String [ CodeMode = expression ]
{
$$GetCompileMode^%apiSQL()
}

/// Function returns the current contents of the %ROWID variable. It can be called after INSERT to get %ROWID value of the row inserted.
/// This method can also be called as a Stored Procedure named %SYSTEM.SQL_GetROWID()
ClassMethod GetROWID() As %Library.String [ Language = cache, ProcedureBlock = 1, SqlProc ]
{
	QUIT $Get(%ROWID)
}

/// *** THIS FUNCTION IS NO LONGER SUPPORTED ***
/// GRANT ODBC/JDBC/SQL Manager access for user(s) to a namespace(s).
/// This access privilege is only in effect if <b>ODBC Namespace Security</b> is ON.
/// Prior to calling this function, <i>%msql</i> must be set to a valid Cach&eacute; SQL username.
/// See the <b>$SYSTEM.SQL.Login</b> function for information on logging into
/// SQL and setting the <i>%msql</i> variable.<br>
/// This function returns TRUE (1) if the grant was successful or FALSE (0)
/// if the grant failed. If FALSE, the caller should check the value of the
/// variable passed by reference to the SQLCODE parameter for the reason.<br>
/// <br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>userlist</i>
/// <dd>One or more SQL usernames, separated by commas (,).
/// This parameter is required.
/// <dt><i>namespacelist</i>
/// <dd>One or more Cach&eacute; namespaces, separated by commas (,).
/// This parameter is required.
/// <dt><i>grantoption</i>
/// <dd>TRUE(1)/FALSE(0) flag to determine if the namespace access
/// privilege should be granted with grant option.
/// This parameter is optional. The default is FALSE (0).
/// <dt><i>SQLCODE</i>
/// <dd>Passed by reference. The value for SQLCODE is set to 0 for success
/// or -### for failure.
/// This parameter is optional
/// </dl>
/// *** THIS FUNCTION IS NO LONGER SUPPORTED ***
ClassMethod GrantODBCNamespaceAccess(userlist As %Library.String, namespacelist As %Library.String, grantoption As %Library.Boolean = 0, ByRef SQLCODE As %Library.Integer) As %Library.Boolean [ CodeMode = expression, Internal ]
{
$$GrantODBCNamespaceAccess^%apiSQL(userlist,namespacelist,grantoption,.SQLCODE)
}

/// Import an Informix DDL/DML script file.<br>
/// The Informix DDL/DML Import Utility supports the following statements:<ul>
/// <li>CREATE TABLE ...</li>
/// <li>ALTER TABLE ...</li>
/// <li>CREATE INDEX ...</li>
/// <li>CREATE VIEW ...</li>
/// <li>SET OPTION ...</li>
/// <li>GRANT { ALTER | SELECT | INSERT | UPDATE | DELETE | REFERENCES | ALL PRIVILEGES } ...</li>
/// </ul>
/// Statements other than the ones above are not handled by the utility and must be added 
/// to your Cach&eacute; application manually (if applicable).
ClassMethod Informix() As %Library.String
{
	Do Informix^%apiSQL
	QUIT ""
}

/// Import an Interbase DDL/DML script file.<br>
/// The Interbase DDL/DML Import Utility supports the following statements:<ul>
/// <li>CREATE TABLE ...</li>
/// <li>ALTER TABLE ...</li>
/// <li>CREATE INDEX ...</li>
/// <li>CREATE UNIQUE INDEX ...</li>
/// <li>CREATE VIEW ...</li>
/// <li>CREATE ROLE ...</li>
/// </ul>
/// Statements other than the ones above are not handled by the utility and must be added 
/// to your Cach&eacute; application manually (if applicable).
ClassMethod InterBase() As %Library.String
{
	Do InterBase^%apiSQL
	QUIT ""
}

/// This entry point can be used to determine if a user exists.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>username</i>
/// <dd>Name of the user to check.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Write $SYSTEM.SQL.UserExists("Robert") // Writes a 1 if user Robert exists</li>
/// </ul>
/// This method can also be called as a Stored Procedure named %SYSTEM.SQL_UserExists(<i>username</i>)
ClassMethod UserExists(username As %Library.String = "") As %Library.Boolean [ SqlProc ]
{
	QUIT $$UsersSQLExists^%SYS.SQLSEC(username)
}

/// This entry point can be used to determine if a role exists.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>rolename</i>
/// <dd>Name of the role to check.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Write $SYSTEM.SQL.RoleExists("SalesManager") // Writes a 1 if role SalesManager exists</li>
/// </ul>
/// This method can also be called as a Stored Procedure named %SYSTEM.SQL_RoleExists(<i>rolename</i>)
ClassMethod RoleExists(rolename As %Library.String = "") As %Library.Boolean [ SqlProc ]
{
	QUIT $$RoleExists^%SYS.SQLSEC(rolename)
}

/// This entry point can be used to determine if a base table exists.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>tablename</i>
/// <dd>Name of the table to check.<br>
/// <i>tablename</i> can be qualified or unqualified.  If unqualified, the default schema is applied.
/// <dt><i>metadata</i>
/// <dd>Passed by reference, optional argument.<br>
/// If the table exists, returns the following information about the table:
/// $ListBuild(SchemaName,TableName,Classname that projected the table,System Flag)
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Write $SYSTEM.SQL.TableExists("Sample.Person") // Writes a 1 if table Sample.Person exists</li>
/// <li>Write $SYSTEM.SQL.TableExists("Sample.Person",.metadata) // Writes a 1 if table Sample.Person exists, returns metadata=$lb("Sample","Person","Sample.Person","0")</li>
/// </ul>
/// <p><b>Notes</b>:
/// <ul>
/// <li>If the user calling the function does not hold any privileges for the table, 0 will be returned.</li>
/// <li>If a class exists that would project this table to SQL during compilation, but the class has not been compiled, 0 will be returned.</li>
/// <li>If a class that projects the table is marked as hidden, 0 will be returned.</li>
/// <li>metadata will be set to "" if 0 is returned by the function.</li>
/// </ul>
/// This method can also be called as a Stored Procedure named %SYSTEM.SQL_TableExists(<i>tablename</i>)
ClassMethod TableExists(tablename As %Library.String = "", ByRef metadata As %String) As %Library.Boolean [ ProcedureBlock = 1, SqlProc ]
{
	set metadata=""					// start clean
	QUIT:tablename="" 0
	set tablename=$$IntQualifiedName^%apiSQL(tablename)
	QUIT:tablename="" 0  ; ???
	set tSchema=$$$SchemaFromIQN(tablename)
	QUIT:tSchema="" 0
	set tTable=$$$TableFromIQN(tablename)
	QUIT:tTable="" 0
	set tablename=$$$GetExactIQNFromIQN(tablename)
	QUIT:tablename="" 0  ; ???
	QUIT:'$$AnyPrivObj^%SYS.SQLSEC("1,"_tablename) 0	// Not privileged
	set tData=$$$GetRVIdxDataFromIQN(tablename)
	if tData="" QUIT 0				// Does not exist
	if $$$GetTableTypeFromIQN(tablename)'=1		// Not a table
	set tSchema=$$$SchemaFromIQN(tablename)
	set tTable=$$$TableFromIQN(tablename)
	QUIT:'$d(^oddSQL(tSchema,tTable),tData2) 0	// Not completely defined are completely compiled?
	QUIT:$lg(tData2,8)=1 0				// Hidden table
	set metadata=$lb(tSchema,tTable,$$$GetClassNameFromIQN(tablename),$lg(tData2,7))
	QUIT 1
}

/// This entry point can be used to determine if a view exists.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>viewname</i>
/// <dd>Name of the view to check.<br>
/// <i>viewname</i> can be qualified or unqualified.  If unqualified, the default schema is applied.
/// <dt><i>metadata</i>
/// <dd>Passed by reference, optional argument.<br>
/// If the view exists, returns the following information about the view:
/// $ListBuild(SchemaName,ViewName,Classname that projected the view,System Flag)
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Write $SYSTEM.SQL.ViewExists("SQLUser.STestView") // Writes a 1 if view SQLUser.STestView exists</li>
/// <li>Write $SYSTEM.SQL.ViewExists("STestView",.metadata) // Writes a 1 if view [DefaultSchema].STestView exists, returns metadata=$lb("SQLUser","STestView","User.STestView","0")</li>
/// </ul>
/// <p><b>Notes</b>:
/// <ul>
/// <li>If the user calling the function does not hold any privileges for the view, 0 will be returned.</li>
/// <li>If a class exists that would project this view to SQL during compilation, but the class has not been compiled, 0 will be returned.</li>
/// <li>If a class that projects the view is marked as hidden, 0 will be returned.</li>
/// <li>metadata will be set to "" if 0 is returned by the function.</li>
/// </ul>
/// This method can also be called as a Stored Procedure named %SYSTEM.SQL_ViewExists(<i>viewname</i>)
ClassMethod ViewExists(viewname As %Library.String = "", ByRef metadata As %String) As %Library.Boolean [ ProcedureBlock = 1, SqlProc ]
{
	set metadata=""					// start clean
	QUIT:viewname="" 0
	set viewname=$$IntQualifiedName^%apiSQL(viewname)
	QUIT:viewname="" 0  ; ???
	set tSchema=$$$SchemaFromIQN(viewname)
	QUIT:tSchema="" 0
	set tView=$$$TableFromIQN(viewname)
	QUIT:tView="" 0
	set viewname=$$$GetExactIQNFromIQN(viewname)
	QUIT:viewname="" 0  ; ???
	QUIT:'$$AnyPrivObj^%SYS.SQLSEC("3,"_viewname) 0	// Not privileged
	set tData=$$$GetRVIdxDataFromIQN(viewname)
	if tData="" QUIT 0				// Does not exist
	if $$$GetTableTypeFromIQN(viewname)'=3		// Not a view
	set tSchema=$$$SchemaFromIQN(viewname)
	set tView=$$$TableFromIQN(viewname)
	QUIT:'$d(^oddSQL(tSchema,tView),tData2) 0	// Not completely defined are completely compiled?
	QUIT:$lg(tData2,8)=1 0				// Hidden view
	set metadata=$lb(tSchema,tView,$$$GetClassNameFromIQN(viewname),$lg(tData2,7))
	QUIT 1
}

/// This entry point can be used to determine if a stored procedure exists.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>procname</i>
/// <dd>Name of the stored procedure to check.<br>
/// <i>procname</i> can be qualified or unqualified.  If unqualified, the default schema is applied.
/// <dt><i>metadata</i>
/// <dd>Passed by reference, optional argument.<br>
/// If the stored procedure exists, returns the following information about the procedure:
/// $ListBuild(SchemaName,ProcedureName,Classname that projected the stored procedure,procedure type)
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Write $SYSTEM.SQL.ProcedureExists("SQLUser.stpSalaryReport") // Writes a 1 if procedure SQLUser.stpSalaryReport exists</li>
/// <li>Write $SYSTEM.SQL.ProcedureExists("stpSalaryReport",.metadata) // Writes a 1 if procedure [DefaultSchema].stpSalaryReport exists, returns metadata=$lb("SQLUser","stpSalaryReport","User.stpSalaryReport","function")</li>
/// </ul>
/// <p><b>Notes</b>:
/// <ul>
/// <li>If the user calling the function does not hold any privileges for the procedure, 0 will be returned.</li>
/// <li>If a class exists that would project this procedure to SQL during compilation, but the class has not been compiled, 0 will be returned.</li>
/// <li>If a procedure is marked as hidden, 0 will be returned.</li>
/// <li>metadata will be set to "" if 0 is returned by the function.</li>
/// </ul>
/// This method can also be called as a Stored Procedure named %SYSTEM.SQL_ProcedureExists(<i>procname</i>)
ClassMethod ProcedureExists(procname As %Library.String = "", ByRef metadata As %String) As %Library.Boolean [ ProcedureBlock = 1, SqlProc ]
{
	set metadata=""					// start clean
	QUIT:procname="" 0
	set procname=$$IntQualifiedName^%apiSQL(procname)
	QUIT:procname="" 0  ; ???
	set tSchema=$$$UPPER($$$SchemaFromIQN(procname))
	QUIT:tSchema="" 0
	set tProc=$$$UPPER($$$TableFromIQN(procname))
	QUIT:tProc="" 0
	QUIT:'$d($$$PROC($$$pPROC,tSchema,tProc)) 0	// No such procure defined
	QUIT:$$$PROChidden($$$pPROC,tSchema,tProc) 0	// Hidden procedure
	QUIT:'$$AnyPrivObj^%SYS.SQLSEC("9,"_$$$PROCschema($$$pPROC,tSchema,tProc)_"."_$$$PROCname($$$pPROC,tSchema,tProc)) 0	// Not privileged
	set metadata=$lb($$$PROCschema($$$pPROC,tSchema,tProc),$$$PROCname($$$pPROC,tSchema,tProc),$$$PROCclass($$$pPROC,tSchema,tProc),$$$PROCtype($$$pPROC,tSchema,tProc))
	QUIT 1
}

/// This entry point can be used to determine if a string is an SQL Reserved word.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>word</i>
/// <dd>The word to check against the SQL Reserved Word list.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Write $SYSTEM.SQL.IsReservedWord("select") // Writes a 1</li>
/// <li>Write $SYSTEM.SQL.IsReservedWord("football") // Writes a 0</li>
/// </ul>
/// This method can also be called as a Stored Procedure named %SYSTEM.SQL_IsReservedWord(<i>word</i>)
ClassMethod IsReservedWord(word As %Library.String) As %Library.Boolean [ SqlProc ]
{
	Quit:$g(word)=""||($l(word)>200) 0
	If $Piece($Get(^%qCacheSQL("reservewords",$$$UPPER(word))),$c(1),2)="Y" Quit 1
	Quit 0
}

/// This entry point can be used to determine if an SQL identifier is a valid regular SQL identifier.
/// An SQL regular identifier must begin with '%', '_', or a letter followed by 0 or more letters, 
/// numbers, '_', '@', '#', or '$' characters.
/// It must also not be an SQL Reserved word. 
/// Identifiers which do not qualify as Regular identifiers must be 
/// specified as Delimited identifiers in SQL statements.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>identifier</i>
/// <dd>Name of the identifier to check.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Write $SYSTEM.SQL.IsValidRegularIdentifier("select") // Writes a 0 (reserved word)</li>
/// <li>Write $SYSTEM.SQL.IsValidRegularIdentifier("football") // Writes a 1</li>
/// <li>Write $SYSTEM.SQL.IsValidRegularIdentifier("%Correct") // Writes a 1</li>
/// <li>Write $SYSTEM.SQL.IsValidRegularIdentifier("%Correct_$Amount") // Writes a 1</li>
/// </ul>
/// This method can also be called as a Stored Procedure named %SYSTEM.SQL_IsValidRegularIdentifier(<i>identifier</i>)
ClassMethod IsValidRegularIdentifier(identifier As %Library.String) As %Library.Boolean [ SqlProc ]
{
	Quit:$g(identifier)=""||($l(identifier)>200) 0
	If ($zname($e(identifier))||($e(identifier)="_")),$zname($tr("%"_$e(identifier,2,*),"_@#$")),'$$$SQLReservedWordForParsing($zcvt(identifier,"U")) QUIT 1
	Quit 0
}

/// THIS FUNCTION IS NO LONGER SUPPORTED
/// FEATURE HAS BEEN REMOVED! $SYSTEM.SQL.Logon() is no longer supported!
ClassMethod Login(ByRef username As %Library.String, password As %Library.String) As %Library.Status [ CodeMode = expression, Internal ]
{
$$SQLLogin^%apiSQL(.username,password)
}

/// Import an MS SQL Server DDL/DML script file.<br>
/// The MS SQL Server DDL/DML Import Utility supports the following statements:<ul>
/// <li>CREATE [GLOBAL TEMPORARY] TABLE ...</li>
/// <li>CREATE VIEW ...</li>
/// <li>ALTER TABLE ...</li>
/// <li>CREATE INDEX ...</li>
/// <li>CREATE CLUSTERED INDEX ...</li>
/// <li>CREATE UNIQUE INDEX ...</li>
/// <li>INSERT ...</li>
/// <li>UPDATE ...</li>
/// <li>DELETE ...</li>
/// <li>SET OPTION ...</li>
/// </ul>
/// Statements other than the ones above are not handled by the utility and must be added 
/// to your Cach&eacute; application manually (if applicable).
ClassMethod MSSQLServer() As %Library.String
{
	Do MSSQLServer^%apiSQL
	QUIT ""
}

/// Import an Oracle DDL/DML script file.<br>
/// The Oracle DDL/DML Import Utility supports the following statements:<ul>
/// <li>CREATE TABLE ...</li>
/// <li>CREATE VIEW ...</li>
/// <li>ALTER TABLE ...</li>
/// <li>CREATE INDEX ...</li>
/// <li>CREATE UNIQUE INDEX ...</li>
/// <li>DROP TABLE ...</li>
/// <li>DROP VIEW ...</li>
/// <li>DROP INDEX ...</li>
/// <li>INSERT ...</li>
/// <li>UPDATE ...</li>
/// <li>DELETE ...</li>
/// <li>SET OPTION ...</li>
/// <li>CREATE USER ...</li>
/// <li>CREATE ROLE ...</li>
/// <li>GRANT { SELECT | INSERT | UPDATE | DELETE | REFERENCES | ALL PRIVILEGES } ...</li>
/// </ul>
/// Statements other than the ones above are not handled by the utility and must be added 
/// to your Cach&eacute; application manually (if applicable).
ClassMethod Oracle() As %Library.String
{
	Do Oracle^%apiSQL
	QUIT ""
}

/// Import a TSQL script file.<br>
/// TSQL source files can contain any TSQL syntax supported by Cach&eacute; TSQL.<br>
/// This API will put the caller to the SQL Shell in the default TSQL dialect as defined in the TSQL Compatibility Settings.<br>
/// The caller can then use the <b>run [<i>filename</i>]</b> command from the shell to import the script file.<br>
ClassMethod TSQL() As %Library.String [ ProcedureBlock = 1 ]
{
	set tDialect=$Get(^%SYS("tsql","DIALECT"),"Sybase")
	Do ##class(%SQL.Shell).%Go(tDialect)
	QUIT ""
}

/// Purges Cached Queries.
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>days</i>
/// <dd>Number of days.  Purge cached queries not prepared in more than <i>days</i> days.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.Purge(0)   // Purge all Cached Queries</li>
/// <li>Do $SYSTEM.SQL.Purge()    // Purge all Cached Queries</li>
/// <li>Do $SYSTEM.SQL.Purge(30)  // Purge all Cached Queries that have not be used (prepared) in the last 30 days</li>
/// </ul>
ClassMethod Purge(days As %Library.Integer = 0) As %Library.String
{
	d Purge^%SYS.SQLSRV(days)
	QUIT ""
}

/// Purges Cached Queries in all namespaces on this system
/// <br><br>
/// <p><b>Example</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.PurgeAllNamespaces() // Purge all Cached Queries on this system</li>
/// </ul>
ClassMethod PurgeAllNamespaces() As %Library.String
{
	d PurgeAllNamespaces^%SYS.SQLSRV()
	QUIT ""
}

/// Purges Cached Queries given the name(s) of the Cached Query Classes.<br>
/// This entry point is deprecated.  $SYSTEM.SQL.PurgeCQClass(classname) should be used instead.
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>routine</i>
/// <dd>The name of the cached query class to purge, or a comma delimited list of cached query class names to purge.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.PurgeForRoutine("%sqlcq.USER.cls13") ; Purge this Cached Query</li>
/// <li>Do $SYSTEM.SQL.PurgeForRoutine("%sqlcq.USER.cls13,%sqlcq.USER.cls16,%sqlcq.USER.cls124") ; Purge these 3 Cached Queries</li>
/// </ul>
ClassMethod PurgeForRoutine(routine As %Library.String) As %Library.String
{
	Do PurgeForRoutine^%apiSQL($g(routine))
	QUIT ""
}

/// Purges Cached Queries given the name(s) of the Cached Query Classes.
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>Classlist</i>
/// <dd>The name of the cached query class to purge, or a comma delimited list of cached query class names to purge.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.PurgeCQClass("%sqlcq.USER.cls13") ; Purge this Cached Query</li>
/// <li>Do $SYSTEM.SQL.PurgeCQClass("%sqlcq.USER.cls13,%sqlcq.USER.cls16,%sqlcq.USER.cls124") ; Purge these 3 Cached Queries</li>
/// </ul>
ClassMethod PurgeCQClass(Classlist As %Library.String) As %Library.String
{
	Do PurgeForRoutine^%apiSQL($g(Classlist))
	QUIT ""
}

/// Purges all Cached Queries which use table <i>table</i>.
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>table</i>
/// <dd>The qualified name of the table to purge the Cached Queries for.  If the schema is not specified, the default schema will be used.
/// 
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.PurgeForTable("MedLab.Patient")</li>
/// <li>Do $SYSTEM.SQL.PurgeForTable("IscPerson") ; Purges Cached Queries for SQLUser.IscPerson</li>
/// </ul>
ClassMethod PurgeForTable(table As %Library.String) As %Library.String
{
	Do PurgeForTable^%apiSQL($g(table))
	QUIT ""
}

/// Turn the results of a query into a table definition.
/// This utility takes a query and the name of a new table and
/// executes the query. The results of the query are turned
/// into a new table of name 'table'.<br>
/// <br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>query</i>
/// <dd>The query text to execute.
/// query can be of the format:
/// <pre>
/// query="sql text"
/// OR
/// query = # of lines
/// query(1) = sql line 1
/// query(n) = sql line n
/// </pre>
/// <dt><i>table</i>
/// <dd>Name of the new SQL table to generate.
/// The name may be qualified with a schema name:
/// <i>Medical.Patient</i>
/// If the schema name is omitted, the default schema is used.
/// <dt><i>display</i>
/// <dd>TRUE(1)/FALSE(0) flag. Displays progress messages to the current device if
/// TRUE. The default is FALSE (0).
/// <dt><i>error</i>
/// <dd>Array of error messages returned if there is a
/// problem. The format is:
/// <pre>error = # of error lines
/// error(1) = error line 1
/// error(n) = error line n
/// </pre>
/// </dl>
/// <p><b>Examples</b>:
/// <p>
/// <pre>
/// Do $SYSTEM.SQL.QueryToTable("SELECT * FROM MedLab.Patient WHERE Sex = 'Male'","MedLab.MalePatient",1,.errors)
/// Set query=3
/// Set query(1)="SELECT *"
/// Set query(2)=" FROM ""Med Lab"".Patient""
/// Set query(3)=" WHERE Sex = 'Male'"
/// Do $SYSTEM.SQL.QueryToTable(.query,"""Med Lab"".MalePatient",1,.errors)
/// Do $SYSTEM.SQL.QueryToTable("SELECT * FROM Patient WHERE Sex = 'Male'","MalePatient",1,.errors) ; Creates SQLUser.MalePatient
/// </pre>
ClassMethod QueryToTable(ByRef query As %Library.String, table As %Library.String, display As %Library.Boolean = 0, ByRef error As %Library.String) As %Library.String
{
	Do QueryToTable^%apiSQL(.query,$g(table),$g(display),.error)
	QUIT ""
}

/// *** THIS FUNCTION IS NO LONGER SUPPORTED ***
/// REVOKE ODBC/JDBC/SQL Manager access for user(s) to a namespace(s).
/// Prior to calling this function, <i>%msql</i> must be set to a valid Cach&eacute; SQL username.
/// See the <b>$SYSTEM.SQL.Login</b> function for information on logging into
/// SQL and setting the <i>%msql</i> variable.<br>
/// This function returns TRUE (1) if the revoke was successful or FALSE (0)
/// if the revoke failed. If FALSE, the caller should check the value of the
/// variable passed by reference to the SQLCODE parameter for the reason.<br>
/// <br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>userlist</i>
/// <dd>One or more SQL usernames, separated by commas (,).
/// This parameter is required.
/// <dt><i>namespacelist</i>
/// <dd>One or more Cach&eacute; namespaces, separated by commas (,).
/// This parameter is required.
/// <dt><i>grantoption</i>
/// <dd>TRUE(1)/FALSE(0) flag to determine if the namespace access is revoked,
/// or just the grant option. If TRUE (1), just the grant option is revoked.
/// If FALSE (0), the entire access privilege is revoked.
/// This parameter is optional. The default is FALSE (0).
/// <dt><i>SQLCODE</i>
/// <dd>Passed by reference. The value for SQLCODE is set to 0 for success
/// or -### for failure.
/// This parameter is optional
/// </dl>
/// *** THIS FUNCTION IS NO LONGER SUPPORTED ***
ClassMethod RevokeODBCNamespaceAccess(userlist As %Library.String, namespacelist As %Library.String, grantoption As %Library.Boolean = 0, ByRef SQLCODE As %Library.Integer) As %Library.Boolean [ CodeMode = expression, Internal ]
{
$$RevokeODBCNamespaceAccess^%apiSQL(userlist,namespacelist,grantoption,.SQLCODE)
}

/// This entry point can be used to return the description of an SQLCODE value.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>SQLCODE</i>
/// <dd>SQLCODE value.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Write $SYSTEM.SQL.SQLCODE(-105)</li>
/// <li>Write $SYSTEM.SQL.SQLCODE(100)</li>
/// </ul>
/// This method can also be called as a Stored Procedure named %SYSTEM.SQL_SQLCODE(<i>SQLCODE</i>)
ClassMethod SQLCODE(SQLCODE As %Library.Integer) As %Library.String [ SqlProc ]
{
	Quit $$sqlcode^%apiSQL($g(SQLCODE))
}

/// THIS FUNCTION IS NO LONGER SUPPORTED
/// Defines what routine prefix name will be used for Cached Query routines.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>prefix</i>
/// <dd>A string to be used as the routine prefix for Cached Queries.
/// For example: "CQ" - means all Cached Queries will begin with the
/// string "CQ". If prefix is not specified, the default "CacheSql" prefix will be used.
/// <dt><i>system</i>
/// <dd>TRUE(1)/FALSE(0) flag to set the Cached Query routine prefix for the
/// entire system, or just for the current namespace. If TRUE (1), the system
/// wide flag is changed. If FALSE (0), it pertains to this namespace only.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <p>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Set sc=$SYSTEM.SQL.SetCachedQueryPrefix("CQ") // System wide setting</li>
/// <li>Set sc=$SYSTEM.SQL.SetCachedQueryPrefix("abc",0) // For this namespace</li>
/// <li>Set sc=$SYSTEM.SQL.SetCachedQueryPrefix("",0,.oldprefix) // Restore default, for this namespace</li>
/// </ul>
/// <i><b>NOTE:</b> You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.</i>
/// THIS FUNCTION IS NO LONGER SUPPORTED
ClassMethod SetCachedQueryPrefix(prefix As %Library.String = "CacheSql", system As %Library.Boolean = 1, ByRef oldval As %Library.String) As %Library.Status
{
	QUIT $$SetCachedQueryPrefix^%apiSQL(prefix,system,.oldval)
}

/// Defines whether or not the source code for Cached Queries is retained.
/// The default is no source is saved. The setting is on a per-system basis.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) flag to set the flag to retain source code for all
/// Cached Queries. If TRUE (1), source is retained.
/// If FALSE (0), source is deleted after the Cached Query has compiled.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <p>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Set sc=$SYSTEM.SQL.SetCachedQuerySaveSource(1) // Retain source</li>
/// <li>Set sc=$SYSTEM.SQL.SetCachedQuerySaveSource(0,.oldval) // Do not retain source</li>
/// </ul>
/// <i><b>NOTES:</b>
/// <dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will take effect immediately for all processes in Cach&eacute after this function is called.
/// Any new cached queries created by any process will immediately begin saving (or not saving) cached query source.  
/// Any existing cached queries will only have source saved if the system was configured to save source at the time the statement was prepared.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetCachedQuerySaveSource(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetCachedQuerySaveSource^%apiSQL(flag,.oldval)
}

/// Defines the lock timeout length used for Cached Queries when a lock needs to be acquired on Cached Query metadata.
/// The default is 120 seconds.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>timeout</i>
/// <dd>Number of seconds the lock command should timeout after when attempting to lock cached query definitions.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <p>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Set sc=$SYSTEM.SQL.SetCachedQueryLockTimeout(60) // Sets cached query lock timeout to 60 seconds</li>
/// <li>Set sc=$SYSTEM.SQL.SetCachedQuerySaveSource(300,.oldval) // Sets lock timeout to 5 minutes, returns previous lock timeout setting in oldval.</li>
/// </ul>
/// <i><b>NOTES:</b>
/// <dd> - The setting is on a per system basis.</i>
ClassMethod SetCachedQueryLockTimeout(timeout As %Library.Integer = 120, ByRef oldval As %Library.Integer) As %Library.Status
{
	QUIT $$SetCachedQueryLockTimeout^%apiSQL(timeout,.oldval)
}

/// Set the namespace wide flag which turns on Deferred Compilation mode.
/// Changing this setting will only take effect for this process.
ClassMethod SetCompileModeDeferred() As %Library.String
{
	Do SetCompileModeDeferred^%apiSQL
	QUIT ""
}

/// Set the namespace wide flag which turns on Immediate Compilation mode.
/// Immediate Compile Mode is the default compilation mode. If there are
/// pending compilations when switching from Deferred/Install Compile Mode,
/// they will be compiled immediately.
/// Changing this setting will only take effect for this process.
ClassMethod SetCompileModeImmediate() As %Library.String
{
	Do SetCompileModeImmediate^%apiSQL
	QUIT ""
}

/// Set the namespace wide flag which turns on Install Compilation mode.
/// This mode should only be used for installation procedures where no data
/// exists for any of the tables being created. If data exists for the
/// tables definitions being manipulated through DDL statement, use
/// Deferred Compile Mode instead.
/// Changing this setting will only take effect for this process.
ClassMethod SetCompileModeInstall() As %Library.String
{
	Do SetCompileModeInstall^%apiSQL
	QUIT ""
}

/// Set the namespace wide flag which turns on Nocheck Compilation mode.
/// This mode is the same as immediate mode except that existing data is not
/// validated against new constraints. For example if you add a unique constraint
/// to a table that already has data, Nocheck mode will not validate that
/// the constraint is valid. This compile mode must be used with extreme caution.
/// You could end up with data integrity problems in your application.
/// Changing this setting will only take effect for this process.
ClassMethod SetCompileModeNocheck() As %Library.String
{
	Do SetCompileModeNocheck^%apiSQL
	QUIT ""
}

/// Sets the flag which determines if a DDL DROP TABLE statement deletes the table's data.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>1 or 0. If TRUE, set the system wide flag to DELETE the table's data when the table is dropped. Otherwise, the data is not deleted.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDDLDropTabDelData(flag As %Library.Boolean = 1, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetDDLDropTabDelData^%apiSQL(flag,.oldval)
}

/// Sets the flag which determines if a class created by a DDL CREATE TABLE statement is Final.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>1 or 0. If TRUE, set the system wide flag to define a class created by CREATE TABLE as Final. Otherwise, do not define the class as Final.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
/// <dd> - The default setting is TRUE, the class will be defined as Final.</i>
/// <dd> - Temporary tables are always defined as Final, regardless of this setting.</i>
ClassMethod SetDDLFinal(flag As %Library.Boolean = 1, ByRef oldval As %Library.Boolean) As %Library.Status
{
	#dim sc As %Library.Status
	set sc=$$$OK
	try {
		set oldval=$$$GetDDLFinal
		set sc=$$$SetDDLFinal(''$g(flag))
		quit:$$$ISERR(sc)
		set ^%SYS("sql","sys","ddl","class final")=''$g(flag)
	}
	catch {
		set sc=$$$ERROR($$$GeneralError,"Error encountered in $SYSTEM.SQL.SetDDLFinal: "_$ze)
	}
	QUIT sc
}

/// Sets the flag which determines if a class created by a DDL CREATE TABLE statement uses $Sequence for ID assignment.
/// The storage keyword IDFUNCTION can be defined as INCREMENT or SEQUENCE. This keyword value is used by the class compiler to determine 
/// which system function - $increment or $sequence - is to be used for assigning new ID values for a persistent class using default storage.
/// The default value for IDFUNCTION is INCREMENT, however the default behavior for classes defined through DDL is to define IDFUNCTION as SEQUENCE.
/// To configure the system to have classes created through DDL to define IDFUNCTION as INCREMENT, pass in 0 for the <i>flag</i> parameter.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>1 or 0. If TRUE, set the system wide flag to define a class created by CREATE TABLE uses $Sequence for ID assignment. Otherwise, do not define the class as Final.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
/// <dd> - The default setting is TRUE, the class will use $Sequence for ID assignment.</i>
ClassMethod SetDDLUseSequence(flag As %Library.Boolean = 1, ByRef oldval As %Library.Boolean) As %Library.Status
{
	#dim sc As %Library.Status
	set sc=$$$OK
	try {
		set oldval=$$$GetDDLUseSequence
		set sc=$$$SetDDLUseSequence(''$g(flag))
		quit:$$$ISERR(sc)
		set ^%SYS("sql","sys","ddl","use $sequence")=''$g(flag)
	}
	catch {
		set sc=$$$ERROR($$$GeneralError,"Error encountered in $SYSTEM.SQL.SetDDLUseSequence: "_$ze)
	}
	QUIT sc
}

/// Sets the flag which determines if a class created by a DDL CREATE TABLE statement defines a bitmap extent index for the class.
/// This setting only applies to classes created through DDL that do not also define an explicit IdKey index.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>1 or 0. If TRUE, set the system wide flag to define a bitmap extent index for classes created by CREATE TABLE. Otherwise, do not define the bitmap extent index for the class.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
/// <dd> - The default setting is TRUE, the class will define a bitmap extent index.</i>
ClassMethod SetDDLDefineBitmapExtent(flag As %Library.Boolean = 1, ByRef oldval As %Library.Boolean) As %Library.Status
{
	#dim sc As %Library.Status
	set sc=$$$OK
	try {
		set oldval=$$$GetDDLDefineBitmapExtent
		set sc=$$$SetDDLDefineBitmapExtent(''$g(flag))
		quit:$$$ISERR(sc)
		set ^%SYS("sql","sys","ddl","define bitmap extent")=''$g(flag)
	}
	catch {
		set sc=$$$ERROR($$$GeneralError,"Error encountered in $SYSTEM.SQL.SetDDLDefineBitmapExtent: "_$ze)
	}
	QUIT sc
}

/// Sets the DDLNo201 configuration setting to [dis]allow CREATE TABLE for existing table.
/// This flag determines if an SQLCODE -201 error is returned when the
/// attempt is made to CREATE through DDL a table which already exists.
/// The default is that an error is returned.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>1 or 0. If TRUE, set the system wide configuration setting for the current configuration to not return an error if an attempt is made 
/// to CREATE a table through DDL that already exists. 
/// The existing table will be dropped, and then the CREATE TABLE will occur. Otherwise, return SQLCODE=-201. The default is 0 (FALSE).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDDLNo201(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetDDLNo201^%apiSQL(flag,.oldval)
}

/// Sets the DDLNo30 configuration setting to [dis]allow DROP TABLE for a non-existing table.
/// This flag determines if an SQLCODE -30 error is returned when the
/// attempt is made to DROP through DDL a table which does not exists.
/// The default is that an error is returned.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>1 or 0. If TRUE, set the system wide configuration setting for the current configuration to not return an error if an attempt is made to 
/// DROP a non-existent table through DDL. Otherwise, return SQLCODE=-30. The default is 0 (FALSE).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDDLNo30(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetDDLNo30^%apiSQL(flag,.oldval)
}

/// Sets the DDLNo307 configuration setting to [dis]allow DDL ADD PRIMARY KEY when the table already has an existing PRIMARY KEY.
/// This flag determines if an SQLCODE -307 error is returned when an
/// attempt is made to add through DDL a primary key constraint to a table
/// which already has a primary key constraint defined.
/// The default is that an error is returned.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>1 or 0. If TRUE, set the system wide configuration setting for the current configuration to not return an error if an attempt is made add a primary key constraint to a table through DDL when
/// a primary key constraint already exists for the table. The existing primary key constraint will be dropped, and then new primary key constraint
/// added. Otherwise, return SQLCODE=-307. The default is 0 (FALSE).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDDLNo307(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetDDLNo307^%apiSQL(flag,.oldval)
}

/// Sets the DDLNo311 configuration setting to [dis]allow DDL ADD FOREIGN KEY when existing FOREIGN KEY of the same name already exists for the table.
/// This flag determines if an SQLCODE -311 error is returned when an attempt
/// is made to create, through DDL, a foreign key constraint when a foreign key
/// constraint with the same name already exists for the table. The default is that an error is returned.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>1 or 0. If TRUE, set the system wide configuration setting for the current configuration to not return an error if an attempt is made to 
/// CREATE a duplicate foreign key constraint through DDL. Otherwise, return SQLCODE=-311. The default is 0 (FALSE).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDDLNo311(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetDDLNo311^%apiSQL(flag,.oldval)
}

/// Sets the DDLNo315 configuration setting to [dis]allow DROP CONSTRAINT for non-existing constraint.
/// This configuration setting determines if an SQLCODE -315 error is returned when the attempt is made to DROP, through DDL, a non-existing constraint.
/// The default is that an error is returned.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>1 or 0. If TRUE, set the system wide configuration setting for the current configuration to not return an error if an attempt is made to DROP a non-existent constraint through DDL. 
/// Otherwise, return SQLCODE=-315. The default is 0 (FALSE).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDDLNo315(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetDDLNo315^%apiSQL(flag,.oldval)
}

/// Sets the DDLNo324 configuration setting to [dis]allow CREATE INDEX for existing index.
/// This configuration setting determines if an SQLCODE -324 error is returned when an attempt is made to CREATE, through DDL, an index on a table which
/// already has an index of the same name. The default is that an error is returned.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>1 or 0. If TRUE, set the system wide configuration setting for the current configuration to not return an error if an attempt is made to CREATE an index through DDL that already exists.
/// The existing index will be dropped, and then the CREATE INDEX will occur. Otherwise, return SQLCODE=-324. The default is 0 (FALSE).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDDLNo324(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetDDLNo324^%apiSQL(flag,.oldval)
}

/// Sets the DDLNo333 configuration setting to [dis]allow DROP INDEX for non-existing index.
/// This configuration setting determines if an SQLCODE -333 error is returned when an attempt is made to DROP, through DDL, a non-existing index.
/// The default is that an error is returned.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>1 or 0. If TRUE, set the system wide configuration setting for the current configuration to not return an error if an attempt is made to DROP a non-existent index through DDL. 
/// Otherwise, return SQLCODE=-333. The default is 0 (FALSE).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDDLNo333(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetDDLNo333^%apiSQL(flag,.oldval)
}

/// Set configuration setting for PRIMARY KEY in DDL also being the IDKey index.
/// This configuration setting determines if a primary key constraint, specified through DDL, also becomes
/// the IDKey index in the class definition.<br>
/// By default, the primary key does NOT also become the IDKey index.<br>
/// Having the primary key index also be an IDKey index generally gives better performance,
/// but it means the Primary key fields cannot be updated.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) If <i>flag</i> is TRUE (1), set the system wide configuration setting for the current configuration to 
/// NOT make Primary Key constraints become IDKey indices.
/// If <i>flag</i> is FALSE (0), the Primary Key index will also become the IDKey index. 
/// The default is TRUE (1).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDDLPKeyNotIDKey(flag As %Library.Boolean = 1, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetDDLPKeyNotIDKey^%apiSQL(flag,.oldval)
}

/// THIS FUNCTION IS NO LONGER SUPPORTED
/// Defines how many days a Cached Query remain defined past its last day of use.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>days</i>
/// <dd>Number of days a Cached Query should remained defined after its last
/// date of use before being deleted. If days does not evaluate to a number,
/// the DaysBeforePurge setting will be deleted.
/// <dt><i>system</i>
/// <dd>TRUE(1)/FALSE(0) flag to set/change the DaysBeforePurge setting for the
/// entire system, or just for the current namespace. If TRUE (1), the system
/// wide flag is changed. If FALSE (0), it pertains to this namespace only.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Set sc=$SYSTEM.SQL.SetDaysBeforePurge(14) // System wide setting</li>
/// <li>Set sc=$SYSTEM.SQL.SetDaysBeforePurge(21,0) // For this namespace</li>
/// <li>Set sc=$SYSTEM.SQL.SetDaysBeforePurge("",0,.oldval) // For this namespace</li>
/// </ul>
/// <br>
/// <b>Parameter:</b>
/// <p>
/// 
/// 
/// <i>timeout</i> gives the number of seconds to set the lock timeout to. The default is 10 seconds.
/// <p>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTE:</b> You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.</i>
/// THIS FUNCTION IS NO LONGER SUPPORTED
ClassMethod SetDaysBeforePurge(days As %Library.Integer, system As %Library.Boolean = 1, ByRef oldval As %Library.Integer) As %Library.Status
{
	QUIT $$SetDaysBeforePurge^%apiSQL($g(days),system,.oldval)
}

/// Set the configuration setting which determines if extrinsic functions are allowed to be used in SQL statements through ODBC, JDBC, and Dynamic SQL.
/// The default is use of extrinsic functions is not supported.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) If <i>flag</i> is FALSE(0) (the default), do not allow extrinsic functions in SQL statements through ODBC, JDBC, or Dynamic SQL.
/// If TRUE(1), do allow extrinsic functions in SQL statements through ODBC, JDBC, or Dynamic SQL
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetAllowExtrinsicFunctions(flag As %Library.Boolean = 1, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetAllowExtrinsicFunctions^%apiSQL(flag,.oldval)
}

/// Set the configuration setting which determines if double quote ("") in an SQL statement is used for delimited
/// (quoted) identifiers or string constants. The default is delimited identifiers are supported.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) If <i>flag</i> is TRUE (1), "..." is treated as an identifier.
/// If <i>flag</i> is FALSE (0), "..." is treated as a string literal. The default is TRUE (1).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDelimitedIdentifiers(flag As %Library.Boolean = 1, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetDelimitedIdentifiers^%apiSQL(flag,.oldval)
}

/// Defines whether or not SQL DISTINCT is optimized to use indexes.
/// The default is DISTINCT optimizations are ON.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) flag to define the setting to allow SQL optimizations of DISTINCT. If TRUE (1), DISTINCT optimization is turned on.
/// If FALSE (0), DISTINCT optimization is turned OFF.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <p>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Set sc=$SYSTEM.SQL.SetFastDistinct(1) // DISTINCT Optimization ON</li>
/// <li>Set sc=$SYSTEM.SQL.SetFastDistinct(0,.oldval) // DISTINCT Optimization OFF</li>
/// </ul>
/// <dd>If true (the default) many SQL queries involving DISTINCT (and GROUP BY) will run much more efficiently by making better use of indices 
/// (if available). This is an optimization added in Cach&eacute; 5.1.
/// The downside of this is that the values returned by such queries will be collated in the same way they are stored within the index (i.e., results 
/// may be in upper case). Some applications care about the case of values returned by such queries. If "Fast DISTINCT" is set to false (0), the 
/// SQL will revert to its pre-5.1 behavior with regards to DISTINCT behavior.
/// <p><i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> -  The setting is on a per system basis.</i>
ClassMethod SetFastDistinct(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetFastDistinct^%apiSQL(flag,.oldval)
}

/// Defines whether or not SQL SELECT statements perform a $SYSTEM.ECP.Sync() call in the OPEN code
/// The default is ECP Sync is OFF.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) flag to define the setting to Perform ECP Syncs for Select queries. If TRUE (1), ECP Sync is turned on.
/// If FALSE (0), ECP Sync is turned OFF.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <p>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Set sc=$SYSTEM.SQL.SetECPSync(1) // ECP Sync ON</li>
/// <li>Set sc=$SYSTEM.SQL.SetECPSync(0,.oldval) // ECP Sync OFF</li>
/// </ul>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will only take effect for this process and new processes starting in Cach&eacute after this function is called. 
/// Any existing Cach&eacute processes will still use the old setting.
/// <dd> -  The setting is on a per system basis.</i>
ClassMethod SetECPSync(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetECPSync^%apiSQL(flag,.oldval)
}

/// Set the configuration setting which determines if Foreign Key Referential Integrity checks are performed
/// in the SQL Filer. Turning off SQL Filer Referential Integrity checking will suppress any
/// SQLCODE -121, -122, -123, and -124 errors. The default value is TRUE (Validation checks are performed).<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) flag to determine if SQL Filer referential integrity checks are
/// performed. If <i>flag</i> is FALSE (0), the SQL Filer will skip referential integrity
/// checks. Checks will be performed if <i>flag</i> is TRUE (1). The default is TRUE (1).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b> 
/// <dl>
/// <dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will only take effect for this process and new processes starting in Cach&eacute after this function is called. 
/// Any existing Cach&eacute processes will still use the old setting.
/// <dd> - This is a system-wide setting.
/// </dl></i>
ClassMethod SetFilerRefIntegrity(flag As %Library.Boolean = 1, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetFilerRefIntegrity^%apiSQL(flag,.oldval)
}

/// Set the Lock timeout for Cach&eacute; locks acquired during execution of SQL statements.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>timeout</i>
/// <dd>Number of seconds to set the lock timeout to. The default is 10 seconds.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b> 
/// <dl>
/// <dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will only take effect for this process and new processes starting in Cach&eacute after this function is called. 
/// Any existing Cach&eacute processes will still use the old setting.
/// <dd> - This is a system-wide setting.
/// </dl></i>
ClassMethod SetLockTimeout(timeout As %Library.Integer = 10, ByRef oldval As %Library.Integer) As %Library.Status
{
	QUIT $$SetLockTimeout^%apiSQL(timeout,.oldval)
}

/// Return the current system Lock Timeout value as defined in the configuration settings.  Note, this may be different than the lock timeout for the current process.
ClassMethod GetLockTimeout() As %Integer [ CodeMode = expression ]
{
$$$GetLockTimeout
}

/// Returns the current system-wide setting of the BitmapFriendlyCheck flag.<br>
/// See SetBitmapFriendlyCheck() for more information about this setting.<br>
/// <br>
/// <b>Returns:</b>
/// <p>Boolean value:
/// <dd>1 means the class compiler will check to make sure the type of ID of the class is a positive integer if there is a bitmap index defined for the class and the class uses %CacheSQLStorage.
/// <dd>0 (the default), means the class compiler will not perform this check and no error will be returned if the class contains a bitmap index and does not have a positive integer ID type.
/// <p>
ClassMethod GetBitmapFriendlyCheck() As %Library.Boolean
{
	QUIT $$$SQLCheckBitmapFriendly
}

/// Sets the flag to determine if the compiler should check if the bitmap index is allowed in a %CacheSQLStorage class.<br>
/// This setting only applies to classes using %CacheSQLStorage.
/// If this setting is TRUE (1), during class compilation the compiler will check to make sure the ID of the table is an INTEGER type if there are any bitmap or bitmap extent indices defined.
/// An INTEGER type means the class must have either no IdKey index, or a single field IdKey index.  
/// If the class has a single field IdKey index, the type of the IdKey property must be of SqlCategory="INTEGER" or SqlCategory="NUMERIC" with a SCALE=0 and MINVAL=1 or higher.
/// If BitmapFriendlyCheck is set to 1, and the class compile finds a non bitmap friendly class, the class compilation will fail with an error.
/// If BitmapFriendlyCheck=0 and a %CacheSQLStorage class is defined with an ID that is not a positive integer, it is up to the developer of the class to make sure the index is data is properly stored and retrieved from the global.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>pFlag</i>
/// <dd>1 means the class compiler will check to make sure the type of ID of the class is a positive integer if there is a bitmap index defined for the class and the class uses %CacheSQLStorage.
/// <dd>0 (the default), means the class compiler will not perform this check and no error will be returned if the class contains a bitmap index and does not have a positive integer ID type.
/// <dt><i>pOldVal</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b> 
/// <dl>
/// <dd> - Changing this configuration setting will only take effect immediately for all processes. 
/// <dd> - This is a system-wide setting.
/// </dl></i>
ClassMethod SetBitmapFriendlyCheck(pFlag As %Library.Integer = 0, ByRef pOldVal As %Library.Integer) As %Library.Status
{
	QUIT $$SetBitmapFriendlyCheck^%apiSQL(pFlag,.pOldVal)
}

/// Defines whether or not all class queries project as SQL Stored Procedures regardless of the query's SqlProc value.
/// The default is class queries are not projected as stored procedures unless the query SqlProc setting is TRUE.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) flag to define the setting force all class queries to be projected as stored procedures.
/// If FALSE (0), only class queries with SqlProc = TRUE are projected as stored procedures.
/// If TRUE (1), all class queries are projected as stored procedures.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <p>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Set sc=$SYSTEM.SQL.SetQueryProcedures(1) // All class queries projected as procedures</li>
/// <li>Set sc=$SYSTEM.SQL.SetQueryProcedures(0,.oldval) // Only SqlProc=TRUE class queries projected as procedures</li>
/// </ul>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - The setting is on a per system basis.</i>
ClassMethod SetQueryProcedures(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetQueryProcedures^%apiSQL(flag,.oldval)
}

/// Set the TCP Keep Alive interval for Cach&eacute xDBC connections.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>seconds</i>
/// <dd>Number of seconds to set the TCP Keep Alive interval to.  The default is 300 seconds (5 minutes).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetTCPKeepAlive(seconds As %Library.Integer = 300, ByRef oldval As %Library.Integer) As %Library.Status
{
	QUIT $$SetTCPKeepAlive^%apiSQL(seconds,.oldval)
}

/// Sets the default schema used by SQL.<br>
/// This configuration setting provides the ability to define a default schema name other than SQLUser, the default. When an unqualified table name is 
/// encountered in an SQL statement (and there is no #import statement specified), the default schema will be used. You may specify 
/// _CURRENT_USER for the default schema name if you wish to use the SQL username the process logged in as the name of the default schema. 
/// If the process has not logged in to SQL, SQLUser will be used as the default schema name. You may also specify _CURRENT_USER/<default name>. 
/// In this case, if the process has not logged in to SQL, <default name> will be used as the default schema name. For example: 
/// _CURRENT_USER/HMO will use HMO as the default schema if the process has not logged in to SQL. This setting has nothing to do with the 
/// mappings between SQL schema names and the class package name, it only specifies the default schema.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>schema</i>
/// <dd>String containing the default SQL schema name. If <i>schema</i> is "" or not defined, the default schema will be set to SQLUser.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// <dt><i>Namespace</i>
/// <dd>Boolean 1/0 flag.  If TRUE, set the default schema for the current namespace only.  The default for <i>Namespace</i> is FALSE
/// </dl>
/// <b>Returns:</b>
/// <dl>
/// <dd>Status Code
/// </dl>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.</i> 
ClassMethod SetDefaultSchema(schema As %Library.String = "", ByRef oldval As %Library.String, Namespace As %Library.Boolean = 0) As %Library.Status
{
	QUIT $$SetDefaultSchema^%apiSQL(schema,.oldval,Namespace)
}

/// Sets the DDL Identifier Translation mappings configuration settings.<br>
/// This is for filtering/modifying valid SQL identifier characters when translating SQL identifiers into Objects identifiers.
/// When converting an SQL identifier to an Objects Identifier at DDL run time, the characters in the 'from' list will be converted
/// to the characters in the 'to' list. This is done through the Cach&eacute; $Translate function. For example:<br>
/// SQL Table name = "My Table!"<br>
/// from = '"! '<br>
/// to = ''<br>
/// Class name = $Translate("My Table!",from,to) = MyTable<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>from</i>
/// <dd>A string of characters to translate from
/// <dt><i>to</i>
/// <dd>A string of characters to translate to (by position in the string) Optional. Default is "".
/// <dt><i>oldfrom</i>
/// <dd>Passed By Reference. Contains the previous value of the 'from' setting
/// <dt><i>oldto</i>
/// <dd>Passed By Reference. Contains the previous value of the 'to' setting
/// </dl>
/// <b>Returns:</b>
/// <dl>
/// <dd>Status Code
/// </dl>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDDLIdentifierTranslations(from As %Library.String, to As %Library.String = "", ByRef oldfrom As %Library.String, ByRef oldto As %Library.String) As %Library.Status
{
	QUIT $$SetDDLIdentifierTranslations^%apiSQL(from,to,.oldfrom,.oldto)
}

/// <p>Set the IDENTITY_INSERT option for this Cach&eacute; process.</p>
/// <p>
/// IDENTITY_INSERT controls the ability of the user to specify a value for the IDENTITY property when saving a new object, a value for the IDENTITY column
/// or an explicit ROWID value in an SQL INSERT. If IDENTITY_INSERT is false and the user specifies an explicit IDENTITY or ROWID value when saving a new object (Cach&eacute; Objects)
/// or inserting a new ROW (SQL) then an error condition is reported.</p>
/// <p>Setting takes effect immediately and lasts for the duration of the process or until SetIdentityInsert is called again.</p>
/// <p>Valid values are:</p>
/// <p>
/// <table cols=2 cellpadding=5>
/// <tr><td>0</td><td>IDENTITY cannot be set</td></tr>
/// <tr><td>1</td><td>IDENTITY can be set</td></tr>
/// </table>
/// </p>
/// <p>
/// If a valid value is passed in then the IDENTITY_INSERT option for the current process will be set to that value and the previous IDENTITY_INSERT value is returned.
/// Otherwise the IDENTITY_INSERT setting is left unchanged and <var>pStatus</var> will contain a %Status
/// value describing the error and the current IDENTITY_INSERT value is returned.
/// </p>
ClassMethod SetIdentityInsert(value As %Integer = 1, ByRef pStatus As %Library.Status) As %Integer
{
	if '$Find("|0|1",value) { set pStatus = $$$ERROR($$$DTValueList,value,"0|1") quit $zu(115,11) }
	set pStatus = $$$OK
	quit $zu(115,11,value)
}

/// Return the current IDENTITY_INSERT option value.
/// Possible values are:
/// <p>
/// <table cols=2 cellpadding=5>
/// <tr><td>0</td><td>IDENTITY cannot be set</td></tr>
/// <tr><td>1</td><td>IDENTITY can be set</td></tr>
/// </table>
/// </p>
ClassMethod GetIdentityInsert() As %Integer [ CodeMode = expression ]
{
$zu(115,11)
}

/// Set the Lock Threshold for Cach&eacute; locks acquired during filing of rows within a single transaction.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>value</i>
/// <dd>Number of row locks to acquire before escalating to a table lock. The default is 1000.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <dl>
/// <dd>Status Code
/// </dl>
/// <i><b>NOTES:</b> 
/// <dl>
/// <dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will take effect for this process and all other current processes in Cach&eacute after this function is called. 
/// <dd> - This is a system-wide setting.
/// </dl></i>
ClassMethod SetLockThreshold(value As %Library.Integer = 1000, ByRef oldval As %Library.Integer) As %Library.Status
{
	QUIT $$SetLockThreshold^%apiSQL(value,.oldval)
}

/// Return the current Lock Threshold setting.
/// The value returned is an integer that is the number of row locks to acquire before escalating to a table lock.
/// This is a system wide setting that is in effect for all processes.
ClassMethod GetLockThreshold() As %Integer [ CodeMode = expression ]
{
$zu(156,50,1)
}

/// Set the default format for the SQL TO_DATE() function.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>value</i>
/// <dd>String value with the default format the TO_DATE function will return.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <dl>
/// <dd>Status Code
/// </dl>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately. 
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetToDateDefaultFormat(value As %Library.String = "", ByRef oldval As %Library.String) As %Library.Status
{
	QUIT $$SetToDateDefaultFormat^%apiSQL(value,.oldval)
}

/// Set the Default precision for the Time component of the value returned by the GETDATE(), CURRENT_TIME, and CURRENT_TIMESTAMP SQL Scalar functions.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>value</i>
/// <dd>Precision (number of decimal places for the millisecond portion of the time value). The default is 0, milliseconds are not returned in the values returned by the GETDATE(), CURRENT_TIME, and CURRENT_TIMESTAMP functions.
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <dl>
/// <dd>Status Code
/// </dl>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetDefaultTimePrecision(value As %Library.Integer = 0, ByRef oldval As %Library.Integer) As %Library.Status
{
	QUIT $$SetDefaultTimePrecision^%apiSQL(value,.oldval)
}

/// THIS FUNCTION IS NO LONGER SUPPORTED
/// Set the flag which determines if ODBC Namespace Security is enabled.
/// If ODBC Namespace Security is ON users will only be allowed to connect
/// to a namespace through ODBC, JDBC, SQL Manager, or <b>$SYSTEM.SQL.Login</b>,
/// if the user has been granted access to the namespace. If ODBC Namespace
/// Security is OFF (default), any user may access any namespace through ODBC.
/// Once a user has access to a namespace, they still need object privileges granted
/// to them to access tables and views (see <b>$SYSTEM.SQL.SetSQLSecurity</b>).<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) If <i>flag</i> is TRUE (1), ODBC namespace security is ON
/// If <i>flag</i> is FALSE (0), ODBC Namespace Security is OFF. The default is FALSE(0).
/// </dl>
/// <i><b>NOTE:</b> Changing this setting through this API only changes
/// the setting until Cach&eacute; is stopped. Once Cach&eacute; is restarted, the
/// settings from the Cach&eacute; Configuration Manager are restored. To
/// permanently change this setting, use Cach&eacute; Configuration Manager.</i>
/// THIS FUNCTION IS NO LONGER SUPPORTED
ClassMethod SetNamespaceSecurity(flag As %Library.Boolean = 0) As %Library.String [ Internal ]
{
	Do SetNamespaceSecurity^%apiSQL(flag)
	Quit ""
}

/// Set the configuration setting which determines if embedded SQL statements are retained as comments in the .INT
/// code version of the routine. The default is no SQL comments are retained.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) If <i>flag</i> is TRUE (1), SQL text will be retained as comments in the
/// .INT code. No comments will be created if <i>flag</i> is FALSE (0). The default is FALSE (0).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <dl>
/// <dd>Status Code
/// </dl>
/// <i><b>NOTES:</b><dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will affect all Cach&eacute processes immediately.
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetRetainSQL(flag As %Library.Boolean = 0, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetRetainSQL^%apiSQL(flag,.oldval)
}

/// Sets the AUTO_COMMIT mode for this Cach&eacute; process.  
/// Setting takes effect immediately and lasts for the duration of the process or until SetAutoCommit is called again.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>0 - No AutoCommit <br>
/// 1 - AutoCommit ON <br>
/// 2 - AutoCommit OFF <br>
/// </dl>
/// <b>Returns:</b>
/// <dl>
/// <dd>Old value (0, 1, or 2) of the AutoCommit setting.
/// </dl>
/// 
ClassMethod SetAutoCommit(flag As %Library.Integer = 0) As %Library.Integer [ ProcedureBlock = 1 ]
{
	Set oldValue=$zu(115,1)
	Do SetAutoCommit^%apiSQL(flag)
	Quit oldValue
}

/// Return the current process's Transaction Commit Mode value.
/// Possible values are:
/// <p>
/// <table cols=2 cellpadding=5>
/// <tr><td>0</td><td>NO AUTO TRANSACTION</td></tr>
/// <tr><td>1</td><td>AUTO COMMIT ON (Default)</td></tr>
/// <tr><td>2</td><td>AUTO COMMIT OFF</td></tr>
/// </table>
ClassMethod GetAutoCommit() As %Integer [ CodeMode = expression ]
{
$zu(115,1)
}

/// Return the CollectionProjection setting.
/// Possible values are:
/// <p>
/// <table cols=2 cellpadding=5>
/// <tr><td>0</td><td>Do not project collections as columns if also projected as child table (DEFAULT)</td></tr>
/// <tr><td>1</td><td>Project all collections as columns</td></tr>
/// </table>
ClassMethod GetCollectionProjection() As %Integer [ CodeMode = expression ]
{
$$$CollectionProjectionGet
}

/// Given a table name, return a list of columns by name with the column number, and a list of columns sorted by column number with the name.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>tableName</i>
/// <dd>Name of the table to return the columns for.  Name is expected to be in the format Schema.Tablename
///     If the name is unqualified, the default schema will be used.
/// <dt><i>byName</i>
/// <dd>Passed By Reference. Returns columns ordered by column name with SqlColumnNumber as data.  For example:  byName("Id")=1,byName("Name")=2
/// <dt><i>byNumber</i>
/// <dd>Passed By Reference. Returns columns ordered by SqlColumnNumber with column name as data.  For example:  byName(1)="Id",byName(2)="Name"
/// <dt><i>skipHiddenFields</i>
/// <dd>Passed By Value. Default is 0.  If TRUE, do not include any SQL hidden columns in the <i>byName</i> and <i>byNumber</i> output arrays.  
/// SQL fields are defined as hidden if they are projected by a property defined as private, a RowID field defined as SqlRowIDPrivate, a RowID field for a linked table, 
/// a serial field that is not a collection and the storage structure is known, the %%CLASSNAME field, or a list or array collection property projected as a child table.
/// </dl>
/// <b>Returns:</b>  A %Boolean value.  1 if the columns were returned successfully, 0 if there was no such table.
ClassMethod GetColumns(tablename As %String = "", ByRef byName As %String, ByRef byNumber As %String, skipHiddenFields As %Boolean = 0) As %Boolean [ ProcedureBlock = 1 ]
{
		#; This API is not exposed to xDBC, so we won't check privileges here.  It can only be called from the terminal line or someone's ObjectScript code
	QUIT:tablename="" 0
	set tName=$$IntQualifiedName^%apiSQL(tablename)
	set tExtentname=$$$GetExtentNameFromIQN(tName)
	QUIT:tExtentname="" 0
	kill byName,byNumber
	set tFieldname=""
	for  {
		set tFieldname=$o($$$EXTSQLCOL($$$rEXT,tExtentname,tFieldname)) quit:tFieldname=""
		set fieldinfo=$$$EXTSQLCOLsqlinfo($$$rEXT,tExtentname,tFieldname)
		if skipHiddenFields,$$$SQLLocColHidden(fieldinfo)="Y" { continue }
		set tColumn=$lg(fieldinfo)
		set byName(tFieldname)=tColumn,byNumber(tColumn)=tFieldname
	}
	QUIT 1
}

/// Sets the collection projection option. 
/// Setting takes effect when classes are recompiled.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>value</i>
/// <dd>0 - do not project collections as a column if the collection is projected as a child table. <br>
/// 1 - project all collections as columns. <br>
/// </dl>
/// <b>Returns:</b>
/// <dl>
/// <dd>Old value (0, 1) of the CollectionProjection setting.
/// </dl>
/// 
ClassMethod SetCollectionProjection(value As %Library.Integer = 0) As %Library.Integer [ ProcedureBlock = 1 ]
{
	Set oldValue = $$$CollectionProjectionGet
	$$$CollectionProjectionSet(value)
	Quit oldValue
}

/// <p>Set the Transaction Isolation Mode for this Cach&eacute; process.</p>
/// <p>
/// The ISOLATION MODE options permit you to specify whether or not uncommitted changes to the database should be available for read access by a SELECT query. 
/// The COMMITTED READ option states that only those changes that have been committed are available for query access. If requested data has been changed, 
/// but the changes have not been committed (or rolled back), the query waits for transaction completion. 
/// If a lock timeout occurs while waiting for this data to be available, an SQLCODE error is issued. COMMITTED READ is the default. 
/// The UNCOMMITTED READ option states that all changes are immediately available for query access. 
/// <p>Setting takes effect immediately and lasts for the duration of the process or until SetIsolationMode is called again.</p>
/// <p>Valid values are:</p>
/// <p>
/// <table cols=2 cellpadding=5>
/// <tr><td>0</td><td>UNCOMMITTED READ (Default)</td></tr>
/// <tr><td>1</td><td>COMMITTED READ</td></tr>
/// </table>
/// </p>
/// <p>
/// If a valid value is passed in then the Isolation Mode option for the current process will be set to that value and the previous Isolation Mode value is returned.
/// Otherwise the Isolation Mode setting is left unchanged and <var>pStatus</var> will contain a %Status
/// value describing the error and the current Isolation Mode value is returned.
/// </p>
ClassMethod SetIsolationMode(value As %Integer = 1, ByRef pStatus As %Library.Status) As %Integer
{
	if '$Find("|0|1",value) { set pStatus = $$$ERROR($$$DTValueList,value,"0|1") quit $zu(115,2) }
	set pStatus = $$$OK
	quit $zu(115,2,value)
}

/// Return the current process's Transaction Isolation Mode value.
/// Possible values are:
/// <p>
/// <table cols=2 cellpadding=5>
/// <tr><td>0</td><td>UNCOMITTED READ (Default)</td></tr>
/// <tr><td>1</td><td>COMMITTED READ</td></tr>
/// </table>
ClassMethod GetIsolationMode() As %Integer [ CodeMode = expression ]
{
$zu(115,2)
}

/// <p>Set the Lock Timeout for this Cach&eacute; process.</p>
/// <p>
/// The lock timeout (in seconds) for Cach&eacute; locks made during execution of SQL statements.
/// <p>Setting takes effect immediately and lasts for the duration of the process or until SetProcessLockTimeout is called again.</p>
/// <p>An integer value should be specified for <i>value</i>.</p>
/// <p>
ClassMethod SetProcessLockTimeout(value As %Integer = 1, ByRef pStatus As %Library.Status) As %Integer
{
	set pStatus = $$$OK
	quit $zu(115,4,value)
}

/// Return the Lock Timeout value for the current process.
ClassMethod GetProcessLockTimeout() As %Integer [ CodeMode = expression ]
{
$zu(115,4)
}

/// Set the select mode for this Cach&eacute; process.
/// Setting takes effect immediately and lasts for the duration of the process or until SetSelectMode is called again.<br>
/// Valid values are:
/// <p>
/// <table cols=2 cellpadding=5>
/// <tr><td>0</td><td>Logical</td></tr>
/// <tr><td>1</td><td>ODBC</td></tr>
/// <tr><td>2</td><td>Display</td></tr>
/// </table>
/// If a valid value is passed in, then the select mode for the current process will be set to that value and the previous select mode value is returned.
/// Otherwise, the select mode setting is left unchanged and <var>pStatus</var> will contain a %Status
/// value describing the error and the current select mode value is returned.<br>
/// The select mode set by this API is used when:<br>
///     #SQLCompile Select = Runtime<br>
/// is specified for the compiled SQL code.<br>
/// When the SQL statement is compiled in Runtime mode, the mode specified by SetSelectMode will be used at runtime
/// to determine whether Logical(0), ODBC(1), or Display(2) mode is used for the statement. 
/// See the documentation for <i>#SQLCompile Select</i> for more information.
ClassMethod SetSelectMode(value As %Integer = 1, ByRef pStatus As %Library.Status) As %Integer
{
	if '$Find("|0|1|2",value) { set pStatus = $$$ERROR($$$DTValueList,value,"0|1|2") quit $zu(115,5) }
	set pStatus = $$$OK
	quit $zu(115,5,value)
}

/// Return the select mode value for the current process.
/// Possible values are:
/// <p>
/// <table cols=2 cellpadding=5>
/// <tr><td>0</td><td>Logical</td></tr>
/// <tr><td>1</td><td>ODBC</td></tr>
/// <tr><td>2</td><td>Display</td></tr>
/// </table>
/// The select mode returned by this API is used when:<br>
///     #SQLCompile Select = Runtime<br>
/// is specified for the compiled SQL code.<br>
/// When the SQL statement is compiled in Runtime mode, the mode returned by GetSelectMode will be used at runtime
/// to determine whether Logical(0), ODBC(1), or Display(2) mode is used for the statement. 
/// See the documentation for <i>#SQLCompile Select</i> for more information.
ClassMethod GetSelectMode() As %Integer [ CodeMode = expression ]
{
$zu(115,5)
}

/// This method closes all the open ODBC/JDBC Gateway connections and unloads the SQL Gateway shared library.
ClassMethod DropAll() As %Integer
{
 d DropAll^%apiGTW()
}

/// THIS FUNCTION IS NO LONGER SUPPORTED
/// As an alternative to Cach&eacute; SQL's native security
/// checking, you may define override security. This
/// allows you to set up a security system by calling
/// out to external security checking routines.
/// The extrinsic function you specify must take the
/// form:<br>
/// <pre>
/// tag^routine
/// </pre>
/// The extrinsic function overrides the standard Cach&eacute;
/// SQL security checking. The user validation check is
/// performed by this function. Your extrinsic function
/// should take the username and password specified by
/// the user as input parameters. If the username and
/// password are valid, the function must return the SQL
/// username to use with Cach&eacute; SQL. If the username
/// and password are invalid, the function should return
/// NULL ("").<br>
/// <br>
/// A simple example would be:<br>
/// <pre>
/// UserPass^Security(user,pass)
/// If LoginSuccessful, Set user=SQLUserName
/// Else Set user=""
/// Quit
/// 
/// Your function call could be invoked by:
/// Set SQLUser=$$UserPass^Security(username,password)
/// </pre>
/// To define this override via this entrypoint do:<br>
/// <pre>
/// Do SetSQLLoginOverride^%apiSQL("UserPass^Security")
/// </pre>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>function</i>
/// <dd>The <i>tag^routine</i> to be called as an extrinsic
/// function to perform validation.<br>
/// Call with <i>function</i> of <i>""</i> or <i>undefined</i> to delete
/// override login code for this system.
/// </dl>
/// <br>
/// <i><b>NOTE:</b> Changing this setting through this API only changes
/// the setting until Cach&eacute; is stopped. Once Cach&eacute; is restarted, the
/// settings from the Cach&eacute; Configuration Manager are restored. To
/// permanently change this setting, use Cach&eacute; Configuration Manager.</i>
/// THIS FUNCTION IS NO LONGER SUPPORTED
ClassMethod SetSQLLoginOverride(function As %Library.String = "") As %Library.String [ Internal ]
{
	Do SetSQLLoginOverride^%apiSQL(function)
	QUIT ""
}

/// Set the system wide flag for controlling if SQL Functions perform ODBCToLogical/DisplayToLogical on SQL Function input arguments.
/// Setting takes effect immediately for all new compilations/prepares of SQL statements system wide.<br>
/// Change does not affect already compiled statements or cached dynamic statements compiled with the previous value.<br>
/// <br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) If <i>flag</i> is FALSE(0) (the default), SQL will not convert input arguments for SQL Functions from Odbc/Display to Logical format.
/// If TRUE(1), SQL will convert input arguments for SQL Functions from Odbc/Display to Logical format if needed.
/// <dt><i>pStatus</i>
/// <dd>Status Code reports the success or failure of this API call
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Old value of the SQLFunctionArgConversion setting
/// <p>
/// <p><b>Example</b>:
/// <ul>
/// <li>Set oldvalue = $SYSTEM.SQL.GetSQLFunctionArgConversion(1,.sc)<br>
/// SELECT SQLUser.AddDay('2013-01-01')<br>
/// In the statement above, if the type of the argument to AddDay is %Date and this statement is executed in ODBC mode, you may or may not want the input argument to be converted from ODBC date format to Logical %Date format.  
/// If you would like Cach&eacute; to handle the conversion automatically, use $SYSTEM.SQL.SetSQLFucntionArgConverion(1)</li>
/// </ul>
/// <i><b>NOTES:</b>
/// <dd> - Setting takes effect immediately for all new compilations/prepares of SQL statements system wide.<br>
/// <dd> - Change does not affect already compiled statements or cached dynamic statements compiled with the previous value.<br>
/// <dd> - This is a system-wide setting.</i>
ClassMethod SetSQLFunctionArgConversion(flag As %Integer = 1, ByRef pStatus As %Library.Status) As %Boolean
{
	try {
		set tReturn=$$$SQLFunctionArgConversionG,pStatus=$$$OK
		if '$Find("|0|1",flag) { set pStatus = $$$ERROR($$$DTValueList,flag,"0|1") quit  }
		set $$$SQLFunctionArgConversion=flag
	} catch {
		set pStatus=$$$ERROR($$$GeneralError,"Error encountered in $SYSTEM.SQL.SetSQLFunctionArgConversion: "_$ze)
	}
	QUIT tReturn
}

/// Get the current setting of the system wide flag for controlling if SQL Functions perform ODBCToLogical/DisplayToLogical on SQL Function input arguments.<br>
/// <br>
/// <b>Parameters:</b><br>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) If <i>flag</i> is FALSE(0) (the default), SQL will not convert input arguments for SQL Functions from Odbc/Display to Logical format.
/// If TRUE(1), SQL will convert input arguments for SQL Functions from Odbc/Display to Logical format if needed.
/// <dt><i>pStatus</i>
/// <dd>Status Code reports the success or failure of this API call
/// </dl>
/// <b>Returns:</b>
/// <p>
/// <dd>Current value of the SQLFunctionArgConversion setting
/// <p>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Set return = $SYSTEM.SQL.GetSQLFunctionArgConversion()</li>
/// </ul>
/// <i><b>NOTES:</b>
/// <dd> - This is a system-wide setting.</i>
ClassMethod GetSQLFunctionArgConversion() As %Boolean
{
	QUIT $$$SQLFunctionArgConversionG
}

/// Set the configuration setting which determines if SQL security is enabled.
/// If SQL security is ON, all Cach&eacute; SQL security is active.
/// This means:
/// <ul>
/// <li>Privilege-based table/view security is active. A user may only perform actions on a
/// table or view they have been granted privilege for.</li>
/// </ul>
/// If SQL security is OFF, Cach&eacute; SQL security is inactive. This means:
/// <ul>
/// <li>Privilege-based table/view security is suppressed. A user may perform actions on a table
/// or view even if they have not been granted privileges to do so.</li>
/// </ul>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) If <i>flag</i> is TRUE (1), SQL security is ON
/// If <i>flag</i> is FALSE (0), SQL security is OFF. The default is TRUE(1).
/// <dt><i>oldval</i>
/// <dd>Passed By Reference. Contains the previous value of the setting.
/// </dl>
/// <b>Returns:</b>
/// <dl>
/// <dd>Status Code
/// </dl>
/// <i><b>NOTES:</b> 
/// <dl>
/// <dd> - You must have the "USE" permission on the %Admin Manage Resource in order to change this configuration setting.
/// <dd> - Changing this configuration setting will only take effect for this process and new processes starting in Cach&eacute after this function is called. 
/// Any existing Cach&eacute processes will still use the old setting.
/// <dd> - This is a system-wide setting.
/// </dl></i>
ClassMethod SetSQLSecurity(flag As %Library.Boolean = 1, ByRef oldval As %Library.Boolean) As %Library.Status
{
	QUIT $$SetSQLSecurity^%apiSQL(flag,.oldval)
}

/// Returns ODBC/JDBC/SQL Manager initialization code.
/// This Initialization code is executed at login time when connecting to
/// Cach&eacute; SQL through ODBC, JDBC, or the SQL Manager. 
/// If no initialization code is defined for this namespace, "" is returned.
/// Initialization code is defined on a per-namespace basis.<br>
/// <br>
/// <p>Examples:
/// <ul>
/// <li>Write $SYSTEM.SQL.GetServerInitCode()</li>
/// </ul>
ClassMethod GetServerInitCode() As %Library.String
{
	QUIT $$GetServerInitCode^%apiSQL()
}

/// Define ODBC/JDBC/SQL Manager initialization code.
/// This Initialization code is executed at login time when connecting to
/// Cach&eacute; SQL through ODBC, JDBC, or the SQL Manager. Initialization
/// code is defined on a per-namespace basis.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>code</i>
/// <dd>A single line of Cach&eacute; ObjectScript to be executed.
/// Call with <i>code=""</i> or <i>undefined</i> to delete
/// initialization code for this namespace.
/// </dl>
/// <p>Examples:
/// <ul>
/// <li>Do $SYSTEM.SQL.SetServerInitCode("Do Setup^%ZMedPatSetup")</li>
/// <li>Do $SYSTEM.SQL.SetServerInitCode("")</li>
/// </ul>
/// <dd> - Changing this configuration setting will only take effect for new processes starting in Cach&eacute after this function is called.
/// Any existing Cach&eacute processes will not have executed the server init code upon connection.
ClassMethod SetServerInitCode(code As %Library.String = "") As %Library.String
{
	Do SetServerInitCode^%apiSQL(code)
	QUIT ""
}

/// Define ODBC/JDBC disconnect code.
/// Upon disconnect any ObjectScript code defined in this setting will be executed immediately before 
/// the server process Halts.  This code will also attempt to be executed anytime the server process 
/// encounters an unrecoverable error that causes the server process to Halt.  
/// It will not be executed if the server process encounters a Halt in other user defined code, 
/// if the process crashes, if the process is stopped, or Cach&eacute; is stopped or forced down.
/// The disconnect code is defined on a per-namespace basis.<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>code</i>
/// <dd>A single line of Cach&eacute; ObjectScript to be executed.
/// Call with <i>code=""</i> or <i>undefined</i> to delete
/// disconnect code for this namespace.
/// </dl>
/// <p>Examples:
/// <ul>
/// <li>Do $SYSTEM.SQL.SetServerDisconnectCode("Do Cleanup^%ZMedPatUtil")</li>
/// <li>Do $SYSTEM.SQL.SetServerDisconnectCode("")</li>
/// </ul>
/// <dd> - Changing this configuration setting will take effect immediately for all server processes in Cach&eacute after this function is called.
/// Any existing Cach&eacute processes will execute the server disconnect code disconnection.
ClassMethod SetServerDisconnectCode(code As %Library.String = "") As %Library.String
{
	Do SetServerDisconnectCode^%apiSQL(code)
	QUIT ""
}

/// Returns ODBC/JDBC disconnect code.
/// Upon disconnect any ObjectScript code defined in this setting will be executed immediately before 
/// the server process Halts.  This code will also attempt to be executed anytime the server process 
/// encounters an unrecoverable error that causes the server process to Halt.  
/// It will not be executed if the server process encounters a Halt in other user defined code, 
/// if the process crashes, if the process is stopped, or Cach&eacute; is stopped or forced down.
/// If no disconnect code is defined for this namespace, "" is returned.
/// The disconnect code is defined on a per-namespace basis.<br>
/// <br>
/// <p>Examples:
/// <ul>
/// <li>Write $SYSTEM.SQL.GetServerDisconnectCode()</li>
/// </ul>
ClassMethod GetServerDisconnectCode() As %Library.String
{
	QUIT $$GetServerDisconnectCode^%apiSQL()
}

/// THIS FUNCTION IS NO LONGER SUPPORTED
/// Set the flag which determines if Threshold checking is code generated into SQL statements. 
/// A value of TRUE enables the code generation of Threshold checking. The default value Cach&eacute;
/// is first installed with is FALSE (no Threshold checks are code generated).<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) If <i>flag</i> is TRUE (1), the SQL compiler code generates Threshold checks.
/// If <i>flag</i> is FALSE (0), the SQL compiler does not code generate Threshold checks. The default is FALSE (0).
/// </dl>
/// <i><b>NOTE:</b> When this setting is change, any SQL statement already compiled will have to be recompiled
/// in order for this setting to take affect for that statement.</i>
/// THIS FUNCTION IS NO LONGER SUPPORTED
ClassMethod SetThresholdCodeGen(flag As %Library.Boolean = 0) As %Library.String [ Internal ]
{
	Do SetThresholdCodeGen^%apiSQL(flag)
	Quit ""
}

/// THIS FUNCTION IS NO LONGER SUPPORTED
/// Set the flag which determines if Threshold checking is checked at SQL run-time. 
/// Threshold checking can only occur at run time if the Threshold checks have been code generated in the SQL code. 
/// The default value Cach&eacute; is first installed with is FALSE (no Threshold checks are checked at run-time).<br>
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd>TRUE(1)/FALSE(0) If <i>flag</i> is TRUE (1), Threshold checks are performed at SQL run-time.
/// If <i>flag</i> is FALSE (0), Threshold checks are not performed at run-time. The default is FALSE (0).
/// </dl>
/// THIS FUNCTION IS NO LONGER SUPPORTED
ClassMethod SetThresholdRunTime(flag As %Library.Boolean = 0) As %Library.String [ Internal ]
{
	Do SetThresholdRunTime^%apiSQL(flag)
	Quit ""
}

/// Interactive SQL Shell. Execute SQL statements from the command line. Refer to %SQL.Shell for more info.
ClassMethod Shell() As %Library.String
{
	Do ##class(%SQL.Shell).%Go()
	QUIT ""
}

/// Display the execution plan for an SQL statement
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>sql</i>
/// <dd>Passed by reference.  sql=# of SQL lines, sql(1)=first SQL line, ... sql(n)=last SQL line.
/// <dt><i>array</i>
/// <dd>Optional, 1 or 0, default is 0.  If 1, leave the resulting plan lines in the %plan() array, otherwise generate the plan output using Write commands.
/// <dt><i>showstats</i>
/// <dd>Optional, 1 or 0, default is 0.  If 1, run the SQL query to generate stats and output the stats as part of the plan text.
/// <dt><i>packages</i>
/// <dd>Optional, default is "".  $List of Package names that will be used as default packages/schemas.
/// <dt><i>schemapath</i>
/// <dd>Optional, default is "".  Any non-NULL value will be set into %sqlSchemaPath overriding any currently defined %sqlSchemaPath
/// <dt><i>preparse</i>
/// <dd>Optional, 1 or 0, default is 0.  If 1, ShowPlan will first preparse the SQL statement to perform literal replacement.
/// </dl>
ClassMethod ShowPlan(sql As %Library.String, array As %Library.Boolean = 0, showstats As %Library.Boolean = 0, packages As %Library.List = "", schemapath As %Library.String = "", preparse As %Library.Boolean = 0)
{
	new %qi,%qln,%qsize,%sqlcodegen,comerr,line
	do ShowPlan^%apiSQL(.sql,array,0,showstats,packages,schemapath,preparse)
	QUIT
}

/// Display the execution plan for an SQL statement, then list other query costs the user can select to see alternate plans
/// <br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>sql</i>
/// <dd>Passed by reference.  sql=# of SQL lines, sql(1)=first SQL line, ... sql(n)=last SQL line.
/// <dt><i>array</i>
/// <dd>Optional, 1 or 0, default is 0.  If 1, leave the resulting plan lines in the %AltPlan() array, otherwise generate the plan output using Write commands.
/// <dt><i>showstats</i>
/// <dd>Optional, 1 or 0, default is 0.  If 1, run the SQL query to generate stats and output the stats as part of the plan text.
/// <dt><i>packages</i>
/// <dd>Optional, default is "".  $List of Package names that will be used as default packages/schemas.
/// <dt><i>schemapath</i>
/// <dd>Optional, default is "".  Any non-NULL value will be set into %sqlSchemaPath overriding any currently defined %sqlSchemaPath
/// <dt><i>preparse</i>
/// <dd>Optional, 1 or 0, default is 0.  If 1, ShowPlan will first preparse the SQL statement to perform literal replacement.
/// </dl>
ClassMethod ShowPlanAlt(sql As %Library.String, array As %Library.Boolean = 0, showstats As %Library.Boolean = 0, packages As %Library.List = "", schemapath As %Library.String = "", preparse As %Library.Boolean = 0)
{
	new %qi,%qln,%qsize,%sqlcodegen,comerr,line
	do ShowPlanAlt^%apiSQL(.sql,array,0,showstats,packages,schemapath,preparse)
	QUIT
}

/// Import a Sybase DDL/DML script file.<br>
/// The Sybase DDL/DML Import Utility supports the following statements:<ul>
/// <li>CREATE [GLOBAL TEMPORARY] TABLE ...</li>
/// <li>CREATE VIEW ...</li>
/// <li>ALTER TABLE ...</li>
/// <li>CREATE INDEX ...</li>
/// <li>CREATE CLUSTERED INDEX ...</li>
/// <li>CREATE UNIQUE INDEX ...</li>
/// <li>INSERT ...</li>
/// <li>UPDATE ...</li>
/// <li>DELETE ...</li>
/// <li>SET OPTION ...</li>
/// <li>GRANT CONNECT ... (Same as Cach&eacute; SQL CREATE USER ...)</li>
/// <li>GRANT { ALTER | SELECT | INSERT | UPDATE | DELETE | REFERENCES | ALL PRIVILEGES } ...</li>
/// </ul>
/// Statements other than the ones above are not handled by the utility and must be added 
/// to your Cach&eacute; application manually (if applicable).
ClassMethod Sybase() As %Library.String
{
	Do Sybase^%apiSQL
	QUIT ""
}

/// This entry point can be used to invoke the TSQL shell.
/// <br><br>
/// <b>(no parameters or result)</b>
/// <dl>
/// <p><b>Example</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.TSQLShell()</li>
/// </ul>
/// <p>In the shell type ? for help
ClassMethod TSQLShell()
{
	do ##class(%SQL.Shell).%Go($Get(^%SYS("tsql","DIALECT"),"MSSQL"))
}

/// Calculate accurate extentsize and selectivity for all classes/tables and their properties/fields within a schema.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>schema</i>
/// <dd>Name of a schema to tune tables.
/// If the schema name is omitted, the default schema is used.
/// <dt><i>update</i>
/// <dd>TRUE(1)/FALSE(0) flag. Tells tuner whether to update the
/// tables and class definitions with the new extentsize and selectivity values.
/// If <i>update</i>=1, the values will be updated in the table
/// and class definition. The default is FALSE (0).
/// <dt><i>display</i>
/// <dd>TRUE(1)/FALSE(0) flag. Displays progress messages to the current device if
/// TRUE. The default is FALSE (0).
/// <dt><i>pMessage</i>
/// <dd>Passed by reference. May return error information.
/// <dt><i>KeepClassUpToDate</i>
/// <dd>TRUE(1)/FALSE(0) flag. If TRUE (and <i>update</i> is TRUE), the class definition will be
/// updated with the new EXTENTSIZE and SELECTIVITY values, but the class definition will be kept
/// as up-to-date. In many cases, however, it is desirable to recompile the class after its table
/// has been tuned so that queries in the class definition can be recompiled and the SQL query optimizer
/// can use the updated data statistics. The default is FALSE (0).
/// Note that if the class is deployed the class definition will not be updated.
/// <dt><i>ClearValues</i>
/// <dd>TRUE(1)/FALSE(0) flag. If TRUE (and <i>update</i> is TRUE), the SELECTIVITY and EXTENTSIZE 
/// settings will be cleared from the class and table definition.  Note that if the class is deployed
/// the class definition will not be updated.
/// <dt><i>LogFile</i>
/// <dd>Optional name of a file to log the output of the TuneTable utility to.
/// If <i>display</i> is also TRUE, output will go to the current device and the log file.
/// <dt><i>RecompileCQ</i>
/// <dd>Default value is 0.  Optional value, if TRUE(1) attempt to recompile cached queries instead of purging them.
/// If the recompile encounters any errors, the cached query will be purged.  This will only work if the <i>Keep Cached Query Source</i> SQL setting is TRUE.
/// When the Keep Cached Query Source setting is FALSE the cached classes are deployed and cannot be recompiled.  This argument also only has an effect when <i>KeepClassUpToDate</i> is FALSE.
/// <dt><i>SamplePercent</i>
/// <dd>The percentage of rows of the table to be used for sampling the data for the TuneTable utility.  This percentage can be specified as .## or ##%.  
/// For example .12 or 12% will cause TuneTable to use 12% of the rows in the table when sampling the data.  This value does not usually need to be specified when calling TuneTable.
/// Only specify this value when potential outlier values for a field are not evenly distributed among rows throughout the table. 
/// Note, for any table with an extentsize < 1000, the entire extent will be used by TuneTable.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.TuneSchema("MedLab",1,1,.errors,1,0,"TuneLog.txt",0,"40%")</li>
/// <li>Do $SYSTEM.SQL.TuneSchema("""Medical Lab""",1,1,.errors,0)</li>
/// <li>Do $SYSTEM.SQL.TuneSchema("") ; Tunes SQLUser schema</li>
/// </ul>
ClassMethod TuneSchema(schema As %Library.String, update As %Library.Boolean = 0, display As %Library.Boolean = 0, ByRef pMessage As %Library.String, KeepClassUpToDate As %Library.Boolean = 0, ClearValues As %Library.Boolean = 0, LogFile As %Library.String = "", RecompileCQ As %Library.Boolean = 0, SamplePercent As %Library.String = "") As %Library.String
{
	Do TuneSchema^%apiSQL($g(schema),update,display,.pMessage,KeepClassUpToDate,ClearValues,LogFile,RecompileCQ,SamplePercent)
	QUIT ""
}

/// Calculate accurate extentsize and selectivity for a class/table and its properties/fields.
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>table</i>
/// <dd>Name of a table or '*' to tune all tables.
/// The name may be qualified with a schema name:
/// <i>Medical.Patient</i>
/// If the schema name is omitted, the default schema is used.
/// <dt><i>update</i>
/// <dd>TRUE(1)/FALSE(0) flag. Tells tuner whether to update the
/// table and class definitions with the new extentsize and selectivity values.
/// If <i>update</i>=1, the values will be updated in the table
/// and class definition. The default is FALSE (0).
/// <dt><i>display</i>
/// <dd>TRUE(1)/FALSE(0) flag. Displays progress messages to the current device if
/// TRUE. The default is FALSE (0).
/// <dt><i>pMessage</i>
/// <dd>Passed by reference. May return error information.
/// <dt><i>KeepClassUpToDate</i>
/// <dd>TRUE(1)/FALSE(0) flag. If TRUE (and <i>update</i> is TRUE), the class definition will be
/// updated with the new EXTENTSIZE and SELECTIVITY values, but the class definition will be kept
/// as up-to-date. In many cases, however, it is desirable to recompile the class after its table
/// has been tuned so that queries in the class definition can be recompiled and the SQL query optimizer
/// can use the updated data statistics. The default is FALSE (0).
/// Note that if the class is deployed the class definition will not be updated.
/// <dt><i>ClearValues</i>
/// <dd>TRUE(1)/FALSE(0) flag. If TRUE (and <i>update</i> is TRUE), the SELECTIVITY and EXTENTSIZE 
/// settings will be cleared from the class and table definition.  Note that if the class is deployed
/// the class definition will not be updated.
/// <dt><i>LogFile</i>
/// <dd>Optional name of a file to log the output of the TuneTable utility to.
/// If <i>display</i> is also TRUE, output will go to the current device and the log file.
/// <dt><i>ExtentSize</i>
/// <dd>Default value is "".  Optional value to be used as the table ExtentSize instead of calculating it.
/// <dt><i>RecompileCQ</i>
/// <dd>Default value is 0.  Optional value, if TRUE(1) attempt to recompile cached queries instead of purging them.
/// If the recompile encounters any errors, the cached query will be purged.  This will only work if the <i>Keep Cached Query Source</i> SQL setting is TRUE.
/// When the Keep Cached Query Source setting is FALSE the cached classes are deployed and cannot be recompiled.  This argument also only has an effect when <i>KeepClassUpToDate</i> is FALSE.
/// <dt><i>SamplePercent</i>
/// <dd>The percentage of rows of the table to be used for sampling the data for the TuneTable utility.  This percentage can be specified as .## or ##%.  
/// For example .12 or 12% will cause TuneTable to use 12% of the rows in the table when sampling the data.  This value does not usually need to be specified when calling TuneTable.
/// Only specify this value when potential outlier values for a field are not evenly distributed among rows throughout the table. 
/// Note, for any table with an extentsize < 1000, the entire extent will be used by TuneTable.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.TuneTable("MedLab.Patient",1,1,.errors,1,,"Tune.log",999999,0,"30%")</li>
/// <li>Do $SYSTEM.SQL.TuneTable("""Medical Lab"".Patient",1,1,.errors,0)</li>
/// <li>Do $SYSTEM.SQL.TuneTable("IscPerson") ; Tunes SQLUser.IscPerson</li>
/// </ul>
ClassMethod TuneTable(table As %Library.String, update As %Library.Boolean = 0, display As %Library.Boolean = 0, ByRef pMessage As %Library.String, KeepClassUpToDate As %Library.Boolean = 0, ClearValues As %Library.Boolean = 0, LogFile As %Library.String = "", ExtentSize As %Library.Integer = "", RecompileCQ As %Library.Boolean = 0, SamplePercent As %Library.String = "") As %Library.String
{
	Do TuneTable^%apiSQL($g(table),update,display,.pMessage,KeepClassUpToDate,ClearValues,LogFile,ExtentSize,RecompileCQ,SamplePercent)
	QUIT ""
}

/// Freeze or Unfreeze plans or SQL statements in this namespace
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>Action</i>
/// <dd>0 means Unfreeze plans, 1 means freeze plans.  Default is 1.
/// <dt><i>Scope</i>
/// <dd>1 for all plans in this namespace, 2 for all plans for a given schema, 3 for all plans for a given relation, 4 for a single plan for a given statement hash.  Default is 1.
/// <dt><i>ScopeArgument</i>
/// <dd>If <i>Scope</i>=2, the name of the schema for which to freeze the plans, if <i>Scope</i>=3, the name of the relation for which to freeze the plans.
/// <dd>If <i>Scope</i>=3, the name of the relation needs to be in what we call internal qualified format.  This is typically simply Schema.Tablename, but if tablename itself contains any "." characters, it needs to be in Schema_"."_$translate(Tablename,".",$Char(2)) format.
/// <dd>If <i>Scope</i>=4, the value of the statement hash id.  This is typically hash value like "3DgIqc72NS+Np6nybddb719NKb8=".
/// <dt><i>Errors</i>
/// <dd>Passed by reference.  Returns an array of error messages if there are any failures while freezing plans.
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.FreezePlans(1,1,,.Errors))   // Freezes all SQL statement plans in the current namespace</li>
/// <li>Do $SYSTEM.SQL.FreezePlans(1,2,"XLT",.Errors))   // Freezes all SQL statement plans in the current namespace for each statement that references a relation in the XLT schema.</li>
/// <li>Do $SYSTEM.SQL.FreezePlans(1,3,"XLT.Person",.Errors))   // Freezes all SQL statement plans in the current namespace for each statement that references the XLP.Person table.</li>
/// <li>Do $SYSTEM.SQL.FreezePlans(1,4,"3DgIqc72NS+Np6nybddb719NKb8=",.Errors))   // Freezes SQL statement plan for statement identified by hash "3DgIqc72NS+Np6nybddb719NKb8=".</li>
/// <li>Do $SYSTEM.SQL.FreezePlans(0,1,,.Errors))   // Unfreezes all SQL statement plans in the current namespace</li>
/// <li>Do $SYSTEM.SQL.FreezePlans(0,2,"XLT",.Errors))   // Unfreezes all SQL statement plans in the current namespace for each statement that references a relation in the XLT schema.</li>
/// <li>Do $SYSTEM.SQL.FreezePlans(0,3,"XLT.Person",.Errors))   // Unfreezes all SQL statement plans in the current namespace for each statement that references the XLP.Person table.</li>
/// <li>Do $SYSTEM.SQL.FreezePlans(0,4,"3DgIqc72NS+Np6nybddb719NKb8=",.Errors))   // Unfreezes SQL statement plan for statement identified by hash "3DgIqc72NS+Np6nybddb719NKb8=".</li>
/// </ul>
ClassMethod FreezePlans(Action As %Library.SmallInt = 1, Scope As %Library.SmallInt = 1, ScopeArgument As %Library.String = "", ByRef Errors As %Library.String) [ ProcedureBlock = 1, PublicList = SQLCODE ]
{
	kill:$d(Errors) Errors
	set Errors=0
	if '$SYSTEM.Security.Check($$$DevelopmentResourceName,$$$PermUseName) {
		set Errors=Errors+1,Errors(Errors)="User '"_$username_"' is not privileged for the operation of "_$s(Action=1:"freezing",1:"un-freezing")_" query plans."
		QUIT
	}
	if Scope=1	{ 
		if Action=1 		{ do FreezePlanAll^%SYS.SQLSRV(1,.Errors) }
		elseif Action=0	{ do FreezePlanAll^%SYS.SQLSRV(0,.Errors) }
		else 			{ set Errors=Errors+1,Errors(Errors)="Action argument must be 1 or 0." }
	}
	elseif Scope=2	{
		if Action=1 		{ do FreezePlanSchema^%SYS.SQLSRV(1,ScopeArgument,.Errors) }
		elseif Action=0	{ do FreezePlanSchema^%SYS.SQLSRV(0,ScopeArgument,.Errors) }
		else 			{ set Errors=Errors+1,Errors(Errors)="Action argument must be 1 or 0." }
	}
	elseif Scope=3	{
		if Action=1 		{ do FreezePlanRelation^%SYS.SQLSRV(1,ScopeArgument,.Errors) }
		elseif Action=0	{ do FreezePlanRelation^%SYS.SQLSRV(0,ScopeArgument,.Errors) }
		else 			{ set Errors=Errors+1,Errors(Errors)="Action argument must be 1 or 0." }
	}
	elseif Scope=4	{
		if Action=1 		{ set val=$$FreezePlan^%SYS.SQLSRV(ScopeArgument) if 'val { set Errors=Errors+1,Errors(Errors)="Error freezing plan for statement id '"_ScopeArgument_"'. SQLCODE="_$g(SQLCODE)_", %msg="_$g(%msg) }}
		elseif Action=0	{ set val=$$UnfreezePlan^%SYS.SQLSRV(ScopeArgument) if 'val { set Errors=Errors+1,Errors(Errors)="Error freezing plan for statement id '"_ScopeArgument_"'. SQLCODE="_$g(SQLCODE)_", %msg="_$g(%msg) }}
		else 			{ set Errors=Errors+1,Errors(Errors)="Action argument must be 1 or 0." }
	}
	else 		{ set Errors=Errors+1,Errors(Errors)="Scope argument must be 1, 2, 3, or 4." }
	QUIT
}

/// Export extentsize and selectivity for tables/fields to an XML file.  
/// Generated file can be loaded using $SYSTEM.SQL.ImportTuneStats().
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>pFilename</i>
/// <dd>Name of the file to output the table(s) tuning statistics to.
/// <dt><i>pSchemaFilter</i>
/// <dd>Filter to limit the schemas output.  The default is "", which means there is no filter applied and all schemas in the namespace are exported.
/// pSchemaFilter uses '_' to signify any single character, '*' to signify 0 through N characters, and ' to signify NOT.
/// <dt><i>pTableFilter</i>
/// <dd>Filter to limit the tables output.  The default is "", which means there is no filter applied and all tables in the specified schemas are exported.
/// pTableFilter uses '_' to signify any single character, '*' to signify 0 through N characters, and ' to signify NOT.
/// <dt><i>pDisplay</i>
/// <dd>TRUE(1)/FALSE(0) flag. Displays progress messages to the current device if TRUE. The default is TRUE (1).
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.ExportTuneStats("C:\AllStats.xml") // Exports TuneTable Statistics for all schemas/tables in the current namespace</li>
/// <li>Do $SYSTEM.SQL.ExportTuneStats("C:\SampleStats.xml","Sample") // Exports TuneTable Statistics for all Sample.* tables in the current namespace</li>
/// <li>Do $SYSTEM.SQL.ExportTuneStats("C:\SamplePStats.xml","Sample","P*") // Exports TuneTable Statistics for all Sample.P* in the current namespace</li>
/// <li>Do $SYSTEM.SQL.ExportTuneStats("C:\SamplePersonStats.xml","Sample","Person") // Exports TuneTable Statistics for table Sample.Person in the current namespace</li>
/// </ul>
ClassMethod ExportTuneStats(pFilename As %Library.String, pSchemaFilter As %Library.String = "", pTableFilter As %Library.String = "", pDisplay As %Library.Boolean = 1) As %Library.Status [ ProcedureBlock = 1 ]
{
	set tSC=$$$OK
	set tSC=$$ExportTuneStats^%qarTune($g(pFilename),pSchemaFilter,pTableFilter,pDisplay)
	QUIT tSC
}

/// Import extentsize and selectivity for a table and its fields from a file created by $SYSTEM.SQL.ExportTuneStats().
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>pFilename</i>
/// <dd>Name of the file to output the table(s) tuning statistics to.
/// <dt><i>pDisplay</i>
/// <dd>TRUE(1)/FALSE(0) flag. Displays progress messages to the current device if TRUE. The default is TRUE (1).
/// <dt><i>KeepClassUpToDate</i>
/// <dd>TRUE(1)/FALSE(0) flag. If TRUE (and <i>update</i> is TRUE), the class definition will be
/// updated with the new EXTENTSIZE and SELECTIVITY values, but the class definition will be kept
/// as up-to-date. In many cases, however, it is desirable to recompile the class after its table
/// has been tuned so that queries in the class definition can be recompiled and the SQL query optimizer
/// can use the updated data statistics. The default is FALSE (0).
/// Note that if the class is deployed the class definition will not be updated.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.ImportTuneStats("C:\AllStats.xml") // Import TuneTable Statistics for all schemas/tables that were exported with the $SYSTEM.SQL.ExportTuneStats() to the AllStats.xml file</li>
/// </ul>
ClassMethod ImportTuneStats(pFilename As %Library.String, pDisplay As %Library.Boolean = 1, pKeepClassUpToDate As %Library.Boolean = 0) As %Library.Status [ ProcedureBlock = 1 ]
{
	set tSC=$$$OK
	set tSC=$$ImportTuneStats^%qarTune($g(pFilename),pDisplay,pKeepClassUpToDate)
	QUIT tSC
}

/// Export an SQL Statement Index entry, including query plan.
/// Generated file can be loaded using $SYSTEM.SQL.ImportStatement().<br>
/// The main reason to export/import an SQL Statement entry is to move a frozen plan from one location to another.  
/// Other than moving a frozen plan, there is not much benefit of moving an SQL Statement definition from one location to another.
/// When exporting SQL Statement definitions, the Locations (routines) the SQL Statement is defined in is not exported.  This is because it is possible the Locations are different or don't exist on the target system.
/// Recompiling the class/routines that contain the SQL Statement on the target system will redeine the Location entries for the SQL Statement definition.<br>
/// If the current user is not privileged to execute this SQL Statement, a privilege error will be returned and the export will not occur.
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>Filename</i>
/// <dd>Name of the file to output the SQL Statement definition to.
/// <dt><i>Hash</i>
/// <dd>SQL Statement definition hash, used as the ID of the SQL Statement Definition index entry
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.ExportSQLStatement("C:\MyStatement.xml","Kod99B0VFOn/aXQ9PyRGfb64q04=") // Exports SQL Satement with ID hash of 'Kod99B0VFOn/aXQ9PyRGfb64q04='</li>
/// </ul>
ClassMethod ExportSQLStatement(Filename As %Library.String = "", Hash As %Library.String = "") As %Library.Status [ ProcedureBlock = 1 ]
{
	set tSC=$$$OK
	set tSC=$$ExportSQLStatement^%SYS.SQLSRV(Filename,Hash)
	QUIT tSC
}

/// Exports all SQL Statement Index entries in this namespace, including query plans.
/// Generated file can be loaded using $SYSTEM.SQL.ImportStatement().<br>
/// The main reason to export/import an SQL Statement entry is to move a frozen plan from one location to another.  
/// Other than moving a frozen plan, there is not much benefit of moving an SQL Statement definition from one location to another.
/// When exporting SQL Statement definitions, the Locations (routines) the SQL Statement is defined in is not exported.  This is because it is possible the Locations are different or don't exist on the target system.
/// Recompiling the class/routines that contain the SQL Statement on the target system will redeine the Location entries for the SQL Statement definition.<br>
/// Any SQL Statements the current user does not have privilege to run will not be exported.
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>Filename</i>
/// <dd>Name of the file to output the SQL Statement definitions to.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.ExportAllSQLStatements("C:\MyAllStatements.xml") // Exports all SQL Satements</li>
/// </ul>
ClassMethod ExportAllSQLStatements(Filename As %Library.String = "") As %Library.Status [ ProcedureBlock = 1 ]
{
	set tSC=$$$OK
	set tSC=$$ExportAllSQLStatements^%SYS.SQLSRV(Filename)
	QUIT tSC
}

/// Import a file containing SQL Statement Index entries.
/// Files can be loaded that were generated with $SYSTEM.SQL.ExportStatement() or $SYSTEM.SQL.ExportAllStatements().<br>
/// The main reason to export/import an SQL Statement entry is to move a frozen plan from one location to another.  
/// Other than moving a frozen plan, there is not much benefit of moving an SQL Statement definition from one location to another.
/// When exporting SQL Statement definitions, the Locations (routines) the SQL Statement is defined in is not exported.  This is because it is possible the Locations are different or don't exist on the target system.
/// Recompiling the class/routines that contain the SQL Statement on the target system will redeine the Location entries for the SQL Statement definition.
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>Filename</i>
/// <dd>Name of the file to output the SQL Statement definition to.
/// <dt><i>Display</i>
/// <dd>1/0 Flag.  If 1, display import progress on the screen.  Default is 1.
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.ImportSQLStatement("C:\MyStatements.xml",1) // Imports SQL Statement(s) defined in the file</li>
/// </ul>
ClassMethod ImportSQLStatement(Filename As %Library.String = "", Display As %Library.Boolean = 1) As %Library.Status [ ProcedureBlock = 1 ]
{
	set tSC=$$$OK
	set tSC=$$ImportSQLStatement^%SYS.SQLSRV(Filename,Display)
	QUIT tSC
}

/// Given a package name, return the schema name
/// This method can also be called as a Stored Procedure named %SYSTEM.SQL_GetSchemaFromPackage(<i>packagename</i>)
ClassMethod GetSchemaFromPackage(packagename As %Library.String = "") As %Library.String [ Internal, SqlProc ]
{
	QUIT:packagename="" ""
	Set schema=$g($$$PACKAGEsqlname(packagename)) QUIT:schema'="" schema
	If packagename="User" QUIT "SQLUser"
	QUIT $tr(packagename,".","_")
}

/// Set the SELECTIVITY of a field and property to the value of the given selectivity
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>schema</i>
/// <dd>Name of the table's schema.  Default is the default schema.
/// <dt><i>tablename</i>
/// <dd>Name of the table the field is in (required).
/// <dt><i>fieldname</i>
/// <dd>Name of the field to set the SELECTIVITY for (required).
/// <dt><i>selectivity</i>
/// <dd>New selectivity value for the field (required).  The selectivity of a property specifies the approximate frequency of specific values within the entire distribution of values.
/// The Selectivity value for a column is generally the percentage of rows within a table that would be returned as a result of query searching for a typical value of the column.
/// For example, suppose a table contains a Gender column whose value is evenly distributed between "M" and "F". The Selectivity value for the Gender column would be 50%, as a 
/// typical query based on Gender would find 50% of the rows within the table. The Selectivity value for a more unique property, such as TaxID, is typically a small percentage 
/// that varies according to the size of the table.
/// Examples of values you can specify here are:
/// <li>"10%" - Means that typical values for this column will return 10% of the rows in the table</li>
/// <li>"1" - Means this field is unique.  For any given value, it will return 1 row from the table.</li>
/// <li><number> - A pure number will calculate the selectivity as EXTENTSIZE/<i>selectivity</i>.  For example, if EXTENTSIZE is 100000 and <i>selectivity</i> is 1000, this will set the selectivity to 1%.</li>
/// <li>"NUMROWS" - This is the same as specifying "1", it means the field is unique.  This is allowed for legacy support of M/SQL tables that have been converted to Cach&eacute; class definitions.</li>
/// <li>NUMROWS/positive_integer - This will calculate the SQL SELECTIVITY as EXTENTSIZE/positive_integer.  For example if EXTENTSIZE is 100000 and you specify NUMROWS/5000, this will set the SQL SELECTIVITY to 20, which means for a typical value for the field, 20 rows of the table will be returned.  This is allowed for legacy support of M/SQL tables that have been converted to Cach&eacute; class definitions.</li>
/// <dd>There is no validation of the value you enter for the SELECTIVITY.  If you enter something not recognized as a valid SELECTIVITY, such as the string "nonsense", it will be turned into a value of 0.  If the SQL query processor sees a SELECTIVITY of 0, it will attempt to come up with a typical SELECTIVITY value for the field based on how many rows are in the table and whether or not the field is a reference column, is part of the IDKEY field, has a VALUELIST specification, etc.
/// <dt><i>KeepClassUpToDate</i>
/// <dd>TRUE(1)/FALSE(0) flag. If TRUE the class definition will be
/// updated with the new SELECTIVITY value, but the class definition will be kept
/// as up-to-date. In many cases, however, it is desirable to recompile the class after its table
/// has been tuned so that queries in the class definition can be recompiled and the SQL query optimizer
/// can use the updated data statistics. The default is FALSE (0).
/// Note that if the class is deployed the class definition will not be updated.
/// </dl>
/// <p>
/// <b>Returns:</b>
/// <p>
/// <dd>Status Code
/// <p>
/// <p><b>Example</b>:
/// <ul>
/// <li>Do $SYSTEM.SQL.SetFieldSelectivity("MedLab","Patient","Home_Phone","2.5%",0)</li>
/// </ul>
ClassMethod SetFieldSelectivity(schema As %Library.String, tablename As %Library.String, fieldname As %Library.String, selectivity As %Library.String, KeepClassUpToDate As %Boolean = 0) As %Library.Status [ ProcedureBlock = 1 ]
{
 set:$g(schema)="" schema=$SYSTEM.SQL.DefaultSchema()
 QUIT:$g(tablename)="" $$$ERROR($$$InvalidParameter,"tablename","tablename parameter is required")
 QUIT:$g(fieldname)="" $$$ERROR($$$InvalidParameter,"fieldname","fieldname parameter is required")
 QUIT:$g(selectivity)="" $$$ERROR($$$InvalidParameter,"selectivity","selectivity parameter is required")
 s extent=$$$GetExtentNameFromTableName(schema,tablename)   QUIT:extent="" $$$ERROR($$$TableDoesNotExist,$$$UPPER(schema_"."_tablename))
 s fldinfo=$g($$$EXTSQLCOLsqlinfo($$$rEXT,extent,fieldname)) QUIT:fldinfo="" $$$ERROR($$$FieldNameInvalid,fieldname_" - no such field")
 s tabinfo=$$$EXTsqlinfo($$$rEXT,extent)
 s classname=$$$SetSQLLocTableClassname(tabinfo)
 s extentsize=$$$SQLLocTableExtentSize(tabinfo)
 QUIT $$SetSelectivity^%qarTune(extent,fieldname,fldinfo,classname,extentsize,selectivity,$$ConvertSelectivity^%ocsExtent(selectivity,extentsize),,,,KeepClassUpToDate)
}

/// Sets the flag that controls whether or not we gather SQL Statistics about each run of a query
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd> 4 values 
/// 		0 - Default, do not generate stats. 
/// 		1 - Generate stats code in all queries. 
/// 		2 - Record stats for just the outer loop of the query. 
/// 		3 - Record stats for all modules of the query.
/// </dl>
/// <p>
/// <b>Returns:</b>
/// <p>
/// <dd>Old Value
/// <p>
ClassMethod SetSQLStats(flag As %Library.Integer = 0) As %Library.Integer
{
	if (flag<0)!(flag>3) s flag=0
	QUIT $$SetSQLStats^%SYS.PTools(flag)
}

/// Sets the flag that controls whether or not this job gather SQL Statistics about each run of a query
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>flag</i>
/// <dd> 5 values 
/// 		-1 - Turn off stats for this job,
/// 		 0 - Default, use the system setting value, 
/// 		 1 - Generate stats code in all queries, 
/// 		 2 - Record stats for just the outer loop of the query, 
/// 		 3 - Record stats for all modules of the query
/// </dl>
/// <p>
/// <b>Returns:</b>
/// <p>
/// <dd>Old Value
/// <p>
ClassMethod SetSQLStatsJob(flag As %Library.Integer = 0) As %Library.Integer
{
	if (flag<-1)!(flag>3) s flag=0
	QUIT $zu(115,12,flag)
}

/// This entrypoint is used to make an SQL Map definition [not] selectable to the SQL Query Optimizer
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>pTablename</i>
/// <dd>Name of the table to check.<br>
/// <i>pTablename</i> can be qualified or unqualified.  If unqualified, the default schema is applied.
/// <dt><i>pMapname</i>
/// <dd>Name of the SQL Map in the table to make selectable or not selectable.<br>
/// <dt><i>pValue</i>
/// <dd>1/0 flag.  1 means make this map Selectable - the SQL Query Optimizer will be able to choose this map.  0 means make this map Not Selectable - the SQL Query Optimizer will NOT be able to consider this map<br>
/// </dl>
/// <p><b>Returns:</b>
/// <ul>1 if the call was successful, Otherwise an error message is returned in a string format.</ul>
/// <p><b>Note:</b><ul>This feature is not useful for extent indices (non bitmap).  When a non-bitmap extent index is defined, the data map projected to SQL will use both the extent index global and the data map global.  
/// When a non-bitmap extent index is added to a table with existing data, the index must be populated before any queries are run against the table.  If not, any queries plans that loop over the data map will return no data.</ul>
/// <ul>This feature sets the selectability for the map in the current namespace only.  If this table is mapped to multiple namespaces, and the index needs to be built in each namespace, SetMapSelectability should be called in each namespace the index is to be built in.</ul>
/// <ul>Also, this feature sets the selectability for the map in the current table only.  If there is a subclass that inherits the index map, and the index is being rebuilt for the entire extent, SetMapSelectability should be called for each table/map in the extent.</ul>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Write $SYSTEM.SQL.SetMapSelectability("Sample.Person","NameIndex",1) // SQL Query Optimizer WILL consider map NameIndex</li>
/// <li>Write $SYSTEM.SQL.SetMapSelectability("Sample.Person","NameIndex",0) // SQL Query Optimizer WILL NOT consider map NameIndex</li>
/// </ul>
/// <p><b>Returns:</b>
ClassMethod SetMapSelectability(pTablename As %Library.String = "", pMapname As %Library.String = "", pValue As %Boolean = "") As %Library.String [ ProcedureBlock = 1 ]
{
	QUIT:pTablename="" "pTablename argument missing"
	QUIT:pMapname="" "pMapname argument missing"
	set tTablename=$$IntQualifiedName^%apiSQL(pTablename)
	QUIT:tTablename="" "Unable to determine Schema.Table from given pTablename value ("_pTablename_")"
	set tSchema=$$$SchemaFromIQN(tTablename)
	QUIT:tSchema="" "Unable to determine Schema name from given pTablename value ("_pTablename_")"
	set tTable=$$$TableFromIQN(tTablename)
	QUIT:tTable="" "Unable to determine Table name from given pTablename value ("_pTablename_")"
	set pMapname=$$$UPPER(pMapname)
	if pValue=0 { set ^oddSQL(tSchema,tTable,"MS",pMapname,$namespace)="" }
	if pValue=1 { kill ^oddSQL(tSchema,tTable,"MS",pMapname,$namespace) }
	QUIT 1
}

/// This entrypoint is used to determine if an SQL Map definition is selectable by the SQL Query Optimizer or not
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>pTablename</i>
/// <dd>Name of the table to check.<br>
/// <i>pTablename</i> can be qualified or unqualified.  If unqualified, the default schema is applied.
/// <dt><i>pMapname</i>
/// <dd>Name of the SQL Map in the table to check the selectable for.<br>
/// </dl>
/// <p><b>Returns:</b>
/// The method returns 1 if the map is selectable.  
/// If the map is not selectable, 0 is returned.
/// If the Selectability of the map cannot be determined, a message string will be returned.
/// <p><b>Note:</b><ul>A return of 1 by this function does not necessarily mean the map exists, just that the map's selectability has not been set to 0.</ul>
/// <ul>Also, this feature checks the selectability for the map in the current namespace only.  
/// If this table is mapped to multiple namespaces, and the index needs to be built in each namespace, SetMapSelectability should be called in each namespace the index is to be built in.  GetMapSelectability should be checked in each namespace the table is mapped to.</ul>
/// </dl>
/// <p><b>Examples</b>:
/// <ul>
/// <li>Write $SYSTEM.SQL.GetMapSelectability("Sample.Person","NameIndex")
/// </ul>
ClassMethod GetMapSelectability(pTablename As %Library.String = "", pMapname As %Library.String = "") As %Library.String [ ProcedureBlock = 1 ]
{
	#dim tSchema,tTable,tTablename As %String
	
	QUIT:pTablename="" "pTablename argument missing"
	QUIT:pMapname="" "pMapname argument missing"
	set tTablename=$$IntQualifiedName^%apiSQL(pTablename)
	QUIT:tTablename="" "Unable to determine Schema.Table from given pTablename value ("_pTablename_")"
	set tSchema=$$$SchemaFromIQN(tTablename)
	QUIT:tSchema="" "Unable to determine Schema name from given pTablename value ("_pTablename_")"
	set tTable=$$$TableFromIQN(tTablename)
	QUIT:tTable="" "Unable to determine Table name from given pTablename value ("_pTablename_")"
	set pMapname=$$$UPPER(pMapname)
	QUIT '$d(^oddSQL(tSchema,tTable,"MS",pMapname,$namespace))	// If global is not defined, map is Selectable
}

/// GrantObjPriv lets you grant an <i>ObjPriv</i> to a <i>User</i> via this call instead of using the SQL GRANT statement
/// <p>
/// $SYSTEM.SQL.GrantObjPriv(<i>ObjPriv</i>,<i>ObjList</i>,<i>Type</i>,<i>User</i>,<i>wGrant</i>)<br>
/// <dl>
///   Paramaters:
/// <p>
/// <dt><i>ObjPriv</i>     	
/// <dd>Comma delimited string of actions to grant. * for all actions:<br>
/// <ul>
/// <li>Alter</li>
/// <li>Select</li>
/// <li>Insert</li>
/// <li>Update</li>
/// <li>Delete</li>
/// <li>References</li>
/// <li>Execute</li>
/// <li>or any combination</li>
/// </ul>
/// <dt><i>ObjList</i>
/// <dd> * for all objects, else a comma delimited list of object names<br>
/// <dt><i>Type</i>
/// <dd> Table, View, or Stored Procedures<br>
/// <dt><i>Users</i>
/// <dd> Comma delimited list of users<br>
/// <dt><i>wGrant</i>
/// <dd> 0/1 for WITH GRANT OPTION<br>
ClassMethod GrantObjPriv(ObjPriv As %String, ObjList As %String, Type As %String, User As %String, wGrant As %Integer = 0) As %Status [ ProcedureBlock = 1 ]
{
	Try {
		TSTART
		
		s Type=$$$UPPER(Type)
		s Type=$S(Type="TABLE":1,Type="VIEW":3,Type="CUBES":4,Type="STORED PROCEDURES":9,1:"")
		i Type="" THROW ##class(%Exception.General).%New("GrantObjPriv Error",-400,,"Invlaid Type")
		
		s ObjPriv=$$$UPPER(ObjPriv)
		s Objs=""
		for i=1:1:$L(ObjPriv,",") {
			s Obj=$P(ObjPriv,",",i) 
			s Objs=Objs_$S(Obj="*":"*",Obj="ALTER":"a",Obj="SELECT":"s",Obj="INSERT":"i",Obj="UPDATE":"u",Obj="DELETE":"d",Obj="REFERENCE":"r",Obj="EXECUTE":"e",1:"")
		}
		i Objs="" THROW ##class(%Exception.General).%New("GrantObjPriv Error",-400,,"Invlid Action")		// did not enter any valid actions
		
		s ObjList=$$$UPPER(ObjList)
		if ObjList'="*" {
			s ObjList=$LISTFROMSTRING(ObjList,",")
			s VObjList=""
			f i=1:1:$LL(ObjList) {
				s Obj=$LG(ObjList,i)
				s schema=$P(Obj,".",1)
				s object=$P(Obj,".",2)
				if Type=1!(Type=3) {
					s:$D(^rINDEXSQL("rv",schema,object)) VObjList=VObjList_$LB($LG(^rINDEXSQL("rv",schema,object),4))
				}
				ELSEIF Type=4 {
					
				}
				ELSEIF Type=9 {
					s:$D(^oddPROC(schema,object)) VObjList=VObjList_$LB(schema_"."_object)
				}
			}
			s ObjList=VObjList
		}
		i ObjList="" THROW ##class(%Exception.General).%New("GrantObjPriv Error",-30,,"No Objects found")		// did not enter any valid objects
		
		s User=$$$UPPER(User)
		s VUsers=""
		f i=1:1:$L(User,",") {
			s user=$P(User,",",i)
			s exists=$$$SecurityUsersExists(user,data)
			s:exists=0 exists=$$$SecurityRolesExists(user,data)
			if exists s VUsers=VUsers_","_user
		}
		s User=$E(VUsers,2,*)_","
		i User="," THROW ##class(%Exception.General).%New("GrantObjPriv Error",-118,,"Invalid User or Role")	
		
		s SQLCODE=100   
	 	d setup^%SYS.SQLSEC(Objs,Type,ObjList,User,wGrant,1)
	 	i SQLCODE<0 { 
	 		THROW ##class(%Exception.General).%New("GrantObjPriv Error",SQLCODE,,"SQL Error Code")
	 		}
	 	ELSE {s status = $$$OK}
	 	TCOMMIT 

	}
	
	Catch err {
		 TROLLBACK 1 
	 	s status=err.AsStatus()
	}
 	QUIT status
}

/// RevokeObjPriv lets you revoke an <i>ObjPriv</i> from a <i>User</i> via this call instead of using the SQL REVOKE statement
/// <p>
/// $SYSTEM.SQL.RevokeObjPriv(<i>ObjPriv</i>,<i>ObjList</i>,<i>Type</i>,<i>User</i>,<i>wGrant</i>,<i>Cascade</i>,<i>AsGrantor</i>)<br>
/// <dl>
///   Paramaters:
/// <p>
/// <dt><i>ObjPriv</i>     	
/// <dd>Comma delimited string of actions to grant. * for all actions:<br>
/// <ul>
/// <li>Alter</li>
/// <li>Select</li>
/// <li>Insert</li>
/// <li>Update</li>
/// <li>Delete</li>
/// <li>References</li>
/// <li>Execute</li>
/// <li>or any combination</li>
/// </ul>
/// <dt><i>ObjList</i>
/// <dd> * for all objects, else a comma delimited list of object names<br>
/// <dt><i>Type</i>
/// <dd> Table, View, or Stored Procedures<br>
/// <dt><i>Users</i>
/// <dd> Comma delimited list of users<br>
/// <dt><i>wGrant</i>
/// <dd> 0/1 for WITH GRANT OPTION<br>
/// <dt><i>Cascade</i>
/// <dd> 0/1 cascade revoke?<br>
/// <dt><i>AsGrantor</i>
/// <dd> Alternate User to remove Privs for. As Grantor can be a user name, a comma-separated list of user names, or "*". <br>
ClassMethod RevokeObjPriv(ObjPriv As %String, ObjList As %String, Type As %String, User As %String, wGrant As %Integer = 0, Cascade As %Integer = 0, AsGrantor As %String = "") As %Status [ ProcedureBlock = 1 ]
{
	Try {
		TSTART
		
		s Type=$$$UPPER(Type)
		s Type=$S(Type="TABLE":1,Type="VIEW":3,Type="CUBES":4,Type="STORED PROCEDURES":9,1:"")
		i Type="" THROW ##class(%Exception.General).%New("RevokeObjPriv Error",-400,,"Invlaid Type")
		
		s ObjPriv=$$$UPPER(ObjPriv)
		s Objs=""
		for i=1:1:$L(ObjPriv,",") {
			s Obj=$P(ObjPriv,",",i) 
			s Objs=Objs_$S(Obj="*":"*",Obj="ALTER":"a",Obj="SELECT":"s",Obj="INSERT":"i",Obj="UPDATE":"u",Obj="DELETE":"d",Obj="REFERENCE":"r",Obj="EXECUTE":"e",1:"")
		}
		i Objs="" THROW ##class(%Exception.General).%New("RevokeObjPriv Error",-400,,"Invlid Action")		// did not enter any valid actions
		
		s ObjList=$$$UPPER(ObjList)
		if ObjList'="*" {
			s ObjList=$LISTFROMSTRING(ObjList,",")
			s VObjList=""
			f i=1:1:$LL(ObjList) {
				s Obj=$LG(ObjList,i)
				s schema=$P(Obj,".",1)
				s object=$P(Obj,".",2)
				if Type=1!(Type=3) {
					s:$D(^rINDEXSQL("rv",schema,object)) VObjList=VObjList_$LB($LG(^rINDEXSQL("rv",schema,object),4))
				}
				ELSEIF Type=4 {
					
				}
				ELSEIF Type=9 {
					if $D(^oddPROC(schema,object)) {
						s exschema=$LG(^oddPROC(schema,object,11),2)
						s exobject=$LG(^oddPROC(schema,object,11),3)
						s VObjList=VObjList_$LB(exschema_"."_exobject)
					}
				}
			}
			s ObjList=VObjList
		}
		i ObjList="" THROW ##class(%Exception.General).%New("RevokeObjPriv Error",-30,,"Table or view not found")		// did not enter any valid Objects
		
		s User=$$$UPPER(User)
		s VUsers=""
		f i=1:1:$L(User,",") {
			s user=$P(User,",",i)
			s exists=$$$SecurityUsersExists(user,data)
			s:exists=0 exists=$$$SecurityRolesExists(user,data)
			if exists s VUsers=VUsers_","_user
		}
		s User=$E(VUsers,2,*)_","
		i User="," THROW ##class(%Exception.General).%New("RevokeObjPriv Error",-118,,"Invalid User or Role")	
		
		s AsGrantor=$S(AsGrantor="*":"*",AsGrantor="":"",1:AsGrantor_",")
		s SQLCODE=0   
	 	d setup1^%SYS.SQLSEC(Objs,Type,ObjList,User,wGrant,Cascade,,,AsGrantor,)
	 	i SQLCODE<0 { 
	 		THROW ##class(%Exception.General).%New("RevokeObjPriv Error",SQLCODE,,"SQL Error Code")
	 		}
	 	ELSE {s status=$$$OK}
	 	TCOMMIT 

	}
	
	Catch err {
		 TROLLBACK 1 
	 	s status=err.AsStatus()
	}
 	QUIT status
}

}
