Class %ZEN.Mojo.WidgetReference.bootstrap33xBaseTemplate Extends %ZEN.Mojo.Component.contentTemplate
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
					{type:'$div',cssClass:'headerDiv navbar-fixed-top',children:[
						{type:'$content',cssClass:'header',content:'=[headerTitle]'}
					]},
					{type:'$div',cssClass:'mainDiv',children:[
						{type:'$h1',ovSize:'2',content:'=[referenceTitle]'},
						{type:'$text',content:'=[referenceDescription]'},
						{type:'$link',href:'=[linkAddress]',content:'=[link]',extra:{rel:'external'}},
						{type:'$listGroup',linked:'true',value:'=[widgets]',children:[
							{type:'$listGroupItem',linked:'true',label:'=[widgetname]',labelNoWrapper:false,content:'=[widgetOriginalName]',key:'show-widget',value:'=[widgetvalue]'}
						]}
					]}
				]
 			}; 
 		
 			break;
 	
 		default : 
  			
  			var data = zenPage.getContent('data',key,criteria);
  			
  			content = {
				sourceData:data,
				children:[
					{type:'$div',cssClass:'headerDiv navbar-fixed-top',children:[
						{type:'$button',content:'Back',theme:'primary',icon:'chevron-left',key:'back'},
						{type:'$text',cssClass:'header',content:'=[headercontent]'}
					]},
					
					{type:'$div',cssClass:'mainDiv',children:[
						{type:'$h1',ovSize:'2',content:'=[widgetname]'},
						{type:'$text',content:'=[description]'},
						{type:'$link',href:'=[linkAddress]',content:'=[link]',$extra:{rel:'external'}}
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
		  			docStaticCodeLayout =	{type:'$panel',children:[
		  										{type:'$panelHeading',role:'tab',id:'headingStaticCode',children:[
		  											{type:'$h1',ovSize:'4',cssClass:'panel-title',children:[
		  												{type:'$link',dataToggle:'collapse',dataParent:'#doc',href:'#staticCode',ariaExpanded:'true',ariaControls:'staticCode',content:'Zen Mojo Static Layout'}
		  											]}
		  										]},
		  										{type:'$div',id:'staticCode',cssClass:'panel-collapse collapse in',role:'tabpanel',ariaLabel:'headingStaticCode',children:[
		  											{type:'$panelBody',children:[
		  												{type:'$tableBody',children:[
		  													{type:'$tableRow',children:[
		  														{type:'$tableCell',cssClass:'gutter',children:docStaticCodeLineNumbers},
		  														{type:'$tableCell',children:docStaticCode}
		  														]}
		  												]}
		  											]}
		  										]}
											]};
	  			}
	  			var docStaticDataLayout = null;
	  			if (docStaticDataLineNumbers.length > 0) {
	  				docStaticDataLayout = 	{type:'$panel',children:[
		  										{type:'$panelHeading',role:'tab',id:'headingStaticData',children:[
		  											{type:'$h1',ovSize:'4',cssClass:'panel-title',children:[
		  												{type:'$link',dataToggle:'collapse',dataParent:'#doc',href:'#staticData',ariaExpanded:'true',ariaControls:'staticData',content:'Zen Mojo Static Data'}
		  											]}
		  										]}
	  										]};
	  			}
	  			var docDynamicCodeLayout = null;
	  			if (docDynamicCodeLineNumbers.length > 0) {
	  				docDynamicCodeLayout = 	{type:'$panel',children:[
		  										{type:'$panelHeading',role:'tab',id:'headingDynamicCode',children:[
		  											{type:'$h1',ovSize:'4',cssClass:'panel-title',children:[
		  												{type:'$link',dataToggle:'collapse',dataParent:'#doc',href:'#dynamicCode',ariaExpanded:'true',ariaControls:'staticCode',content:'Zen Mojo Dynamic Layout'}
		  											]}
		  										]},
		  										{type:'$div',id:'dynamicCode',cssClass:'panel-collapse collapse in',role:'tabpanel',ariaLabel:'headingDynamicCode',children:[
		  											{type:'$panelBody',children:[
		  												{type:'$tableBody',children:[
		  													{type:'$tableRow',children:[
		  														{type:'$tableCell',cssClass:'gutter',children:docDynamicCodeLineNumbers},
		  														{type:'$tableCell',children:docDynamicCode}
		  														]}
		  												]}
		  											]}
		  										]}
											]};
	  			}
	  			var docDynamicDataLayout = null;
	  			if (docDynamicDataLineNumbers.length > 0) {
		  			docDynamicDataLayout = 	{type:'$panel',children:[
		  										{type:'$panelHeading',role:'tab',id:'headingDynamicData',children:[
		  											{type:'$h1',ovSize:'4',cssClass:'panel-title',children:[
		  												{type:'$link',dataToggle:'collapse',dataParent:'#doc',href:'#dynamicData',ariaExpanded:'true',ariaControls:'dynamicData',content:'Zen Mojo Dynamic Data'}
		  											]}
		  										]}
	  										]};
	  			}
	  			var docCSSLayout = null;
	  			if (docCSSLineNumbers.length > 0) {
		  			var docCSSLayout = 	{type:'$panel',children:[
		  										{type:'$panelHeading',role:'tab',id:'headingCSS',children:[
		  											{type:'$h1',ovSize:'4',cssClass:'panel-title',children:[
		  												{type:'$link',dataToggle:'collapse',dataParent:'#doc',href:'#CSS',ariaExpanded:'true',ariaControls:'CSS',content:'CSS'}
		  											]}
		  										]},
		  										{type:'$div',id:'CSS',cssClass:'panel-collapse collapse in',role:'tabpanel',ariaLabel:'headingCSS',children:[
		  											{type:'$panelBody',children:[
		  												{type:'$tableBody',children:[
		  													{type:'$tableRow',children:[
		  														{type:'$tableCell',cssClass:'gutter',children:docCSSLineNumbers},
		  														{type:'$tableCell',children:docCSS}
		  														]}
		  												]}
		  											]}
		  										]}
											]};
	  			}
	  			var docZenMojoCodeLayout = null;
	  			if (docZenMojoCodeLineNumbers.length > 0) {
		  			var docZenMojoCodeLayout = 	{type:'$panel',children:[
		  										{type:'$panelHeading',role:'tab',id:'headingZenMojoCode',children:[
		  											{type:'$h1',ovSize:'4',cssClass:'panel-title',children:[
		  												{type:'$link',dataToggle:'collapse',dataParent:'#doc',href:'#ZenMojoCode',ariaExpanded:'true',ariaControls:'ZenMojoCode',content:'Zen Mojo Code'}
		  											]}
		  										]},
		  										{type:'$div',id:'ZenMojoCode',cssClass:'panel-collapse collapse in',role:'tabpanel',ariaLabel:'headingZenMojoCode',children:[
		  											{type:'$panelBody',children:[
		  												{type:'$tableBody',children:[
		  													{type:'$tableRow',children:[
		  														{type:'$tableCell',cssClass:'gutter',children:docZenMojoCodeLineNumbers},
		  														{type:'$tableCell',children:docZenMojoCode}
		  														]}
		  												]}
		  											]}
		  										]}
											]};
	  			}
	  			
	  			var docs = [];
	  			
	  			docs.push({type:'$div',cssClass:'panel-group',id:'doc',role:'tablist',ariaMultiSelect:'true',children:[]});
	  			if (docStaticCodeLayout) {
		  			docs[0].children.push(docStaticCodeLayout);
		  		}
		  		if (docStaticDataLayout) {
		  			docs[0].children.push(docStaticDataLayout);
		  		}
		  		if (docDynamicCodeLayout) {
		  			docs[0].children.push(docDynamicCodeLayout);
		  		}
		  		if (docDynamicDataLayout) {
		  			docs[0].children.push(docDynamicDataLayout);
		  		}
		  		if (docCSSLayout) {
		  			docs[0].children.push(docCSSLayout);
		  		}
		  		if (docZenMojoCodeLayout) {
			  		docs[0].children.push(docZenMojoCodeLayout);
		  		}								
				docs[0].expanded = true;
  				
  				var section =	{type:'$div',cssClass:'sampleSection',children:[
									{type:'$h1',ovSize:'2',content:sectionData.header},
									{type:'$content',content:sectionData.description},
									{type:'$div',cssClass:'sampleArea',children:[
										sampleCode
									]},
									{type:'$button',content:'View Source',size:'sm',icon:'chevron-up',dataToggle:'modal',dataTarget:'#myModal'+i},
									{type:'$modal',id:'myModal'+i,tabindex:'-1',size:'lg',role:'dialog',ariaLabel:'myModalLabel'+i,ariaHidden:'true',label:'View Source',children:docs}
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
	 			
	 		view.getPluginByName('bootstrap33xHelper').showModal(value);
	 	
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
