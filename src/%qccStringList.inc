ROUTINE %qccStringList [Type=INC]
 ;
#include %occConstant
#def1arg LB(%args) $$ListBuild(%args)
#def1arg LL(%args) $$ListLength(%args)
#def1arg LI(%args) $$List(%args)
#define  SLB(%arg) $length(%arg)_":"_%arg
#define SetClsIndexRow(%var,%data,%showhidden) Set %var=$$$SLB($list(%data,2))_$$$SLB($lg(%data))_$$$SLB($lg(%data,7))_$$$SLB($ld(%data,5))_$$$SLB($lg(%data,5))_$$$SLB($lg(%data,3))_$$$SLB($select(%showhidden:0,1:+$lg(%data,4)))_$$$SLB(+$lg(%data,11))_$$$SLB($lg(%data,14)),%var=$$$SLB(%var)
 ;
ListBuild(args...) {
	Set list="" For i=1:1:args Set list=list_$Length($Get(args(i)))_":"_$Get(args(i))
	Quit list
}
ListLength(list) {
	If $Get(list)="" Quit 0
	Set start=1,length=$Length(list),count=0
	For count=1:1 Do  Quit:start>length
	. If $Extract(list,start)'?1N Set count=-1,start=length+1 Quit
	. Set len=+$Extract(list,start,length),start=start+$Length(len)+1+len
	If count=-1||(start>(length+1)) Quit -1
	Quit count
}
List(list,piece) {
	If $Get(list)=""||($get(piece)<1) Quit ""
	Set start=1,length=$Length(list),count=0
	For count=1:1:piece Do  Quit:start>length
	. If $Extract(list,start)'?1N Set count=-1,start=length+1 Quit
	. Set len=+$Extract(list,start,length),start=start+$Length(len)+1+len
	If count=-1||(start>(length+1)) Quit ""
	If count=piece Quit $Extract(list,start-len,start-1)
	Quit ""
}
Split(list,array) ; Split the list into an array, return number of elements
 Kill array
 If $Get(list)="" Quit 0
 New start,length,count,len
 Set start=1,length=$Length(list),count=0
 For count=1:1 Do  Quit:start>length
 . If $Extract(list,start)'?1N Set count=-1,start=length+1 Quit
 . Set len=+$Extract(list,start,length),start=start+$Length(len)+1+len,array(count)=$Extract(list,start-len,start-1)
 If count=-1 Kill array Quit 0
 If start>(length+1) Kill array Quit 0
 Quit count
 ;
Linearize(array,linear) {
	Set tier=1,data=array(1),index=1,maxstring=$$$MaxLocalLength-100
	For  {
		Set find=$find(data,":",index)
		If find {
			Set len=$extract(data,index,find-2),index=find
		} Else {
			Set len=$extract(data,index,*),index=1
			Do {
				Set tier=tier+1 If tier>array Goto exit
				Set data=array(tier),find=$find(data,":")
				If find=0 Set len=len_array(tier)
			} While find=0
			Set len=len_$extract(data,1,find-2),index=find
		}
		If len<maxstring {
			Set val=$extract(data,index,index+len-1),index=index+len
			While $length(val)'=len {
				Set tier=tier+1 If tier>array Goto exit
				Set data=array(tier),index=len-$length(val)+1
				Set val=val_$extract(data,1,index-1)
			}
			Set linear($increment(linear))=val
		} Else {
			Set linear($increment(linear))="",line=0
			While len>0 {
				Set tmp=$extract(data,index,len+index-1),linear(linear,$increment(line))=tmp,len=len-$length(tmp) If len=0 Set index=index+$length(tmp) Quit
				Set tier=tier+1 If tier>array Goto exit
				Set data=array(tier),index=1
			}
		}
	}
exit	Set linear($increment(linear))=""
}
 