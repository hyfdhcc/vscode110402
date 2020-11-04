/// %Monitor object for viewing sample data
Class %Monitor.View Extends %RegisteredObject [ System = 3 ]
{

/*
---------------------Documentation------------------------------------
SAP323  02/03/05 Steve Pettibone, make %Monitor.Sample non-% class
SAP159	04/15/04 Steve Pettibone, initial.
-------------------End Documentation----------------------------------
*/
/// ID for sample group being viewed
Property SampleId As %String;

ClassMethod Display(mclass As %String) As %Status
{
 // Execute the query on the sample to get the data
 Set rspec = ##class(%ResultSet).%New("Monitor.Sample:LatestSample")
 Do rspec.Execute(mclass)
 // Get all the data
 While rspec.Next(.sc) {
	 If '$SYSTEM.Status.IsOK(sc) Quit
	 // Get ID
	 Set id= rspec.GetData(1)
	 Set data = ##class(Monitor.Sample).%OpenId(id)
	 If data = "" s sc=0 q
	 Do data.DisplayDetails()
	 k data
 }
 k rspec

 Q sc
}

}
