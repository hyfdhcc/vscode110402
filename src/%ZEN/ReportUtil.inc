ROUTINE %ZEN.ReportUtil [Type=INC]
#; ****** NUMBER FORMATTING ********* ;#
#; could skip using this macro, and have the user directly input format-number()
#; into the field attribute
#define ZENREPORTDEBUG 0
#define celldata $s(..formatNumber="":..qualify(..field),1:"format-number("_..qualify(..field)_","""_..formatNumber_""")")
 
#; ****** HTML STYLING ************** ;#
#define stylehtml Do ..%StyleHTML(.context,.XSL,.delay)
 
#; ***** XSL-FO STYLING ************* ;#
 
#; Returns the style string in the format: %so(attribute)=value
#define createStyleObject(%string,%so) For zz=1:1:$l(%string,";") { If $p($p(%string,";",zz),":",1)'="" { Set:$zstrip($p($p(%string,";",zz),":",1),"<>W")'="" %so($zstrip($p($p(%string,";",zz),":",1),"<>W"))=$zstrip($p($p(%string,";",zz),":",2),"<>W") } }
#define applyclass(%tag,%context) ..%ApplyClass(%tag,%context)
#; following must not be used on table-cell since it will invalidly put a width there
#define stylefo Do ..%StyleXSLFO(.context,.XSL,.delay,0) 
 
#; *** XSL-FO SPECIAL CHARACTERS **** ;# 
 
#define nbsp "&#160;"
 
#; *** GROUP CONTEXT MACROS *** 
 
#define groupNum			$g(context("SubReport"))_$g(context("GroupID"))
#define groupNumInc			Set context("GroupID") = $g(context("GroupID")) + 1
#define groupNumSet(%val)	Set context("GroupID") = %val
 
#; *** TABLE CONTEXT MACROS
 
#define tableNum			$g(context("TableID"))
#define tableNumInc			Set context("TableID") = $$$tableNum + 1
#define tableNumSet(%val)	Set context("TableID") = %val
 
#; *** ITEM CONTEXT MACROS ***
 
#define itemNum			$g(context("ItemID"))
#define itemNumInc			Set context("ItemID") = $$$itemNum + 1
#define itemNumSet(%val)	Set context("ItemID") = %val
 
#; *** CAPTION CONTEXT MACROS ***
 
#define captionNum			$g(context("CaptionID"))
#define captionNumInc			Set context("CaptionID") = $$$captionNum + 1
#define captionNumSet(%val)	Set context("CaptionID") = %val
 
#; *** VARIABLE CONTEXT MACROS ***
 
#define varNum			$g(context("VariableID"))
#define varNumInc			Set context("VariableID") = $$$varNum + 1
#define varNumSet(%val)	Set context("VariableID") = %val
 
#; LEVEL MACROS
#define levelNumInit Set context("LevelID") = -1
#define levelNum (+$g(context("LevelID")))
#define levelNumInc Set context("LevelID") = $$$levelNum + 1
#define levelNumDec Set context("LevelID") = $$$levelNum - 1
 
#; *** CHART GLOBAL VARIABLE NAMES ** ;# 
 
#define seriescount			"seriescount"
#define seriessize			"seriessize"
#define dataXMax				"dataXMax"
#define dataXMin				"dataXMin"
#define dataYMax				"dataYMax"
#define dataYMin				"dataYMin"
 
#define xMax 				"xMax"
#define xMin 				"xMin"
#define xRange				"xRange"
#define xRangeMax			"xRangeMax"
#define xRangeMin			"xRangeMin"
#define xMajorUnits			"xMajorUnits"
#define xMinorUnits			"xMinorUnits"
#define xLabelUnits			"xLabelUnits"
#define xBase				"xBase"
 
#define yMax 				"yMax"
#define yMin 				"yMin"
#define yRange				"yRange"
#define yRangeMax			"yRangeMax"
#define yRangeMin			"yRangeMin"
#define yMajorUnits			"yMajorUnits"
#define yMinorUnits			"yMinorUnits"
#define yLabelUnits			"yLabelUnits"
#define yBase				"yBase"
 
#define REPLACE(%x,%o,%n) ##class(%ZEN.Report.reportPage).replace(%x,%o,%n)
#define THIS $this

#define CEIL(%x) $SYSTEM.SQL.CEILING(%x)
#define FLOOR(%x) $SYSTEM.SQL.FLOOR(%x)
#define ROUND(%x) $NORMALIZE(%x,0)
#define TOFIXED(%x,%d) $Normalize(%x,%d)
#define ISNAN(%x) $$isNaN^%occZENReports(%x)
#define PARSEFLOAT(%x) $$parseFloat^%occZENReports(%x)
#define PARSEINT(%x) $$parseInt^%occZENReports(%x)
#define MIN(%x,%y) $s((%x) < (%y): (%x), 1:(%y))
#define MAX(%x,%y) $s((%x) > (%y): (%x), 1:(%y))
#define TOUPPERCASE(%s) $zcvt(%s,"u")
#define TOLOWERCASE(%s) $zcvt(%s,"l")
#define mkf(%d,%n) ##class(%SYS.ZENReportServer).MakeFileName(%d,%n)
#define pdfbox "pdfbox-app-1_7_1.jar"
#define commonlogging "commons-logging-1_0_4.jar"
#define pdfboxpath $s($$$isVMS:$$$mkf("fop.lib",$$$pdfbox),$$$isUNIX:$$$mkf("fop/lib",$$$pdfbox),1:$$$mkf("fop\lib",$$$pdfbox))
#define pdfboxclasspath $$$pdfboxpath_$s($$$isVMS:",",$$$isUNIX:":",1:";")_$s($$$isVMS:$$$mkf("fop.lib",$$$commonlogging),$$$isUNIX:$$$mkf("fop/lib",$$$commonlogging),1:$$$mkf("fop\lib",$$$commonlogging))
#define saxjar $s($$$isVMS:$$$mkf("fop.lib","saxon9he.jar"),$$$isUNIX:$$$mkf("fop/lib","saxon9he.jar"),1:$$$mkf("fop\lib","saxon9he.jar"))
#define fopbat $s($$$isVMS:$$$mkf("fop","fop.com"),$$$isUNIX:$$$mkf("fop","fop"),1:$$$mkf("fop","fop.bat"))
#define fopconfig $s($$$isVMS:$$$mkf("fop.conf","fop.xconf"),$$$isUNIX:$$$mkf("fop/conf","fop.xconf"),1:$$$mkf("fop\conf","fop.xconf"))
#define GETPARAMETER(%n) ..%GetParam(%n)
#define GETCODEGENPARAMETER(%n) ..%GetCodeGenParam(%n)
#define exceljar $s($$$isVMS:$$$mkf("lib.ExcelExporter","excelexporter.jar"),$$$isUNIX:$$$mkf("lib/ExcelExporter","excelexporter.jar"),1:$$$mkf("lib\ExcelExporter","excelexporter.jar"))
#define toexcel $s($$$isVMS:$$$mkf("lib.ExcelExporter","toexcel.xsl"),$$$isUNIX:$$$mkf("lib/ExcelExporter","toexcel.xsl"),1:$$$mkf("lib\ExcelExporter","toexcel.xsl"))
#define workbook $s($$$isVMS:$$$mkf("lib.ExcelExporter","workbook.xml"),$$$isUNIX:$$$mkf("lib/ExcelExporter","workbook.xml"),1:$$$mkf("lib\ExcelExporter","workbook.xml"))
#define toexcelmultisheet $s($$$isVMS:$$$mkf("lib.ExcelExporter","toexcelmultiworksheet.xsl"),$$$isUNIX:$$$mkf("lib/ExcelExporter","toexcelmultiworksheet.xsl"),1:$$$mkf("lib\ExcelExporter","toexcelmultiworksheet.xsl"))
#define toexcelfromattribute $s($$$isVMS:$$$mkf("lib.ExcelExporter","toexcelfromattribute.xsl"),$$$isUNIX:$$$mkf("lib/ExcelExporter","toexcelfromattribute.xsl"),1:$$$mkf("lib\ExcelExporter","toexcelfromattribute.xsl"))
#define excelbat $s($$$isVMS:$$$mkf("lib.ExcelExporter","run.com"),$$$isUNIX:$$$mkf("lib/ExcelExporter","run"),1:$$$mkf("lib\ExcelExporter","run.bat"))
  
#define OptionCachePath (1)
#define OptionConserve (2)
#define OptionDPI (3)
#define OptionEnableAccessibility (4)
#define OptionFlush (5)
#define OptionLang (6)
#define OptionNoAccessContent (7)
#define OptionNoAnnotations (8)
#define OptionNoAssembleDoc (9)
#define OptionNoComplexScript (10)
#define OptionNoCopy (11)
#define OptionNoEdit (12)
#define OptionNoFillInForms (13)
#define OptionNoPrint (14)
#define OptionNoPrintHq (15)
#define OptionOwnerPassword (16)
#define OptionPDFProfile (17)
#define OptionRelaxed (18)
#define OptionUserPassword (19)

#define GETJAVA $$GetJava^%occZENReports