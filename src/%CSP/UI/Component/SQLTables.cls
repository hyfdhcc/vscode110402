/// Component for editing SQL Tables, Views, and Procedures on the User and Role edit pages
Class %CSP.UI.Component.SQLTables Extends (%ZEN.Component.component, %CSP.UI.Component.SelectBoxUtils) [ System = 3 ]
{

Parameter DOMAIN [ Internal ] = "%Utility";

/// This is the XML namespace for this component.
Parameter NAMESPACE [ Internal ] = "http://www.intersystems.com/zen";

Property includeSystem As %ZEN.Datatype.integer [ InitialExpression = 0 ];

Property namespace As %ZEN.Datatype.string;

Property nsDisplayList As %ZEN.Datatype.string;

Property nsValueList As %ZEN.Datatype.string;

Property pageType As %ZEN.Datatype.string(VALUELIST = ",Users,Roles");

/// Name of the User/Role being edited
Property PID As %ZEN.Datatype.string(ZENEXPRESSION = 1);

/// If true, tables are for display only
Property readOnly As %ZEN.Datatype.boolean(ZENEXPRESSION = 1) [ InitialExpression = 0 ];

Property showSystemBox As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

Property tab As %ZEN.Datatype.integer;

Property type As %ZEN.Datatype.string;

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.Text2:first-letter {
    font-size:1.4em;
}
.Text2 {
    font-size:13px;
    max-width:575px;
    margin-bottom:5px;
}
.sectionLabel {
	font-size:13px;
	font-weight:normal;
	color:black;
	margin-top:15px;
}
</style>
}

/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	Try {
		Set PID = $$$ZENVAL(..PID)
		
		If ..namespace = "" {
			Set ..namespace = $G(%session.Data("$NAMESPACE"),$zu(5))
		}
		If (","_..namespace_"," '[ ","_..nsValueList_",") Set ..namespace = $zu(5)
		// update the session $NAMESPACE now
		Set %session.Data("$NAMESPACE") = ..namespace
		
		Set ..includeSystem = $G(%session.Data("includeSystemItems"),0)
		
		&html<
			<div style="margin-bottom:3px;">
			<span class="zenLabel">#($$$TextHTML("Namespace"))#</span>
			<select id="#(..%MakeId("Namespace"))#" onchange="zenPage.getComponent('#(..index)#').changeNS(this);" value="#($zconvert(..namespace,"O","HTML"))#">>
		For i=1:1:$LENGTH(..nsValueList,",") {
			Set val = $PIECE(..nsValueList,",",i)
			Set display = $PIECE(..nsDisplayList,",",i)
			Set selected = $SELECT(val=..namespace:"selected",1:"")
			&html<<option value="#($zconvert(val,"O","HTML"))#" #(selected)#>#(display)#</option>>
		}
		&html<</select>>
		If (..showSystemBox) {
			Set checked = $SELECT(..includeSystem=1:"checked",1:"")
			&html<
			<label style="margin-left:10px;">
				<input type="checkbox" id="#(..%MakeId("SystemItems"))#" #(checked)# onchange="zenPage.getComponent('#(..index)#').changeSysItems(this);"/>
				<span class="normal">#($$$Text("Include System Items"))#</span>
			</label>>
		}
		If '$$$ZENVAL(..readOnly) {
			Set lblAdd = $CASE(..type,"TABLE":$$$TextHTML("Add Tables..."),"VIEW":$$$TextHTML("Add Views..."),:$$$TextHTML("Add Procedures..."))
			&html<<input type="button" value='#(lblAdd)#' onclick="zenPage.getComponent('#(..index)#').doLaunchSchemas('#($ZCVT($ZCVT(PID,"O","JS"),"O","HTML"))#','','');">>
			If (..type="TABLE") || (..type="VIEW") {
				&html<<input type="button" value='#($$$TextHTML("Add Columns..."))#' onclick="zenPage.getComponent('#(..index)#').doLaunchColumns('#($ZCVT($ZCVT(PID,"O","JS"),"O","HTML"))#','');">>
			}
		} 
		&html<</div>>
		
		New $namespace
		Set $namespace = ..namespace
		
		If ..type = "STORED PROCEDURE" {
			Set PrivilegeString = "EXECUTE"
		} Else {
			Set PrivilegeString = "%ALTER,SELECT,INSERT,UPDATE,DELETE,REFERENCES"
		}
		Set nPrivilegesLen = $L(PrivilegeString,",")
		
		Set tRS = ##class(%ResultSet).%New("%SQL.Manager.CatalogPriv:UserPrivs")
		Set tSC = tRS.Execute(PID,..includeSystem)
		If $$$ISERR(tSC) throw ##Class(%Exception.StatusException).CreateFromStatus(tSC)
		
		&html<
			<div>
			<table class="tpTable" cellspacing="2" cellpadding="0" border="1" style="table-layout:auto;" width="100%">>
		&html<
			<thead class="tpHead">
				<th nowrap>#($$$Text("Name"))#</th>>
		For i = 1:1:nPrivilegesLen {
			&html<
				<th nowrap>#($P(PrivilegeString,",",i))#</th>>
		}
		&html<
				<th nowrap>#($$$TextHTML("Granted Via"))#</th>
				<th nowrap>#($$$TextHTML("Granted By"))#</th>>
		If ..type '= "STORED PROCEDURE" {
			&html<
				<th nowrap>#($$$TextHTML("Column Priv"))#</th>>
		}
		&html<
				<th>&nbsp;</th>
				<th>&nbsp;</th>
			</thead>
			<tbody class="tpBody">>
		While tRS.Next() {
			If tRS.Data("TYPE") = ..type {
				Set tLastName = tRS.Data("NAME")
				Set tGrantedVia = $SELECT(tRS.Data("GRANTED_VIA")="":0,1:tRS.Data("GRANTED_VIA"))
				Set tGrantedBy = $SELECT(tRS.Data("GRANTED_BY")="":0,1:tRS.Data("GRANTED_BY"))
				Set tPrivName = tRS.Data("PRIVILEGE")
				Set tGrant = tRS.Data("GRANT_OPTION")
				Set tObjects(tLastName,tGrantedVia,tGrantedBy,0) = tRS.Data("TYPE")
				For i=1:1:nPrivilegesLen {
					If $P(PrivilegeString,",",i) = tPrivName {
						Set $P(tObjects(tLastName,tGrantedVia,tGrantedBy),",",i) = $S(tGrant="Yes":2,1:1)	
					}
				}
				Set $P(tObjects(tLastName,tGrantedVia,tGrantedBy),",",i+1) = tRS.Data("GRANTED_VIA")
				Set $P(tObjects(tLastName,tGrantedVia,tGrantedBy),",",i+2) = tRS.Data("GRANTED_BY")
				Set $P(tObjects(tLastName,tGrantedVia,tGrantedBy),",",i+3) = tRS.Data("HAS_COLUMN_PRIV")
			}
		}
		Set tRow = 0
		Set tLastName = $O(tObjects(""))
		While tLastName '= "" {
			Set tRow = tRow + 1
			Set rowClass = $CASE(tRow#2,1:"tpOdd",:"tpEven")
			Set tGrantedVia = $O(tObjects(tLastName,""))
			While tGrantedVia '= "" {
				Set tGrantedBy = $O(tObjects(tLastName,tGrantedVia,""))
				While tGrantedBy '= "" {
					Set tObj = tObjects(tLastName,tGrantedVia,tGrantedBy)
					&html<
					<tr class="#(rowClass)#">
						<td class="tpStr" nowrap>#($ZCVT(tLastName,"O","HTML"))#</td>>
					Do ..BuildLine(tObj,nPrivilegesLen)
					If ..type '= "STORED PROCEDURE" {
						// Column Priv column
						If $P(tObj,",",nPrivilegesLen+3) = 1 {
							&html<
						<td class="tpAction" style="text-align:center;"><a href="##(..tab)#" onclick="zenPage.getComponent('#(..index)#').doLaunchColumns('#($ZCVT($ZCVT(PID,"O","JS"),"O","HTML"))#','#(tLastName)#');">#($$$TextHTML("Edit Columns"))#</a></td>>
						} Else {
							&html<
						<td nowrap>&nbsp;</td>>
						}
					}
					If $P(tObj,",",nPrivilegesLen+1) = "Direct" {
						&html<
						<td class="tpAction" style="text-align:center;"><a href="##(..tab)#" onclick="zenPage.getComponent('#(..index)#').doLaunchSchemas('#($ZCVT($ZCVT(PID,"O","JS"),"O","HTML"))#','#($ZCVT(tLastName,"O","JS"))#','#(tObj)#');">#($$$TextHTML("Edit"))#</a></td>
						<td class="tpAction" style="text-align:center;"><a href="##(..tab)#" onclick="zenPage.getComponent('#(..index)#').doRevokeObj('#($ZCVT($ZCVT(PID,"O","JS"),"O","HTML"))#','#($ZCVT(tLastName,"O","JS"))#','#($ZCVT(tGrantedBy,"O","JS"))#');">#($$$TextHTML("Revoke"))#</a></td>>
					} Else {
						&html<
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>>
					}
					&html<
					</tr>>
					Set tGrantedBy = $O(tObjects(tLastName,tGrantedVia,tGrantedBy))
				}
				Set tGrantedVia = $O(tObjects(tLastName,tGrantedVia))	
			}
			Set tLastName = $O(tObjects(tLastName))
		}
		
		If tRow = 0 {
			&html<<tr><td colspan="12">#($$$TextHTML("None."))#</td></tr>>	
		} Else {
			&html<<tr><td colspan="12">&nbsp;&nbsp;>
			&html<#($$$TextHTML("Legend"))#: <span style="font-size:14px;">&nbsp;-&nbsp;</span>>
			&html<#($$$TextHTML("Not Granted"))#<span style="font-size:14px;">&nbsp;&nbsp;&#186;&nbsp;</span>>
			&html<#($$$TextHTML("Granted"))#<span style="font-size:14px;">&nbsp;&nbsp;&#8226;&nbsp;</span>>
			&html<#($$$TextHTML("Granted with Grant Admin Option"))#</td></tr>>
		}
		&html<</tbody></table></div>>
	} Catch Error {
		Do ##class(%ZEN.Utils).%DisplayErrorHTML(##this,Error.AsStatus())
	}
	Quit
}

ClientMethod changeNS(sel) [ Language = javascript ]
{
	var newVal = sel.options[sel.selectedIndex].value;  
	zenPage.changeNS(newVal);
}

ClientMethod changeSysItems(chbox) [ Language = javascript ]
{
	var newVal = Number(chbox.checked);
	this.includeSystem = newVal;
	this.SetIncludeSystem(newVal);
	this.refreshContents();
}

ClassMethod SetIncludeSystem(newVal As %Integer) [ ZenMethod ]
{
	Set %session.Data("includeSystemItems") = newVal
}

ClientMethod doRevokeObj(PID, tblname, grantedby) [ Language = javascript ]
{
	var oldSynchronousMode = zenSynchronousMode;
	zenSynchronousMode = true;
	var st = this.RevokeRow(this.namespace,PID,tblname,"*",this.tab,this.pageType,grantedby);
	if (st != "") {
		alert(st);
	} else {
		this.refreshContents();
	}
	zenSynchronousMode = oldSynchronousMode;
}

ClientMethod doLaunchSchemas(PID, objName, objPriv) [ Language = javascript ]
{
	var url = zenLink('%CSP.UI.Portal.Dialog.SchemaPriv.zen?Type='+this.type+'&PID='+encodeURIComponent(PID)+'&IncludeSystem='+this.includeSystem+'&ObjName='+encodeURIComponent(objName)+'&ObjPriv='+encodeURIComponent(objPriv)+'&$NAMESPACE='+encodeURIComponent(this.namespace));
	zenLaunchPopupWindow(url,this.type+'-UserSchemas','status,scrollbars,resizable=yes,width=700,height=700');
}

ClientMethod doLaunchColumns(PID, objName) [ Language = javascript ]
{
	var url = zenLink('%CSP.UI.Portal.Dialog.ColumnPriv.zen?Type='+this.type+'&PID='+encodeURIComponent(PID)+'&IncludeSystem='+this.includeSystem+'&ObjName='+encodeURIComponent(objName)+'&$NAMESPACE='+encodeURIComponent(this.namespace));
	zenLaunchPopupWindow(url,this.type+'-UserColumns','status,scrollbars,resizable=yes,width=900,height=700');
}

ClassMethod BuildLine(tVal As %String, nPrivilegesLen As %Integer)
{
	Set tInd = 1
	While tInd '> nPrivilegesLen {
  		Set IsSelected = $P(tVal,",",tInd)
  		Set Icon = $CASE(IsSelected,1:"&#186;",2:"&#8226;",:"-")
  		Set Title = $CASE(IsSelected,1:$$$TextHTML("Granted"),2:$$$TextHTML("Granted with Grant Admin Option"),:$$$TextHTML("Not Granted"))
  		&html<<td class="tpStr" nowrap style="font-size:14px;text-align:center;" title="#(Title)#">#(Icon)#</td>>
		Set tInd = tInd + 1
	}
	// write Granted Via
	Set tGrantedVia = $ZCVT($P(tVal,",",tInd),"U")
	If tGrantedVia = "SUPERUSER" {
		Set tGV = $$$TextHTML("SuperUser")
	} ElseIf tGrantedVia = "SCHEMA PRIVILEGE" {
		Set tGV = $$$TextHTML("Schema Privilege")
	} ElseIf tGrantedVia = "PUBLIC" {
		Set tGV = $$$TextHTML("Public")
	} ElseIf tGrantedVia = "DIRECT" {
		Set tGV = $$$TextHTML("Direct")
	} ElseIf tGrantedVia [ "ROLE:" {
		Set tGV = $$$TextHTML("Role")_":"_$P(tGrantedVia,"ROLE:",2)
	} ElseIf tGrantedVia [ "USER:" {
		Set tGV = $$$TextHTML("User")_":"_ $P(tGrantedVia,"USER:",2)
	} Else {
		Set tGV = tGrantedVia
	}
	Set GrantedBy = $P(tVal,",",tInd+1)
	&html<<td class="tpStr" nowrap>#($S(tGV'="":tGV,1:"&nbsp;"))#</td>>
	&html<<td class="tpStr" nowrap>#($S(GrantedBy'="":GrantedBy,1:"&nbsp;"))#</td>>
}

ClassMethod RevokeRow(NAMESPACE, Grantee, cbState, sActs, tab, sType, GrantedBy) As %String [ ZenMethod ]
{
	Try {
		New $namespace
		Set $namespace = NAMESPACE
		
		Set tResult = ""

		//For Users: tab=3:tables, tab=4:views, tab=5:procedures
		//For Roles: tab=4:tables, tab=5:views, tab=6:procedures
		If sType = "Roles" {
			Set nType = $S(tab="4":1,tab="5":3,1:9)
		} Else {
			Set nType = $S(tab="3":1,tab="4":3,1:9)
		}
		If $E(cbState) = "," Set cbState = $E(cbState,2,$L(cbState))

		For i=1:1:$LENGTH(cbState,",") {
			Set sObj = $P(cbState,",",i)
			Set tSC = ##class(%SQL.Manager.API).SaveObjPriv(sActs,nType,sObj,Grantee,0,1,.SQLCODE,.sMsg,GrantedBy)
			If SQLCODE '= 0 {
				Set tResult = tResult_sObj_" "_"["_SQLCODE_"]"_sMsg_"\n"
			}
		}
    } Catch Error {
		Set tResult = $System.Status.GetErrorText(Error.AsStatus())
	}
	Set tResult = $ZCVT(tResult,"O","JS")
	Quit tResult
}

}
