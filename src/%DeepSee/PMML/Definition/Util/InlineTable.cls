Class %DeepSee.PMML.Definition.Util.InlineTable Extends TableIdentifier [ System = 3 ]
{

// Property Rows As list Of InlineTableRow(XMLNAME = "row", XMLPROJECTION = "ELEMENT");

Property Content As %Stream.TmpCharacter(CONTENT = "MIXED", XMLPROJECTION = "CONTENT");

/// Returns the contents of this Inline Table as two-dimensional array:
/// 		pRows(rowNumber, columnName) = columnValue
Method %GetRows(Output pRows) As %Status
{
	set tSC = $$$OK
	try {
		kill pRows
		set pRows = 0
		
		set tLen = 7
		if ..Content.Read(.tLen)'="<table>" {
			set tStream = ##class(%Stream.TmpCharacter).%New()
			do tStream.Write("<table>")
			do tStream.CopyFrom(..Content)
			do tStream.Write("</table>")
		} else {
			set tStream = ..Content
		}
		
		set tSC = ##class(%XML.Document).GetDocumentFromStream(tStream, .tDocument)
		quit:$$$ISERR(tSC)
		
		set tNode = tDocument.GetDocumentElement() // get <table> element
		quit:'tNode.MoveToFirstChild(1) // first <row> element
		for {
			set pRows = pRows+1
			
			continue:'tNode.MoveToFirstChild(1) // first <column>
			for {
				set tName = tNode.LocalName, tText = ""
				if (tName'="") && tNode.GetText(.tText) {
					set pRows(pRows, tName) = tText
				}
				quit:'tNode.MoveToNextSibling(1) // next <column>
			}
			
			do tNode.MoveToParent() // back up to <row> element
			quit:'tNode.MoveToNextSibling(1) // next <row> element
		}
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Adds node-specific validation checks
Method %OnValidateObject(force As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	set tSC = $$$OK
	try {
		
		// try to parse the table as a validation check
		set tSC = ..%GetRows(.tRows)
		quit:$$$ISERR(tSC)
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
