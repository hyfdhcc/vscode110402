Include %occInclude

IncludeGenerator (%occInclude, %occReference2)

Class %BI.CopyTable [ Abstract, ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

ClassMethod HiCopyTable() As %Status [ CodeMode = generator ]
{
	QUIT:'($$$CLASSclasstype($$$gMGINFO,%class)=$$$cCLASSCLASSTYPEPERSISTENT) $$$OK
	
	new sqlclass,curName,cnt,allrow,allrowf,FF
	set sqlclass=$G(^oddCOM("V500."_$P(%class,".",2),53))
	set curName=$P(%class,".",2),allrow="",cnt=0,allrowf=""
	s f="" f  s f=$O(^oddCOM(%class,"a",f)) q:f=""  d
	. i $E(f)="%" q
	. i allrow'="" s allrow=allrow_",",allrowf=allrowf_","
	. s allrow=allrow_$LG($LG(^oddCOM(%class,"a",f,3),1),8)
	. s cnt=cnt+1
	. s allrowf=allrowf_":F("_cnt_")"
	. s FF(cnt)=f
	$$$GENERATE(" new F,SQLCODE,curr")
	$$$GENERATE(" &sql(declare Cur"_curName_" cursor for")
	$$$GENERATE("  select "_allrow_" into "_allrowf_" from "_sqlclass_")")
	$$$GENERATE(" &sql(open Cur"_curName_")")
	$$$GENERATE(" for  &sql(fetch Cur"_curName_") quit:SQLCODE  do")
	$$$GENERATE(" . set curr=##class("_%class_").%New()")
	f i=1:1:cnt d
	. $$$GENERATE(" . s curr."_FF(i)_"=F("_i_")")
	$$$GENERATE(" . do curr.%Save()")
	$$$GENERATE(" . do curr.%Close()")
	$$$GENERATE(" &sql(close Cur"_curName_")")
	$$$GENERATE(" quit $$$OK")
	
	quit $$$OK
}

}
