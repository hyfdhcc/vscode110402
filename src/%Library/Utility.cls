/// Handy utility functions
Class %Library.Utility [ Abstract, System = 4 ]
{

/*
---------------------Documentation------------------------------------
STC2099 06/18/12 Steve Clay, Allow %Library.Utility:Replace() 
                 Start parameter to be passed by reference 
LFT1285 07/14/04 Laura Tillem, add FormatMB() from CFL1104
LFT1197 01/27/04 Laura Tillem, added System=4 setting
LFT1135 10/07/03 Laura Tillem, create this file
-------------------End Documentation----------------------------------
*/
/// Center text on a line
ClassMethod Center(str As %String = "", width As %Integer = 80) As %String
{
	Q $J(str,($L(str)+width)\2)
}

/// Show the date, for example
///  Sep 26 2003
ClassMethod Date(Format As %Integer = 7) As %String
{
 Quit $ZD($H,Format)
}

/// Show date and time, for example:
/// Sep 26 2003  5:39 PM
ClassMethod DateTime(Format As %Integer = 7) As %String
{
 Quit $ZD($H,Format)_" "_..Time()
}

/// Show the time, for example
///  6:33 PM
ClassMethod Time() As %String
{
 S M=$P($H,",",2)\60
 S N=" AM" S:M'<720 M=M-720,N=" PM" S:M<60 M=M+720
 S I=M\600 S:'I I=" "
 S TIM=I_(M\60#10)_":"_(M#60\10)_(M#10)_N
 Quit TIM
}

/// Used for formatting database and global sizes in MB
/// Returns a minimum of two significant digits
ClassMethod FormatMB(val As %Float) As %Float
{
 If val<.1 Quit $j(val,0,3)
 If val<1 Quit $j(val,0,2)
 If val<10 Quit $j(val,0,1)
 Quit $j(val,0,0)
}

/// Searches in Source the occurrences of FindWhat and replaces them with ReplaceWith.<br>
/// The Search will be case insensitive if MatchCase=0 (default = 1).<br>
/// The result of the operation will be placed in OutputString.<br>
/// The method returns the number of times the replacement occurred.<br>
/// You can also specify a starting point for the search (Start) and how many occurrences of<br>
/// FindWhat you want replaced (default: 0 = All).<br>
/// If FindWhat is the empty string, no replacement occurs.
/// StartMode specifies how the Start parameter works.
/// If StartMode=0, Start is a character count like in $Find.
/// If StartMode=1, Start is a FindWhat count. That is, replacing starts at the beginning of the Start-th
/// piece delimited by FindWhat.
/// If Start<0, the find/replace operation works backwards from the end of the string.
/// If Start is passed byref, return value of Start is where next search of the 
/// same line should start from, i.e. 1 character after the last replace.
/// 
ClassMethod Replace(Source As %String = "", FindWhat As %String = "", ReplaceWith As %String = "", MatchCase As %Boolean = 1, ByRef OutputString As %String, Start As %Integer = 1, RepeatCount As %Integer = 0, StartMode As %Integer = 0) As %Integer
{
	If Start<0 {
		Set Source=$Reverse(Source),FindWhat=$Reverse(FindWhat),ReplaceWith=$Reverse(ReplaceWith)
		Set Start=-Start,Reverse=1
	}
	Set Work=Source,OutputString=Source,Count=0
	If Work="" Quit 0
	Set FindLen=$Length(FindWhat),ReplaceLen=$Length(ReplaceWith),DLen=ReplaceLen-FindLen
	If 'FindLen Quit 0
	Set:'MatchCase Work=$Zcvt(Work,"U"),FindWhat=$Zcvt(FindWhat,"U")
	If StartMode=1 {
		Set f=0
		For i=1:1:Start-1 {
			Set f=$Find(Work,FindWhat,f) Quit:'f
		}
		Set Start=f
	}
	For {
		Set Start=$Find(Work,FindWhat,Start) Quit:'Start
		Set StartOut=Count*DLen+Start
		Set $Extract(OutputString,StartOut-FindLen,StartOut-1)=ReplaceWith
		If $Increment(Count)=RepeatCount Quit
	}
	s Start=Start-FindLen+ReplaceLen
	If $Get(Reverse) Set OutputString=$Reverse(OutputString),Start=-Start
	Quit Count
}

}
