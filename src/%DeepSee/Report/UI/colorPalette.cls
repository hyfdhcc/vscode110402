/// Spinner control
Class %DeepSee.Report.UI.colorPalette Extends %ZEN.Component.control [ LegacyInstanceContext, System = 3 ]
{

Parameter INCLUDEFILES = "zenCSLM.js,zreNS.js";

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.colorPalette {
	position:relative;
	top:0px;
	left:0px;
}
	
.colorPaletteBody {
	position:relative;
	top:0px;
	left:0px;
}

.paletteItem {
	position:absolute;
	top:0px;
	left:0px;
	font-size:1px;
}

</style>
}

/*
ZRU.ColorPalette=function(div) {

	if (ZRU.ColorPalette.editPane==null) {
		ZRU.ColorPalette.editPane=ZMS.ModalPane.create("Custom Color Editor");
		ZRU.ColorPalette.editPane.base.style.width="216px";
		ZRU.ColorPalette.editPane.base.style.height="225px";
		ZRU.ColorPalette.colorEdit=ZRU.ColorEditor.create();
		ZRU.ColorPalette.editPane.contents.appendChild(ZRU.ColorPalette.colorEdit.base);
	}
}

ZMS.PickPalette=function(div) {
	this.changeCB=div.getAttribute("onchange");  


	return(this);
}
*/
/// The %DrawHTML method draws the initial HTML for this component.
Method %DrawHTML()
{
	&html<
		<div id="#(..%MakeId("base"))#" class="colorPalette" > 
		<div id="#(..%MakeId("body"))#" class="colorPaletteBody" onclick="this.controller.serviceClick();"></div>
		</div>
	>
}

ClientMethod onloadHandler() [ Language = javascript ]
{
	this._base = this.findElement('base');
	this._base.controller = this;

	// Define global editor space if we don't have one already
//	if (!ZRE) ZRE = {};
	
	if (!ZRE.colors) this.initMaster();
	this._maxCols = 24;
	this._maxRows = 8;
	this._autoFill = 0; // Horizontal
	this._forcedW = 10;
	this._forcedH = 10;
	this._fixed = true;
	this._pick = [];
				
	this.populatePalette();
		
	this.setValue("#ffffff");
}

ClientMethod populatePalette() [ Language = javascript ]
{
	var idx=0;
	for (var r=0;r<8;r++) {
		for (var c=0;c<24;c++) {
			var b=ZLM.makeElement("div");
			b.controller = this;
			b.style.fontSize="1px";
			b.style.background=ZRE.colors[idx].hex;
			b.style.width="10px";
			b.style.height="10px";
			var itemNum=this.addItem(b,ZRE.colors[idx].hex);
			ZLM.setLocalAttribute(b,"oncontextmenu","return(this.controller.tweakCB("+this.index+","+itemNum+",event));");
			idx++;
		}
	}
	this._marker=ZLM.makeElement('div',{style:'position:absolute; display:none; font-size:1px;'});
	this._base.appendChild(this._marker);
	this.refresh();
}

ClientMethod addItem(contents, value) [ Language = javascript ]
{
	
	var div = ZLM.makeElement('div',{'class':'paletteItem',value:value});
	if (contents) div.appendChild(contents);
	div._palette=this;
	div.controller=this;
	div._value = value;

	ZLM.setLocalAttribute(div,"onmouseover","this.controller.reborder(this,1);");
	ZLM.setLocalAttribute(div,"onmouseout","this.controller.reborder(this,0);");
	ZLM.setLocalAttribute(div,"onclick","this.controller.serviceClick(this._value);");
	this.reborder(div,0);

	this._pick.push(div);
	this._base.appendChild(div);
	this._nPicks = this._pick.length;

	return(this._nPicks-1);
	
	return(null);
}

ClientMethod reborder(pickItem, hiLite) [ Language = javascript ]
{
	if (hiLite==1) pickItem.style.border="1px solid white";
	else pickItem.style.border="1px solid #356B8D";
}

ClientMethod refresh() [ Language = javascript ]
{
	this._maxW=this.getMaxW()+2;
	this._maxH=this.getMaxH()+2;
	if (this._autoFill==0) this.layoutHorizontal(this._maxW,this._maxH); 
	else this.layoutVertical(this._maxW,this._maxH); 
	this.markValue();
}

ClientMethod getMaxW() [ Language = javascript ]
{
	if (this._forcedW) return(parseInt(this._forcedW,10));
	var maxW=0;
	for (var i=0;i<this._nPicks;i++) {
		if (this._pick[i]._nativeW>maxW) maxW=this._pick[i]._nativeW;
	}
	return(maxW);
}

ClientMethod getMaxH() [ Language = javascript ]
{
	if (this._forcedH) return(parseInt(this._forcedH,10));
	var maxH=0;
	for (var i=0;i<this._nPicks;i++) {
		if (this._pick[i]._nativeH>maxH) maxH=this._pick[i]._nativeH;
	}
	return(maxH);
}

ClientMethod layoutHorizontal(mW, mH) [ Language = javascript ]
{
	var cCount=0;
	var col=0;
	var row=0;
	for (var i=0;i<this._nPicks;i++) {
		var s = this._pick[i].style;
		s.top=row+"px";
		s.left=col+"px";
		ZLM.setSize(this._pick[i],mW-2,mH-2,"1px solid #356B8D");
		cCount++;
		if (cCount==this._maxCols) {
			cCount=0;
			col=0;
			row+=mH;
		}
		else {
			col+=mW;
		}
	}
	if (cCount==0) row-=mH; 
	ZLM.setSize(this._base,this._maxCols*mW,row+mH,"1px solid #356B8D");
}

ClientMethod layoutVertical(mW, mH) [ Language = javascript ]
{
	var rCount=0;
	var col=0;
	var row=0;
	for (var i=0;i<this._nPicks;i++) {
		var s = this._pick[i].style;
		s.top=row+"px";
		s.left=col+"px";
		ZLM.setSize(this._pick[i],mW-2,mH-2,"1pt solid #356B8D");
		rCount++;
		if (rCount==this._maxRows) {
			rCount=0;
			col+=mW;
			row=0;
		}
		else {
			row+=mH;
		}
	}
	if (rCount==0) col-=mW; 
	ZLM.setSize(this._base,col+mW,this.maxRows*mH,"1px solid #356B8D");
}

ClientMethod markValue() [ Language = javascript ]
{
	for (var i=0;i<this._nPicks;i++) {
		if (this._pick[i]._value==this.value) {
			var p=this._pick[i];
			if (this._base.lastChild!=this._marker) {
				this._base.removeChild(this._marker);
				this._base.appendChild(this._marker);
			}
			ZLM.setSize(this._marker,this._maxW-2,this._maxH-2,"2px solid #e0e0a0");
			this._marker.style.top=(parseInt(p.style.top)-1)+"px";
			this._marker.style.left=(parseInt(p.style.left)-1)+"px";
			this._marker.style.display="block";
			return;
		}
	}
	this._marker.style.display="none";
}

ClientMethod tweakCB(idx, itemNum, event) [ Language = javascript ]
{
	return;
	
	ZRU.ColorPalette.editPane.setOnAccept("ZRU.ColorPalette.editCB("+idx+","+itemNum+");");
	var startColor=ZRU.ColorPalette.registry[idx].palette.getItemValue(itemNum);
	ZRU.ColorPalette.colorEdit.setHex(startColor);
	ZRU.ColorPalette.editPane.show();
	return(ZLM.killEvent(event));
}

ClientMethod serviceClick(value) [ Language = javascript ]
{
	this.setValue(value);
	if (this.onchange) zenInvokeCallbackMethod(this.onchange,this,'onchange');;
}

/// Set the value of a named property.
ClientMethod setProperty(property, value, value2) [ Language = javascript ]
{
	switch(property) {
	case 'value':
		this.value=value;
		this.markValue();
		break;

	default:
		// dispatch
		return this.invokeSuper('setProperty',arguments);
	}
	return true;
}

/*

/// HTML spec:
///  <div class="pickPalette" onchange=_callback()_ maxCols=_#_ maxRows=_#_ defaultValue=_value_ autoFill={horizontal|vertical} >
///    <div class="paletteItem" value=_value_ >
///       _item contents_
///    </div>
///    _..._
///  </div> 

ZMS.PickPalette.prototype.setItem=function(idx,contents,value) {
	if (idx>=this.nPicks) return;
	this.pick[idx].setContents(contents);
	this.pick[idx].setValue(value);
}

ZMS.PickPalette.prototype.setItemContents=function(idx,contents) {
	if (idx>=this.nPicks) return;
	this.pick[idx].setContents(contents);
}

ZMS.PickPalette.prototype.setItemValue=function(idx,value) {
	if (idx>=this.nPicks) return;
	this.pick[idx].setValue(value);
}

ZMS.PickPalette.prototype.getItemContents=function(idx) {
	if (idx>=this.nPicks) return(null);
	return(this.pick[idx].getContents());
}

ZMS.PickPalette.prototype.getItemValue=function(idx) {
	if (idx>=this.nPicks) return(null);
	return(this.pick[idx].getValue());
}

ZMS.PickPalette.prototype.setValue=function(newV) {
	this.value=newV;
	this.markValue();
	if (this.changeCB) eval(this.changeCB);
}

ZMS.PickPalette.prototype.getValue=function() {
	return(this.value);
}

ZMS.PickPalette.prototype.setChangeCallback=function(newCB) {
	this.changeCB=newCB;
}

//===========

ZMS.PaletteItem.prototype.setContents=function(contents) {
	if (this.base.firstChild) this.base.removeChild(this.base.firstChild);
	this.base.appendChild(contents);	
	this.calcNativeSize();
}

ZMS.PaletteItem.prototype.setValue=function(value) {
	this.value=value;
}

ZMS.PaletteItem.prototype.getContents=function() {
	return(this.base.firstChild);
}

ZMS.PaletteItem.prototype.getValue=function() {
	return(this.value);
}

//=========

ZRU.ColorPalette.editPane=null;
ZRU.ColorPalette.colorEdit=null;

ZRU.ColorPalette.editCB=function(idx,itemNum) {
	ZRU.ColorPalette.registry[idx].updateColor(itemNum);
}

ZRU.ColorPalette.prototype.updateColor=function(itemNum) {
	var c=ZRU.ColorPalette.colorEdit.value;
	var div=this.palette.getItemContents(itemNum);
	div.style.background=c;
	this.palette.setItemValue(itemNum,c);
	this.palette.setValue(c);
}

ZRU.ColorPalette.prototype.setValue=function(newV) {
	this.palette.setValue(newV);
}

ZRU.ColorPalette.prototype.getValue=function() {
	return(this.palette.getValue());
}

ZRU.ColorPalette.prototype.setChangeCallback=function(newCB) {
	this.palette.setChangeCallback(newCB);
}

*/
/// Initialize the master palette to a broad collection of statically defined, logically diverse 
/// and organized colors
ClientMethod initMaster() [ Language = javascript ]
{
	ZRE.colors=[{r:255,g:255,b:255,hex:"#ffffff"},{r:0,g:0,b:0,hex:"#000000"},{r:11,g:11,b:11,hex:"#0b0b0b"},{r:22,g:22,b:22,hex:"#161616"},{r:33,g:33,b:33,hex:"#212121"},{r:44,g:44,b:44,hex:"#2c2c2c"},{r:55,g:55,b:55,hex:"#373737"},{r:67,g:67,b:67,hex:"#434343"},{r:78,g:78,b:78,hex:"#4e4e4e"},{r:89,g:89,b:89,hex:"#595959"},{r:100,g:100,b:100,hex:"#646464"},{r:111,g:111,b:111,hex:"#6f6f6f"},{r:122,g:122,b:122,hex:"#7a7a7a"},{r:133,g:133,b:133,hex:"#858585"},{r:144,g:144,b:144,hex:"#909090"},{r:155,g:155,b:155,hex:"#9b9b9b"},{r:166,g:166,b:166,hex:"#a6a6a6"},{r:177,g:177,b:177,hex:"#b1b1b1"},{r:188,g:188,b:188,hex:"#bcbcbc"},{r:200,g:200,b:200,hex:"#c8c8c8"},{r:211,g:211,b:211,hex:"#d3d3d3"},{r:222,g:222,b:222,hex:"#dedede"},{r:233,g:233,b:233,hex:"#e9e9e9"},{r:244,g:244,b:244,hex:"#f4f4f4"},
		{r:64,g:0,b:0,hex:"#400000"},{r:64,g:16,b:0,hex:"#401000"},{r:64,g:32,b:0,hex:"#402000"},{r:64,g:48,b:0,hex:"#403000"},{r:64,g:64,b:0,hex:"#404000"},{r:48,g:64,b:0,hex:"#304000"},{r:32,g:64,b:0,hex:"#204000"},{r:16,g:64,b:0,hex:"#104000"},
		{r:0,g:64,b:0,hex:"#004000"},{r:0,g:64,b:16,hex:"#004010"},{r:0,g:64,b:32,hex:"#004020"},{r:0,g:64,b:48,hex:"#004030"},{r:0,g:64,b:64,hex:"#004040"},{r:0,g:48,b:64,hex:"#003040"},{r:0,g:32,b:64,hex:"#002040"},{r:0,g:16,b:64,hex:"#001040"},{r:0,g:0,b:64,hex:"#000040"},
		{r:16,g:0,b:64,hex:"#100040"},{r:32,g:0,b:64,hex:"#200040"},{r:48,g:0,b:64,hex:"#300040"},{r:64,g:0,b:64,hex:"#400040"},{r:64,g:0,b:48,hex:"#400030"},{r:64,g:0,b:32,hex:"#400020"},{r:64,g:0,b:16,hex:"#400010"},
		{r:127,g:0,b:0,hex:"#7f0000"},{r:127,g:32,b:0,hex:"#7f2000"},{r:127,g:64,b:0,hex:"#7f4000"},{r:127,g:96,b:0,hex:"#7f6000"},{r:127,g:127,b:0,hex:"#7f7f00"},{r:96,g:127,b:0,hex:"#607f00"},{r:64,g:127,b:0,hex:"#407f00"},{r:32,g:127,b:0,hex:"#207f00"},
		{r:0,g:127,b:0,hex:"#007f00"},{r:0,g:127,b:32,hex:"#007f20"},{r:0,g:127,b:64,hex:"#007f40"},{r:0,g:127,b:96,hex:"#007f60"},{r:0,g:127,b:127,hex:"#007f7f"},{r:0,g:96,b:127,hex:"#00607f"},{r:0,g:64,b:127,hex:"#00407f"},{r:0,g:32,b:127,hex:"#00207f"},{r:0,g:0,b:127,hex:"#00007f"},
		{r:32,g:0,b:127,hex:"#20007f"},{r:64,g:0,b:127,hex:"#40007f"},{r:96,g:0,b:127,hex:"#60007f"},{r:127,g:0,b:127,hex:"#7f007f"},{r:127,g:0,b:96,hex:"#7f0060"},{r:127,g:0,b:64,hex:"#7f0040"},{r:127,g:0,b:32,hex:"#7f0020"},{r:191,g:0,b:0,hex:"#bf0000"},
		{r:191,g:48,b:0,hex:"#bf3000"},{r:191,g:96,b:0,hex:"#bf6000"},{r:191,g:143,b:0,hex:"#bf8f00"},{r:191,g:191,b:0,hex:"#bfbf00"},{r:143,g:191,b:0,hex:"#8fbf00"},{r:96,g:191,b:0,hex:"#60bf00"},{r:48,g:191,b:0,hex:"#30bf00"},{r:0,g:191,b:0,hex:"#00bf00"},
		{r:0,g:191,b:48,hex:"#00bf30"},{r:0,g:191,b:96,hex:"#00bf60"},{r:0,g:191,b:143,hex:"#00bf8f"},{r:0,g:191,b:191,hex:"#00bfbf"},{r:0,g:143,b:191,hex:"#008fbf"},{r:0,g:96,b:191,hex:"#0060bf"},{r:0,g:48,b:191,hex:"#0030bf"},{r:0,g:0,b:191,hex:"#0000bf"},
		{r:48,g:0,b:191,hex:"#3000bf"},{r:96,g:0,b:191,hex:"#6000bf"},{r:143,g:0,b:191,hex:"#8f00bf"},{r:191,g:0,b:191,hex:"#bf00bf"},{r:191,g:0,b:143,hex:"#bf008f"},{r:191,g:0,b:96,hex:"#bf0060"},{r:191,g:0,b:48,hex:"#bf0030"},{r:255,g:0,b:0,hex:"#ff0000"},
		{r:255,g:64,b:0,hex:"#ff4000"},{r:255,g:127,b:0,hex:"#ff7f00"},{r:255,g:191,b:0,hex:"#ffbf00"},{r:255,g:255,b:0,hex:"#ffff00"},{r:191,g:255,b:0,hex:"#bfff00"},{r:127,g:255,b:0,hex:"#7fff00"},{r:64,g:255,b:0,hex:"#40ff00"},{r:0,g:255,b:0,hex:"#00ff00"},
		{r:0,g:255,b:64,hex:"#00ff40"},{r:0,g:255,b:127,hex:"#00ff7f"},{r:0,g:255,b:191,hex:"#00ffbf"},{r:0,g:255,b:255,hex:"#00ffff"},{r:0,g:191,b:255,hex:"#00bfff"},{r:0,g:127,b:255,hex:"#007fff"},{r:0,g:64,b:255,hex:"#0040ff"},{r:0,g:0,b:255,hex:"#0000ff"},
		{r:64,g:0,b:255,hex:"#4000ff"},{r:127,g:0,b:255,hex:"#7f00ff"},{r:191,g:0,b:255,hex:"#bf00ff"},{r:255,g:0,b:255,hex:"#ff00ff"},{r:255,g:0,b:191,hex:"#ff00bf"},{r:255,g:0,b:127,hex:"#ff007f"},{r:255,g:0,b:64,hex:"#ff0040"},
		{r:255,g:64,b:64,hex:"#ff4040"},{r:255,g:112,b:64,hex:"#ff7040"},{r:255,g:159,b:64,hex:"#ff9f40"},{r:255,g:207,b:64,hex:"#ffcf40"},{r:255,g:255,b:64,hex:"#ffff40"},{r:207,g:255,b:64,hex:"#cfff40"},{r:159,g:255,b:64,hex:"#9fff40"},{r:112,g:255,b:64,hex:"#70ff40"},
		{r:64,g:255,b:64,hex:"#40ff40"},{r:64,g:255,b:112,hex:"#40ff70"},{r:64,g:255,b:159,hex:"#40ff9f"},{r:64,g:255,b:207,hex:"#40ffcf"},{r:64,g:255,b:255,hex:"#40ffff"},{r:64,g:207,b:255,hex:"#40cfff"},{r:64,g:159,b:255,hex:"#409fff"},{r:64,g:112,b:255,hex:"#4070ff"},
		{r:64,g:64,b:255,hex:"#4040ff"},{r:112,g:64,b:255,hex:"#7040ff"},{r:159,g:64,b:255,hex:"#9f40ff"},{r:207,g:64,b:255,hex:"#cf40ff"},{r:255,g:64,b:255,hex:"#ff40ff"},{r:255,g:64,b:207,hex:"#ff40cf"},{r:255,g:64,b:159,hex:"#ff409f"},{r:255,g:64,b:112,hex:"#ff4070"},
		{r:255,g:127,b:127,hex:"#ff7f7f"},{r:255,g:159,b:127,hex:"#ff9f7f"},{r:255,g:191,b:127,hex:"#ffbf7f"},{r:255,g:223,b:127,hex:"#ffdf7f"},{r:255,g:255,b:127,hex:"#ffff7f"},{r:223,g:255,b:127,hex:"#dfff7f"},{r:191,g:255,b:127,hex:"#bfff7f"},{r:159,g:255,b:127,hex:"#9fff7f"},
		{r:127,g:255,b:127,hex:"#7fff7f"},{r:127,g:255,b:159,hex:"#7fff9f"},{r:127,g:255,b:191,hex:"#7fffbf"},{r:127,g:255,b:223,hex:"#7fffdf"},{r:127,g:255,b:255,hex:"#7fffff"},{r:127,g:223,b:255,hex:"#7fdfff"},{r:127,g:191,b:255,hex:"#7fbfff"},{r:127,g:159,b:255,hex:"#7f9fff"},
		{r:127,g:127,b:255,hex:"#7f7fff"},{r:159,g:127,b:255,hex:"#9f7fff"},{r:191,g:127,b:255,hex:"#bf7fff"},{r:223,g:127,b:255,hex:"#df7fff"},{r:255,g:127,b:255,hex:"#ff7fff"},{r:255,g:127,b:223,hex:"#ff7fdf"},{r:255,g:127,b:191,hex:"#ff7fbf"},{r:255,g:127,b:159,hex:"#ff7f9f"},
		{r:255,g:191,b:191,hex:"#ffbfbf"},{r:255,g:207,b:191,hex:"#ffcfbf"},{r:255,g:223,b:191,hex:"#ffdfbf"},{r:255,g:239,b:191,hex:"#ffefbf"},{r:255,g:255,b:191,hex:"#ffffbf"},{r:239,g:255,b:191,hex:"#efffbf"},{r:223,g:255,b:191,hex:"#dfffbf"},{r:207,g:255,b:191,hex:"#cfffbf"},
		{r:191,g:255,b:191,hex:"#bfffbf"},{r:191,g:255,b:207,hex:"#bfffcf"},{r:191,g:255,b:223,hex:"#bfffdf"},{r:191,g:255,b:239,hex:"#bfffef"},{r:191,g:255,b:255,hex:"#bfffff"},{r:191,g:239,b:255,hex:"#bfefff"},{r:191,g:223,b:255,hex:"#bfdfff"},{r:191,g:207,b:255,hex:"#bfcfff"},
		{r:191,g:191,b:255,hex:"#bfbfff"},{r:207,g:191,b:255,hex:"#cfbfff"},{r:223,g:191,b:255,hex:"#dfbfff"},{r:239,g:191,b:255,hex:"#efbfff"},{r:255,g:191,b:255,hex:"#ffbfff"},{r:255,g:191,b:239,hex:"#ffbfef"},{r:255,g:191,b:223,hex:"#ffbfdf"},{r:255,g:191,b:207,hex:"#ffbfcf"}];
}

ClientMethod initColor(min, max, ratio) [ Language = javascript ]
{
	if (ratio==0) return(Math.round(min*2.55));
	if (ratio==100) return(Math.round(max*2.55));
	if (ratio==25) return(Math.round(2.55*(3*min+max)/4));
	if (ratio==50) return(Math.round(2.55*(min+max)/2));
	if (ratio==75) return(Math.round(2.55*(min+3*max)/4));
}

/// Calculate a master palette of colors.  The end result is the same as the colors 
/// defined in initMaster.  The dynamic algorithm show here takes longer but illustraites
/// how the palette in the other function was determined.  For performance reasons, the 
/// initMaster call is preferable.
ClientMethod calculateMaster() [ Language = javascript ]
{
	// General color-gun sequence is HH-LL+ with four steps in each phase
	// In H phase gun is at max value for row (25,50,75 - for rows 0-2, 100% otherwise)
	// In L phase gun is at min value for row (0 - for rows 0-3, then 25, 50 , 75 respectively)
	// In - phase gun steps from max value to min++ in 4 steps (max, (3*max+min)/4, (max+min)/2, (3*min+max)/4)
	// In + phase gun steps from min value to max-- in 4 steps (min, (3*min+max)/4, (min+max)/2, (3*max+min)/4)
	// green gun is two phases out of sync with red
	// blue gun is four phases out of sync with red
	ZRE.colors=[];
	var phaseIdx = [100,100,100,100, 100,75,50,25, 0,0,0,0, 0,0,0,0, 0,25,50,75, 100,100,100,100];
	var idx=1;
	var clr={};
	clr.r=255;
	clr.g=255;
	clr.b=255;
	clr.hex="#ffffff";
	ZRE.color[0]=clr;
	for (var c=0;c<23;c++) {
		var clr={};
		clr.r=Math.round(255*c/23);
		clr.g=clr.r;
		clr.b=clr.r;
		clr.hex=ZLM.toHTMLColorSpec(clr.r+","+clr.g+","+clr.b);
		ZRE.color[idx++]=clr;
	}
	for (var r=0;r<7;r++) {
		// init phase for each row
		var redI=0;
		var greenI=16;
		var blueI=8;
		var max=100;
		var min=0;
		if (r==0) max=25;
		else if(r==1) max=50;
		else if(r==2) max=75;
		if (r==4) min=25;
		if (r==5) min=50;
		if (r==6) min=75;
		for (var c=0;c<24;c++) {
			var clr={};
			clr.r=this.initColor(min,max,phaseIdx[redI]);
			clr.g=this.initColor(min,max,phaseIdx[greenI]);
			clr.b=this.initColor(min,max,phaseIdx[blueI]);
			clr.hex=ZLM.toHTMLColorSpec(clr.r+","+clr.g+","+clr.b);
			ZRE.color[idx]=clr;
			redI++;
			if (redI>23) redI=0;
			greenI++;
			if (greenI>23) greenI=0;
			blueI++;
			if (blueI>23) blueI=0;
			idx++;
		}
	}
}

}
