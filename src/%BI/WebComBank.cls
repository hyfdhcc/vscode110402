Class %BI.WebComBank [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod boundUpId()
{
	s x="" f  s x=$O(^BI.ImageListD(x)) q:x=""||(x>10000)  d
	. s ^BI.ImageListD(x+10000)=^BI.ImageListD(x)
	. k ^BI.ImageListD(x)
	s ^BI.ImageListD=$G(^BI.ImageListD)+10000
}

ClassMethod deleteCom(comId As %Integer, type As %String)
{
	;i $$chkIfCanAccess^%bi.SWr.WebMain2(4,comId,"",3)=1 {	
	i type = "img" {s ok = ##class(%BI.ImageList).%DeleteId(comId)}
		else {s ok = ##class(%BI.TextList).%DeleteId(comId)}
		i ok
		{	d BuildMenu^%bi.SWr.Trees(3)
			;w "drawTree (""pivTree"", '', menu, theme, 2, 2);"
			//w "ctDraw (""pivotTree"", menu, ctThemeXP1, ""ThemeXP"",0,0,2,1,0);"
		}
	;} else {w "alert('Permission denied. You are not allowed to delete this image.');"}
}

ClassMethod initImg()
{
	i $$IsSpeed^%bi.SMr.SpeedL {s img("gen",1,"Hesper Logo")="Hesper.jpg",img("gen",2,"Speedminer Logo")="Speedminer.jpg"}
	else {s img("gen",1,"Intersystems Logo")="Intersystems.gif",img("gen",2,"DeepSee Logo")="DeepSee.jpg"}
	;s img("gen","Trak Logo")="Trak.jpg"
	
	s img("btn",1,"Blue Button")="btnBlue.gif"
	s img("btn",2,"Grey Button")="btnGrey.gif"
	s img("btn",3,"Round Blue Button")="rBtnBlue.gif"
	s img("btn",4,"Round Green Button")="rBtnGreen.gif"
	s img("btn",5,"Round Red Button")="rBtnRed.gif"
	s img("btn",6,"Round Yellow Button")="rBtnYellow.gif"
	s img("btn",7,"Small Blue Button")="sBtnBlue.gif"
	s img("btn",8,"Small Grey Button")="sBtnGrey.gif"
	s img("btn",9,"Small Round Blue Button")="sRBtnBlue.gif"
	s img("btn",10,"Small Round Green Button")="sRBtnGreen.gif"
	s img("btn",11,"Small Round Red Button")="sRBtnRed.gif"
	s img("btn",12,"Small Round Yellow Button")="sRBtnYellow.gif"
	s img("btn",13,"Rectangular Blue Button")="rtBtnBlue.bmp"
	s img("btn",14,"Rectangular Green Button")="rtBtnGreen.bmp"
	s img("btn",15,"Rectangular Orange Button")="rtBtnOrange.bmp"
	s img("btn",16,"Rectangular Red Button")="rtBtnRed.bmp"
	
	s img("map","Malaysia",1,0,0)=""
	s img("map","Malaysia",1,0,1)=""
	s img("map","Malaysia",1,0,2)=""
	s img("map","Malaysia",1,0,3)=""
	s img("map","Malaysia",1,0,4)=""
	s img("map","Malaysia",1,0,5)=""
	s img("map","Malaysia",1,1,0)=""
	s img("map","Malaysia",1,1,1)=""
	s img("map","Malaysia",1,1,2)=""
	s img("map","Malaysia",1,1,3)=""
	s img("map","Malaysia",1,1,4)=""
	s img("map","Malaysia",1,1,5)=""
	s img("map","Malaysia",1,2,0)=""
	s img("map","Malaysia",1,2,1)=""
	s img("map","Malaysia",1,2,2)=""
	s img("map","Malaysia",1,2,3)=""
	s img("map","Malaysia",1,2,4)=""
	s img("map","Malaysia",1,2,5)=""
	s img("map","Malaysia",1,3,0)=""
	s img("map","Malaysia",1,3,1)=""
	s img("map","Malaysia",1,3,2)=""
	s img("map","Malaysia",1,3,3)=""
	s img("map","Malaysia",1,3,4)=""
	s img("map","Malaysia",1,3,5)=""
	s img("map","Malaysia",1,4,0)=""
	s img("map","Malaysia",1,4,1)=""
	s img("map","Malaysia",1,4,2)=""
	s img("map","Malaysia",1,4,3)=""
	s img("map","Malaysia",1,4,4)=""
	s img("map","Malaysia",1,4,5)=""
	s img("map","Malaysia",1,5,0)=""
	s img("map","Malaysia",1,5,1)=""
	s img("map","Malaysia",1,5,2)=""
	s img("map","Malaysia",1,5,3)=""
	s img("map","Malaysia",1,5,4)=""
	s img("map","Malaysia",1,5,5)=""
	s img("map","Malaysia",1,6,0)=""
	s img("map","Malaysia",1,6,1)=""
	s img("map","Malaysia",1,6,2)=""
	s img("map","Malaysia",1,6,3)=""
	s img("map","Malaysia",1,6,4)=""
	s img("map","Malaysia",1,6,5)=""
	
	s img("map","Malaysia",2,0,0)=""
	
	s img("map","Malaysia",3,0,0)=""
	s img("map","Malaysia",3,0,1)=""
	s img("map","Malaysia",3,0,2)=""
	s img("map","Malaysia",3,1,0)=""
	s img("map","Malaysia",3,1,1)=""
	s img("map","Malaysia",3,1,2)=""
	
	;k ^BI.ImageListD 
	s ip="library/img/"
	s ^BI.ImageListD=0,^BI.FolderD=1
	s parId=$P($$AddFolder^%bi.SMr.Folder1(0),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(0,parId,"Library")
	s foldId=$P($$AddFolder^%bi.SMr.Folder1(parId),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(parId,foldId,"Image")
	s x="" f  s x=$O(img("gen",x)) q:x=""  d
	. s img=##class(%BI.ImageList).%New()
	. s img.ImageName=$O(img("gen",x,"")),img.FileName=ip_img("gen",x,img.ImageName),img.Folder=foldId
	. d img.%Save()
	s parId=foldId
	s foldId=$P($$AddFolder^%bi.SMr.Folder1(parId),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(parId,foldId,"Button")
	s fButton=foldId
	s x="" f  s x=$O(img("btn",x)) q:x=""  d
	. s img=##class(%BI.ImageList).%New()
	. s name=$O(img("btn",x,""))
	. s img.ImageName=name,img.FileName=ip_"button/"_img("btn",x,name),img.Folder=foldId
	. d img.%Save()
	
	s foldId=$P($$AddFolder^%bi.SMr.Folder1(parId),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(parId,foldId,"Arrow")
	s fArrow=foldId
	
	/*
	s ^BI.ImageListD(87)=$LB("Black Up Arrow",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"arrow/uArrBlack.gif")
	s ^BI.ImageListD(88)=$LB("Black down Arrow",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"arrow/dArrBlack.gif")
	s ^BI.ImageListD(89)=$LB("Blue Up Arrow",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"arrow/uArrBlue.gif")
	s ^BI.ImageListD(90)=$LB("Blue down Arrow",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"arrow/dArrBlue.gif")
	s ^BI.ImageListD(91)=$LB("Dark Green Up Arrow",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"arrow/uArrDGreen.gif")
	s ^BI.ImageListD(92)=$LB("Dark Green down Arrow",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"arrow/dArrDGreen.gif")
	*/
	
	s foldId=$P($$AddFolder^%bi.SMr.Folder1(parId),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(parId,foldId,"Flag")
	s fFlag=foldId

	/*
	s ^BI.ImageListD(93)=$LB("Austrian Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/austria.bmp")
	s ^BI.ImageListD(94)=$LB("Brazilian Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/brazil.bmp")
	s ^BI.ImageListD(95)=$LB("Canadian Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/canada.bmp")
	s ^BI.ImageListD(96)=$LB("Denmark Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/denmark.bmp")
	s ^BI.ImageListD(97)=$LB("Finland Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/finland.bmp")
	s ^BI.ImageListD(98)=$LB("French Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/france.bmp")
	s ^BI.ImageListD(99)=$LB("German Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/germany.bmp")
	s ^BI.ImageListD(100)=$LB("Irish Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/ireland.bmp")
	s ^BI.ImageListD(101)=$LB("Italian Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/italy.bmp")
	s ^BI.ImageListD(102)=$LB("Mexican Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/mexico.bmp")
	s ^BI.ImageListD(103)=$LB("Norwegian Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/norway.bmp")
	s ^BI.ImageListD(104)=$LB("Polish Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/poland.bmp")
	s ^BI.ImageListD(105)=$LB("Portugese Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/portugal.bmp")
	s ^BI.ImageListD(106)=$LB("Spanish Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/spain.bmp")
	s ^BI.ImageListD(107)=$LB("Swedish Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/sweden.bmp")
	s ^BI.ImageListD(108)=$LB("Switzerland Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/switzerland.bmp")
	s ^BI.ImageListD(109)=$LB("UK Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/uk.bmp")
	s ^BI.ImageListD(110)=$LB("American Flag",foldId,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"Flags/usa.bmp")
	*/
	
	s foldId=$P($$AddFolder^%bi.SMr.Folder1(parId),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(parId,foldId,"map")
	s parId=foldId
	
	s w="" f  s w=$O(img("map",w)) q:w=""  d
	. s foldId=$P($$AddFolder^%bi.SMr.Folder1(parId),$C(2),1)
	. d RenFolder^%bi.SMr.Folder1(parId,foldId,w)
	. s img=##class(%BI.ImageList).%New()
	. s img.ImageName=w,img.FileName=ip_"map/"_w_"/"_w_".jpg",img.Folder=foldId
	. d img.%Save() 
	. s x="" f  s x=$O(img("map",w,x)) q:x=""  d
	.. s foldId2=$P($$AddFolder^%bi.SMr.Folder1(foldId),$C(2),1)
	.. d RenFolder^%bi.SMr.Folder1(foldId,foldId2,"Level "_x)
	.. s y="" f  s y=$O(img("map",w,x,y)) q:y=""  d
	... s z="" f  s z=$O(img("map",w,x,y,z)) q:z=""  d
	.... s img=##class(%BI.ImageList).%New()
	.... s img.ImageName="R"_y_" C"_z,img.FileName=ip_"map/"_w_"/level"_x_"/"_"R"_y_"C"_z_".jpg",img.Folder=foldId2
	.... d img.%Save()
	d img.%Close()
	
	s foldId2=$P($$AddFolder^%bi.SMr.Folder1(foldId),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(foldId,foldId2,"KL")
	s img=##class(%BI.ImageList).%New(),img.ImageName="KL",img.FileName=ip_"map/malaysia/kl/kl.jpg",img.Folder=foldId2 d img.%Save()
	;s ^BI.ImageListD(70)=$LB("KL",foldId2,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/kl/kl.jpg")
	s foldId3=$P($$AddFolder^%bi.SMr.Folder1(foldId2),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(foldId2,foldId3,"Level 1")
	
	s img=##class(%BI.ImageList).%New(),img.ImageName="R0 C0",img.FileName=ip_"map/malaysia/kl/level1/R0C0.jpg",img.Folder=foldId3 d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="R0 C1",img.FileName=ip_"map/malaysia/kl/level1/R0C1.jpg",img.Folder=foldId3 d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="R1 C0",img.FileName=ip_"map/malaysia/kl/level1/R1C0.jpg",img.Folder=foldId3 d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="R1 C1",img.FileName=ip_"map/malaysia/kl/level1/R1C1.jpg",img.Folder=foldId3 d img.%Save()
	/*
	s ^BI.ImageListD(71)=$LB("R0 C0",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/kl/level1/R0C0.jpg")
	s ^BI.ImageListD(72)=$LB("R0 C1",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/kl/level1/R0C1.jpg")
	s ^BI.ImageListD(73)=$LB("R1 C0",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/kl/level1/R1C0.jpg")
	s ^BI.ImageListD(74)=$LB("R1 C1",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/kl/level1/R1C1.jpg")
	*/
	s foldId3=$P($$AddFolder^%bi.SMr.Folder1(foldId2),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(foldId2,foldId3,"Level 2")
	
	s img=##class(%BI.ImageList).%New(),img.ImageName="R0 C0",img.FileName=ip_"map/malaysia/kl/level2/R0C0.jpg",img.Folder=foldId3 d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="R0 C1",img.FileName=ip_"map/malaysia/kl/level2/R0C1.jpg",img.Folder=foldId3 d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="R1 C0",img.FileName=ip_"map/malaysia/kl/level2/R1C0.jpg",img.Folder=foldId3 d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="R1 C1",img.FileName=ip_"map/malaysia/kl/level2/R1C1.jpg",img.Folder=foldId3 d img.%Save()
	/*
	s ^BI.ImageListD(75)=$LB("R0 C0",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/kl/level2/R0C0.jpg")
	s ^BI.ImageListD(76)=$LB("R0 C1",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/kl/level2/R0C1.jpg")
	s ^BI.ImageListD(77)=$LB("R1 C0",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/kl/level2/R1C0.jpg")
	s ^BI.ImageListD(78)=$LB("R1 C1",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/kl/level2/R1C1.jpg")
	*/
	
	s foldId2=$P($$AddFolder^%bi.SMr.Folder1(foldId),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(foldId,foldId2,"Penang")
	
	s img=##class(%BI.ImageList).%New(),img.ImageName="Penang",img.FileName=ip_"map/malaysia/penang/penang.jpg",img.Folder=foldId2 d img.%Save()
	;s ^BI.ImageListD(79)=$LB("Penang",foldId2,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/penang/penang.jpg")
	s foldId3=$P($$AddFolder^%bi.SMr.Folder1(foldId2),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(foldId2,foldId3,"Level 1")
	
	s img=##class(%BI.ImageList).%New(),img.ImageName="R0 C0",img.FileName=ip_"map/malaysia/penang/level1/R0C0.jpg",img.Folder=foldId3 d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="R0 C1",img.FileName=ip_"map/malaysia/penang/level1/R0C1.jpg",img.Folder=foldId3 d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="R1 C0",img.FileName=ip_"map/malaysia/penang/level1/R1C0.jpg",img.Folder=foldId3 d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="R1 C1",img.FileName=ip_"map/malaysia/penang/level1/R1C1.jpg",img.Folder=foldId3 d img.%Save()
	/*
	s ^BI.ImageListD(80)=$LB("R0 C0",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/penang/level1/R0C0.jpg")
	s ^BI.ImageListD(81)=$LB("R0 C1",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/penang/level1/R0C1.jpg")
	s ^BI.ImageListD(82)=$LB("R1 C0",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/penang/level1/R1C0.jpg")
	s ^BI.ImageListD(83)=$LB("R1 C1",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/penang/level1/R1C1.jpg")
	*/
	s foldId3=$P($$AddFolder^%bi.SMr.Folder1(foldId2),$C(2),1)
	d RenFolder^%bi.SMr.Folder1(foldId2,foldId3,"Level 2")
	
	s img=##class(%BI.ImageList).%New(),img.ImageName="R0 C0",img.FileName=ip_"map/malaysia/penang/level2/R0C0.jpg",img.Folder=foldId3 d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="R1 C0",img.FileName=ip_"map/malaysia/penang/level2/R1C0.jpg",img.Folder=foldId3 d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="R2 C0",img.FileName=ip_"map/malaysia/penang/level2/R2C0.jpg",img.Folder=foldId3 d img.%Save()
	/*
	s ^BI.ImageListD(84)=$LB("R0 C0",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/penang/level2/R0C0.jpg")
	s ^BI.ImageListD(85)=$LB("R1 C0",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/penang/level2/R1C0.jpg")
	s ^BI.ImageListD(86)=$LB("R2 C0",foldId3,"",$LB("<<$C(0,23,1,19,1)_""^BI.ImageListS""_$C(2,1,2,1)>>","%GlobalBinaryStream"),"map/malaysia/penang/level2/R2C0.jpg")
	*/
	
	s foldId=fArrow
	s img=##class(%BI.ImageList).%New(),img.ImageName="Black Up Arrow",img.FileName=ip_"arrow/uArrBlack.gif",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Black down Arrow",img.FileName=ip_"arrow/dArrBlack.gif",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Blue Up Arrow",img.FileName=ip_"arrow/uArrBlue.gif",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Blue Down Arrow",img.FileName=ip_"arrow/dArrBlue.gif",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Dark Green Up Arrow",img.FileName=ip_"arrow/uArrDGreen.gif",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Dark Green Down Arrow",img.FileName=ip_"arrow/dArrDGreen.gif",img.Folder=foldId d img.%Save()

	s foldId=fFlag	
	s img=##class(%BI.ImageList).%New(),img.ImageName="Austrian Flag",img.FileName=ip_"Flags/austria.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Brazilian Flag",img.FileName=ip_"Flags/brazil.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Canadian Flag",img.FileName=ip_"Flags/canada.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Denmark Flag",img.FileName=ip_"Flags/denmark.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Finland Flag",img.FileName=ip_"Flags/finland.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="French Flag",img.FileName=ip_"Flags/france.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="German Flag",img.FileName=ip_"Flags/germany.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Irish Flag",img.FileName=ip_"Flags/ireland.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Italian Flag",img.FileName=ip_"Flags/italy.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Mexican Flag",img.FileName=ip_"Flags/mexico.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Norwegian Flag",img.FileName=ip_"Flags/norway.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Polish Flag",img.FileName=ip_"Flags/poland.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Portugese Flag",img.FileName=ip_"Flags/portugal.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Spanish Flag",img.FileName=ip_"Flags/spain.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Swedish Flag",img.FileName=ip_"Flags/sweden.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Switzerland Flag",img.FileName=ip_"Flags/switzerland.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="UK Flag",img.FileName=ip_"Flags/uk.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="American Flag",img.FileName=ip_"Flags/usa.bmp",img.Folder=foldId d img.%Save()
	
	s foldId=fButton
	s img=##class(%BI.ImageList).%New(),img.ImageName="Rectangular Blue Button 2",img.FileName=ip_"button/rtBtnBlue2.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Rectangular Orange Button 2",img.FileName=ip_"button/rtBtnOrange2.bmp",img.Folder=foldId d img.%Save()
	s img=##class(%BI.ImageList).%New(),img.ImageName="Rectangular Blue Button 3",img.FileName=ip_"button/rtBtnBlue3.bmp",img.Folder=foldId d img.%Save()
	
	i $G(^BI.ImageListD)<10000 s ^BI.ImageListD=10000
}

ClassMethod reInitImg()
{
	s:^BI.FolderD>=10000 temp=^BI.FolderD s:^BI.ImageListD>=10000 temp2=^BI.ImageListD
	f x=2:1:17 k ^BI.FolderD(x)
	k ^BI.FolderI
	d ##class(%BI.WebComBank).initImg()
	k ^BI.FolderI
	d ReIdxFolder^%bi.SMr.Setup
	s:$D(temp) ^BI.FolderD=temp s:$D(temp2) ^BI.ImageListD=temp2
}

ClassMethod saveCom(comId As %String, comName As %String, folderId As %Integer, type As %String, val As %String)
{
	i type = "img"
	{	s obj = ##class(%BI.ImageList).%OpenId(comId)
		i obj = "" {s obj = ##class(%BI.ImageList).%New()}
		s obj.ImageName = comName
		s obj.LoadToMemory = $piece(val,",",2)
		s obj.Picture = ""
		s ok = obj.%Save()
		i 'ok
		{	w "saved=0;"
			quit
		}
		s id = obj.%Id() ;s id = $O(^BI.ImageListD(""),-1) + 1
		s obj.FileName = id _ "." _ $piece(val,",",1)
		w "fileName='" _ obj.FileName _ "';"
	}
	else
	{	s obj = ##class(%BI.ImageList).%OpenId(comId)
		i obj = "" {s obj = ##class(%BI.TextList).%New()}
		s obj.TextName = comName
		s obj.Text = val
	}
	s obj.Folder = folderId
	s ok = obj.%Save()
	w "saved=" _ ok _ ";"
	d obj.%Close()
}

ClassMethod showPic(imgId As %String)
{
	set thePicStr=..GetPic(imgId)
	w "imgHTML = ""<img id=img src='" _ thePicStr _ "'>"";"
}

ClassMethod GetPic(imgId As %String) As %String
{
	s pico = ##class(%BI.ImageList).%OpenId(imgId) q:pico="" ""
	i pico.FileName = ""
	{	s dbPic = pico.Picture.GetStreamId()
		s bgPicStream = ##class(%CSP.Page).EscapeURL(##class(%CSP.Page).Encrypt(dbPic))
		s thePicStr = "%25CSP.StreamServer.cls?STREAMOID=" _ bgPicStream
	}
	else 
	{	i $E(pico.FileName,1,14)="uploadedFiles/" {s pico.FileName="img/"_$E(pico.FileName,15,99999) d pico.%Save()}
		s thePicStr = $S(imgId<10000:"",1:$TR($G(^SYS("BI","CFG","Configuration","Path",0,6)),"\","/"))_pico.FileName /*fileName $S(imgId>10000:"uploadedFiles/",1:"library/img/") _ fileName}*/
	}
	d pico.%Close()
	quit thePicStr
}

}
