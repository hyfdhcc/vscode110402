ROUTINE ISCETAD [Type=INC]
 ;ISCETAD.INC   ;HYY110  7/18/97
#ifndef ISCETAD
#define ISCETAD
 ;
#;      ; given a date, return the number of days since 1840/12/31 thru the date
#;      ; knowing little about calendar years, this routine relies on $ZDATE
#;      ; input format: YYYY,MM,DD ($$ETAD) or YYYYMMDD ($$etad)
 ;
#if 0   ;HYY110+
etad(date)
 N (date)
 S year=$E(date,1,4),month=$E(date,5,6),day=$E(date,7,8)
#if 0   ;HYY073+
 S days=(((year-1841)*365.25)+((month-1)*30.4)+day+0.5)\1 ;approximate
 F  D  Q:d=date
 . S zdate=$ZDATE(days),d=$P(zdate,"/",3)_$P(zdate,"/",1)_$P(zdate,"/",2)
 . S:$L(d)<8 d="19"_d ;$ZDATE uses two digits for years in 20th century
 . S:d<date days=days+1 S:d>date days=days-1
 Q days        
#else   ;HYY073=
 Q $ZDH(month_"/"_day_"/"_year)
#endif  ;HYY073-
#if 0   ;HYY073+
ETAD(year,month,day) 
 N (year,month,day)
 S date=year_month_day
 S days=(((year-1841)*365.25)+((month-1)*30.4)+day+0.5)\1 ;approximate
 F  D  Q:d=date
 . S zdate=$ZDATE(days),d=$P(zdate,"/",3)_$P(zdate,"/",1)_$P(zdate,"/",2)
 . S:$L(d)<8 d="19"_d ;$ZDATE uses two digits for years in 20th century
 . S:d<date days=days+1 S:d>date days=days-1
 Q days
#endif  ;HYY073-         
 ; convert zdate to date format used in journal file names
ZDTOJRND(zdate)         
 S d=$P(zdate,"/",3)_$P(zdate,"/",1)_$P(zdate,"/",2)
 S:$L(d)<8 d="19"_d ;$ZDATE uses two digits for years in 20th century
 Q d
#else   ;HYY110=
 ; days=$zdh(YYYYMMDD,8)
#define etad(%a) $zdh(%a,8)
 ; YYYYMMDD=$zd($zdh(MM/DD/[YY]YY),8)
#define ZDTOJRND(%a) $zd($zdh(%a),8)
#endif  ;HYY110-
  
#endif ISCETAD