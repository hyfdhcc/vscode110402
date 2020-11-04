ROUTINE %occCPTtrace [Type=INC]


#; define this for tracing :-
#; #define CPTTRACEON

#ifdef CPTTRACEON
#define CPTTRACE(%proc,%args) ##safeexpression($$CPTTRACEPROC^%occStorageCompiler(%proc,%args))
#else
#define CPTTRACE(%proc,%args)
#endif


CPTTRACEPROC(proc,args) public {
	Quit "Write """_proc_" ("","_$$showargs(args)_","")"",!"
showargs(args)
	If args="" {Quit """()"""}
	Set out=$$showone($Piece(args,","))
	For i=2:1:$Length(args,",") {
		Set out=out_","","","_$$showone($Piece(args,",",i))
	}
	Quit out
showone(arg) Quit """"_arg_"=""_$$CPTTRACEREPR(."_arg_")"
enquote(s) // not used
	If s["""" {
		Quit """"_$Replace(s,"""","""""")_""""
	}
	Else {
		Quit """"_s_""""
	}
}


CPTTRACEREPR(var) public {
	Set out=""
	If $Data(var) {
		If $Data(var)#10 {
			Set out=out_##class(%XSQL.Format).ListFormat(var)
		}
		If $Data(var)\10 {
			If out'="" {Set out=out_" "}
			Set out=out_$$desc(.var)
		}
	}
	Else {
		Set out="*"
	}
	Quit out
desc(var)
	Set ss=""
	Set k=""
	Do {
		Set k=$Order(var(k)) If k="" {Quit}
		If ss'="" {Set ss=ss_","}
		Set ss=ss_##class(%XSQL.Format).ListFormat(k)
	} While $Length(ss)<40
	Quit "("_ss_")"
}

