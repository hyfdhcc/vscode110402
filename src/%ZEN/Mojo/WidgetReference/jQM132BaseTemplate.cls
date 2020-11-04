Class %ZEN.Mojo.WidgetReference.jQM132BaseTemplate Extends %ZEN.Mojo.Component.contentTemplate
{

Parameter DOMAIN = "WidgetReference";

ClientMethod formatDocCode(pCode) [ Language = javascript ]
{
	var docCode = [];
	var indent = 0;
	var indentString = '';
	
	if (!pCode) {
		return docCode;
	}
	
	for (var i = 0; i < pCode.length;i++) {
		var line = pCode[i].line;
		if (line.charAt(0) == ']'){
  			indent--;
  			indentString = '';
  			for (var k = 0; k < indent; k++) {
	  			indentString = indentString + '&nbsp;&nbsp;&nbsp;&nbsp;';
  			}
		} else if (line.charAt(0) == '}'){
  			indent--;
  			indentString = '';
  			for (var k = 0; k < indent; k++) {
	  			indentString = indentString + '&nbsp;&nbsp;&nbsp;&nbsp;';
  			}
		}
		
		var docLine = line;
		var types = docLine.match(/\'\$\w*\'/g);
		if (types) {
			for (var j = 0; j < types.length; j++) {
  				docLine = docLine.replace(types[j],'\'</code><code class="layoutType">'+types[j].substring(1,types[j].length-1)+'</code><code>\'');
			}
		}
		var keys = docLine.match(/\w*[:]/g);
		if (keys) {
			for (var j = 0; j < keys.length; j++) {
  				docLine = docLine.replace(keys[j],'</code><code class="keyType">'+keys[j].substring(0,keys[j].length-1)+'</code><code>:');
			}
		}
		docCode.push({type:'$content',cssClass:'code',content:indentString+'<code>'+docLine+'</code>'});
		
		if (line.charAt(line.length-1) == '[') {
  			indent++;
  			indentString = indentString + '&nbsp;&nbsp;&nbsp;&nbsp;';
		} else if (line.charAt(line.length-1) == '{') {
  			indent++;
  			indentString = indentString + '&nbsp;&nbsp;&nbsp;&nbsp;';
		}
	}
	
	return docCode;
}

ClientMethod formatDocCSS(pCode) [ Language = javascript ]
{
	var docCSS = [];
	var indent = 0;
	var indentString = '';
	
	if (!pCode) {
		return docCSS;
	}
	
	for (var i = 0; i < pCode.length;i++) {
		var line = pCode[i].line;
		if (line.charAt(0) == '}'){
  			indent--;
  			indentString = '';
  			for (var k = 0; k < indent; k++) {
	  			indentString = indentString + '&nbsp;&nbsp;&nbsp;&nbsp;';
  			}
		}
		
		var docLine = line;
		docCSS.push({type:'$content',cssClass:'code',content:indentString+'<code>'+docLine+'</code>'});
		
		if (line.charAt(line.length-1) == '{') {
  			indent++;
  			indentString = indentString + '&nbsp;&nbsp;&nbsp;&nbsp;';
		}
	}
	
	return docCSS;
}

ClientMethod formatDocLineNumbers(pCode) [ Language = javascript ]
{
	var docLineNumbers = [];
	
	if (!pCode) {
		return docLineNumbers;
	}
	
	for (var i = 0; i < pCode.length;i++) {
		docLineNumbers.push({type:'$div',$content:i+1});
	}
	
	return docLineNumbers;
}

ClientMethod formatSampleCode(pCode, pData) [ Language = javascript ]
{
	var sampleCode = [];
	
	if (!pCode) {
		return sampleCode;
	}
	
	for (var i = 0; i < pCode.length;i++) {
		var line = pCode[i].line;
		// quote keys
		// don't quote after whitespace: .replace(/\s\b/g," '")
		//sampleCode.push(line.replace(/\b:/g,"':").replace(/\x7B\b/g,"{'").replace(/,\b/g,",'"));
		sampleCode.push(line);
	}
	
	// join the array, escape quotes correctly and then parse as JSON.
	var joined = sampleCode.join('');
	var a = joined.replace(/\b:/g,"':");
	a = a.replace(/\x7B\b/g,"{'");
	a = a.replace(/,\b/g,",'");
	//a = a.replace(/'\d/g,"");
	a = a.replace(/\'/g,'"');
  	sampleCode = JSON.parse(a);
	
	sampleCode = this.resolveExpressions(sampleCode,pData);
	
	return sampleCode;
}

ClientMethod resolveExpressions(sampleCode, pData) [ Language = javascript ]
{

	if (pData != null && pData != {}) {
		for (var attribute in sampleCode) {
			if (typeof sampleCode[attribute] == 'string' && sampleCode[attribute].charAt(0) == "=" && sampleCode[attribute].charAt(1) == "[" && sampleCode[attribute].charAt(sampleCode[attribute].length-1) == "]") {
				var path = sampleCode[attribute].split("[")[1].split("]")[0];
				sampleCode[attribute] = pData[path];
			} else if (attribute == 'children' && typeof sampleCode[attribute] === 'object') {
				for (var i = 0, length = sampleCode[attribute].length; i < length; i++) {
					sampleCode[attribute][i] = this.resolveExpressions(sampleCode[attribute][i],pData);
				}
			}
		}
	}
	
	return sampleCode;
}

/// Creates the layout object for the page
ClientMethod getLayout(key, criteria) [ Language = javascript ]
{
 	var content = null;
 	switch(key) { 
 	
 		case 'home':
 		
 			var data = zenPage.getContent('data',key,criteria);
  			
  			content = {
				sourceData:data,
				children:[
					{type:'$div',cssClass:'headerDiv',children:[
						{type:'$content',cssClass:'header',content:'=[headerTitle]'}
					]},
					{type:'$div',cssClass:'mainDiv',children:[
						{type:'$h2',$content:'=[referenceTitle]'},
						{type:'$p',$content:'=[referenceDescription]'},
						{type:'$a',href:'=[linkAddress]',$content:'=[link]',$extra:{rel:'external'}},
						{type:'$listview',inset:true,filter:true,filterplaceholder:'Search widgets',value:'=[widgets]',children:[
							{type:'$listviewitem',label:'=[widgetname]',labelNoWrapper:false,content:'=[widgetOriginalName]',clickable:true,key:'show-widget',value:'=[widgetvalue]'}
						]}
					]},
				]
 			}; 
 		
 			break;
 	
 		default : 
  			
  			var data = zenPage.getContent('data',key,criteria);
  			
  			content = {
				sourceData:data,
				children:[
					//{type:'$header',caption:'=[headercontent]',fixed:true,backtheme:'b',backshadow:false},
					{type:'$div',cssClass:'headerDiv',children:[
						{type:'$button',caption:'Back',mini:true,dataicon:'arrow-l',key:'back',inline:true,dataTheme:'b'},
						{type:'$content',cssClass:'header',content:'=[headercontent]'}
					]},
					
					{type:'$div',cssClass:'mainDiv',children:[
						{type:'$h1',$content:'=[widgetname]'},
						{type:'$p',$content:'=[description]'},
						{type:'$a',href:'=[linkAddress]',$content:'=[link]',$extra:{rel:'external'}}
					]},
				]
 			}; 
  			
  			for (var i = 0; i < data.sections.length; i++) {
  				
  				var sectionData = data.sections[i];
  				
	  			var sampleCode = this.formatSampleCode(sectionData.staticCode,{});
	  			var docStaticCodeLineNumbers = this.formatDocLineNumbers(sectionData.staticCode);
	  			var docStaticCode = this.formatDocCode(sectionData.staticCode);
	  			var docStaticDataLineNumbers = this.formatDocLineNumbers(sectionData.staticData);
	  			var docStaticData = this.formatDocCode(sectionData.staticData);
	  			
	  			if (!sectionData.staticCode) {
					sampleCode = this.formatSampleCode(sectionData.dynamicCode,this.formatSampleCode(sectionData.dynamicData));
				}
	  			var docDynamicCodeLineNumbers = this.formatDocLineNumbers(sectionData.dynamicCode);
	  			var docDynamicCode = this.formatDocCode(sectionData.dynamicCode);
	  			var docDynamicDataLineNumbers = this.formatDocLineNumbers(sectionData.dynamicData);
	  			var docDynamicData = this.formatDocCode(sectionData.dynamicData);
	  			
	  			var docCSSLineNumbers = this.formatDocLineNumbers(sectionData.css);
	  			var docCSS = this.formatDocCSS(sectionData.css);
	  			var docZenMojoCodeLineNumbers = this.formatDocLineNumbers(sectionData.zenMojoCode);
	  			var docZenMojoCode = this.formatDocCSS(sectionData.zenMojoCode);
	  			
	  			
	  			var docStaticCodeLayout = null;
	  			if (docStaticCodeLineNumbers.length > 0) {
		  			docStaticCodeLayout =	{type:'$collapsible',inset:false,dataTheme:'b',dataContentTheme:'a',label:'Zen Mojo Static Layout',children:[
		  										{type:'$table',children:[
		  											{type:'$tbody',children:[
		  												{type:'$tr',children:[
		  													{type:'$td',cssClass:'gutter',children:docStaticCodeLineNumbers},
		  													{type:'$td',children:docStaticCode}
		  												]}
		  											]}
		  										]}
											]};
	  			}
	  			var docStaticDataLayout = null;
	  			if (docStaticDataLineNumbers.length > 0) {
	  				docStaticDataLayout = 	{type:'$collapsible',inset:false,dataTheme:'b',dataContentTheme:'a',label:'Zen Mojo Static Data',children:[
	  										]};
	  			}
	  			var docDynamicCodeLayout = null;
	  			if (docDynamicCodeLineNumbers.length > 0) {
	  				docDynamicCodeLayout = 	{type:'$collapsible',inset:false,dataTheme:'b',dataContentTheme:'a',label:'Zen Mojo Dynamic Layout',children:[
		  										{type:'$table',children:[
		  											{type:'$tbody',children:[
		  												{type:'$tr',children:[
		  													{type:'$td',cssClass:'gutter',children:docDynamicCodeLineNumbers},
		  													{type:'$td',children:docDynamicCode}
		  												]}
		  											]}
		  										]}
	  										]};
	  			}
	  			var docDynamicDataLayout = null;
	  			if (docDynamicDataLineNumbers.length > 0) {
		  			docDynamicDataLayout = 	{type:'$collapsible',inset:false,dataTheme:'b',dataContentTheme:'a',label:'Zen Mojo Dynamic Data',children:[
												{type:'$table',children:[
	  												{type:'$tbody',children:[
	  													{type:'$tr',children:[
	  														{type:'$td',cssClass:'gutter',children:docDynamicDataLineNumbers},
	  														{type:'$td',children:docDynamicData}
	  													]}
	  												]}
	  											]}
	  										]};
	  			}
	  			var docCSSLayout = null;
	  			if (docCSSLineNumbers.length > 0) {
		  			var docCSSLayout = 	{type:'$collapsible',inset:false,dataTheme:'b',dataContentTheme:'a',label:'CSS',children:[
											{type:'$table',children:[
  												{type:'$tbody',children:[
  													{type:'$tr',children:[
  														{type:'$td',cssClass:'gutter',children:docCSSLineNumbers},
  														{type:'$td',children:docCSS}
  													]}
  												]}
  											]}
										]};
	  			}
	  			var docZenMojoCodeLayout = null;
	  			if (docZenMojoCodeLineNumbers.length > 0) {
		  			var docZenMojoCodeLayout = 	{type:'$collapsible',inset:false,dataTheme:'b',dataContentTheme:'a',label:'Zen Mojo Code',children:[
													{type:'$table',children:[
  														{type:'$tbody',children:[
  															{type:'$tr',children:[
  																{type:'$td',cssClass:'gutter',children:docZenMojoCodeLineNumbers},
  																{type:'$td',children:docZenMojoCode}
  															]}
  														]}
  													]}
												]};
	  			}
	  			
	  			var docs = [];
	  			
	  			if (docStaticCodeLayout) {
		  			docs.push(docStaticCodeLayout);
		  		}
		  		if (docStaticDataLayout) {
		  			docs.push(docStaticDataLayout);
		  		}
		  		if (docDynamicCodeLayout) {
		  			docs.push(docDynamicCodeLayout);
		  		}
		  		if (docDynamicDataLayout) {
		  			docs.push(docDynamicDataLayout);
		  		}
		  		if (docCSSLayout) {
		  			docs.push(docCSSLayout);
		  		}
		  		if (docZenMojoCodeLayout) {
			  		docs.push(docZenMojoCodeLayout);
		  		}						
							
				docs[0].expanded = true;
  				
  				var section =	{type:'$div',cssClass:'sampleSection',children:[
									{type:'$h2',$content:sectionData.header},
									{type:'$content',content:sectionData.description},
									{type:'$div',cssClass:'sampleArea',children:[
										sampleCode
									]},
									{type:'$button',key:'show-source',value:'sample-'+i,caption:'View Source',mini:true,dataicon:'arrow-u',inline:true},
									{type:'$popup',key:'sample-'+i,children:docs}
								]};
  				
  				content.children[1].children.push(section);
  			}
  			
			break;
 	} 

 	return content;
}

/// Client-side content provider method.
/// <var>which</var> is the name of the content to return. 
/// <var>key</var> is the key value associated with the request.
/// <var>criteria</var> is the search criteria associated with the request.
ClientMethod onGetContent(which, key, criteria) [ Language = javascript ]
{
 	switch (which)
 	{ 
 		case 'layout': 
  			return this.getLayout(key,criteria);
  		case 'data':
  			return this.getData(key,criteria);
 	} 

 	// return null -> fetch data from server
 	return null;
}

ClientMethod onselect(key, value, docViewId) [ Language = javascript ]
{
 	var view = zen(docViewId);
 	var realKey = key.split(':')[0];
 	switch(realKey) {
	 	case 'show-source':
	 	
	 		view.getPluginByName('jQM-1.3.2-Helper').showPopup(value);
	 	
	 		break;
	 	
	 	case 'show-widget':
	 	
	 		view.pushDocument(value,{},value,{});
	 	
	 		break;
	 		
	 	case 'back':
	 	
	 		view.popDocument();
	 	
	 		break;
 	}
}

ClientMethod addBoldTag(text) [ Language = javascript ]
{
	return "<b>"+text+"</b>";
}

}
