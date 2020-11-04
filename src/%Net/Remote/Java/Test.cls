Class %Net.Remote.Java.Test Extends %RegisteredObject [ Abstract, System = 3 ]
{

/// This shows how to use the sample classes delivered with Ensemble (under /dev/java/samples).
/// To run the example, start the Java Gateway Super Server, then from your 
/// ENSEMBLE namespace type in Do ##class(%Net.Remote.Java.Test).Test(port,host)
ClassMethod Test(port As %Integer, host As %String = "127.0.0.1") [ Final ]
{
	Try {
	Set gateway=..Connect(port,host)
	Quit:gateway=""
	Set student=##class(remote.test.Student).%New(gateway,29,"976-01-6712")
	
	// get, set Date
	Write !,"setNextClass returned: ",student.setNextClass($zd($h,3),$zt($h),"White Hall",3.0,0)
	Write !,"Next class on: ",student.myGetNextClassDate(),!,!

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
	
	// HashMap example
	Set grades=##class(java.util.HashMap).%New(gateway)
	Set x=grades.put("Biology",3.8)
	Write "Biology grade changed from "_grades.put("Biology",3.1)_" to 3.1",!
	Set x=grades.put("French",3.75)
	Set x=grades.put("Spanish",2.75)
	Do student.mySetGrades(grades)

	Set grades=student.myGetGrades()
	Write "Student has completed the following ",grades.size()," classes:",!
	Set it=grades.keySet().iterator()
	While (it.hasNext()) {
    	Set key=it.next()
    	Set value=grades.get(key)
		Write "  ",key," ",value,!
	}
	Write !,"Highest grade: ",student.myGetHighestGrade()

	Write !,"Now taking: Calculus, Chemistry, English Comp",!,!
	Do student.setGrade("Calculus",3.5)
	Do student.setGrade("Chemistry",3.92)
	Do student.setGrade("English Comp",2.5)
	Write "English Comp Grade: ",student.getGrade("English Comp"),!

	Set grades=student.myGetGrades()
	Write !,"Student has completed the following ",grades.size()," classes:",!
	Set it=grades.keySet().iterator()
	While (it.hasNext()) {
    	Set key=it.next()
    	Set value=grades.get(key)
		Write "  ",key," ",value,!
	}
	
	Write !,"Highest grade now: "
	Write student.myGetHighestGrade()

	// example of using Class.forName
	// instead of sports=##class(java.util.ArrayList).%New(gateway)
	Set arrayListClass=##class(java.lang.Class).forName(gateway,"java.util.ArrayList")
	Set sports=arrayListClass.newInstance()
	Do sports.add("Basketball")
	Do sports.add("Tennis")
	Do sports.add("Running")
	Do sports.add("Swiming")
	Do student.mySetFavoriteSports(sports)

 	// set/get a list of Strings
	Set list=student.myGetFavoriteSports()
	Write !,"Student's favorite sports are: ",!
	For i=0:1:list.size()-1 {
		Write "  "_list.get(i),!
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
	Do student.changeAddress(home,newHome)
	// get an array of Strings
	Set list=student.getAddressAsCollection()
	Write "Student's new address is: ",!
	Write "  "_list.GetAt(4),!,"  "_list.GetAt(1)_", "_list.GetAt(2)_" "_list.GetAt(3),!
		
	// Disconnect
	Set status=gateway.%Disconnect()
	Do ..ProcessError(status)
	} Catch exception {
		Set status=##class(%Net.Remote.Gateway).%SetStatus(exception)
		Do ..ProcessError(status)
	}
}

/// This shows how to use arrays. The test uses sample classes delivered with 
/// Ensemble (under /dev/java/samples).
/// To run the example, start the Java Gateway Super Server, then from your 
/// ENSEMBLE namespace type in Do ##class(%Net.Remote.Java.Test).TestArrays(port,host)
ClassMethod TestArrays(port As %Integer, host As %String = "127.0.0.1") [ Final ]
{
	Try {
	Set gateway=..Connect(port,host)
	Quit:gateway=""
	
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
	// Note that byteStream is passed in by value, so any changes on the Java
	// side will be ignored. The next example will pass the stream by reference
	// meaning changes on the Java side will be reflected here as well
	Do test.setByteArray(byteStream)
	
	Set result=test.getByteArray()
	Write result.Read(result.SizeGet()),!
			
	Set readStream=##class(%GlobalBinaryStream).%New()
	// we need to 'reserve' a number of bytes since we are passing the stream
	// by reference (Java's equivalent is byte[] ba = new byte[max];)
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

/// This example establishes a connection with Cache JDBC driver, then executes
/// some standard JDBC code. This code should work against any database that 
/// has a JDBC driver. Simply change the connection parameters (driver class name,
/// url, username and password)    
/// To run the example, start the Java Gateway Super Server, then from your 
/// ENSEMBLE namespace type in Do ##class(%Net.Remote.Java.Test).JDBC(port,host,jdbcPort,jdbcHost)
ClassMethod JDBC(port As %Integer, host As %String = "127.0.0.1", jdbcPort As %Integer = 1972, jdbcHost As %String = "127.0.0.1") [ Final ]
{
	Try {
	Set gateway=..Connect(port,host)
	Quit:gateway=""
	
	Set status=gateway.%ClassForName("com.intersys.jdbc.CacheDriver")
	If status'=$$$OK {
		Do ..ProcessError(status) 
		Quit
	}
	// connect to Cache JDBC (in order to connect to a different database, modify
	// the connection parameters: driver name, url, username and password)
	Set url="jdbc:Cache://"_jdbcHost_":"_jdbcPort_"/SAMPLES",username="_SYSTEM",password="SYS"
	// calls java Class.forName method
	Set connection=##class(java.sql.DriverManager).getConnection(gateway,url,username,password)
	
	// get a list of tables
	Set databaseMetaData=connection.getMetaData()
	Set tables=databaseMetaData.getTables("","Sample","%","")
	Write "Tables in SAMPLES Namespace [Schema=Sample]:",!
	While (tables.next()) {
		Write "  ",tables.getString(3)_" ",!
	}
	
	// execute a query against Sample.Person table
	Set statement=connection.createStatement()
	Set resultSet=statement.executeQuery("select * from Sample.Person where ID < 10")
	Set resultSetMetaData=resultSet.getMetaData()
	Write !,"Execute query: select * from Sample.Person where ID < 10",!
	Write "----------------------------------------------",!
	Write resultSetMetaData.getColumnName(1)_"  "_resultSetMetaData.getColumnName(3)_"          "
	Write resultSetMetaData.getColumnName(6)_"           "_resultSetMetaData.getColumnName(5)_"  ",!
	Write "----------------------------------------------",!
	While (resultSet.next()) {
		Write resultSet.getString(1)_"   "
		Write resultSet.getString(3)_"   "
		Write resultSet.getString(6)_"   "
		Write resultSet.getString(5)_"   ",!
	}
	Write "----------------------------------------------",!

	Set status=gateway.%Disconnect()
	Do ..ProcessError(status)
	} Catch exception {
		Set status=##class(%Net.Remote.Gateway).%SetStatus(exception)
		Do ..ProcessError(status)
	}
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

ClassMethod Connect(port As %Integer, host As %String) As %Net.Remote.Gateway
{
	// connect to current namespace, use 2 second timeout
	Set status=$$$OK,namespace=$zu(5),timeout=2
	Set classPath=##class(%ListOfDataTypes).%New()
	Set samplePath=$SYSTEM.Util.InstallDirectory()_"dev/java/samples/"
	// or: Set samplePath=$SYSTEM.Util.InstallDirectory()_"dev/java/samples/javagatewaysamples.jar"
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

ClassMethod TestEager(port As %Integer, eager As %Boolean = 1, runs As %Integer = 1000, host As %String = "127.0.0.1") [ Final ]
{
	Try {
		Set gateway=..Connect(port,host)
		Quit:gateway=""
		
		Set student=##class(remote.test.Student).%New(gateway,29,"976-01-6712")
		Set timeElapsed=$P($now(),",",2)
		Set grades=##class(java.util.HashMap).%New(gateway)
		Set x=grades.put("Biology",3.8)
		Set x=grades.put("French",3.75)
		Set x=grades.put("Spanish",2.75)
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
			Set time=student.getnextClassTime()
			Set location=student.getnextClassLocation()
			Set onSchedule=student.getnextClassOnSchedule()
			Set grades=student.getgrades()
			Set favoriteColors=student.getfavoriteColors()
			Set byteArray=student.getByteArray()
			//Set date=student.getnextClassDate()
			//Set student.getchemistryFinal() As %Library.TimeStamp
		}
		Write "Time Elapsed: "_($P($now(),",",2)-timeElapsed),!
		Write "Years: "_years,!,"GPA: "_gpa,!,"Highest grade: "_hg,!,"Credits: "_credits,!,"ID: "_id,!
		Write "Biology grade: "_student.getgrades().get("Biology"),!
		Write "Favorite Colors: ",!
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

}
