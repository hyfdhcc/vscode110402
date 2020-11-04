ROUTINE %stringreplace [Type=INC]
#define InQuotes(%s,%p) ($L($E(%s,1,%p-1),"""")+1#2)
#define InSingleQuotes(%s,%p) ($L($E(%s,1,%p-1),"'")+1#2)
strrep(str,replace,with,noquote=0) public {
#IF 0    ;
         ;  Function:       strrep
         ;  Description:    Given a string, replace all occurances of the
         ;                  substring contained in the variable 'replace' with
         ;                  the substring contained in the variable 'with'.
         ;  Parameters:     str       - The string to perform the replace 
         ;                              function on.
         ;                  replace   - The string to replace with the 'with'
         ;                              string.
         ;                  with      - The string which will replace the 
         ;                              'replace' string.
         ;                  noquote   - Boolean variable
         ;                              0 (False) - Replace all occrances of
         ;                                          the string regardless of
         ;                                          wether or not it is 
         ;                                          contained within quotes.
         ;                              1 (True)  - Replace only those 
         ;                                          occurances of the string
         ;                                          not withing quotes.
#ENDIF   ;
         Set pos=0
loop     Set pos=$find(str,replace,pos) QUIT:'pos str GOTO loop:noquote&&($$$InQuotes(str,pos)) Set $extract(str,pos-$length(replace),pos-1)=with,pos=pos+($length(with)-$length(replace)) Goto loop
}

StringReplaceSQL(str,replace,with,noquote=0) public {
#IF 0    ;
         ;  Function:       strrep
         ;  Description:    Given a string, replace all occurances of the
         ;                  substring contained in the variable 'replace' with
         ;                  the substring contained in the variable 'with'.
         ;  Parameters:     str       - The string to perform the replace 
         ;                              function on.
         ;                  replace   - The string to replace with the 'with'
         ;                              string.
         ;                  with      - The string which will replace the 
         ;                              'replace' string.
         ;                  noquote   - Boolean variable
         ;                              0 (False) - Replace all occrances of
         ;                                          the string regardless of
         ;                                          wether or not it is 
         ;                                          contained within quotes.
         ;                              1 (True)  - Replace only those 
         ;                                          occurances of the string
         ;                                          not withing quotes.
#ENDIF   ;
        set pos=0
loop    set pos=$find(str,replace,pos)
	QUIT:'pos str 
	if noquote && (($$$InSingleQuotes(str,pos)) || ($$$InQuotes(str,pos))) { goto loop }
	set $extract(str,pos-$length(replace),pos-1)=with
	set pos=pos+($length(with)-$length(replace))
	goto loop
}