Class %BI.EdmundPageCSP [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod CreateCell(GetValue)
{
		set p =##class(%BI.EdmundPage).%New()
		set value=GetValue
		
		s dispData="<table border=1>"
		s dispData=dispData_"<tr>"
		s dispData=dispData_"<th> Name"
		s dispData=dispData_"<th> Description"
		s dispData=dispData_"</tr>"
		s x=0
			WHILE value > 0
 		 {
 		 	;s dispData=dispData_"here"
    		s dispData=dispData_"<tr colspan=2>"
    		s dispData=dispData_"<td ><input id=""a"_x_""" type=text size=15 /></td>"
    		s dispData=dispData_"<td><input  id=""b"_x_""" type=text size=20 /></td>"
    		s dispData=dispData_"</tr>"
    		;WRITE !,"looping "
    		SET value=value-1
    		 s x=x+1
  
    }
  		s dispData=dispData_"</table>"
  		
  		w "abc.innerHTML="_##class(%CSP.Page).QuoteJS(dispData)_";"
  		
  		s CreateButton ="<br><br><input type=button value=""Save"" onclick=""SaveCell()"" />"
  		w "ButtonTD.innerHTML='"_CreateButton_"';"
}

ClassMethod SaveRecord(Category1, ElementNum, ArrN, ArrD)
{
	
	s y=1
	s p =##class(%BI.EdmundPage).%New()
	s p.Category = Category1
	s p.NumElement = ElementNum
	;do p.%Save()
	
	WHILE ElementNum >= y
	
	{	;c
		;x "s t"_y_"= """""	
		;s ^EdDiagnos="s t"_y_"= """""
		;s t =##class(%BI.SubCategory).%New()
		s t = ##class(%BI.SubCategory).%New()
		
		;x "s temp="""""
		;x "s temp = $p(ArrN, ""^"" ,"y")
		;x "s temp2 = $p(ArrN, ""^"" ,"y")
		
		s temp1 = $p(ArrN, "^", y)
		s temp2 = $p(ArrD, "^", y)
		
		;do t.Name.Insert(temp)
		
		s t.Name = temp1
		s t.Desc = temp2
		
		;do t.Name.InsertAt(temp,y) 
			
		;w "alert('"_temp_"');"
		;w "alert('"_temp2_"');"
		;if (y=1) {
		;s ^EdDiagnos2="s t"_y_".MainCat = p"
		s t.MainCat = p

		;w "alert('hi')"
		;s t1.MainCat = p
		;	}
		;ElseIf (y=2){
			;}
			
		s y=y+1
		do p.%Save()
	}
	;s t.Desc = ArrD
	
	;do t.%Save()
	w "alert('Success to added!');"
}

ClassMethod showCat(abc)
{
   
	
	s p = ##class(%ResultSet).%New("%BI.EdmundPage:GetCategory")
	s loop=0
	do p.Execute()
	while p.Next() {
		s loop=loop+1
		&js<
			var newOption=document.createElement("option")
			newOption.innerHTML="#(p.Data("Category"))#"
			newOption.value="#(p.Data("Category"))#"
			cmbCat.appendChild(newOption)
	
			>
		s count1 = p.Data("NumElement")
		
		
		if (loop=1)
		{
			s m = ##class(%ResultSet).%New("%BI.EdmundPage:GetSubCategory")
			d m.Execute(abc)
			s inc=1
			do m.Next()
			
  			s display = "<table border=1>"
			s display=display_"<tr>"
			s display=display_"<th> Name "
			s display=display_"<th> Description"
			s display=display_"</tr>"
			
			s t = ##class(%BI.EdmundPage).%OpenId(m.Data("ID"))
			
			s appendData1=""
			while count1 > 0
			{		
			s NameData = t.ChildCat.GetAt(inc).Name
			s DescData = t.ChildCat.GetAt(inc).Desc
			s appendData1=appendData1_"<tr><td>"
			s appendData1=appendData1_NameData_"</td><td>"
			s appendData1=appendData1_DescData_"</td></tr>"
			s inc= inc + 1
			s count1 = count1-1
			}
			s display=display_appendData1
			s display=display_"</table>"
			w "SubCat.innerHTML='"_display_"';"
		}
		
		}
}

ClassMethod showSubCat(value)
{
	
	s inc=1
	s NameData=""
	s DescData=""
	
	s p1 = ##class(%ResultSet).%New("%BI.EdmundPage:GetSubCategory")
	
	do p1.Execute(value)
	do p1.Next()
		s count = p1.Data("NumElement")
 	  	s display = "<table border=1>"
		s display=display_"<tr>"
		s display=display_"<th> Name "
		s display=display_"<th> Description"
		s display=display_"</tr>"
		
	s t1 = ##class(%BI.EdmundPage).%OpenId(p1.Data("ID"))	
	
	s appendData=""
	
		while count > 0
		{		
			s NameData = t1.ChildCat.GetAt(inc).Name
			s DescData = t1.ChildCat.GetAt(inc).Desc
			s appendData=appendData_"<tr><td>"
			s appendData=appendData_NameData_"</td><td>"
			s appendData=appendData_DescData_"</td></tr>"
			s inc= inc + 1
			s count =  count - 1
			;w NameData,DescData
			;&js<alert("#(NameData)#"+" "+"#(DescData)#");>	
			}
	;w count 
	s display=display_appendData
	s display=display_"</table>"
	w "SubCat.innerHTML='"_display_"';"
}

}
