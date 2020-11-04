/// Installation Utility for UMLS
/// 
/// <p> UMLS stands for Unified Medical Language System.It consists of several parts including ICD-10, MeSH, SNOMED CT, DSM-IV, LOINC. We can map either to any UMLS concept or only to a concept present in a specified vocabulary (or several vocabularies).
/// 
/// <p> For detailed information on UMLS see:
/// 
/// <ul>
/// <li><a href="http://en.wikipedia.org/wiki/Unified_Medical_Language_System">Description in Wikipedia</a>
/// 
/// <li><a href="http://www.nlm.nih.gov/research/umls/">UMLS Home at NIH</a>
/// </ul>
/// 
/// <p> To install UMLS inisde Cache you first need to install UMLS distribution files on your local machine by following <a href="http://www.nlm.nih.gov/research/umls/quickstart.html#Access_the_UMLS">UMLS Installation Instructions</a>. 
/// 
/// During installation UMLS Installation tool offers to create Database Load Scripts. Cache is not in the list of databases, select MySQL - we will later convert them to Cache.
/// 
/// <p>Once local installation is completed you need to create UMLS database by running the following method:
/// <EXAMPLE>
/// d ##class(%UMLS.Install.Utils).createDatabase()
/// </EXAMPLE>
/// 
/// <p>This method also adds mappings so UMLS is acessible from all existing namespaces. If you create another namespace later in order to enable UMLS on the new namespace you need to run:
/// <EXAMPLE>
/// d ##class(%UMLS.Install.Utils).addMapping("newNamespace")
/// </EXAMPLE>
/// or
/// <EXAMPLE>
/// d ##class(%UMLS.Install.Utils).addMapToAllNamespaces()
/// </EXAMPLE>
/// 
/// <p> When database is created run import utility:
/// 
/// <EXAMPLE>
/// d ##class(%UMLS.Install.Utils).import("/OS/Path/To/UMLS/Installation")
/// </EXAMPLE>
/// 
Class %UMLS.Install.Utils Extends %RegisteredObject [ System = 4 ]
{

Parameter packageLEX = "%UMLS.lex";

Parameter packageMETA = "%UMLS.meta";

Property LoadData As %Boolean [ InitialExpression = 1 ];

Property ProcessSystem As %Boolean [ InitialExpression = 1 ];

Property Replace As %Boolean [ InitialExpression = 1 ];

Property verbose As %Boolean [ InitialExpression = 0 ];

Property ProcessOther As %Boolean [ InitialExpression = 1 ];

Property Pattern As %String;

Method SetOptions(qspec As %String = "") As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim option, substr As %String
	#dim i As %Integer
	#dim v

	Try {
		for option = "load","system","other","replace" {
			set v = ""
			set i = $find(qspec,"/"_option)
			if (i > 0) {
				set substr = $e(qspec,i,*)
				set i = $f(substr,"/")
				if (i > 0) {
					set substr = $e(substr,0,i-2)
				}
				set i = $f(substr,"=")
				if (i > 0) {
					set v = $e(substr,i,*)
				} else {
					set v = 1
				}
				
			} else {
				set i = $find(qspec,"/no"_option)
				if (i > 0) {
					set v = 0
				}
			}
			
			w:..verbose option_" = "_v, !
			
			if (option = "load") {
				set:v'="" ..LoadData = v
			} elseif (option = "system") {
				set:v'="" ..ProcessSystem = v
			} elseif (option = "other") {
				set:v'="" ..ProcessOther = v
			} elseif (option = "replace") {
				set:v'="" ..Replace = v
			}
		}
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

/// Imprts UMLS from a local installation into Cache
/// <var>dir</var> - Path to local UMLS installation
/// <var>pattern</var> - Specify if you would like only partial import
/// <var>qpec</var> options:
/// <ul>
/// <li> "load" or "/noload" - whether to load data. If load = 0 or "noload" then just create classes but do not import data
/// <li> "system"/"nosystem" - Import/Do not import classes that are used for iKnow UMLS mapping
/// <li> "other"/"noother"  - Import/Do not import classes that are not used for iKnow UMLS mapping
/// <li> "replace/noreplace" - Replace/Do not replace existing data
/// </ul>
ClassMethod import(dir As %String, pattern As %String = "%", qspec As %String = "", verbose As %Boolean = 0) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	Try {
		set sc = ..checkDatabase()
		Quit:$$$ISERR(sc)
		
		set install = ..%New()
		set install.verbose = verbose
		set install.Pattern = pattern
		set sc = install.SetOptions(qspec)
		Quit:$$$ISERR(sc)
		
		set sc = install.doImport(dir)
		Quit:$$$ISERR(sc)
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	if ($$$ISERR(sc)) {
		d $system.OBJ.DisplayError(sc)
	} else {
		w "ALL DONE", !
	}
	
	Quit sc
}

Method doImport(dir As %String) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim path As %String
	
	Try {
		w "Importing Metathesaurus tables", !
		
		set sc = ##class(Scripts).loadScripts(dir)
		Quit:$$$ISERR(sc)
		
		set path = ##class(%File).NormalizeDirectory("META",dir)
		set sc = ..importMETA(path)
		Quit:$$$ISERR(sc)
		
		
		w "DONE: Import of Metathesaurus tables", !
		w "Importing SPECIALIST Lexicon tables", !
		
		set path = ##class(%File).NormalizeDirectory("LEX",dir)
		set sc = ..importLEX(path)
		Quit:$$$ISERR(sc)
		
		set sc = ..buildNormTable()
		Quit:$$$ISERR(sc)
		
		w "DONE: Import of SPECIALIST Lexicon tables", !
		w "Building collection indices: ", !
		
		set sc = ..buildCUIColl()
		Quit:$$$ISERR(sc)
		set sc = ..buildSUIColl()
		Quit:$$$ISERR(sc)

		w "DONE: Building collection indices", !
		w "Populating Monogram frequencies", !
		
		set sc = ##class(%UMLS.TFIDF).populate()
		Quit:$$$ISERR(sc)
		w "DONE: Populating frequencies", !
		
		w "Populating BM25 Scores for Strings", !
		set sc = ##class(%UMLS.TFIDF).populate2()
		Quit:$$$ISERR(sc)
		w "DONE: Populating BM25 Scores for Strings", !
		
		set sc = ..SetInfo(dir)
		Quit:$$$ISERR(sc)
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	if ($$$ISERR(sc)) {
		d $system.OBJ.DisplayError(sc)
	} else {
		w "ALL DONE", !
	}
	
	if ($g(^%UMLS.Install.Errors) > 0) {
		w "Non-fatal Errors detected: "_^%UMLS.Install.Errors
		zw ^%UMLS.Install.Errors
	}

	Quit sc
}

ClassMethod SetInfo(dir As %String) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim path, fName, line As %String
	#dim len As %Integer
	
	Try {
		set path = ##class(%File).NormalizeDirectory("META",dir)
		set fName = ##class(%File).NormalizeFilename("release.dat",path)
		
		set file = ##class(%File).%New(fName)
		set sc = file.Open("R")
		Quit:$$$ISERR(sc)
		
		While ('file.AtEnd) {
			set len = 3200
			set line = file.ReadLine(.len, .sc)
			Quit:$$$ISERR(sc)
			Continue:line=""
			
			if ('(line["=")) {
				set ^%UMLS.Install.Version(line) = ""
			} else {
				set ^%UMLS.Install.Version($p(line,"=",1)) = $p(line,"=",2)
			}
		}
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	Quit sc
}

/// Verifies that the given directory contains original UMLS install files.
ClassMethod checkFiles(dir As %String) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim path, fName As %String
	#dim err

	Try {
		if ('##class(%File).DirectoryExists(dir)) {
			set sc = $$$ERROR($$$GeneralError,"No directory: "_dir)
			Quit
		}
		
		set path = ##class(%File).NormalizeDirectory("META",dir)
		if ('##class(%File).DirectoryExists(path)) {
			set sc = $$$ERROR($$$GeneralError,"No directory: "_path)
			Quit
		}

		&sql(declare c1 cursor for
			select distinct infile into :infile from %UMLS_Install.Scripts order by 1
		)
		&sql(open c1)
		&sql(fetch c1)
		
		While (SQLCODE = 0) {
			set fName = ##class(%File).NormalizeFilename(infile,path)
			w infile_": "
			if (##class(%File).Exists(fName)) {
				w "OK", !
			} else {
				w "NOT FOUND", !
				set err(infile) = "NOT FOUND"
			}
			
			&sql(fetch c1)
		}
		&sql(close c1)
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	w "Errors:"
	zw err

	Quit sc
}

ClassMethod isSystem(className As %String, Output system As %Boolean) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	Try {
		set system = 0
		if (##class(%Dictionary.CompiledClass).%ExistsId(className)) {
			set cDef = ##class(%Dictionary.CompiledClass).%OpenId(className)
			if (cDef.System > 0) {
				if ($parameter(className,"UMLSVERSION") '= "") {
					set system =  1
				}
			}
		}
	} Catch (ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod isInstalled(dir As %String, table As %String, Output installed As %Boolean, Output loaded As %Boolean) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim path As %String

	Try {
		set installed = 0
		set loaded = 0
		
		set path = $g(^%UMLS.Install.Tables(table, "path"))
		if (path = "") {
			Quit
		}
		
		set dir = ##class(%File).NormalizeFilename(dir)
		set path = ##class(%File).NormalizeFilename(path)
		if ($e(path,0,$l(dir)) = dir) {
			set installed = 1
		} else {
			set installed = -1
		}

		set loaded = $g(^%UMLS.Install.Tables(table, "data"),loaded)
	} Catch (ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod createIndex(command As %String, table As %String, code As %String) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim i, l, d As %Integer
	#dim t, s, c, code1 As %String
	
	Try {
		set i = $f(code, table)
		d ..classForTable(table, .t)
		
		if (command = "CREATE INDEX") {
			set s = "ON "_table_"("
			set code = $p(code,s,1)_"ON "_t_"("_$p(code,s,2)
			
			set code1 = code
			set code = ""
			set l = $l(code1)
			set d = 0
			for i = 1:1:l {
				set c = $e(code1, i)
				if (c = "(") {
					set d = d + 1
				} 
				if (d < 2) {
					set code = code_c
				}
				if (c = ")") {
					set d = d - 1
				}
			}
			
		} elseif (command = "ALTER TABLE") {
			set code = "alter table "_t_" "_$e(code,i,*)
		}
		
		set sc =..executeSQL(code)
		Quit:$$$ISERR(sc)
	} Catch (ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod executeSQL(code As %String) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim rs As %SQL.StatementResult
	
	Try {
		set code = $tr(code,";")
		set stmt = ##class(%SQL.Statement).%New()
		set stmt.%SchemaPath = $tr(..#packageMETA,".","_")_","_$tr(..#packageLEX,".","_")
		set sc = stmt.%Prepare(code)
		Quit:$$$ISERR(sc)
		
		set rs = stmt.%Execute()
		if (rs.%SQLCODE '= 0) {
			set sc = $system.Status.Error(-rs.%SQLCODE,rs.%Message)
			Quit
		}
		
		d rs.%Close()
		d stmt.%Close()
		
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	if ($$$ISERR(sc)) {
		w "SQL = "_code, !
	}

	Quit sc
}

ClassMethod classForTable(table As %String, Output cacheTable As %String, Output type As %String) As %String
{
	#dim package As %String = ""
	#dim c As %String
	
	set type = ""
	if (table = "MRXNS_ENG") {
		set table = "MRXNS"
	} elseif (table = "MRXNW_ENG") {
		set table = "MRXNW"
	}
	
	set c = $zcvt($e(table),"U")
	if (c = "M") {
		set package = ..#packageMETA
		set type = "META"
	} elseif (c = "L") {
		set package = ..#packageLEX
		set type = "LEX"
	} elseif ((c = "A") || (c = "D")) {
		set package = ..#packageMETA
		set type = "META"
	}
	
	set cacheTable = $tr(package,".","_")_"."_table
	Quit package_"."_$tr(table,"_")
}

/// Creates UMLS database
/// <p>
/// <var>dbpath</var> - Optional parameter to specify path to the new database. Full UMLS can take up to 50G.
/// 
ClassMethod createDatabase(dbpath As %String = "") As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim namespace, dbFileName As %String
	#dim props
	
	Try {
		set namespace = $namespace
		set sc = ..checkDatabase()
		if ($$$ISOK(sc)) {
			set sc = $$$ERROR($$$GeneralError,"UMLS is already installed")
			Quit
		}
 		zn "%SYS"
	 	if (##Class(Config.Databases).Exists("UMLS",,.sc)) {
			set sc = $$$ERROR($$$GeneralError,"UMLS database already exists. Remove it first.")
			Quit
	 	}		
		
		set dbFileName = ""
 		if ($g(dbpath)="") { 
 			s dbpath=$zu(12)
 		} else {
	 		set dbFileName = ##class(%File).NormalizeFilename("CACHE.DAT",dbpath)
			if ('##class(%File).Exists(dbFileName)) {
				set dbFileName = ""
			}
		}
 		
 		if (dbFileName = "") {
	 		if '(##class(%File).DirectoryExists(dbpath)) {
  				s sc=##class(%File).CreateDirectory(dbpath) 
 			}
	 		set dbpath = ##class(%File).NormalizeDirectory("UMLS",dbpath)
 		}
 		if '(##class(%File).DirectoryExists(dbpath)) {
  			s sc=##class(%File).CreateDirectory(dbpath) 
 		}

		set dbFileName = ##class(%File).NormalizeFilename("CACHE.DAT",dbpath)
		if ('##class(%File).Exists(dbFileName)) {
	 		set sc=##Class(SYS.Database).CreateDatabase(dbpath, 4096,,0,,0)
	 		Quit:$$$ISERR(sc)
		}
	 	
	 	set props("Directory") = dbpath
	 	set sc = ##Class(Config.Databases).Create("UMLS",.props)
	 	Quit:$$$ISERR(sc)

	 	set sysdb = ##Class(SYS.Database).%OpenId(dbpath,,.sc)
	 	Quit:$$$ISERR(sc)
	 	
	 	if ('sysdb.Mounted) {
	 		set sc = sysdb.Mount()
		 	Quit:$$$ISERR(sc)
	 	}

		set sc = ..addMapToAllNamespaces()
	 	Quit:$$$ISERR(sc)
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	zn namespace
	
	if ($$$ISERR(sc)) {
		d $system.OBJ.DisplayError(sc)
	}
	
	Quit sc
}

ClassMethod deleteDatabase() As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim namespace As %String
	#dim db As Config.Databases
	
	Try {
		w "Deleting UMLS Database", !
		set namespace = $namespace
 		zn "%SYS"

		set sc = ..deleteMapFromAllNamespaces()
	 	Quit:$$$ISERR(sc)

	 	set db=##Class(Config.Databases).Open("UMLS",,,.sc)
	 	Quit:$$$ISERR(sc)
	 	
	 	set sysdb = ##Class(SYS.Database).%OpenId(db.Directory,,.sc)
	 	if ($$$ISERR(sc)) {
		 	d $system.OBJ.DisplayError(sc)
		 	set sc = ##Class(Config.Databases).Delete("UMLS")
		 	Quit
	 	}
	 	
	 	if (sysdb.Expanding) {
			set sc = $$$ERROR($$$GeneralError,"UMLS database is Expanding. Wait until expansion is complete and try again or delete it manually.")
			Quit
	 	}

	 	set sc = ##Class(Config.Databases).Delete("UMLS")
	 	Quit:$$$ISERR(sc)
	 	
	 	if (sysdb.Mounted) {
		 	set sc = sysdb.Dismount()
		 	Quit:$$$ISERR(sc)
	 	}
	 	
	 	//set sc = ##Class(SYS.Database).DeleteDatabase(db.Directory)
	 	Quit:$$$ISERR(sc)
	 	
	 	
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	zn namespace
	
	if ($$$ISERR(sc)) {
		d $system.OBJ.DisplayError()
	}
	
	Quit sc
}

ClassMethod checkDatabase() As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim namespace As %String
	
	Try {
		set namespace = $namespace
		zn "%SYS"
	 	if (##Class(Config.Databases).Exists("UMLS",,.sc)) {
		 	set sc = $$$OK
	 	} elseif ($$$ISOK(sc)) {
		 	set sc = $$$ERROR($$$GeneralError,"Database UMLS does not exist")
	 	}
	 	Quit:$$$ISERR(sc)
	 	
		if (##class(Config.MapGlobals).Exists($namespace,"%UMLS.*",,.sc)) {
		 	set sc = $$$OK
	 	} elseif ($$$ISOK(sc)) {
		 	set sc = $$$ERROR($$$GeneralError,"Global Mapping %UMLS.* is not defined")
	 	}
	 	Quit:$$$ISERR(sc)
	 	
		if (##class(Config.MapGlobals).Exists(namespace,"%UMLS.*",,.sc)) {
		 	set sc = $$$OK
	 	} elseif ($$$ISOK(sc)) {
		 	set sc = $$$ERROR($$$GeneralError,"Global Mapping %UMLS.* is not defined")
	 	}
	 	Quit:$$$ISERR(sc)
	 	
	 	
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	zn namespace
	
	Quit sc
}

ClassMethod addMapToAllNamespaces() As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim props
	#dim ns As %String
	#dim remote, available As %Boolean
	
	Try {
		set rs = ##class(%ResultSet).%New("%SYS.Namespace:List")
		set sc = rs.Execute(0)
		
		While (rs.%Next()) {
			set ns = rs.%GetData(1)
			set available = rs.%GetData(2)
			set remote = rs.%GetData(3)
			
			if (('available) || remote) {
				Continue
			}
			
			set sc = ..addMapping(ns)
			//w ns, !
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)
		
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	Quit sc
}

ClassMethod deleteMapFromAllNamespaces() As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim props
	#dim ns As %String
	#dim remote, available As %Boolean
	
	Try {
		set rs = ##class(%ResultSet).%New("%SYS.Namespace:List")
		set sc = rs.Execute(0)
		
		While (rs.%Next()) {
			set ns = rs.%GetData(1)
			set available = rs.%GetData(2)
			set remote = rs.%GetData(3)
			
			if (('available) || remote) {
				Continue
			}
			
			set sc = ..deleteMapping(ns)
			//w ns, !
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)
		
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	Quit sc
}

/// Build indices for an additional language in UMLS.<p>
/// Note that languages are sepcified in UMLS format. For example English is "ENG" and 
/// Dutch is "DUT". Languages supported by iKnow are:
/// 1:"ENG",2:"FRE",3:"GER",4:"DUT",5:"SPA",6:"POR",7:"RUS"
ClassMethod addLAT(lat As %String) As %Status
{
	Quit ##class(%UMLS.meta.SUICOLL).addLAT(lat)
}

ClassMethod addMapping(ns As %String = "") As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim mapping As %String = "%UMLS"
	#dim namespace As %String
	#dim props
	
	Try {
		set namespace = $namespace
		if (ns = "") {
			set ns = namespace
		}
		
		zn "%SYS"
		
		if (##class(Config.MapGlobals).Exists(ns,"%UMLS.*")) {
			Quit
		}
		
		set props("Database") = "UMLS"
		set sc = ##class(Config.MapGlobals).Create(ns, "%UMLS.*", .props)
		Quit:$$$ISERR(sc)
		
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	zn namespace
	
	Quit sc
}

ClassMethod deleteMapping(ns As %String = "") As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim namespace As %String
	
	Try {
		set namespace = $namespace
		if (ns = "") {
			set ns = namespace
		} 
		
		zn "%SYS"
		
		if ('##class(Config.MapGlobals).Exists(ns,"%UMLS.*")) {
			Quit
		}
		
		set sc = ##class(Config.MapGlobals).Delete(ns, "%UMLS.*")
		Quit:$$$ISERR(sc)
		
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	zn namespace
	
	Quit sc
}

Method importMETA(dir As %String) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim fName, line, table, mrfilLine, mrcolsLine As %String
	#dim rs As %IResultSet
	#dim command, infile, code, path, className As %String
	#dim len, n, i, count As %Integer
	#dim handle
	#dim icount As %Integer
	#dim isSystem As %Boolean
	
	Try {
		set count = 0
		set mrfilLine = ""
		set mrcolsLine = ""
		set fName = ##class(%File).NormalizeFilename("MRFILES.RRF",dir)
		
		set file = ##class(%File).%New(fName)
		set sc = file.Open("R")
		Quit:$$$ISERR(sc)
		
		While ('file.AtEnd) {
			set len = 3200
			set line = file.ReadLine(.len, .sc)
			Quit:$$$ISERR(sc)
			Continue:line=""
			
			if ($e(line,1,7) = "MRFILES") {
				set mrfilLine = line
			} elseif ($e(line,1,6) = "MRCOLS") {
				set mrcolsLine = line
			}
		}
		Quit:$$$ISERR(sc)
		d file.Close()

		if (mrcolsLine '= "") {
			set sc = ..importTable(dir, mrcolsLine, .handle, 1)
			Quit:$$$ISERR(sc)
		}

		if (mrfilLine '= "") {
			set sc = ..importTable(dir, mrfilLine, .handle, 1)
			Quit:$$$ISERR(sc)
		}

		if (mrcolsLine '= "") {
			set sc = ..importTable(dir, mrcolsLine, .handle, 1)
			Quit:$$$ISERR(sc)
		}

		set fName = ##class(%File).NormalizeFilename("MRFILES.RRF",dir)
		
		set file = ##class(%File).%New(fName)
		set sc = file.Open("R")
		Quit:$$$ISERR(sc)
		
		While ('file.AtEnd) {
			set len = 3200
			set line = file.ReadLine(.len, .sc)
			Quit:$$$ISERR(sc)
			Continue:line=""
			set table 	= $p(line,"|",1)
			
			if (table["/") {
				set n = $l(table,"/")
				set table = $p(table,"/",n)
			}
			set table = $p(table,".")
			
			if ((table = "MRFILES") || (table = "MRCOLS")) {
				Continue
			}
			if ('$match(table,$replace(..Pattern,"%",".*"))) {
				Continue
			}
			
			set sc = ..importTable(dir, line, .handle)
			Quit:$$$ISERR(sc)
			set count = $i(count)
		}
		Quit:$$$ISERR(sc)
				
		d file.Close()
		
		w "Adding Indices", !
		set sc = ##class(Scripts).GetRS("ALTER TABLE,CREATE INDEX", ..Pattern, .rs)
		Quit:$$$ISERR(sc)
		
		set count = 0
		set icount = 0
		set table = ""
		While (rs.%Next()) {
			if ((icount > 0) && (table '= rs.%Get("table"))) {
				/*
				set className = ..classForTable(table)
				w "Rebuilding "_icount_" indices for "_className, !
				set sc = $classmethod(className,"%BuildIndices")
				Quit:$$$ISERR(sc)
				*/
				set count = $i(count)
				set icount = 0
			} 
			set table = rs.%Get("table")
			if (icount = 0) {
				w "Adding indices for table: "_table, !
			}
			
			set className = ..classForTable(table)
			if ('##class(%Dictionary.CompiledClass).%ExistsId(className)) {
				w "Skipping non-existent table: "_table, !
				set sc = $$$ERROR($$$GeneralError,"Reference to non-existent table: "_table)
				d ..LogError(sc)
				set sc = $$$OK
				Continue
			}
			set sc = ..isSystem(className, .isSystem)
			Quit:$$$ISERR(sc)
			if (isSystem) {
				Continue
			}
			
			set code = rs.%Get("code")
			set command = rs.%Get("command")
			
			set sc = ..createIndex(command,table,code)
			Quit:$$$ISERR(sc)
			
			set icount = $i(icount)
		}
		Quit:$$$ISERR(sc)
		
		if (icount > 0) {
			/*
			set className = ..classForTable(table)
			w "Rebuilding "_icount_" indices for "_className, !
			set sc = $classmethod(className,"%BuildIndices")
			Quit:$$$ISERR(sc)
			*/
			set count = $i(count)
		}
		
		w "Tables processed: "_count, !
		
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	w count _" Tables Imported", !
	
	Quit sc
}

Method importLEX(dir As %String) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim fName, line, table, lrfilLine As %String
	#dim len, n, i, count As %Integer
	#dim pDesc
	
	Try {
		set count = 0
		set lrfilLine = ""
		set fName = ##class(%File).NormalizeFilename("LRFLD",dir)
		
		set file = ##class(%File).%New(fName)
		set sc = file.Open("R")
		Quit:$$$ISERR(sc)
		
		While ('file.AtEnd) {
			set len = 3200
			set line = file.ReadLine(.len, .sc)
			Quit:$$$ISERR(sc)
			Continue:line=""
			
			set pDesc($p(line,"|",1)) = $p(line,"|",2)
		}
		Quit:$$$ISERR(sc)
		d file.Close()

		set fName = ##class(%File).NormalizeFilename("LRFIL",dir)
		
		set file = ##class(%File).%New(fName)
		set sc = file.Open("R")
		Quit:$$$ISERR(sc)
		
		While ('file.AtEnd) {
			set len = 3200
			set line = file.ReadLine(.len, .sc)
			Quit:$$$ISERR(sc)
			Continue:line=""
			set table 	= $p(line,"|",1)
			if (table = "LRFIL") {
				set lrfilLine = line
				Continue
			}
			if ('$match(table,$replace(..Pattern,"%",".*"))) {
				Continue
			}
			
			set sc = ..importTable(dir, line, .pDesc)
			Quit:$$$ISERR(sc)
			set count = $i(count)
		}
		Quit:$$$ISERR(sc)
				
		d file.Close()
		if (lrfilLine '= "") {
			set sc = ..importTable(dir, lrfilLine, .pDesc, 1)
			Quit:$$$ISERR(sc)
		}
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	w count _" Tables Imported", !
	
	Quit sc
}

Method importTable(dir As %String, line As %String, ByRef pDesc, forceLoad As %Boolean = 0) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim table, desc, columns, infile, lrfilLine, fileName, className, type As %String
	#dim size, nc, nr As %Integer
	#dim isSystem, isInstalled, isLoaded, process As %Boolean
	
	Try {
		set fileName	= $p(line,"|",1)
		set desc  		= $p(line,"|",2)
		set columns 	= $p(line,"|",3)
		set nc 			= $p(line,"|",4)
		set nr 			= $p(line,"|",5)
		set size		= $p(line,"|",6)
			
		set infile = ##class(%File).NormalizeFilename(fileName,dir)
		set table = ##class(%File).GetFilename(infile)
		set table = $p(table,".")
		
		set sc = ..isInstalled(dir, table, .isInstalled, .isLoaded)
		QUit:$$$ISERR(sc)

		if (nc '= $l(columns,",")) {
			set sc = $$$ERROR($$$GeneralError,"Number of columns mismatch for table: "_table_"; expected: "_nc_", actual: "_$l(columns,","))
			Quit
		}
		
		set className = ..classForTable(table,,.type)

		if (isInstalled && ..Replace) {
			set isInstalled = 0
		}
		
		set process = -1
		set sc = ..isSystem(className, .isSystem)
		if (isInstalled) {
			w "Already installed: "_table, !
		} elseif (type = "LEX") {
			set sc = ##class(CBuilder).createLexClass(className, desc, .columns, .pDesc)
			Quit:$$$ISERR(sc)
		} elseif (type = "META") {
			Quit:$$$ISERR(sc)
			if (isSystem) {
				if (..ProcessSystem) {
					set process = 1
					set sc = ##class(CBuilder).updateMetaClass(className, desc, .columns, .pDesc, fileName)
				} else {
					set process = 0
				}
			} else {
				if (..ProcessOther) {
					set process = 1
					set sc = ##class(CBuilder).createMetaClass(className, desc, .columns, .pDesc, fileName)
				} else {
					set process = 0
				}
			}
			Quit:$$$ISERR(sc)
		}
		
		if (process < 0) {
			if (isSystem) {
				if (..ProcessSystem) {
					set process = 1
				} else {
					set process = 0
				}
			} else {
				if (..ProcessOther) {
					set process = 1
				} else {
					set process = 0
				}
			}
		}
		
		if ('isInstalled) {
			set isLoaded = 0
		}
		
		
		if (forceLoad || (..LoadData && ('isLoaded || ..Replace) && process)) {
			set sc = ..loadData(table, columns, infile, size, nr)
			Quit:$$$ISERR(sc)
			set isLoaded = 1
		}
		
		if ('isInstalled) {
			d ..LogInstall(table, infile, isLoaded)
		} elseif (isLoaded) {
			d ..LogLoaded(table)
		}
	} Catch (ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod loadData(table As %String, columns As %String, infile As %String, size As %Integer, nrec As %Integer) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim i, n, l As %Integer
	#dim className, prop, line As %String
	#dim parray
	#dim record As %Persistent
	
	Try {
		set l = 0
		set className = ..classForTable(table)
		set sc = $classmethod(className,"%KillExtent")
		Quit:$$$ISERR(sc)
		
		set n = $l(columns,",")
		for i = 1:1:n {
			set parray(i) = $zcvt($p(columns,",",i),"U")
		}
		
		set file = ##class(%FileCharacterStream).%New()
		//set sc = file.Open("R")
		//Quit:$$$ISERR(sc)
		set file.Filename = infile
		set file.TranslateTable = "UTF8"
		
		if (file.Size '= size) {
			set sc = $$$ERROR($$$GeneralError,"File size mismatch for table: "_table_"; expected: "_size_", actual: "_file.Size)
			//Quit
			d $system.OBJ.DisplayError(sc)
			d ..LogError(sc)
			set sc = $$$OK
		}
		
		w "Loading data into "_table, !
		While ('file.AtEnd) {
			set line = file.ReadLine(32000,.sc)
			Quit:$$$ISERR(sc)
			
			set line = $zstrip(line,"<>W")
			if (line = "") {
				Continue
			}
			
			if ($l(line,"|") '= (n + 1)) {
				set sc = $$$ERROR($$$GeneralError,"Unexpected number of tokens in line #"_l_": "_$l(line,"|"))
				Quit
			}
			
			set record = $classmethod(className,"%New")
			for i = 1:1:n {
				set prop = parray(i)
				set $property(record,prop) = $p(line,"|",i)
			}
			set sc = record.%Save()
			//break:$$$ISERR(sc)
			Quit:$$$ISERR(sc)
			set l = $i(l)
			
			if ((l#50000) = 0) {
				w table_": loaded records: "_l, !
			}
		}
		Quit:$$$ISERR(sc)
		
		// d file.Close()
		
		if (l '= nrec) {
			set sc = $$$ERROR($$$GeneralError,"Number of records mismatch for table: "_table_"; expected: "_nrec_", actual: "_l)
			//Quit
			d $system.OBJ.DisplayError(sc)
			d ..LogError(sc)
			set sc = $$$OK
		}
		
		Quit:$$$ISERR(sc)
	} Catch (ex) {
		set sc = ex.AsStatus()
	}

	w table_": Total records: "_l, !

	Quit sc
}

ClassMethod buildCUIColl() As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim cui, str As %String
	#dim count, count1 As %Integer
	
	Try {
		set sc = ##class(%UMLS.meta.CUICOLL).%KillExtent()
		Quit:$$$ISERR(sc)
		
 		&sql(declare cCUICOLL cursor for
 			select CUI, NWD into :cui1,:nwd from %UMLS_meta.MRXNW_ENG order by CUI
 		)
 		&sql(Open cCUICOLL)
 		
 		set count = 0
 		set count1 = 0
 		set cui = ""
 		while(1) {
	 		set cui1 = ""
	 		set nwd = ""
	 		&sql(Fetch cCUICOLL)
	 		if (SQLCODE '= 0) {
		 		Quit
	 		}
        	s count = count + 1
            if (cui1 = "") {
	            continue
            } elseif (cui = "") {
                set cui = cui1
                set str = $lb(nwd)
            } elseif (cui1 = cui) {
            	s str=str_$lb(nwd)
            } else {
            	d ..InsertCUI(cui,str,"ENG")
                set cui = cui1
                set str = $lb(nwd)
                set count1 = $i(count1)
	            if ('(count1#1000)) {
		            w "CUICOLL: "_count1_"/"_count, !
        	    }
            }
 		}
 		&sql(Close cCUICOLL)
 		Quit:$$$ISERR(sc)
 		
 		d ..InsertCUI(cui,str,"ENG")
	} Catch (ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod buildSUIColl() As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim SUI, str As %String
	#dim count, count1 As %Integer
	
	Try {
		set sc = ##class(%UMLS.meta.SUICOLL).%KillExtent()
		Quit:$$$ISERR(sc)
		set ^%UMLS.Install.Languages = $lb("ENG")
		
 		&sql(declare cSUICOLL cursor for
 			select SUI, NWD into :SUI1,:nwd from %UMLS_meta.MRXNW_ENG order by SUI
 		)
 		&sql(Open cSUICOLL)
 		
 		set count = 0
 		set count1 = 0
 		set SUI = ""
 		while(1) {
	 		set SUI1 = ""
	 		set nwd = ""
	 		&sql(Fetch cSUICOLL)
	 		if (SQLCODE '= 0) {
		 		Quit
	 		}
        	s count = count + 1
            if (SUI1 = "") {
	            continue
            } elseif (SUI = "") {
                set SUI = SUI1
                set str = $lb(nwd)
            } elseif (SUI1 = SUI) {
            	s str=str_$lb(nwd)
            } else {
            	d ..InsertSUI(SUI,str,"ENG")
                set SUI = SUI1
                set str = $lb(nwd)
                set count1 = $i(count1)
	            if ('(count1#1000)) {
		            w "SUICOLL: "_count1_"/"_count, !
        	    }
            }
 		}
 		&sql(Close cSUICOLL)
 		Quit:$$$ISERR(sc)
 		
 		d ..InsertSUI(SUI,str,"ENG")
	} Catch (ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod InsertCUI(cui As %String, coll As %List, lat As %String)
{
	set %ROWCOUNT = 0
	&sql(insert into %UMLS_meta.CUICOLL (cui, nwd, lat)values(:cui,:coll,:lat))
	if (%ROWCOUNT < 1) {
		throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
 	}
}

ClassMethod InsertSUI(sui As %String, coll As %List, lat As %String)
{
	set %ROWCOUNT = 0
	&sql(insert into %UMLS_meta.SUICOLL (sui, nwd, LAT)values(:sui,:coll,:lat))
	if (%ROWCOUNT < 1) {
		throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
 	}
}

ClassMethod buildNormTable() As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	Try {
		set sc = ##class(%UMLS.lex.LNORM).%KillExtent()
		Quit:$$$ISERR(sc)
		
		&sql(insert into %UMLS_lex.LNORM (str, nrm)
    		select str, cit from %UMLS_lex.lragr group by str
    	)
    	if (SQLCODE '= 0) {
			throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    	}
		
	} Catch (ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod LogError(sc As %Status)
{
	set ^%UMLS.Install.Errors($i(^%UMLS.Install.Errors), "text") = $system.Status.GetErrorText(sc)
	set ^%UMLS.Install.Errors(^%UMLS.Install.Errors, "timestamp") = $zts
}

ClassMethod LogInstall(table As %String, path As %String, loaded As %String)
{
	set ^%UMLS.Install.Tables(table) = $i(^%UMLS.Install.Tables)
	set ^%UMLS.Install.Tables(table, "timestamp") = $zts
	set ^%UMLS.Install.Tables(table, "path") = path
	set ^%UMLS.Install.Tables(table, "data") = loaded
}

ClassMethod LogLoaded(table As %String)
{
	set ^%UMLS.Install.Tables(table, "data") = 1
}

Method ClearLog()
{
	k ^%UMLS.Install.Errors
	if (..Replace) {
		k ^%UMLS.Install.Tables
	}
}

}
