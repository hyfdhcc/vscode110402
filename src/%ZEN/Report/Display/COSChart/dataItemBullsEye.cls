Class %ZEN.Report.Display.COSChart.dataItemBullsEye Extends %RegisteredObject
{

Property value As %Double;

Property itemNo As %Integer;

Property label As %String;

Property r As %Double;

Method %OnNew(value, itemNo, label) As %Status
{
		Set ..value=value
		Set ..itemNo = itemNo
		Set ..label = label
		quit $$$OK
}

ClassMethod sort(ByRef dataItems) [ Internal ]
{
	Set dataItemsLength=0
	// sort array of dataItem by value
	Set i="" For { Set i=$O(dataItems(i),1, dataItem) q:i=""
		;s ^foobar($i(^foobar))="filling i="_i_" value="_dataItem.value_" itemNo="_dataItem.itemNo_" label="_dataItem.label
		Set sort(dataItem.value,dataItem.itemNo,dataItem.label)=dataItem
		Set dataItemsLength = dataItemsLength+1
	}
	Set i=0
	Set value="" For { Set value=$O(sort(value),-1) q:value=""
		Set itemNo="" For { Set itemNo=$O(sort(value,itemNo)) q:itemNo=""
			Set label="" For { Set label=$O(sort(value,itemNo,label)) q:label=""
			Set dataItems(i)=sort(value,itemNo,label)
			;s ^foobar($i(^foobar))="setting i="_i_" value="_value_" itemNo="_itemNo_" label="_label
			Set i=i+1
			}
		}
			
	}
}

// this method needs an optimization - probably by enclosing dataItem class in a dataItems class

ClassMethod length(ByRef dataItems) [ Internal ]
{
	Set dataItemsLength=0
	// sort array of dataItem by value
	Set i="" For { Set i=$O(dataItems(i)) q:i=""
		Set dataItemsLength = dataItemsLength+1
	}
	;s ^foobar($i(^foobar))="dataItemsLength="_dataItemsLength
	quit dataItemsLength ;
}

}
