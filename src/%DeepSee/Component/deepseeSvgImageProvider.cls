Include %ZEN.ReportUtil

/// SVGImageProvider
/// These utilities are built upon the java .jar libraries in the FOP distribution included
/// with modern releases of Cache
Class %DeepSee.Component.deepseeSvgImageProvider Extends %ZEN.ComponentEx.svgImageProvider [ System = 3 ]
{

///  This is the XML namespace used for library components.
Parameter NAMESPACE = "http://www.intersystems.com/deepsee";

Parameter DOMAIN = "%DeepSee";

Property printParameters;

/// Create a temporary SVG container in the body of the Zen component. This is used to
/// trigger the calcualation of bounding boxes of temporary elements that would not otherwise
/// be committed to the DOM.
ClientMethod createTempSvgContainer() [ Language = javascript ]
{
	// Method added by DTB407
	var svg = this.getTempSvgContainer();
	
	if (!svg) {
		var body = document.getElementById('zenBody');
		
		svg = document.createElementNS(SVGNS,'svg');
		svg.setAttribute('id','tempSVGContainer');
		if ((svg)&&(body)) {
			body.appendChild(svg);
		}
	}
	
	return svg;
}

/// Return the current temporary SVG container, if it exists.
ClientMethod getTempSvgContainer() [ Language = javascript ]
{
	// Method added by DTB407
	return document.getElementById('tempSVGContainer');
}

/// Remove the temporary SVG container from the Zen body.
ClientMethod destroyTempSvgContainer() [ Language = javascript ]
{
	// Method added by DTB407
	var body = document.getElementById('zenBody');
	var svg = this.getTempSvgContainer();
	if ((svg)&&(body)) {
		body.removeChild(svg);
	}
}

/// Given the ID of a Zen component, attempt to extract the primary html table
/// and convert it to an SVG representation. This also supports 4-quadrant tables used
/// for some DeepSee widgets.
ClientMethod createSVGTableFromZenComponent(componentId) [ Language = javascript ]
{
	// Method added by DTB345
	this.createTempSvgContainer();		// DTB407 - Establish a workspace for physical property calculation
	
	var svgContent = null;
	
	if (!componentId) {
		return svgContent;
	}
	var component = zenPage.getComponentById(componentId);
	
	var mainDiv = component.getEnclosingDiv();
	var tables = mainDiv.getElementsByTagName('table');
	
	if (tables.length==1) {
		svgContent = this.convertHTMLTableToSVG(tables[0],componentId);
	}
	else {
		// DTB367 - This is a composite table with multiple components making up the display
		var svgTables = [];
		// Assume 4 quadrant tables (original style for pivots, kpis, listings)
		var leftWidth = 0;
		var topHeight = 0;
		var dataWidth = 0;
		var dataHeight = 0;
		for (var t=0; t<tables.length; t++) {
			svgTables[t] = this.convertHTMLTableToSVG(tables[t],componentId);
			
			if (t==0) {
				// Initialize the content using the first table encountered
				// All <svg> root content should be the same.
				svgContent = svgTables[0];
			}
			else {
				// Add any subsequent groups 
				svgContent.appendChild(svgTables[t].childNodes[0]);
			}
			
			// Record the sizes of the tables to position them later
			groupId = svgTables[t].id;
			if (groupId.indexOf('leftTable')>=0) {
				leftWidth = parseFloat(svgTables[t].getAttribute('width'));
			}
			else if (groupId.indexOf('topTable')>=0) {
				topHeight = parseFloat(svgTables[t].getAttribute('height'));
			}
			else if (groupId.indexOf('dataTable')>=0) {
				// Record the size of the lower right quadrant
				dataHeight = parseFloat(svgTables[t].getAttribute('height'));
				dataWidth = parseFloat(svgTables[t].getAttribute('width'));
			}
		}
		
		var groupId='';
		var totalWidth = leftWidth + dataWidth;
		var totalHeight = topHeight + dataHeight;
		svgContent.setAttribute('height',totalHeight);
		svgContent.setAttribute('width',totalWidth);
		
		// Draw a rect to enclose the entire table
		var totalRect = document.createElementNS(SVGNS,'rect');
		totalRect.setAttribute('height',totalHeight);
		totalRect.setAttribute('width',totalWidth);
		totalRect.setAttribute('stroke-width',1);
		totalRect.setAttribute('stroke','#000000');
		//svgContent.appendChild(totalRect);
		
		for (var g=0; g<svgContent.childNodes.length; g++) {
			groupId = svgContent.childNodes[g].id
			if (groupId.indexOf('dataTable')>=0) {
				svgContent.childNodes[g].setAttribute('transform','translate(' + leftWidth + ' ' + topHeight + ')');
			}
			else if (groupId.indexOf('leftTable')>=0) {
				svgContent.childNodes[g].setAttribute('transform','translate(0 ' + topHeight + ')');
			}
			else if (groupId.indexOf('topTable')>=0) {
				svgContent.childNodes[g].setAttribute('transform','translate(' + leftWidth + ' 0)');
			}
		}
	}
	
	this.destroyTempSvgContainer();		// DTB407 - Remove the temporary workspace now that the table is complete

	return svgContent;
}

/// - chartDocument is the document obtained using 
///    %DeepSee.Component.deepseeSvgImageProvider:getSVGDOMRoot(chartSVGFrameId)
/// - legendSVG is manufactured by
///    %DeepSee.Component.deepseeSvgImageProvider:createSVGTableFromZenComponent(chartLegendId)
ClientMethod addSVGLegendToChart(chartDocument, legendSVG, legendPosition) [ Language = javascript ]
{
	// Method added by DTB345
	if ((!legendPosition)||('none'==legendPosition)) {
		return;
	}
	var chartSVG = null;
	var chartScalingGroup = null;
	
	// Search for the actual <svg> node. Several children could be style sheets.
	for (var p=chartDocument.firstChild; p!=null; p=p.nextSibling) {
		if ('svg'==p.nodeName) {
			chartSVG = p;
		}
	}
	
	if (chartSVG) {
		for (var g=chartSVG.firstChild; g!=null; g=g.nextSibling) {
			if (('g'==g.nodeName)&&('zenScalingGroup'==g.id)) {
				chartScalingGroup = g;
			}
		}
	}
	else {
		return;
	}

	if (!chartScalingGroup) {
		return;
	}

	// legendSVG was created by convertHTMLTableToSVG, which has one group below the 
	// primary <svg> node. This is the group that can be added to the svg document.
	var legendGroup = legendSVG.childNodes[0]
	
	var cw = parseFloat(chartSVG.getAttribute('width'));
	var ch = parseFloat(chartSVG.getAttribute('height'));
	var lw = parseFloat(legendSVG.getAttribute('width'));
	var lh = parseFloat(legendSVG.getAttribute('height'));
	
	// Translate the contents to make room for the legend
	if ('left'==legendPosition) {
		chartScalingGroup.setAttribute('transform','translate('+lw+' 0)');
		chartSVG.setAttribute('width',cw+lw);
		if (lh > ch) {
			// DTB367 - Prevent legend clipping
			chartSVG.setAttribute('height',lh);
		}
	}
	else if ('top'==legendPosition) {
		chartScalingGroup.setAttribute('transform','translate(0 '+lh+')');
		chartSVG.setAttribute('height',ch+lh);
		if (lw > cw) {
			// DTB367 - Prevent legend clipping
			chartSVG.setAttribute('width',lh);
		}
	}
	else if ('right'==legendPosition) {
		legendGroup.setAttribute('transform','translate('+cw+' 0)');
		chartSVG.setAttribute('width',cw+lw);
		if (lh > ch) {
			// DTB367 - Prevent legend clipping
			chartSVG.setAttribute('height',lh);
		}
	}
	else if ('bottom'==legendPosition) {
		legendGroup.setAttribute('transform','translate(0 '+ch+')');
		chartSVG.setAttribute('height',ch+lh);
		if (lw > cw) {
			// DTB367 - Prevent legend clipping
			chartSVG.setAttribute('width',lh);
		}
	}
	
	// Add the legend content to the chart SVG document
	chartSVG.appendChild(legendGroup);
	
	return chartDocument;
}

/// Pull the svg legend from the chart document
ClientMethod removeSVGLegendFromChart(chartDocument, legendGroupId, legendPosition) [ Language = javascript ]
{
	// Method added by DTB345
	var chartSVG = null;
	for (var p=chartDocument.firstChild; p!=null; p=p.nextSibling) {
		if ('svg'==p.nodeName) {
			chartSVG = p;
		}
	}
	if (chartSVG) {
		for (var g=chartSVG.firstChild; g!=null; g=g.nextSibling) {
			if (('g'==g.nodeName)&&('zenScalingGroup'==g.id)) {
				chartScalingGroup = g;
			}
		}
	}
	else {
		return;
	}
	
	// Remove the legend node
	for (var p=chartSVG.firstChild; p!=null; p=p.nextSibling) {
		if (legendGroupId==p.id) {
			// +DTB356 - Resize the chartSVG once the child is removed
			if (('left'==legendPosition)||('right'==legendPosition)) {
				// Remove the legend width from the chart width
				var lw = p.getBBox().width;
				var cw = chartSVG.getAttribute('width');
				chartSVG.setAttribute('width',cw-lw);
			}
			else if (('top'==legendPosition)||('bottom'==legendPosition)) {
				// Remove the legend height from the chart height
				var lh = p.getBBox().height;
				var ch = chartSVG.getAttribute('height');
				chartSVG.setAttribute('height',ch-lh);
			}
			else {
				// No resize
			}
			// -DTB356
			
			chartSVG.removeChild(p);
		}
	}
	
	if (!chartScalingGroup) {
		return;
	}
	
	// Remove the transform from the chart content
	chartScalingGroup.setAttribute('transform','');
	
	return chartDocument;
}

/// Create an SVG representation of a single HTML table. These could be:<br>
/// - Components of a pivot or listing table<br>
/// - Chart legends
ClientMethod convertHTMLTableToSVG(table, defaultId) [ Language = javascript ]
{
	// Method Added By DTB341
	var tableId = (table.id ? table.id : defaultId)
	
	var svgFrame = document.createElementNS(SVGNS,'svg');
	var svgFrameId = 'svg_' + tableId; 
	svgFrame.id = svgFrameId;
	svgFrame.setAttribute('xmlns:xlink','http://www.w3.org/1999/xlink');
	svgFrame.setAttribute('height',table.offsetHeight);
	svgFrame.setAttribute('width',table.offsetWidth);
	svgFrame.setAttribute('xmlns',SVGNS);
	
	// Create a new svg group for the svg table
	var svgTable = document.createElementNS(SVGNS,'g');
	svgTable.id = 'svg_' + tableId + '_table';
	svgTable.setAttribute('x',0);
	svgTable.setAttribute('y',0);
	
	// Render a table border
	var svgTableBorder = document.createElementNS(SVGNS,'rect');
	svgTableBorder.id = 'svg_' + tableId + '_border';
	svgTableBorder.setAttribute('stroke','#000000');
	svgTableBorder.setAttribute('stroke-width',3);
	svgTableBorder.setAttribute('fill','#ffffff');
	svgTableBorder.setAttribute('height',table.offsetHeight);
	svgTableBorder.setAttribute('width',table.offsetWidth);
	svgTable.appendChild(svgTableBorder);
	
	svgFrame.appendChild(svgTable);
	
	// Commit the contents to the new svgTable
	this.dumpDOMTreeGeometry(table,svgTable);	
	
	
	return svgFrame;
}

/// Given an htmlCell representing a cell of an html table, return an equivalent representation as a member of an
/// svg group.
ClientMethod convertHTMLCellToSVGRect(htmlCell, geometry) [ Language = javascript ]
{
	// Method Added By DTB341
	var svgCell = document.createElementNS(SVGNS,'g');
	
	// Set the ID for this svg cell. Try to make it unique basd on the HTML cell 
	// ID or on an internal counter, as appropriate.
	var idString = 'svg_';
	if (htmlCell.id) {
		idString += htmlCell.id;
	}
	else {
		if (!zenPage._cellIdNo) {
			zenPage._cellIdNo = 0;
		}
		idString += 'Cell'+zenPage._cellIdNo;
		zenPage._cellIdNo++;
	}

	svgCell.id = idString;

	
	// Capture complete styling of the cell
	var htmlStyle = window.getComputedStyle(htmlCell,null);
	
	// Render the svg rect container with the same geometry as the original html cell. 
	// This rect draws the outline of the cell and provides the background color.
	var svgRect = document.createElementNS(SVGNS,'rect');
	svgRect.id = svgCell.id + '_rect';
	for (g in geometry) {
		svgRect.setAttribute(g,geometry[g]);
	}
	
	// Apply rect styling
	this.applyHTMLStyleToSVG(svgRect,htmlStyle,1);
	
	svgCell.appendChild(svgRect);
	
	if ('DIV'==htmlCell.childNodes[0].nodeName) {
		var childDiv = htmlCell.childNodes[0];
		var divClass = childDiv.getAttribute('class');
		if ('dslegendBox'==divClass) {
			// If this is a legend box, style the SVG rect like the inner Div
			var divStyle = window.getComputedStyle(childDiv,null);
			this.applyHTMLStyleToSVG(svgRect,divStyle,1);
		}
		else {
			if (1==childDiv.childNodes.length) {
				// Text node
				// DTB367 - for cross-browser compatibility, look for possible text containers
				if (htmlCell.innerText) {
					// Look for innerText first (Chrome, IE)
					var htmlTextStr = htmlCell.innerText.trim();
				}
				else if (htmlCell.textContent) {
					// Try textContent (FireFox)
					var htmlTextStr = htmlCell.textContent.trim();
				}

				if (htmlTextStr) {
					var svgText = this.createSVGTextNode(htmlTextStr,svgCell.id+'_text',geometry,htmlStyle);
					svgCell.appendChild(svgText);
				}
			}
			else if (2==childDiv.childNodes.length) {
				var firstNode = childDiv.childNodes[0];
				var secondNode = childDiv.childNodes[1];
				if ('IMG'==secondNode.nodeName) {
					// Image
					var svgImage = document.createElementNS(SVGNS,"image");
					svgImage.id = svgCell.id + '_image';
					svgImage.setAttribute('xlink:href',secondNode.src);
					for (g in geometry) {
						svgImage.setAttribute(g,geometry[g]);
					}
					svgCell.appendChild(svgImage);
				}
			}
		}
	} 
	else if ('#text'==htmlCell.childNodes[0].nodeName) {
		// Text node
		// DTB367 - for cross-browser compatibility, look for possible text containers
		if (htmlCell.innerText) {
			// Look for innerText first (Chrome, IE)
			var htmlTextStr = htmlCell.innerText.trim();
		}
		else if (htmlCell.textContent) {
			// Try textContent (FireFox)
			var htmlTextStr = htmlCell.textContent.trim();
		}
		
		var svgText = this.createSVGTextNode(htmlTextStr,svgCell.id+'_text',geometry,htmlStyle);
		svgCell.appendChild(svgText);
	}

	return svgCell;
}

ClientMethod createSVGTextNode(text, id, geometry, htmlStyle) [ Language = javascript ]
{
	// Method added by DTB341
	var svgText = document.createElementNS(SVGNS,"text");
	var svgWorkspace = this.getTempSvgContainer();		// DTB407
	
	if (id) {
		svgText.id = id;
	}
	
	// Position within the document is provided
	var x = 0;
	var y = 0;
	var height = 0;
	var width = 0;
	if (geometry) {
		x = (geometry.x) ? parseFloat(geometry.x) : 0;
		y = (geometry.y) ? parseFloat(geometry.y) : 0;
		height = (geometry.height) ? parseFloat(geometry.height) : 0;
		width = (geometry.width) ? parseFloat(geometry.width) : 0;
	}

	svgText.setAttribute('x',x);
	svgText.setAttribute('y',y);
	svgText.setAttribute('height',height);
	svgText.setAttribute('width',width);

	// Apply styling
	this.applyHTMLStyleToSVG(svgText,htmlStyle,1);

	// Add the actual text
	var textNode = document.createTextNode(text);
	svgText.appendChild(textNode);
	
	if (svgWorkspace) {
		// DTB407 - Use the workspace to calculate the dimensions of the textNode.
		// If the bounding box can be calculated, use this to wrap the text as needed.
		
		// Break the text into words
		svgWorkspace.appendChild(svgText);
		var textBBox = svgText.getBBox();
		
		if (((textBBox.width)/geometry.width)>=1) {
			// This text is not going to fit wihtin the box. Try to break it down into words and apply word wrap.
			var words = text.split(' ');
			if (words.length > 1) {
				// There are multiple words. Look to see if word wrap is possible within the provided geometry.
				var wrappedSvgText = this.wrapSvgText(words,id,geometry,htmlStyle);
				if (wrappedSvgText) {
					svgText = wrappedSvgText;
				}
			}
		}
		
		svgWorkspace.appendChild(svgText);
		var textBBox = svgText.getBBox();
		
		if (((textBBox.width)/geometry.width)>=1) {
			// DTB407 - If the wrapping did not do the job, scale the text down to fit.
			svgText.setAttribute('transform','scale('+geometry.width/(textBBox.width)+')');
		}
		
		svgWorkspace.removeChild(svgText);
	}
	
	return svgText;
}

/// Return an array with the components of wrapped SVG text
ClientMethod wrapSvgText(words, id, geometry, htmlStyle) [ Language = javascript ]
{
	// Method added by DTB407
	var returnSvg = null;
	var svgWorkspace = this.getTempSvgContainer();
	var svgTextGroup = document.createElementNS(SVGNS,'g');
	svgTextGroup.setAttribute('id',id);
	
	// Position within the document is provided
	var x = 0;
	var y = 0;
	var height = 0;
	var width = 0;
	if (geometry) {
		x = (geometry.x) ? parseFloat(geometry.x) : 0;
		y = (geometry.y) ? parseFloat(geometry.y) : 0;
		height = (geometry.height) ? parseFloat(geometry.height) : 0;
		width = (geometry.width) ? parseFloat(geometry.width) : 0;
	}
	
	// Protect all work in a Try block to ensure the group can be removed from the temp workspace
	try {
		// Calculate styled space width
		var svgTextSpace = document.createElementNS(SVGNS,"text");
		var spaceNode = document.createTextNode('"          "');		// DTB407 - 10 spaces in quotes
		svgTextSpace.appendChild(spaceNode);
		svgTextGroup.appendChild(svgTextSpace);
		svgWorkspace.appendChild(svgTextGroup);

		svgTextSpace.setAttribute('x',x);
		svgTextSpace.setAttribute('y',y);
		svgTextSpace.setAttribute('height',height);
		svgTextSpace.setAttribute('width',width);

		this.applyHTMLStyleToSVG(svgTextSpace,htmlStyle,1);
		
		var spaceWidth = svgTextSpace.getBBox().width/10;
		
		svgWorkspace.removeChild(svgTextGroup);
		svgTextGroup.removeChild(svgTextSpace);
		
		var currWordCount = 0;
		var currWordWidth = 0;
		var currLineWidth = 0;
		var currLineCount = 0;
		var currLineText = '';
		var svgTempText = null;
		var textNode = null;
		var svgLines = [];
		for ( var w=0 ; w < words.length ; w++ ) {
			currWordCount++;
			svgTempText = document.createElementNS(SVGNS,"text");
			textNode = document.createTextNode(words[w]);
			svgTempText.appendChild(textNode);
			svgTextGroup.appendChild(svgTempText);
			svgWorkspace.appendChild(svgTextGroup);
			
			currWordWidth = svgTempText.getBBox().width;
			currLineWidth += (((currWordCount>1) ? spaceWidth : 0) + currWordWidth);
			
			// Compare the current line length to the available space
			if ((currLineWidth > geometry.width ) && (currWordCount > 1)) {
				// Bank the current line and reset the counters
				svgLines.push(currLineText);
				currLineText = '';
				currLineWidth = 0;
				currWordCount = 0;
				currLineCount++;
			}
			
			currLineText += (((currWordCount>1) ? ' ' : '') + words[w]);
			
			svgWorkspace.removeChild(svgTextGroup);
			svgTextGroup.removeChild(svgTempText);
		}
		svgLines.push(currLineText);
		
		if (svgLines.length>1) {
			// Create a multi-line svgText node to return to the caller
			returnSvg = document.createElementNS(SVGNS,"g");
			var lineHeight = height/(svgLines.length);
			for ( lineNo in svgLines) {
				// Add the line to the returnSVG
				var svgLine = document.createElementNS(SVGNS,"text");
				svgLine.setAttribute('id',id + ':line' + lineNo);
				
				lineText = document.createTextNode(svgLines[lineNo]);
				svgLine.appendChild(lineText);
				svgTextGroup.appendChild(svgLine);
				svgWorkspace.appendChild(svgTextGroup);
				
				// Add styling and positioning to the line within the group
				svgLine.setAttribute('x',x);
				svgLine.setAttribute('y',y + (lineHeight*lineNo));
				svgLine.setAttribute('height',lineHeight);
				svgLine.setAttribute('width',width);
				
				this.applyHTMLStyleToSVG(svgLine,htmlStyle,1);
				
				returnSvg.appendChild(svgLine);
			}
		}
	}
	catch(ex) {
		zenExceptionHandler(ex,arguments,'Error in onlayoutHandler');
		// Clean up the workspace
		if (svgTextGroup.parentNode == svgWorkspace) {
			svgWorkspace.removeChild(svgTextGroup);
		}
	}
	
	return returnSvg;
}

/// As closely as possible copy an html css style definition to an SVG object.
/// This can sanitize the style input for compatibility printing in Batik or
/// retain more complex styling for browser display.
ClientMethod applyHTMLStyleToSVG(svgNode, htmlStyle, forBatik) [ Language = javascript ]
{
	// Method added by DTB341
	var nodeHeight = parseFloat(svgNode.getAttribute('height'));
	var nodeWidth = parseFloat(svgNode.getAttribute('width'));
	var nodeX = parseFloat(svgNode.getAttribute('x'));
	var nodeY = parseFloat(svgNode.getAttribute('y'));
	
	// +DTB405 - Use print overrides
	var fontSize = htmlStyle.fontSize;
	var fontFamily = htmlStyle.fontFamily;
	
	var printParameters = this.getPrintParameters();
	
	if (printParameters) {
		
		if (svgNode.id.indexOf('col')>=0) {
			// Column Label
			if (printParameters.FONTSIZECOL) {
				fontSize = this.convertSizeToPoint(printParameters.FONTSIZECOL).value;
			}
			if (printParameters.FONTFAMILYCOL) {
				fontFamily = printParameters.FONTFAMILYCOL
			}
		}
		else if (svgNode.id.indexOf('row')>=0) {
			// Row Label
			if (printParameters.FONTSIZEROW) {
				fontSize = this.convertSizeToPoint(printParameters.FONTSIZEROW).value;
			}
			if (printParameters.FONTFAMILYROW) {
				fontFamily = printParameters.FONTFAMILYROW
			}
		}
		else if (svgNode.id.indexOf('cell')>=0) {
			// Cell
			if (printParameters.FONTSIZECELL) {
				fontSize = this.convertSizeToPoint(printParameters.FONTSIZECELL).value;
			}
			if (printParameters.FONTFAMILYCELL) {
				fontFamily = printParameters.FONTFAMILYCELL
			}
		}
	}
	// -DTB405
	
	
	// Common settings
	
	// Node-based settings
	if ('text'==svgNode.nodeName) {
		// This is the styling of the actual text
		if (fontSize) {
			// DTB421 - Only set this attribute if there is a real value
			svgNode.setAttribute('font-size',fontSize);
		}
		if (fontFamily) {
			// DTB421 - Only set this attribute if there is a real value
			svgNode.setAttribute('font-family',fontFamily);
		}
		svgNode.setAttribute('font-weight',(htmlStyle.fontWeight)?htmlStyle.fontWeight:'normal');	// DTB350
		svgNode.setAttribute('fill',htmlStyle.color);
		svgNode.setAttribute('stroke',htmlStyle.color);
		svgNode.setAttribute('stroke-width',0);
		
		// Text Alignment:
		// 		left - start
		//		center - middle
		// 		right - end
		var textAlign = htmlStyle.textAlign;
		var textAnchor = '';
		var maxPadding = 2;		// DTB407
		if ('left'==textAlign) {
			textAnchor = 'start';
			svgNode.setAttribute('x',nodeX + Math.min(nodeWidth*0.1,maxPadding));		// DTB407 - Impose a maximum padding
		}
		else if ('center'==textAlign) {
			textAnchor = 'middle';
			svgNode.setAttribute('x',nodeX + (nodeWidth*0.5));
		}
		else if ('right'==textAlign) {
			textAnchor = 'end';
			//svgNode.setAttribute('x',nodeX + (nodeWidth*0.9));
			svgNode.setAttribute('x',nodeX + Math.max(nodeWidth*0.9,nodeWidth-maxPadding));		// DTB407 - Impose a maximum padding
		}
		else {
			// DTB350 - Default to the same settings as 'left'
			textAnchor = 'start';
			svgNode.setAttribute('x',nodeX + Math.min(nodeWidth*0.1,maxPadding));		// DTB407 - Impose a maximum padding
		}

		// DTB346 - Vertical positioning needs to be calculated off the 
		// cell geometry and font size.
		// This currently assumes vertical-align="middle"
		svgNode.setAttribute('y',nodeY + (nodeHeight+parseFloat(fontSize))*0.5);
		svgNode.setAttribute('text-anchor',textAnchor);
	}
	else {
		var htmlBackground = htmlStyle.backgroundColor
		if ((htmlBackground) && 
				(('rgba(0,0,0,0)'==htmlBackground.replace(/ /g,'') || 
					('transparent'==htmlBackground))) && 
					(htmlStyle.backgroundImage) &&
				(htmlStyle.backgroundImage.indexOf('linear-gradient')>=0)) {
			// DTB350 - Special handling for the default pivot table header background
			htmlBackground = 'rgb(232,232,232)';
		}
		else if ((htmlBackground) && ('transparent'==htmlBackground)) {
			// DTB367 - Assume transparent means white
			htmlBackground = 'rgb(255,255,255)';
		}
		svgNode.setAttribute('fill',htmlBackground);
		svgNode.setAttribute('stroke','#000000');
	}
	
	if (forBatik) {
		// Remove some problematic settings so Batik has an easier time processing the style
		var svgFill = svgNode.getAttribute('fill');
		if ((svgFill)&&(svgFill.indexOf("rgba(")>=0)) { // Batik doesn't take RGBA values
			var tmp = svgFill.split("rgba(");
			for (var i=1;i<tmp.length;i++) {
				var balance = tmp[i];
				var tmp2 = balance.split(")");
				var args = tmp2[0].split(",");
				if (0==args[3].trim()) {
					// Replace opacity 0 with white
					tmp2[0]='255,255,255';
				}
				else {
					tmp2[0]=args[0]+","+args[1]+","+args[2];
				}
				tmp[i] = tmp2.join(")");
			}
			svgNode.setAttribute('fill',tmp.join("rgb(")); 
		}
	}
}

/// Set the print parameters for reference when converting style information.
ClientMethod setPrintParameters(parms) [ Language = javascript ]
{
	// Method added by DTB405
	this.printParameters = parms;
}

/// Get the print parameters stored in this provider.
ClientMethod getPrintParameters() [ Language = javascript ]
{
	// Method added by DTB405
	return (this.printParameters) ? this.printParameters : null;
}

/// Output a text representation of a DOM subtree showing element nesting and basic
/// goemetry parameters starting from the given root node.  To dump the entire DOM
/// to the error console, pass this function document.body as the root.
ClientMethod dumpDOMTreeGeometry(root, svgGroup) [ Language = javascript ]
{
	// Method Added By DTB341 (adapted from ZLM)
	this.dumpDOMNodeGeometry(root,0,"",true,0,0,svgGroup);
}

/// Recursive function to dump the nesting structure and base geometry of a tree of DOM nodes
///   node: the root the of the current subtree
///   level: the currnet depth of recursion
///   stem: a string of 0s and 1s used to indicate the location of leaves in the tree already encountered
///   last: a boolean flag used to tell the current node whether or not it is the last child element of its parent
///   pst: parentScrollTop offset
///   psl: parentScrollLeft offset
ClientMethod dumpDOMNodeGeometry(node, level, stem, last, pst, psl, svgGroup) [ Language = javascript ]
{
	// Method Added By DTB341 (adapted from ZLM)
	var printStr='';
	var branchStr='';
	
	if (node.scrollTop!=0 || node.scrollLeft!=0) {
		//geoString+=" SCROLLED TO: "+node.scrollTop+"|"+node.scrollLeft;
		pst+=node.scrollTop;
		psl+=node.scrollLeft;
	}
	
	if (('TD'==node.nodeName)||('TH'==node.nodeName)){
		// This is a visible cell in the table. Convert the cell to an SVG rect.
		// Identify the html geometry and pass it to the svg node converter.
		var geometry = {};
		geometry.x = (node.offsetLeft-psl);
		geometry.y = (node.offsetTop-pst);
		geometry.width = (node.offsetWidth);
		geometry.height = (node.offsetHeight);
		var svgCell = this.convertHTMLCellToSVGRect(node, geometry);
		if (svgCell) {
			svgGroup.appendChild(svgCell);
		} 
	}
	
	var lastKid=null;
	for (var i=node.childNodes.length-1; i>=0;i--) {
		var n=node.childNodes[i];
		if (n.nodeType==1) {
			lastKid=n;
			i= -1;
		}
	}
	
	if (lastKid==null) {
		return;
	}
	
	if (last) {
		stem+='0';
	}
	else {
		stem+='1';
	}
	
	level++;
	

	if (ZLM.isPositionAnchor(node) || node.tagName=='TABLE') {
		pst-=node.offsetTop;
		psl-=node.offsetLeft;
	}

	// Descend into child nodes
	for (var i=0;i<node.childNodes.length;i++) {
		var n=node.childNodes[i];
		if ((n.nodeType==1)||(n.nodeType==3)) {
			this.dumpDOMNodeGeometry(n,level,stem,n==lastKid,pst,psl,svgGroup);
		}
	}
}

/// This method takes as input the filterNames and filterValues arrays that are commonly built 
/// for DeepSee widgets. The array is reshaped into a table that can be digested by
/// the fo conversion utilities.
ClientMethod prepareFilterTable(filterNames, filterValues, parms) [ Language = javascript ]
{
	var parms  = (parms) ? parms : {};
	var svgFilterTable = {};
	var printMode = (parms.SHOWFILTERS);	// DTB405
	
	
	// Default styles for the cells of the filter table
	var headerStyle = {fontWeight:"bold",
					fontSize:"8pt",
					padding:"2pt"};
	var cellOddStyle = {fontSize:"6pt",
					padding:"2pt"};
	var cellEvenStyle = {fontSize:"6pt",
					backgroundColor:"#E0E0E0",
					padding:"2pt"};
	var cellSpacerStyle = {padding:"2pt"};
	
	// +DTB405 - Apply the styling overrides from the print settings
	var filterTableCaptionStyle = (parms.FILTERTABLECAPTIONSTYLE) ? this.parseCssStyleString(parms.FILTERTABLECAPTIONSTYLE) : {};
	var filterTableItemStyle = (parms.FILTERTABLEITEMSTYLE) ? this.parseCssStyleString(parms.FILTERTABLEITEMSTYLE) : {};

	// Cell header styles
	if (filterTableCaptionStyle['color']) {
		headerStyle.color = filterTableCaptionStyle['color'];
	}
	if (filterTableCaptionStyle['background-color']) {
		headerStyle.backgroundColor = filterTableCaptionStyle['background-color'];
	}
	if (filterTableCaptionStyle['font-family']) {
		headerStyle.fontFamily = filterTableCaptionStyle['font-family'].trim();
	}
	if (filterTableCaptionStyle['font-size']) {
		headerStyle.fontSize = this.convertSizeToPoint(filterTableCaptionStyle['font-size']).value;
	}
	if (filterTableCaptionStyle['text-align']) {
		headerStyle.textAlign = filterTableCaptionStyle['text-align'].trim();
	}
	if (filterTableCaptionStyle['padding']) {
		headerStyle.padding = this.convertSizeToPoint(filterTableCaptionStyle['padding']).value;
	}
	if (filterTableCaptionStyle['font-style']) {
		headerStyle.fontStyle = filterTableCaptionStyle['font-style'].trim();
	}
	if (filterTableCaptionStyle['font-weight']) {
		headerStyle.fontWeight = filterTableCaptionStyle['font-weight'].trim();
	}
	if (filterTableCaptionStyle['text-decoration']) {
		headerStyle.textDecoration = filterTableCaptionStyle['text-decoration'];
	}
	
	
	// Cell item styles
	if (filterTableItemStyle['color']) {
		cellEvenStyle.color = filterTableItemStyle['color'];
		cellOddStyle.color = filterTableItemStyle['color'];
	}
	if (filterTableItemStyle['background-color']) {
		cellEvenStyle.backgroundColor = filterTableItemStyle['background-color'];
		cellOddStyle.backgroundColor = filterTableItemStyle['background-color'];
	}
	if (filterTableItemStyle['font-family']) {
		cellEvenStyle.fontFamily = filterTableItemStyle['font-family'].trim();
		cellOddStyle.fontFamily = filterTableItemStyle['font-family'].trim();
	}
	if (filterTableItemStyle['font-size']) {
		cellEvenStyle.fontSize = this.convertSizeToPoint(filterTableItemStyle['font-size']).value;
		cellOddStyle.fontSize = this.convertSizeToPoint(filterTableItemStyle['font-size']).value;
	}
	if (filterTableItemStyle['text-align']) {
		cellEvenStyle.textAlign = filterTableItemStyle['text-align'].trim();
		cellOddStyle.textAlign = filterTableItemStyle['text-align'].trim();
	}
	if (filterTableItemStyle['padding']) {
		cellEvenStyle.padding = this.convertSizeToPoint(filterTableItemStyle['padding']).value;
		cellOddStyle.padding = this.convertSizeToPoint(filterTableItemStyle['padding']).value;
	}
	if (filterTableItemStyle['font-style']) {
		cellEvenStyle.fontStyle = filterTableItemStyle['font-style'].trim();
		cellOddStyle.fontStyle = filterTableItemStyle['font-style'].trim();
	}
	if (filterTableItemStyle['font-weight']) {
		cellEvenStyle.fontWeight = filterTableItemStyle['font-weight'].trim();
		cellOddStyle.fontWeight = filterTableItemStyle['font-weight'].trim();
	}
	if (filterTableItemStyle['text-decoration']) {
		cellEvenStyle.textDecoration = filterTableItemStyle['text-decoration'];
		cellOddStyle.textDecoration = filterTableItemStyle['text-decoration'];
	}
	// -DTB405
	
	
	// Create the filter table
	if (filterNames.length) {
		if ('byTitle'==printMode) {
			// DTB377 - Add the byTitle option. No header in this case
			var svgFilterTable={
							header:[{caption:""}],
							rows:[]
						};
			for (f=0 ; f<filterNames.length ; f++) {
				svgFilterTable.rows[svgFilterTable.rows.length] = { 
							cells: [ 
								{ caption:filterNames[f]+' = '+filterValues[f],
									style:cellOddStyle}
							] 
						};
			} 
		}
		else if ('off'==printMode) {
			// DTB377 - Add the option to turn the filter display off
			var svgFilterTable={};
		}
		else {
			// Default is byTable printing
			var svgFilterTable={
							header: [
					   			{ caption:$$$Text("Filter"), 
					   				style:headerStyle 
					   			},
					   			{ caption:$$$Text("Value"), 
					   				style:headerStyle 
					   			}
					 		],
					 		rows:[]
					 	};
			for (f=0 ; f<filterNames.length ; f++) {
				svgFilterTable.rows[svgFilterTable.rows.length] = { 
							cells: [ 
								{ caption:filterNames[f],
									style: (f%2) ? cellOddStyle : cellEvenStyle}, 
								{ caption:filterValues[f],
									style: (f%2) ? cellOddStyle : cellEvenStyle} 
							] 
						};
			}
		}
	}
	
	return svgFilterTable;
}

/// This interprets the current page margin settings and returns the maximum
/// width available for the svg image. The value is returned in points.
ClientMethod calculateMaxImageWidth(metaDataJS) [ Language = javascript ]
{
	var permittedScaling = 1.25;
	var imageWidth = 0;
	var requestedImageWidth = 0;
	
	// DTB350 - See if an image width was passed in. This will limit the scaling up of the image
	// to a factor defined by permittedScaling.
	if (metaDataJS.imageWidth) {
		requestedImageWidth = this.convertSizeToPoint(metaDataJS.imageWidth);
	}
	
	var settings = this.reconcileDefaults(metaDataJS);
	
	// Normalize
	var pageWidth = this.convertSizeToPoint(settings.pageWidth);
	var marginLeft = this.convertSizeToPoint(settings.marginLeft);
	var marginRight = this.convertSizeToPoint(settings.marginRight);
	
	var calcImageWidth = (pageWidth.value - (marginLeft.value + marginRight.value));
	
	// DTB350 - Use the smaller of the two values, the user-defined width or the max-scaled image width
	if ((requestedImageWidth) && ((permittedScaling*requestedImageWidth.value) < calcImageWidth)) {
		imageWidth = permittedScaling*requestedImageWidth.value;
	}
	else {
		imageWidth = calcImageWidth;
	}

	return imageWidth + 'pt';
}

/// This interprets the current page margin settings and returns the maximum
/// width available for the svg image. The value is returned in points.
ClientMethod calculateMaxImageHeight(metaDataJS) [ Language = javascript ]
{
	var permittedScaling = 1.25;
	var imageHeight = 0;
	var requestedImageHeight = 0;
	
	// DTB350 - See if an image width was passed in. This will limit the scaling up of the image
	// to a factor defined by permittedScaling.
	if (metaDataJS.imageHeight) {
		requestedImageHeight = this.convertSizeToPoint(metaDataJS.imageHeight);
	}
	
	var settings = this.reconcileDefaults(metaDataJS);
	
	// Normalize
	var pageHeight = this.convertSizeToPoint(settings.pageHeight);
	var marginTop = this.convertSizeToPoint(settings.marginTop);
	var marginBottom = this.convertSizeToPoint(settings.marginBottom);
	
	var calcImageHeight = (pageHeight.value - (marginTop.value + marginBottom.value));
	
	// DTB350 - Use the smaller of the two values, the user-defined width or the max-scaled image height
	if ((requestedImageHeight) && ((permittedScaling*requestedImageHeight.value) < calcImageHeight)) {
		imageHeight = permittedScaling*requestedImageHeight.value;
	}
	else {
		imageHeight = calcImageHeight;
	}

	return imageHeight + 'pt';
}

/// Parse a size attribute into its value and units.
ClientMethod parseSize(size) [ Language = javascript ]
{
	sizeStr = size+'';		// DTB405 - Force string type for parsing
	var sizeParsed = {};
	sizeParsed.value = parseFloat(sizeStr);
	if (('0'==(''+sizeParsed.value)[0])&&('0'!=sizeStr[0])) {
		// DTB252 - Check to see if the parsing added a leading zero, eg: '.5in' parses to '0.5'
		sizeStr = '0' + sizeStr;
	}
	
	while (('0'==sizeStr[(''+sizeParsed.value).length])||('.'==sizeStr[(''+sizeParsed.value).length])) {
		// DTB367 - Check to see if the parser removed trailing zeros or the decimal point from the numeric part
		sizeParsed.value += sizeStr[(''+sizeParsed.value).length];
	}

	sizeParsed.units = sizeStr.substring((''+sizeParsed.value).length).trim();
	
	return sizeParsed;
}

/// Given a size attribute setting, convert it to points. The size is returned in an object:<br>
///   size.value<br>
///   size.units
ClientMethod convertSizeToPoint(sizeStr) [ Language = javascript ]
{
	var size = this.parseSize(sizeStr);
	
	if ('pt'==size.units) {
		// Nothing to do
	}
	else if ('in'==size.units) {
		// 1 in = 72 pt
		size.value = size.value*72;
		size.units = 'pt';
	}
	else if ('mm'==size.units) {
		// 0.352777778 millimeter = 1 point
		size.value = Math.round(size.value/0.352777778);
		size.units = 'pt';
	}
	else if ('px'==size.units) {
		// DTB407
		size.value = size.value*(72/this.getPPI());
		size.units = 'pt';
	}
	else if (''==size.units) {
		// Assume pt if no unit is indicated
		size.units = 'pt';
	}
	else {
		size.units = 'pt';
	}

	
	// Return a real value
	if (isNaN(size.value)) {
		size.value = 0;
		size.units = 'pt';
	}

	return size;
}

/// Parse a bare css style string into an object
ClientMethod parseCssStyleString(cssString) [ Language = javascript ]
{
	// Method added by DTB405
	var cssOBJ = {};
	var cssArray = cssString.split(';')
	
	for (n=0 ; n<cssArray.length-1 ; n++) {
		var cssDef = cssArray[n];
		var name = cssDef.split(':')[0];
		var value = cssDef.split(':')[1];
		cssOBJ[name] = value;
	}
	
	return cssOBJ;
}

/// Get the pixels per inch 
ClientMethod getPPI() [ Language = javascript ]
{
	// Method Added by DTB407
	// create an empty element
	var div = document.createElement("div");
	// give it an absolute size of one inch
	div.style.width="1in";
	var body = document.getElementsByTagName("body")[0];
	body.appendChild(div);
	// read the computed width
	var ppi = document.defaultView.getComputedStyle(div, null).getPropertyValue('width');
	// remove it
	body.removeChild(div);
	
	return parseFloat(ppi);
}

/// Do the work of performing the merge of two or more xsl files into a single file <var>pOutfile</var>.
/// All files must be located in the mgr/Temp directory.
/// The <var>pTargetFile</var> is the master file which will provide the page settings.
/// The argument <var>pSourceFiles</var> is a list of file names delimited by "||". The page
/// content of each of these files will be appended to the content of the <var>pTargetFile</var>
/// spearated by a page break.
ClassMethod MergeXSLFiles(pOutFile, pTargetFile, pSourceFiles, pSessionId = "") As %Status [ ZenMethod ]
{
	// Method added by DTB252
#define MergeGLVN ^CacheTemp.MergeXSLParse
#define XMLFileHeader "<?xml version=""1.0"" encoding=""utf-8"" ?>"

	Set tSC = $$$OK
	Set:(pSessionId="") tSessionId = "generatedID" _ $R(10000000)
	
	Set debug=0			// Switch on to write temp global contents to merged output file
	
	Try {
		// This must be clear before beginning. No two processes should be calling with 
		// the same session id
		Kill $$$MergeGLVN(tSessionId)
		
		Set tOutFile = ..ScopeFileName(pOutFile)
		Set tTargetFile = ..ScopeFileName(pTargetFile)
		
		For ii=1:1:$L(pSourceFiles,"||") {
			Set tSourceFiles(ii) = ..ScopeFileName($P(pSourceFiles,"||",ii))
		}
		
		// Load the target file contents into the target reader
		Set tSC = ##class(%XML.TextReader).ParseFile(tTargetFile,.tTargetReader,,,,,,$Name($$$MergeGLVN)_"("""_tSessionId_""",""target"")")
		If $$$ISERR(tSC) Quit
		
		// Locate the target's <fo:flow>
		If (tTargetReader.ReadStartElement("fo:flow")) {
			Set tTargetFlowStart = tTargetReader.seq
			Set tTargetFlowDepth = tTargetReader.DepthGet()
			
			Set tTargetContentStart = ""
			Set tTargetContentDepth = -1 
			
			// pivot and svg widgets print all content into a single <fo:block>
			If tTargetReader.ReadStartElement("fo:block") {
				Set tTargetContentStart = tTargetReader.seq	
				Set tTargetContentDepth = tTargetReader.DepthGet()
				Set tMergedPageStart($I(tMergedPageStart)) = tTargetContentStart
			}
			Else {
				// A target file with no content block cannot be used for a merge
				Set tSC = $$$ERROR($$$GeneralError,$$$FormatText("No content block located in target file %1",pTargetFile))
				Quit
			}
		}
		Else {
			// A target file with no flow block cannot be used for a merge
			Set tSC = $$$ERROR($$$GeneralError,$$$FormatText("No flow block located in target file %1",pTargetFile))
			Quit
		}
		
		// Use everything in the taget file up until the content as the header 
		// information for the merged file.
		For tTargetSeq=1:1:tTargetContentStart {
			Merge $$$MergeGLVN(tSessionId,"merged",1,tTargetSeq) = $$$MergeGLVN(tSessionId,"target",1,tTargetSeq)
		}
		
		// Continue merging until we return to the <flow> depth
		While tTargetReader.Read()&&(tTargetReader.DepthGet()>tTargetFlowDepth) {
			Set tTargetSeq = tTargetReader.seq
			Merge $$$MergeGLVN(tSessionId,"merged",1,tTargetSeq) = $$$MergeGLVN(tSessionId,"target",1,tTargetSeq)
			
			// Collect IDs of any elements
			If tTargetReader.HasAttributesGet() && tTargetReader.MoveToAttributeName("id") {
				Set tUsedIDs(tTargetReader.ValueGet()) = ""
			}
		}
		Set tTargetSeq = tTargetReader.seq
		Merge $$$MergeGLVN(tSessionId,"merged",1,tTargetSeq) = $$$MergeGLVN(tSessionId,"target",1,tTargetSeq)
		
		Set tTargetInsertPoint = tTargetSeq
		Set tMergeSeq = tTargetSeq
		
		Set tSourceFileIdx = $O(tSourceFiles(""),1,tSourceFileName)
		While tSourceFileIdx {
			Kill tSourceReader
			
			// Load tSourceFile into the source reader
			Set tSC = ##class(%XML.TextReader).ParseFile(tSourceFileName,.tSourceReader,,,,,,$Name($$$MergeGLVN)_"("""_tSessionId_""","""_tSourceFileIdx_""")")
			If $$$ISERR(tSC) Quit
			
			// Locate the source's <fo:flow>
			If (tSourceReader.ReadStartElement("fo:flow")) {
				Set tSourceFlowStart = tSourceReader.seq
				Set tSourceFlowDepth = tSourceReader.DepthGet()
				
				Set tSourceContentStart(tSourceFileIdx) = ""
				Set tSourceContentDepth(tSourceFileIdx) = -1 
				While (tSourceContentStart(tSourceFileIdx)="")&&tSourceReader.ReadStartElement("fo:block") {
					// Find the block which has the pageContent	
					Set tSourceContentStart(tSourceFileIdx) = tSourceReader.seq	
					Set tSourceContentDepth(tSourceFileIdx) = tSourceReader.DepthGet()
					
					Set tMergeSeq = tMergeSeq + 1
					Merge $$$MergeGLVN(tSessionId,"merged",1,tMergeSeq) = $$$MergeGLVN(tSessionId,tSourceFileIdx,1,tSourceReader.seq)
					Set tMergedPageStart($I(tMergedPageStart)) = tMergeSeq
 				
					If tSourceReader.HasAttributesGet() &&
						tSourceReader.MoveToAttributeName("id") &&
						(tSourceReader.ValueGet()="pageContent") {
						// Alter the merged content to avoid pageContent id conflicts
						Set $LI($$$MergeGLVN(tSessionId,"merged",1,tMergeSeq,1),5) = "pageContent"_tSourceFileIdx
					}	
				}
				
				Set tMakeNewId = 1		// DTB285
				// Continue merging until we return to the original pageContent
				While tSourceReader.Read()&&(tSourceReader.DepthGet()>tSourceFlowDepth) {
					Set tSourceSeq = tSourceReader.seq
					Set tMergeSeq = tMergeSeq + 1
					Merge $$$MergeGLVN(tSessionId,"merged",1,tMergeSeq) = $$$MergeGLVN(tSessionId,tSourceFileIdx,1,tSourceSeq)
					
					// Check for used IDs of any elements
					//  <svg:svg> blocks are assumed to be without conflicting IDs 
					//  and so are exempt from the id check
					// DTB285 - Some of these SVG definitions are nested within the svg:defs 
					// element and do not have the "svg:" prefix.
					If (tSourceReader.NodeTypeGet()="element")&&(tSourceReader.NameGet()="svg:defs") {
						Set tMakeNewId=0
					}
					If (tSourceReader.NodeTypeGet()="endelement")&&(tSourceReader.NameGet()="svg:defs") {
						Set tMakeNewId=1
					}
					
					If tSourceReader.HasAttributesGet() && 
						(tSourceReader.NameGet()'["svg") &&
						tSourceReader.MoveToAttributeName("id") &&
						tMakeNewId											// DTB285
						{
						If $D(tUsedIDs(tSourceReader.ValueGet())) {
							// Reset the current ID
							Set tNewID = tSourceReader.ValueGet()_tSourceFileIdx
							Set $LI($$$MergeGLVN(tSessionId,"merged",1,tMergeSeq,1),5) = tNewID
							Set tUsedIDs(tNewID) = ""
						}
						Else {
							Set tUsedIDs(tSourceReader.ValueGet()) = ""
						}
					}
				} 
				Set tMergeSeq = tMergeSeq + 1
				Merge $$$MergeGLVN(tSessionId,"merged",1,tMergeSeq) = $$$MergeGLVN(tSessionId,tSourceFileIdx,1,tSourceReader.seq)
			}
			Else {
				// A source file with no flow block is simply skipped in the merge, do nothing
			}
			
			Set tSourceFileIdx = $O(tSourceFiles(tSourceFileIdx),1,tSourceFileName)
		}
		
		// Complete the <flow> from the original target file
		While tTargetReader.Read() {
			Set tTargetSeq = tTargetReader.seq
			Set tMergeSeq = tMergeSeq + 1
			Merge $$$MergeGLVN(tSessionId,"merged",1,tMergeSeq) = $$$MergeGLVN(tSessionId,"target",1,tTargetSeq)
		}

		// Insert page breaks after the original page content
		For p=1:1:(tMergedPageStart-1) {
			Set tPageSeq = tMergedPageStart(p)
			Set tAttrCount = $LG($$$MergeGLVN(tSessionId,"merged",1,tPageSeq),5)
			Set tNewAttrSeq = tAttrCount + 1
			Set $$$MergeGLVN(tSessionId,"merged",1,tPageSeq,tNewAttrSeq) = $LB("","break-after","break-after","CDATA","page")
			Set $LI($$$MergeGLVN(tSessionId,"merged",1,tPageSeq),5) = tNewAttrSeq
		}
		
		
		
		// === Generate the new merged file from the global ===
		// open the merged file
		Set io = $io
		If (pOutFile'="") {
			Open pOutFile:"WNU":0 Else  Set tSC = $$$ERROR($$$GeneralError,$$$FormatText("Unable to open file %1",pOutFile)) Quit
			Use pOutFile
		}
		
		Kill tMappingNS
		Set tInContent = 0
		
		// Write out the xml header
		Write $$$XMLFileHeader
		
		// Write the merged global back into tOutFile.
		Set tSeqNo = $O($$$MergeGLVN(tSessionId,"merged",1,""),1,tSequence)
		While (tSeqNo'="") {
		 	// Build each line out of a sequence
		 	Set tLine = ""
		 	
		 	Set tNodeType = $LG(tSequence,1)
		 	If (tNodeType="startprefixmapping") {
			 	// Remember the xml namespace mappings
			 	Set tMappingNS(tSeqNo) = "xmlns" _ ":" _ $LG(tSequence,2) _ "=" _ $$$quote($LG(tSequence,3))
		 	}
		 	ElseIf (tNodeType="element") {
			 	// Begin an element tag
			 	If ($LG(tSequence,3)="root") {
				 	Set tInContent = 1
			 	}
			 	Set tLine = "<" _ $LG(tSequence,4)
			 	For a=1:1:$LG(tSequence,5) {
				 	// Write in attributes if any exist
				 	Set tSequence = $$$MergeGLVN(tSessionId,"merged",1,tSeqNo,a)
				 	Set tAttrName = $LG(tSequence,3)		// DTB346 - Read the 3rd list item as attribute name
				 	Set tAttrValue = $LG(tSequence,5)
				 	If $IsValidNum(tAttrValue) {
					 	// Numbers need to be manually quoted
					 	Set tLine = tLine _ " " _ tAttrName _ "=""" _ tAttrValue _ """"
				 	}
				 	Else {
				 		Set tLine = tLine _ " " _ tAttrName _ "=" _ $$$quote(tAttrValue)
				 	}
			 	}
			 	
			 	If ($LG(tSequence,3)="root") {
				 	// Write namespaces into the root element
				 	Set tMappingIdx = $O(tMappingNS(""),1,tMapping)
				 	While tMappingIdx'="" {
					 	Set tLine = tLine _ " " _ tMapping
					 	Set tMappingIdx = $O(tMappingNS(tMappingIdx),1,tMapping)
				 	}

			 	}
			 	
				Set tLine = tLine _ ">"		// Close the element tag
		 	}
		 	ElseIf (tNodeType="endelement") {
			 	// Write an end element
			 	Set tLine = "</" _ $LG(tSequence,4) _ ">"
		 	}
		 	ElseIf (tNodeType="chars") {
			 	// Write chracters
			 	Set tLine = $ZCVT($LG(tSequence,2),"O","XML")
		 	}
		 	ElseIf (tNodeType="endprefixmapping") {
			 	// Nothing to do in the file output
		 	}
		 	Else {
			 	// Report a node type that isn't handled
			 	Set tSC = $$$ERROR($$$GeneralError,$$$FormatText("Missing Node Type in file output: %1",tNodeType))
		 	}

			If (tLine'="") {
				// Actually write the line to the output file
				Write !,tLine
			}
			Set tSeqNo = $O($$$MergeGLVN(tSessionId,"merged",1,tSeqNo),1,tSequence)
		}

		If debug {
			// Dump some extra information to the output file for debugging purposes
			w !!
			zw $$$MergeGLVN(tSessionId)
			w !!
			zw tTargetContentStart,tSourceContentStart,tMergedPageStart
		}
		
		// Close the merged file
		If (pOutFile'="") {
			Use io
			Close pOutFile
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	// Keep the global in debug mode, otherwise clean it up
	If 'debug {
		Kill $$$MergeGLVN(tSessionId)
	}
	
	Quit tSC
}

}
