Class %ZEN.Mojo.WidgetReference.bootstrap33xTemplate Extends %ZEN.Mojo.WidgetReference.bootstrap33xBaseTemplate
{

Parameter DOMAIN = "WidgetReference";

ClientMethod onselect(key, value, docViewId) [ Language = javascript ]
{
	this.invokeSuper('onselect',arguments);
	
	console.log('select '+key);
 	var view = zen(docViewId);
 	var realKey = key.split(':')[0];
 	switch(realKey) {
	 	
	 	case 'show-modal':
	 	
	 		view.getPluginByName('bootstrap33xHelper').showModal(value);
	 		
	 		break;
	 		
	 	case 'show-modal-origin':
	 		currentControl = view.getItemByKey(key);
	 		view.getPluginByName('bootstrap33xHelper').showModal(value,{positionTo:"#"+currentControl.$makeId('control')});
	 		
	 		break;
	 		
	 	case 'show-modal-onobject':
	 		targetPopup = view.getItemByKey(value);
	 		targetObject = view.getItemByKey(targetPopup.value);
	 		view.getPluginByName('bootstrap33xHelper').showModal(value,{positionTo:"#"+targetObject.$makeId()});
	 		
	 		break;
 	}
}

ClientMethod getData(key, criteria) [ Language = javascript ]
{
	
	var data = {};

	switch (key) {
	
		case 'home':
		
			data = {
				headerTitle:'Zen Mojo Widget Reference',
				referenceTitle:'Twitter Bootstrap Widget Reference',
				referenceDescription:'Test drive a handful of components in the library, and easily build pages by copying and pasting the markup configuration you need. ',
				linkAddress:'http://getbootstrap.com/components/',
				link:'bootstrap documentation',
				widgets:[
					{widgetname:'$alerts',widgetOriginalName:'Alerts',widgetvalue:'alerts'},
					{widgetname:'$badges',widgetOriginalName:'Badges',widgetvalue:'badges'},
					{widgetname:'$breadcrumbs',widgetOriginalName:'Breadcrumbs',widgetvalue:'breadcrumbs'},
					{widgetname:'$button',widgetOriginalName:'Buttons',widgetvalue:'buttons'},
					{widgetname:'$buttonGroup & $buttonToolbar',widgetOriginalName:'Button Groups',widgetvalue:'buttonGroups'},
					{widgetname:'Button Dropdowns',widgetOriginalName:'Button Dropdowns',widgetvalue:'buttonDropdowns'},
					{widgetname:'$container & $containerFluid',widgetOriginalName:'Containers',widgetvalue:'containers'},
					{widgetname:'$dropdown & $dropdownMenuItem',widgetOriginalName:'Dropdowns',widgetvalue:'dropdowns'},
					{widgetname:'$form & $formGroup',widgetOriginalName:'Forms',widgetvalue:'forms'},
					{widgetname:'$glyphicon',widgetOriginalName:'Glyphicons',widgetvalue:'glyphicons'},
					{widgetname:'$gridSystem & $gridColumn',widgetOriginalName:'Grid System',widgetvalue:'gridSystems'},
					{widgetname:'$h1',widgetOriginalName:'Headings',widgetvalue:'headings'},
					{widgetname:'$image',widgetOriginalName:'Images',widgetvalue:'images'},
					{widgetname:'$input',widgetOriginalName:'Input',widgetvalue:'inputs'},
					{widgetname:'$inputGroup & $inputGroupAddon',widgetOriginalName:'Input Groups',widgetvalue:'inputGroups'},
					{widgetname:'$jumbotron',widgetOriginalName:'Jumbotron',widgetvalue:'jumbotron'},
					{widgetname:'$label',widgetOriginalName:'Labels',widgetvalue:'labels'},
					{widgetname:'$li, $ul & $ol',widgetOriginalName:'Lists',widgetvalue:'lists'},
					{widgetname:'$listGroup & $listGroupItem',widgetOriginalName:'List Group',widgetvalue:'listGroup'},
					{widgetname:'$mediaObject',widgetOriginalName:'Media Object',widgetvalue:'mediaObject'},
					{widgetname:'$nav',widgetOriginalName:'Navs',widgetvalue:'navs'},
					{widgetname:'$navbar',widgetOriginalName:'Navbar',widgetvalue:'navbar'},
					{widgetname:'$pageHeader',widgetOriginalName:'Page Header',widgetvalue:'pageHeader'},
					{widgetname:'$pagination & $pager',widgetOriginalName:'Pagination',widgetvalue:'pagination'},
					{widgetname:'$panel, $panelBody, $panelHeading & $panelFooter',widgetOriginalName:'Panels',widgetvalue:'panels'},	
					{widgetname:'$progressBar',widgetOriginalName:'Progress Bars',widgetvalue:'progressBars'},	
					{widgetname:'$responsiveEmbed',widgetOriginalName:'Responsive embed',widgetvalue:'responsiveEmbed'},
					{widgetname:'$table, $tableBody, $tableHeader, $tableFooter, $tableRow, $tableColumn & $tableCell',widgetOriginalName:'Tables',widgetvalue:'tables'},
					{widgetname:'$text',widgetOriginalName:'Paragraphs',widgetvalue:'paragraphs'},
					{widgetname:'$thumbnails',widgetOriginalName:'Thumbnails',widgetvalue:'thumbnails'},
					{widgetname:'$wells',widgetOriginalName:'Wells',widgetvalue:'wells'},
				]};
			break;
			
		case 'glyphicons':
			data = this.getDataGlyphicons();
			break;
		
		case 'dropdowns':
			data = this.getDataDropdowns();
			break;
			
		case 'buttons':
			data = this.getDataButtons();
			break;
		
		case 'buttonGroups':
			data = this.getDataButtonGroups();
			break;
		
		case 'buttonDropdowns':
			data = this.getDataButtonDropdowns();
			break;
		
		case 'inputGroups':
			data = this.getDataInputGroups();
			break;
		
		case 'navs':
			data = this.getDataNavs();
			break;
		
		case 'navbar':
			data = this.getDataNavbar();
			break;
		
		case 'breadcrumbs':
			data = this.getDataBreadcrumbs();
			break;
		
		case 'pagination':
			data = this.getDataPagination();
			break;
			
		case 'labels':
			data = this.getDataLabels();
			break;
		
		case 'badges':
			data = this.getDataBadges();
			break;
		
		case 'jumbotron':
			data = this.getDataJumbotron();
			break;
		
		case 'pageHeader':
			data = this.getDataPageHeader();
			break;
		
		case 'thumbnails':
			data = this.getDataThumbnails();
			break;
		
		case 'alerts':
			data = this.getDataAlerts();
			break;
		
		case 'progressBars':
			data = this.getDataProgressBars();
			break;
			
		case 'mediaObject':
			data = this.getDataMediaObject();
			break;
		
		case 'listGroup':
			data = this.getDataListGroup();
			break;
		
		case 'panels':
			data = this.getDataPanels();
			break;
			
		case 'responsiveEmbed':
			data = this.getDataResponsiveEmbed();
			break;
		
		case 'wells':
			data = this.getDataWells();
			break;
			
		case 'containers':
			data = this.getDataContainers();
			break;
			
		case 'gridSystems':
			data = this.getDataGridSystems();
			break;
			
		case 'headings':
			data = this.getDataHeadings();
			break;
			
		case 'paragraphs':
			data = this.getDataParagraphs();
			break;
			
		case 'lists':
			data = this.getDataLists();
			break;
			
		case 'tables':
			data = this.getDataTables();
			break;
			
		case 'forms':
			data = this.getDataForms();
			break;
			
		case 'inputs':
			data = this.getDataInputs();
			break;
			
		case 'images':
			data = this.getDataImages();
			break;
	}
	return data;
}

ClientMethod getDataEmptyTemplate() [ Language = javascript ]
{
	var data = {
		widgetname:'Empty Template',
		description:'Description of this widget.',
		headercontent:'Empty Template Header',
		linkAddress:'http://getbootstrap.com/components/',
		link:'Twitter Bootstrap Documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : '',
			description : '',
			
			staticCode:[
				{line:"{type:'$container',children:["},
				
				{line:"]}"}
			],
			dynamicCode:[
				{line:"Only staticCode is format checked."}
			],
			dynamicData:[
				{line:"Only staticCode is format checked."}
			],
			css:[
				{line:"Only staticCode is format checked."}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataGlyphicons() [ Language = javascript ]
{
	var data = {
		widgetname:'$glyphicon',
		headercontent:'Glyphicons',
		linkAddress:'http://getbootstrap.com/components/#glyphicons',
		link:'Twitter Bootstrap Glyphicons Documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Available glyphs',
			description : 'Includes over 250 glyphs in font format from the Glyphicon Halflings set. <a href="http://glyphicons.com/">Glyphicons</a> Halflings are normally'
				  + ' not available for free, but their creator has made them available for Bootstrap free of cost.',
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',key:'icon3',icon:'asterisk'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'plus'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'euro'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'eur'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'minus'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'cloud'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'envelope'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'pencil'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'glass'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'music'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'search'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'heart'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'star'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'star-empty'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'user'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'film'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'th-large'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'th'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'th-list'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'ok'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'remove'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'zoom-in'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'zoom-out'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'off'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'signal'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'cog'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'trash'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'home'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'file'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'time'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'road'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'download-alt'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'download'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'upload'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'inbox'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'play-circle'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'repeat'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'refresh'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'list-alt'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'lock'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'flag'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'headphones'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'volume-off'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'volume-down'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'volume-up'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'qrcode'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'barcode'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'tag'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'tags'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'book'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'bookmark'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'print'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'camera'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'font'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'bold'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'italic'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'text-height'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'text-width'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'align-left'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'align-center'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'align-right'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'align-justify'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'list'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'indent-left'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'indent-right'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'facetime-video'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'picture'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'map-marker'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'adjust'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'tint'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'edit'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'share'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'check'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'move'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'step-backward'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'fast-backward'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'backward'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'play'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'pause'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'stop'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'forward'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'fast-forward'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'step-forward'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'eject'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'chevron-left'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'chevron-right'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'plus-sign'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'minus-sign'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'remove-sign'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'ok-sign'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'question-sign'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'info-sign'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'screenshot'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'remove-circle'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'ok-circle'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'ban-circle'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'arrow-left'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'arrow-right'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'arrow-up'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'arrow-down'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'share-alt'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'resize-full'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'resize-small'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'exclamation-sign'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'gift'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'leaf'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'fire'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'eye-open'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'eye-close'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'warning-sign'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'plane'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'calendar'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'random'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'comment'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'magnet'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'chevron-up'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'chevron-down'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'retweet'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'shopping-cart'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'folder-close'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'folder-open'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'resize-vertical'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'resize-horizontal'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'hdd'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'bullhorn'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'bell'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'certificate'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'thumbs-up'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'thumbs-down'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'hand-right'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'hand-left'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'hand-up'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'hand-down'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'circle-arrow-right'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'circle-arrow-left'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'circle-arrow-up'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'circle-arrow-down'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'globe'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'wrench'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'tasks'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'filter'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'briefcase'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'fullscreen'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'dashboard'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'paperclip'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'heart-empty'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'link'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'phone'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'pushpin'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'usd'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'gbp'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sort'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sort-by-alphabet'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sort-by-alphabet-alt'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sort-by-order'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sort-by-order-alt'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sort-by-attributes'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sort-by-attributes-alt'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'unchecked'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'expand'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'collapse-down'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'collapse-up'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'log-in'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'flash'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'log-out'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'new-window'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'record'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'save'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'open'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'saved'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'import'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'export'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'send'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'floppy-disk'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'floppy-saved'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'floppy-remove'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'floppy-save'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'floppy-open'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'credit-card'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'transfer'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'cutlery'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'header'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'compressed'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'earphone'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'phone-alt'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'tower'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'stats'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sd-video'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'hd-video'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'subtitles'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sound-stereo'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sound-dolby'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sound-5-1'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sound-6-1'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sound-7-1'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'copyright-mark'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'registration-mark'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'cloud-download'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'cloud-upload'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'tree-conifer'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'tree-deciduous'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'cd'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'save-file'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'open-file'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'level-up'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'copy'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'paste'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'alert'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'equalizer'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'king'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'queen'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'pawn'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'bishop'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'knight'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'baby-formula'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'tent'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'blackboard'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'bed'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'apple'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'erase'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'hourglass'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'lamp'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'duplicate'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'piggy-bank'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'scissors'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'bitcoin'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'btc'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'xbt'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'yen'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'jpy'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'ruble'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'rub'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'scale'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'ice-lolly'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'ice-lolly-tasted'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'education'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'option-horizontal'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'option-vertical'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'menu-hamburger'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'modal-window'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'oil'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'grain'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'sunglasses'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'text-size'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'text-color'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'text-background'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'object-align-top'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'object-align-bottom'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'object-align-horizontal'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'object-align-left'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'object-align-vertical'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'object-align-right'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'triangle-right'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'triangle-left'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'triangle-bottom'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'triangle-top'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$ul',cssClass:'glyphicons',children:["},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'console'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'superscript'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'subscript'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'menu-left'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'menu-right'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'menu-down'}"},
				{line:"]},"},
				{line:"{type:'$li',children:["},
				{line:"{type:'$glyphicon',icon:'menu-up'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'How to use',
			description : 'To use, just set the <code>icon</code> attibute of <code>$glyphicon</code> to an icon listed above.'
						+ ' Be sure to leave a space between the icon and text for proper padding.',
			staticCode:[
				{line:"{type:'$glyphicon',icon:'search'}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Glyphicon in buttons',
			description : 'Add an <code>icon</code> attribute to <code>$button</code>, and use <code>$buttonGroup</code> or <code>$buttonToolbar</code> '
						+ 'for a toolbar, navigation, or prepended form inputs.',
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$buttonToolbar',children:["},
				{line:"{type:'$buttonGroup',children:["},
				{line:"{type:'$button',id:'button2',icon:'align-left',ariaLabel:'Left Align'},"},
				{line:"{type:'$button',icon:'align-center',ariaLabel:'Center Align'},"},
				{line:"{type:'$button',icon:'align-right',ariaLabel:'Right Align'},"},
				{line:"{type:'$button',icon:'align-justify',ariaLabel:'Justify'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$buttonToolbar',children:["},
				{line:"{type:'$button',icon:'star',size:'lg',content:' Star'},"},
				{line:"{type:'$button',icon:'star',content:' Star'},"},
				{line:"{type:'$button',icon:'star',size:'sm',content:' Star'},"},
				{line:"{type:'$button',icon:'star',size:'xs',content:' Star'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Glyphicon in alerts',
			description : 'An icon can also be used in an <code>$alert</code>.',
			staticCode:[
				{line:"{type:'$alert',theme:'danger',icon:'exclamation-sign',content:' Enter a valid email address'}"},
			]
		},
	];
	
	return data;
}

ClientMethod getDataDropdowns() [ Language = javascript ]
{
	var data = {
		widgetname:'$dropdown & $dropdownMenuItem',
		description:'Toggleable, contextual menu for displaying lists of links.',
		headercontent:'Dropdowns',
		linkAddress:'http://getbootstrap.com/components/#dropdowns',
		link:'Twitter Bootstrap Dropdowns Documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Example',
			description : 'Change <code>content</code> to customize the content of dropdown button and use'
						+ ' <code>$dropdownMenuItem</code> for menu item. Dropdown menu can be changed to expand '
						+ 'upwards (instead of downwards) by setting <code>dropup</code> attribute to be true',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$dropdown',key:'dropdown1',children:["},
				{line:"{type:'$dropdownMenuItem',id:'dmItem1',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'}"},			
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$dropdown',dropup:true,content:'Dropup ',id:'dropdown2',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'}"},			
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Alignment',
			description : 'By default, a dropdown menu is automatically positioned 100% from the top and along the left side'
						+ ' of its parent. Set <code>right</code> to be <code>true</code> to right align the dropdown menu.',
			
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$dropdown',right:true,id:'dropdown3',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'}"},			
				{line:"]}"},
				{line:"]}"},
			]
		},
		{
			/* --- --- */
			header : 'Header',
			description : 'Add a header to label sections of actions in any dropdown menu by setting '
						+ '<code>header</code> to be <code>true</code> of a <code>$dropdownMenuItem</code>.',
			staticCode:[
				{line:"{type:'$dropdown',id:'dropdown4',children:["},
				{line:"{type:'$dropdownMenuItem',header:true,id:'dmItem2',content:'Dropdown header'},"},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',header:true,content:'Dropdown header'},"},
				{line:"{type:'$dropdownMenuItem',content:'Separated link'}"},			
				{line:"]}"},
			]
		},
		{
			/* --- --- */
			header : 'Divider',
			description : 'Add a divider to separate series of links in a dropdown menu by setting <code>divider</code>'
						+ ' to be <code>true</code> of a <code>$dropdownMenuItem</code>(No <code>content</code> needed).',
			staticCode:[
				{line:"{type:'$dropdown',id:'dropdown4',children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'Separated link'}"},			
				{line:"]}"},
			]
		},
		{
			/* --- --- */
			header : 'Disabled menu items',
			description : 'Set <code>disabled</code> to be <code>true</code> of a <code>$dropdownMenuItem</code> to '
						+ 'disable the link.',
			staticCode:[
				{line:"{type:'$dropdown',id:'dropdown4',children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Regular Link'},"},
				{line:"{type:'$dropdownMenuItem',disabled:true,content:'Disabled Link'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another Link'}"},			
				{line:"]}"},
			]
		},
	];
	
	return data;
}

ClientMethod getDataButtons() [ Language = javascript ]
{
	var data = {
		widgetname:'$button',
		headercontent:'Buttons',
		linkAddress:'http://getbootstrap.com/css/#buttons',
		link:'Twitter Bootstrap Buttons Documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Button tags',
			description : 'Build button by using <code>$button</code> (with the option of '
						+ '<code>asLink</code> which would be rendered as an anchor element'
						+ ' in HTML5) or <code>$input</code>(with a <code>inputType'
						+ '</code> of <code>button</code> or <code>submit</code>).',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$button',asLink:true,content:'Link'},"},
				{line:"{type:'$button',key:'btn3',content:'Button'},"},
				{line:"{type:'$input',key:'btn2',inputType:'button',value:'Input'},"},
				{line:"{type:'$input',inputType:'submit',value:'Submit'}"},			
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Options',
			description : 'Use any of the available <code>theme</code>s to quickly create a styled <code>button</code>.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$button',content:'Default'},"},
				{line:"{type:'$button',theme:'primary',content:'Primary'},"},
				{line:"{type:'$button',theme:'success',content:'Success'},"},
				{line:"{type:'$button',theme:'info',content:'Info'},"},
				{line:"{type:'$button',theme:'warning',content:'Warning'},"},
				{line:"{type:'$button',theme:'danger',content:'Danger'},"},
				{line:"{type:'$button',theme:'link',content:'Link'}"},		
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Sizes',
			description : 'Fancy larger or smaller buttons? Set <code>size</code> to be <code>lg</code>, <code>'
						+ 'sm</code> or <code>xs</code> for additional sizes.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$text',children:["},
				{line:"{type:'$button',size:'lg',theme:'primary',content:'Large button'},"},
				{line:"{type:'$button',size:'lg',content:'Large button'}"},			
				{line:"]},"},
				{line:"{type:'$text',children:["},
				{line:"{type:'$button',theme:'primary',content:'Default button'},"},
				{line:"{type:'$button',content:'Default button'}"},			
				{line:"]},"},
				{line:"{type:'$text',children:["},
				{line:"{type:'$button',size:'sm',theme:'primary',content:'Small button'},"},
				{line:"{type:'$button',size:'sm',content:'Small button'}"},			
				{line:"]},"},
				{line:"{type:'$text',children:["},
				{line:"{type:'$button',size:'xs',theme:'primary',content:'Extra small button'},"},
				{line:"{type:'$button',size:'xs',content:'Extra small button'}"},		
				{line:"]}"},		
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			description : 'Create block level buttons-those that span the full width of a parent- '
						+ 'by setting <code>blocklevel</code> to be <code>true</code>.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$button',size:'lg',theme:'primary',blocklevel:true,content:'Block level button'},"},
				{line:"{type:'$button',size:'lg',blocklevel:true,content:'Block level button'}"},			
				{line:"]}"},
			]
		},
		{
			/* --- --- */
			header : 'Active state',
			description : 'Buttons will appear pressed (with a darker background, darker border, and inset shadow) when active.'
						+ '  Just set <code>active</code> to be <code>true</code>.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$button',size:'lg',theme:'primary',active:true,content:'Block level button'},"},
				{line:"{type:'$button',size:'lg',active:true,content:'Block level button'}"},			
				{line:"]}"},
			]
		},
		{
			/* --- --- */
			header : 'Disabled state',
			description : 'Set <code>disabled</code> to be <code>true</code> to make buttons look '
						+ 'unclickable by fading them back with opacity.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$button',size:'lg',theme:'primary',disabled:true,content:'Block level button'},"},
				{line:"{type:'$button',size:'lg',disabled:true,content:'Block level button'}"},			
				{line:"]}"},
			]
		}
	];
	
	return data;
}

ClientMethod getDataButtonGroups() [ Language = javascript ]
{
	var data = {
		widgetname:'$buttonGroup & $buttonToolbar',
		description:'Group a series of buttons together on a single line with the button group.',
		headercontent:'Button groups',
		linkAddress:'http://getbootstrap.com/components/#btn-groups',
		link:'Twitter Bootstrap Button groups Documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Basic example',
			description : 'Wrap a series of <code>$button</code> in <code>$buttonGroup</code>',
			staticCode:[
				{line:"{type:'$buttonGroup',children:["},
				{line:"{type:'$button',content:'Left'},"},
				{line:"{type:'$button',content:'Middle'},"},
				{line:"{type:'$button',content:'Right'}"},			
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Button toolbar',
			description : 'Combine sets of <code>$buttonGroup</code> into a <code>$buttonToolbar</code> for more complex components.',
			
			staticCode:[
				{line:"{type:'$buttonToolbar',key:'btnTool',children:["},
				{line:"{type:'$buttonGroup',key:'btnGrp',children:["},
				{line:"{type:'$button',content:'1'},"},
				{line:"{type:'$button',content:'2'},"},
				{line:"{type:'$button',content:'3'},"},
				{line:"{type:'$button',content:'4'}"},			
				{line:"]},"},
				{line:"{type:'$buttonGroup',children:["},
				{line:"{type:'$button',content:'5'},"},
				{line:"{type:'$button',content:'6'},"},
				{line:"{type:'$button',content:'7'}"},			
				{line:"]},"},
				{line:"{type:'$buttonGroup',children:["},
				{line:"{type:'$button',content:'8'}"},			
				{line:"]}"},		
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Sizing',
			description : 'Instead of applying <code>size</code> for every <code>$button</code> in a group, just set '
						+ '<code>size</code> of the <code>$buttonGroup</code>, including when nesting multiple groups.',
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$buttonGroup',size:'lg',children:["},
				{line:"{type:'$button',content:'Left'},"},
				{line:"{type:'$button',content:'Middle'},"},
				{line:"{type:'$button',content:'Right'}"},			
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$buttonGroup',children:["},
				{line:"{type:'$button',content:'Left'},"},
				{line:"{type:'$button',content:'Middle'},"},
				{line:"{type:'$button',content:'Right'}"},			
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$buttonGroup',size:'sm',children:["},
				{line:"{type:'$button',content:'Left'},"},
				{line:"{type:'$button',content:'Middle'},"},
				{line:"{type:'$button',content:'Right'}"},			
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$buttonGroup',size:'xs',children:["},
				{line:"{type:'$button',content:'Left'},"},
				{line:"{type:'$button',content:'Middle'},"},
				{line:"{type:'$button',content:'Right'}"},			
				{line:"]}"},		
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Nesting',
			description : 'Set <code>buttonGroup</code> to be <code>true</code> of a <code>$dropdown</code> widget and place it'
						+ ' within a <code>$buttonGroup</code> when you want dropdown menus mixed with a series of buttons.',
			staticCode:[
				{line:"{type:'$buttonGroup',children:["},
				{line:"{type:'$button',content:'1'},"},
				{line:"{type:'$button',content:'2'},"},
				{line:"{type:'$dropdown',buttonGroup:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Dropdown Link'},"},
				{line:"{type:'$dropdownMenuItem',content:'Dropdown Link'}"},			
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Vertical variation',
			description : 'Make a set of buttons appear vertically stacked rather than horizontally by setting '
						+ '<code>vertical</code> to be <code>true</code>. <strong class="text-danger">Split button '
						+ 'dropdowns are not supported here.</strong>',
			staticCode:[
				{line:"{type:'$buttonGroup',vertical:true,children:["},
				{line:"{type:'$button'},"},
				{line:"{type:'$button'},"},
				{line:"{type:'$dropdown',buttonGroup:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Dropdown Link'},"},
				{line:"{type:'$dropdownMenuItem',content:'Dropdown Link'}"},			
				{line:"]},"},
				{line:"{type:'$button'},"},
				{line:"{type:'$button'},"},
				{line:"{type:'$dropdown',buttonGroup:true,children:["},		
				{line:"{type:'$dropdownMenuItem',id:'drop1',content:'Dropdown Link'},"},
				{line:"{type:'$dropdownMenuItem',content:'Dropdown Link'}"},			
				{line:"]},"},
				{line:"{type:'$dropdown',buttonGroup:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Dropdown Link'},"},
				{line:"{type:'$dropdownMenuItem',content:'Dropdown Link'}"},			
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Justified button groups with buttons as <code>$link</code> elements',
			description : '<p>Make a group of buttons stretch at equal sizes to span the entire width of its parent by '
						+ 'setting <code>justified</code> to be <code>true</code>. </p><p>Also works with button <code>'
						+ '$dropdown</code> (make sure <code>buttonGroup</code> is set to be <code>true</code>) within <code>'
						+ '$buttonGroup</code>.</p><p>Set<code>asLink</code> to be <code>true</code> for both <code>'
						+ '$button</code> and <code>$dropdown</code> to create button with <code>$link</code> element.</p>',
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$buttonGroup',justified:true,ariaLabel:'justified button group',children:["},
				{line:"{type:'$button',asLink:true,content:'Left'},"},
				{line:"{type:'$button',asLink:true,content:'Middle'},"},
				{line:"{type:'$button',asLink:true,content:'Right'}"},		
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$buttonGroup',justified:true,ariaLabel:'justified button group with nested dropdown',children:["},
				{line:"{type:'$button',asLink:true,content:'Left'},"},
				{line:"{type:'$button',asLink:true,content:'Middle'},"},
				{line:"{type:'$dropdown',id:'dropdown4',asLink:true,buttonGroup:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'Separated link'}"},			
				{line:"]}"},		
				{line:"]}"},
				{line:"]}"},
			]
		},
		{
			/* --- --- */
			header : 'Justified button groups with buttons as <code>$button</code> elements',
			description : 'To use justified button groups with <code>$button</code> elements, <strong class='
						+ '"text-danger">you must wrap each button in a <code>$buttonGroup</code></strong>.',
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$buttonGroup',id:'btnGroup1',justified:true,ariaLabel:'justified button group',children:["},
				{line:"{type:'$buttonGroup',children:["},
				{line:"{type:'$button',content:'Left'}"},
				{line:"]},"},
				{line:"{type:'$buttonGroup',children:["},
				{line:"{type:'$button',content:'Middle'}"},
				{line:"]},"},
				{line:"{type:'$buttonGroup',children:["},
				{line:"{type:'$button',content:'Right'}"},		
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		}
	];
	
	return data;
}

ClientMethod getDataButtonDropdowns() [ Language = javascript ]
{
	var data = {
		widgetname:'Button Dropdowns',
		description:'Use any button to trigger a dropdown menu by setting <code>buttonGroup</code> to be <code>true</code> for a <code>$dropdown</code>.',
		headercontent:'Button Dropdowns',
		linkAddress:'http://getbootstrap.com/components/#btn-dropdowns',
		link:'Twitter Bootstrap Button Dropdowns documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Single button dropdowns',	
			description : 'Set <code>buttonGroup</code> to be <code>true</code> for <code>$dropdown</code> to use a customized button as dropdown toggle.',
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$dropdown',key:'drop2',buttonGroup:true,content:'Default ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',theme:'primary',buttonGroup:true,content:'Primary ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',theme:'success',buttonGroup:true,content:'Success ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',theme:'info',buttonGroup:true,content:'Info ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',theme:'warning',buttonGroup:true,content:'Warning ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',theme:'danger',buttonGroup:true,content:'Danger ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Split button dropdowns',	
			description : 'Create split button dropdowns by setting <code>separated</code> to be '
						+ '<code>true</code> for <code>$dropdown</code>.',
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$dropdown',buttonGroup:true,content:'Default ',separated:true,children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',theme:'primary',buttonGroup:true,content:'Primary ',separated:true,children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',theme:'success',buttonGroup:true,content:'Success ',separated:true,children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',theme:'info',buttonGroup:true,content:'Info ',separated:true,children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',theme:'warning',buttonGroup:true,content:'Warning ',separated:true,children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',theme:'danger',buttonGroup:true,content:'Danger ',separated:true,children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Sizing',	
			description : 'Button dropdowns work with buttons of all sizes. Just apply <code>size</code> to <code>$dropdown</code>.',
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$dropdown',size:'lg',buttonGroup:true,content:'Large button ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',buttonGroup:true,content:'Default button ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',size:'sm',buttonGroup:true,content:'Small button ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',size:'xs',buttonGroup:true,content:'Extra small button ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Dropup variation',	
			description : 'Trigger dropdown menus above elements by setting <code>dropup</code> to be <code>true</code> of the <code>$dropdown</code>.',
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$dropdown',dropup:true,buttonGroup:true,separated:true,content:'Dropup ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]},"},
				{line:"{type:'$dropdown',dropup:true,theme:'primary',right:true,buttonGroup:true,separated:true,content:'Right dropup ',children:["},
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'A separated link'}"},
				{line:"]}"},
				{line:"]}"}
			]
		}
	]
	return data;
}

ClientMethod getDataInputGroups() [ Language = javascript ]
{
	var data = {
		widgetname:'$inputGroup & $inputGroupAddon',
		description:'Extend form controls by adding text or buttons before, after, or on both sides of any text-based '
				  + 'input. Use <code>$inputGroup</code> with an <code>$inputGroupAddon</code> to prepend or append '
				  + 'elements to a single <code>$input</code>',
		headercontent:'Input groups',
		linkAddress:'http://getbootstrap.com/components/#input-groups',
		link:'Twitter Bootstrap Input Groups documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Basic Example',
			description : '<p>Place one add-on or button on either side of an input. You may also place one on both '
						+ 'sides of an input.</p><p><strong class="text-danger">Bootstrap does not support multiple '
						+ 'add-ons on a single side.</strong></p><p><strong class="text-danger">Bootstrap does not '
						+ 'support multiple form-controls in a single input group.</strong></p>',
			
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$inputGroupAddon',content:'@',key:'basic-addon1'},"},
				{line:"{type:'$input',placeholder:'Username',ariaDescribe:'basic-addon1'}"},
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$input',placeholder:'Recipient username',ariaDescribe:'basic-addon2'},"},
				{line:"{type:'$inputGroupAddon',content:'@example.com',key:'basic-addon2'}"},
				{line:"]},"},	
				{line:"{type:'$break'},"},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$inputGroupAddon',content:'$'},"},
				{line:"{type:'$input',ariaLabel:'Amount (to the nearest dollar)'},"},
				{line:"{type:'$inputGroupAddon',content:'.00'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Sizing',
			description : 'Setting the <code>size</code> attribute of the <code>$inputGroup</code> itself and contents'
						+ ' within will automatically resize-no need for repeating the form control size classes on'
						+ ' each element.',
			
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$inputGroup',size:'lg',children:["},
				{line:"{type:'$inputGroupAddon',content:'@',key:'sizing-addon1'},"},
				{line:"{type:'$input',placeholder:'Username',ariaDescribe:'sizing-addon1'}"},
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$inputGroupAddon',content:'@',key:'sizing-addon2'},"},
				{line:"{type:'$input',placeholder:'Username',ariaDescribe:'sizing-addon2'}"},
				{line:"]},"},	
				{line:"{type:'$break'},"},
				{line:"{type:'$inputGroup',size:'sm',children:["},
				{line:"{type:'$inputGroupAddon',content:'@',key:'sizing-addon3'},"},
				{line:"{type:'$input',placeholder:'Username',ariaDescribe:'sizing-addon3'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Checkboxes and radio addons',
			description : 'Place any checkbox or radio option within the <code>children</code> of an <code>$inputGroupAddon</code> instead of <code>content</code>.',	
			staticCode:[
				{line:"{type:'$gridSystem',children:["},
				{line:"{type:'$gridColumn',lg:'6',children:["},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$inputGroupAddon',children:["},
				{line:"{type:'$input',inputType:'checkbox'}"},
				{line:"]},"},
				{line:"{type:'$input'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',lg:'6',children:["},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$inputGroupAddon',children:["},
				{line:"{type:'$input',inputType:'radio'}"},
				{line:"]},"},
				{line:"{type:'$input'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Button addons',
			description : 'Buttons in input groups are a bit different. Instead of using the <code>$inputGroupAddon</code> widget, you will need to set the '
						+ '<code>asButton</code> of <code>$inputGroup</code> to be <code>true</code> to wrap the buttons. This is required due to default '
						+ 'browser styles that cannot be overridden.',	
			staticCode:[
				{line:"{type:'$gridSystem',children:["},
				{line:"{type:'$gridColumn',lg:'6',children:["},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$inputGroup',asButton:true,children:["},
				{line:"{type:'$button',content:'Go!'}"},
				{line:"]},"},
				{line:"{type:'$input'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',lg:'6',children:["},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$input'},"},
				{line:"{type:'$inputGroup',asButton:true,children:["},
				{line:"{type:'$button',content:'Go!'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Buttons with dropdowns',	
			description : 'Instead of using the <code>$inputGroupAddon</code> widget, you will need to set the '
						+ '<code>inputGroup</code> of <code>$dropdown</code> to be <code>true</code> for buttons '
						+ 'with dropdowns.',	
			staticCode:[
				{line:"{type:'$gridSystem',children:["},
				{line:"{type:'$gridColumn',lg:'6',children:["},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$dropdown',content:'Action ',inputGroup:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'Separated link'}"},			
				{line:"]},"},
				{line:"{type:'$input'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',lg:'6',children:["},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$input'},"},
				{line:"{type:'$dropdown',content:'Action ',inputGroup:true,right:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'Separated link'}"},			
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Segmented buttons',	
			staticCode:[
				{line:"{type:'$gridSystem',children:["},
				{line:"{type:'$gridColumn',lg:'6',children:["},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$dropdown',content:'Action ',separated:true,inputGroup:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'Separated link'}"},			
				{line:"]},"},
				{line:"{type:'$input'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',lg:'6',children:["},
				{line:"{type:'$inputGroup',children:["},
				{line:"{type:'$input'},"},
				{line:"{type:'$dropdown',content:'Action ',separated:true,right:true,inputGroup:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'Separated link'}"},			
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
	];
	
	return data;
}

ClientMethod getDataNavs() [ Language = javascript ]
{
	var data = {
		widgetname:'$nav',
		description:'Navs available in Bootstrap have shared markup, starting with the base <code>$nav</code> widget, as well as shared states. Swap modifier '
				  + 'classes to switch between each style.',
		headercontent:'Navs',
		linkAddress:'http://getbootstrap.com/components/#nav',
		link:'Twitter Bootstrap Navsdocumentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Tabs',
			description : 'Set <code>navType</code> to <code>tabs</code>, and use <code>$link</code> with a <code>true</code> value of its <code>listed</code> attribute',
			
			staticCode:[
				{line:"{type:'$nav',navType:'tabs',children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Profile'},"},
				{line:"{type:'$link',listed:true,content:'Messages'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Pills',
			description : 'Take the same structure, but use <code>navType</code> for <code>pills</code> instead:',
			
			staticCode:[
				{line:"{type:'$nav',key:'nav1',navType:'pills',children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Profile'},"},
				{line:"{type:'$link',listed:true,content:'Messages'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			description : 'Pills are also vertically stackable. Just set <code>stacked</code> to be <code>true</code>.',
			
			staticCode:[
				{line:"{type:'$nav',navType:'pills',stacked:true,children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Profile'},"},
				{line:"{type:'$link',listed:true,content:'Messages'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Justified nav',
			description : 'Set <code>justified</code> to be <code>true</code>',
			
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$nav',navType:'tabs',justified:true,children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Profile'},"},
				{line:"{type:'$link',listed:true,content:'Messages'}"},
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$nav',navType:'pills',justified:true,children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Profile'},"},
				{line:"{type:'$link',listed:true,content:'Messages'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Disabled Links',
			description : 'For any nav component (tabs or pills), set <code>disabled</code> of the <code>$link</code> widget to be <code>true</code> for <strong>gray '
						+ 'links and no hover effects.</strong>',
			
			staticCode:[
				{line:"{type:'$nav',navType:'pills',children:["},
				{line:"{type:'$link',listed:true,content:'Clickable link'},"},
				{line:"{type:'$link',listed:true,content:'Clickable link'},"},
				{line:"{type:'$link',listed:true,disabled:true,content:'Disabled link'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Tabs with dropdowns',
			description : 'Set <code>listed</code> and <code>asLink</code> of <code>$dropdown</code> to be <code>true</code> to add dropdown menus',
			staticCode:[
				{line:"{type:'$nav',navType:'tabs',children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Help'},"},
				{line:"{type:'$dropdown',listed:true,asLink:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'Separated link'}"},			
				{line:"]}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Pills with dropdowns',
			staticCode:[
				{line:"{type:'$nav',navType:'pills',children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Help'},"},
				{line:"{type:'$dropdown',listed:true,asLink:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'Separated link'}"},			
				{line:"]}"},
				{line:"]}"},
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataNavbar() [ Language = javascript ]
{
	var data = {
		widgetname:'$navbar',
		headercontent:'Navbar',
		linkAddress:'http://getbootstrap.com/components/#navbar',
		link:'Twitter Bootstrap Navbar documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Default navbar',
			description : '<p>Navbars are responsive meta components that serve as navigation headers for your application '
						+ 'or site. They begin collapsed (and are toggleable) in mobile views and become horizontal as the '
						+ 'available viewport width increases.</p><p>Use <code>brand</code> for your brand name and <code>'
						+ 'brandTarget</code> for a link to your homepage.</p><p><strong class="text-danger">Justified navbar'
						+ ' nav links are currently not supported.</strong></p>',
			staticCode:[
				{line:"{type:'$navbar',key:'navbar-collapse',brand:'Brand',children:["},
				{line:"{type:'$nav',cssClass:'navbar-nav',children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Link',children:["},
				{line:"{type:'$span',cssClass:'sr-only',content:'(Current)'}"},
				{line:"]},"},
				{line:"{type:'$link',listed:true,content:'Link'},"},
				{line:"{type:'$dropdown',listed:true,asLink:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'Separated link'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'One more separated link'}"},			
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$navbarForm',role:'search',children:["},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',placeholder:'Search'}"},
				{line:"]},"},
				{line:"{type:'$button',buttonType:'submit',content:'Submit'}"},
				{line:"]},"},
				{line:"{type:'$nav',cssClass:'navbar-nav navbar-right',children:["},
				{line:"{type:'$link',listed:true,content:'Link'},"},
				{line:"{type:'$dropdown',listed:true,asLink:true,children:["},		
				{line:"{type:'$dropdownMenuItem',content:'Action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Another action'},"},
				{line:"{type:'$dropdownMenuItem',content:'Something else here'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'Separated link'},"},
				{line:"{type:'$dropdownMenuItem',divider:true},"},
				{line:"{type:'$dropdownMenuItem',content:'One more separated link'}"},			
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			header : 'Brand image',
			description : '<p>Replace the navbar brand with your own image by swapping the text for an <code>brandImage</code>, '
						+ 'and you <strong class="text-danger">must</strong> set <code>brand</code> as an alternate text. Here'
						+ 'you also have an option to disable the collapse attribute of navbar when there is no content within it'
						+ 'by setting <code>collapseDisabled</code> to be <code>true</code>.</p><p>Since the navbar brand has '
						+ 'its own padding and height, you may need to override some CSS depending on your image.</p>',
			staticCode:[
				{line:"{type:'$navbar',id:'navbar-non-collapse',collapseDisabled:true,brand:'Brand',brandImage:'zenmojo_images/logo.gif'}"},
			],
			css:[
				{line:".navbar-brand>img{"},
				{line:"margin-top:-25px;"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Forms',
			description : '<p>Place form content within <code>$navbarForm</code> for proper vertical alignment and '
						+ 'collapsed behavior in narrow viewports. Use the <code>alignment</code> options to decide where '
						+ 'it resides within the navbar content.</p><p>As a heads up, <code>$navbarForm</code> shares much '
						+ 'of its code with <code>$form</code> whose <code>inline</code> set to be <code>true</code> '
						+ 'via mixin. Some form controls, like <code>$inputGroup</code>, may require fixed widths to be '
						+ 'show up properly within a navbar.</p>',
			staticCode:[
				{line:"{type:'$navbar',id:'navbar-collapse2',brand:'Brand',children:["},
				{line:"{type:'$navbarForm',role:'search',children:["},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',placeholder:'Search'}"},
				{line:"]},"},
				{line:"{type:'$button',buttonType:'submit',content:'Submit'}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			header : 'Buttons',
			description : 'Add the <code>.navbar-btn</code> cssClass of <code>$button</code> elements not residing in a '
						+ '<code>$navbarForm</code> to vertically center them in the navbar.',
			staticCode:[
				{line:"{type:'$navbar',id:'navbar-collapse3',brand:'Brand',children:["},
				{line:"{type:'$nav',cssClass:'navbar-nav',children:["},
				{line:"{type:'$button',cssClass:'navbar-btn',content:'Sign in'}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
		
		{
			/* --- --- */
			header : 'Text',
			description : 'Wrap strings of text in an element with <code>navbar-text</code> cssClass, usually as a <code>$text</code> for proper leading and color.',
			staticCode:[
				{line:"{type:'$navbar',navClass:'navbar-default',containerClass:'container-fluid',id:'navbar-collapse4',brand:'Brand',children:["},
				{line:"{type:'$nav',cssClass:'navbar-nav',children:["},
				{line:"{type:'$text',cssClass:'navbar-text',content:'Signed in as Mark Otto'}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			header : 'Non-nav links and Component alignment',
			description : '<p>For folks using standard links that are not within the regular navbar navigation component, '
						+ 'use <code>$link</code> with the <code>.navbar-link</code> cssClass to add the proper colors for '
					 	+ 'the default and inverse navbar options.<p><p>To right align <code>$link</code>s, <code>$navForm'
					 	+ '</code>s, <code>$button</code>s, or <code>$text</code>s in <code>$nav</code>, setting its <code>'
					 	+ 'right</code> to be <code>true</code>. Both classes will add a CSS float in the specified '
						+ 'direction(left by default). </p><p>These classes are mixin-ed versions of <code>.pull-left'
						+ '</code> and <code>.pull-right</code>, but they are scoped to media queries for easier handling '
					    + 'of navbar components across device sizes.',
			staticCode:[
				{line:"{type:'$navbar',navClass:'navbar-default',containerClass:'container-fluid',id:'navbar-collapse5',brand:'Brand',children:["},
				{line:"{type:'$nav',cssClass:'navbar-nav',right:true,children:["},
				{line:"{type:'$text',cssClass:'navbar-text',content:'Signed in as ',children:["},
				{line:"{type:'$link',href:'#',cssClass:'navbar-link',content:'Mark Otto'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			header : 'Fixed to top',
			description : '<p>Set <code>position</code> to <code>fixed-top</code> and include a <code>.container</code> or '
						+ '<code>.containerFluid</code> containerClass to center and pad navbar content.</p><p>The fixed '
						+ 'navbar will overlay your other content, unless you add <code>padding</code> to the top of the '
						+ '<code>body</code>. Try out your own values or use our snippet below. Tip: By default, the '
						+ 'navbar is 50px high.</p><p>Make sure to include this after the core Bootstrap CSS.</p>',
			staticCode:[
				{line:"{type:'$navbar',navClass:'navbar-default',position:'fixed-top',containerClass:'container',id:'navbar-collapse6',brand:'Brand',children:["},
				{line:"{type:'$nav',cssClass:'navbar-nav',children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Profile'},"},
				{line:"{type:'$link',listed:true,content:'Messages'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:"body { padding-top: 70px; }"}
			]
		},
		
		{
			/* --- --- */
			header : 'Fixed to bottom',
			description : '<p>Set <code>position</code> to <code>fixed-bottom</code> navClass and include a <code>'
						+ '.container</code> or <code>.containerFluid</code> containerClass to center and pad navbar '
						+ 'content.</p><p>The fixed navbar will overlay your other content, unless you add <code>padding'
						+ '</code> to the bottom of the <code>body</code>. Try out your own values or use our snippet '
						+ 'below. Tip: By default, the navbar is 50px high.</p><p>Make sure to include this after the '
						+ 'core Bootstrap CSS.</p>',
			staticCode:[
				{line:"{type:'$navbar',navClass:'navbar-default',position:'fixed-bottom',containerClass:'container',id:'navbar-collapse7',brand:'Brand',children:["},
				{line:"{type:'$nav',cssClass:'navbar-nav',children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Profile'},"},
				{line:"{type:'$link',listed:true,content:'Messages'}"},
				{line:"]}"},
				{line:"]}"}
			],
			css:[
				{line:"body { padding-bottom: 70px; }"}
			]
		},
		
		
		{
			/* --- --- */
			header : 'Static top',
			description : '<p>Create a full-width navbar that scrolls away with the page by Setting <code>position</code> '
						+ 'to <code>static-top</code> and use <code>container</code> or <code>containerFluid</code> as its '
						+ '<code>containerClass</code> to center and pad navbar content.</p><p>Unlike the <code>$navbar</code>'
						+ ' whose <code>position</code> is <code>navbar-fixed-*</code>, you do not need to change any padding'
						+ ' on the <code>body</code>.</p>',
			staticCode:[
				{line:"{type:'$navbar',navClass:'navbar-default',position:'static-top',containerClass:'container',id:'navbar-collapse8',brand:'Brand',children:["},
				{line:"{type:'$nav',cssClass:'navbar-nav',children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Profile'},"},
				{line:"{type:'$link',listed:true,content:'Messages'}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			header : 'Inverted navbar',
			description : 'Modify the look of the navbar by setting <code>inverse</code> to be <code>true</code>',
			staticCode:[
				{line:"{type:'$navbar',inverse:true,id:'navbar-collapse9',brand:'Brand',children:["},
				{line:"{type:'$nav',cssClass:'navbar-nav',children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Profile'},"},
				{line:"{type:'$link',listed:true,content:'Messages'}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
	];
	
	return data;
}

ClientMethod getDataBreadcrumbs() [ Language = javascript ]
{
	var data = {
		widgetname:'$breadcrumb',
		headercontent:'Breadcrumbs',
		description:'Indicate the location of current page within a navigational hierarchy.',
		linkAddress:'http://getbootstrap.com/components/#breadcrumbs',
		link:'Twitter Bootstrap Breadcrumbs documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			description : 'Separators are automatically added in CSS through <code>:before</code> and <code>content</code>.',
			staticCode:[
				{line:"{type:'$breadcrumb',children:["},
				{line:"{type:'$li',id:'li1',active:true,content:'Home'}"},
				{line:"]}"}
			],
		},
		
		
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$breadcrumb',children:["},
				{line:"{type:'$link',listed:true,content:'Home'},"},
				{line:"{type:'$li',active:true,content:'Library'}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$breadcrumb',children:["},
				{line:"{type:'$link',listed:true,content:'Home'},"},
				{line:"{type:'$link',listed:true,content:'Library'},"},
				{line:"{type:'$li',active:true,content:'Data'}"},
				{line:"]}"}
			],
		}
		
		
	];
	
	return data;
}

ClientMethod getDataPagination() [ Language = javascript ]
{
	var data = {
		widgetname:'$pagination & $pager',
		headercontent:'Pagination',
		description:'Provide pagination links for your site or app with the multi-page pagination component, or the '
				  + 'simpler <code>$pager</code> alternative.',
		linkAddress:'http://getbootstrap.com/components/#pagination',
		link:'Twitter Bootstrap Pagination documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Default pagination',
			description : 'Simple pagination inspired by Rdio, great for apps and search results. The large block is hard'
						+ ' to miss, easily scalable, and provides large click areas.',
			staticCode:[
				{line:"{type:'$pagination',key:'pagin1',hrefPref:'#',hrefNext:'#',children:["},
				{line:"{type:'$link',href:'#',listed:true,content:'1'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'2'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'3'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'4'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'5'}"},
				{line:"]}"}
			],
		},
			
		{
			/* --- --- */
			header : 'Disabled and active states',
			description : 'Links are customizable for different circumstances. Use <code>disabled</code> for the page number'
						+ 'with unclickable link and <code>active</code> to indicate the current page.',
			staticCode:[
				{line:"{type:'$pagination',disabledPref:true,hrefPref:'#',hrefNext:'#',children:["},
				{line:"{type:'$link',active:true,href:'#',listed:true,content:'1'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'2'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'3'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'4'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'5'}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			header : 'Sizing',
			description : 'Fancy larger or smaller pagination? Apply <code>size</code> for additional sizes.',
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$pagination',hrefPref:'#',hrefNext:'#',size:'lg',children:["},
				{line:"{type:'$link',href:'#',listed:true,content:'1'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'2'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'3'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'4'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'5'}"},
				{line:"]},"},
				{line:"{type:'$pagination',hrefPref:'#',hrefNext:'#',children:["},
				{line:"{type:'$link',href:'#',listed:true,content:'1'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'2'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'3'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'4'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'5'}"},
				{line:"]},"},
				{line:"{type:'$pagination',hrefPref:'#',hrefNext:'#',size:'sm',children:["},
				{line:"{type:'$link',href:'#',listed:true,content:'1'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'2'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'3'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'4'},"},
				{line:"{type:'$link',href:'#',listed:true,content:'5'}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			header : 'Pager',
			description : '<p>Quick previous and next links for simple pagination implementations with light '
						+ 'markup and styles by using <code>$pager</code>. It is great for simple sites like'
						+ ' blogs or magazines.</p><p>By default, the pager centers links, whose targets could'
						+ ' be modified by setting <code>hrefPrev</code> and <code>hrefNext</code> separately.',
			staticCode:[
				{line:"{type:'$pager',key:'pager1',hrefPref:'#',hrefNext:'#'}"}
			],
		},
		{
			/* --- --- */
			header : 'Pager with aligned links',
			description : 'Alternatively, you can align each link to the sides by setting <code>aligned</code> '
						+ 'to be <code>true</code>.  Button contents could be customized by setting <code>'
						+ 'contentPrev</code> and <code>contentNext</code> separately.  There is also an option '
						+ 'to include arrows besides them by setting <code>arrow</code> to be <code>true</code>',
			staticCode:[
				{line:"{type:'$pager',hrefPref:'#',hrefNext:'#',aligned:true,contentPrev:'Older',contentNext:'Newer',arrow:true}"}
			],
		},
		{
			/* --- --- */
			header : 'Pager with optional disabled state',
			description : 'Pager links can also be disabled by setting <code>disabledPrev</code> or <code>'
						+ 'disabledNext</code> to be <code>true</code> for your own purpose.',
			staticCode:[
				{line:"{type:'$pager',hrefPref:'#',hrefNext:'#',aligned:true,contentPrev:'Older',contentNext:'Newer',arrow:true,disabledPrev:true}"}
			],
		},
	];
	
	return data;
}

ClientMethod getDataLabels() [ Language = javascript ]
{
	var data = {
		widgetname:'$label',
		headercontent:'Labels',
		linkAddress:'http://getbootstrap.com/components/#labels',
		link:'Twitter Bootstrap Labels documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Example',
			description : 'Use <code>$label</code> as a child of other elements, or set the <code>label</code> '
						+ 'attribute of an <code>$h1</code> element directly',	
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$h1',content:'Example heading ',children:["},
				{line:"{type:'$label',content:'New '}"},
				{line:"]},"},
				{line:"{type:'$h1',ovSize:'2',content:'Example heading ',children:["},
				{line:"{type:'$label',content:'New '}"},
				{line:"]},"},
				{line:"{type:'$h1',ovSize:'3',content:'Example heading ',children:["},
				{line:"{type:'$label',content:'New '}"},
				{line:"]},"},
				{line:"{type:'$h1',ovSize:'4',content:'Example heading ',label:'New'},"},
				{line:"{type:'$h1',ovSize:'5',content:'Example heading ',label:'New'},"},
				{line:"{type:'$h1',ovSize:'6',content:'Example heading ',label:'New'}"},
				{line:"]}"}
			],
		},
		
		
		{
			/* --- --- */
			header : 'Available variations',
			description : 'Add any of the below mentioned modifier classes as <code>theme</code> attribute to change the appearance of a label.',		
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$label',theme:'default',content:'Default'},"},
				{line:"{type:'$label',theme:'primary',content:'Primary'},"},
				{line:"{type:'$label',theme:'success',content:'Success'},"},
				{line:"{type:'$label',theme:'info',content:'Info'},"},
				{line:"{type:'$label',theme:'warning',content:'Warning'},"},
				{line:"{type:'$label',theme:'danger',content:'Danger'}"},
				{line:"]}"}
			],
		},
		
		
	];
	
	return data;
}

ClientMethod getDataBadges() [ Language = javascript ]
{
	var data = {
		widgetname:'$badge',
		description:'Easily highlight new or unread items by adding <code>$badge</code> to links, Bootstrap navs, and more.',
		headercontent:'Badges',
		linkAddress:'http://getbootstrap.com/components/#badges',
		link:'Twitter Bootstrap Badges documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			description : 'Use <code>$badge</code> as a child of other elements',	
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$link',href:'#',id:'link1',content:'Inbox ',children:["},
				{line:"{type:'$badge',id:'badge1',content:'42'}"},
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$button',theme:'primary',content:'Message ',children:["},
				{line:"{type:'$badge',content:'4'}"},
				{line:"]}"},
				{line:"]}"},
			],
		},
		
		{
			/* --- --- */
			description : 'Alternatively, set the <code>badge</code> attribute of a <code>$link</code> or '
						+ '<code>button</code> element directly',	
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$link',href:'#',id:'link2',content:'Inbox ',badge:'42'},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$button',id:'button1',theme:'primary',content:'Message ',badge:'4'}"},
				{line:"]}"},
			],
		},
		
		
		{
			/* --- --- */
			header : 'Self collapsing and adapts to active nav states',
			description : '<p>When there are no new or unread items, badges will simply collapse (via CSS :empty selector)'
						+ ' provided no content exists within.</p><p>Built-in styles are included for placing badges in '
						+ 'active states in pill navigations.</p>',		
			staticCode:[
				{line:"{type:'$nav',navType:'pills',role:'tablist',children:["},
				{line:"{type:'$link',listed:true,active:true,content:'Home',badge:'42'},"},
				{line:"{type:'$link',listed:true,content:'Profile'},"},
				{line:"{type:'$link',listed:true,content:'Message',badge:'3'}"},
				{line:"]}"}
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataJumbotron() [ Language = javascript ]
{
	var data = {
		widgetname:'$jumbotron',
		description:'A lightweight, flexible component that can optionally extend the entire viewport to showcase key content on your site.',
		headercontent:'Jumbotron',
		linkAddress:'http://getbootstrap.com/components/#jumbotron',
		link:'Twitter Bootstrap Jumbotron documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$jumbotron',children:["},
				{line:"{type:'$h1',content:'Hello world!'},"},
				{line:"{type:'$text',content:'This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information.'},"},
				{line:"{type:'$button',theme:'primary',size:'lg',asLink:true,href:'#',content:'Learn more'}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
		{
			/* --- --- */
			description : 'To make the jumbotron full width, and without rounded corners, place it outside all <code>containers</code> and instead add a <code>container</code> within.',		
			staticCode:[
				{line:"{type:'$jumbotron',children:["},
				{line:"{type:'$container',children:["},
				{line:"{type:'$h1',content:'Hello world!'},"},
				{line:"{type:'$text',content:'This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information.'},"},
				{line:"{type:'$button',theme:'primary',size:'lg',asLink:true,href:'#',content:'Learn more'}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
	];
	
	return data;
}

ClientMethod getDataPageHeader() [ Language = javascript ]
{
	var data = {
		widgetname:'$pageHeader',	
		headercontent:'Page Header',
		linkAddress:'http://getbootstrap.com/components/#page-header',
		link:'Twitter Bootstrap Page Header documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			description:'A simple shell for an <code>$h1</code> to appropriately space out and segment sections of content on a page. It can utilize the the default '
				  + '<code>subtext</code> element of <code>$pageHeader</code>, as well as most other components (with additional styles).',
			staticCode:[
				{line:"{type:'$pageHeader',id:'pageHeader',header:'Example page header ',subtext:'Subtext for header'}"}
			],
		},
		
	];
	
	return data;
}

ClientMethod getDataThumbnails() [ Language = javascript ]
{
	var data = {
		widgetname:'$thumbnail',
		description:'Extend the grid system of Bootstrap with the thumbnail component to easily display grids of images, videos, text, and more.',
		headercontent:'Thumbnails',
		linkAddress:'http://getbootstrap.com/components/#thumbnails',
		link:'Twitter Bootstrap Thumbnails documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Default example',
			description : 'By default, the thumbnails of Bootstrap are designed to showcase linked images with minimal required markup.',
			
			staticCode:[
				{line:"{type:'$gridSystem',children:["},
				{line:"{type:'$gridColumn',xs:'6',md:'3',children:["},
				{line:"{type:'$thumbnail',href:'#',src:'zenmojo_images/placeholder.png',alt:'A generic square placeholder'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',xs:'6',md:'3',children:["},
				{line:"{type:'$thumbnail',href:'#',src:'zenmojo_images/placeholder.png',alt:'A generic square placeholder'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',xs:'6',md:'3',children:["},
				{line:"{type:'$thumbnail',href:'#',src:'zenmojo_images/placeholder.png',alt:'A generic square placeholder'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',xs:'6',md:'3',children:["},
				{line:"{type:'$thumbnail',href:'#',src:'zenmojo_images/placeholder.png',alt:'A generic square placeholder'}"},
				{line:"]}"},
				{line:"]}"},
			],
		},
		
		{
			/* --- --- */
			header : 'Custom content',
			description : 'It is possible to add any kind of HTML content like headings, paragraphs, or buttons into thumbnails just by adding them as <code>children</code>',
			staticCode:[
				{line:"{type:'$gridSystem',children:["},
				{line:"{type:'$gridColumn',xs:'6',md:'4',children:["},
				{line:"{type:'$thumbnail',href:'#',src:'zenmojo_images/placeholder.png',alt:'A generic square placeholder',children:["},
				{line:"{type:'$h1',ovSize:'3',content:'Thumbnail label'},"},
				{line:"{type:'$text',content:'Donec key elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'},"},
				{line:"{type:'$button',asLink:'ture',theme:'primary'},"},
				{line:"{type:'$button',asLink:true}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',xs:'6',md:'4',children:["},
				{line:"{type:'$thumbnail',href:'#',src:'zenmojo_images/placeholder.png',alt:'A generic square placeholder',children:["},
				{line:"{type:'$h1',ovSize:'3',content:'Thumbnail label'},"},
				{line:"{type:'$text',content:'Donec key elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'},"},
				{line:"{type:'$button',asLink:'ture',theme:'primary'},"},
				{line:"{type:'$button',asLink:true}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',xs:'6',md:'4',children:["},
				{line:"{type:'$thumbnail',href:'#',src:'zenmojo_images/placeholder.png',alt:'A generic square placeholder',children:["},
				{line:"{type:'$h1',ovSize:'3',content:'Thumbnail label'},"},
				{line:"{type:'$text',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'},"},
				{line:"{type:'$button',asLink:'ture',theme:'primary'},"},
				{line:"{type:'$button',asLink:true}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
			],
		},
		
	];
	
	return data;
}

ClientMethod getDataImages() [ Language = javascript ]
{
	var data = {
		widgetname:'$image',
		headercontent:'Images',
		linkAddress:'http://getbootstrap.com/css/#images',
		link:'Twitter Bootstrap Images documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Responsive images',
			description : '<p>Images in Bootstrap 3 can be made responsive-friendly by setting '
						+ '<code>responsive</code> to be true.</p><p>To center images, set <code>'
						+ 'center</code> to be <code>true</code>',
			
			staticCode:[
				{line:"{type:'$image',id:'img1',src:'zenmojo_images/placeholder.png',alt:'A generic square placeholder',responsive:true,center:true}"},
			],
		},
		
		{
			/* --- --- */
			header : 'Image shapes',
			description : 'Apply <code>imgType</code> to easily style images in any project.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$image',src:'zenmojo_images/placeholder.png',alt:'A rounded placeholder',imgType:'rounded'},"},
				{line:"{type:'$image',src:'zenmojo_images/placeholder.png',alt:'A circle placeholder',imgType:'circle'},"},
				{line:"{type:'$image',src:'zenmojo_images/placeholder.png',alt:'A thumbnail placeholder',imgType:'thumbnail'}"},
				{line:"]}"},
			],
		},
		
	];
	
	return data;
}

ClientMethod getDataAlerts() [ Language = javascript ]
{
	var data = {
		widgetname:'$alert',
		description:'Provide contextual feedback messages for typical user actions with the handful of available and flexible alert messages. ',
		headercontent:'Alerts',
		linkAddress:'http://getbootstrap.com/components/#alerts',
		link:'Twitter Bootstrap Alerts documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Examples',
			description : 'Wrap any text as <code>content</code> in <code>$alert</code> and one of the four'+
						  ' contextual classes as the <code>theme</code> for basic alert messages.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$alert',key:'alert1',theme:'success',content:'<strong>Well done!</strong> You successfully read this important alert message'},"},
				{line:"{type:'$alert',theme:'info',content:'<strong>Heads up!</strong> This alert needs your attention, but it is not super important'},"},
				{line:"{type:'$alert',theme:'warning',content:'<strong>Warning!</strong> Best check your self, you are not looking too good'},"},
				{line:"{type:'$alert',theme:'danger',content:'<strong>Oh snap!</strong> Change a few things up and try submitting again'}"},
				{line:"]}"}		
			]
		},
		
		{
			/* --- --- */
			header : 'Dismissable alerts',
			description : 'Build on any alert by setting <code>dismissable</code> to be true.',		
			staticCode:[
				{line:"{type:'$alert',theme:'warning',dismissable:true,content:'<strong>Warning!</strong> Best check your self, you are not looking too good'}"},	
			]
		},
		
		{
			/* --- --- */
			header : 'Links in alerts',
			description : 'Instead of a simple <code>content</code>, use <code>$link</code> with <code>alert-link</code> cssClass '
						+ 'and <code>$raw</code> as <code>children</code> to provide matching colored links within any alert',		
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$alert',id:'alert2',theme:'success',children:["},
				{line:"{type:'$raw',content:'<strong>Well done!</strong> You successfully read'},"},
				{line:"{type:'$link',cssClass:'alert-link',content:' this important alert message'}"},		
				{line:"]},"},
				{line:"{type:'$alert',theme:'info',children:["},
				{line:"{type:'$raw',content:'<strong>Heads up!</strong> This'},"},	
				{line:"{type:'$link',cssClass:'alert-link',content:' alert needs your attention'},"},
				{line:"{type:'$raw',content:', but it is not super important'}"},
				{line:"]},"},
				{line:"{type:'$alert',theme:'warning',children:["},
				{line:"{type:'$raw',content:'<strong>Warning!</strong> Best check your self, you are'},"},
				{line:"{type:'$link',cssClass:'alert-link',content:' not looking too good.'}"},	
				{line:"]},"}	,
				{line:"{type:'$alert',theme:'danger',children:["},
				{line:"{type:'$raw',content:'<strong>Oh snap!</strong> and try submitting again'},"},
				{line:"{type:'$link',cssClass:'alert-link',content:' Change a few things up'},"},
				{line:"{type:'$raw',content:' and try submitting again'}"},		
				{line:"]}"},
				{line:"]}"}	
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataProgressBars() [ Language = javascript ]
{
	var data = {
		widgetname:'$progressBar',
		description:'Provide up-to-date feedback on the progress of a workflow or action with simple yet flexible progress bars.',
		headercontent:'Progress bars',
		linkAddress:'http://getbootstrap.com/components/#progress',
		link:'Twitter Bootstrap Progress bars documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Basic example',
			description : 'Wrap <code>$progressBar</code> within a <code>$div</code> with <code>progress</code> <code>cssClass</code>'
						+ ' for a default progress bar.',
			staticCode:[
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',key:'bar1',value:'60'}"},
				{line:"]}"}		
			]
		},
		
		{
			/* --- --- */
			header : 'With label',
			description : 'Set <code>label</code> to be <code>true</code> to show a visible percentage.',		
			staticCode:[
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',key:'bar2',label:true,value:'60'}"},
				{line:"]}"}	
			]
		},
		
		{
			/* --- --- */
			description : 'To ensure that the label text remains legible even for low percentages, consider adding a <code>minWidth'
						+ '</code> attribute to the progress bar.',		
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',label:true,value:'0',minWidth:'2em'}"},
				{line:"]},"},	
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',label:true,value:'2',minWidth:'2em'}"},
				{line:"]}"},
				{line:"]}"}	
			]
		},
		
		{
			/* --- --- */
			header : 'Contextual alternatives',
			description : 'Progress bars use some of the same button and alert classes for consistent styles, just apply a <code>theme</code> to it',		
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',theme:'success',value:'40'}"},
				{line:"]},"},	
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',theme:'info',value:'20'}"},
				{line:"]},"},
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',theme:'warning',value:'60'}"},
				{line:"]},"},	
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',theme:'danger',value:'80'}"},
				{line:"]}"},
				{line:"]}"}	
			]
		},
		
		{
			/* --- --- */
			header : 'Striped',
			description : 'Uses a gradient to create a striped effect by setting <code>striped</code> to be <code>true</code>. Not available in IE9 and below.',		
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',striped:true,theme:'success',value:'40'}"},
				{line:"]},"},	
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',striped:true,theme:'info',value:'20'}"},
				{line:"]},"},
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',striped:true,theme:'warning',value:'60'}"},
				{line:"]},"},	
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',striped:true,theme:'danger',value:'80'}"},
				{line:"]}"},
				{line:"]}"}	
			]
		},
		
		{
			/* --- --- */
			header : 'Animated',
			description : 'Animate the stripes right to left by setting <code>active</code> to be <code>true</code>. Not available in IE9 and below.',		
			staticCode:[
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',striped:true,active:true,value:'45'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Stacked',
			description : 'Place multiple <code>$progressBar</code> into the same <code>$div</code> to stack them.',		
			staticCode:[
				{line:"{type:'$div',cssClass:'progress',children:["},
				{line:"{type:'$progressBar',theme:'success',value:'35'},"},
				{line:"{type:'$progressBar',striped:true,theme:'warning',value:'20'},"},
				{line:"{type:'$progressBar',theme:'danger',value:'10'}"},
				{line:"]}"},	
			]
		},
		
		
	];
	
	return data;
}

ClientMethod getDataMediaObject() [ Language = javascript ]
{
	var data = {
		widgetname:'Media Object',
		description:'Abstract object styles for building various types of components (like blog comments, Tweets, etc) that feature a left- or right-aligned image'
				   +' alongside textual content.',
		headercontent:'Media Object',
		linkAddress:'http://bootstrapdocs.com/v3.1.1/docs/components/#media',
		link:'Twitter Bootstrap Media Object documentation'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Default media',
			description : 'The default media allow to float a media object (images, video, audio) to the left or right '
						+ 'of a content block.',		
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$mediaObject',id:'media1',srcLeft:'zenmojo_images/placeholder.png',altLeft:'A generic square placeholder',heading:'Media heading',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'},"},
				{line:"{type:'$mediaObject',id:'media2',srcLeft:'zenmojo_images/placeholder.png',altLeft:'A generic square placeholder',heading:'Media heading',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.',children:["},
				{line:"{type:'$mediaObject',srcLeft:'zenmojo_images/placeholder.png',altLeft:'A generic square placeholder',heading:'Nested media heading',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'}"},
				{line:"]},"},
				{line:"{type:'$mediaObject',srcRight:'zenmojo_images/placeholder.png',altRight:'A generic square placeholder',heading:'Media heading',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'},"},
				{line:"{type:'$mediaObject',srcLeft:'zenmojo_images/placeholder.png',altLeft:'A generic square placeholder',srcRight:'zenmojo_images/placeholder.png',altRight:'A generic square placeholder',heading:'Media heading',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'}"},
				{line:"]}"}
			],
		},	
		{
			/* --- --- */
			header : 'Media alignment',
			description : 'The images or other media can be aligned top, middle, or bottom by applying <code>alignLeft</code>'
						+ ' for media at the left of the content block and <code>alignRight</code> for media at right. The '
						+ 'default is top aligned.',		
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$mediaObject',srcLeft:'zenmojo_images/placeholder.png',altLeft:'A generic square placeholder',heading:'Media heading',children:["},
				{line:"{type:'$text',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus. Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.  Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'},"},
				{line:"{type:'$text',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus. Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.  Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'}"},
				{line:"]},"},
				{line:"{type:'$mediaObject',srcLeft:'zenmojo_images/placeholder.png',altLeft:'A generic square placeholder',alignLeft:'middle',heading:'Media heading',children:["},
				{line:"{type:'$text',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus. Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.  Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'},"},
				{line:"{type:'$text',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus. Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.  Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'}"},
				{line:"]},"},
				{line:"{type:'$mediaObject',srcLeft:'zenmojo_images/placeholder.png',altLeft:'A generic square placeholder',alignLeft:'bottom',heading:'Nested media heading',children:["},
				{line:"{type:'$text',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus. Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.  Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'},"},
				{line:"{type:'$text',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus. Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.  Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'}"},
				{line:"]}"},
				{line:"]}"}
			],
		},	
		{
			/* --- --- */
			header : 'Media list',
			description : 'By using <code>$mediaObject</code> as <code>children</code> of another <code>$mediaObject</code> '
						+ 'widget, you can use media inside list (useful for comment threads or articles lists).',		
			staticCode:[
				{line:"{type:'$mediaObject',srcLeft:'zenmojo_images/placeholder.png',altLeft:'A generic square placeholder',heading:'Media heading',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.',children:["},
				{line:"{type:'$mediaObject',srcLeft:'zenmojo_images/placeholder.png',altLeft:'A generic square placeholder',heading:'Nested media heading',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.',children:["},
				{line:"{type:'$mediaObject',srcLeft:'zenmojo_images/placeholder.png',altLeft:'A generic square placeholder',heading:'Nested media heading',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'}"},
				{line:"]},"},
				{line:"{type:'$mediaObject',srcLeft:'zenmojo_images/placeholder.png',altLeft:'A generic square placeholder',heading:'Nested media heading',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'}"},
				{line:"]}"},
			],
		},
		
	];
	
	return data;
}

ClientMethod getDataListGroup() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$listGroup & $listGroupItem',
		description : '<code>$listGroup</code> is a flexible and powerful component for displaying not only simple lists of <code>$listGroupItem</code>s, but complex ones with custom content.',
		headercontent:'List group',
		link:'Twitter Bootstrap List group documentation',
		linkAddress:'http://getbootstrap.com/components/#list-group'
	};
	
	data.sections = [
		{
			/* --- --- */
			header : 'Basic example',
			description : 'The most basic <code>$listGroup</code> is simply built upon with <code>$listGroupItem</code>.',
			staticCode:[
				{line:"{type:'$listGroup',children:["},
				{line:"{type:'$listGroupItem',content:'Cras justo odio'},"},
				{line:"{type:'$listGroupItem',content:'Dapibus ac facilisis in'},"},
				{line:"{type:'$listGroupItem',content:'Morbi leo risus'},"},
				{line:"{type:'$listGroupItem',content:'Porta ac consectetur ac'},"},
				{line:"{type:'$listGroupItem',content:'Vestibulum at eros'}"},
				{line:"]}"}
			]
		},
	
		{
			/* --- --- */
			header : 'Badges',
			description : 'Add the <code>badge</code> component to any <code>$listGroupItem</code> and it will automatically be positioned on the right.',		
			staticCode:[
				{line:"{type:'$listGroup',children:["},
				{line:"{type:'$listGroupItem',id:'lgItem1',badge:'14',content:'Cras justo odio'},"},
				{line:"{type:'$listGroupItem',badge:'2',content:'Dapibus ac facilisis in'},"},
				{line:"{type:'$listGroupItem',badge:'1',content:'Morbi leo risus'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Glyphicons',
			description : 'Add the <code>icon</code> component to any <code>$listGroupItem</code>, and optionally set <code>'
						+ 'iconRight</code> to be <code>true</code> to position it on the right.',		
			staticCode:[
				{line:"{type:'$listGroup',children:["},
				{line:"{type:'$listGroupItem',id:'lgItem3',icon:'menu-right',iconRight:true,content:'Cras justo odio'},"},
				{line:"{type:'$listGroupItem',icon:'menu-right',iconRight:true,content:'Dapibus ac facilisis in'},"},
				{line:"{type:'$listGroupItem',icon:'menu-right',iconRight:true,content:'Morbi leo risus'}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Linked items',
			description : 'Linkify <code>$listGroupItem</code> by setting its <code>linked</code> to be <code>true</code>, '
						+ 'as well as for <code>$listGroup</code>. No need for individual parents around each element.',		
			staticCode:[
				{line:"{type:'$listGroup',linked:true,children:["},
				{line:"{type:'$listGroupItem',linked:true,content:'Cras justo odio'},"},
				{line:"{type:'$listGroupItem',linked:true,content:'Dapibus ac facilisis in'},"},
				{line:"{type:'$listGroupItem',linked:true,content:'Morbi leo risus'},"},
				{line:"{type:'$listGroupItem',linked:true,content:'Porta ac consectetur ac'},"},
				{line:"{type:'$listGroupItem',linked:true,content:'Vestibulum at eros'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Disabled items',
			description : 'Set <code>disabled</code> to be <code>true</code> for <code>$listGroupItem</code> to gray it out to appear disabled.',		
			staticCode:[
				{line:"{type:'$listGroup',linked:true,children:["},
				{line:"{type:'$listGroupItem',linked:true,disabled:true,content:'Cras justo odio'},"},
				{line:"{type:'$listGroupItem',linked:true,content:'Dapibus ac facilisis in'},"},
				{line:"{type:'$listGroupItem',linked:true,content:'Morbi leo risus'},"},
				{line:"{type:'$listGroupItem',linked:true,content:'Porta ac consectetur ac'},"},
				{line:"{type:'$listGroupItem',linked:true,content:'Vestibulum at eros'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Contextual classes',
			description : 'Use contextual classes to style <code>$listGroupItem</code>, default or linked. Also includes <code>active</code> state.',		
			staticCode:[
				{line:"{type:'$gridSystem',children:["},
				{line:"{type:'$gridColumn',sm:'6',children:["},
				{line:"{type:'$listGroup',children:["},
				{line:"{type:'$listGroupItem',theme:'success',active:true,content:'Cras justo odio'},"},
				{line:"{type:'$listGroupItem',theme:'info',content:'Dapibus ac facilisis in'},"},
				{line:"{type:'$listGroupItem',theme:'warning',content:'Morbi leo risus'},"},
				{line:"{type:'$listGroupItem',theme:'danger',content:'Porta ac consectetur ac'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',sm:'6',children:["},
				{line:"{type:'$listGroup',linked:true,children:["},
				{line:"{type:'$listGroupItem',linked:true,theme:'success',content:'Cras justo odio'},"},
				{line:"{type:'$listGroupItem',linked:true,theme:'info',content:'Dapibus ac facilisis in'},"},
				{line:"{type:'$listGroupItem',linked:true,theme:'warning',content:'Morbi leo risus'},"},
				{line:"{type:'$listGroupItem',linked:true,theme:'danger',content:'Porta ac consectetur ac'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
				
		{
			/* --- --- */
			header : 'Custom content',
			description : 'Add heading by applying <code>label</code>, or add nearly any HTML by using <code>children</code> and proper <code>cssClass</code> within, even for linked list groups like the one below.',		
			staticCode:[
				{line:"{type:'$gridSystem',children:["},
				{line:"{type:'$gridColumn',sm:'4',children:["},
				{line:"{type:'$listGroup',linked:true,children:["},
				{line:"{type:'$listGroupItem',id:'lgItem2',linked:true,active:true,label:'List group item heading',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'},"},
				{line:"{type:'$listGroupItem',linked:true,label:'List group item heading',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'},"},
				{line:"{type:'$listGroupItem',linked:true,children:["},
				{line:"{type:'$h1',ovSize:'4',cssClass:'list-group-item-heading',content:'List group item heading'},"},
				{line:"{type:'$text',cssClass:'list-group-item-text',content:'Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus.'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
	];
	
	return data;
}

ClientMethod getDataPanels() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$panel, $panelBody, $panelHeading & $panelFooter',
		description : 'While not always necessary, sometimes you need to put your DOM in a box. For those situations, try the panel component.',
		headercontent: 'Panels',
		link:'Twitter Bootstrap Panels documentation',
		linkAddress:'http://getbootstrap.com/components/#panels'
	};
	
	data.sections = [
		{
			/* --- --- */
			header : 'Basic example',
			description : 'By default, all the <code>$panel</code> does is apply some basic border and padding to contain some content.',
			staticCode:[		
				{line:"{type:'$panel',children:["},
				{line:"{type:'$panelBody',content:'Basic panel example'}"},
				{line:"]}"},
			]
		},
	
		{
			/* --- --- */
			header : 'Panel with heading',
			description : 'Easily add a heading container to your panel with <code>$panelHeading</code>. You may also include an '+
						  '<code>ovSize</code> and apply <code>1</code>-<code>6</code> to add a pre-styled heading.',		
			staticCode:[

				{line:"{type:'$panel',children:["},
				{line:"{type:'$panelHeading',id:'panelHead1',content:'Panel heading without title'},"},
				{line:"{type:'$panelBody',id:'panelBody1',content:'Panel content'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$panel',children:["},
				{line:"{type:'$panelHeading',id:'panelHead2',ovSize:'3',content:'Panel title'},"},
				{line:"{type:'$panelBody',content:'Panel content'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Panel with footer',
			description : 'Wrap buttons or secondary text in <code>$panelFooter</code>. Note that panel footers <strong>do not</strong>'+
						  ' inherit colors and borders when using contextual variations as they are not meant to be in the foreground.',		
			staticCode:[

				{line:"{type:'$panel',children:["},
				{line:"{type:'$panelBody',content:'Panel content'},"},
				{line:"{type:'$panelFooter',id:'panelFoot1',content:'Panel footer'}"},
				{line:"]}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Contextual alternatives',
			description : 'Like other components, easily make a panel more meaningful to a particular context by adding any of the contextual state classes.',		
			staticCode:[
				{line:"{type:'$panel',theme:'primary',children:["},
				{line:"{type:'$panelHeading',ovSize:'3',cssClass:'panel-title',content:'Panel title'},"},
				{line:"{type:'$panelBody',content:'Panel content'}"},
				{line:"]}"},
			],
		},
		{
			/* --- --- */		
			staticCode:[
				{line:"{type:'$panel',theme:'success',children:["},
				{line:"{type:'$panelHeading',ovSize:'3',cssClass:'panel-title',content:'Panel title'},"},
				{line:"{type:'$panelBody',content:'Panel content'}"},
				{line:"]}"},
			],
		},
		{
			/* --- --- */		
			staticCode:[
				{line:"{type:'$panel',theme:'info',children:["},
				{line:"{type:'$panelHeading',ovSize:'3',cssClass:'panel-title',content:'Panel title'},"},
				{line:"{type:'$panelBody',content:'Panel content'}"},
				{line:"]}"},
			],
		},
		{
			/* --- --- */		
			staticCode:[
				{line:"{type:'$panel',theme:'warning',children:["},
				{line:"{type:'$panelHeading',ovSize:'3',cssClass:'panel-title',content:'Panel title'},"},
				{line:"{type:'$panelBody',content:'Panel content'}"},
				{line:"]}"},
			],
		},
		{
			/* --- --- */		
			staticCode:[
				{line:"{type:'$panel',theme:'danger',children:["},
				{line:"{type:'$panelHeading',ovSize:'3',cssClass:'panel-title',content:'Panel title'},"},
				{line:"{type:'$panelBody',content:'Panel content'}"},
				{line:"]}"},
			],
		},
		
		{
			/* --- --- */
			header : 'With tables',
			description : 'Add any non-bordered <code>$table</code> within a panel for a seamless design. If there is a <code>$panelBody</code>,' 
			+'we add an extra border to the top of the table for separation.',		
			staticCode:[
				{line:"{type:'$panel',children:["},
				{line:"{type:'$panelHeading',content:'Panel heading'},"},
				{line:"{type:'$panelBody',children:["},
				{line:"{type:'$text',content:'Some default panel content here.  Nullam id dolor id nibh ultricies vehicula ut id elit.'}"},
				{line:"]},"},
				{line:"{type:'$table',children:["},
				{line:"{type:'$tableHeader',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',content:'#'},"},
				{line:"{type:'$tableColumn',content:'First Name'},"},
				{line:"{type:'$tableColumn',content:'Last Name'},"},
				{line:"{type:'$tableColumn',content:'Username'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$tableBody',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableCell',content:'1'},"},
				{line:"{type:'$tableCell',content:'Mark'},"},
				{line:"{type:'$tableCell',content:'Otto'},"},
				{line:"{type:'$tableCell',content:'@mdo'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableCell',content:'2'},"},
				{line:"{type:'$tableCell',content:'Jacob'},"},
				{line:"{type:'$tableCell',content:'Thornton'},"},
				{line:"{type:'$tableCell',content:'@fat'}"},
				{line:"]},"},			
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableCell',content:'3'},"},
				{line:"{type:'$tableCell',content:'Larry'},"},
				{line:"{type:'$tableCell',content:'the Bird'},"},
				{line:"{type:'$tableCell',content:'@twitter'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
			],
		},
		{
			/* --- --- */
			description : 'If there is no panel body, the component moves from panel header to table without interruption.',
			staticCode:[
				{line:"{type:'$panel',children:["},
				{line:"{type:'$panelHeading',content:'Panel heading'},"},
				{line:"{type:'$table',children:["},
				{line:"{type:'$tableHeader',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',content:'#'},"},
				{line:"{type:'$tableColumn',content:'First Name'},"},
				{line:"{type:'$tableColumn',content:'Last Name'},"},
				{line:"{type:'$tableColumn',content:'Username'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$tableBody',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableCell',content:'1'},"},
				{line:"{type:'$tableCell',content:'Mark'},"},
				{line:"{type:'$tableCell',content:'Otto'},"},
				{line:"{type:'$tableCell',content:'@mdo'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableCell',content:'2'},"},
				{line:"{type:'$tableCell',content:'Jacob'},"},
				{line:"{type:'$tableCell',content:'Thornton'},"},
				{line:"{type:'$tableCell',content:'@fat'}"},
				{line:"]},"},			
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableCell',content:'3'},"},
				{line:"{type:'$tableCell',content:'Larry'},"},
				{line:"{type:'$tableCell',content:'the Bird'},"},
				{line:"{type:'$tableCell',content:'@twitter'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
			],
		},
		
		{
			/* --- --- */
			header : 'With list groups',
			description : 'Easily include full-width list groups within any panel.',	
			staticCode:[
				{line:"{type:'$panel',children:["},
				{line:"{type:'$panelHeading',content:'Panel heading'},"},
				{line:"{type:'$panelBody',children:["},
				{line:"{type:'$text',content:'Some default panel content here.  Nullam id dolor id nibh ultricies vehicula ut id elit.  Some default panel content here.  Nullam id dolor id nibh ultricies vehicula ut id elit.  Some default panel content here.  Nullam id dolor id nibh ultricies vehicula ut id elit.'}"},
				{line:"]},"},
				{line:"{type:'$listGroup',children:["},
				{line:"{type:'$listGroupItem',content:'Cras justo odio'},"},
				{line:"{type:'$listGroupItem',content:'Dapibus ac facilisis in'},"},
				{line:"{type:'$listGroupItem',content:'Morbi leo risus'},"},
				{line:"{type:'$listGroupItem',content:'Porta ac consectetur ac'},"},
				{line:"{type:'$listGroupItem',content:'Vestibulum at eros'}"},
				{line:"]}"},
				{line:"]}"}
			],
		},
		
	];
	
	return data;
}

ClientMethod getDataResponsiveEmbed() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$responsiveEmbed',
		description : 'Allow browsers to determine video or slideshow dimensions based on the width of their containing block by creating an intrinsic ratio that will properly scale on any device.',
		headercontent:'Responsive Embed',
		link:'Twitter Bootstrap Responsive Embed documentation',
		linkAddress:'http://getbootstrap.com/components/#responsive-embed'
	};
	
	data.sections = [
		{
			/* --- --- */
			description : '<p>Rules are directly applied to the <code>element</code> of <code>iframe</code>(default), '
						+ '<code>embed</code>, <code>video</code>, and <code>object</code>; optionally set <code>descendant'
						+ '</code> to be <code>true</code> when you want to match the styling for other attributes.</p>'
						+ '<p>You <strong>must</strong> apply the link to your embed as <code>src</code>(skip the http part),'
						+ ' and may optionally set <code>ratio</code> as one of <code>16by9</code>(default), <code>4by3</code> '
						+ 'or your own choice.</p>',
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$responsiveEmbed',id:'resp1',src:'www.youtube.com/embed/gb6B_YwFBno',descendant:true}"},
				{line:"]}"}
			]
		},
	
	];
	
	return data;
}

ClientMethod getDataWells() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$well',
		headercontent:'Wells',
		link:'Twitter Bootstrap Wells documentation',
		linkAddress:'http://getbootstrap.com/components/#wells'
	};
	
	data.sections = [
		{
			/* --- --- */
			header : 'Default well',
			description : 'Use the well as a simple effect on an element to give it an inset effect.',
			staticCode:[
				{line:"{type:'$well',id:'well1',content:'Look, I am in a well. '}"}
			]
		},
	
		{
			/* --- --- */
			header : 'Optional classes',
			description : 'Control padding and rounded corners by setting <code>size</code> as <code>lg</code> or <code>sm</code>.',		
			staticCode:[
				{line:"{type:'$well',size:'lg',content:'Look, I am in a large well.'}"},
			]
		},
		{
			/* --- --- */		
			staticCode:[
				{line:"{type:'$well',size:'sm',content:'Look, I am in a small well. '}"},
			]
		},
	];
	
	return data;
}

ClientMethod getDataContainers() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$container and $containerFluid',
		description : 'Bootstrap requires a containing element to wrap site contents and house their grid system. '
					+ 'You may choose one of two containers to use in your projects. Note that, due to <code>'
					+ 'padding</code> and more, neither container is nestable.',
		headercontent:'Containers',
		link:'Twitter Bootstrap Containers documentation',
		linkAddress:'http://getbootstrap.com/css/#overview-container'
	};
	
	data.sections = [
		{
			/* --- --- */
			description : 'Use <code>$container</code> for a responsive fixed width container.',
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$h1',content:'Look, I am in a container.'},"},
				{line:"{type:'$text',content:'Nullam id dolor id nibh ultricies vehicula ut id elit.  Some default panel content here.  Nullam id dolor id nibh ultricies vehicula ut id elit.  Some default panel content here.  Nullam id dolor id nibh ultricies vehicula ut id elit.'}"},
				{line:"]}"}
			]
		},
	
		{
			/* --- --- */
			description : 'Use <code>$containerFluid</code> for a full width container, spanning the entire width of your viewport.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$h1',content:'Look, I am in a fluid container.'},"},
				{line:"{type:'$text',content:'Nullam id dolor id nibh ultricies vehicula ut id elit.  Some default panel content here.  Nullam id dolor id nibh ultricies vehicula ut id elit.  Some default panel content here.  Nullam id dolor id nibh ultricies vehicula ut id elit.'}"},
				{line:"]}"}
			]
		},
	];
	
	return data;
}

ClientMethod getDataGridSystems() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$gridSystem and $gridColumn',
		description : 'Bootstrap includes a responsive, mobile first fluid grid system that appropriately '
					+ 'scales up to 12 columns as the device or viewport size increases. ',
		headercontent:'Grid system',
		link:'Twitter Bootstrap Grid System documentation',
		linkAddress:'http://getbootstrap.com/css/#grid'
	};
	
	data.sections = [
		{
			/* --- --- */
			header : 'Introduction',
			description : 'Grid systems are used for creating page layouts through a series of rows and columns'
						+ ' that house your content. Here is how it works: <ul><li>Use <code>$gridSystem</code> '
						+ 'to create horizontal groups of columns, and it <strong>must</strong> be placed within'
						+ ' a <code>$container</code> (fixed-width) or <code>$containerFluid</code> (full-width)'
						+ ' for proper alignment and padding.</li><li>Content should be placed within <code>'
						+ '$gridColumn</code>, and only <code>$gridColumn</code> may be immediate children of'
						+ ' <code>$gridSystem</code>.</li><li>Grid columns are created by specifying the number'
						+ ' of twelve available columns you wish to span. For example, three equal columns would'
						+ ' use three <code>$gridColumn</code>s whose <code>xs</code> set to be <code>4</code>, '
						+ 'and if more than 12 columns are placed within a single row, each group of extra columns'
						+ ' will, as one unit, wrap onto a new line.</li><li>Grid classes apply to devices with '
						+ 'screen widths greater than or equal to the breakpoint sizes, and override grid classes'
						+ ' targeted at smaller devices. Therefore, e.g. setting the <code>md</code> attribute of '
						+ 'a <code>$gridColumn</code> element will not only affect its styling on medium devices '
						+ 'but also on large devices if the <code>lg</code> attribute is not present.</li></ul>',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$gridSystem',id:'grid1',children:["},
				{line:"{type:'$gridColumn',xs:'4',children:["},
				{line:"{type:'$text',content:'xs-4'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',xs:'4',children:["},
				{line:"{type:'$text',content:'xs-4'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',xs:'4',children:["},
				{line:"{type:'$text',content:'xs-4'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
	
		{
			/* --- --- */
			header : 'Grid options for <code>$gridColumn</code>',
			description : '<div class="table-responsive"><table class="table table-bordered table-striped"><thead>'
						+ '<tr><th></th><th>"Extra small devices"<small>Phones (<768px)</small></th><th>"Small devices"'
						+ '<small>Tablets (>=768px)</small></th><th>Medium devices<small>Desktops (>= 992px)</small></th>'
						+ '<th>Large devices<small>Desktops (>=1200px)</small></th></tr></thead><tbody><tr><th class="text'
						+ '-nowrap" scope="row">Grid behavior</th><td>Horizontal at all times</td><td colspan="3">Collapsed'
						+ ' to start, horizontal above breakpoints</td></tr><tr><th class="text-nowrap" scope="row">Container'
						+ ' width</th><td>None (auto)</td><td>750px</td><td>970px</td><td>1170px</td></tr><tr><th class="text'
						+ '-nowrap" scope="row">Attribute</th><td><code>xs</code></td><td><code>sm</code></td><td><code>md'
						+ '</code></td><td><code>lg</code></td></tr><tr><th class="text-nowrap" scope="row"># of columns</th>'
						+ '<td colspan="4">12</td></tr><tr><th class="text-nowrap" scope="row">Nestable</th><td colspan="4">'
						+ 'Yes</td></tr></tbody></table></div><p>Setting <code>md</code> for a single set of <code>$gridColumn'
						+ '</code>s, you can create a basic grid system that starts out stacked on mobile devices and tablet'
						+ ' devices (the extra small to small range) before becoming horizontal on desktop (medium) devices.</p>',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$gridSystem',id:'grid2',children:["},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'1',children:["},
				{line:"{type:'$text',content:'md-1'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridSystem',id:'grid3',children:["},
				{line:"{type:'$gridColumn',md:'8',children:["},
				{line:"{type:'$text',content:'md-8'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'4',children:["},
				{line:"{type:'$text',content:'md-4'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridSystem',id:'grid4',children:["},
				{line:"{type:'$gridColumn',md:'4',children:["},
				{line:"{type:'$text',content:'md-4'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'4',children:["},
				{line:"{type:'$text',content:'md-4'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'4',children:["},
				{line:"{type:'$text',content:'md-4'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridSystem',id:'grid5',children:["},
				{line:"{type:'$gridColumn',md:'6',children:["},
				{line:"{type:'$text',content:'md-6'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'6',children:["},
				{line:"{type:'$text',content:'md-6'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Example: Mobile and desktop',
			description : 'Do not want your columns to simply stack in smaller devices? Use the extra small and medium '
						+ 'device grid classes by adding <code>xs</code> <code>md</code> to your <code>$gridColumn</code>s.'
						+ ' See the example below for a better idea of how it all works.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$gridSystem',id:'grid6',children:["},
				{line:"{type:'$gridColumn',md:'8',xs:'12',children:["},
				{line:"{type:'$text',content:'md-8 xs-12'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'4',xs:'6',children:["},
				{line:"{type:'$text',content:'md-4 xs-6'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridSystem',id:'grid7',children:["},
				{line:"{type:'$gridColumn',md:'4',xs:'6',children:["},
				{line:"{type:'$text',content:'md-4 xs-6'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'4',xs:'6',children:["},
				{line:"{type:'$text',content:'md-4 xs-6'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'4',xs:'6',children:["},
				{line:"{type:'$text',content:'md-4 xs-6'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridSystem',id:'grid8',children:["},
				{line:"{type:'$gridColumn',xs:'6',children:["},
				{line:"{type:'$text',content:'xs-6'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',xs:'6',children:["},
				{line:"{type:'$text',content:'xs-6'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Example: Mobile, tablet, desktop',
			description : 'Build on the previous example by creating even more dynamic and powerful layouts with tablet '
						+ '<code>sm</code> attribute.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$gridSystem',id:'grid9',children:["},
				{line:"{type:'$gridColumn',md:'8',sm:'6',xs:'12',children:["},
				{line:"{type:'$text',content:'md-8 sm-6 xs-12'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'4',xs:'6',children:["},
				{line:"{type:'$text',content:'md-4 xs-6'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridSystem',id:'grid10',children:["},
				{line:"{type:'$gridColumn',sm:'4',xs:'6',children:["},
				{line:"{type:'$text',content:'sm-4 xs-6'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',sm:'4',xs:'6',children:["},
				{line:"{type:'$text',content:'sm-4 xs-6'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',sm:'4',xs:'6',children:["},
				{line:"{type:'$text',content:'sm-4 xs-6'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Offsetting columns',
			description : 'Move columns to the right using <code>col-md-offset-*</code> cssClasses. These classes'
						+ ' increase the left margin of a column by <code>*</code> columns. For example, a <code>'
						+ 'col-md-offset-4</code> moves <code>$gridColumn</code> over four columns.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$gridSystem',id:'grid11',children:["},
				{line:"{type:'$gridColumn',md:'4',children:["},
				{line:"{type:'$text',content:'md-4'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'4',cssClass:'col-md-offset-4',children:["},
				{line:"{type:'$text',content:'md-4 col-md-offset-4'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridSystem',id:'grid12',children:["},
				{line:"{type:'$gridColumn',md:'3',cssClass:'col-md-offset-3',children:["},
				{line:"{type:'$text',content:'md-3 col-md-offset-3'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'3',cssClass:'col-md-offset-3',children:["},
				{line:"{type:'$text',content:'md-3 col-md-offset-3'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$gridSystem',id:'grid13',children:["},
				{line:"{type:'$gridColumn',md:'6',cssClass:'col-md-offset-3',children:["},
				{line:"{type:'$text',content:'md-6 col-md-offset-3'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Nesting columns',
			description : 'To nest your content with the default grid, add a new <code>$gridSystem</code> and set '
						+ 'of <code>$gridColumn</code> within an existing <code>$gridColumn</code>. Nested <code>'
						+ '$gridSystem</code> should include a set of <code>$gridColumn</code>s that add up to 12' 
						+ ' or fewer (it is not required that you use all 12 available columns).',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$gridSystem',id:'grid14',children:["},
				{line:"{type:'$gridColumn',sm:'9',children:["},
				{line:"{type:'$text',content:'Level 1 sm-9'},"},
				{line:"{type:'$gridSystem',children:["},
				{line:"{type:'$gridColumn',xs:'8',sm:'6',children:["},
				{line:"{type:'$text',content:'Level 2 xs-8 sm-6'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',xs:'4',sm:'6',children:["},
				{line:"{type:'$text',content:'Level 2 xs-4 sm-6'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Column ordering',
			description : 'Easily change the order of built-in <code>$gridColumn</code> with <code>'
						+ 'col-md-push-*</code> and <code>col-md-pull-*</code> modifier cssClasses.',
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$gridSystem',id:'grid15',children:["},
				{line:"{type:'$gridColumn',md:'9',cssClass:'col-md-push-3',children:["},
				{line:"{type:'$text',content:'md-9 col-md-push-3'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',md:'3',cssClass:'col-md-pull-9',children:["},
				{line:"{type:'$text',content:'md-3 col-md-pull-9'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
	];
	
	return data;
}

ClientMethod getDataHeadings() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$h1',
		description : 'All HTML headings are available by using <code>$h1</code> and setting '
					+ '<code>ovSize</code> for <code>h1</code>(default)-<code>h6</code>.',
		headercontent:'Headings',
		link:'Twitter Bootstrap Headings documentation',
		linkAddress:'http://getbootstrap.com/css/#type-headings'
	};
	
	data.sections = [
		{
			/* --- --- */
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$h1',content:'h1. Bootstrap heading'},"},
				{line:"{type:'$h1',ovSize:'2',content:'h2. Bootstrap heading'},"},
				{line:"{type:'$h1',ovSize:'3',content:'h3. Bootstrap heading'},"},
				{line:"{type:'$h1',ovSize:'4',content:'h4. Bootstrap heading'},"},
				{line:"{type:'$h1',ovSize:'5',content:'h5. Bootstrap heading'},"},
				{line:"{type:'$h1',ovSize:'6',content:'h6. Bootstrap heading'}"},
				{line:"]}"},
			]
		},
	
		{
			/* --- --- */
			header : 'Secondary text',
			description : 'Create lighter, secondary text in any heading with <code>subtext</code> attribute.',		
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$h1',id:'heading1',subtext:'Secondary text',content:'h1. Bootstrap heading'},"},
				{line:"{type:'$h1',subtext:'Secondary text',ovSize:'2',content:'h2. Bootstrap heading'},"},
				{line:"{type:'$h1',subtext:'Secondary text',ovSize:'3',content:'h3. Bootstrap heading'},"},
				{line:"{type:'$h1',subtext:'Secondary text',ovSize:'4',content:'h4. Bootstrap heading'},"},
				{line:"{type:'$h1',subtext:'Secondary text',ovSize:'5',content:'h5. Bootstrap heading'},"},
				{line:"{type:'$h1',subtext:'Secondary text',ovSize:'6',content:'h6. Bootstrap heading'}"},
				{line:"]}"},
			]
		},
		{
			/* --- --- */	
			header : 'Label',	
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$h1',label:'New',content:'h1. Bootstrap heading'},"},
				{line:"{type:'$h1',id:'heading2',label:'New',ovSize:'2',content:'h2. Bootstrap heading'},"},
				{line:"{type:'$h1',label:'New',ovSize:'3',content:'h3. Bootstrap heading'},"},
				{line:"{type:'$h1',label:'New',ovSize:'4',content:'h4. Bootstrap heading'},"},
				{line:"{type:'$h1',label:'New',ovSize:'5',content:'h5. Bootstrap heading'},"},
				{line:"{type:'$h1',label:'New',ovSize:'6',content:'h6. Bootstrap heading'}"},
				{line:"]}"},
			]
		},
	];
	
	return data;
}

ClientMethod getDataParagraphs() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$text',
		headercontent:'Paragraphs',
		link:'Twitter Bootstrap Headings documentation',
		linkAddress:'http://getbootstrap.com/css/#type-headings'
	};
	
	data.sections = [
	
		{
			/* --- --- */
			header : 'Lead body copy',
			description : 'Make a paragraph stand out by setting <code>lead</code> to be <code>true</code>.',		
			staticCode:[
				{line:"{type:'$text',id:'text1',lead:'ture',content:'Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Duis mollis, est non commodo luctus.'}"},
			]
		},
		{
			/* --- --- */	
			header : 'Alignment classes',	
			description : 'Easily realign text to components with <code>align</code> attribute.',		
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$text',align:'left',content:'Left aligned text.'},"},
				{line:"{type:'$text',align:'center',content:'Center aligned text.'},"},
				{line:"{type:'$text',align:'right',content:'Right aligned text.'},"},
				{line:"{type:'$text',align:'justify',content:'Justified text.'},"},
				{line:"{type:'$text',align:'nowrap',content:'No wrap text.'}"},
				{line:"]}"},
			]
		},
		{
			/* --- --- */	
			header : 'Transformation classes',	
			description : 'Transform text in components with <code>trans</code> attribute.',		
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$text',trans:'lowercase',content:'Lowercased text.'},"},
				{line:"{type:'$text',trans:'uppercase',content:'Uppercased text.'},"},
				{line:"{type:'$text',trans:'capitalize',content:'Capitalized text.'}"},
				{line:"]}"},
			]
		},
		{
			/* --- --- */	
			header : 'Contextual colors',	
			description : 'Convey meaning through color with a handful of emphasis utility classes '
						+ 'by applying <code>theme</code>',		
			staticCode:[
				{line:"{type:'$container',children:["},
				{line:"{type:'$text',theme:'muted',content:'Muted text.'},"},
				{line:"{type:'$text',theme:'primary',content:'Primary text.'},"},
				{line:"{type:'$text',theme:'success',content:'Sussess text.'},"},
				{line:"{type:'$text',theme:'info',content:'Info text.'},"},
				{line:"{type:'$text',theme:'warning',content:'Warning text.'},"},
				{line:"{type:'$text',theme:'danger',content:'Danger text.'}"},
				{line:"]}"},
			]
		},
		{
			/* --- --- */	
			header : 'Contextual backgrounds',	
			description : 'Similar to the contextual text color classes, easily set the background of an '
						+ 'element to any contextual class by applying <code>textBackground</code>',		
			staticCode:[
				{line:"{type:'$container',id:'bg-example',children:["},
				{line:"{type:'$text',textBackground:'muted',content:'Muted text.'},"},
				{line:"{type:'$text',textBackground:'primary',content:'Primary text.'},"},
				{line:"{type:'$text',textBackground:'success',content:'Sussess text.'},"},
				{line:"{type:'$text',textBackground:'info',content:'Info text.'},"},
				{line:"{type:'$text',textBackground:'warning',content:'Warning text.'},"},
				{line:"{type:'$text',textBackground:'danger',content:'Danger text.'}"},
				{line:"]}"},
			]
		},
	];
	
	return data;
}

ClientMethod getDataLists() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$li, $ul & $ol',
		headercontent:'Lists',
		link:'Twitter Bootstrap Lists documentation',
		linkAddress:'http://getbootstrap.com/css/#type-lists'
	};
	
	data.sections = [
	
		{
			/* --- --- */
			header : 'Unordered',
			description : 'A list of items in which the order does not explicitly matter.',		
			staticCode:[
				{line:"{type:'$ul',id:'ul1',children:["},
				{line:"{type:'$li',content:'Lorem ipsum dolor sit amet'},"},
				{line:"{type:'$li',content:'Consectetur adipiscing elit'},"},
				{line:"{type:'$li',content:'Integer molestie lorem at massa'},"},
				{line:"{type:'$li',content:'Facilisis in pretium nisl aliquet'},"},
				{line:"{type:'$li',content:'Nulla volutpat aliquam velit',children:["},
				{line:"{type:'$ul',children:["},
				{line:"{type:'$li',content:'Phasellus iaculis neque'},"},
				{line:"{type:'$li',content:'Purus sodales ultricies'},"},
				{line:"{type:'$li',content:'Vestibulum laoreet porttitor sem'},"},
				{line:"{type:'$li',content:'Ac tristique libero volutpat at'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$li',content:'Faucibus porta lacus fringilla vel'},"},
				{line:"{type:'$li',content:'Aenean sit amet erat nunc'},"},
				{line:"{type:'$li',content:'Eget porttitor lorem'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Ordered',
			description : 'A list of items in which the order does explicitly matter.',		
			staticCode:[
				{line:"{type:'$ol',children:["},
				{line:"{type:'$li',content:'Lorem ipsum dolor sit amet'},"},
				{line:"{type:'$li',content:'Consectetur adipiscing elit'},"},
				{line:"{type:'$li',content:'Integer molestie lorem at massa'},"},
				{line:"{type:'$li',content:'Facilisis in pretium nisl aliquet'},"},
				{line:"{type:'$li',content:'Nulla volutpat aliquam velit'},"},
				{line:"{type:'$li',content:'Faucibus porta lacus fringilla vel'},"},
				{line:"{type:'$li',content:'Aenean sit amet erat nunc'},"},
				{line:"{type:'$li',content:'Eget porttitor lorem'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Unstyled',
			description : 'Remove the default list style and left margin on list items by setting <code>'
						+ 'unstyled</code> to be <code>true</code>. <strong>This only applies to immediate '
						+ 'children list items</strong>, meaning you will need to add the class for any '
						+ 'nested lists as well.',		
			staticCode:[
				{line:"{type:'$ul',unstyled:true,children:["},
				{line:"{type:'$li',id:'li3',content:'Lorem ipsum dolor sit amet'},"},
				{line:"{type:'$li',content:'Consectetur adipiscing elit'},"},
				{line:"{type:'$li',content:'Integer molestie lorem at massa'},"},
				{line:"{type:'$li',content:'Facilisis in pretium nisl aliquet'},"},
				{line:"{type:'$li',content:'Nulla volutpat aliquam velit',children:["},
				{line:"{type:'$ul',children:["},
				{line:"{type:'$li',content:'Phasellus iaculis neque'},"},
				{line:"{type:'$li',content:'Purus sodales ultricies'},"},
				{line:"{type:'$li',content:'Vestibulum laoreet porttitor sem'},"},
				{line:"{type:'$li',content:'Ac tristique libero volutpat at'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$li',content:'Faucibus porta lacus fringilla vel'},"},
				{line:"{type:'$li',content:'Aenean sit amet erat nunc'},"},
				{line:"{type:'$li',content:'Eget porttitor lorem'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Inline',
			description : 'Place all list items on a single line by setting <code>inline</code> to'
						+ ' be <code>true</code>.',		
			staticCode:[
				{line:"{type:'$ul',inline:true,children:["},
				{line:"{type:'$li',content:'Lorem ipsum'},"},
				{line:"{type:'$li',content:'Phasellus iaculis '},"},
				{line:"{type:'$li',content:'Eget porttitor lorem'}"},
				{line:"]}"}
			]
		},
	];
	
	return data;
}

ClientMethod getDataTables() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$table, $tableBody, $tableHeader, $tableFooter, $tableRow, $tableColumn & $tableCell',
		headercontent:'Tables',
		link:'Twitter Bootstrap Tables documentation',
		linkAddress:'http://getbootstrap.com/css/#tables'
	};
	
	data.sections = [
	
		{
			/* --- --- */
			header : 'Basic example',	
			staticCode:[
				{line:"{type:'$table',id:'table1',caption:'Optional table caption',children:["},
				{line:"{type:'$tableHeader',key:'tHeader',children:["},
				{line:"{type:'$tableRow',id:'row1',children:["},
				{line:"{type:'$tableColumn',content:'#'},"},
				{line:"{type:'$tableColumn',id:'column1',content:'First Name'},"},
				{line:"{type:'$tableColumn',content:'Last Name'},"},
				{line:"{type:'$tableColumn',content:'Username'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$tableBody',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'1'},"},
				{line:"{type:'$tableCell',content:'Mark'},"},
				{line:"{type:'$tableCell',content:'Otto'},"},
				{line:"{type:'$tableCell',content:'@mdo'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'2'},"},
				{line:"{type:'$tableCell',content:'Jacob'},"},
				{line:"{type:'$tableCell',content:'Thornton'},"},
				{line:"{type:'$tableCell',content:'@fat'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'3'},"},
				{line:"{type:'$tableCell',content:'Larry'},"},
				{line:"{type:'$tableCell',content:'the Bird'},"},
				{line:"{type:'$tableCell',content:'@twitter'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Striped rows',
			description : 'Set <code>striped</code> to be <code>true</code> for <code>$table</code> to add '
						+ 'zebra-striping to any <code>$tableRow</code> within the <code>$tableBody</code>. ',		
			staticCode:[
				{line:"{type:'$table',striped:true,children:["},
				{line:"{type:'$tableHeader',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',content:'#'},"},
				{line:"{type:'$tableColumn',content:'First Name'},"},
				{line:"{type:'$tableColumn',content:'Last Name'},"},
				{line:"{type:'$tableColumn',content:'Username'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$tableBody',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'1'},"},
				{line:"{type:'$tableCell',content:'Mark'},"},
				{line:"{type:'$tableCell',content:'Otto'},"},
				{line:"{type:'$tableCell',content:'@mdo'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'2'},"},
				{line:"{type:'$tableCell',content:'Jacob'},"},
				{line:"{type:'$tableCell',content:'Thornton'},"},
				{line:"{type:'$tableCell',content:'@fat'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'3'},"},
				{line:"{type:'$tableCell',content:'Larry'},"},
				{line:"{type:'$tableCell',content:'the Bird'},"},
				{line:"{type:'$tableCell',content:'@twitter'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Bordered table',
			description : 'Set <code>bordered</code> to be <code>true</code> for borders on all sides of '
						+ 'the table and cells. ',		
			staticCode:[
				{line:"{type:'$table',bordered:true,children:["},
				{line:"{type:'$tableHeader',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',content:'#'},"},
				{line:"{type:'$tableColumn',content:'First Name'},"},
				{line:"{type:'$tableColumn',content:'Last Name'},"},
				{line:"{type:'$tableColumn',content:'Username'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$tableBody',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'1'},"},
				{line:"{type:'$tableCell',content:'Mark'},"},
				{line:"{type:'$tableCell',content:'Otto'},"},
				{line:"{type:'$tableCell',content:'@mdo'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'2'},"},
				{line:"{type:'$tableCell',content:'Jacob'},"},
				{line:"{type:'$tableCell',content:'Thornton'},"},
				{line:"{type:'$tableCell',content:'@fat'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'3'},"},
				{line:"{type:'$tableCell',content:'Larry'},"},
				{line:"{type:'$tableCell',content:'the Bird'},"},
				{line:"{type:'$tableCell',content:'@twitter'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Hover rows',
			description : 'Set <code>hover</code> to be <code>true</code> to enable a hover state on '
						+ '<code>$tableRow</code>s within the <code>$tableBody</code>. ',		
			staticCode:[
				{line:"{type:'$table',hover:true,children:["},
				{line:"{type:'$tableHeader',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',content:'#'},"},
				{line:"{type:'$tableColumn',content:'First Name'},"},
				{line:"{type:'$tableColumn',content:'Last Name'},"},
				{line:"{type:'$tableColumn',content:'Username'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$tableBody',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'1'},"},
				{line:"{type:'$tableCell',content:'Mark'},"},
				{line:"{type:'$tableCell',content:'Otto'},"},
				{line:"{type:'$tableCell',content:'@mdo'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'2'},"},
				{line:"{type:'$tableCell',content:'Jacob'},"},
				{line:"{type:'$tableCell',content:'Thornton'},"},
				{line:"{type:'$tableCell',content:'@fat'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'3'},"},
				{line:"{type:'$tableCell',content:'Larry'},"},
				{line:"{type:'$tableCell',content:'the Bird'},"},
				{line:"{type:'$tableCell',content:'@twitter'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Condensed table',
			description : 'Set <code>condensed</code> to be <code>true</code> to make tables more '
						+ 'compact by cutting cell padding in half.',		
			staticCode:[
				{line:"{type:'$table',condensed:true,children:["},
				{line:"{type:'$tableHeader',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',content:'#'},"},
				{line:"{type:'$tableColumn',content:'First Name'},"},
				{line:"{type:'$tableColumn',content:'Last Name'},"},
				{line:"{type:'$tableColumn',content:'Username'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$tableBody',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'1'},"},
				{line:"{type:'$tableCell',content:'Mark'},"},
				{line:"{type:'$tableCell',content:'Otto'},"},
				{line:"{type:'$tableCell',content:'@mdo'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'2'},"},
				{line:"{type:'$tableCell',content:'Jacob'},"},
				{line:"{type:'$tableCell',content:'Thornton'},"},
				{line:"{type:'$tableCell',content:'@fat'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'3'},"},
				{line:"{type:'$tableCell',content:'Larry'},"},
				{line:"{type:'$tableCell',content:'the Bird'},"},
				{line:"{type:'$tableCell',content:'@twitter'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Contextual classes',
			description : 'Use contextual classes as <code>theme</code> to color <code>$tableRow</code>s,'
						+ ' <code>$tableColumn</code>s or <code>$tableCell</code>s. ',		
			staticCode:[
				{line:"{type:'$table',children:["},
				{line:"{type:'$tableHeader',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',content:'Theme'},"},
				{line:"{type:'$tableColumn',content:'Description'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$tableBody',children:["},
				{line:"{type:'$tableRow',theme:'active',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'<code>active</code>'},"},
				{line:"{type:'$tableCell',content:'Applies the hover color to a particular row or cell'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',theme:'success',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'<code>success</code>'},"},
				{line:"{type:'$tableCell',content:'Indicates a successful or positive action'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',theme:'info',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'<code>info</code>'},"},
				{line:"{type:'$tableCell',content:'Indicates a neutral informative change or action'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',theme:'warning',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'<code>warning</code>'},"},
				{line:"{type:'$tableCell',content:'Indicates a warning that might need attention'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',theme:'danger',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'<code>danger</code>'},"},
				{line:"{type:'$tableCell',content:'Indicates a dangerous or potentially negative action'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Responsive tables',
			description : 'Create responsive tables by setting <code>responsive</code> to be <code>true</code> to make '
						+ 'them scroll horizontally on small devices (under 768px). When viewing on anything larger than'
						+ ' 768px wide, you will not see any difference in these tables.',		
			staticCode:[
				{line:"{type:'$table',responsive:true,children:["},
				{line:"{type:'$tableHeader',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',content:'#'},"},
				{line:"{type:'$tableColumn',content:'Table heading'},"},
				{line:"{type:'$tableColumn',content:'Table heading'},"},
				{line:"{type:'$tableColumn',content:'Table heading'},"},
				{line:"{type:'$tableColumn',content:'Table heading'},"},
				{line:"{type:'$tableColumn',content:'Table heading'},"},
				{line:"{type:'$tableColumn',content:'Table heading'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$tableBody',children:["},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'1'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'2'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'}"},
				{line:"]},"},
				{line:"{type:'$tableRow',children:["},
				{line:"{type:'$tableColumn',scope:'row',content:'3'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'},"},
				{line:"{type:'$tableCell',content:'Table cell'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
	];
	
	return data;
}

ClientMethod getDataForms() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$form & $formGroup',
		headercontent:'Forms',
		link:'Twitter Bootstrap Forms documentation',
		linkAddress:'http://getbootstrap.com/css/#forms'
	};
	
	data.sections = [
	
		{
			/* --- --- */
			header : 'Basic example',
			description : 'Individual <code>$input</code>s automatically receive some global styling. Apply the <code>label</code> '
						+ 'attribute and wrap them with <code>$formGroup</code> for optimum spacing.',			
			staticCode:[
				{line:"{type:'$form',id:'form1',children:["},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',id:'exampleInputEmail1',inputType:'email',placeholder:'Enter email',label:'Email address'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',id:'exampleInputPassword1',inputType:'password',placeholder:'Password',label:'Password'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',id:'exampleInputFile',inputType:'file',help:'Example block-level help text here.',label:'File input'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',id:'check1',inputType:'checkbox',value:'checked',content:'Check me out'}"},
				{line:"]},"},
				{line:"{type:'$button',buttonType:'submit',content:'Submit'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Inline form',
			description : 'Set <code>inline</code> to be <code>true</code> for left-aligned and inline-block controls. '
						+ '<strong>This only applies to forms within viewports that are at least 768px wide.</strong>',			
			staticCode:[
				{line:"{type:'$form',inline:true,children:["},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',id:'exampleName2',placeholder:'Intersystems',label:'Name'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',id:'exampleInputEmail2',inputType:'email',placeholder:'intersystems@example.com',label:'Email address'}"},
				{line:"]},"},
				{line:"{type:'$button',buttonType:'submit',content:'Send invitation'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			description : '<strong>Screen readers will have trouble with your forms if you don not include a <code>label</code> for every input.</strong>'
						+ '  For these inline forms, you can hide the labels by setting <code>hideLabel</code> to be <code>true</code>.',				
			staticCode:[
				{line:"{type:'$form',inline:true,children:["},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',hideLabel:true,id:'exampleInputEmail3',inputType:'email',placeholder:'Enter email',label:'Email address'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',hideLabel:true,id:'exampleInputPassword3',inputType:'password',placeholder:'Password',label:'Password'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',inputType:'checkbox',content:'Remember me'}"},
				{line:"]},"},
				{line:"{type:'$button',buttonType:'submit',content:'Sign in'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			description : 'Use <code>$inputGroup</code> within <code>$formGroup</code>',				
			staticCode:[
				{line:"{type:'$form',inline:true,children:["},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$inputGroup',hideLabel:true,label:'Amount (in dollors)',children:["},
				{line:"{type:'$inputGroupAddon',content:'$'},"},
				{line:"{type:'$input',id:'exampleInputAmount',placeholder:'Amount'},"},
				{line:"{type:'$inputGroupAddon',content:'.00'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$button',buttonType:'submit',theme:'primary',content:'Transfer cash'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Horizontal form',
			description : 'Set <code>horizontal</code> to be <code>true</code> for aligning labels and groups of form '
						+ 'controls in a horizontal layout.  Doing so changes <code>$formGroup</code> to behave as <code>'
						+ '$gridSystem</code>, so make sure to wrap every element with it including <code>$button</code>.  '
						+ 'Also set <code>offset</code> and <code>colSize</code>(by default it is<code>sm</code>) to '
						+ 'specify how many columns are hold for labels.',			
			staticCode:[
				{line:"{type:'$form',horizontal:true,children:["},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',offset:'2',id:'inputEmail3',inputType:'email',placeholder:'Email',label:'Email'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',offset:'2',hideLabel:true,id:'inputPassword3',inputType:'password',placeholder:'Password',label:'Password'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',offset:'2',inputType:'checkbox',content:'Remember me'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$button',offset:'2',buttonType:'submit',content:'Sign in'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Disabled state',
			description : 'Set <code>disabled</code> to be true on an <code>$input</code> to prevent user interactions. '
						+ 'Disabled inputs appear lighter and add a not-allowed cursor.',		
			staticCode:[
				{line:"{type:'$input',disabled:true,id:'disabledInput',placeholder:'Disabled input here...'}"},
			]
		},
		{
			/* --- --- */
			header : 'Disabled fieldsets',
			description : 'Add another level of <code>fieldset</code> and set its <code>disabled</code> attribute to be '
						+ '<code>true</code> to disable all the controls within it at once.',		
			staticCode:[
				{line:"{type:'$form',children:["},
				{line:"{type:'$fieldset',disabled:true,children:["},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',id:'disabledTextInput',placeholder:'Disabled input',label:'Disabled input'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',id:'disabledSelect',inputType:'select',label:'Disabled select menu',children:["},
				{line:"{type:'$option',content:'Disabled select'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',id:'disabledTextInput',inputType:'checkbox',content:'Can not check this'}"},
				{line:"]},"},
				{line:"{type:'$button',buttonType:'submit',theme:'primary',content:'Submit'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Readonly state',
			description : 'Set <code>readonly</code> to be true on an <code>$input</code> to prevent modification of the '
						+ 'input value. Read-only inputs appear lighter(just like disabled inputs), but retain the standard cursor.',		
			staticCode:[
				{line:"{type:'$input',readonly:true,id:'readonlyInput',placeholder:'Readonly input here...'}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Validation states',
			description : 'Bootstrap includes validation styles for error, warning, and success states on form controls. '
						+ 'To use, apply <code>warning</code>, <code>error</code>, or <code>success</code> as the <code>'
						+ 'validation</code> attribute of <code>$formGroup</code>. Any elements within it will receive'
						+ ' the validation styles.',		
			staticCode:[
				{line:"{type:'$form',children:["},
				{line:"{type:'$formGroup',validation:'success',children:["},
				{line:"{type:'$input',id:'inputSussess1',label:'Input with success'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',validation:'warning',children:["},
				{line:"{type:'$input',id:'inputWarning1',label:'Input with warning'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',validation:'error',children:["},
				{line:"{type:'$input',id:'inputError1',label:'Input with error'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',validation:'success',children:["},
				{line:"{type:'$input',id:'checkboxSuccess',inputType:'checkbox',content:'Checkbox with success',value:'option1'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',validation:'warning',children:["},
				{line:"{type:'$input',id:'checkboxWarning',inputType:'checkbox',content:'Checkbox with warning',value:'option1'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',validation:'error',children:["},
				{line:"{type:'$input',id:'checkboxError',inputType:'checkbox',content:'Checkbox with error',value:'option1'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Validation states with optional icons',
			description : 'You can also add optional feedback icons by setting <code>feedback</code> to be true with an'
						+ ' addition <code>feedbackIcon</code> for its <code>$input</code> or <code>$inputGroup</code> '
						+ 'child.  <strong class="text-danger">Feedback icons only work with <code>$input</code> elements'
						+ 'whose <code>inputType</code> is not <code>checkbox</code>,<code>radio</code>,'
						+ ' <code>file</code>, <code>button</code> or <code>submit</code></strong>.',		
			staticCode:[
				{line:"{type:'$form',children:["},
				{line:"{type:'$formGroup',id:'formGroup1',validation:'success',feedback:true,children:["},
				{line:"{type:'$input',id:'inputSussess2',feedbackIcon:'ok',label:'Input with success'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',validation:'warning',feedback:true,children:["},
				{line:"{type:'$input',id:'inputWarning2',feedbackIcon:'warning-sign',label:'Input with warning'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',validation:'error',feedback:true,children:["},
				{line:"{type:'$input',id:'inputError2',feedbackIcon:'remove',label:'Input with error'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',validation:'success',feedback:true,children:["},
				{line:"{type:'$inputGroup',id:'inputGroup2',feedbackIcon:'ok',label:'Input group with success',children:["},
				{line:"{type:'$inputGroupAddon',content:'@'},"},
				{line:"{type:'$input',id:'inputGroupSuccess2',ariaDescribe:'inputGroupSuccess1Status'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Validation states with optional icons in horizontal and inline forms',	
			staticCode:[
				{line:"{type:'$form',horizontal:true,children:["},
				{line:"{type:'$formGroup',validation:'success',feedback:true,children:["},
				{line:"{type:'$input',offset:'3',id:'inputSussess3',feedbackIcon:'ok',label:'Input with success'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',validation:'success',feedback:true,children:["},
				{line:"{type:'$inputGroup',offset:'3',feedbackIcon:'ok',label:'Input group with success',children:["},
				{line:"{type:'$inputGroupAddon',content:'@'},"},
				{line:"{type:'$input',id:'inputGroupSuccess3',ariaDescribe:'inputGroupSuccess1Status'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */	
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$form',inline:true,children:["},
				{line:"{type:'$formGroup',validation:'success',feedback:true,children:["},
				{line:"{type:'$input',id:'inputSussess4',feedbackIcon:'ok',label:'Input with success'}"},
				{line:"]}"},
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$form',inline:true,children:["},
				{line:"{type:'$formGroup',validation:'success',feedback:true,children:["},
				{line:"{type:'$inputGroup',feedbackIcon:'ok',label:'Input group with success',children:["},
				{line:"{type:'$inputGroupAddon',content:'@'},"},
				{line:"{type:'$input',id:'inputGroupSuccess4',ariaDescribe:'inputGroupSuccess1Status'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Validation states with optional icons and hiden labels',
			description : 'Set <code>hideLabel</code> to be <code>treu</code> for its <code>$input</code> or'
						+ ' <code>$inputGroup</code> child to hide the label of form control. ',		
			staticCode:[
				{line:"{type:'$form',children:["},
				{line:"{type:'$formGroup',validation:'success',feedback:true,children:["},
				{line:"{type:'$input',id:'inputSussess5',feedbackIcon:'ok',label:'Input with success'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',validation:'success',feedback:true,children:["},
				{line:"{type:'$inputGroup',feedbackIcon:'ok',label:'Input group with success',hideLabel:true,children:["},
				{line:"{type:'$inputGroupAddon',content:'@'},"},
				{line:"{type:'$input',id:'inputGroupSuccess5',ariaDescribe:'inputGroupSuccess1Status'}"},
				{line:"]}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Control sizing (height)',
			description : 'Create taller or shorter form controls that match button sizes by setting <code>size</code>'
						+ ' to be <code>lg</code> or <code>sm</code> for <code>$input</code> element.',		
			staticCode:[
				{line:"{type:'$form',children:["},
				{line:"{type:'$input',size:'lg',placeholder:'Large input'},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$input',placeholder:'Default input'},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$input',size:'sm',placeholder:'Small input'},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$input',inputType:'select',size:'lg',children:["},
				{line:"{type:'$option',content:'Large select'}"},
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$input',inputType:'select',children:["},
				{line:"{type:'$option',content:'Default select'}"},
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$input',inputType:'select',size:'sm',children:["},
				{line:"{type:'$option',content:'Small select'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Control sizing (horizontal)',
			description : 'Quickly size <code>$form</code> whose <code>horizontal</code> set to be '
						+ '<code>true</code> by applying <code>size</code> to its <code>$formGroup'
						+ '</code> <code>children</code>.',		
			staticCode:[
				{line:"{type:'$form',horizontal:true,children:["},
				{line:"{type:'$formGroup',size:'lg',children:["},
				{line:"{type:'$input',offset:'2',id:'formGroupInputLarge',placeholder:'Large input',label:'Large label'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',size:'sm',children:["},
				{line:"{type:'$input',offset:'2',id:'formGroupInputSmall',placeholder:'Small input',label:'Small label'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Control sizing (column)',
			description : 'Wrap inputs in <code>$gridSystem</code> and <code>$gridColumn</code> to easily enforce desired widths.',		
			staticCode:[
				{line:"{type:'$gridSystem',children:["},
				{line:"{type:'$gridColumn',xs:'2',children:["},
				{line:"{type:'$input',placeholder:'xs-2'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',xs:'3',children:["},
				{line:"{type:'$input',placeholder:'xs-3'}"},
				{line:"]},"},
				{line:"{type:'$gridColumn',xs:'4',children:["},
				{line:"{type:'$input',placeholder:'xs-4'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Help text',
			description : 'Block level help text for form controls by applying <code>help</code>',		
			staticCode:[
				{line:"{type:'$input',hideLabel:true,id:'inputHelpBlock',help:'A block of help text that breaks onto a new line and may extend beyond one line.'}"},
			]
		}
	];
	
	return data;
}

ClientMethod getDataInputs() [ Language = javascript ]
{
	
	var data = {
		widgetname:'$input',
		description : '<code>$input</code> is mostly used for text-based form control, inslucdes support for <strong>all'
					+ '</strong> HTML5 types: <code>text</code>, <code>password</code>, <code>datetime</code>, <code>datetime'
					+ '-local</code>, <code>date</code>, <code>month</code>, <code>time</code>, <code>week</code>, <code>'
					+ 'number</code>, <code>email</code>, <code>url</code>, <code>search</code>, <code>tel</code>, <code>color'
					+ '</code>, <code>textarea</code>, <code>select</code>, <code>checkbox</code> and <code>radio</code>.',
		headercontent:'Input',
		link:'Twitter Bootstrap Form controls documentation',
		linkAddress:'http://getbootstrap.com/css/#forms-controls'
	};
	
	data.sections = [
	
		{
			/* --- --- */
			header : 'Basic example',
			description : 'Inputs will only be fully styled if their <code>inputType</code> is properly declared'
						+ '(<code>text</code> by defualt).',			
			staticCode:[
				{line:"{type:'$input',key:'text1',placeholder:'Text input'}"},
			]
		},
		{
			/* --- --- */
			header : 'Textarea',
			description : 'Set <code>inputType</code> to be <code>textarea</code> to support multiple lines of text. '
						+ 'Change <code>rows</code> attribute as necessary(<code>3</code> by default).',			
			staticCode:[
				{line:"{type:'$input',inputType:'textarea',key:'textArea1',placeholder:'Textarea'}"},
			]
		},
		{
			/* --- --- */
			header : 'Checkboxes and radios (stacked)',
			description : 'Set <code>inputType</code> to be <code>checkbox</code> or <code>radio</code> for your purpose.'
						+ ' Checkboxes are for selecting one or several options in a list, while radios are for selecting'
						+ ' one option from many.',				
			staticCode:[
				{line:"{type:'$form',children:["},
				{line:"{type:'$input',inputType:'checkbox',content:'Option one is this and that-be sure to include why it is great',value:''},"},
				{line:"{type:'$input',inputType:'checkbox',content:'Option two is disabled',value:'',disabled:true},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$input',inputType:'radio',name:'optionsRadios',key:'optionsRadios1',content:'Option one is this and that-be sure to include why it is great',value:'option1',checked:true},"},
				{line:"{type:'$input',inputType:'radio',name:'optionsRadios',key:'optionsRadios2',content:'Option two can be something else and selecting it will deselect option one',value:'option2'},"},
				{line:"{type:'$input',inputType:'radio',name:'optionsRadios',key:'optionsRadios3',content:'Option three is disabled',value:'option3',disabled:true}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Checkboxes and radios (inline)',
			description : 'Set <code>inline</code> to be <code>true</code> on a series of checkboxes or radios for controls that appear on the same line.',				
			staticCode:[
				{line:"{type:'$containerFluid',children:["},
				{line:"{type:'$form',children:["},
				{line:"{type:'$input',inputType:'checkbox',key:'check1',inline:true,content:'1',value:'option1'},"},
				{line:"{type:'$input',inputType:'checkbox',inline:true,content:'2',value:'option2'},"},
				{line:"{type:'$input',inputType:'checkbox',inline:true,content:'3',value:'option3'}"},
				{line:"]},"},
				{line:"{type:'$break'},"},
				{line:"{type:'$form',children:["},
				{line:"{type:'$input',inputType:'radio',inline:true,name:'inlineRadios',key:'inlineRadios1',content:'1',value:'option1'},"},
				{line:"{type:'$input',inputType:'radio',inline:true,name:'inlineRadios',key:'inlineRadios2',content:'2',value:'option2'},"},
				{line:"{type:'$input',inputType:'radio',inline:true,name:'inlineRadios',key:'inlineRadios3',content:'3',value:'option3'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Checkboxes and radios (without label text)',
			description : 'Should you have no <code>content</code> within the <code>checkbox</code> or <code>radio</code>, '
						+ 'the <code>$input</code> is positioned as you would expect. <strong>Currently only works on non-'
						+ 'inline <code>checkbox</code> and <code>radio</code>.</strong> Remember to still provide some '
						+ 'form of label for assistive technologies (for instance, using <code>ariaLabel</code>).',				
			staticCode:[
				{line:"{type:'$form',children:["},
				{line:"{type:'$input',inputType:'checkbox',ariaLabel:'1',value:'option1'},"},
				{line:"{type:'$input',inputType:'radio',inline:true,name:'blankRadios',key:'blankRadios1',ariaLabel:'1',value:'option1'}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Selects',
			description : 'Set <code>inputType</code> to be <code>select</code> and use <code>$option</code>s as <code>children</code>',		
			staticCode:[
				{line:"{type:'$form',children:["},
				{line:"{type:'$input',key:'select1',inputType:'select',children:["},
				{line:"{type:'$option',content:'1'},"},
				{line:"{type:'$option',content:'2'},"},
				{line:"{type:'$option',content:'3'},"},
				{line:"{type:'$option',content:'4'},"},
				{line:"{type:'$option',content:'5'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */
			header : 'Selects (multiple)',
			description : 'For <code>select</code> controls with <code>multiple</code> attribute set to be <code>true</code>,'
						+ ' multiple options are shown by default.',		
			staticCode:[
				{line:"{type:'$form',children:["},
				{line:"{type:'$input',inputType:'select',multiple:true,children:["},
				{line:"{type:'$option',key:'option1',content:'1'},"},
				{line:"{type:'$option',key:'option2',content:'2'},"},
				{line:"{type:'$option',content:'3'},"},
				{line:"{type:'$option',content:'4'},"},
				{line:"{type:'$option',content:'5'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		
		{
			/* --- --- */
			header : 'Static control',
			description : 'When you need to place plain text next to a form label within a form, set '
						+ '<code>inputType</code> to be <code>static</code>',		
			staticCode:[
				{line:"{type:'$form',horizontal:true,children:["},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',offset:'2',key:'static1',inputType:'static',content:'intersystems@example.com',label:'Email'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',offset:'2',key:'inputPassword',inputType:'password',placeholder:'Password',label:'Password'}"},
				{line:"]}"},
				{line:"]}"}
			]
		},
		{
			/* --- --- */		
			staticCode:[
				{line:"{type:'$form',inline:true,children:["},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',key:'static',hideLabel:true,inputType:'static',content:'intersystems@example.com',label:'Email address'}"},
				{line:"]},"},
				{line:"{type:'$formGroup',children:["},
				{line:"{type:'$input',key:'pass1',hideLabel:true,id:'inputPassword2',inputType:'password',placeholder:'Password',label:'Password'}"},
				{line:"]},"},
				{line:"{type:'$button',buttonType:'submit',content:'Confirm identity'}"},
				{line:"]}"}
			]
		},
	];
	
	return data;
}

}
