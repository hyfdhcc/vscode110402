Class %SYSTEM.DSTIME Extends %Persistent [ Final, System = 4 ]
{

Index IDK On (ClassName, DSTIME, ObjectId) [ IdKey ];

Property DSTIME As %Library.Integer;

Property ClassName As %String(MAXLEN = "");

Property ObjectId As %Binary;

Property FilingOp As %Integer;

Storage Default
{
<CounterLocation>^OBJ.DSTIME</CounterLocation>
<Data name="DSTIMEDefaultData">
<Attribute>FilingOp</Attribute>
<Structure>node</Structure>
</Data>
<DataLocation>^OBJ.DSTIME</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^OBJ.DSTIME</IdLocation>
<IndexLocation>^OBJ.DSTIMEI</IndexLocation>
<StreamLocation>^OBJ.DSTIMES</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
