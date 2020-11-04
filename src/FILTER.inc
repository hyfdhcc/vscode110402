ROUTINE FILTER [Type=INC]
;%filter.inc   -- dispatch calls to %FILTER for utility inclusion
 
 
#ifndef %filter
#define %filter
 
 ;open up a filter channel                               (width,length)
#def1arg FOpen(%arg) D OPEN^%FILTER(%arg)
 
 ;close the filter channel,                                no arguments
#def1arg FClose(%a)  D CLOSE^%FILTER(%a)
 
 ;write text after a new line                      (text,# extra-lines)
#def1arg FWrite(%a)  D NEWLN^%FILTER(%a)
 
 ;append text to the end of the current line                     (text)
#def1arg FAppnd(%a)  D WRITE^%FILTER(%a)
 
 ;center text, optional linefeeds, use defined width       (text,lines)
#def1arg FCC(%a)     D CC^%FILTER(%a)
 
 ;flush-right text, optional linefeeds, use defined width  (text,lines)
#def1arg FRT(%a)     D RT^%FILTER(%a)
 
 ;insert spaces to a column, add optional text            (column,text)
#def1arg FTab(%a)    D TAB^%FILTER(%a)
 
 ;append bold text to end of line, with option linefeeds   (text,lines)
#def1arg FBold(%a)   D BOLD^%FILTER(%a)
 
 ;append bold text to end of line, with option linefeeds   (text,lines)
#def1arg FUlin(%a)   D ULIN^%FILTER(%a)
 
 ;append bold text to end of line, with option linefeeds   (text,lines)
#def1arg FRvid(%a)   D RVID^%FILTER(%a)
 
 ;return the column position of the end of the line,       no arguments
#def1arg FX(%a)      $$X^%FILTER(%a)
 
 ;return the current line width
#def1arg FWid(%a)    $$WID^%FILTER(%a)
 
 ;return the current page length
#def1arg FLen(%a)    $$LEN^%FILTER(%a)
 
#if $G(%simple)
 
#def1arg FOpen(%a)  S %filter=1
#def1arg FClose(%a) K %filter
#def1arg FX(%a)     $X
#def1arg FWid(%a)   80
#def1arg FLen(%a)   23
#def1arg FTab(%a)   D SIMTab^%FILTER(%a)
#def1arg FWrite(%a) D SIMWrt^%FILTER(%a)
#def1arg FAppnd(%a) D SIMApp^%FILTER(%a)
#def1arg FBold(%a)  D SIMBld^%FILTER(%a)
#def1arg FUlin(%a)  D SIMUln^%FILTER(%a)
#def1arg FRvid(%a)  D SIMRvd^%FILTER(%a)
#define  FCC(%x)    W ?80-$L($G(%x))\2,$G(%x)
#define  FRT(%x)    W ?80-$L($G(%x)),$G(%x)
 
#endif simple
 
#endif %filter