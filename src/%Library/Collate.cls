Include %syNLS

/// Datatype to handle validation/display of system collations
Class %Library.Collate Extends %Library.Integer [ System = 2 ]
{

/*
---------------------Documentation------------------------------------
STC1617 06/17/09 Steve Clay, Allow string collations to be entered for database collations
LFT1428 03/29/05 Laura Tillem, add flag bit for old collations
STC666	10/29/04 Steve Clay, Rename/CACHESYS/CACHELIB split
STC467	08/13/03 Steve Clay, Initial version
-------------------End Documentation----------------------------------
*/
/// Return the number of the collation used in local arrays
/// by the current process (e.g. 5)
ClassMethod GetLocalNumber() As %Integer
{
 Return $ZU(23,1)
}

/// Return the name of the collation used in local arrays
/// by the current process (e.g. "Cache standard")
ClassMethod GetLocalName() As %String
{
 Set $ZT="Error"
 Do GetNLSCollations^%SYS.Access(.array,1,1,2)
 Return $G(array($ZU(23,1)),"")
 
Error Set $ZT=""
 Return ""
}

/// Set the collation used by the current process in local arrays<br>
/// col = collation number (e.g. 5)
ClassMethod SetLocalNumber(col As %Integer) As %Status
{
 Set $ZT="Error"
 Do GetNLSCollations^%SYS.Access(.array,1,0,2)
 If '$D(array(col)) Return $$$ERROR($$$GeneralError,"Invalid collation number")
 Do $ZU(23,1,col)
 Return $$$OK

Error Set $ZT=""
 Return $$$ERROR($$$CacheError,$ze)
}

/// Set the collation used by the current process in local arrays<br>
/// col = collation name (e.g. "Cache standard")
ClassMethod SetLocalName(col As %String) As %Status
{
 Set $ZT="Error"
 Do GetNLSCollations^%SYS.Access(.array,1,0,1)
 If '$D(array(col)) Return $$$ERROR($$$GeneralError,"Invalid collation name")
 Do $ZU(23,1,$LI(array(col),3))
 Return $$$OK

Error Set $ZT=""
 Return $$$ERROR($$$CacheError,$ze)
}

/// Convert external collation name or abbreviation to internal number.
/// <br>
/// Flag = 0 - Name to number (default)<br>
/// Flag = 1 - Abbreviation to number<br>
/// Flag = 2 - Name or Abbreviation to number<br>
ClassMethod DisplayToLogical(CollationName As %String, Flag As %Integer = 0) As %Integer [ ServerOnly = 0 ]
{
 s UcCollationName=$zcvt(CollationName,"U")
 s Found=0
 Set Rset = ##class(%ResultSet).%New("%Library.Collate:CollationList")
 d Rset.Execute()
 While (Rset.Next()) {
	i (Flag=0),(UcCollationName=$zcvt(Rset.GetData(1),"U")) s Found=1 q
	i (Flag=1),(UcCollationName=$zcvt(Rset.GetData(2),"U")) s Found=1 q
	i (Flag=2),((UcCollationName=$zcvt(Rset.GetData(1),"U"))!(UcCollationName=$zcvt(Rset.GetData(2),"U"))) s Found=1 q
 }
 i Found q +Rset.GetData(3)
 q -1
}

/// Convert internal collation number to external name or abbreviation.
/// <br>
/// Flag = 0 - Number to name (default)<br>
/// Flag = 1 - Number to abbreviation<br>
/// Flag = 2 - Show Old collations
ClassMethod LogicalToDisplay(CollationNumber As %Integer, Flag As %Integer = 0) As %String [ ServerOnly = 0 ]
{
 i CollationNumber'=+CollationNumber q ""
 s Found=0
 Set Rset = ##class(%ResultSet).%New("%Library.Collate:CollationList")
 i Flag=2 d Rset.Execute(1,1)
 e  d Rset.Execute()
 While (Rset.Next()) {
	i +CollationNumber=+Rset.GetData(3) s Found=1 q
 }
 i Found q $case(Flag=1,0:Rset.GetData(1),1:Rset.GetData(2))
 q ""
}

ClassMethod IsValid(%Val As %CacheString) As %Status [ CodeMode = generator, Internal, ServerOnly = 0 ]
{
 s %code=0
 s %codemode=$$$cMETHCODEMODEEXPRESSION
 s str="('##Class(%Library.Collate).IsValidNumber(%Val))"
 s %code="$case("_str_",0:1,1:$$$ERROR($$$DatatypeValidationFailed,"""_%class_":"_%property_""",%Val))"
	QUIT $$$OK
}

/// Return the System default collation name.
ClassMethod GetSystemDefaultName() As %String
{
 Set $ZT="Error"
 Do GetNLSCollations^%SYS.Access(.array,1,1,2)
 Return $G(array($ZU(23,0)),"Cache standard")
 
Error Set $ZT=""
 Return "Cache standard"
}

/// Return the System default collation number.
ClassMethod GetSystemDefaultNumber() As %String
{
 Return $ZU(23,0)
}

/// Verifies that the collation name is valid, and loaded
/// <br>
/// Flag = 0 - Validate name (default)<br>
/// Flag = 1 - Validate abbreviation<br>
/// Flag = 2 - Validate name or abbreviation<br>
/// Loaded = 0 - Don't validate the table is loaded<br>
/// Loaded = 1 - Validate the table is loaded
ClassMethod IsValidName(CollationName As %String, Flag As %Integer = 0, Loaded As %Boolean = 1) As %Boolean [ Internal ]
{
 Set Uname=$zcvt(CollationName,"U")
 Do GetNLSCollations^%SYS.Access(.array,1,0,1)
 Set name=$O(array(""),1,node),valid=0
 If Flag=0 {       // Name
 	While (name'="") {
		If Uname=$zcvt(name,"U") Set valid=1 Quit
		Set name=$O(array(name),1,node)
 	}
 } ElseIf Flag=1 { // Abbreviation
 	While (name'="") {
		If (Uname=$zcvt($LI(node,2),"U")) Set valid=1 Quit
		Set name=$O(array(name),1,node)
 	}
 } ElseIf Flag=2 { // Name or abbreviation
 	While (name'="") {
		If (Uname=$zcvt(name,"U"))||(Uname=$zcvt($LI(node,2),"U")) Set valid=1 Quit
		Set name=$O(array(name),1,node)
 	}
 }
 If valid,("Built-in,Available"'[$LI(node,4)) Set valid=0
 Quit valid
}

/// Verifies that the collation number is valid.
/// <br>
/// Loaded = 0 - Don't validate the table is loaded<br>
/// Loaded = 1 - Validate the table is loaded
ClassMethod IsValidNumber(CollationNumber As %Integer, Loaded As %Boolean = 1) As %Boolean [ Internal ]
{
 Set number=+CollationNumber
 If number'=CollationNumber Quit 0
 Do GetNLSCollations^%SYS.Access(.array,1,0,0)
 If '$D(array(number),status) Quit 0
 If Loaded,'status Quit 0
 Quit 1
}

/// Creates an array with the desired collations<br>
/// Helper method used by other methods and ^COLLATE<br>
///   Parameters:<ul>
///    <li>Array = Name of the array</li>
///    <li>IsLoaded = 0: all collations, 1: only loaded collations</li>
///    <li>OldCollations = 0: only new collations, 1: include old collations</li>
///    <li>Format=0: Array(num)="status;num;name"</li>
///    <li>Format=1: Array(name)=$LB(name,abbrv,num,status)</li>
///    <li>Format=2: Array(num)="name"</li></ul>
ClassMethod MakeArray(ByRef Array As %Binary, IsLoaded As %Boolean = 1, OldCollations As %Boolean = 0, Format As %Integer = 1) As %Status [ Internal ]
{
 Set $ZT="Error"
 Do GetNLSCollations^%SYS.Access(.Array,IsLoaded,OldCollations,Format)
 Quit $$$OK
 
Error Set $ZT=""
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Returns a list of the Cache collations
/// <br>
/// Pass IsLoaded=1 to only return loaded collations
Query CollationList(IsLoaded As %Boolean, OldCollations As %Boolean) As %Query(ROWSPEC = "Name:%String,Abbreviation:%String,Number:%Integer,Status:%String") [ Internal ]
{
}

ClassMethod CollationListExecute(ByRef qHandle As %Binary, IsLoaded As %Boolean = 1, OldCollations As %Boolean = 0) As %Status [ Internal ]
{
 Set $ZT="Error"
 Do GetNLSCollations^%SYS.Access(.qHandle,IsLoaded,OldCollations,1)
 Set qHandle="^"
 Quit $$$OK

Error Set $ZT=""
 Quit $$$ERROR($$$CacheError,$ze)
}

ClassMethod CollationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
 s $zt="Error"
 s Name=$p(qHandle,"^",1)
 s Name=$o(qHandle(Name),1,Row)
 i Name="" s AtEnd=1
 s qHandle=Name_"^"
 Quit $$$OK
Error s $zt=""
 Quit $$$ERROR($$$CacheError,$ze)
}

ClassMethod CollationListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = CollationListExecute ]
{
 Quit $$$OK
}

}
