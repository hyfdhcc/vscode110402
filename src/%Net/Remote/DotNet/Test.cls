Class %Net.Remote.DotNet.Test Extends %RegisteredObject [ Abstract, System = 3 ]
{

/// This shows how to use the sample classes delivered with Cache and Ensemble
/// in subdirectory ...\dev\dotnet\samples\remote\test. <br>
/// The documentation contains information about how to use the .NET Gateway in Cache which applies for Cache and Ensemble,
/// plus additional specific information for Ensemble in case of Ensemble instances. <br>
/// The steps below give a quick overview of what is required to run this sample method. For more details, refer to the documentation. <br>
/// - Compile the sample classes and place the resulting DotNetGatewaySamples.DLL is subdirectory ...\dev\dotnet\bin. <br>
/// - Start the Object Gateway Server for .NET.  This can be done by configuring and starting the Gateway using the Management Portal,
/// or adding a Business Service using the EnsLib.DotNetGateway.Service class, or directly at the Windows command prompt, or invoking
/// method <method>StartGatewayTemp</method>. <br>
/// - In Studio, generate the proxy classes in your namespace, by using the .NET Wizard available under Tools | Add-Ins. <br>
/// - Run from your namespace: <br>
/// >Do ##class(%Net.Remote.DotNet.Test).Test(port[,host]) <br>
/// - Stop the Gateway.
ClassMethod Test(port As %Integer, host As %String = "127.0.0.1") [ Final ]
{
	If '$G(port) Write !,"Usage: Do ##class(%Net.Remote.DotNet.Test).Test(port,host)",!,"       where host is optional",! Quit
	Set port = +port Close "|TCP|"_port

	Try {
		Set gateway=..Connect(port,host)
		Set student=##class(remote.test.Student).%New(gateway,29,"976-01-6712")

		Write !,"setNextClass returned: ",student.setNextClass($zd($h,3),$zt($h),"White Hall",3.0,0)
		Write !,"Next class on: ",$E(student.myGetNextClassDate(),1,10)
		Write $E(student.getNextClassTime(),11,*),!,!

		// set a String
		Do student.mySetName("John","Smith")

		// set an int
		Do student.mySetID(27)
		Write "Name: ",student.myGetName(),!
		Write "ID: ",student.myGetID(),!
		Write "SSN: ",student.getSSN(),!,!

		Write "Static method execute: ",##class(remote.test.Person).myStaticMethod(gateway),!,!
		Do ##class(remote.test.Person).setstaticProperty(gateway,89)
		Write "Static set/get: "_##class(remote.test.Person).getstaticProperty(gateway),!!
	
		// Hashtable example
		Set grades=##class(System.Collections.Hashtable).%New(gateway)
		Do grades.Add("Biology",3.8)
		Do grades.Add("French",3.75)
		Do grades.Add("Spanish",2.75)
		Do student.mySetGrades(grades)

		Set grades=student.myGetGrades()
		Write "Student has completed the following ",grades.getuCount()," classes:",!

    	Set keys=grades.getuKeys().GetEnumerator()
    	Set values=grades.getuValues().GetEnumerator()
    	While (keys.MoveNext())
		{
			If (values.MoveNext()) {
				Write "  ",keys.getuCurrent()," ",values.getuCurrent(),!
			}
		}
		Write !,"Highest grade: ",student.myGetHighestGrade()

		Write !,"Now taking: Calculus, Chemistry, English Comp",!,!
		Do student.setGrade("Calculus",3.5)
		Do student.setGrade("Chemistry",3.92)
		Do student.setGrade("English Comp",2.5)
		Write "English Comp Grade: ",student.getGrade("English Comp"),!

		Set grades=student.myGetGrades()
		Write !,"Student has completed the following ",grades.getuCount()," classes:",!
    	Set keys=grades.getuKeys().GetEnumerator()
    	Set values=grades.getuValues().GetEnumerator()
    	While (keys.MoveNext())
		{
			If (values.MoveNext()) {
				Write "  ",keys.getuCurrent()," ",values.getuCurrent(),!
			}
		}
		Write !,"Highest grade now: "
		Write student.myGetHighestGrade()
		Set sports=##class(System.Collections.ArrayList).%New(gateway)
		// Example of using Type.GetType; to use it, replace the above line with the 
		// following two lines: (also make sure to import System.Activator)
    	// Set arrayListClass=##class(System.Type).GetType(gateway,"System.Collections.ArrayList")
		// Set sports=##class(System.Activator).CreateInstance(gateway,arrayListClass)
		Do sports.Add("Basketball")
		Do sports.Add("Tennis")
		Do sports.Add("Running")
		Do sports.Add("Swiming")
		Do student.mySetFavoriteSports(sports)

 		// set/get a list of Strings
		Set list=student.myGetFavoriteSports()
		Write !,"Student's favorite sports are: ",!
		For i=0:1:list.getuCount()-1 {
			Write "  "_list.getuItem(i),!
		}
		// set an object
		Set home=##class(remote.test.Address).%New(gateway)
		Set street=##class(remote.test.Street).%New(gateway)
		Do street.setname("Memorial Drive")
		Do street.setnumber("One")
		Do home.mySetCity("San Diego")
		Do home.mySetStreet(street)
		Do home.mySetState("CA")
		Do home.mySetZip("20098")
		Do student.sethome(home)
		// get an object
		Write !,"Student's address: ",!
		Set home2=student.gethome()
		Write "  "_student.gethome().getstreet().getname(),!
		Write "  "_home2.myGetCity()_", "_home2.myGetState()_" "_home2.myGetZip(),!,!
	
		Write "Change address",!
		Set newHome=##class(remote.test.Address).%New(gateway)
		Set newStreet=##class(remote.test.Street).%New(gateway)
		Do newStreet.setnumber("456")
		Do newStreet.setname("Del Monte")
		Do newHome.mySetCity("Boston")
		Do newHome.mySetState("MA")
		Do newHome.mySetStreet(newStreet)
		Do newHome.mySetZip("40480")
		Set tempAddress=##class(remote.test.Address).%New(gateway)
		Do student.getAddressAsReference(.tempAddress)
		Write "City, before address change: "_tempAddress.myGetCity(),!
		Do student.changeAddress(home,newHome)
	
		Do student.getAddressAsReference(.tempAddress)
		Write "City, after address change: "_tempAddress.myGetCity(),!
		// get an array of Strings
		Set list=student.getAddressAsCollection()
		Write !,"Student's new address is: ",!
		Write "  "_list.GetAt(4),!,"  "_list.GetAt(1)_", "_list.GetAt(2)_" "_list.GetAt(3),!
		Write !,"Old addresses:",!
		Set oldAddresses=##class(%ListOfObjects).%New(gateway)
		Set newAdd=##class(remote.test.Address).%New(gateway)
		Set add2=student.getOldAddresses(home,.oldAddresses,.newAdd)
		For i=1:1:oldAddresses.Count() {
			Set oldAddress=oldAddresses.GetAt(i)
	    	Write !,"Address "_i_":",!
	    	Write oldAddress.getstreet().getnumber()_" "_oldAddress.getstreet().getname(),!
	    	Write oldAddress.getcity()
	    	Write ", "_oldAddress.getstate()
	    	Write " "_oldAddress.getzip(),!
		}		
		Write !,"Most recent Address:",!
		Write add2.getstreet().getnumber()_" "_add2.getstreet().getname(),!
		Write add2.getcity()
		Write ", "_add2.getstate()
		Write " "_add2.getzip(),!
	
		Write !,"Least Recent Address: ",!
		Write newAdd.getstreet().getnumber()_" "_newAdd.getstreet().getname(),!
		Write newAdd.getcity()
		Write ", "_newAdd.getstate()
		Write " "_newAdd.getzip(),!
		// Disconnect
		Set status=gateway.%Disconnect()
		Do ..ProcessError(status)
	} Catch exception {
		Set status=##class(%Net.Remote.Gateway).%SetStatus(exception)
		Do ..ProcessError(status)
	}
}

/// This shows how to use arrays. The test uses sample classes delivered 
/// with Cache and Ensemble in subdirectory dev\dotnet\samples\remote\test.
/// We assume that DotNetGatewaySamples.DLL is in the same directory as the 
/// Gateway distribution files. To run the example, start the Object Gateway 
/// Server for .NET, then run from your namespace:
/// Do ##class(%Net.Remote.DotNet.Test).TestArrays(port[,host])
ClassMethod TestArrays(port As %Integer, host As %String = "127.0.0.1") [ Final ]
{
	If '$G(port) Write !,"Usage: Do ##class(%Net.Remote.DotNet.Test).Test(port,host)",!,"       where host is optional",! Quit
	Set port = +port Close "|TCP|"_port

	Try {
		Set gateway=..Connect(port,host)
		Set test=##class(remote.test.Person).%New(gateway)
	
		// test simple string arrays
		Set stringArray=##class(%ListOfDataTypes).%New()
		Do stringArray.Insert("test string one")
		Do stringArray.Insert("test string two")
		Do stringArray.Insert("test string three")
		Do stringArray.Insert("test string four")

		// test simple string arrays
		Do test.setStringArray(stringArray)
		Set outStringArray=test.getStringArray()
	
		For i=1:1:outStringArray.Count() {
	    	Write "String "_i_" : "_outStringArray.GetAt(i),!
		}
	
		// test array of objects
		Set home=##class(remote.test.Address).%New(gateway)
		Set street=##class(remote.test.Street).%New(gateway)
		Do street.setname("Memorial Drive")
		Do street.setnumber("One")
		Do home.mySetCity("Cambridge")
		Do home.mySetStreet(street)
		Do home.mySetState("MA")
		Do home.mySetZip("02142")

		Set home2=##class(remote.test.Address).%New(gateway)
		Set street2=##class(remote.test.Street).%New(gateway)
		Do street2.setname("Santa Cruz Ave")
		Do street2.setnumber("4555")
		Do home2.mySetCity("San Diego")
		Do home2.mySetStreet(street2)
		Do home2.mySetState("CA")
		Do home2.mySetZip("92109")

		Set addressArray=##class(%ListOfObjects).%New()
		Do addressArray.Insert(home)
		Do addressArray.Insert(home2)

		Do test.setAddressArray(addressArray)
		Set addressArray=test.getAddressArray()
		For i=1:1:addressArray.Count() {
			Set home=addressArray.GetAt(i)
	    	Write !,"Address "_i_":",!
	    	Write home.getstreet().getnumber()_" "_home.getstreet().getname(),!
	    	Write home.getcity()
	    	Write ", "_home.getstate()
	    	Write " "_home.getzip(),!
		}
	
		// byte[] is mapped as %GlobalBinaryStream
		Write !,"Byte array test:",!
		Set byteStream=##class(%GlobalBinaryStream).%New()
		Do byteStream.Write("Global binary stream")
		// Note that byteStream is passed in by value, so any changes on the DotNet
		// side will be ignored. The next example will pass the stream by reference
		// meaning changes on the DotNet side will be reflected here as well
		Do test.setByteArray(byteStream)
	
		Set result=test.getByteArray()
		Write result.Read(result.SizeGet()),!
			
		Set readStream=##class(%GlobalBinaryStream).%New()
		// we need to 'reserve' a number of bytes since we are passing the stream
		// by reference (DotNet's equivalent is byte[] ba = new byte[max];)
		For i=1:1:50 Do readStream.Write("0")
	
		Set bytesRead=test.read(.readStream,50)
		Write readStream.Read(bytesRead),!

		Set status=gateway.%Disconnect()
		Do ..ProcessError(status)
	} Catch exception {
		Set status=##class(%Net.Remote.Gateway).%SetStatus(exception)
		Do ..ProcessError(status)
	}
}

ClassMethod TestEager(port As %Integer, eager As %Boolean = 1, runs As %Integer = 1000, host As %String = "127.0.0.1") [ Final ]
{
	If '$G(port) Write !,"Usage: Do ##class(%Net.Remote.DotNet.Test).Test(port,host)",!,"       where host is optional",! Quit
	Set port = +port Close "|TCP|"_port

	Try {
		Set gateway=..Connect(port,host)
		Quit:gateway=""
		
		Set student=##class(remote.test.Student).%New(gateway,29,"976-01-6712")
		Set timeElapsed=$P($now(),",",2)
		Set grades=##class(System.Collections.Hashtable).%New(gateway)
		Do grades.Add("Biology",3.8)
		Do grades.Add("French",3.75)
		Do grades.Add("Spanish",2.75)
		Set colors=##class(%Library.ListOfDataTypes).%New()
		Do colors.Insert("Red")
		Do colors.Insert("Blue")
		Do colors.Insert("White")
		Set byteStream=##class(%GlobalBinaryStream).%New()
		Do byteStream.Write("Global binary stream")
		Do:eager=1 student.%SetEager(1)
		For i=1:1:runs {
			Do student.setyearsInProgram(8)
			Do student.setGPA(3.45)
			Do student.sethighestGrade(4.0)
			Do student.setnextClassCredits(3.0)
			Do student.setisGraduate(1)
			Do student.setnextClassOnSchedule(1)
			Do student.setnextClassLocation("McCall Hall")
			Do student.setclassCount(7)
			Do student.setcredits(12)
			Do student.setstudentID(5024)
			Do student.setnextClassTime("12:00:00")
			Do student.setgrades(grades)
			Do student.setfavoriteColors(colors)
			Do student.setByteArray(byteStream)
			Do:eager=1 student.%SendObject()
			Do:eager=1 student.%FetchObject()
			Set years=student.getyearsInProgram()
			Set gpa=student.getGPA()
			Set hg=student.gethighestGrade()
			Set nc=student.getnextClassCredits()
			Set ig=student.getisGraduate()
			Set credits=student.getcredits()
			Set id=student.getstudentID()	
			Set cc=student.getclassCount()
			Set time=student.getNextClassTime()
			Set location=student.getnextClassLocation()
			Set onSchedule=student.getnextClassOnSchedule()
			Set grades=student.getgrades()
			Set favoriteColors=student.getfavoriteColors()
			Set byteArray=student.getByteArray()
		}
		Write "Time Elapsed: "_($P($now(),",",2)-timeElapsed),!
		Write "Years: "_years,!,"GPA: "_gpa,!,"Highest grade: "_hg,!,"Credits: "_credits,!,"ID: "_id,!
		Write "Biology grade: "_student.getgrades().getuItem("Biology"),!
		Write "Favorite Colors: ",!
		Set favoriteColors=student.getfavoriteColors()
		For i=1:1:favoriteColors.Count() {
			Write " ",favoriteColors.GetAt(i),!
		}
		Write "ByteArray: ",byteArray.Read(byteArray.SizeGet()),!
	
		Set status=gateway.%Disconnect()
	} Catch exception {
		Set status=##class(%Net.Remote.Gateway).%SetStatus(exception)
		Do ..ProcessError(status)
	}
}

ClassMethod Connect(port As %Integer, host As %String) As %Net.Remote.Gateway
{
	// connect to current namespace, use 2 second timeout
	Set status=$$$OK,namespace=$zu(5),timeout=2
	Set classPath=##class(%ListOfDataTypes).%New()
	Set samplePath=$SYSTEM.Util.InstallDirectory()_"dev/dotnet/bin/DotNetGatewaySamples.dll"
	Do classPath.Insert(samplePath)

	// get a connection handle and connect
	Set gateway=##class(%Net.Remote.Gateway).%New()
	Set status=gateway.%Connect(host,port,namespace,timeout,classPath)
	If status'=$$$OK {
		Do ..ProcessError(status) 
		Quit ""
	}
	Quit gateway
}

ClassMethod ProcessError(status As %Status) [ Final ]
{
	Use 0
	If status=$$$OK {
		Write !,"Test Successfully Completed"
	} Else {
		Write $system.OBJ.DisplayError(status)
	}
}

/// Demonstrate COM object access via the Object Gateway for .NET.
/// This example provides type library enumeration on the target system using the provided Interop.TLLib.dll which is an interop to TL.dll. <br>
/// It starts a temporary Object Gateway for .NET; generates proxy classes if they have not been generated yet;
/// uses them to list the type libraries; disconnects; stops the Gateway. <br>
/// Multiple users on the same system should not start individual Gateway servers but rather start one Gateway and have each client connect to it. <br>
/// Parameter <parameter>version</parameter> indicates whether to use .NET 2.0 (default) or 4.0.
ClassMethod ListTypeLibs(port As %Integer = "", host As %String = "127.0.0.1", version As %String = "2.0")
{
	Try {
		// Start a temporary .NET Gateway server
		Set status = ..StartGatewayTemp(.ogs,.port,host,1,$G(version))
		Quit:$$$ISERR(status)

		Set dir = "v2.0.50727" // Subdirectory where to find Interop.TLLib.dll
		Set classPath = ##class(%ListOfDataTypes).%New()
		Set samplePath = $SYSTEM.Util.InstallDirectory()_"dev/dotnet/bin/"_dir_"/Interop.TLLib.dll"
		Do classPath.Insert(samplePath)

		// Generate proxy classes for TLLib.dll
		Do ##class(%Net.Remote.ImportHelper).ExpressImport(samplePath,port)

		// Get a connection handle and connect
		Set gateway = ##class(%Net.Remote.Gateway).%New()
		Set status = gateway.%Connect(host,port,$ZU(5),5,classPath)
		Quit:$$$ISERR(status)

		// List type libraries
		Write !!,"Type Libraries:"
		Set objUtils = ##class(TLLib.UtilsClass).%New(gateway)
		Set objLibs = objUtils.getuLibraries()
		For i = 1:1:objLibs.getuCount() {
		   Set tld = objLibs.getuItem(i)
		   // tld is a | delimited string
		   Write !,$Piece(tld,"|")," - ",$Piece(tld,"|",2)," - ",$Piece(tld,"|",3)
		}
		Write !,"Total TypeLibs: "_objLibs.getuCount(),!
	
		// Disconnect
		Do gateway.%Disconnect()
	} Catch (ex) {
		Set status = ex.AsStatus()
	}

	// Stop the Gateway server -- Very important!  We should not leave it running if it's just for one-time use, to conserve system resources.
	// Note: Alternatively, one can call gateway.%Shutdown() in case there is no monitor active (such as in this example) or if we do not have the object available.
	If $IsObject(ogs) {
		Write !
		Set status = ##class(%Net.Remote.Service).StopGatewayObject(ogs,1)
	}

	If $$$ISERR(status) Write !,"ERROR: ",$system.Status.GetErrorText(status)
	Quit
}

/// Demonstrate how to programmatically start an Object Gateway for .NET without creating a persistent definition.
/// To run the example, execute from your namespace: <br>
/// >Set status = Do ##class(%Net.Remote.DotNet.Test).StartGatewayTemp(.ogserver,.port,host,verbose) <br>
/// The in-memory object instance <var>ogserver</var> of the Gateway server that was started can be used to stop it later. <br>
/// You may pass a <parameter>port</parameter> number, or pass a null variable by reference to have a port assigned for you. <br>
/// Note: To start a persistent Object Gateway by its name, define the Object Gateway and run instead: <br>
/// >Set status = Do ##class(%Net.Remote.Service).StartGateway(name,verbose)
ClassMethod StartGatewayTemp(Output ogserver As %Net.Remote.ObjectGateway, ByRef port As %String, host As %String = "127.0.0.1", verbose As %Boolean = 1, version As %String = "2.0") As %Status
{
	Set status = $$$OK
	Try {
		Write:verbose !,"Defining a temporary in-memory Object Gateway for .NET",!
		Kill %objlasterror
		Set ogserver = ##class(%Net.Remote.ObjectGateway).%New()
		If '$IsObject(ogserver) Set status = $G(%objlasterror) Quit
		// Type=2 indicates it's for .NET
		Set ogserver.Type = 2
		// Assign a temporary name
		Set ogserver.Name = "Temp"
		If '+$G(port) {
			// Assign first available port starting with port 55000
			For port = 55000:1 {
				If $$$ISOK(##class(%Net.Remote.Service).CheckTCP(port,host)) Quit
			}
		}
		Set ogserver.Port = port
		// Ensure it runs in 32-bit mode
		Set ogserver.Exec64 = 0
		// Set the .NET version (default is 2.0)
		Set ogserver.DotNetVersion = version
		// Do not monitor (avoid jobbing off the monitor process)
		Set ogserver.HeartbeatInterval = 0
		// Start this Object Gateway Server
		Set status = ##class(%Net.Remote.Service).StartGatewayObject(ogserver,verbose)
	} Catch (ex) {
		Set status = ex.AsStatus()
	}
	If $$$ISERR(status) Write:verbose !,"ERROR: ",$system.Status.GetErrorText(status),!
	Quit status
}

}
