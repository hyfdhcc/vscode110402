/// Used to scan user code looking for code that may not work correctly due to use of unsupported features.
Class %SYSTEM.CodeScanner Extends %SYSTEM.Help
{

/// Define the list of things to scan for. The format is:<ul>
/// <li>patterns(num)=pattern</li>
/// <li>patterns(num,"case")=case sensitive</li>
/// <li>patterns(num,"version")=version customer will see the problem in</li>
/// <li>patterns(num,"info")=description of the problem</li>
/// <li>patterns(num,"whole")=whole word pattern match</li></ul>
ClassMethod SetupPatterns(ByRef patterns As %String, ByRef info As %String) [ Private ]
{
	Set patterns(1)="$zobjval(",patterns(1,"case")=0,patterns(1,"version")="2011.2"
	Set patterns(1,"info")="Use of '$zobjval' is not supported. It relies on internal slot number information which has changed so code using this will not function correctly. Replace this useage with i%var to reference the instance variable 'var' which is fully supported in all versions of Cache."
	Set patterns(2)="$zobjmod(",patterns(2,"case")=0,patterns(2,"version")="2011.2"
	Set patterns(2,"info")="Use of '$zobjmod' is not supported. It relies on internal slot number information which has changed so code using this will not function correctly. Replace this useage with ..PropIsModified()/..PropSetModified(val) method calls which are supported in all versions of Cache."
	Set patterns(3)="$$$cIVARslot",patterns(3,"case")=1,patterns(3,"version")="2011.2"
	Set patterns(3,"info")="Use of '$$$cIVARslot' macro is not supported. The macro has been removed as it is no longer used internally so code using this will report an error on compilation. Look at where the slot number was used and remove the use of the slot number, e.g. i%var instead of $zobjval and then remove the code that uses the macro."
	Set patterns(4)="$$$cIVARrefslot",patterns(4,"case")=1,patterns(4,"version")="2011.1"
	Set patterns(4,"info")="Use of '$$$cIVARrefslot' macro is not supported. The macro has been removed as it is no longer used internally so code using this will report an error on compilation. Look at where the refslot number was used and remove the use of the refslot number, e.g. r%var instead of $zobjval and then remove the code that uses the macro."
	Set patterns(5)="%this",patterns(5,"case")=1,patterns(5,"version")="2011.1",patterns(5,"whole")=1
	Set patterns(5,"info")="Use of '%this' to reference the current object instance context is deprecated. There may be some false matches if you happen to have a local variable called %this rather than the case where %this is assumed to be the current oref in an instance method. Since 2010.1 you should use $this system variable which provides the current context in both class methods and instance methods. Code using %this as the instance context will continue to work as old classes automatically have 'LegacyInstanceContext' keyword added to them which makes all instance methods pass a first argument of %this, however removing 'LegacyInstanceContext' will improve the speed of calling instance methods and at some point we will remove this backward compatibility keyword."
	Set patterns=$order(patterns(""),-1)
}

/// Scan all namespaces on this system looking for code that may not work correctly due to use of unsupported features.
/// You can pass an options <var>SearchList</var> argument which is a mask of which documents to search for.
ClassMethod ScanAll(SearchList As %String = "*.*")
{
	Do List^%SYS.NAMESPACE(.nslist,3,0)
	Set ns="" For  Set ns=$Order(nslist(ns)) Quit:ns=""  Do
	. If ns="%SYS"||(ns="ENSLIB")||(ns="DOCBOOK") Quit
	. New $namespace Set $namespace=ns
	. Do ..Scan(SearchList)
	Quit
}

/// Scan this namespace looking for code that may not work correctly due to use of unsupported features.
/// You can pass an options <var>SearchList</var> argument which is a mask of which documents to search for.
ClassMethod Scan(SearchList As %String = "*.*")
{
	New %SourceControl,%text
	Write "Scanning namespace : ",$namespace
	Do ..SetupPatterns(.patterns)
	Set sc=##class(%RoutineMgr).StudioOpenDialogExecute(.QHandle,SearchList,1,1,0,1,,0)
	If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit

	Set idx=$list(QHandle),found=0
	For i=1:1:patterns {
		Set pattern=patterns(i),name=pattern,case=+$get(patterns(i,"case")),whole=+$get(patterns(i,"whole"))
		Set pattern=$select(case:pattern,1:$zconvert(pattern,"l"))
		If pattern["?"||(pattern["*")||(pattern["\")||(whole) {
			Set pattern=##class(%Studio.Project).pattern(pattern,whole,.wild)
		} Else {
			Set wild=0
		}
		Set %text=$char(13,10,13,10)_"Scanning for '"_name_"' which will cause problems in "_patterns(i,"version")_$char(13,10)_patterns(i,"info")_$char(13,10)
		Set item=""
		For {
			Set item=$order(^||%RoutineList(idx,1,item),1,data) Quit:item=""
			If $extract($list(data),1,7)="EnsLib." Continue
			Do ..searchItem(pattern,$list(data),.found,wild,case,99999999,name,whole)
		}
	}
	Kill ^||%RoutineList(idx)
	If found=0 {
		Write !!,"No potential problems found",!!
	} Else {
		Write !!,"Found "_found_" potential issues",!!
	}
}

/// Search this specific items for the string
ClassMethod searchItem(pattern As %String, Name As %String, ByRef Found As %Integer = 0, wild As %Boolean = 0, CaseSensitive As %Boolean = 1, Max As %Integer = 200, Pattern As %String, WholeWords As %Boolean = 0) As %Boolean [ Private ]
{
#define check(%str,%pat,%case,%wild) $s(%wild:$s('%case:$zcvt(%str,"l"),1:%str)?@%pat,'%case:$zcvt(%str,"l")[%pat,1:%str[%pat) w:%text'="" %text s:%text'="" %text=""
	Set oldFound=Found
	Set name=$piece(Name,".",1,$length(Name,".")-1),type=$zconvert($piece(Name,".",$length(Name,".")),"U")
	If name="" Quit 0
	If Name["/"||(Name["\") {
		Set csp=##class(%CSP.Routine).%New(Name)
		If csp=$$$NULLOREF Quit 0
		If $$$check(name,pattern,CaseSensitive,wild) Write $char(13,10)_Name_": "_Name Set Found=Found+1
		Set trail=""
		For lineno=1:1 {
			If csp.AtEnd Quit
			Set eol=0,line=trail_csp.ReadLine(32000,,.eol),trail=""
			If $$$check(line,pattern,CaseSensitive,wild) Write $char(13,10)_Name_"("_lineno_"): "_$zstrip(line,"<W") Set Found=Found+1 If Found'<Max Quit
			If 'eol Set lineno=lineno-1,trail=$extract(line,*-700,*)
		}
	} ElseIf ##class(%RoutineMgr).UserType(Name,.cls) {
		Do $classmethod(cls,"Search",Name,Pattern,WholeWords,CaseSensitive,Max,.Found)
	} ElseIf type="CLS" {
		If '$data(^oddDEF(name)) Quit 0
		Do ..searchClassNode(Name,"^oddDEF("""_name_""")",$$$cROOTclass,name,pattern,.Found,"",CaseSensitive,Max,wild) 
	} ElseIf $$$rtnIsMAC(type) {
		If '$data(^rMAC(name,0)) Quit 0
		If $$$check(name,pattern,CaseSensitive,wild) Write $char(13,10)_Name_": "_Name Set Found=Found+1
		Set l=0 For lineno=1:1:$get(^rMAC(name,0,0)) If $data(^(lineno),line),$increment(l),$$$check(line,pattern,CaseSensitive,wild) Do  If Found'<Max Quit
		. Write $char(13,10)_Name_"("_l_"): "_$zstrip(line,"<W") Set Found=Found+1
	} ElseIf $$$rtnIsINT(type) {
		If '$data(^ROUTINE(name,0)) Quit 0
		If $$$check(name,pattern,CaseSensitive,wild) Write $char(13,10)_Name_": "_Name Set Found=Found+1
		Set l=0 For lineno=1:1:$get(^ROUTINE(name,0,0)) If $data(^(lineno),line),$increment(l),$$$check(line,pattern,CaseSensitive,wild) Do  If Found'<Max Quit
		. Write $char(13,10)_Name_"("_l_"): "_$zstrip(line,"<W") Set Found=Found+1
	} ElseIf $$$rtnIsINC(type) {
		If '$data(^rINC(name,0)) Quit 0
		If $$$check(name,pattern,CaseSensitive,wild) Write $char(13,10)_Name_": "_Name Set Found=Found+1
		Set l=0 For lineno=1:1:$get(^rINC(name,0,0)) If $data(^(lineno),line),$increment(l),$$$check(line,pattern,CaseSensitive,wild) Do  If Found'<Max Quit
		. Write $char(13,10)_Name_"("_l_"): "_$zstrip(line,"<W") Set Found=Found+1
	} ElseIf type="PRJ" {
		Set prj=##class(%Studio.Project).%OpenId(name)
		If prj'=$$$NULLOREF {
			If $$$check(name,pattern,CaseSensitive,wild) Write $char(13,10)_Name_": "_Name Set Found=Found+1
			Set item="",items=prj.Items
			#; Create list of items in this project.
			Set itemobj=items.GetNext(.item)
			While item'=""&&(Found<Max) {
				If $isobject(itemobj) {
					Set name=itemobj.Name,type=itemobj.Type
					If ..searchItem(Pattern,name_$select(type="CLS":".CLS",1:""),.Found,WholeWords,CaseSensitive,Max)
					Do items.%UnSwizzleAt(item)
				}
				Set itemobj=items.GetNext(.item)
			}
		}
	}
	Quit (oldFound'=Found)
}

/// Search this class for the string
ClassMethod searchClassNode(Name As %String, ref As %String, type As %String, NewName As %String, pattern As %String, ByRef Found As %Integer, Tree As %String, CaseSensitive As %Boolean = 1, Max As %Integer = 200, Wild As %Boolean = 0) [ Private ]
{
#define check(%str,%pat,%case,%wild) $s(%wild:$s('%case:$zcvt(%str,"l"),1:%str)?@%pat,'%case:$zcvt(%str,"l")[%pat,1:%str[%pat) w:%text'="" %text s:%text'="" %text=""
	Set value="",data=$data(@ref,value)
	#;
	#; Check for 'value' nodes e.g property parameters 
	If 'data Quit
	Set line=$translate(Tree,","," ") If $$$check(line,pattern,CaseSensitive,Wild) Do outputMatch If Found'<Max Quit
	Set line=NewName If $$$check(line,pattern,CaseSensitive,Wild) Do outputMatch If Found'<Max Quit
	Set line=value If $$$check(line,pattern,CaseSensitive,Wild) Do outputMatch If Found'<Max Quit
	If data=1 Quit
	Set key="" For  Set key=$Order(@ref@(key)) Quit:key=""  Do  Quit:Found'<Max
	  #; If this key isn't defined for this tnode type then don't output
	. Set external=$$$tableSubSubToExtGet(type,key) If external=""||(external="Name") Quit
	  #; If the keyword is of type "k", that is, its a keyword with a single value
	. If $extract($$$tableTypeGet(type,key))="k" Do
	    #; If this is the implementation we need to output all the subnodes
	. . If $$$tableMultiLineGet(type,key) Do  Quit
	. . . For lineno=1:1:@ref@(key) Do  Quit:Found'<Max
	. . . . Set line=@ref@(key,lineno)
	. . . . If $$$check(line,pattern,CaseSensitive,Wild) Do outputMatch
	. . If $$$check(external,pattern,CaseSensitive,Wild) Set line=@ref@(key) Do outputMatch Quit
	. . Set value=@ref@(key),line=value
	. . If $$$check(line,pattern,CaseSensitive,Wild) Do
	. . . If $length(value,$char(13,10))=1 Do outputMatch Quit
	. . . For lineno=1:1:$length(value,$char(13,10)) Do  Quit:Found'<Max
	. . . . Set line=$piece(value,$char(13,10),lineno)
	. . . . If $$$check(line,pattern,CaseSensitive,Wild) Do outputMatch
	. Else  Do
	. . Set name="" For  Set name=$Order(@ref@(key,name)) Quit:name=""  Do ..searchClassNode(Name,$Extract(ref,1,$Length(ref)-1)_","""_key_""","""_name_""")",key,name,pattern,.Found,Tree_external_","_name_",",CaseSensitive,Max,Wild) Quit:Found'<Max
	Quit
outputMatch Set Found=Found+1,output=$char(13,10)_Name
	If $piece(Tree,",")'="Storage" {
		Set output=output_"("_$piece(Tree,",",2)
		If $get(external)="Implementation" {
			Set output=output_$select($get(lineno)>0:"+"_(lineno),1:"")_")"
		} ElseIf $get(external)="FormalSpec" {
			Write output_"): "_$piece(Tree,",",2)_"(",$zstrip(line,"<W"),")" Quit
		} ElseIf $piece(Tree,",",$length(Tree,",")-2)="Parameter" {
			Set output=output_")" If $length(Tree,",")>4 Set output=output_"["_$piece(Tree,",",$length(Tree,",")-1)_"]"
		} Else {
			Set output=output_")" If $get(external)'="" Set output=output_"["_external_$select($get(lineno)>0:"+"_lineno,1:"")_"]"
		}
	} Else {
		Set output=output_"(Storage)["_$piece(Tree,",",2,$$$MaxStringLength)_$get(external)_"]"
	}
	Write output_": "_$zstrip(line,"<W")
	Quit
}

}
