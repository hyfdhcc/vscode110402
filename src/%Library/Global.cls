Include Wserver

Class %Library.Global [ Abstract, System = 4 ]
{

/*
---------------------Documentation------------------------------------
SML2000  1/16/15 Simon Li, Fix restoring current device for %Global.Import() and %Global.Export() methods.
SML1835  3/03/14 Simon Li,Preserve current device for %Global.Import() and %Global.Export() methods.
SML1791 10/21/13 Simon Li,Fix %Global.Export() to return all mapped globals in Skipped list for block format.
STC2242 09/03/13 Steve Clay, Update global edit to properly retrieve protections on globals selected for edit
SML1706 05/22/13 Simon Li,Fix %Global.Export() to return subscriped name in Skipped list for block format.
STC2028 12/20/11 Steve Clay, Make ZW and ^%r $bit displays agree with Studio display
JO2453	 8/10/11 Jeffrey Orlin, update documentation for .Export and .Import
                 methods. Add code to .Import() to strip leading "^" and trailing
                 .gbl off the global names in the GlobalList argument. This
       			 allows the same list to be used for export and import. The
       			 .gbl probably comes from $SYSTEM.OBJ.Export which uses the trailing
       			 type to identify what is being exported.
SML1324 03/17/11 Simon Li,Preserve local variables for %Global.Export() and %Global.Import() methods.
CFL1607 01/27/11 Carlos Lopes, fix CFL1567
SML1265 12/01/10 Simon Li, Replace ^CacheTemp with private global in system query codes.
JO2366  11/17/10 Jeffrey Orlin, don't require global names in export list to
                 contain ".gbl"
CFL1567 07/22/10 Carlos Lopes, Export returns a list of skipped globals in $$$goISMBLK mode.
CDS1535 03/30/09 Chuck Sorenson, truncate long $BIT() formatting
CDS1197 10/12/07 Chuck Sorenson, use $LISTVALID()
SML893  06/15/07 Simon Li, fix Find to handle UNICODE string in $list format.
CFL1476 11/17/06 Carlos Lopes, fix Find to not include the namespace in the search.
STC1048 08/16/06 Steve Clay, Fix display of global data 
STC1011 06/14/06 Steve Clay, Add permissions column to Get query. Reorganize.
SML665  12/16/05 Simon Li, Fix ListDump() to truncate overflow instead of return "".
CFL1396 10/31/05 Carlos Lopes, fix loop in %Global.Get()
CFL1395 10/19/05 Carlos Lopes, fixed Quote() for non-canonic numbers
LRS969  09/13/05 Lee smith, revised $$$ERROR codes
CFL1380 09/09/05 Carlos Lopes, allow passing in the translation to be used
                 in Export().
SML618  07/21/05 Simon Li, Handle global data could overflow the $LB() list.
CFL1327 05/23/05 Carlos Lopes, Export takes an array of globals
SML560  04/28/05 Simon Li, For Export, add ^ to global name if it does not have it.
CFL1305 04/19/05 Carlos Lopes, add error traps
CFL1256 02/17/05 Carlos Lopes, fix methods for implied namespaces
CFL1250 02/16/05 Carlos Lopes, Fix %Global:Get (Quote)
LFT1395 01/31/05 Laura Tillem, allow ^ in NewName in Import()
CFL1224 01/13/05 Carlos Lopes, fix Export
LFT1349 12/15/04 Laura Tillem, allow rename on stream gif import
LFT1322 11/08/04 Laura Tillem, replace ^%utility($j) with ^CacheTempJ($j)
PWC923  11/03/04 Peter Cudhea, Created %Library.Function, %Library.Utility,
                 and %Sys.System classes.
CFL1163 10/27/04 Carlos Lopes, rename %Wgr and %Wgs
CFL1131 08/20/04 Carlos Lopes, localize messages
CFL1130 08/20/04 Carlos Lopes, add flags
CFL1125 08/18/04 Carlos Lopes, add Export/Import methods
CFL1113 07/26/04 Carlos Lopes, make Get query work like standard queries
CFL1111 07/22/04 Carlos Lopes, remove 12KB limit from Get query
CFL1100 07/16/04 Carlos Lopes, add Get method, add Namespace parameter to
                 Find query.
CFL1107 07/14/04 Carlos Lopes, add Quote and Unquote class methods
CFL1096 07/07/04 Carlos Lopes, add Find query.
-------------------End Documentation----------------------------------
*/
ClassMethod DoubleInnerQuotes(str As %String, ByRef ov As %Boolean) As %String [ Internal ]
{
	Try {
		Set str=$replace(str,"""","""""")
	} Catch {
		Set ov=1
	}
	Quit str
}

ClassMethod Eval(x) As %String [ Internal, ProcedureBlock = 0 ]
{
	New y Set @("y="_x) Quit y
}

/// Exports a list of globals <var>GlobalList</var> from a namespace <var>Nsp</var> to <var>FileName</var> using <var>OutputFormat</var> and <var>RecordFormat</var>.<br>
/// <br><var>GlobalList</var> is a comma delimited string or a local array,
/// containing the names of the globals
/// to export. A leading ^ and trailing type of .gbl on each global name are optional.
/// <br><br>
/// Cache Block Format (%GOF - type 7) cannot be used to export subscript mapped globals
/// or globals which are mapped to a database other than the default global database 
/// of the namespace. If a mapped global is included in the <var>GlobalList</var>, it will be dropped
/// and a message that it well be skipped is displayed. Use ISM/Cache format to export mapped globals.
/// <br><br>
/// <var>OutputFormat</var> has the following values:<br>
/// <li>1 - DTM format</li>
/// <li>3 - VAXDSM format</li>
/// <li>4 - DSM11 format</li>
/// <li>5 - ISM/Cache format</li>
/// <li>6 - MSM format</li>
/// <li>7 - Cache Block format (%GOF)</li><br>
/// <var>RecordFormat</var> has the following values:<br>
/// <li>V - Variable Length Records</li>
/// <li>S - Stream Data</li>
ClassMethod Export(Nsp As %String = {$zu(5)}, ByRef GlobalList As %String, FileName As %String, OutputFormat As %Integer = 5, RecordFormat As %String = "V", qspec As %String = "d", Translation As %String = "<Device Default>", ByRef Skipped As %String) As %Status [ PublicList = (G, IOT, blkcnt, blocks, write, %UI) ]
{
#define DBG 0
	Set $ZT = "Trap"
	#;SML1324 ; make sure they don't get updates by %SYS.Wgs.
	New G,IOT,blkcnt,blocks,write,%UI
	#;SML1835 ; Save current device.
	s OldCurDev=$I
	If OutputFormat = $$$goISMBLK {  // Cache Block Format
		Set sdev = FileName _ ":(""UNW*"")"
	} Else {
		Set sdev = FileName _ ..GetOpenParms(1, RecordFormat="V", Translation)
	}
	Set sc=$$$qualifierParse("Compiler",.qspec,.qstruct) Quit:$$$ISERR(sc) sc
	Set display=$$$qualifierGetValue(qstruct,"displaylog")
	Set OldNsp=$zu(5) ZN:Nsp'=OldNsp Nsp
	Kill ^CacheTempJ($j)
	If $d(GlobalList)>=10 {
		Set sc=$$$OK,tItem="",nG=0
		For tInd=1:1 {
			Set tItem=$o(GlobalList(tItem)) Quit:tItem=""
			Set len=$l(tItem,"."),ext=$zcvt($p(tItem,".",len),"l")
			#;JO2366+
			If len>=2,(ext="gbl") {
				; There can be .'s embedded in the global name. If the
				; name ends with .gbl then this is the old type which
				; was required for globals to be exported so we drop it.
				; Otherwise we use the name the user provided
				s len=len-1
			}
			s glo=$p(tItem,".",1,len)
			#;JO2366-
			s:$e(glo)'="^" glo="^"_glo
			Set ^CacheTempJ($j,tInd)=glo,nG=nG+1
		}
	} Else {
		Set nG=$l(GlobalList,","),sc=$$$OK
		For tInd=1:1:nG {
			Set tItem=$p(GlobalList,",",tInd) Quit:tItem=""
			Set len=$l(tItem,"."),ext=$zcvt($p(tItem,".",len),"l")
			#;JO2366+
			If len>=2,(ext="gbl") {
				; There can be .'s embedded in the global name. If the
				; name ends with .gbl then this is the old type which
				; was required for globals to be exported so we drop it.
				; Otherwise we use the name the user provided
				s len=len-1
			}
			s glo=$p(tItem,".",1,len)
			#;JO2366-
			s:$e(glo)'="^" glo="^"_glo
			Set ^CacheTempJ($j,tInd)=glo
		}
	}
	If OutputFormat = $$$goISMBLK {  // Cache Block Format
		If $d(Skipped) Kill Skipped Set Skipped=0
		Kill SkNames,mapglb
		Set CurNsp=$ZU(5)
		#;SML1791+
		Set NsInfo=$zu(90,21,CurNsp)
		Set defdb=$p(NsInfo,"^",2,3),SkipAll=($p(NsInfo,"^",2)'="")
		#;Set rc=$$GetGlobalMappings^%SYS.CONFIG(CurNsp,.mapglb)
		#;SML1791-
		Set tInd="" For {
			Set tInd=$o(^CacheTempJ($j,tInd)) Quit:tInd=""
			#;SML1706+ ;Always skip the subscripted global and put it in the Skippped list.
			Set g=^(tInd) Write:$$$DBG !,"Global: ",g  ;If $p(g,"(",2)]"" Kill ^(tInd) Continue
			Write:$$$DBG !,"List: ",g Set g=$e(g,2,*) Write:$$$DBG !,"Lis2: ",g
			#;SML1791+
			#;If $p(g,"(",2)]"" || $d(mapglb(g)) {
			If SkipAll || ($p(g,"(",2)]"") || (defdb'=$p($zu(90,21,CurNsp,g),"^",2,3)) {
			#;SML1791-
			#;SML1706-
				Kill ^(tInd)
				If $d(Skipped),'$d(SkNames(g)) {
					Set SkNames(g)="",Skipped($i(Skipped))=g
					Write:$$$DBG !,"Skipped: ",g
				}
				Continue
			}
		}
	}
	#;SML2000 ; swithc back to original current device when failed.
	If $$$ISERR(sc) Use OldCurDev Quit sc
	Set %UI="CHUI",RM=80,all=0,gui=2
	Set header="Export of "_nG_" global"_$s(nG=1:"",1:"s")_" from Namespace "_Nsp
	If display {
		Use 0 Write !,$$$GetSimpleMessage("%Compiler","ExportGOStart")_$zdt($horolog)
	}
	Set tSC=$$main^%SYS.Wgs(sdev,OutputFormat,header,all,gui,display)
	Kill ^CacheTempJ($j)
	If OldNsp'=Nsp ZN OldNsp
	If '+tSC Set sc=$$$ERROR($$$UnexpectedError,$P(tSC,$$$del1,2))
	If '$$$ISERR(sc),display Use 0 Write !,$$$GetSimpleMessage("%Compiler","ExportOk"),!
	#;SML2000 ; restore current device.
	Use OldCurDev
	Quit sc
Trap
	Set $ZT="" If $g(OldNsp),OldNsp'=Nsp ZN OldNsp
	#;SML1835 ; restore current device.
	If $d(OldCurDev) Use OldCurDev
	Set sc=$$$ERROR($$$CacheError,$ze) Quit sc
}

ClassMethod GetFileFormat(FileName As %String, ByRef Format As %String, ByRef RecordFormat As %String, DefaultFormat As %String = "5", DefaultRecordFormat As %String = "V") As %Boolean [ Internal ]
{
	Set Format=$$filefmt^%SYS.Wgr(FileName)
	Set FormatInHeader=(Format]"")
	Set RecordFormat=$p(Format,".",2)
	Set Format=$p(Format,".")
	Set:Format="" Format=DefaultFormat
	Set:RecordFormat="" RecordFormat=DefaultRecordFormat
	Quit FormatInHeader
}

ClassMethod GetFileHeader(ByRef Header As %String, ByRef GblList As %List, FileName As %String, InputFormat As %Integer = 5, VariableLength As %Integer = 1) As %Status [ Internal ]
{
	Set $zt="ERROR"
	If InputFormat=$$$goISMBLK {
		Set parms=":(""UR"")"
	} Else {
		Set parms=..GetOpenParms(0,VariableLength,,InputFormat)
	}
	Set dev=FileName_parms
	Set Header=$$header^%SYS.Wgr(dev,InputFormat,2,.sc)
	Set GblList=..GetGlobalList(Header),Header=$p(Header,$$$del1)
	Quit sc
ERROR Set $zt="" Close:$d(dev) dev
	Set sc=$$$ERROR($$$CacheError,$ze) Quit sc
}

ClassMethod GetGlobalList(Header As %String) As %List [ Internal ]
{
	Set l2=$l($$$del2)
	Set lst=$p(Header,$$$del1,2),GblList=""
	Set:$e(lst,1,l2)'=$$$del2 lst=$$$del2_lst
	For i=2:1:$l(lst,$$$del2) {
		Set g=$p(lst,$$$del2,i)
		Set:g]"" GblList=GblList_$lb(g)
	}
	Quit GblList
}

///  Construct file Open parameters
///  bWrite = open file for write access
///  bVariable = read/write Variablelength/Stream record (True="V"\False="S")
///  sEncoding = character encoding for \k???\ syntax
/// 
///  Return parameters string
ClassMethod GetOpenParms(Write As %Boolean, Variable As %Boolean = 1, Encoding As %String = "", Format As %Integer = 5) As %String [ Internal ]
{
	If Format=$$$goISMBLK Quit ":(""U"_$s(Write:"W",1:"R")_""")"
    Set Return=""
    If Encoding]"",Encoding'="<Device Default>" Set Return="k\"_Encoding_"\"
    Set Return=Return_$s(Variable:"V",1:"S")
    Set Return=$s(Write:"WN",1:"R")_Return
    Quit ":("""_Return_""")"
}

/// Imports a list of globals <var>GlobalList</var> from <var>FileName</var> into namespace <var>Nsp</var> assuming the file was written in <var>InputFormat</var> with record format of <var>VariableLength</var>.<br>
/// <br>
/// The Import method attempts to detect the file format from its header. If this fails, then the format parameters passed in are used.<br>
/// <br><var>GlobalList</var> is &quot*&quot to import all globals or it should contain
/// a comma delimited string containing the names of the specific globals
/// to import. A leading ^ and trailing type of .gbl around each name are optional.
/// <br><br><var>GlobalList</var> is ignored for non Cache Block Format (%GOF) - Type #7 - files.
/// <br><br><var>NewName</var> is used to specify a new name for the global being imported.
/// The input file must be type #7 (%GOF - Cache Block Format) and the file must contain only
/// a single global.
/// <br><br>
/// <var>InputFormat</var> has the following values:<br>
/// <li>1 - DTM format</li>
/// <li>3 - VAXDSM format</li>
/// <li>4 - DSM11 format</li>
/// <li>5 - ISM/Cache format</li>
/// <li>6 - MSM format</li>
/// <li>7 - Cache Block format (%GOF)</li><br>
/// <var>RecordFormat</var> has the following values:<br>
/// <li>V - Variable Length Records</li>
/// <li>S - Stream Data</li>
ClassMethod Import(Nsp As %String = {$zu(5)}, GlobalList As %String, FileName As %String, InputFormat As %Integer = 5, VariableLength As %Integer = 1, NewName As %String = "") As %Status [ PublicList = (RMSMAXLEN, blkcnt, blocks, endian, version, vol, write, %UI, %gifmsg) ]
{
	Set $zt="Trap"
	#;SML1324 ; make sure they don't get updates by %SYS.Wgr.
	New RMSMAXLEN, blkcnt, blocks, endian, version, vol, write, %UI, %gifmsg
	#;SML1835 ; Save current device.
	s OldCurDev=$I
	Set FormatInHeader=..GetFileFormat(FileName,.Format,.RecordFormat,"5",$s(VariableLength:"V",1:"S"))
	Set sc=..GetFileHeader(.Header,.GblList,FileName,Format,RecordFormat="V")
	#;SML2000 ; swithc back to original current device when failed.
	If $$$ISERR(sc) Use OldCurDev Quit sc
	Set OldNsp=$zu(5) If OldNsp'=Nsp ZN Nsp
	Kill ^CacheTempJ($j)
	If GlobalList'="*" {
		If $e(GlobalList)'="," Set GlobalList=","_GlobalList
		If $e(GlobalList,$l(GlobalList))'="," Set GlobalList=GlobalList_","
		#;JO2453+
		#;The global names in GlobalList need to match the global names
		#; stored in the GOF file. In the GOF file they are stored without
		#; leading ^'s and trailing ".gbl"'s. We allow these in the input list
		#; for compatability with $SYSTEM.OBJ.Export and %Globals.Export
		#; We don't require them because other people are used to not specifying
		#; them.
		s len=$L(GlobalList,",")
		/* there is a leading and trailing comma so go from 2...len-1 */
		s changed=0
		for i=2:1:len-1 {
			s globnam=$P(GlobalList,",",i)
			if $E(globnam)="^" {
				s globnam=$E(globnam,2,$L(globnam))
				s changed=1
			}
			Set dots=$l(globnam,".")
			s ext=$zcvt($p(globnam,".",dots),"l")
			If (dots>=2),(ext="gbl") {
				; There can be .'s embedded in the global name. If the
				; name ends with .gbl then drop it, otherwise use the
				; name the user provided
				s globnam=$p(globnam,".",1,dots-1)
				s changed=1
			}
			if changed {
				s $P(GlobalList,",",i)=globnam
				s changed=0
			}
		}			
		#;JO2453-
	}
	If NewName]"" {
		If $e(NewName)="^" s NewName=$e(NewName,2,$l(NewName))
		If Format'=$$$goISMBLK Quit $$$ERROR($$$BadParameter)
		If $ll(GblList)'=1 Quit $$$ERROR($$$BadParameter)
		Set ^CacheTempJ($j,NewName)=""
	}
	ElseIf Format=$$$goISMBLK {
		For i=1:1:$ll(GblList) {
			Set gbl=$lg(GblList,i) If gbl="" Continue
			If GlobalList="*"!(GlobalList[(","_gbl_",")) Set ^CacheTempJ($j,gbl)=""
		}
	}
	Set dev=FileName_..GetOpenParms(0,RecordFormat="V",,Format)
	Set sc=$$main^%SYS.Wgr(dev,Format,"*",0,0,2,,.StatusCode,NewName) Close dev
	Kill ^CacheTempJ($j)
	#;SML1835 ; restore current device.
	Use OldCurDev
	If OldNsp'=Nsp ZN OldNsp
	If sc'=1 Quit StatusCode
	Quit $$$OK
Trap
	Set $ZT="" If $g(OldNsp),OldNsp'=Nsp ZN OldNsp
	#;SML1835 ; restore current device.
	If $d(OldCurDev) Use OldCurDev
	Set sc=$$$ERROR($$$CacheError,$ze) Quit sc
}

ClassMethod ListDump(list As %List, level As %Integer, ByRef ov As %Boolean, Flags As %Integer = 0) As %String [ Internal, ProcedureBlock = 0 ]
{
	If list="" || '$listvalid(list) Quit ""
	Quit $$ListDump^%qcr(.list,.level,.ov,.Flags)
}

/// This method quotes gvns or values so they can be printed. The default behavior is to quote a
/// value. You must pass in gvn=1 to quote a gvn. In this case, the quoting is applied to the global
/// name and to each subscript.
/// 
/// Numbers need no quoting and are returned unchanged.
/// 
/// Strings of printable characters are returned enclosed in quotes. If the string contains a quote
/// character itself, the quotes are doubled to keep it a valid COS string.
/// 
/// A string that is a valid $list is converted to a valid COS expression that evaluates to the
/// original string (for instance, $lb(1,3.14,"test")).
/// 
/// A string that contains control characters is converted to a valid COS expression that evaluates to the
/// original string (for instance, "test1"_$c(7)_"test2").
/// Flags - bit string  
/// Bit 0 - Format string
/// Bit 1 - Highlight String
/// Bit 2 - Write String to current device
ClassMethod Quote(str As %String, gvn As %Boolean = 0, ByRef ov As %Boolean, Flags As %Integer = 1) As %String [ Internal ]
{
	Quit $$Quote^%qcr(.str,.gvn,.ov,.Flags)
}

ClassMethod UndoubleInnerQuotes(str As %String) As %String [ Internal ]
{
	Quit $replace(str,"""""","""")
}

/// Undoes the effects of the Quote method. That is, given the gvn and value display strings,
/// Unquote returns a gvn and a value that can be used in a set command like Set @gvn=value.
/// 
/// The default behavior is to Unquote a value. To Unquote a gvn you must pass in gvn=1.
/// 
ClassMethod Unquote(str As %String, gvn As %Boolean = 0) As %String [ Internal ]
{
	Set $zt="ERROR"
	If 'gvn Quit ..Eval(str)
	If str]"" Quit $name(@str)
	Quit str
ERROR Set $zt="" Quit ""
}

/// The query returns the nodes that contain <var>FindWhat</var>, one node per row, with
/// four columns, namely Name, Value, Name Format and Value Format.<br>
/// Use ##Class(%Library.Utility).Replace to replace <var>FindWhat</var> with <var>ReplaceWith</var>.<br>
/// NameFormat:
/// <li>1 - String format, this is the value of the subscript unaltered</li>
/// <li>2 - Cache format, the value has been converted into the Cache representation for easy viewing,
/// for example instead of showing the binary value a list is displayed as '$lb(1,"test")'. This format
/// is suitable as the argument of $name.</li><br>
/// ValueFormat:
/// <li>1 - String format, this is the value unaltered</li>
/// <li>2 - Cache format, the value has been converted into the Cache representation for easy viewing,
/// for example instead of showing the binary value a list is displayed as '$lb(1,"test")'.</li>
/// On output, Name Format and Value Format may assume a third value, namely 3, which means "Not editable".
/// Due to issues with the length of this data not all of it can be displayed so a portion is displayed.
Query Find(Namespace As %String, StartNode As %String, FindWhat As %String, MatchCase As %Boolean = 1, NameFormat As %Integer = 1, ValueFormat As %Integer = 1) As %Query(ROWSPEC = "Name:%String:Global Name,Value:%String:Value,Name Format:%Integer,Value Format:%Integer")
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary, Namespace As %String, StartNode As %String, FindWhat As %String = "", MatchCase As %Boolean = 1, NameFormat As %Integer = 1, ValueFormat As %Integer = 1) As %Status [ Internal ]
{
	Set $zt="ERROR"
	Set qHandle("FindFirst")=1
	If FindWhat="" Quit $$$ERROR($$$InvalidParameter,"FindWhat","")
	Set:'MatchCase FindWhat=$zcvt(FindWhat,"U")
	Set qHandle("FindWhat")=FindWhat
	Set qHandle("MatchCase")=MatchCase
	Set qHandle("NameFormat")=NameFormat
	Set qHandle("ValueFormat")=ValueFormat
	If StartNode=""!($e(StartNode)'="^") Quit $$$ERROR($$$InvalidParameter,"StartNode",StartNode)
	If Namespace="" Quit $$$ERROR($$$InvalidParameter,"Namespace",Namespace)
	Set gref="^|"""_Namespace_"""|"_$p($qs(StartNode,0),"^",2)
	If $ql(StartNode) Set gref=gref_"("_$p(StartNode,"(",2,$l(StartNode,"("))
	Set qHandle("StartNode")=gref
	Quit $$$OK
ERROR Set $zt="" Quit $$$ERROR($$$CacheError,$ze)
}

ClassMethod FindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = FindExecute ]
{
	Set $zt="ERROR"
	Set MatchCase=qHandle("MatchCase")
	Set FindWhat=qHandle("FindWhat")
	Set StartNode=qHandle("StartNode")
	Set NameFormat=qHandle("NameFormat")
	Set ValueFormat=qHandle("ValueFormat")
	Set FindFirst=$g(qHandle("FindFirst"),0) Kill qHandle("FindFirst")
	Set nullsub=$zu(68,1,1)
	;
	If FindFirst,$d(@StartNode)#10 {
		Set OutNode=StartNode,OutValue=@StartNode
		Set rec="^"_$p(OutNode,"""|",2,999)_"="_OutValue Set:'MatchCase rec=$zcvt(rec,"U")
		If rec[FindWhat {
			If NameFormat=2 Set OutNode=$$Quote^%qcr(OutNode,1,.ov) Set:ov NameFormat=3
			If ValueFormat=2 Set OutValue=$$Quote^%qcr(OutValue,0,.ov) Set:ov ValueFormat=3
			Set Row=$lb(OutNode,OutValue,NameFormat,ValueFormat) Quit $$$OK
		}
	}
	;
	For {
		Set StartNode=$Q(@StartNode) If StartNode="" Set Row="",AtEnd=1 Quit
		Set OutNode=StartNode,OutValue=@StartNode
#;SML893+
	 	Set TempList=..ListDump(OutValue,9,.ov,0)
	 	I TempList="" Set TempList=OutValue
		Set rec="^"_$p(OutNode,"""|",2,999)_"="_TempList Set:'MatchCase rec=$zcvt(rec,"U")
#;SML893-
		If rec[FindWhat {
			If NameFormat=2 Set OutNode=$$Quote^%qcr(OutNode,1,.ov) Set:ov NameFormat=3
			If ValueFormat=2 Set OutValue=$$Quote^%qcr(OutValue,0,.ov) Set:ov ValueFormat=3
			Set Row=$lb(OutNode,OutValue,NameFormat,ValueFormat)
			Set qHandle("StartNode")=StartNode Quit
		}
	}
	;
	Set:'nullsub nullsub=$zu(68,1,0)
	Quit $$$OK
ERROR Set $zt=""
	If $d(nullsub),'nullsub Set nullsub=$zu(68,1,0)
	Quit $$$ERROR($$$CacheError,$ze)
}

ClassMethod FindClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = FindExecute ]
{
	Quit $$$OK
}

/// The query returns the nodes selected by <var>SearchMask</var>, one node per row, with
/// four columns, namely Name, Value, Name Format and Value Format.<br>
/// NameFormat:
/// <li>1 - String format, this is the value of the subscript unaltered</li>
/// <li>2 - Cache format, the value has been converted into the Cache representation for easy viewing,
/// for example instead of showing the binary value a list is displayed as '$lb(1,"test")'. This format
/// is suitable as the argument of $name.</li><br>
/// ValueFormat:
/// <li>1 - String format, this is the value unaltered</li>
/// <li>2 - Cache format, the value has been converted into the Cache representation for easy viewing,
/// for example instead of showing the binary value a list is displayed as '$lb(1,"test")'.</li>
/// On output, Name Format and Value Format may assume a third value, namely 3, which means "Not editable".
/// Due to issues with the length of this data not all of it can be displayed so a portion is displayed.<br>
/// GetPermissions: Note that returning permissions on an individual global will
/// affect performance of the query.
/// <li>0 - Return "" for permission (no performance penalty) </li>
/// <li>1 - Return permissions (READ,WRITE,USE) </li>
Query Get(Namespace As %String, SearchMask As %String, LastNode As %String, NameFormat As %Integer = 1, ValueFormat As %Integer = 1, GetPermissions As %Integer = 0) As %Query(ROWSPEC = "Name:%String:Global Name,Value:%String:Value,Name Format:%Integer,Value Format:%Integer,Permissions:%String") [ SqlProc ]
{
}

ClassMethod GetExecute(ByRef qHandle As %Binary, Namespace As %String, SearchMask As %String, LastNode As %String, NameFormat As %Integer = 1, ValueFormat As %Integer = 1, GetPermissions As %Integer = 0) As %Status [ Internal ]
{
	Set $zt="ERROR"
	Set Index=$i($$$ISCQUERYTEMP)
	;
	If Namespace="" Quit $$$ERROR($$$InvalidParameter,"Namespace",Namespace)
	Set qHandle=Index_"^"
	Set qHandle("Namespace")=Namespace
	Set qHandle("SearchMask")=$g(SearchMask)
	Set qHandle("LastNode")=$g(LastNode)
	Set qHandle("NameFormat")=NameFormat
	Set qHandle("ValueFormat")=ValueFormat
	Set qHandle("GetPermissions")=GetPermissions
	Quit $$$OK
ERROR Set $zt="" Quit $$$ERROR($$$CacheError,$ze)
}

ClassMethod GetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = GetExecute ]
{
	Set $zt="ERROR"
	Set idx=$p(qHandle,"^",2)
	Set Index=$p(qHandle,"^")
	Set idx=$Order($$$ISCQUERYTEMP(Index,idx),1,Row)
	If idx="" {
		Set Namespace=qHandle("Namespace")
		Set SearchMask=qHandle("SearchMask")
		Set LastNode=qHandle("LastNode")
		Set NameFormat=qHandle("NameFormat")
		Set ValueFormat=qHandle("ValueFormat")
		Set OldNsp=$zu(5),%UI="CHUI",Count=100
		If Namespace'=OldNsp ZN Namespace
		Set data=$$page^%Wgdisp(SearchMask,LastNode,.Count,0,"","",1,NameFormat,ValueFormat)
		If $zu(5)'=OldNsp ZN OldNsp
		If 'Count Set AtEnd=1,Row="" Quit $$$OK
		;
		Kill $$$ISCQUERYTEMP(Index)
		For i=1:1:Count {
			Set rec=$p(data,$$$del1,i),subs=$p(rec,$$$del2),val=$p(rec,$$$del2,2)
			Set nf=$p(rec,$$$del2,3),vf=$p(rec,$$$del2,4)
#;SML618+
#;Setup ^CacheTemp with a subroutine in case it overflows the $LB() list.
			d BuildCacheTemp
#;SML618-
		}
		Set qHandle("LastNode")=..Unquote(subs,1)
		Set qHandle=Index_"^"
		Quit ..GetFetch(.qHandle,.Row,.AtEnd)
	} Else {
#;SML618+
#;If there is extension of data then set them to Row array for %ResultSet to get them.
		if $d($$$ISCQUERYTEMP(Index,idx,1)) {
			Set Row(1)=$$$ISCQUERYTEMP(Index,idx,1)
			if $d($$$ISCQUERYTEMP(Index,idx,2)) {
				Set Row(2)=$$$ISCQUERYTEMP(Index,idx,2)
			}
		}
#;SML618-
		Set qHandle=Index_"^"_idx
	}
	Quit $$$OK
ERROR Set $zt=""
	If $g(OldNsp)'="",$zu(5)'=$g(OldNsp) ZN OldNsp
	Quit $$$ERROR($$$CacheError,$ze)
#;SML618+
#;Set the data extension to two or three pieces if it could not fit in one piece.
BuildCacheTemp s $zt="BuildErr1"
	i subs["(" {
		s sub1="("_$p(subs,"(",2,999)
	} else {
		s sub1=""
	}
	s Perm=$s(qHandle("GetPermissions")=0:"",1:$$GetGlobalPermission^%SYS.SECURITY(Namespace,$p(subs,"(",1),sub1,1))
	Set $$$ISCQUERYTEMP(Index,i)=$lb(subs,val,nf,vf,Perm)
	Q
BuildErr1 s $zt="BuildErr2"
	Set $$$ISCQUERYTEMP(Index,i)=$lb(subs,$e(val,1,$l(val)\2),nf,vf,$g(Perm))
	Set $$$ISCQUERYTEMP(Index,i,1)=$lb("",$e(val,$l(val)\2+1,$l(val)),"","","")
	Q
BuildErr2 s $zt=""
	Set $$$ISCQUERYTEMP(Index,i)=$lb(subs,$e(val,1,$l(val)\3),nf,vf,$g(Perm))
	Set $$$ISCQUERYTEMP(Index,i,1)=$lb("",$e(val,$l(val)\3+1,$l(val)\3*2),"","","")
	Set $$$ISCQUERYTEMP(Index,i,2)=$lb("",$e(val,$l(val)\3*2+1,$l(val)),"","","")
	Q
#;SML618-
}

ClassMethod GetClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = GetExecute ]
{
	Set Index=$p(qHandle,"^",1)
	Kill $$$ISCQUERYTEMP(Index)
	Quit $$$OK
}

}
