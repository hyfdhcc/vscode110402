Include %msql

IncludeGenerator %msql

/// This class implements expression generators for the all Cache' collations.
/// 
/// <p>A collation expression is used by code generators to tranform logical data values into 
/// values used by indices.
/// <p>For example, you may wish that a query by name finds 
/// the same results for both "ELVIS" and "elvis". Using a case-insensitive 
/// index transformation, such as String, will accomplish this. If you want an exact 
/// match, use Exact.
/// 
/// <p>Collations are specified via a property's <var>COLLATION</var> parameter. Every datatype 
/// has a default <var>COLLATION</var> value, which matches one of the methods of the 
/// <nobr><b>%Collation</b></nobr> class. 
/// The <var>COLLATION</var> parameter can be overwritten by an individual property or by 
/// a specific index definition.
/// 
/// <p>Note that changing a property's <var>COLLATION</var> value will corrupt any index values 
/// currently stored for that property and will require you to manually repopulate the 
/// index.
Class %Library.CollationGenerator [ Not ProcedureBlock, System = 2 ]
{

/// This method generates the appropriate collation expression as requested by the parameters.
/// 
/// collation = 
/// <p><b>AlphaUp</b>	Converts a logical value to upper case, strips all punctuation and white space (except for ',' and '?').
/// <p>This method is included for compatability with earlier products; use <b>String</b> instead.
/// 
/// <p><b>Exact</b>	Performs no transformation; the index value is exactly the logical value.
/// 
/// <p><b>Minus</b>	Prepends a minus ('-') sign to the logical value.
/// <p>This method is included for compatability with earlier products; you should not 
/// need it in new applications.
/// 
/// <p><b>MVR</b>	MULTI VALUE Collation
/// 
/// <p><b>Plus</b>	Prepends a plus ('+') sign to the logical value.
/// <p>This method is included for compatability with earlier products; you should not 
/// need it in new applications.
/// 
/// <p><b>Space</b>	Prepends a space (' ') character to the logical value.
/// <p>This method is included for compatability with earlier products; you should not 
/// need it in new applications.
/// 
/// <p><b>SqlString</b>	Prepends a space to force string collation and strips trailing whitespace.
/// <p>This method is used to insure that strings are collated case-sensitively and that numeric 
/// string values are collated correctly.
/// 
/// <p><b>SqlUpper</b>	Converts a logical value to upper case, strips trailing whitespace and prepends a space to force string collation.
/// <p>This collation is used to insure that strings are collated case-insensitively and that numeric 
/// string values are collated correctly.
/// 
/// <p><b>String</b>	Converts a logical value to upper case, strips all punctuation and white space 
/// (except for ',').
/// 
/// <p><b>Truncate</b>	Performs no transformation; the index value is exactly the logical value.  However, the value will be truncated to
/// the length specified by the optional length argument.  Truncate with no length is the same as Exact.
/// 
/// <p><b>Upper</b>	Converts a logical value to upper case without removing any characters.
/// 
/// <p>%val	the expression being collated
/// <p>parms	collation parameters as expected by collation
ClassMethod CollationExpression(collation As %String = "", %val As %String, parms As %String) As %String
{
 Set collation = $zcvt(collation,"U")
 If collation = "SQLUPPER" Quit $$$SQLUPPERTCodeGen(%val,$s($g(parms)="":32768,1:parms))
 If collation = "ALPHAUP" Quit $$$ALPHAUPCodeGen(%val)
 If collation = "UPPER" Quit $$$UPPERCodeGen(%val)
 If collation = "SQLSTRING" Quit $$$SQLSTRINGTCodeGen(%val,$s($g(parms)="":32768,1:parms))
 If collation = "STRING" Quit $$$STRINGTCodeGen(%val,$s($g(parms)="":32768,1:parms))
 If collation = "MVR" Quit $$$MVRCodeGen(%val)
 If collation = "TRUNCATE" Quit $$$TRUNCATETCodeGen(%val,$s($g(parms)="":32768,1:parms))
 If collation = "EXACT" Quit %val
 If collation = "PLUS" Quit "+"_%val
 If collation = "SPACE" Quit """ ""_"_%val
 If collation = "MINUS" Quit "-"_%val
}

ClassMethod IsValid(collation As %CacheString = "") [ CodeMode = expression ]
{
(''$Find("|SQLUPPER|ALPHAUP|EXACT|UPPER|SQLSTRING|STRING|PLUS|SPACE|MINUS|MVR|TRUNCATE||","|"_$$$ucase($Piece(collation,"(",1))_"|"))&&((collation'["(")||($Find("|SQLUPPER|SQLSTRING|STRING|TRUNCATE|","|"_$$$ucase($Piece(collation,"(",1))_"|")))
}

ClassMethod Nulls(collation As %String = "") As %Boolean
{
	Set collation = $zcvt(collation,"U")
	If collation = "SQLUPPER" Quit 0
	If collation = "ALPHAUP" Quit 1
	If collation = "UPPER" Quit 1
	If collation = "MVR" Quit 0
	If collation = "SQLSTRING" Quit 0
	If collation = "STRING" Quit 0
	If collation = "EXACT" Quit 1
	If collation = "PLUS" Quit 0
	If collation = "SPACE" Quit 0
	If collation = "MINUS" Quit 0
	If collation = "TRUNCATE" Quit 1
	Quit 1
}

}
