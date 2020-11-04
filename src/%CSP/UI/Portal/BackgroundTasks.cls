/// This page displays background tasks without the main header.
Class %CSP.UI.Portal.BackgroundTasks Extends %ZEN.Component.page [ System = 4 ]
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "%CSP.UI.Portal.Application";

/// Displayed name of this page.
Parameter PAGENAME = "BackgroundTasks";

/// Domain used for localization.
Parameter DOMAIN;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="">
<tablePane id="table" queryClass="%CSP.UI.System.BackgroundTask" queryName="EnumerateTasks"
showZebra="true" >
</tablePane>
<timer id="timer" ontimeout="zenPage.timeout(zenThis);" timeout="5000"/>
</page>
}

ClientMethod timeout(timer) [ Language = javascript ]
{
	var table = zen('table');
	table.refreshContents();
	timer.startTimer();
}

}
