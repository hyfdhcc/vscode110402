Class %iKnow.Compiler.LexrepIdeographicStateOutputFunction Extends %iKnow.Compiler.LexrepStateOutputFunc
{

// 

// Hiragana (u3040-u309F)                    http://unicode.org/charts/PDF/U3040.pdf

// Katakana (u30A0-u30FF)				      http://unicode.org/charts/PDF/U30A0.pdf

// CJK Unified Ideographs (u4E00-u9FCF)      http://www.unicode.org/charts/PDF/U4E00.pdf

// CJK Symbols and Punctuation (u3000-u303F) http://unicode.org/charts/PDF/U3000.pdf

// Halfwidth & Fullwidth forms (uFF00-uFFEF) http://unicode.org/charts/PDF/UFF00.pdf

// 

Method IsKatakanaWord(word As %String) As %Boolean
{
	For cnt=1:1:$Length(word) {
		If '..IsKatakana($Extract(word,cnt)) { Return 0 }
	}
	Return 1
}

Method IsKatakana(token As %Char) As %Boolean
{
 Quit:(($Ascii(token)'<$ZHEX("30A0")) & ($Ascii(token)'>$ZHEX("30FF"))) 1
 Quit 0
}

Method IsJapanese(token As %Char) As %Boolean
{
	Quit:(($Ascii(token)'<$ZHEX("3040")) & ($Ascii(token)'>$ZHEX("309F"))) 1 // Hiragana
	Quit:(($Ascii(token)'<$ZHEX("309F")) & ($Ascii(token)'>$ZHEX("30FF"))) 1 
	Quit:(($Ascii(token)'<$ZHEX("4E00")) & ($Ascii(token)'>$ZHEX("9FCF"))) 1 
	Quit:(($Ascii(token)'<$ZHEX("3000")) & ($Ascii(token)'>$ZHEX("303F"))) 1 // CJK Symbols and Punctuation (u3000-u303F)
	Quit:(($Ascii(token)'<$ZHEX("FF00")) & ($Ascii(token)'>$ZHEX("FFEF"))) 1 // Half width & Full width forms
	Quit 0
}

Method IsNumeric(token As %Char) As %Boolean
{
	Quit:(($Ascii(token)'<$ZHEX("0030")) & ($Ascii(token)'>$ZHEX("0039"))) 1 // '0' to '9'
	Quit 0
}

Method CountWithNumeric(word As %String) As %Integer
{
	Set bInNumeric=0
	Set cntNumeric=0
	Set cntNonNumeric=0
	For cnt=1:1:$Length(word) {
		If ..IsNumeric($extract(word,cnt)) { 
		  If bInNumeric=0 Set cntNumeric = cntNumeric + 1
		  Set bInNumeric=1
		} Else {
		    Set bInNumeric=0
		    Set cntNonNumeric = cntNonNumeric + 1
		}
	}
	Return (cntNumeric+cntNonNumeric)
}

Method GetValue(value As %String) As %String
{
	// Throw:$Length(value," ")>1 ##class(%Exception.General).%New("Lexreps for Japanese cannot contain space characters")
	Set wordCount = ..CountWithNumeric(value)		
	If (wordCount > ..MaxWordCount) Set ..MaxWordCount = wordCount
	Quit $LB(wordCount, ..Labels, value, ..LabelString)
}

}
