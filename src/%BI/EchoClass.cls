Class %BI.EchoClass Extends %CSP.Page [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Parameter SECURITYRESOURCE = "%BI_LegacyAccess";

ClassMethod OnPage() As %Status
{
	s Dtyp=%request.Get("Dtyp")
	w "<?xml version=""1.0"" standalone=""no""?>"
	w !,"<!DOCTYPE svg PUBLIC ""-//W3C//DTD SVG 1.0//EN"" ""http://www.w3.org/TR/2001/PR-SVG-20010719/DTD/svg10.dtd"">"
	
	w !,"<svg id='Hh"_Dtyp_"' width='100%' height='100%' viewBox='0 10 400 300' preserveAspectRatio=""xMidYMid meet"" xmlns=""http://www.w3.org/2000/svg"">" 
    
    w !,"<title>Venn Diagram</title>"
   	w !,"<defs>"    
    w !,"<script type='text/javascript'><![CDATA["
    
    w !,"function Mover2(evt)"
	  	w !,"{"
		w !,"pth=evt.getTarget()"
		w !,"pth.setAttribute('stroke','red');"
		w !,"pth.setAttribute('stroke-width','4')"
		w !,"}"
    w !,"function Mout2(evt)"
		w !,"{"
		w !,"pth=evt.getTarget()"
		w !,"pth.setAttribute('stroke','#000000');"
		w !,"pth.setAttribute('stroke-width','2')"
		w !,"}"
	w !,"function DTes(pthN)"
		w !,"{"
		// this is for MId Ant Sept
		w !,"pp=document.getElementById(pthN)"
		w !,"pp2=pp.getAttribute('fill')"
		
		w !,"if (pthN=='frt1' || pthN=='fou1')"
		w !,"{SelMidAntSept(pp2,pthN);"
		w !,"hrtregion[0]=pp2;"
		w !,"hrtregion[16]=pp2;"
		w !,"}"
		w !,"else if (pthN=='frt2' || pthN=='sec1')"
		w !,"{SelBasalAntSept(pp2,pthN)"
		w !,"hrtregion[1]=pp2;"
		w !,"hrtregion[4]=pp2;"
		w !,"}"
		w !,"else if (pthN=='frt3' || pthN=='fou4')"
		w !,"{SelMidPost(pp2,pthN)"
		w !,"hrtregion[2]=pp2;"
		w !,"hrtregion[19]=pp2;"
		w !,"}"
		w !,"else if (pthN=='thr6' || pthN=='sec3')"
		w !,"{SelBasalLat(pp2,pthN)"
		w !,"hrtregion[15]=pp2;"
		w !,"hrtregion[6]=pp2;"
		w !,"}"
		w !,"else if (pthN=='fiv1' || pthN=='sec5')"
		w !,"{SelBasalINF(pp2,pthN)"
		w !,"hrtregion[22]=pp2;"
		w !,"hrtregion[8]=pp2;"
		w !,"}"
		w !,"else if (pthN=='thr1' || pthN=='sec6')"
		w !,"{SelBasalSept(pp2,pthN)"
		w !,"hrtregion[10]=pp2;"
		w !,"hrtregion[9]=pp2;"
		w !,"}"
		w !,"else if (pthN=='fou6' || pthN=='thr2')"
		w !,"{SelMidSept(pp2,pthN)"
		w !,"hrtregion[21]=pp2;"
		w !,"hrtregion[11]=pp2;"
		w !,"}"
		w !,"else if (pthN=='fiv5' || pthN=='fou2')"
		w !,"{SelMidAnt(pp2,pthN)"
		w !,"hrtregion[26]=pp2;"
		w !,"hrtregion[17]=pp2;"
		w !,"}"
		w !,"else if (pthN=='thr5' || pthN=='fou3')"
		w !,"{SelMidLat(pp2,pthN)"
		w !,"hrtregion[14]=pp2;"
		w !,"hrtregion[18]=pp2;"
		w !,"}"
		w !,"else if (pthN=='fou5' || pthN=='fiv2')"
		w !,"{SelMidINF(pp2,pthN)"
		w !,"hrtregion[20]=pp2;"
		w !,"hrtregion[23]=pp2;"
		w !,"}"		
		w !,"else"
		w !,"{SelBasalPost(pp2,pthN)"
		w !,"hrtregion[7]=pp2;"
		w !,"hrtregion[3]=pp2;"
		w !,"}"		
		
		w !,"}"
	
	w !,"function CColor(evt,nm)"
		w !,"{"
		w !,"pth=evt.getTarget()"
		w !,"CallColor(pth,nm)"
		w !,"}"
	w !,"function MMO()"
	w !,"{"
	//w !,"Mo='';"
	w !,"}"
	w !,"function MM(evt,nm)"
	w !,"{"
	w !,"pth=evt.getTarget()"
	w !,"Mo=pth;"
	w !,"RegionNum=nm;"
	w !,"}"
	w !,"function REx(clr)"
	w !,"{"
		w !,"if(Mo!='')"
		w !,"{Mo.setAttribute('fill',clr);"
		w !,"hrtregion[RegionNum]=clr;"
		w !,"TTU=Mo.getAttributeNS(null,'id');"
		w !,"DTes(TTU);"
		w !,"}"
	w !,"}"
	
	 w !,"var newMenuRoot = parseXML( printNode( document.getElementById( 'NewMenu' ) ), contextMenu );"
 	w !,"contextMenu.replaceChild( newMenuRoot, contextMenu.firstChild );"  
	
	w !,"]]></script>"
    w !,"</defs>"
	
	s Did=%request.Get("THID")
	s CHid=%request.Get("chID")
	s %session.Data("CH")=CHid
	d HrtOne^%bi.SWr.HrtL(Dtyp,Did,CHid)
		
	w !,"<defs>"
	w !,"<menu id='NewMenu' xmlns='http://foo' onload='GetPosition(evt)'>"
	
	w !,"<separator/>"
	
	//w !,"<item onactivate=""DoListing(0)"">Listing To Screen (whole group) </item>"
	w !,"<item onactivate=""REx('#FFFFFF')"">Clear</item>"
	w !,"<item onactivate=""REx('#00FF00')"">Normal</item>"
   	w !,"<item onactivate=""REx('#FFFF00')"">Hypokinetic</item>"
   	w !,"<item onactivate=""REx('#0000FF')"">Akinetic</item>"
   	w !,"<item onactivate=""REx('#FF0000')"">Dyskinetic</item>"
   	w !,"<item onactivate=""REx('#800080')"">Aneurysmal</item>"
   	w !,"<item onactivate=""REx('#000080')"">Akinetic with Scar</item>"
   	w !,"<item onactivate=""REx('#803300')"">Dyskinetic with Scar</item>"
   	w !,"<item onactivate=""REx('#000000')"">Unscoreable</item>"
   	
   		w !,"<separator/>"
	w !,"<item action='Help'>&amp;Help...</item>"
	w !,"<item action='About'>About SVG Viewer...</item>"
	w !,"</menu>"
 	w !,"</defs>"
 	
 	w !,"</svg>"	
		
	Quit $$$OK
}

}
