Class %DeepSee.PMML.Utils.Result Extends %RegisteredObject [ Abstract, System = 4 ]
{

Property TestId As %Integer;

Property ModelClass As %String(MAXLEN = 2000);

Property TestRecordId As %String(MAXLEN = 2000);

Property ActualValue As %String(MAXLEN = 2000);

Property PredictedValue As %String(MAXLEN = 2000);

Property PredictTime As %TimeStamp;

Property Probability As %Double;

ClassMethod GetNewTestId() As %Integer [ Abstract ]
{
}

}
