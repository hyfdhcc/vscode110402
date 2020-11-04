Include (%occInclude, %occReference2)

IncludeGenerator %occInclude

/// Hyperindex Utilities class
Class %BI.MinerUtils Extends %BI.MinerParams [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/// Add a new (Compound) condition to ^SpeedI.Hi
ClassMethod DelCond(Class, CondRow) As %Status
{
	n (Class, CondRow)
	s IncUpdate=$G(^SYS("BI","CFG","Configuration","System",0,3))
	set sc=$$$OK
	
	s zzClassNZ=$$gClass^%bi.SMr.Main(Class)
	if IncUpdate d
	. s zzchunk="" f  s zzchunk=$O(^BIidx.Hi(zzClassNZ,CondRow,zzchunk),1,zzbitdata) q:zzchunk=""  d  
	.. s zzoffset=1 f  s zzoffset=$bitfind(zzbitdata,1,zzoffset) q:zzoffset=0  d  
	... s Col=zzoffset+(zzchunk*..#BitsPerChunk)
	... s zzoffset=zzoffset+1
	... kill ^BIidx.Cols(zzClassNZ,Col,CondRow)
	k ^BIidx.Hi(zzClassNZ,CondRow)
	
	quit sc
}

/// Add a new (Compound) condition to ^SpeedI.Hi
ClassMethod AddCond(Class, CondRow, Query) As %Status
{
 ;#if (..#Debug)
 ;write !,"AddCond called for condition ",CondRow,"(",Query,") in class ",Class
 ;#endif
	new sc,temp,Col
	set sc=$$$OK,error=""
	s zzClassNZ=$$gClass^%bi.SMr.Main(zzClass)
	set temp=$$Search^%bi.SMr.MinerUtils1(Class,Query,.error,zzClassNZ) ; run search engine to get row
	if error'="" set sc=$$$ERR(error) quit sc
	if temp="" set sc=$$$ERR("Invalid Query") quit sc

	s IncUpdate=$G(^SYS("BI","CFG","Configuration","System",0,3))
	if IncUpdate d ..DelCond(Class,CondRow)
	do Copy^%bi.SMr.MinerUtils1(zzClassNZ,temp,CondRow) ; copy row into new cond row
	if temp'?1n.n kill ^BIidx.Hi(zzClassNZ,temp) ; delete temp row
	
	; for each 'hit', add the condition to the list - may take some time !!
	;set catid=$li(^BIidx.ConditionD(CondRow),1)
	if +IncUpdate'=1 q sc
	set Col=""

	s zzchunk="" f  s zzchunk=$O(^BIidx.Hi(zzClassNZ,CondRow,zzchunk),1,zzbitdata) q:zzchunk=""  d  
	. s zzoffset=1 f  s zzoffset=$bitfind(zzbitdata,1,zzoffset) q:zzoffset=0  d  
	.. s Col=zzoffset+(zzchunk*..#BitsPerChunk)
	.. s zzoffset=zzoffset+1
	.. set ^BIidx.Cols(zzClassNZ,Col,CondRow)=""

	quit sc
}

/// Fast rebuild of one class
ClassMethod FastRebuild(class, SortSize = 256) As %Status
{
	q $$Compress^%bi.SMr.MinerU2(class,SortSize,1)
}

/// Rebuild ^SpeedI.Hi for ALL classes.
/// This method will delete all existing conditions (total rebuild) if the
/// init parameter is set (default = 1).
/// Then it will call either the FastRebuild (if parameter fast = 1 (default))
/// or the normal Rebuild, for each class that has such a method.
ClassMethod HiRebuildAll(init = 1, fast = 1) As %Status
{
	new Method,rs,Class,ok
	if $g(init) {
	 kill ^BI.CategoryD,^BI.CategoryI,^BIidx.ConditionD,^BIidx.ConditionI
	}
	set Method=$s($g(fast):"HiFastRebuild",1:"HiRebuild")
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="%CompiledClass",rs.QueryName="ClassInfo"
	set ok=rs.Execute("&")
	set $zt="HiRebuildAllTrap"
	for  quit:'rs.Next()  set Class=rs.Get("Name") do  quit:$$$ISERR(ok)
	. if '$$$METHrunnable($$$MGINFO,Class,Method) quit
	. write !!,"Rebuilding Class ",Class
	. s zzClassNZ=$$gClass^%bi.SMr.Main(Class)
	. set ^BIidx.Hi(zzClassNZ)="" ; no restart
	. set ok=$zobjclassmethod(Class,Method)
	do rs.%Close()
	quit ok
HiRebuildAllTrap if $d(Class),$d(^BIidx.Hi(zzClassNZ)) set ^BIidx.Hi(zzClassNZ)="" ; NOT restartable
	quit $$$ERROR($$$GeneralError,$ZE)
}

/// delete record Id
ClassMethod Delete(Class, Id) As %Status
{
	new Col,chunk,offset,cond,catid
	
 	set zzClassNZ=$$gClass^%bi.SMr.Main(Class)
	set Col=$get(^BIidx.Id(zzClassNZ,Id)) ; convert Id to Col
	if Col="" quit $$$OK
	set chunk=Col-1\..#BitsPerChunk,offset=Col-(chunk*..#BitsPerChunk)
	; do I need to do this ?  I could just leave the bits set as long as the Exists bit is off ??
	set cond="" for  set cond=$o(^BIidx.Cols(zzClassNZ,Col,cond)) q:cond=""  do
	. set $bit(^BIidx.Hi(zzClassNZ,cond,chunk),offset)=0
	. if $bitfind(^BIidx.Hi(zzClassNZ,cond,chunk),1)=0 kill ^BIidx.Hi(zzClassNZ,cond,chunk)
	kill ^BIidx.Id(zzClassNZ,Id),^BIidx.Col(zzClassNZ,Col),^BIidx.Cols(zzClassNZ,Col)

	; Exist
	s catid=$O(^BI.CategoryI("Cat",Class,"<System>",""))
	s cond=$O(^BIidx.ConditionI("ShortName",Class,catid,"Exists",""))
	if cond="" quit $$$OK
	set $bit(^BIidx.Hi(zzClassNZ,cond,chunk),offset)=0
	if $bitfind(^BIidx.Hi(zzClassNZ,cond,chunk),1)=0 kill ^BIidx.Hi(zzClassNZ,cond,chunk)
	quit $$$OK
}

/// set all compound conditions for record Id
ClassMethod SetCompoundConditionsOneRecord(Class, Id) As %Status
{
	new Col,ok,qh,c,row,atend,cond,name,chunk,offset,bs,r,incUpd
	
	s zzClassNZ=$$gClass^%bi.SMr.Main(Class)
	if '$D(^BIidx.Id(zzClassNZ,Id)) quit 1
	set Col=^BIidx.Id(zzClassNZ,Id) ; column number
	set chunk=Col-1\..#BitsPerChunk,offset=Col-(chunk*..#BitsPerChunk)
	s error=""
	#;s incUpd=$G(^SYS("BI","CFG","Configuration","ETL",0,2))
	s c="" f  s c=$O(^BIidx.ConditionI("Compound",Class,c)) q:c=""  d
	. s r=$G(^BIidx.ConditionD(c))
	. i r="" k ^BIidx.ConditionI("Compound",Class,c) q
	. q:$LG(r,5)
	. set cond=$lg(r,3),name=$lg(r,6)
	. ;Note: since conditions are never deleted, we can assume that conditions
	. ; ONLY refer to earlier ones
	. d
	.. n (Class,cond,error,row,%session,incUpd,zzClassNZ)
	.. set row=$$Search^%bi.SMr.MinerUtils1(Class,cond,.error,zzClassNZ)
	. ; if col Col is 'on' for row, set bit for cond c, col Col
	. if $bit($g(^BIidx.Hi(zzClassNZ,row,chunk)),offset) set ^BIidx.Cols(zzClassNZ,Col,c)="",$bit(^BIidx.Hi(zzClassNZ,c,chunk),offset)=1
	. else  Kill ^BIidx.Cols(zzClassNZ,Col,c) s $bit(^BIidx.Hi(zzClassNZ,c,chunk),offset)=0
	. if row'?1n.n kill ^BIidx.Hi(zzClassNZ,row) ; if new one, kill it off

	quit $$$OK
}

/// Loop through the compound (user-defined) conditions
/// and set the bits for them.  Note this can be slow !
ClassMethod UpdateCompoundConditions(Class) As %Status
{
	new ok,qh,c,catid,row,atend,cond,name,Col,NewSess,incUpd
	set ok=##class(%BI.Condition).CompoundConditionsExecute(.qh,Class)
	s NewSess=0
	i $G(%session)="" s NewSess=1 d Create^%bi.SMr.Session
	s error=""
	s zzClassNZ=$$gClass^%bi.SMr.Main(Class)
	s incUpd=$G(^SYS("BI","CFG","Configuration","ETL",0,2))
	s c="" f  s c=$O(^BIidx.ConditionI("Compound",Class,c)) q:c=""  d
	. s r=$G(^BIidx.ConditionD(c))
	. i r="" k ^BIidx.ConditionI("Compound",Class,c) q
	. q:$LG(r,5)
	. set cond=$lg(r,3),name=$lg(r,6)
	. set catid=$li(^BIidx.ConditionD(c),1)
	. d
	.. n (Class,cond,zzClassNZ,error,row,%session)
	.. set row=$$Search^%bi.SMr.MinerUtils1(Class,cond,.error,zzClassNZ)
	. do Copy^%bi.SMr.MinerUtils1(zzClassNZ,row,c)
	. d eShortIdx^%bi.SMr.Condition3(Class,catid,name,c)
	. ; scan the bits in row c and set into the conditions list for each record
	. if row'?1n.n kill ^BIidx.Hi(zzClassNZ,row)
	. q:'incUpd
	. s zzchunk="" f  s zzchunk=$O(^BIidx.Hi(zzClassNZ,c,zzchunk),1,zzbitdata) q:zzchunk=""  d  
	.. s zzoffset=1 f  s zzoffset=$bitfind(zzbitdata,1,zzoffset) q:zzoffset=0  d  
	... s Col=zzoffset+(zzchunk*..#BitsPerChunk)
	... s zzoffset=zzoffset+1
	... set ^BIidx.Cols(zzClassNZ,Col,c)=""
	i NewSess do Close^%bi.SMr.Session
	quit $$$OK
}

/// Parse def into def(n)=$lb(type,category,params)
/// def is list of type specs, can have params and category
/// e.g.  Values,Words[Text contains](3,0),Range[Age Range](-50,51-)
ClassMethod Parse(ByRef def) As %Status
{
	new sc,spec,seq,p1,p2,p3,type,cat,level,inquotes,i,c,param
	
	set sc=$$$OK,spec=def,seq=0 kill def set def=spec ; remove old entries !
	for  quit:def=""  quit:'sc  do
	. set p1=$p(def,",",1),p2=$p(def,"(",1),p3=$p(def,"[",1)
	. if $l(p1)'>$l(p2) set type=$s($l(p1)<$l(p3):p1,1:p3)
	. else  set type=$s($l(p2)<$l(p3):p2,1:p3)
	. if type="" set sc=$$$ERROR(401,spec) quit  ; invalid
	. set seq=seq+1,def(seq)=$lb(type),def=$p(def,type,2,9999) ; strip type
	. if def="" quit  ; single
	. if $e(def)="[" set cat=$e(def,2,$f(def,"]")-2),def=$p(def,"]",2,9999)
	. else  set cat=""
	. set def(seq)=def(seq)_$lb(cat)
	. if def="" quit  ; just type and cat
	. if $e(def)="," set def=$p(def,",",2,99999) quit  ; just type and cat
	. if $e(def)'="(" set sc=$$$ERROR(401,spec) quit  ; invalid
	. ; have params - scan for closing ( watching for embedded ( and quotes
	. set def=$e(def,2,9999),level=1,inquotes=0
	. for i=1:1:$l(def) set c=$e(def,i) do  quit:level=0
	. . if inquotes quit:c'=""""  do  quit
	. . . if $e(def,i+1)="""" set i=i+1 quit
	. . . set inquotes=0
	. . if c="""" set inquotes=1 quit
	. . if c="(" set level=level+1 quit
	. . if c=")" set level=level-1 quit
	. if level!inquotes set sc=$$$ERROR(401,spec) quit  ; unmatched quotes or ()
	. set param=$e(def,1,i-1),def(seq)=def(seq)_$lb(param),def=$e(def,i+2,99999)
	
	quit sc
}

/// Finds the next column number after Col in condition# Cond for Class.
/// Starts at null, returns null if no more
ClassMethod Next(Class, Cond, Col) As %Integer
{
	quit $$Next^%bi.SMr.MinerUtils2(Class,Cond,Col)
}

/// Run the File, using whatever tool has been set up for the
/// extension (eg MsWord for .doc, TextPad for .txt, etc)
/// Called from List.frm in VB
/// The quotes are needed in case the filename contains spaces (etc)
ClassMethod RunFile(File)
{
	if File'?1"""".e1"""" set File=""""_File_""""
	if $zf(-2,File)
	quit
}

ClassMethod Print(Class)
{
	new x,c,i,cond,bits,chunk,str
	set x=""
	s zzClassNZ=$$gClass^%bi.SMr.Main(Class)
	If $g(Class)="" r !,"Class >",Class quit:Class=""
	If '$d(^BIidx.Hi(zzClassNZ)) set Class="User."_Class if '$d(^BIidx.Hi(zzClassNZ)) quit
	write !?30,"12345678901234567890123456789012345678901234567890"
	set c="" for i=1:1 set c=$o(^BIidx.Hi(zzClassNZ,c)) quit:c=""  do  quit:x'=""
	. if c="Upd" quit
	. if '(i#22) read !?70,"<more>",x i x'="" quit
	. set cond=##class(%BI.Condition).%OpenId(c)
	. if cond'="" write !,$j(c,4)," ",$e(cond.ConditionName,1,20),?30 do cond.%Close()
	. else  write !,c,?30
	. set bits=0,chunk=""
	. for chunk=0:1 quit:$o(^BIidx.Hi(zzClassNZ,c,chunk))=""&'$d(^BIidx.Hi(zzClassNZ,c,chunk))  quit:bits'<50  do
	. . set str=..ToString($get(^BIidx.Hi(zzClassNZ,c,chunk)),..#BitsPerChunk)
	. . write $e(str,1,50-bits)
	. . set bits=bits+$length(str)
	quit
}

/// Converts bitstring to string of zeroes and ones
ClassMethod ToString(bitstring, length)
{
	new s,i set s=""
	if '$g(length) set length=$bitcount(bitstring)
	if length>32000 set length=32000
	for i=1:1:length set s=s_$bit(bitstring,i)
	quit s
}

/// Hyperindex on each value. : Params:       Startswith[(maxchars)]
ClassMethod Values(Class, Prop, Params, Cat, nullidx, nullptr, complex, sclass, linkprop, addcond)
{
	do Values^%bi.SMr.MinerU1
	quit
}

/// Hyperindex on a reference (do not index nulls).
/// Params:List of attribute name(s) to display in the condition description
/// Note this cannot be resolved at %OnAfterSave time because the values in the
/// referenced record may change, so I store the condition as (eg)
/// [oid]Name,DOB and the front-end tool must resolve at display time
ClassMethod Reference(Class, Prop, Params, Cat, nullidx, nullptr, complex, sclass, linkprop, addcond)
{
	do Reference^%bi.SMr.MinerU1
	quit
}

ClassMethod Boolean(Class, Prop, Params, Cat)
{
	do Boolean^%bi.SMr.MinerU1
	quit
}

/// Hyperindex on date fields.
/// Params:       none (yet)
ClassMethod Date(Class, Prop, Params, Cat, nullidx, nullptr, complex, DateFormat, sclass, linkprop, addcond)
{
	do Date^%bi.SMr.MinerU1
	quit
}

/// Hyperindex on Number fields.
/// Params:       none (yet)
ClassMethod Number(Class, Prop, Params, Cat, nullidx, nullptr, complex)
{
	do Number^%bi.SMr.MinerU1
	quit
}

/// Hyperindex on time fields.
/// Params:       none (yet)
ClassMethod Time(Class, Prop, Params, Cat, nullidx, nullptr, complex)
{
	do Time^%bi.SMr.MinerU1
	quit
}

/// Split a time field into its various ranges.
/// Params:       [from]-to,from-to,from-to,from-to,...,from-[to]
/// Each from/to must be valid time (accepted by $zth(x))
/// [ assumes non-overlapping, increasing ranges ]
ClassMethod TimeRanges(Class, Prop, Params, Cat)
{
 ; generated code
 ;   set val=%this.<Prop>
 ;   if val?1.6n do ..HiTimeRanges("<Class>","<Cat>",val,"<Params>",Col,chunk,offset)

 $$$GENERATE(" set val=%this."_Prop)
 $$$GENERATE(" if val?1.6n do ..HiTimeRanges("""_%class_""","""_Cat_""",val,"""_Params_""",Col,chunk,offset)")
 quit

 quit
}

/// Hyperindex on a set of ranges.
/// Params:       [from]-to,from-to,from-to,from-to,...,from-[to]
/// [ assumes non-overlapping, increasing ranges ]
/// [ negative numbers must be enclosed in paren, eg "(-100)-50" means -100 to 50]
ClassMethod Ranges(Class, Prop, Params, Cat, nullidx, nullptr, complex, iRange)
{
	do Ranges^%bi.SMr.MinerU1
	quit
}

/// Hyperindex on each word in the string.
/// Words are defined as strings delimited by <space><tab><cr><lf> or punctuation
/// Purely numeric and/or punctuation are ignored
/// Params: minlength,punc
/// minlength = minimum number length to index
/// punc = strip punctuation (1=yes)
ClassMethod Words(Class, Prop, Params, Cat, nullidx, nullptr, complex, sclass, linkprop, addcond)
{
	do Word^%bi.SMr.MinerU1
	quit
}

/// Hyperindex on each word in the (line-oriented) text-characterstream Prop.
/// Words are defined as strings delimited by <space><tab><cr><lf> or punctuation.
/// Purely numeric and/or punctuation are ignored.
/// The stream is expected to be line-oriented (contains CR/LF every < 32000 chars)
/// Params: minlength,punc
/// minlength = minimum number length to index
/// punc = strip punctuation (1=yes)
ClassMethod StreamWords(Class, Prop, Params, Cat)
{
	; generated code
	;   kill ^BI.TempWords($j) ; temp global to check for duplicates (performance)
	;   do %this.<Prop>.Rewind()
	;   for  {
	;         set i=32000  ; Note i is newed in HiBuild()
	;         set val=%this.<Prop>.ReadLine(.i)
	;         if i=-1 quit
	;         do ..HiWords("<Class>","<Cat>",val,"<Params>",Col,chunk,offset)
	;   }
	;   kill ^BI.TempWords($j)
	
	$$$GENERATE(" kill ^BI.TempWords($j)")
	$$$GENERATE(" set val=%this."_Prop_".Rewind()")
	$$$GENERATE(" for  {")
	$$$GENERATE("      set i=32000")
	$$$GENERATE("      set val=%this."_Prop_".ReadLine(.i)")
	$$$GENERATE("      if i=-1 quit")
	$$$GENERATE("      do ..HiWords("""_%class_""","""_Cat_""",val,"""_Params_""",Col,chunk,offset)")
	$$$GENERATE(" }")
	$$$GENERATE(" kill ^BI.TempWords($j)")
	quit
}

}
