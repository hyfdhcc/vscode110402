Include %syDataCheck

/// Defines the possible states for global ranges recorded in the <CLASS>RangeList</CLASS> objects.
/// The logical value is one of the following constants, defined for convenience in %syDataCheck.inc:
/// <li> 0 - $$$RangeStateUnknown - system has not checked this range yet</li>
/// <li> 1 - $$$RangeStateMatched - system has found this range to be matched</li>
/// <li> 2 - $$$RangeStateExcluded - this range is excluded from the check</li>
/// <li> 3 - $$$RangeStateIncluded - used only by the global selection set of RangeLists, this range is to be included in the check</li>
/// <li>-1 - $$$RangeStateUnmatched - system has found a discrepancy in this range</li>
/// <li>-2 - $$$RangeStateColDis - system has found a collation discrepancy</li>
Class SYS.DataCheck.RangeState Extends %Integer
{

ClassMethod LogicalToDisplay(%val As %Integer) As %String
{
	quit $case(+%val,
	           $$$RangeStateUnknown    : "Unknown",
	           $$$RangeStateMatched    : "Matched",
	           $$$RangeStateUnmatched  : "Unmatched",
	           $$$RangeStateColDis     : "Collation Discrepancy",
	           $$$RangeStateExcluded   : "Excluded",
	           $$$RangeStateIncluded   : "Included"
	           )
}

ClassMethod DisplayToLogical(%val As %String) As %Integer
{
	quit $case(%val,
	           "Unknown"                : $$$RangeStateUnknown,
	           "Matched"                : $$$RangeStateMatched,
	           "Unmatched"              : $$$RangeStateUnmatched,
	           "Collation Discrepancy"  : $$$RangeStateColDis,
	           "Excluded"               : $$$RangeStateExcluded,
	           "Included"               : $$$RangeStateIncluded
               )
}

}
