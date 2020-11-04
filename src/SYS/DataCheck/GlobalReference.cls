Include %syDataCheck

/// Datatype for global node names used in DataCheck. Only to be used in the context
/// of DataCheck.
/// <p>
/// Valid global references contain no extended reference, no naked references, and only literal subscripts. 
/// In their normalized form they include a leading ^.  Consumers should check validity and normalize
/// (via <METHOD>Normalize</METHOD> or by validating the class which has this datatype as a property)
/// before using the reference.
/// <p>
/// Null is a valid global reference for DataCheck and represents the end of the universe of possible subscripts
/// for any global.  In other words, "" collates after any other valid global reference.
/// <p>
/// Null appearing as a subscript is valid and represents the beginning of the range of the subscript level
/// in which it appears.  In other words, ^X(123,"") collates before ^X(123, followed by any other subscripts).
/// 
Class SYS.DataCheck.GlobalReference Extends %Binary
{

/// Returns true if the global reference in 'key1' collates after the global
/// reference in 'key2' in collation 'col', otherwise returns false
ClassMethod CollatesAfter(key1 As GlobalReference, key2 As GlobalReference, col As %Integer = 5, alreadynormalized As %Boolean = 0) As %Boolean [ Internal ]
{
	i 'alreadynormalized { s key1=..Normalize(key1),key2=..Normalize(key2) }
	i key1=key2 { q 0 }
	i (key1="") && (key2'="") { q 1 }
	i key2="" { q 0 }
	#; Make sure the global names or the same, otherwise throw an error
	i $qs(key1,0)'=$qs(key2,0) zt "GNAM"
	#; Get the encoding rule
	s rule=$zu(70,1,col)
	#; Get the number of subscripts of both 
	s ql1=$ql(key1),ql2=$ql(key2)
	#; For each subscipt that both keys have, convert to encoded form
	#; and then do string comparisons to find the collation order
	s minql=$s(ql1<ql2:ql1,1:ql2)
	f i=1:1:minql {
		s sub1=$qs(key1,i),sub2=$qs(key2,i)
		i sub1'=sub2 {
			#; subscripts are not equal, so convert to encoded
			s enc1=$zu(70,2,sub1,rule),enc2=$zu(70,2,sub2,rule)
			i enc1]enc2 { g q1 }
			#; Here'e we know that unencoded form was not equal
			#; and that enc1 does not follow enc2 so we could
			#; simply assume that enc2 follows enc1.  However
			#; there may be obscure collations where different
			#; strings encode to the same value so instead
			#; we'll check explicitly if enc2 follows enc1 
			elseif enc2]enc1 { g q0 }
		}
		#; these subscripts are the same, continue to next subscript
	}
	#; The subscripts have matched up to the end of one key.
	#; If key1 has more subscripts then it collates after key2
	q $s(ql1>ql2:1,1:0)
q0	q 0
q1  q 1
}

/// Validates and normalizes the global reference specified by 'key', returning it without any 
/// subscripts, and returning the full global reference in the 'normalized' argument.
ClassMethod GlobalName(key As GlobalReference, Output normalized As GlobalReference) As GlobalReference [ Internal ]
{
	i '$l(key) q ""
	s normalized=..Normalize(key)
	q $qs(normalized,0)
}

/// Returns the encoded form of the global reference
ClassMethod Encode(ref As GlobalReference, col As %Integer = 5, alreadynormalized As %Boolean = 0) As %String [ Internal ]
{
	i 'alreadynormalized { s ref=..Normalize(ref) }
	i ref="" { q "" }
	#; Get the encoding rule
	s rule=$zu(70,1,col)
	s enc=$e($qs(ref,0),2,*)
	f i=1:1:$ql(ref) { s enc=enc_$c(0)_$zu(70,2,$qs(ref,i),rule) }
	q enc
}

/// Returns the non-null global reference, including the "^", passed though $name,
/// or null if the global reference is null.  This method will validate the global reference
/// and throw an error if the global reference is invalid.  You may use <METHOD>IsValid</METHOD>
/// with the 'normalized' output parameter avoid errors. 
ClassMethod Normalize(%val As GlobalReference) As GlobalReference
{
	if %val="" { quit "" }
	if $extract(%val)'="^" { set %val="^"_%val }
	#; $qsubscript throws <FUNCTION> if global reference doesn't parse,
	#; is a naked reference, or if it contains non-literals. Test this
	#; first so we don't pass non-literals to indirection. Also don't
	#; accept extended references.
	if $qsubscript(%val,-1)'="" { ztrap "EXRF" }
	quit $name(@%val) ; $name truncates if global name is too long, and normalizes everything
}

/// Returns $$$OK if the global reference in '%val' is valid, or an error status if invalid.
/// If valid, the normalized value is returned by reference in the 'normalized' parameter.  
/// Note that a global reference which
/// passes this test, although syntactically valid, may not actually be usable 
/// depending on the changeable state of the system.  For example, upon using a 
/// valid global reference in a database operation, one may still encounter errors
/// like <SUBSCRIPT> if the collation of the global does not allow a particular
/// subscript, or if it contains a null subscript and null subscript support is 
/// turned off.
ClassMethod IsValid(%val As GlobalReference, Output normalized As GlobalReference) As %Status
{
	try { s normalized=##class(SYS.DataCheck.GlobalReference).Normalize(%val),ret=$$$OK }
	catch err { 
		s ret=$$$ERROR($$$DCGlobalReferenceInvalid)
		s ret=$$$EMBEDSC(ret,err.AsStatus())
	}
	q ret
}

/// Quotes subscripts for display purposes and converts "" to an end-of-global marker for display purposes
/// 
ClassMethod LogicalToDisplay(%val As GlobalReference) As %String
{
	i '##class(SYS.DataCheck.GlobalReference).IsValid(%val,.norm) { q "<ILLEGAL VALUE>" }
	i norm="" { q "[end]" }
	q ##class(%Global).Quote(norm,1)
}

/// Converts from quoted display form back to normalized GlobalReference format, or -1 on error
/// 
ClassMethod DisplayToLogical(%val As %Binary) As GlobalReference
{
	#; Null is a valid global reference for our purposes (means end of range)
	i (%val="") || (%val="[end]") q "" 
	#; pass non-null values to %Library.Global::Unquote().  Unquote() returns
	#; null on error (like invalid string).  If we get a null return from 
	#; unquote, we need to return an invalid global reference.  We choose
	#; -1 because its printable and obviously invalid.  Classes that try 
	#; to store this as a property will fail to validate because it won't
	#; pass the IsValid() test in this datatype class.
	s unquoted=##class(%Global).Unquote(%val,1) i unquoted="" q -1
	i ##class(SYS.DataCheck.GlobalReference).IsValid(unquoted,.normalized) {
		q normalized
	} else { q -1 }
}

/// Global References are not limited by number of characters, but by the length of their encoded representation
Parameter MAXLEN As INTEGER;

}
