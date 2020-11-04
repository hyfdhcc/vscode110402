ROUTINE %occDetermineSchemaName [Type=INC]
#IF 0   ;
	;-------------------------------------------------------------
	; Description:   Determine a Schema Name from a classname   
	; Author:        David van De Griek
	; Date:          05/14/2009
	; Maintenance History: [ XXXnnn (MM/DD/YY) - Description ]
	;
	;  DPV3410 (05/14/2009) - Implement schema search paths
	;
	;-------------------------------------------------------------
	;                     I N F O R M A T I O N
	;-------------------------------------------------------------
	;  Code copied her from its original location in
	;  DetermineSchemaName^%occClass
	;
#ENDIF  ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

DetermineSchemaName(classname) [] PUBLIC {
		#;  Given a class name, return the SQL schema name for the class
	s packagename=$$$ClassPackageName(classname),schema=$g($$$PACKAGEsqlname(packagename))
	QUIT:schema'="" schema
	QUIT:packagename="User" "SQLUser"
	QUIT $tr(packagename,".","_")
}
