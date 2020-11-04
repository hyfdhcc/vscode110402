Include %syNLS

/// The <class>%SYSTEM.OBJ</class> class provides an interface for managing 
/// objects.
/// <p>You can use it via the special <b>$system</b> object:
/// <example>
/// Do $system.OBJ.Load("MyFile.xml","ck")
/// </example>
Class %SYSTEM.OBJ Extends Help [ Abstract, System = 4 ]
{

/// Create a new object instance.
/// <p>Create a new object instance of type <var>ClassName</var> and 
/// return a reference (OREF) to it.
/// <p>Using this method, you can dynamically create objects, that is 
/// you can determine what type of object to create at run-time.
/// <p>For example:
/// <example>
/// Set obj = $System.OBJ.New("Person")
/// </example>
ClassMethod New(ClassName As %String = "") As %ObjectHandle [ CodeMode = expression ]
{
$classmethod(ClassName,"%New")
}

/// Open a persistent object instance.
/// <p>Load  persistent object instance of type <var>ClassName</var> and 
/// with OID value <var>oid</var> from disk and return a reference (OREF) to it.
/// <p>For example:
/// <example>
/// Set person = $System.OBJ.Open("Person",oid)
/// </example>
ClassMethod Open(ClassName As %String = "", oid As %String = "") As %ObjectHandle [ CodeMode = expression ]
{
$classmethod(ClassName,"%Open",oid)
}

/// Open a persistent object instance.
/// <p>Load  persistent object instance of type <var>ClassName</var> and 
/// with ID value <var>id</var> from disk and return a reference (OREF) to it.
/// <p>For example:
/// <example>
/// Set person = $System.OBJ.OpenId("Person",22)
/// </example>
ClassMethod OpenId(ClassName As %String = "", id As %String = "") As %ObjectHandle [ CodeMode = expression ]
{
$classmethod(ClassName,"%OpenId",id)
}

/// Dump an object to the console.
/// <p>Write the in-memory state of a object referred to by 
/// <var>oref</var> to the console (the current device).
/// <example>
/// Set person = ##class(Person).%OpenId(22)
/// Do $system.OBJ.Dump(person)
/// </example>
ClassMethod Dump(oref As %String = "") As %Status
{
	If (oref="") {
		Write $$$GetSimpleMessage("%Compiler","OBJDumpError"),!
		Quit
	}
	Quit $$DumpObject^%occRun(.oref)
}

/// Decode and display an object error message to the console.
/// If <var>err</var> is omitted, display the last generated object error.
ClassMethod DisplayError(err As %Status = {$get(%objlasterror)}) As %Status [ CodeMode = expression ]
{
$select(err'="":$$DisplayError^%apiOBJ(err),1:$$$OK)
}

/// Load a file from disk into Cache.
/// <p>Load, and optionally compile (if 'c' flag is present), class definitions, CSP pages, routines, or globals from the
/// file <var>file</var>. <var>file</var> may be a list of files to load separated with '*' symbols.<br>
/// You can import files exported in XML format, %RO format, CDL format, UDL format, and CSR/CSP files.<br>
/// A comma separated list of the items it loaded is returned in <var>loadedlist</var>. If the list is too long to fit
/// in the variable, it is terminated with '...'. Items loaded are always returned as subscripts of the <var>loadedlist</var> array.<br>
/// If you pass <var>listonly</var> as true then it will not
/// import anything but just list the items that exist in <var>file</var>.<br>
/// If <var>selecteditems</var> is defined then this will contain either a comma separated list
/// of items to import or a single subscripted array. It will only import items that are in this list from the file
/// provided, so this provides a way to limit which items get imported.<br>
/// <var>qspec</var> is a list of flags or qualifiers which can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// and 'Do $system.OBJ.ShowFlags()'.<br>
/// When loading a %RO file the <var>description</var> variable will be filled in
/// with the description from the %RO file if there is one present.<br>
/// <var>errorlog</var> is an array of the  <class>%Status</class> return
/// values from this call, in the format returned by $system.Status.DecomposeStatus.<br>
/// The <var>displayname</var> is normally not provided. If present
/// it changes the 'load file XYZ' name from the filename to the displayname. This is useful when loading a stream where the
/// stream filename is not the name of the file the user knows from a client system and we want to present a meaningful name.<br>
/// If the filename ends in .gzip or .gz then we ungzip this file before loading it.
ClassMethod Load(file As %String = "", qspec As %String = "", ByRef errorlog As %String, ByRef loadedlist As %String, listonly As %Boolean, selecteditems As %String, displayname As %String, charset As %String = "", ByRef description As %String) As %Status
{
	Set sc=$$Load^%apiOBJ(file,.qspec,.errorlog,.loadedlist,.listonly,.selecteditems,.displayname,,charset,.description)
	#; Convert the list of imported items into a comma seperated list
	Set loadedlist=""
	Set item=""
	For {
		Set item=$order(loadedlist(item)) Quit:item=""
		If $length(loadedlist)+$length(item)<($$$MaxLocalLength-100) {
			Set loadedlist=loadedlist_","_item
		} Else {
			Set loadedlist=loadedlist_",..." Quit
		}
	}
	Set loadedlist=$extract(loadedlist,2,*)
	Quit sc
}

/// Load a stream into Cache.
/// <p>Load and, optionally compile (if 'c' flag is present), class definitions, CSP pages, routines or globals from the
/// stream <var>stream</var>. Returns an array of the items
/// it loaded in <var>loadedlist</var>. If you pass <var>listonly</var> as true then it will not
/// import anything but just list the items that exist in the stream that you supply.<br>
/// If <var>selecteditems</var> is defined then this will contain a comma separated list
/// of items to import (or a single subscripted array). It will only import items that are in this list from the stream
/// provided, so this provides a way to limit which items get imported.<br>
/// <var>qspec</var> is a list of flags or qualifiers which can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// and 'Do $system.OBJ.ShowFlags()'.
ClassMethod LoadStream(stream As %AbstractStream, qspec As %String = "", ByRef errorlog As %String, ByRef loadedlist As %String, listonly As %Boolean, selecteditems As %String, displayname As %String, charset As %String = "") As %Status
{
	If stream.IsCharacter() {
		Set file=##class(%FileCharacterStream).%New()
	} Else {
		Set file=##class(%FileBinaryStream).%New()
	}
	Set file.Filename=##class(%File).NormalizeDirectory(file.Directory)_file.NewFileName("xml")
	Do stream.Rewind()
	If stream.IsCharacter() {
		Set file.TranslateTable="UTF8"
		Set tmp=stream.Read(500)
		If $extract(tmp,1,5)="<?xml" Set tmp=$piece(tmp,"?>",2,999999)
		Set tmp=$zstrip(tmp,"<",$char(13,10))
		Do file.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
		Do file.Write(tmp)
	}
	While 'stream.AtEnd { Do file.Write(stream.Read()) }
	Do file.Rewind()
	Set sc=$$Load^%apiOBJ(file.Filename,.qspec,.errorlog,.loadedlist,.listonly,.selecteditems,.displayname,,charset)
	Quit sc
}

/// Load all class definitions in a directory.
/// <p>Load and optionally compile (if 'c' flag is present) all class definitions within 
/// directory <var>dir</var>, this includes all .XML files.
/// If the <var>recurse</var> is true then it will include subdirectories.
/// Returns a comma separated list of the items it loaded in <var>loadedlist</var> and the same
/// data also as loadedlist(name)="" in case the comma list is more than 32k. Note that this will
/// only compile classes found in these XML files and no other types. If you want to be able to compile
/// anything use the <method>ImportDir</method>.<br>
/// <var>qspec</var> is a list of flags or qualifiers which can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// and 'Do $system.OBJ.ShowFlags()'.
ClassMethod LoadDir(dir As %String = "", qspec As %String = "", ByRef errorlog As %String, recurse As %Boolean, ByRef loadedlist As %String) As %Status
{
	Set sc=$$LoadDir^%apiOBJ(dir,.qspec,.errorlog,.recurse,.loadedlist)
	#; Convert the list of imported items into a comma seperated list
	Set loadedlist=""
	Set item=$order(loadedlist(""))
	While item'="" {
		Set loadedlist=loadedlist_","_item
		If $length(loadedlist)+$length(item)>($$$MaxLocalLength-100) Set loadedlist=loadedlist_",..." Quit
		Set item=$order(loadedlist(item))
	}
	Zkill loadedlist:2
	Set loadedlist=$extract(loadedlist,2,*)
	Quit sc
}

/// Import and optionally compile all items in a directory.
/// <p>This will import all files found in a directory using the <method>Load</method> method so it should be
/// able to detect most common formats. If you pass it the compile flag ('c'), after loading it will also compile
/// all these items. The other flags are the same as found in <method>Load</method> except for the <var>dir</var>
/// which is the directory to load and the <var>recurse</var> which determines if this will look into subdirectories or not.<br>
/// You can limit the items it will import by specifying a <var>wildcards</var> value. For example '*.xml' will only import
/// files that end in XML.<br>
/// <var>qspec</var> is a list of flags or qualifiers which can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// and 'Do $system.OBJ.ShowFlags()'.
ClassMethod ImportDir(dir As %String = "", wildcards As %String, qspec As %String = "", ByRef errorlog As %String, recurse As %Boolean = 0, ByRef imported As %String, listonly As %Boolean, ByRef selectedlist As %String)
{
	Quit $$ImportDir^%apiOBJ(dir,.wildcards,.qspec,.errorlog,.recurse,.imported,.listonly,.selectedlist)
}

/// Compile a class.
/// <p>Compiles the class <var>classes</var>, which can be a single class, a comma separated list, a subscripted
/// array of class names, or include wild cards. If <var>recurse</var> is true then do not output the intial 'compiling'
/// message or the compile report as this is being called inside another compile loop.<br>
/// <var>qspec</var> is a list of flags or qualifiers which can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// and 'Do $system.OBJ.ShowFlags()'.
ClassMethod Compile(ByRef classes As %String = "", qspec As %String = "", ByRef errorlog As %String, recurse As %Boolean = 0) As %Status [ CodeMode = expression ]
{
$$Compile^%apiOBJ(.classes,.qspec,.errorlog,recurse)
}

/// Compile a list of items specified in 'list' and separated by commas, or an array list("item.MAC")="" or wild cards.
/// Each item on the list is sufixed by the type of item it is so to compile a class
/// and a routine you could specify 'class.cls,routine.mac'
/// The order of compilation is INT, CLS, MAC, CSR, CSP.<br>
/// <var>qspec</var> is a list of flags or qualifiers which can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// and 'Do $system.OBJ.ShowFlags()'.
ClassMethod CompileList(ByRef list As %String = "", qspec As %String = "", ByRef errorlog As %String, ByRef updatedlist As %String) As %Status
{
	Set sc=$$$qualifierParse("Compiler",.qspec,.qstruct) Quit:$$$ISERR(sc) sc
	$$$InitISCName
	$$$InitErrorNums
	Set zh=$zh
	If $$$qualifierGetValue(qstruct,"displaylog") Write !,$$$FormatMessage(,"%Compiler","CompileStarted",,$zdt($horolog),qstruct)
	Do normalizeItems^%apiOBJ(.list,,,.qstruct)
	Set item=$order(list(""))
	While item'="" {
		Set ext=$piece(item,".",$length(item,"."))
		If $$$isVMS Set ext=$piece(ext,";")
		If $case($zconvert(ext,"l"),"csp":1,"csr":1,:0) {
			Set itemlist($zconvert(ext,"u"),item)=""
		} ElseIf item'["/" {
			Set slot=$select($$$rtnIsMAC(ext):"MAC",$$$rtnIsINT(ext):"INT",1:$zconvert(ext,"U"))
			Set itemlist(slot,$piece(item,".",1,$length(item,".")-1))=$zconvert(ext,"u")
		}
		Set item=$order(list(item))
	}
	Set sc=##class(%Studio.Project).realCompile(.qstruct,.errorlog,.itemlist,.updatedlist)
	Quit $$reportCompile^%apiOBJ(sc,$$$qualifierGetValue(qstruct,"displaylog"),,,zh)
}

/// Invoke $system.OBJ.CompileAll for all the namespaces.
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>errorlog</td>
/// 		<td>
/// 			<p>
/// 				<var>errorlog</var> is an array of the <class>%Status</class> error values encountered during the execution of this 
/// 				method. Each status value is in the format returned by $system.Status.DecomposeStatus.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// </table>
/// </p>
ClassMethod CompileAllNamespaces(qspec As %String = "", ByRef errorlog As %String) As %Status [ CodeMode = expression ]
{
$$CompileAllNamespaces^%apiOBJ(.qspec,.errorlog)
}

/// Compile all classes within this namespace.
/// By default it will not compile classes mapped from another database unless the qualifier '/mapped=1' is provided.
/// <br><var>qspec</var> is a list of flags or qualifiers which can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// and 'Do $system.OBJ.ShowFlags()'.
ClassMethod CompileAll(qspec As %String = "", ByRef errorlog As %String) As %Status [ CodeMode = expression ]
{
$$CompileAll^%apiOBJ(.qspec,.errorlog)
}

/// Compile all classes within the specified package.
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>package</td>
/// 		<td>
/// 			<p>
/// 				You can pass one or more comma separated packages in <var>package</var> argument.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>errorlog</td>
/// 		<td>
/// 			<p>
/// 				<var>errorlog</var> is an array of the <class>%Status</class> error values encountered during the execution of this 
/// 				method. Each status value is in the format returned by $system.Status.DecomposeStatus.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// </table>
/// </p>
ClassMethod CompilePackage(package As %String = "", qspec As %String = "", ByRef errorlog As %String) As %Status [ CodeMode = expression ]
{
$$CompilePackage^%apiOBJ(package,.qspec,.errorlog)
}

/// Compile all entries in this project.
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>project</td>
/// 		<td>
/// 			<p>
/// 				The name of the package to be compiled.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>errorlog</td>
/// 		<td>
/// 			<p>
/// 				<var>errorlog</var> is an array of the <class>%Status</class> error values encountered during the execution of this 
/// 				method. Each status value is in the format returned by $system.Status.DecomposeStatus.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// </table>
/// </p>
ClassMethod CompileProject(project As %String = "", qspec As %String = "", ByRef errorlog As %String) As %Status
{
	If (project="") {
		Write $$$GetSimpleMessage("%Compiler","OBJCompileProjectError"),!
		Quit $$$ERROR($$$ProjectNoName)
	}
	Quit $$CompileProject^%apiOBJ(project,.qspec,.errorlog)
}

/// Delete a class.
/// <p>Delete the definition of class <var>classes</var> from this namespace which can be a single class, a comma separated list, a subscripted
/// array of class names, or include wild cards. If the class to delete is persistent 
/// include the 'e' flag or '/deleteextent' qualifier to delete the extent data 
/// and extent metadata. Refer to <class>%ExtentMgr.Util</class> for more information 
/// on extent metadata. 
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>classes</td>
/// 		<td>
/// 			<p>
/// 				The class, a comma separated list of classes or a subscripted array of class names. Wild cards may be specified. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>errorlog</td>
/// 		<td>
/// 			<p>
/// 				<var>errorlog</var> is an array of the <class>%Status</class> error values encountered during the execution of this 
/// 				method. Each status value is in the format returned by $system.Status.DecomposeStatus.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// </table>
/// </p>
ClassMethod Delete(ByRef classes As %String = "", qspec As %String = "", ByRef errorlog As %String) As %Status [ CodeMode = expression ]
{
$$Delete^%apiOBJ(.classes,.qspec,.errorlog)
}

/// Delete all the classes within the specified package.
/// Note that this ignores the '/mapped' qualifier as if you know the exact package name it is assumed
/// you wish to delete it even if the package is mapped from another database.
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>package</td>
/// 		<td>
/// 			<p>
/// 				You can pass one or more comma separated packages in <var>package</var> argument.
/// 				If <var>package</var> is '*' then all classes are deleted. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// </table>
/// </p>
ClassMethod DeletePackage(package As %String = "", qspec As %String = "") As %Status [ CodeMode = expression ]
{
$$DeletePackage^%apiOBJ(package,.qspec)
}

/// Delete all the classes in this namespace.
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// </table>
/// </p>
ClassMethod DeleteAll(qspec As %String = "") As %Status [ CodeMode = expression ]
{
$$DeletePackage^%apiOBJ("*",.qspec)
}

/// Delete the named project from this namespace.
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>project</td>
/// 		<td>
/// 			<p>
/// 				The name of the project to delete. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// </table>
/// </p>
ClassMethod DeleteProject(project As %String = "", qspec As %String = "") As %Status [ CodeMode = expression, ProcedureBlock = 1 ]
{
##class(%Studio.Project).%DeleteId(project)
}

/// Export items as an XML file
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>items</td>
/// 		<td>
/// 			<p>
/// 				The items to export.
/// 			</p>
/// 			<p>
/// 				Each of the <var>items</var> must have a type determined by an extension 
/// 				selected from the following list of basic types, additional types are
/// 				supported under the abstract routine interface so this list is not exhaustive.
/// 				<ul>
/// 				<li>CLS - Classes</li>
/// 				<li>CSP - Cache Server Pages</li>
/// 				<li>CSR - Cache Rule files</li>
/// 				<li>MAC - Macro routines</li>
/// 				<li>INT - Non-macro routines</li>
/// 				<li>BAS - Basic routines</li>
/// 				<li>INC - Include files</li>
/// 				<li>GBL - Globals</li>
/// 				<li>PRJ - Studio projects</li>
/// 				<li>OBJ - Compiled object code</li>
/// 				<li>PKG - Package definitions</li>
/// 				</ul>
/// 				If exporting multiple items, separate them with commas, pass the items("item")="" as an array, or use wild cards.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>filename</td>
/// 		<td>
/// 			<p>
/// 				If the output filename is empty, matching items will be exported to the current device. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 			<br>
/// 				If you pass qualifier '/recursive=1' then it will also export any related, e.g. include files included by 
/// 				a class or a superclass, the idea being that this will be a compilable set of items. 
/// 				If the filename ends in .gz or .gzip then it will automatically gzip the file. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>errorlog</td>
/// 		<td>
/// 			<p>
/// 				<var>errorlog</var> is an array of the <class>%Status</class> error values encountered during the execution of this 
/// 				method. Each status value is in the format returned by $system.Status.DecomposeStatus.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>Charset</td>
/// 		<td>
/// 			<p>
/// 				The character set to use for this export. If not specified then the default is 'utf-8'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// </table>
/// </p>
ClassMethod Export(ByRef items As %String = "", ByRef filename As %String = "", qspec As %String = "", ByRef errorlog As %String, Charset As %String = "") As %Status [ CodeMode = expression ]
{
$$ExportXMLList^%apiOBJ(.items,.filename,.qspec,.errorlog,Charset)
}

/// Export items in XML format to a stream
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>items</td>
/// 		<td>
/// 			<p>
/// 				The items to export.
/// 			</p>
/// 			<p>
/// 				Each of the <var>items</var> must have a type determined by an extension 
/// 				selected from the following list of basic types, additional types are
/// 				supported under the abstract routine interface so this list is not exhaustive.
/// 				<ul>
/// 				<li>CLS - Classes</li>
/// 				<li>CSP - Cache Server Pages</li>
/// 				<li>CSR - Cache Rule files</li>
/// 				<li>MAC - Macro routines</li>
/// 				<li>INT - Non-macro routines</li>
/// 				<li>BAS - Basic routines</li>
/// 				<li>INC - Include files</li>
/// 				<li>GBL - Globals</li>
/// 				<li>PRJ - Studio projects</li>
/// 				<li>OBJ - Compiled object code</li>
/// 				<li>PKG - Package definitions</li>
/// 				</ul>
/// 				If exporting multiple items, separate them with commas, pass the items("item")="" as an array, or use wild cards.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>stream</td>
/// 		<td>
/// 			<p>
/// 				The stream in which to place exported items. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 			<br>
/// 				If you pass qualifier '/recursive=1' then it will also export any related, e.g. include files included by 
/// 				a class or a superclass, the idea being that this will be a compilable set of items. 
/// 				If the filename ends in .gz or .gzip then it will automatically gzip the file. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>errorlog</td>
/// 		<td>
/// 			<p>
/// 				<var>errorlog</var> is an array of the <class>%Status</class> error values encountered during the execution of this 
/// 				method. Each status value is in the format returned by $system.Status.DecomposeStatus.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>Charset</td>
/// 		<td>
/// 			<p>
/// 				The character set to use for this export. Note that if you pass in a <var>Charset</var> and also pass in a character 
/// 				stream we will not use the Charset unless the stream is a file character stream. The reason for this is a character 
/// 				stream deals with characters so Charset is only about binary representations of character data. In this specific 
/// 				case of a file character stream we will set the TranslateTable on the file stream to the Charset. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// </table>
/// </p>
ClassMethod ExportToStream(items As %String = "", ByRef stream As %Stream.Object = "", qspec As %String = "", ByRef errorlog As %String, Charset As %String = "") As %Status
{
	Set isfile=0
	If $isobject($get(stream)),stream.%IsA("%Stream.Object"),stream.IsCharacter() {
		#; Check for a file character stream and handle this directly
		If $classname(stream)="%Library.FileCharacterStream"||($classname(stream)="%Stream.FileCharacter") {
			Set filestream=stream,isfile=1
			If Charset="" Set Charset="utf-8"
			Set charset=$$MapCharset^%SYS.NLS(Charset)
			If charset="" Quit $$$ERROR($$$CSPInvalidCharacterSet,Charset)
			If charset=$$GetCharset^%SYS.NLS() Set charset="RAW"
			Set filestream.TranslateTable=charset
		} Else {
			#; The tmp file stream will be utf-8
			Set filestream=##class(%FileCharacterStream).%New()
			Set filestream.TranslateTable="UTF8"
			Set Charset=""
		}
	} Else {
		Set filestream=##class(%FileBinaryStream).%New()
	}
	Do filestream.Write(""),filestream.Rewind()
	Set sc=$$ExportXMLList^%apiOBJ(.items,filestream.Filename,.qspec,.errorlog,Charset) If $$$ISERR(sc) Quit sc
	If $isobject($get(stream)),stream.%IsA("%Stream.Object"),'isfile {
		Do stream.CopyFrom(filestream)
	} Else {
		Set stream=filestream
	}
	Quit sc
}

/// Export all items matching a pattern to an XML file
/// <p>If you pass a pattern of '*.cls' then all classes in this namespace will be exported,
/// or a pattern of 'a*.mac' will export all MAC routines that start with the letter 'a' to be
/// exported. If the filename ends in .gz or .gzip it will automatically gzip the file.
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>pattern</td>
/// 		<td>
/// 			<p>
/// 				The pattern used to construct a list of items to be exported.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>filename</td>
/// 		<td>
/// 			<p>
/// 				If the output filename is empty, matching items will be exported to the current device. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 			<br>
/// 				If you pass qualifier '/recursive=1' then it will also export any related, e.g. include files included by 
/// 				a class or a superclass, the idea being that this will be a compilable set of items. 
/// 				If the filename ends in .gz or .gzip then it will automatically gzip the file. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>errorlog</td>
/// 		<td>
/// 			<p>
/// 				<var>errorlog</var> is an array of the <class>%Status</class> error values encountered during the execution of this 
/// 				method. Each status value is in the format returned by $system.Status.DecomposeStatus.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>Charset</td>
/// 		<td>
/// 			<p>
/// 				The character set to use for this export. If not specified then the default is 'utf-8'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// </table>
/// </p>
ClassMethod ExportPattern(pattern As %String = "", ByRef filename As %String = "", qspec As %String = "", ByRef errorlog As %String, Charset As %String = "") As %Status [ CodeMode = expression ]
{
$$ExportXMLPattern^%apiOBJ(.pattern,.filename,.qspec,.errorlog,Charset)
}

/// Export all items matching a pattern in XML format to a stream
/// <p>If you pass a pattern of '*.cls' then all classes in this namespace will be exported,
/// or a pattern of 'a*.mac' will export all MAC routines that start with the letter 'a' to be
/// exported.
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>pattern</td>
/// 		<td>
/// 			<p>
/// 				The pattern used to construct a list of items to be exported.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>stream</td>
/// 		<td>
/// 			<p>
/// 				If <var>stream</var> is passed in then the data is appended to this stream. If it is "" when called it will
/// 				create a stream and return this. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 			<br>
/// 				If you pass qualifier '/recursive=1' then it will also export any related, e.g. include files included by 
/// 				a class or a superclass, the idea being that this will be a compilable set of items. 
/// 				If the filename ends in .gz or .gzip then it will automatically gzip the file. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>errorlog</td>
/// 		<td>
/// 			<p>
/// 				<var>errorlog</var> is an array of the <class>%Status</class> error values encountered during the execution of this 
/// 				method. Each status value is in the format returned by $system.Status.DecomposeStatus.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>Charset</td>
/// 		<td>
/// 			<p>
/// 				The character set to use for this export. If not specified then the default is 'utf-8'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// </table>
/// </p>
ClassMethod ExportPatternToStream(pattern As %String = "", ByRef stream As %Stream.Object = "", qspec As %String = "", ByRef errorlog As %String, Charset As %String = "") As %Status
{
	Set filestream=##class(%FileBinaryStream).%New()
	Do filestream.Write("")
	Set sc=$$ExportXMLPattern^%apiOBJ(.pattern,filestream.Filename,.qspec,.errorlog,Charset) If $$$ISERR(sc) Quit sc
	If $isobject($get(stream)),stream.%IsA("%Stream.Object") {
		Do stream.CopyFrom(filestream)
	} Else {
		Set stream=filestream
	}
	Quit sc
}

/// Export a class to a Java file.
/// <p>Export class <var>classname</var> to a
/// JAVA file in directory <var>dirname</var>.
ClassMethod ExportJava(classname As %String = "", dirname As %String = "", qspec As %String = "", ByRef errorlog As %String, ByRef paths = "", ByRef Seen) As %Status
{
	s sc=$$$qualifierParse("Export",.qspec,.qstruct) q:$$$ISERR(sc) sc
	If dirname="" {
		If $$$isWINDOWS s ps="\",term="\"
		If $$$isUNIX s ps="/",term="/"
		If $$$isVMS s ps=".",term="]"
		Set NumberSlash=$length($zutil(12),ps)
		Set CacheDir=$piece($zutil(12),ps,1,NumberSlash-2)
		Set dirname=CacheDir_ps_"devuser"_ps_"java"_ps_$znspace_term
	}

	q $$ExportJavaList^%apiOBJ(classname,dirname,.qspec,.errorlog,.paths,.Seen)
}

/// Export classes in this package to Java.
/// <p>Search for classes in the <var>package</var> and export them. The search for classes respects
/// the <var>qspec</var> passed. If the <var>package</var> is "*" then it
/// will search for all classes in this namespace.
/// <p>Export class <var>package</var> to a
/// JAVA file in directory <var>dirname</var>.
ClassMethod ExportJavaPackage(Package As %String = "", dirname As %String = "", qspec As %String = "", ByRef errorlog As %String, ByRef paths = "") As %Status
{
	s sc=$$$qualifierParse("Export",.qspec,.qstruct) q:$$$ISERR(sc) sc
	If dirname="" {
		If $$$isWINDOWS s ps="\",term="\"
		If $$$isUNIX s ps="/",term="/"
		If $$$isVMS s ps=".",term="]"
		Set NumberSlash=$length($zutil(12),ps)
		Set CacheDir=$piece($zutil(12),ps,1,NumberSlash-2)
		Set dirname=CacheDir_ps_"devuser"_ps_"java"_ps_$znspace_term
	}
	s scall=$system.OBJ.GetPackageList(.items,Package,"+r")
	i $$$ISERR(scall) q scall
	s classes=""
	s comma=""
	s scall=$$$OK
	Do UpdatePartition^%occCompile()
	s name="" f  s name=$o(items(name)) q:name=""  d  ;q:$$$ISERR(sc)
	. s log=0
	. If $$$qualifierGetValue(qstruct,"checkuptodate")'="none" i $$isuptodate2^%occClass(name,log,0,$$$utdDESCRIPTION,'$$$qualifierGetValue(qstruct,"checksysutd"),,.utdcache)=0 s sc=$$$ERROR($$$LGClassMustBeUpToDate,name) d ProcessSc^%occLGUtil(sc,.qstruct) q
	. i '$$SuperIsRegistered^%occLGUtil(name,.super) s sc=$$$ERROR($$$LGSuperMustBeRegistered,name,super) d ProcessSc^%occLGUtil(sc,.qstruct) q
 	. i '$$SuperIsPersistent^%occLGUtil(name,.super) s sc=$$$ERROR($$$LGSuperMustBePersistent,name,super) d ProcessSc^%occLGUtil(sc,.qstruct) q
	. i $$CanBeProjected^%occLGUtil(name)=0 s sc=$$$ERROR($$$LGNotProjectible,name) d ProcessSc^%occLGUtil(sc,.qstruct) q
	. s sc=$$AllDependenciesProjectable^%occLGUtil(name,$$$qualifierGetValue(qstruct,"checkuptodate")'="none",.utdcache) d ProcessSc^%occLGUtil(sc,.qstruct) i $$$ISERR(sc) q
	. i $$$getClassType(name)=$$$cCLASSCLASSTYPEDATATYPE s sc=$$$ERROR($$$LGDataType,name) d ProcessSc^%occLGUtil(sc,.qstruct) q
 	. s sc=$system.OBJ.ExportJava(name, dirname,.qspec,.errorlog,.paths,.seen) s scall=$$$ADDSC(scall,sc)
 	. d ProcessSc^%occLGUtil(sc,.qstruct)
	Do UpdatePartition^%occCompile(1)
	q scall
}

/// Export a class to C++ files.
/// <p>Export class <var>classname</var> to 
/// C++ files in directory <var>dirname</var>.
ClassMethod ExportCPP(classname As %String = "", dirname As %String = "", qspec As %String = "", ByRef errorlog As %String) As %Status [ CodeMode = expression ]
{
$$ExportCPPList^%apiOBJ(classname,dirname,.qspec,.errorlog)
}

ClassMethod ExportDynCPP(classname As %String = "", dirname As %String = "", proplist As %String = "", methodlist As %String = "", qspec As %String, ByRef errorlog As %String) As %Status [ CodeMode = expression ]
{
$$ExportDynCPPList^%apiOBJ(classname,dirname,proplist,methodlist,.qspec,.errorlog)
}

/// Export a class to ODL file.
/// <p>Export class <var>classname</var> to 
/// ODL file with file name <var>filename</var>.
ClassMethod ExportODL(classname As %String = "", filename As %String = "", qspec As %String = "", ByRef errorlog As %String) As %Status [ CodeMode = expression ]
{
$$ExportODLList^%apiOBJ(classname,filename,.qspec,.errorlog)
}

/// Export a class or routine in UDL format.
/// <p>Export document <var>itemname</var> to file <var>filename</var> in UDL format.
ClassMethod ExportUDL(itemname As %String = "", filename As %String = "", qspec As %String = "", ByRef errorlog As %String, Charset As %String = "") As %Status [ CodeMode = expression ]
{
$$ExportUDL^%apiOBJ(itemname,filename,.qspec,.errorlog,Charset)
}

/// Export a set of classes in a package as an XML file.
/// <p>Export package <var>package</var> to an 
/// XML file with name <var>filename</var>.
ClassMethod ExportPackage(package As %String = "", ByRef filename As %String = "", qspec As %String = "", ByRef errorlog As %String, Charset As %String = "") As %Status [ CodeMode = expression ]
{
$$ExportXMLPackage^%apiOBJ(package,.filename,.qspec,.errorlog,Charset)
}

/// Export a set of classes in a package in XML format to a stream.
/// <p>Export package <var>package</var> to an XML file with name <var>filename</var>.
/// If <var>stream</var> is passed in then the data is appended to this stream. If it is "" when called it will
/// create a stream and return this.
ClassMethod ExportPackageToStream(package As %String = "", ByRef stream As %Stream.Object = "", qspec As %String = "", ByRef errorlog As %String, Charset As %String = "") As %Status
{
	Set filestream=##class(%FileBinaryStream).%New()
	Do filestream.Write("")
	Set sc=$$ExportXMLPackage^%apiOBJ(package,filestream.Filename,.qspec,.errorlog,Charset) If $$$ISERR(sc) Quit sc
	If $isobject($get(stream)),stream.%IsA("%Stream.Object") {
		Do stream.CopyFrom(filestream)
	} Else {
		Set stream=filestream
	}
	Quit sc
}

/// Export all the classes in this namespace as one large XML file.
/// <p>This function will loop through all the classes exporting them
/// to the file <var>filename</var>. It will restrict which classes are
/// exported based on the <var>qspec</var> 
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>filename</td>
/// 		<td>
/// 			<p>
/// 				The file where exported data will be placed.  
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 			<br>
/// 				If you pass qualifier '/recursive=1' then it will also export any related, e.g. include files included by 
/// 				a class or a superclass, the idea being that this will be a compilable set of items. 
/// 				If the filename ends in .gz or .gzip then it will automatically gzip the file. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>errorlog</td>
/// 		<td>
/// 			<p>
/// 				<var>errorlog</var> is an array of the <class>%Status</class> error values encountered during the execution of this 
/// 				method. Each status value is in the format returned by $system.Status.DecomposeStatus.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>Charset</td>
/// 		<td>
/// 			<p>
/// 				The character set to use for this export. If not specified then the default is 'utf-8'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// </table>
/// </p>
ClassMethod ExportAllClasses(ByRef filename As %String = "", qspec As %String = "", ByRef errorlog As %String, Charset As %String = "") As %Status [ CodeMode = expression ]
{
$$ExportXMLPackage^%apiOBJ("*",.filename,.qspec,.errorlog,Charset)
}

/// Export all the classes in this namespace to a stream. 
/// <p>This function will loop through all the classes exporting them 
/// to a stream. It will restrict which classes are exported based on the <var>qspec</var> 
/// </p>
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>stream</td>
/// 		<td>
/// 			<p>
/// 				If <var>stream</var> is passed in then the data is appended to this stream. If it is null when called it will
/// 				create a stream and return this.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 			<br>
/// 				If you pass qualifier '/recursive=1' then it will also export any related, e.g. include files included by 
/// 				a class or a superclass, the idea being that this will be a compilable set of items. 
/// 				If the filename ends in .gz or .gzip then it will automatically gzip the file. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>errorlog</td>
/// 		<td>
/// 			<p>
/// 				<var>errorlog</var> is an array of the <class>%Status</class> error values encountered during the execution of this 
/// 				method. Each status value is in the format returned by $system.Status.DecomposeStatus.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>Charset</td>
/// 		<td>
/// 			<p>
/// 				The character set to use for this export. If not specified then the default is 'utf-8'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// </table>
ClassMethod ExportAllClassesToStream(ByRef stream As %Stream.Object = "", qspec As %String = "", ByRef errorlog As %String, Charset As %String = "") As %Status
{
	Set filestream=##class(%FileBinaryStream).%New()
	Do filestream.Write("")
	Set sc=$$ExportXMLPackage^%apiOBJ("*",filestream.Filename,.qspec,.errorlog,Charset) If $$$ISERR(sc) Quit sc
	If $isobject($get(stream)),stream.%IsA("%Stream.Object") {
		Do stream.CopyFrom(filestream)
	} Else {
		Set stream=filestream
	}
	Quit sc
}

/// Export all the classes as individual XML files to a directory.
/// <p>This function will loop through all the classes exporting each one as an individual XML file
/// named after the classname to the directory <var>dirname</var>. If you specify a <var>Package</var> then
/// it will only export this package. If <var>SubDir</var> is true then it will export sub-packages as subdirectories. 
/// <br>
/// <p>
/// <h4>Parameters</h4>
/// <table border="1" title="Parameters">
/// 	<tr>
/// 		<th>Name</th><th>Description</th>
/// 	</tr>
/// 	<tr>
/// 		<td>dirname</td>
/// 		<td>
/// 			<p>
/// 				The directory where exported files will be placed.  
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>qspec</td>
/// 		<td>
/// 			<p>
/// 				<var>qspec</var> is a list of flags and qualifiers that can be displayed with 'Do $system.OBJ.ShowQualifiers()'
/// 				and 'Do $system.OBJ.ShowFlags()'. 
/// 			</p>
/// 			<br>
/// 				If you pass qualifier '/recursive=1' then it will also export any related, e.g. include files included by 
/// 				a class or a superclass, the idea being that this will be a compilable set of items. 
/// 				If the filename ends in .gz or .gzip then it will automatically gzip the file. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>errorlog</td>
/// 		<td>
/// 			<p>
/// 				<var>errorlog</var> is an array of the <class>%Status</class> error values encountered during the execution of this 
/// 				method. Each status value is in the format returned by $system.Status.DecomposeStatus.
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>Charset</td>
/// 		<td>
/// 			<p>
/// 				The character set to use for this export. If not specified then the default is 'utf-8'. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>Package</td>
/// 		<td>
/// 			<p>
/// 				If you specify a <var>Package</var> then it will only export this package. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td>Subdir</td>
/// 		<td>
/// 			<p>
/// 				If <var>SubDir</var> is true then it will export sub-packages as subdirectories. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// 		<td></td>
/// 		<td>
/// 			<p>
/// 				The return value is a %Status value indicating success or failure. 
/// 			</p>
/// 		</td>
/// 	</tr>
/// 	<tr>
/// </table>
/// </p>
ClassMethod ExportAllClassesIndividual(dirname As %String = "", qspec As %String = "", ByRef errorlog As %String, Charset As %String = "", Package As %String = "*", SubDir As %Boolean = 0) As %Status [ CodeMode = expression ]
{
$$ExportXMLAll^%apiOBJ(dirname,.qspec,.errorlog,Package,SubDir,Charset)
}

/// Return an array of classes in this package.
/// <p>Search for classes in the <var>package</var> and put their names
/// into the local array <var>items</var>. If the <var>package</var> is "*" then it
/// will return for all classes in this namespace. It uses the qualfier in <var>qspec</var> /includesubpackages
/// to determine if it searches inside a package to subpackages or not.
/// <var>qspec</var> is a list of flags or qualifiers which can be displayed with 'Do $system.OBJ.ShowQualifiers()' 
/// and 'Do $system.OBJ.ShowFlags()'. 
ClassMethod GetPackageList(ByRef items As %String, package As %String, qspec As %String = "") As %Status
{
	Set sc=$$$qualifierParse("Compiler",.qspec,.qstruct) Quit:$$$ISERR(sc) sc
	Kill items
	Quit $$GetPackageList^%occLibrary(.items,package,.qstruct)
}

/// Return an array of classes in this namespace.
/// <p>Search for classes in this namespace and put their names
/// into the local array <var>items</var>. 
/// <var>qspec</var> is a list of flags or qualifiers which can be displayed with 'Do $system.OBJ.ShowQualifiers()' 
/// and 'Do $system.OBJ.ShowFlags()'. The search for classes respects 
/// the <var>qspec</var> passed. It uses the following qualifiers<ul>
/// <li>/application=1/0 - Include application classes</li>
/// <li>/system=1/0 - Include system classes (ones with class attribute 'system' set to something other than zero)</li>
/// <li>/percent=1/0 - Include percent classes</li>
/// <li>/mapped=1/0 - Include classes mapped from other databases or just classes in default databases</li></ul>
ClassMethod GetClassList(ByRef items As %String, qspec As %String = "") As %Status
{
	Set sc=$$$qualifierParse("Compiler",.qspec,.qstruct) Quit:$$$ISERR(sc) sc
	Kill items
	Quit $$GetClassFullList^%occLibrary(.items,.qstruct)
}

/// Make a class or classes deployed. 
/// <var>classes</var> can be a single class, a comma separated list, a subscripted 
/// array of class names, or include wild cards. 
/// This will delete all the source code of the class from the disk. 
/// Once a class is in deployed mode, it can not be edited or exported or recompiled. 
/// You can still create subclasses of a deployed class and compile these. 
/// <var>qspec</var> is a list of flags or qualifiers which can be displayed with 'Do $system.OBJ.ShowQualifiers()' 
/// and 'Do $system.OBJ.ShowFlags()'. 
/// If <var>fulldeploy</var> is true it will attempt to remove pretty much the entire class definition leaving just 
/// the minimum so the class is runnable, this will not work on persistent, serial, datatype, or XML enabled classes as these require 
/// access to the class definition at runtime in order to function. 
ClassMethod MakeClassDeployed(ByRef classes As %String = "", qspec As %String = "", fulldeploy As %Boolean = 0) As %Status [ CodeMode = expression ]
{
$$MakeClassDeployed^%apiOBJ(.classes,.qspec,,.fulldeploy)
}

/// Uncompile a class or classes. 
/// <var>classes</var> can be a single class, a comma separated list, a subscripted 
/// array of class names, or include wild cards. 
/// <var>qspec</var> is a list of flags or qualifiers which can be displayed with 'Do $system.OBJ.ShowQualifiers()' 
/// and 'Do $system.OBJ.ShowFlags()'. 
ClassMethod UnCompile(ByRef classes As %String = "", qspec As %String = "") As %Status [ CodeMode = expression ]
{
$$UnCompile^%apiOBJ(.classes,.qspec)
}

/// Write all classes defined in this namespace to the console. 
/// <p>The optional <var>qspec</var> argument is a qualifier string containing 
/// any of the following options: 
/// <table cols=2 cellpadding=5> 
/// <tr><td>/detail</td><td>Show details.</td></tr>
/// <tr><td>/hidden</td><td>Show hidden classes.</td></tr>
/// <tr><td>/mapped</td><td>Show mapped classes.</td></tr>
/// </table>
/// <p>For example:
/// <example>
/// Do $System.OBJ.ShowClasses("/detail")
/// </example>
ClassMethod ShowClasses(qspec As %String = "") As %Status
{
	; Name:Super:Hidden:Datatype:System:Final:Persistent:Serial:TimeChanged:
	Set sc=$$$qualifierParse("ShowClassAndObject",.qspec,.qstruct) q:$$$ISERR(sc) sc
	
	Set fh=$$$qualifierGetValue(qstruct,"hidden")  ; show hidden classes
	Set fd=$$$qualifierGetValue(qstruct,"detail")  ; show details
	Set fm=$$$qualifierGetValue(qstruct,"mapped")
	
	Set result=##class(%ResultSet).%New("%ClassDefinition.ClassInfo")
	Do result.Execute("",fm)
	For  Quit:result.Next()=0  Do
	. ; filter out classes
	. Set ch=result.GetDataByName("Hidden")
	. Set show=('ch)!(ch&fh)
	. If show Write result.GetDataByName("Name") Write:fd ?25,$zdt(result.GetDataByName("TimeChanged")) Write !
	Quit $$$OK
}

/// Write all object instances in this process to the console.
/// <p>The optional <var>qspec</var> argument is a string containing 
/// any of the following characters:
/// <table cols=2 cellpadding=5>
/// <tr><td>/detail=1</td><td>Show details.</td></tr>
/// </table>
/// <p>For example:
/// <example>
/// Do $System.OBJ.ShowObjects("/detail=1")
/// </example>
ClassMethod ShowObjects(qspec As %String = "") As %Status
{
	Do ListAllObjects^%apiOBJ(.qspec)
	Quit $$$OK
}

/// Deprecated function, to close objects let them go out of scope.
ClassMethod CloseObjects() As %Status [ CodeMode = expression ]
{
$$$OK
}

/// Save all instances of %Library.Persistent in the process. Returns a status value.
ClassMethod SaveObjects() As %Status
{
	set tOref = $zobjnext(""), rStatus = $$$OK
	while $isobject(tOref) {
		if tOref.%IsA("%Library.Persistent") {
			set tSC = tOref.%Save()
			set rStatus = $$$ADDSC(rStatus,tSC)
		}
		set tOref = $zobjnext(tOref)
	}
	quit rStatus
}

/// Return the version number of the current object library.
ClassMethod Version() As %String [ CodeMode = expression ]
{
$$GetVersion^%apiOBJ()
}

/// Display the list of flags used by the compiler.
ClassMethod ShowFlags()
{
	Write "    b - Include sub classes.",!
	Write "    c - Compile. Compile the class definition(s) after loading.",!
	Write "    d - Display. This flag is set by default.",!
	Write "    e - Delete extent.",!
	Write "    h - Generate help.",!
	Write "    i - Validate XML export format against schema on Load.",!
	Write "    k - Keep source.  When this flag is set, source code of",!
	Write "        generated routines will be kept.",!
	Write "    l - Lock classes while compiling.  This flag is set by default.",!
	Write "    p - Percent.  Include classes with names of the form %*.",!
	Write "    r - Recursive.  Compile all the classes that are dependency predecessors.",!
	Write "    s - Process system messages or application messages.",!
	Write "    u - Update only.  Skip compilation of classes that are already up-to-date.",!
	Write "    y - Include classes that are related to the current class in the way that",!
	Write "        they either reference to or are referenced by the current class in SQL usage.",!
	Write !
	Write "These flags are deprecated a, f, g, o, q, v",!
	Write "Default flags for this namespace ",$$$FormatFlag(""),!
	Write "You may change the default flags with the SetFlags(flags,system) classmethod.",!
	Quit
}

/// Display the list of qualifiers defined in the system.
/// It also shows the default qualifiers defined at system level and at namespace levels.
/// The argument <var>group</var> has been deprecated.
ClassMethod ShowQualifiers(group As %String = "")
{
	Set qname="" For  Set qname=$o($$$xQUALIFIER(qname)) Quit:qname=""  Do  Write !
	. Set type=$$$xQUALIFIERtype(qname),desc=$$$xQUALIFIERdescription(qname)
	. If desc="Deprecated." Quit
	. Write "           Name: /",qname,!
	. Write "    Description: ",desc,!
	. Write "           Type: ",type,!
	. If $extract($get($$$xQUALIFIERflagequivalence(qname,1)),2,*)'="" Do
	. . Write "           Flag: ",$extract($$$xQUALIFIERflagequivalence(qname,1),2,*),!
	. ;
	. If type="logical" Do  Quit
	. . Write "  Default Value: ",$$$xQUALIFIERdefaultvalue(qname),!
	. ;
	. If type="enum" Do  Quit
	. . Write "      Enum List: ",$$$xQUALIFIERenumlist(qname),!
	. . Write "  Default Value: ",$$$xQUALIFIERdefaultvalue(qname),!
	. . Write "  Present Value: ",$$$xQUALIFIERpresentvalue(qname),!
	. . Write "  Negated Value: ",$$$xQUALIFIERnegatedvalue(qname),!
	. ;
	. If type="alias" Do  Quit
	. . Write "      Enum List: ",$$$xQUALIFIERenumlist(qname),!
	. . Write "     Alias List: ",$$$xQUALIFIERaliaslist(qname),!
	. . Write "  Present Value: ",$s($d($$$xQUALIFIERpresentvalue(qname))=0:"(none)",1:$$$xQUALIFIERpresentvalue(qname)),!
	. . Write "  Negated Value: ",$s($d($$$xQUALIFIERnegatedvalue(qname))=0:"(none)",1:$$$xQUALIFIERnegatedvalue(qname)),!
	. . Write "      All Value: ",$$$xQUALIFIERallvalue(qname),!
	. . Write "     None Value: ",$$$xQUALIFIERnonevalue(qname),!
	. ;
	;
	If $g(^%oddENV($$$cENVdefaultqualifiers))'="" {
		Write "Default Qualifiers at system level are: ",^%oddENV($$$cENVdefaultqualifiers),!
	} Else {
		Write "No Default Qualifiers at system level are set.",!
	}
	Set tFound=0
	Set ns="" For  {
		Set ns=$o(^%oddENV($$$cENVdefaultqualifiers,ns)) Quit:ns=""
		If $g(^%oddENV($$$cENVdefaultqualifiers,ns))'="" {
			Write "Default Qualifiers for namespace '",ns,"' are: ",^%oddENV($$$cENVdefaultqualifiers,ns),!
			Set tFound=1
		}
	}
	If tFound=0	Write "No Default Qualifiers for namespaces are set",!
	;
	Quit
}

/// Display a list of all variables that contain a reference to this <var>oref</var>.
/// If <var>chkObj</var> is set to 1, the properties of any varibles that contain an object
/// reference will also be searched and displayed.
/// Otherwise only non-object variables will be searched.
/// <br>The list has the base $STACK level of the variable, the internal stack level
/// (as shown by the %STACK utility), and the variable name.
/// 
ClassMethod ShowReferences(oref As %String, chkObj As %Boolean = 0) [ PublicList = arr ]
{
 s st=0 f ln=1:1:$ZU(41)-3 s:"CDSBEedxX"[$E($ZU(41,ln)) st=st+1 s st(ln)=st
 n arr
 for ln=1:1:$ZU(41)-3 { s n="",priv=0
   for { s n=$ZU(42,ln,n) if n="" { q:priv  s priv=1,n="~" continue }
     continue:$ZU(41,ln,n)'=ln ; ignore if not the base level
     s val=$ZU(43,ln,n)
     If val=oref w $J($G(st(ln)),2)," ",$J(ln,3)," ",$E(n,$E(n)="~"+1,*),!
     If chkObj,$IsObject(val)>0 {
       k arr Do DumpObject^%occRun(val,"arr")
       s strval=""""_oref_""""_$C(13,10)
       f i=1:1:$G(arr(1)) {
         If arr(1,i)[strval { s p=$F(arr(1,i)," =")
           If p { s j=i } Else { s j=i-1,p=$F(arr(1,j)," =") }
           s p=$ZSTRIP($E(arr(1,j),2,p-2),"*W") w $J($G(st(ln)),2)," ",$J(ln,3)," ",$E(n,$E(n)="~"+1,*),".",p,!
         }
       }
     }
   }
 }
}

/// Display the list of supported macros defined in the system.
ClassMethod ShowMacros()
{
	Set MacNm=""
	Set MacNm=$ORDER(^rINC(MacNm))
	Set Mark="///"
	Set Define="#define"
	Set Def1Arg="#def1arg"
 
	While (MacNm '= "") {
		Set LnCnt=$GET(^rINC(MacNm,0,0),0)
		Set DispMacNm=MacNm
		Set Comments=0
		For n=1:1:LnCnt {
			Set Ln=$GET(^rINC(MacNm,0,n),"")
			If ($E(Ln,1,$L(Mark))[Mark) {
				Write:($L(DispMacNm)>0) !,"Include file: ",DispMacNm,!,!
				Set DispMacNm=""
				Set Comments=Comments+1
				Write Ln,!
			}
			ElseIf (Comments>0) {
				If (($E(Ln,1,$L(Define))[Define)||($E(Ln,1,$L(Def1Arg))[Def1Arg)) {
					Set EndDef=$FIND(Ln," ")
					Set Def=$ZSTRIP($E(Ln,1,(EndDef-1)),"<>W")
					Set Text=$ZSTRIP($E(Ln,EndDef,*),"<>W")
					Set EndNm=$FIND(Text," ")
					Set Name=$ZSTRIP($E(Text,1,(EndNm-1)),"<>W")
					Set Text=$ZSTRIP($E(Text,EndNm,*),"<>W")
					Write Def," ",Name," ",Text,!,!
					Set Comments=0
				}
			}
			Else {
				Set Comments=0
			}
		}
		Set MacNm=$ORDER(^rINC(MacNm))
	}
	Quit
}

/// Set the default flags for this namespace or this system.
/// If system is true then this sets the default flags for this system, otherwise
/// it sets the default flags for this namespace. If flags are set for this
/// namespace these override any set for the system. These flags are combined with
/// the built in defaults to create the defaults used. This method returns the new
/// defaults after this change.
ClassMethod SetFlags(flags As %String, system As %Boolean = 0) As %String
{
	If system {
		Do SetoddENV^%SYS.OBJECTS($$$cENVdefaultflags,flags)
	} Else {
		Set ^%oddENV($$$cENVdefaultflags,$zutil(5))=flags
	}
	Quit $$$FormatFlag("")
}

/// Set the default qualifiers for this namespace or this system.
/// If system is true then this sets the default qualifiers for this system, otherwise
/// it sets the default qualifiers for this namespace. If qualifiers are set for this
/// namespace these override any set for the system. These qualifiers are combined with
/// the built in defaults to create the defaults used.
/// The argument <var>group</var> has been deprecated.
ClassMethod SetQualifiers(qspec As %String = "", system As %Boolean = 0, group As %String) As %Status
{
	If qspec'="",$e(qspec)'="/" set qspec="/"_qspec
	Set sc=$$$qualifierParse("",.qspec,.qstruct) q:$$$ISERR(sc) sc
	;
	If system {
		Set sc=$$SetoddENV^%SYS.OBJECTS($$$cENVdefaultqualifiers,qspec)
	} Else {
		Set ^%oddENV($$$cENVdefaultqualifiers,$zutil(5))=qspec
	}
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
	Quit sc
}

/// Get the default qualifiers for this namespace or this system.
/// If system is true then this gets the default qualifiers for this system, otherwise
/// it sets the default qualifiers for this namespace. 
ClassMethod GetQualifiers(system As %Boolean = 0) As %String
{
	#Define qspec As %String;
	#Define sc As %Status;
	
	If system {
		Set sc=$$GetoddENV^%SYS.OBJECTS($$$cENVdefaultqualifiers,.qspec)
		Set qspec = $get(qspec)
	} Else {
		Set qspec = $get(^%oddENV($$$cENVdefaultqualifiers,$zutil(5)),"")
		Set sc=$$$OK
	}
	If $$$ISERR(sc) {
		Do $system.OBJ.DisplayError(sc)
	}
	Quit qspec
}

// Query

/// This query returns a list of all object instances currently 
/// in memory within the current process.
Query ObjectList() As %Query(ROWSPEC = "OREF:%Integer:Integer version of the oref,ClassName:%String")
{
}

ClassMethod ObjectListExecute(ByRef QHandle As %Binary) As %Status
{
	Set QHandle=$$$SYSFUNCNULLOREF
	Quit $$$OK
}

ClassMethod ObjectListClose(QHandle As %Binary) As %Status
{
	Set QHandle=$$$SYSFUNCNULLOREF
	Quit $$$OK
}

ClassMethod ObjectListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
	Set Row=""
	
	Set QHandle=$zobjnext(QHandle)
	If QHandle=$$$SYSFUNCNULLOREF Set AtEnd=1 Quit $$$OK
	
	Set Row=$LB($$$objOrefToInt(QHandle),$classname(QHandle))
	Quit $$$OK
}

/// Upgrade the class definition database in one namespace.
ClassMethod Upgrade(qspec As %String = "", ByRef errorlog As %String) As %Status [ CodeMode = expression ]
{
$$Upgrade^%occConvert(.qspec,.errorlog)
}

/// Upgrade the class definition database in all the namespaces.
ClassMethod UpgradeAll(qspec As %String = "", ByRef errorlog As %String) As %Status [ CodeMode = expression ]
{
$$UpgradeAll^%occConvert(.qspec,.errorlog)
}

/// Import the system messages for the specified language from ...\mgr\Locale\allmessages_[language].xml
/// and make this the current language.
/// If language is not specified, then Upgrade the Object locale and
/// import the current language.
ClassMethod LoadLanguage(language As %String = "", qspec As %String = "") As %Status
{
	Set sc=$$$qualifierParse("Compiler",.qspec,.qstruct) q:$$$ISERR(sc) sc
	If language="" {
		Do Upgrade^%occMessages()
		Set language=$get($$$DefaultLanguageNode)
	} Else {
		Do SetDefaultLanguage^%occMessages(language)
	}
	If language="" {
		Set sc=$$$ERROR($$$LanguageNotSpecified)
		If $$$qualifierGetValue(qstruct,"displaylog") Do ..DisplayError(sc)
	}
	If $$$ISOK(sc) {
		Set dir=$$$LOCALEPATH
		Set name="allmessages_"
		Set file=dir_name_language_".xml"
		If ##class(%File).Exists(file) {
			Set sc=$$Import^%occMessages(file,.qstruct,,,1)
			If $$$ISOK(sc) && $$$qualifierGetValue(qstruct,"displaylog") {
				Write file,$$$GetSimpleMessage("%Compiler","Loaded"),!
			}
		} Else {
			If $$$qualifierGetValue(qstruct,"displaylog") {
				Write file,$$$GetSimpleMessage("%Compiler","FileNotFound"),!
			}
		}
		If $$$ISERR(sc) Quit
	}
	Quit sc
}

/// Return $$OK if this class name is valid, or an error message if it is not.
/// If it is invalid it is typically because it contains characters that are
/// not allowed in a class name or because it clashes with a class that already
/// exists (different case in package say).
ClassMethod IsValidClassname(class As %String) As %Status
{
	Set sc=$$IsClassnameConflict^%occName(class)
	If $$$ISERR(sc) Quit sc
	Quit $$IsClassnameValid^%occName(,class)
}

/// Return if this <var>class</var> is up to date or not.
/// If <var>log</var> is true then it will display a log of what it is checking
/// in order to show if it is up to date or not. The <var>type</var> determines what it
/// looks at to see if this class is up to date:
/// <ul><li>0 - Check timestamps on class, so even if a description was modified this will
/// show the class as out of date</li>
/// <li>1 - Ignore changes to descriptions in checking up to date status, this is the default
/// and is what the class compiler typically uses.</li>
/// <li>2 - Ignore changes to descriptions and method code in checking up to date status, this
/// is useful to see if the class has 'structurally' changed in a way that would require a class
/// referencing this via SQL to be recompiled</li>
ClassMethod IsUpToDate(class As %String, log As %Boolean = 0, type As %Integer = 1) As %Boolean
{
	New $$$tCOMPILEDATA
	Set class=$$$NormalizeClassname(class)
	Set sc=$$$qualifierParse("Compiler","",.qstruct) Quit:$$$ISERR(sc) sc
	Set checksysutd=$$$qualifierGetValue(qstruct,"checksysutd")
	Set sc=$$isuptodate2^%occClass(class,log,0,type,'checksysutd)
	Quit sc
}

/// This will return a list of classes the class compiler will include if the listed classes are compiled.
/// The <var>class</var> can be a single class, a comma separated list, a subscripted
/// array of class names, or include wild cards. It returns the list of classes that will be compiled
/// in <var>included</var> based on the compile <var>qspec</var>.
ClassMethod GetDependencies(ByRef class As %String, Output included As %String, qspec As %String) As %Status
{
	New $$$tCOMPILEDATA
	Set sc=$$$qualifierParse("Compiler",.qspec,.qstruct) Quit:$$$ISERR(sc) sc
	#; Make sure we do not display any output
	Set sc=$$$qualifierAmend("Compiler",.qstruct,"-d",.qstructa) Quit:$$$ISERR(sc) sc
	Do normalizeItems^%apiOBJ(.class,,"cls",.qstructa)
	Set sc=$$IncludeClasses^%occCompile(.class,.included,.qstructa)
	Set i="" For  Set i=$order(included(i)) Quit:i=""  Set included(i)=""
	Quit sc
}

/// Set the object transaction mode for the current process to a new value.
/// Valid values are:
/// <p>
/// <table cols=2 cellpadding=5>
/// <tr><td>0</td><td>No transactions used for Object filing</td></tr>
/// <tr><td>1</td><td>Use transactions for Object filing</td></tr>
/// </table>
/// If a valid value is passed in then the transaction mode for the current process will be set to that value and the previous transaction mode value is returned.
/// Otherwise the transaction mode setting is left unchanged and <var>pStatus</var> will contain a %Status
/// value describing the error and the current transaction mode value is returned.
ClassMethod SetTransactionMode(value As %Integer = 1, ByRef pStatus As %Library.Status) As %Integer
{
	if '$Find("|0|1",value) { set pStatus = $$$ERROR($$$DTValueList,value,"0|1") quit $zu(115,9) }
	set pStatus = $$$OK
	quit $zu(115,9,value)
}

/// Return the current Object transaction mode.
ClassMethod GetTransactionMode() As %Integer [ CodeMode = expression ]
{
$zu(115,9)
}

/// Set the Object concurrency mode for the current process to a new value.
/// Valid values are:
/// <p>
/// <table cols=2 cellpadding=5>
/// <tr><td>0</td><td>No concurrency controls</td></tr>
/// <tr><td>1</td><td>Atomic</td></tr>
/// <tr><td>2</td><td>Shared</td></tr>
/// <tr><td>3</td><td>Shared retained</td></tr>
/// <tr><td>4</td><td>Exclusive</td></tr>
/// </table>
/// If a valid value is passed in then the concurrency mode for the current process will be set to that value and the previous concurrency mode value is returned.
/// Otherwise the concurrency mode setting is left unchanged and <var>pStatus</var> will contain a %Status
/// value describing the error and the current concurrency mode value is returned.
ClassMethod SetConcurrencyMode(value As %Integer = 1, ByRef pStatus As %Library.Status) As %Integer
{
	if '$Find("|0|1|2|3|4",value) { set pStatus = $$$ERROR($$$DTValueList,value,"0|1|2|3|4") quit $zu(115,10) }
	set pStatus = $$$OK
	quit $zu(115,10,value)
}

/// Return the current Object Concurrency mode.
ClassMethod GetConcurrencyMode() As %Integer [ CodeMode = expression ]
{
$zu(115,10)
}

/// Turn output redirection on and off in the binding server.
ClassMethod RedirectBindSrvUserOutput(val As %Boolean)
{
	set ^||BindSrvRedirectOutput=val
}

/// Given a <var>class</var> this returns the <var>version</var> of Cache this was compiled on and the <var>compiletime</var> of this class.
ClassMethod CompileInfoClass(class As %String, Output version As %String, Output compiletime As %String) As %Status
{
	Set version="",compiletime=""
	If $get(class)="" Quit $$$ERROR($$$ClassNameRequired)
	Set class=$$$NormalizeClassname(class)
	If '$$$defClassDefined(class) Quit $$$ERROR($$$ClassDoesNotExist,class)
	If '$$$comClassDefined(class) Quit $$$ERROR($$$CompiledClassDoesNotExist,class)
	Set version=$$$comClassKeyGet(class,$$$cCLASScacheversion)
	Set compiletime=$$$comClassKeyGet(class,$$$cCLASStimechanged)
	If compiletime'="" Try { Set compiletime=$$$TimeToODBC(compiletime) } Catch { Set compiletime="" }
	Quit $$$OK
}

/// Query to return version and time when classes were compiled.
/// This only returns compiled classes, so classes not compiled are skipped. The <var>sortorder</var>
/// can be one of:<ul>
/// <li>0 - Time class was compiled (default)</li>
/// <li>1 - Classname</li>
/// <li>2 - Cache version</li></ul>
Query CompileInfo(sortorder As %Integer = 0) As %Query(ROWSPEC = "Name:%String:Class name,Version:%String:Cache version it was compiled on,Time:%TimeStamp:Date/time class was compiled") [ SqlProc ]
{
}

ClassMethod CompileInfoExecute(ByRef QHandle As %Binary, sortorder As %Integer = 0) As %Status
{
	Set idx=$increment($$$ISCQUERYTEMP),count=0
	Set cls=$select($namespace="%SYS":"",1:"&")
	For {
		Set cls=$$$comClassNext(cls) Quit:cls=""
		Set version=$$$comClassKeyGet(cls,$$$cCLASScacheversion)
		Set compiletime=$$$comClassKeyGet(cls,$$$cCLASStimechanged)
		If compiletime'="" Try { Set compiletime=$$$TimeToODBC(compiletime) } Catch { Set compiletime="" }
		Set sort=$case(sortorder,0:compiletime,1:cls,2:version)
		Set $$$ISCQUERYTEMP(idx,sort_$c(0)_$increment(count))=$listbuild(cls,version,compiletime)
	}
	Set QHandle=$listbuild(idx,"")
	Quit $$$OK
}

ClassMethod CompileInfoClose(QHandle As %Binary) As %Status
{
	#; Close the collection
	If $listget(QHandle)'="" {
		Kill $$$ISCQUERYTEMP($list(QHandle))
	}
	Set QHandle=""
	Quit $$$OK
}

ClassMethod CompileInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ CodeMode = expression ]
{
..CompileInfoFetchRows(.QHandle,1,.Row,,.AtEnd)
}

ClassMethod CompileInfoFetchRows(ByRef QHandle As %Binary, FetchCount As %Integer = 0, ByRef RowSet As %List, ByRef ReturnCount As %Integer, ByRef AtEnd As %Integer) As %Status
{
	Set idx=$list(QHandle),item=$list(QHandle,2)
	Set number=0,RowSet=""
	Set item=$order($$$ISCQUERYTEMP(idx,item),1,data)
	While item'="" {
		Set RowSet=RowSet_data,number=number+1
		If number=FetchCount||($length(RowSet)>20000) Quit
		Set item=$order($$$ISCQUERYTEMP(idx,item),1,data)
	}
	If item="" {
		Set AtEnd=1,QHandle=""
		Kill $$$ISCQUERYTEMP(idx)
		Quit $$$OK
	}
	Set QHandle=$listbuild(idx,item)
	Quit $$$OK
}

/// Allows updating a CONFIGVALUE parameter type.
/// If you have defined a <var>parameter</var> in the <var>classname</var> which is specified as 'CONFIGVALUE'
/// in the type keyword then this function allows this to be updated from the original value to a
/// new value. Note that this should be a rare event and not be used for any value that needs to be
/// updated a lot, a global should be used for a rapidly updating value. The advantage of using a class
/// parameter for a configuration value is that a very large number of processes can access this value
/// using 'Set val=##class(ClassName).#ParamName' faster than access to a global.
ClassMethod UpdateConfigParam(classname As %String, parameter As %String, value As %String) As %Status
{
	Quit $$UpdateConfigParam^%apiOBJ(.classname,.parameter,.value)
}

/// Validate indices for a class
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>classname</i>
/// <dd>Name of the persistent class to validate indices for.
/// <dt><i>idxList</i>
/// <dd>Optional.  "" to check all indices, or specify a $list of index names to check.  Default=""
/// <dt><i>autoCorrect</i>
/// <dd>Optional.  If true, correct any errors found.  Default=0
/// <dt><i>lockOption</i>
/// <dd>Optional.  Default = 1
///      0 - No locking is performed at all
///      1 - Shared locking as each row is checked
///      2 - exclusive lock on entire table for duration of the run
/// </dl>
/// <p><b>Returns:</b>
/// <dd>Status Code</dd>
/// </p>
/// <p><b>Example</b>:
/// <li>Do $SYSTEM.OBJ.ValidateIndices("Sample.Person","",1,2)</li>
/// <li>Do $SYSTEM.OBJ.ValidateIndices("Sample.Company",$lb("NameIdx"),1,1)</li>
/// </p>
/// <p><b>Note:</b>:
/// <br>Indices may also be validated by calling the class method <i>##class(classname).%ValidateIndices(idxList,autoCorrect,lockOption)</i>.
/// <br>There is one main difference between validating indices through <i>$SYSTEM.OBJ.ValidateIndices()</i> and <i>##class(classname).%ValidateIndices()</i>.
/// <br><i>$SYSTEM.OBJ.ValidateIndices()</i> will validate the indices for a table, and it will also validate any indices in collection child tables for that table.  
/// <br>When using <i>##class(classname).%ValidateIndices()</i>, collection child table indices must be checked with separate calls.
/// </p>
ClassMethod ValidateIndices(classname As %Library.String, idxList As %String = "", autoCorrect As %Boolean = 0, lockOption As %Integer = 1) As %Library.Status [ PublicList = mapList ]
{
	try {
		new mapList
		if $case(autoCorrect,1:0,0:0,:1) { set tSC=$$$ERROR($$$SystemSQLInvalidArgumentValue5,"$SYSTEM.OBJ.ValidateIndices()","autoCorrect","'0' or '1'") QUIT  }
		if $case(lockOption,2:0,1:0,0:0,:1) { set tSC=$$$ERROR($$$SystemSQLInvalidArgumentValue5,"$SYSTEM.OBJ.ValidateIndices()","lockOption","'0', '1' or '2'") QUIT  }
		set mapListAll="",mapList=""
		set tSC=$$ValidateIndices^%SYS.SECURITY(classname,idxList,autoCorrect,lockOption,0,.mapList)
		QUIT:$$$ISERR(tSC)
		set mapListAll=mapListAll_mapList
			#; Now see if there are any array or list collection child tables for this table that we should also check
		set tChildren=$g($$$EXTchildren($$$rEXT,classname))
		quit:tChildren=""
		for i=1:1:$ll(tChildren) {
			set tTable=$lg(tChildren,i)
			continue:tTable=""
			set tChildExtent=$$$GetExtentNameFromTableName($$$SchemaFromIQN(tTable),$$$TableFromIQN(tTable))
			continue:tChildExtent=""
			set tChildExtentInfo=$g($$$EXTsqlinfo($$$rEXT,tChildExtent))
			continue:$case($$$SQLLocTableChildTableType(tChildExtentInfo),"A":0,"L":0,:1)	// skip nonArray/List child tables
				#; When %ValidateIndices is called from $SYSTEM.OBJ.ValidateIndices, we need a list of maps returned to validate the idxList.
				#; When not called from here, we validate idxList inside of %ValidateIndices.
			set mapList=1
			set tSC=$$ValidateIndices^%SYS.SECURITY(tChildExtent,idxList,autoCorrect,lockOption,0,.mapList)
			QUIT:$$$ISERR(tSC)
			set mapListAll=mapListAll_mapList
		}
		set tPtr=0
		while $listnext(idxList,tPtr,tIndex) {
			if '$lf(mapListAll,tIndex) { set tSC=$select(+tSC:$$Error^%apiOBJ(5066,classname_"::"_tIndex),1:$$AppendStatus^%occSystem(tSC,$$Error^%apiOBJ(5066,classname_"::"_tIndex))) }
		}
	}
	catch {
		set tSC=$$$ERROR($$$CacheError,$ZError)
	}
	QUIT tSC
}

}
