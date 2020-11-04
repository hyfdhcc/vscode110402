Class %ZEN.Mojo.WidgetReference.highCharts401Template Extends %ZEN.Mojo.WidgetReference.jQM132BaseTemplate
{

Property eventHeader As %String [ InitialExpression = "Default Event Handling" ];

ClientMethod dataHeader(chart) [ Language = javascript ]
{
	return 'Data-driven ' + chart.charAt(0).toUpperCase() + chart.slice(1)
}

ClientMethod dataDescription(chart) [ Language = javascript ]
{
	return 'Define a '+this.addBoldTag('$'+chart)+' layout object and set its size using the '+this.addBoldTag('height')+' and '
			+this.addBoldTag('width')+' attributes or CSS styling with the '+this.addBoldTag('style')+' attribute. The chart is '
			+'driven by the provided '+this.addBoldTag('options')+' object.'
}

ClientMethod eventDescription() [ Language = javascript ]
{
	return 'Every HighCharts layout object created in Zen Mojo is assigned default event handlers for clicking. '
			+ 'When a Highchart is clicked or tapped, the '+this.addBoldTag('key')+' of the chart and a '+this.addBoldTag('value')
			+ ' object are passed to the '+this.addBoldTag('onselect')+' method. If a point is clicked, the value object will consist of the '
			+ this.addBoldTag('seriesIndex')+' and the '+this.addBoldTag('dataIndex')+' of the selected point. If the '
			+ 'chart background is clicked, the value object will consist of the '+this.addBoldTag('chartX')+' and '
			+ this.addBoldTag('chartY')+' of the click location.<br>'
			+ 'These default events can be overwritten in the '+this.addBoldTag('options')+' attribute.<br>'
			+ 'Within the '+this.addBoldTag('onselect')+' method of this page, there is event logic defined for layout objects '
			+ 'with the key \'eventchart\' . This is responsible for the behavior of the chart below.'
}

ClientMethod onselect(key, value, docViewId) [ Language = javascript ]
{
	this.invokeSuper('onselect',arguments);

 	var view = zen(docViewId);
 	var realKey = key.split(':')[0];
 	switch(realKey) {
	 	
	 	case 'eventchart':
	 		var chart = view.getItemByKey(key).getChart();
	 		if (value.seriesIndex > -1 && value.dataIndex > -1) {
	 			var label = chart.renderer.label(
	 				'Series name: '+chart.series[value.seriesIndex].name+', dataIndex: '+value.dataIndex,
	 				0,50).attr({fill:Highcharts.getOptions().colors[0], padding:10, r:5, zIndex:8}).css({color:'#FFFFFF'}).add();
	 			setTimeout(function() {label.fadeOut();},2000);
	 		} else {
	 			var label = chart.renderer.label(
	 				'chartX: ' + Highcharts.numberFormat(value.chartX,2) + ', chartY: ' + Highcharts.numberFormat(value.chartY,2),
	 				value.chartX,value.chartY).attr({fill:Highcharts.getOptions().colors[1], padding:10, r:5, zIndex:8}).css({color:'#FFFFFF'}).add();
	 			setTimeout(function() {label.fadeOut();},2000);
	 		}
	 		break;
	 		
	 	case 'eventgaugechart':
	 		var chart = view.getItemByKey(key).getChart();
	 		var point = chart.series[0].points[0]
	 		var newValue = Math.round(Math.random()*200)
	 		point.update(newValue);
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
				referenceTitle:'HighCharts.js 4.0.1 Widget reference',
				referenceDescription:'Test drive a handful of components in the library, and easily build pages by copying and pasting the markup configuration you need. '
									+'For commercial use, a license must be purchased from Highsoft.',
				linkAddress:'http://api.highcharts.com/highcharts',
				link:'Highcharts documentation',
				widgets:[
					{widgetname:'$areachart',widgetOriginalName:'Area Chart',widgetvalue:'area'},
					{widgetname:'$barchart',widgetOriginalName:'Bar Chart',widgetvalue:'bar'},
					{widgetname:'$bubblechart',widgetOriginalName:'Bubble Chart (highcharts-more.js)',widgetvalue:'bubble'},
					{widgetname:'$columnchart',widgetOriginalName:'Column Chart',widgetvalue:'column'},
					{widgetname:'$gaugechart',widgetOriginalName:'Gauge Chart (highcharts-more.js)',widgetvalue:'gauge'},
					{widgetname:'$linechart',widgetOriginalName:'Line Chart (static example)',widgetvalue:'line'},
					{widgetname:'$piechart',widgetOriginalName:'Pie Chart',widgetvalue:'pie'},
					{widgetname:'$scatterchart',widgetOriginalName:'Scatter Plot Chart',widgetvalue:'scatter'},
					{widgetname:'$splinechart',widgetOriginalName:'Spline Chart',widgetvalue:'spline'},
				]};
	
			break;
			
		case 'area':
			data = this.getDataAreaChart();
			break;
		
		case 'bar':
			data = this.getDataBarChart();
			break;
			
		case 'bubble':
			data = this.getDataBubbleChart();
			break;
		
		case 'column':
			data = this.getDataColumnChart();
			break;
		
		case 'gauge':
			data = this.getDataGaugeChart();
			break;
		
		case 'line':
			data = this.getDataLineChart();
			break;
		
		case 'pie':
			data = this.getDataPieChart();
			break;
		
		case 'scatter':
			data = this.getDataScatterChart();
			break;
		
		case 'spline':
			data = this.getDataSplineChart();
			break;
	}
	return data;
}

ClientMethod getDataEmptyChart() [ Language = javascript ]
{
	var chart = '???';
	
	var data = {
		widgetname:'??? Chart',
		description:'Description',
		headercontent:'Using $' + chart,
		link:'High Charts ??? Chart documentation',
		linkAddress:'http://api.highcharts.com/highcharts#plotOptions.???'
	};
	
	data.sections = [
	{
		/* --- --- */
		header : '',
		description : '',
		
		dynamicCode:[
			{line:"{type:'$chart',key:'eventchart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			
			{line:"}"},
			{line:"}"},
		]
	},
	];
	
	return data;
}

ClientMethod getDataAreaChart() [ Language = javascript ]
{
	var chart = 'areachart';
	
	var data = {
		widgetname:'Area Chart',
		description : 'A line chart is a way of plotting data points on a line. Often, it is used to show trend data, and the comparison of two data sets.\r'
					+ 'An area chart is simply a line chart with the area between the data and zero shaded to draw attention to the area below (or above) the curve.',
		headercontent:'Using $' + chart,
		link:'High Charts Area Chart documentation',
		linkAddress:'http://api.highcharts.com/highcharts#plotOptions.area'
	};
	
	data.sections = [
	{
		/* --- --- */
		header : this.dataHeader(chart),
		description : this.dataDescription(chart),
		
		dynamicCode:[
			{line:"{type:'$areachart',key:'chart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
        {line:"title: {"},
            {line:"text: 'US and USSR nuclear stockpiles'"},
        {line:"},"},
        {line:"yAxis: {"},
            {line:"title: {"},
                {line:"text: 'Nuclear weapon states'"},
            {line:"}"},
        {line:"},"},
        {line:"plotOptions: {"},
            {line:"area: {"},
                {line:"pointStart: 1940"},
            {line:"}"},
        {line:"},"},
        {line:"series: [{"},
            {line:"name: 'USA',"},
            {line:"data: [null, null, null, null, null, 6, 11, 32, 110, 235, 369, 640,"},
                {line:" 1005, 1436, 2063, 3057, 4618, 6444, 9822, 15468, 20434, 24126,"},
                {line:" 27387, 29459, 31056, 31982, 32040, 31233, 29224, 27342, 26662,"},
                {line:" 26956, 27912, 28999, 28965, 27826, 25579, 25722, 24826, 24605,"},
                {line:" 24304, 23464, 23708, 24099, 24357, 24237, 24401, 24344, 23586,"},
                {line:" 22380, 21004, 17287, 14747, 13076, 12555, 12144, 11009, 10950,"},
                {line:" 10871, 10824, 10577, 10527, 10475, 10421, 10358, 10295, 10104]"},
        {line:"}, {"},
            {line:"name: 'USSR/Russia',"},
            {line:"data: [null, null, null, null, null, null, null, null, null, null,"},
                {line:" 5, 25, 50, 120, 150, 200, 426, 660, 869, 1060, 1605, 2471, 3322,"},
                {line:" 4238, 5221, 6129, 7089, 8339, 9399, 10538, 11643, 13092, 14478,"},
                {line:" 15915, 17385, 19055, 21205, 23044, 25393, 27935, 30062, 32049,"},
                {line:" 33952, 35804, 37431, 39197, 45000, 43000, 41000, 39000, 37000,"},
                {line:" 35000, 33000, 31000, 29000, 27000, 25000, 24000, 23000, 22000,"},
                {line:" 21000, 20000, 19000, 18000, 18000, 17000, 16000]"},
        {line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	
	{
		/* --- --- */
		header : this.eventHeader,
		description : this.eventDescription(),
		
		dynamicCode:[
			{line:"{type:'$areachart',key:'eventchart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
        {line:"title: {"},
            {line:"text: 'US and USSR nuclear stockpiles'"},
        {line:"},"},
        {line:"subtitle: {"},
            {line:"text: 'Source - thebulletin.metapress.com'"},
        {line:"},"},
        {line:"xAxis: {"},
            {line:"allowDecimals: false"},
            //{line:"labels: {"},
                //{line:"formatter: function () { return this.value;}"},
            //{line:"}"},
        {line:"},"},
        {line:"yAxis: {"},
            {line:"title: {"},
                {line:"text: 'Nuclear weapon states'"},
            {line:"}"},
            //{line:"labels: {"},
                //{line:"formatter:" + function () { return this.value / 1000 + 'k';}},
            //{line:"}"},
        {line:"},"},
        //{line:"tooltip: {"},
            //{line:"pointFormat: '{ series.name } produced <b>{ point.y }</b><br/>warheads in { point.x }'"},
        //{line:"},"},
        {line:"plotOptions: {"},
            {line:"area: {"},
                {line:"pointStart: 1940,"},
                {line:"marker: {"},
                    {line:"enabled: false,"},
                    {line:"symbol: 'circle',"},
                    {line:"radius: 2,"},
                    {line:"states: {"},
                        {line:"hover: {"},
                            {line:"enabled: true"},
                        {line:"}"},
                    {line:"}"},
                {line:"}"},
            {line:"}"},
        {line:"},"},
        {line:"series: [{"},
            {line:"name: 'USA',"},
            {line:"data: [null, null, null, null, null, 6, 11, 32, 110, 235, 369, 640,"},
                {line:" 1005, 1436, 2063, 3057, 4618, 6444, 9822, 15468, 20434, 24126,"},
                {line:" 27387, 29459, 31056, 31982, 32040, 31233, 29224, 27342, 26662,"},
                {line:" 26956, 27912, 28999, 28965, 27826, 25579, 25722, 24826, 24605,"},
                {line:" 24304, 23464, 23708, 24099, 24357, 24237, 24401, 24344, 23586,"},
                {line:" 22380, 21004, 17287, 14747, 13076, 12555, 12144, 11009, 10950,"},
                {line:" 10871, 10824, 10577, 10527, 10475, 10421, 10358, 10295, 10104]"},
        {line:"}, {"},
            {line:"name: 'USSR/Russia',"},
            {line:"data: [null, null, null, null, null, null, null, null, null, null,"},
                {line:" 5, 25, 50, 120, 150, 200, 426, 660, 869, 1060, 1605, 2471, 3322,"},
                {line:" 4238, 5221, 6129, 7089, 8339, 9399, 10538, 11643, 13092, 14478,"},
                {line:" 15915, 17385, 19055, 21205, 23044, 25393, 27935, 30062, 32049,"},
                {line:" 33952, 35804, 37431, 39197, 45000, 43000, 41000, 39000, 37000,"},
                {line:" 35000, 33000, 31000, 29000, 27000, 25000, 24000, 23000, 22000,"},
                {line:" 21000, 20000, 19000, 18000, 18000, 17000, 16000]"},
        {line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	];
	
	return data;
}

ClientMethod getDataBarChart() [ Language = javascript ]
{
	var chart = 'barchart';
	
	var data = {
		widgetname:'Bar Chart',
		description:'A bar chart is a way of showing data as bars. It is sometimes used to show trend data, and the comparison of multiple data sets side by side.',
		headercontent:'Using $' + chart,
		link:'High Charts Bar Chart documentation',
		linkAddress:'http://api.highcharts.com/highcharts#plotOptions.bar'
	};
	
	data.sections = [
	{
		/* --- --- */
		header : this.dataHeader(chart),
		description : this.dataDescription(chart),
		
		dynamicCode:[
			{line:"{type:'$barchart',key:'chart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},	
			{line:"title: {"},
			{line:"text: 'Historic World Population by Region'"},
			{line:"},"},
			{line:"subtitle: {"},
			{line:"text: 'Source - Wikipedia.org'"},
			{line:"},"},
			{line:"xAxis: {"},
			{line:"categories: ['Africa', 'America', 'Asia', 'Europe', 'Oceania']"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"min: 0,"},
			{line:"title: {"},
			{line:"text: 'Population (millions)'"},
			{line:"}"},
			{line:"},"},
			{line:"tooltip: {"},
			{line:"valueSuffix: ' millions'"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Year 1800',"},
			{line:"data: [107, 31, 635, 203, 2]"},
			{line:"}, {"},
			{line:"name: 'Year 1900',"},
			{line:"data: [133, 156, 947, 408, 6]"},
			{line:"}, {"},
			{line:"name: 'Year 2008',"},
			{line:"data: [973, 914, 4054, 732, 34]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	
	{
		/* --- --- */
		header : this.eventHeader,
		description : this.eventDescription(),
		
		dynamicCode:[
			{line:"{type:'$barchart',key:'eventchart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},	
			{line:"title: {"},
			{line:"text: 'Historic World Population by Region'"},
			{line:"},"},
			{line:"subtitle: {"},
			{line:"text: 'Source - Wikipedia.org'"},
			{line:"},"},
			{line:"xAxis: {"},
			{line:"categories: ['Africa', 'America', 'Asia', 'Europe', 'Oceania'],"},
			{line:"title: {"},
			{line:"text: null"},
			{line:"}"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"min: 0,"},
			{line:"title: {"},
			{line:"text: 'Population (millions)',"},
			{line:"align: 'high'"},
			{line:"},"},
			{line:"labels: {"},
			{line:"overflow: 'justify'"},
			{line:"}"},
			{line:"},"},
			{line:"tooltip: {"},
			{line:"valueSuffix: ' millions'"},
			{line:"},"},
			{line:"plotOptions: {"},
			{line:"bar: {"},
			{line:"dataLabels: {"},
			{line:"enabled: true"},
			{line:"}"},
			{line:"}"},
			{line:"},"},
			{line:"legend: {"},
			{line:"layout: 'vertical',"},
			{line:"align: 'right',"},
			{line:"verticalAlign: 'top',"},
			{line:"x: -40,"},
			{line:"y: 100,"},
			{line:"floating: true,"},
			{line:"borderWidth: 1,"},
			//{line:"backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),"},
			{line:"backgroundColor: '#FFFFFF',"},
			{line:"shadow: true"},
			{line:"},"},
			{line:"credits: {"},
			{line:"enabled: false"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Year 1800',"},
			{line:"data: [107, 31, 635, 203, 2]"},
			{line:"}, {"},
			{line:"name: 'Year 1900',"},
			{line:"data: [133, 156, 947, 408, 6]"},
			{line:"}, {"},
			{line:"name: 'Year 2008',"},
			{line:"data: [973, 914, 4054, 732, 34]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	];
	
	return data;
}

ClientMethod getDataBubbleChart() [ Language = javascript ]
{
	var chart = 'bubblechart';
	
	var data = {
		widgetname:'Bubble Chart',
		description: 'A bubble chart is a way of displaying 3 or 4 dimensional data. These dimensions are represented by the x coordinate, y coordinate, size, and color of the bubble. '
					+'Bubble charts require that highcharts-more.js also be included.',
		headercontent:'Using $' + chart,
		link:'High Charts Bubble Chart documentation',
		linkAddress:'http://api.highcharts.com/highcharts#plotOptions.bubble'
	};
	
	data.sections = [
	{
		/* --- --- */
		header : this.dataHeader(chart),
		description : this.dataDescription(chart),
		
		dynamicCode:[
			{line:"{type:'$bubblechart',key:'chart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"title: {"},
			{line:"text: 'Highcharts Bubbles'"},
			{line:"},"},
			{line:"series: [{"},
			{line:"data: [[97, 36, 79], [94, 74, 60], [68, 76, 58], [64, 87, 56], [68, 27, 73], [74, 99, 42], [7, 93, 87], [51, 69, 40], [38, 23, 33], [57, 86, 31]]"},
			{line:"}, {"},
			{line:"data: [[25, 10, 87], [2, 75, 59], [11, 54, 8], [86, 55, 93], [5, 3, 58], [90, 63, 44], [91, 33, 17], [97, 3, 56], [15, 67, 48], [54, 25, 81]]"},
			{line:"}, {"},
			{line:"data: [[47, 47, 21], [20, 12, 4], [6, 76, 91], [38, 30, 60], [57, 98, 64], [61, 17, 80], [83, 60, 13], [67, 78, 75], [64, 12, 10], [30, 77, 82]]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	
	{
		/* --- --- */
		header : this.eventHeader,
		description : this.eventDescription(),
		
		dynamicCode:[
			{line:"{type:'$bubblechart',key:'eventchart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"chart: {"},
			{line:"zoomType: 'xy'"},
			{line:"},"},
			{line:"title: {"},
			{line:"text: 'Highcharts Bubbles'"},
			{line:"},"},
			{line:"series: [{"},
			{line:"data: [[97, 36, 79], [94, 74, 60], [68, 76, 58], [64, 87, 56], [68, 27, 73], [74, 99, 42], [7, 93, 87], [51, 69, 40], [38, 23, 33], [57, 86, 31]]"},
			{line:"}, {"},
			{line:"data: [[25, 10, 87], [2, 75, 59], [11, 54, 8], [86, 55, 93], [5, 3, 58], [90, 63, 44], [91, 33, 17], [97, 3, 56], [15, 67, 48], [54, 25, 81]]"},
			{line:"}, {"},
			{line:"data: [[47, 47, 21], [20, 12, 4], [6, 76, 91], [38, 30, 60], [57, 98, 64], [61, 17, 80], [83, 60, 13], [67, 78, 75], [64, 12, 10], [30, 77, 82]]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	];
	
	return data;
}

ClientMethod getDataColumnChart() [ Language = javascript ]
{
	var chart = 'columnchart';
	
	var data = {
		widgetname:'Column Chart',
		description:'A column chart is a way of showing data as vertical bars. It is sometimes used to show trend data, and the comparison of multiple data sets side by side.',
		headercontent:'Using $' + chart,
		link:'High Charts Column Chart documentation',
		linkAddress:'http://api.highcharts.com/highcharts#plotOptions.column'
	};
	
	data.sections = [
	{
		/* --- --- */
		header : this.dataHeader(chart),
		description : this.dataDescription(chart),

		dynamicCode:[
			{line:"{type:'$columnchart',key:'chart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"title: {"},
			{line:"text: 'Monthly Average Rainfall'"},
			{line:"},"},
			{line:"subtitle: {"},
			{line:"text: 'Source - WorldClimate.com'"},
			{line:"},"},
			{line:"xAxis: {"},
			{line:"categories: ['Jan','Feb','Mar','Apr','May','Jun',"},
			{line:"'Jul','Aug','Sep','Oct','Nov','Dec']"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"min: 0,"},
			{line:"title: {"},
			{line:"text: 'Rainfall (mm)'"},
			{line:"}"},
			{line:"},"},
			{line:"tooltip: {"},
			{line:"shared: true"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Tokyo',"},
			{line:"data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]"},
			{line:"}, {"},
			{line:"name: 'New York',"},
			{line:"data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]"},
			{line:"}, {"},
			{line:"name: 'London',"},
			{line:"data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]"},
			{line:"}, {"},
			{line:"name: 'Berlin',"},
			{line:"data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	
	{
		/* --- --- */
		header : this.eventHeader,
		description : this.eventDescription(),

		dynamicCode:[
			{line:"{type:'$columnchart',key:'eventchart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"title: {"},
			{line:"text: 'Monthly Average Rainfall'"},
			{line:"},"},
			{line:"subtitle: {"},
			{line:"text: 'Source - WorldClimate.com'"},
			{line:"},"},
			{line:"xAxis: {"},
			{line:"categories: ['Jan','Feb','Mar','Apr','May','Jun',"},
			{line:"'Jul','Aug','Sep','Oct','Nov','Dec']"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"min: 0,"},
			{line:"title: {"},
			{line:"text: 'Rainfall (mm)'"},
			{line:"}"},
			{line:"},"},
			{line:"tooltip: {"},
			//{line:"headerFormat: '<span style="font-size:10px">{point.key}</span><table>',"},
			//{line:"pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +"},
			//{line:"'<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',"},
			//{line:"footerFormat: '</table>',"},
			{line:"shared: true"},
			//{line:"useHTML: true"},
			{line:"},"},
			{line:"plotOptions: {"},
			{line:"column: {"},
			{line:"pointPadding: 0.2,"},
			{line:"borderWidth: 0"},
			{line:"}"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Tokyo',"},
			{line:"data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]"},
			{line:"}, {"},
			{line:"name: 'New York',"},
			{line:"data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]"},
			{line:"}, {"},
			{line:"name: 'London',"},
			{line:"data: [48.9, 38.8, 39.3, 41.4, 47.0, 48.3, 59.0, 59.6, 52.4, 65.2, 59.3, 51.2]"},
			{line:"}, {"},
			{line:"name: 'Berlin',"},
			{line:"data: [42.4, 33.2, 34.5, 39.7, 52.6, 75.5, 57.4, 60.4, 47.6, 39.1, 46.8, 51.1]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	];
	
	return data;
}

ClientMethod getDataGaugeChart() [ Language = javascript ]
{
	var chart = 'gaugechart';
	
	var data = {
		widgetname:'Gauge Chart',
		description: 'A gauge chart provides quick visualization of a single, changing data point. '
					+'Gauge charts require that highcharts-more.js also be included.',
		headercontent:'Using $' + chart,
		link:'High Charts Gauge Chart documentation',
		linkAddress:'http://api.highcharts.com/highcharts#plotOptions.gauge'
	};
	
	data.sections = [
	{
		/* --- --- */
		header : this.dataHeader(chart),
		description : this.dataDescription(chart) + '<br>'
					+ 'Click on the chart to change the speed.',
		
		dynamicCode:[
			{line:"{type:'$gaugechart',key:'eventgaugechart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"title: {"},
			{line:"text: 'Speedometer'"},
			{line:"},"},
			{line:"pane: {"},
			{line:"startAngle: -150,"},
			{line:"endAngle: 150"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"min: 0,"},
			{line:"max: 200,"},
			{line:"minorTickInterval: 'auto',"},
			{line:"minorTickColor: '#666',"},
			{line:"tickPixelInterval: 30,"},
			{line:"tickColor: '#666',"},
			{line:"title: {"},
			{line:"text: 'km/h'"},
			{line:"}"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Speed',"},
			{line:"data: [80],"},
			{line:"tooltip: {"},
			{line:"valueSuffix: ' km/h'"},
			{line:"}"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	
	{
		/* --- --- */
		header : this.eventHeader,
		description : this.eventDescription(),
		
		dynamicCode:[
			{line:"{type:'$gaugechart',key:'eventchart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"chart: {"},
			{line:"plotBackgroundColor: null,"},
			{line:"plotBackgroundImage: null,"},
			{line:"plotBorderWidth: 0,"},
			{line:"plotShadow: false"},
			{line:"},"},
			{line:"title: {"},
			{line:"text: 'Speedometer'"},
			{line:"},"},
			{line:"pane: {"},
			{line:"startAngle: -150,"},
			{line:"endAngle: 150,"},
			{line:"background: [{"},
			{line:"backgroundColor: {"},
			{line:"linearGradient: {x1:0,y1:0,x2:0,y2:1 },"},
			{line:"stops: ["},
			{line:"[0, '#FFF'],"},
			{line:"[1, '#333']"},
			{line:"]"},
			{line:"},"},
			{line:"borderWidth: 0,"},
			{line:"outerRadius: '109%'"},
			{line:"}, {"},
			{line:"backgroundColor: {"},
			{line:"linearGradient: {x1:0,y1:0,x2:0,y2:1 },"},
			{line:"stops: ["},
			{line:"[0, '#333'],"},
			{line:"[1, '#FFF']"},
			{line:"]"},
			{line:"},"},
			{line:"borderWidth: 1,"},
			{line:"outerRadius: '107%'"},
			{line:"}, {"},
			{line:"}, {"},
			{line:"backgroundColor: '#DDD',"},
			{line:"borderWidth: 0,"},
			{line:"outerRadius: '105%',"},
			{line:"innerRadius: '103%'"},
			{line:"}]"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"min: 0,"},
			{line:"max: 200,"},
			{line:"minorTickInterval: 'auto',"},
			{line:"minorTickWidth: 1,"},
			{line:"minorTickLength: 10,"},
			{line:"minorTickPosition: 'inside',"},
			{line:"minorTickColor: '#666',"},
			{line:"tickPixelInterval: 30,"},
			{line:"tickWidth: 2,"},
			{line:"tickPosition: 'inside',"},
			{line:"tickLength: 10,"},
			{line:"tickColor: '#666',"},
			{line:"labels: {"},
			{line:"step: 2,"},
			{line:"rotation: 'auto'"},
			{line:"},"},
			{line:"title: {"},
			{line:"text: 'km/h'"},
			{line:"},"},
			{line:"plotBands: [{"},
			{line:"from: 0,"},
			{line:"to: 120,"},
			{line:"color: '#55BF3B'"},
			{line:"}, {"},
			{line:"from: 120,"},
			{line:"to: 160,"},
			{line:"color: '#DDDF0D'"},
			{line:"}, {"},
			{line:"from: 160,"},
			{line:"to: 200,"},
			{line:"color: '#DF5353'"},
			{line:"}]"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Speed',"},
			{line:"data: [80],"},
			{line:"tooltip: {"},
			{line:"valueSuffix: ' km/h'"},
			{line:"}"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	];
	
	return data;
}

ClientMethod getDataLineChart() [ Language = javascript ]
{
	var chart = 'linechart';
	
	var data = {
		widgetname:'Line Chart',
		description:'A line chart is a way of plotting data points on a line. Often, it is used to show trend data, and the comparison of two data sets.',
		headercontent:'Using $' + chart,
		link:'HighCharts.js Line Chart documentation',
		linkAddress:'http://api.highcharts.com/highcharts#plotOptions.line'
	};
	
	data.sections = [
	{
		/* --- --- */
		header : this.dataHeader(chart),
		description : this.dataDescription(chart),

		dynamicCode:[
			{line:"{type:'$linechart',key:'chart1',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"title: {text: 'Monthly Average Temperature'},"},
			{line:"subtitle: {text: 'Source - WorldClimate.com'},"},
			{line:"xAxis: {"},
			{line:"categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',"},
			{line:"'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"title: {text: 'Temperature (\u00B0C)'}"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Tokyo',"},
			{line:"data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]"},
			{line:"}, {"},
			{line:"name: 'New York',"},
			{line:"data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]"},
			{line:"}, {"},
			{line:"name: 'Berlin',"},
			{line:"data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]"},
			{line:"}, {"},
			{line:"name: 'London',"},
			{line:"data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	
	{
		/* --- --- */
		header : 'Static Linechart',
		description : 'The same chart can be created using the highCharts401Helper\'s built-in attributes: '
					+ this.addBoldTag('title')+' '+this.addBoldTag('subtitle')+' '+this.addBoldTag('xAxis')+' '
					+ this.addBoldTag('yAxis')+' '+this.addBoldTag('seriesNames')+' and '+this.addBoldTag('series')
					+'. However, the options object will give you access to the entire High Charts API.',
		
		dynamicCode:[
			{line:"{type:'$linechart',key:'chart2',width:'100%',height:'400px',"},
			{line:"title:'Monthly Average Temperature',"},
			{line:"subtitle:'Source - WorldClimate.com',"},
			{line:"xAxis:['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',"},
			{line:"'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],"},
			{line:"yAxis:'Temperature (\u00B0C)',"},
			{line:"seriesNames:['Tokyo','New York','Berlin','London'],"},
			{line:"series:["},
			{line:"[7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6],"},
			{line:"[-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5],"},
			{line:"[-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0],"},
			{line:"[3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]"},
			{line:"]}"},
		],
	},
	
	{
		/* --- --- */
		header : this.eventHeader,
		description : this.eventDescription(),
		
		dynamicCode:[
			{line:"{type:'$linechart',key:'eventchart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"title: {"},
			{line:"text: 'Monthly Average Temperature',"},
			{line:"x: -20"},
			{line:"},"},
			{line:"subtitle: {"},
			{line:"text: 'Source - WorldClimate.com',"},
			{line:"x: -20"},
			{line:"},"},
			{line:"xAxis: {"},
			{line:"categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',"},
			{line:"'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"title: {"},
			{line:"text: 'Temperature (\u00B0C)'"},
			{line:"},"},
			{line:"plotLines: [{"},
			{line:"value: 0,"},
			{line:"width: 1,"},
			{line:"color: '#808080'"},
			{line:"}]"},
			{line:"},"},
			{line:"tooltip: {"},
			{line:"valueSuffix: '\u00B0C'"},
			{line:"},"},
			{line:"legend: {"},
			{line:"layout: 'vertical',"},
			{line:"align: 'right',"},
			{line:"verticalAlign: 'middle',"},
			{line:"borderWidth: 0"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Tokyo',"},
			{line:"data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6],"},
			{line:"color: '#f7a35c'"},
			{line:"}, {"},
			{line:"name: 'New York',"},
			{line:"data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5],"},
			{line:"color: '#90ed7d'"},
			{line:"}, {"},
			{line:"name: 'Berlin',"},
			{line:"data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0],"},
			{line:"color: '#434348'"},
			{line:"}, {"},
			{line:"name: 'London',"},
			{line:"data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8],"},
			{line:"color: '#7cb5ec'"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	
	
	];
	
	return data;
}

ClientMethod getDataPieChart() [ Language = javascript ]
{
	var chart = 'piechart';
	
	var data = {
		widgetname:'Pie Chart',
		description:'Pie and doughnut charts are probably the most commonly used chart there are. They are divided into segments,'
					+'the arc of each segment shows a the proportional value of each piece of data. They are excellent at showing '
					+'the relational proportions between data.',
		headercontent:'Using $' + chart,
		link:'High Charts Pie Chart documentation',
		linkAddress:'http://api.highcharts.com/highcharts#plotOptions.pie'
	};
	
	data.sections = [
	{
		/* --- --- */
		header : this.dataHeader(chart),
		description : this.dataDescription(chart),
		
		dynamicCode:[
			{line:"{type:'$piechart',key:'chart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"title: {"},
			{line:"text: 'Browser market shares at a specific website, 2014'"},
			{line:"},"},
			{line:"series: [{"},
			{line:"type: 'pie',"},
			{line:"name: 'Browser share',"},
			{line:"data: ["},
			{line:"['Firefox',   45.0],"},
			{line:"['IE',       26.8],"},
			{line:"{"},
			{line:"name: 'Chrome',"},
			{line:"y: 12.8,"},
			{line:"sliced: true,"},
			{line:"selected: true"},
			{line:"},"},
			{line:"['Safari',    8.5],"},
			{line:"['Opera',     6.2],"},
			{line:"['Others',   0.7]"},
			{line:"]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	
	{
		/* --- --- */
		header : this.eventHeader,
		description : this.eventDescription(),
		
		dynamicCode:[
			{line:"{type:'$piechart',key:'eventchart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"chart: {"},
			{line:"plotBackgroundColor: null,"},
			{line:"plotBorderWidth: 1,"},
			{line:"plotShadow: false"},
			{line:"},"},
			{line:"title: {"},
			{line:"text: 'Browser market shares at a specific website, 2014'"},
			{line:"},"},
			//{line:"tooltip: {"},
			//{line:"pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'"},
			//{line:"},"},
			{line:"plotOptions: {"},
			{line:"pie: {"},
			{line:"allowPointSelect: true,"},
			{line:"cursor: 'pointer',"},
			{line:"dataLabels: {"},
			{line:"enabled: true,"},
			//{line:"format: '<b>{point.name}</b>: {point.percentage:.1f} %',"},
			{line:"style: {"},
			//{line:"color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'"},
			{line:"color: 'black'"},
			{line:"}"},
			{line:"}"},
			{line:"}"},
			{line:"},"},
			{line:"series: [{"},
			{line:"type: 'pie',"},
			{line:"name: 'Browser share',"},
			{line:"data: ["},
			{line:"['Firefox',   45.0],"},
			{line:"['IE',       26.8],"},
			{line:"{"},
			{line:"name: 'Chrome',"},
			{line:"y: 12.8,"},
			{line:"sliced: true,"},
			{line:"selected: true"},
			{line:"},"},
			{line:"['Safari',    8.5],"},
			{line:"['Opera',     6.2],"},
			{line:"['Others',   0.7]"},
			{line:"]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	];
	
	return data;
}

ClientMethod getDataScatterChart() [ Language = javascript ]
{
	var chart = 'scatterchart';
	
	var data = {
		widgetname:'Scatter Plot Chart',
		description:'A scatter plot chart is a way of displaying 2 or 3 dimensional data. These dimensions are represented by the x coordinate, y coordinate, and color of the point.',
		headercontent:'Using $' + chart,
		link:'High Charts Scatter Plot Chart documentation',
		linkAddress:'http://api.highcharts.com/highcharts#plotOptions.scatter'
	};
	
	data.sections = [
	{
		/* --- --- */
		header : this.dataHeader(chart),
		description : this.dataDescription(chart),
		
		dynamicCode:[
			{line:"{type:'$scatterchart',key:'chart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"title: {"},
			{line:"text: 'Height Versus Weight of 10 Individuals by Gender'"},
			{line:"},"},
			{line:"subtitle: {"},
			{line:"text: 'Source - Heinz  2003'"},
			{line:"},"},
			{line:"xAxis: {"},
			{line:"title: {"},
			{line:"enabled: true,"},
			{line:"text: 'Height (cm)'"},
			{line:"}"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"title: {"},
			{line:"text: 'Weight (kg)'"},
			{line:"}"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Female',"},
			{line:"color: 'rgba(223, 83, 83, .5)',"},
			{line:"data: [[161.2, 51.6], [167.5, 59.0], [159.5, 49.2], [157.0, 63.0], [155.8, 53.6]]"},
			{line:"}, {"},
			{line:"name: 'Male',"},
			{line:"color: 'rgba(119, 152, 191, .5)',"},
			{line:"data: [[174.0, 65.6], [175.3, 71.8], [193.5, 80.7], [186.5, 72.6], [187.2, 78.8]]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	
	{
		/* --- --- */
		header : this.eventHeader,
		description : this.eventDescription(),
		
		dynamicCode:[
			{line:"{type:'$scatterchart',key:'eventchart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"chart: {"},
			{line:"type: 'scatter',"},
			{line:"zoomType: 'xy'"},
			{line:"},"},
			{line:"title: {"},
			{line:"text: 'Height Versus Weight of 507 Individuals by Gender'"},
			{line:"},"},
			{line:"subtitle: {"},
			{line:"text: 'Source - Heinz  2003'"},
			{line:"},"},
			{line:"xAxis: {"},
			{line:"title: {"},
			{line:"enabled: true,"},
			{line:"text: 'Height (cm)'"},
			{line:"},"},
			{line:"startOnTick: true,"},
			{line:"endOnTick: true,"},
			{line:"showLastLabel: true"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"title: {"},
			{line:"text: 'Weight (kg)'"},
			{line:"}"},
			{line:"},"},
			{line:"legend: {"},
			{line:"layout: 'vertical',"},
			{line:"align: 'left',"},
			{line:"verticalAlign: 'top',"},
			{line:"x: 100,"},
			{line:"y: 70,"},
			{line:"floating: true,"},
			//{line:"backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF',"},
			{line:"backgroundColor: '#FFFFFF',"},
			{line:"borderWidth: 1"},
			{line:"},"},
			{line:"plotOptions: {"},
			{line:"scatter: {"},
			{line:"marker: {"},
			{line:"radius: 5,"},
			{line:"states: {"},
			{line:"hover: {"},
			{line:"enabled: true,"},
			{line:"lineColor: 'rgb(100, 100, 100)'"},
			{line:"}"},
			{line:"}"},
			{line:"},"},
			{line:"states: {"},
			{line:"hover: {"},
			{line:"marker: {"},
			{line:"enabled: false"},
			{line:"}"},
			{line:"}"},
			{line:"}"},
			//{line:"tooltip: {"},
			//{line:"headerFormat: '<b>{series.name}</b><br>',"},
			//{line:"pointFormat: '{point.x} cm, {point.y} kg'"},
			//{line:"}"},
			{line:"}"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Female',"},
			{line:"color: 'rgba(223, 83, 83, .5)',"},
			{line:"data: [[161.2, 51.6], [167.5, 59.0], [159.5, 49.2], [157.0, 63.0], [155.8, 53.6],"},
			{line:"[170.0, 59.0], [159.1, 47.6], [166.0, 69.8], [176.2, 66.8], [160.2, 75.2],"},
			{line:"[172.5, 55.2], [170.9, 54.2], [172.9, 62.5], [153.4, 42.0], [160.0, 50.0],"},
			{line:"[147.2, 49.8], [168.2, 49.2], [175.0, 73.2], [157.0, 47.8], [167.6, 68.8],"},
			{line:"[159.5, 50.6], [175.0, 82.5], [166.8, 57.2], [176.5, 87.8], [170.2, 72.8],"},
			{line:"[174.0, 54.5], [173.0, 59.8], [179.9, 67.3], [170.5, 67.8], [160.0, 47.0],"},
			{line:"[154.4, 46.2], [162.0, 55.0], [176.5, 83.0], [160.0, 54.4], [152.0, 45.8],"},
			{line:"[162.1, 53.6], [170.0, 73.2], [160.2, 52.1], [161.3, 67.9], [166.4, 56.6],"},
			{line:"[168.9, 62.3], [163.8, 58.5], [167.6, 54.5], [160.0, 50.2], [161.3, 60.3],"},
			{line:"[167.6, 58.3], [165.1, 56.2], [160.0, 50.2], [170.0, 72.9], [157.5, 59.8],"},
			{line:"[167.6, 61.0], [160.7, 69.1], [163.2, 55.9], [152.4, 46.5], [157.5, 54.3],"},
			{line:"[168.3, 54.8], [180.3, 60.7], [165.5, 60.0], [165.0, 62.0], [164.5, 60.3],"},
			{line:"[156.0, 52.7], [160.0, 74.3], [163.0, 62.0], [165.7, 73.1], [161.0, 80.0],"},
			{line:"[162.0, 54.7], [166.0, 53.2], [174.0, 75.7], [172.7, 61.1], [167.6, 55.7],"},
			{line:"[151.1, 48.7], [164.5, 52.3], [163.5, 50.0], [152.0, 59.3], [169.0, 62.5],"},
			{line:"[164.0, 55.7], [161.2, 54.8], [155.0, 45.9], [170.0, 70.6], [176.2, 67.2],"},
			{line:"[170.0, 69.4], [162.5, 58.2], [170.3, 64.8], [164.1, 71.6], [169.5, 52.8],"},
			{line:"[163.2, 59.8], [154.5, 49.0], [159.8, 50.0], [173.2, 69.2], [170.0, 55.9],"},
			{line:"[161.4, 63.4], [169.0, 58.2], [166.2, 58.6], [159.4, 45.7], [162.5, 52.2],"},
			{line:"[159.0, 48.6], [162.8, 57.8], [159.0, 55.6], [179.8, 66.8], [162.9, 59.4],"},
			{line:"[161.0, 53.6], [151.1, 73.2], [168.2, 53.4], [168.9, 69.0], [173.2, 58.4],"},
			{line:"[171.8, 56.2], [178.0, 70.6], [164.3, 59.8], [163.0, 72.0], [168.5, 65.2],"},
			{line:"[166.8, 56.6], [172.7, 105.2], [163.5, 51.8], [169.4, 63.4], [167.8, 59.0],"},
			{line:"[159.5, 47.6], [167.6, 63.0], [161.2, 55.2], [160.0, 45.0], [163.2, 54.0],"},
			{line:"[162.2, 50.2], [161.3, 60.2], [149.5, 44.8], [157.5, 58.8], [163.2, 56.4],"},
			{line:"[172.7, 62.0], [155.0, 49.2], [156.5, 67.2], [164.0, 53.8], [160.9, 54.4],"},
			{line:"[162.8, 58.0], [167.0, 59.8], [160.0, 54.8], [160.0, 43.2], [168.9, 60.5],"},
			{line:"[158.2, 46.4], [156.0, 64.4], [160.0, 48.8], [167.1, 62.2], [158.0, 55.5],"},
			{line:"[167.6, 57.8], [156.0, 54.6], [162.1, 59.2], [173.4, 52.7], [159.8, 53.2],"},
			{line:"[170.5, 64.5], [159.2, 51.8], [157.5, 56.0], [161.3, 63.6], [162.6, 63.2],"},
			{line:"[160.0, 59.5], [168.9, 56.8], [165.1, 64.1], [162.6, 50.0], [165.1, 72.3],"},
			{line:"[166.4, 55.0], [160.0, 55.9], [152.4, 60.4], [170.2, 69.1], [162.6, 84.5],"},
			{line:"[170.2, 55.9], [158.8, 55.5], [172.7, 69.5], [167.6, 76.4], [162.6, 61.4],"},
			{line:"[167.6, 65.9], [156.2, 58.6], [175.2, 66.8], [172.1, 56.6], [162.6, 58.6],"},
			{line:"[160.0, 55.9], [165.1, 59.1], [182.9, 81.8], [166.4, 70.7], [165.1, 56.8],"},
			{line:"[177.8, 60.0], [165.1, 58.2], [175.3, 72.7], [154.9, 54.1], [158.8, 49.1],"},
			{line:"[172.7, 75.9], [168.9, 55.0], [161.3, 57.3], [167.6, 55.0], [165.1, 65.5],"},
			{line:"[175.3, 65.5], [157.5, 48.6], [163.8, 58.6], [167.6, 63.6], [165.1, 55.2],"},
			{line:"[165.1, 62.7], [168.9, 56.6], [162.6, 53.9], [164.5, 63.2], [176.5, 73.6],"},
			{line:"[168.9, 62.0], [175.3, 63.6], [159.4, 53.2], [160.0, 53.4], [170.2, 55.0],"},
			{line:"[162.6, 70.5], [167.6, 54.5], [162.6, 54.5], [160.7, 55.9], [160.0, 59.0],"},
			{line:"[157.5, 63.6], [162.6, 54.5], [152.4, 47.3], [170.2, 67.7], [165.1, 80.9],"},
			{line:"[172.7, 70.5], [165.1, 60.9], [170.2, 63.6], [170.2, 54.5], [170.2, 59.1],"},
			{line:"[161.3, 70.5], [167.6, 52.7], [167.6, 62.7], [165.1, 86.3], [162.6, 66.4],"},
			{line:"[152.4, 67.3], [168.9, 63.0], [170.2, 73.6], [175.2, 62.3], [175.2, 57.7],"},
			{line:"[160.0, 55.4], [165.1, 104.1], [174.0, 55.5], [170.2, 77.3], [160.0, 80.5],"},
			{line:"[167.6, 64.5], [167.6, 72.3], [167.6, 61.4], [154.9, 58.2], [162.6, 81.8],"},
			{line:"[175.3, 63.6], [171.4, 53.4], [157.5, 54.5], [165.1, 53.6], [160.0, 60.0],"},
			{line:"[174.0, 73.6], [162.6, 61.4], [174.0, 55.5], [162.6, 63.6], [161.3, 60.9],"},
			{line:"[156.2, 60.0], [149.9, 46.8], [169.5, 57.3], [160.0, 64.1], [175.3, 63.6],"},
			{line:"[169.5, 67.3], [160.0, 75.5], [172.7, 68.2], [162.6, 61.4], [157.5, 76.8],"},
			{line:"[176.5, 71.8], [164.4, 55.5], [160.7, 48.6], [174.0, 66.4], [163.8, 67.3]]"},
			{line:"}, {"},
			{line:"name: 'Male',"},
			{line:"color: 'rgba(119, 152, 191, .5)',"},
			{line:"data: [[174.0, 65.6], [175.3, 71.8], [193.5, 80.7], [186.5, 72.6], [187.2, 78.8],"},
			{line:"[181.5, 74.8], [184.0, 86.4], [184.5, 78.4], [175.0, 62.0], [184.0, 81.6],"},
			{line:"[180.0, 76.6], [177.8, 83.6], [192.0, 90.0], [176.0, 74.6], [174.0, 71.0],"},
			{line:"[184.0, 79.6], [192.7, 93.8], [171.5, 70.0], [173.0, 72.4], [176.0, 85.9],"},
			{line:"[176.0, 78.8], [180.5, 77.8], [172.7, 66.2], [176.0, 86.4], [173.5, 81.8],"},
			{line:"[178.0, 89.6], [180.3, 82.8], [180.3, 76.4], [164.5, 63.2], [173.0, 60.9],"},
			{line:"[183.5, 74.8], [175.5, 70.0], [188.0, 72.4], [189.2, 84.1], [172.8, 69.1],"},
			{line:"[170.0, 59.5], [182.0, 67.2], [170.0, 61.3], [177.8, 68.6], [184.2, 80.1],"},
			{line:"[186.7, 87.8], [171.4, 84.7], [172.7, 73.4], [175.3, 72.1], [180.3, 82.6],"},
			{line:"[182.9, 88.7], [188.0, 84.1], [177.2, 94.1], [172.1, 74.9], [167.0, 59.1],"},
			{line:"[169.5, 75.6], [174.0, 86.2], [172.7, 75.3], [182.2, 87.1], [164.1, 55.2],"},
			{line:"[163.0, 57.0], [171.5, 61.4], [184.2, 76.8], [174.0, 86.8], [174.0, 72.2],"},
			{line:"[177.0, 71.6], [186.0, 84.8], [167.0, 68.2], [171.8, 66.1], [182.0, 72.0],"},
			{line:"[167.0, 64.6], [177.8, 74.8], [164.5, 70.0], [192.0, 101.6], [175.5, 63.2],"},
			{line:"[171.2, 79.1], [181.6, 78.9], [167.4, 67.7], [181.1, 66.0], [177.0, 68.2],"},
			{line:"[174.5, 63.9], [177.5, 72.0], [170.5, 56.8], [182.4, 74.5], [197.1, 90.9],"},
			{line:"[180.1, 93.0], [175.5, 80.9], [180.6, 72.7], [184.4, 68.0], [175.5, 70.9],"},
			{line:"[180.6, 72.5], [177.0, 72.5], [177.1, 83.4], [181.6, 75.5], [176.5, 73.0],"},
			{line:"[175.0, 70.2], [174.0, 73.4], [165.1, 70.5], [177.0, 68.9], [192.0, 102.3],"},
			{line:"[176.5, 68.4], [169.4, 65.9], [182.1, 75.7], [179.8, 84.5], [175.3, 87.7],"},
			{line:"[184.9, 86.4], [177.3, 73.2], [167.4, 53.9], [178.1, 72.0], [168.9, 55.5],"},
			{line:"[157.2, 58.4], [180.3, 83.2], [170.2, 72.7], [177.8, 64.1], [172.7, 72.3],"},
			{line:"[165.1, 65.0], [186.7, 86.4], [165.1, 65.0], [174.0, 88.6], [175.3, 84.1],"},
			{line:"[185.4, 66.8], [177.8, 75.5], [180.3, 93.2], [180.3, 82.7], [177.8, 58.0],"},
			{line:"[177.8, 79.5], [177.8, 78.6], [177.8, 71.8], [177.8, 116.4], [163.8, 72.2],"},
			{line:"[188.0, 83.6], [198.1, 85.5], [175.3, 90.9], [166.4, 85.9], [190.5, 89.1],"},
			{line:"[166.4, 75.0], [177.8, 77.7], [179.7, 86.4], [172.7, 90.9], [190.5, 73.6],"},
			{line:"[185.4, 76.4], [168.9, 69.1], [167.6, 84.5], [175.3, 64.5], [170.2, 69.1],"},
			{line:"[190.5, 108.6], [177.8, 86.4], [190.5, 80.9], [177.8, 87.7], [184.2, 94.5],"},
			{line:"[176.5, 80.2], [177.8, 72.0], [180.3, 71.4], [171.4, 72.7], [172.7, 84.1],"},
			{line:"[172.7, 76.8], [177.8, 63.6], [177.8, 80.9], [182.9, 80.9], [170.2, 85.5],"},
			{line:"[167.6, 68.6], [175.3, 67.7], [165.1, 66.4], [185.4, 102.3], [181.6, 70.5],"},
			{line:"[172.7, 95.9], [190.5, 84.1], [179.1, 87.3], [175.3, 71.8], [170.2, 65.9],"},
			{line:"[193.0, 95.9], [171.4, 91.4], [177.8, 81.8], [177.8, 96.8], [167.6, 69.1],"},
			{line:"[167.6, 82.7], [180.3, 75.5], [182.9, 79.5], [176.5, 73.6], [186.7, 91.8],"},
			{line:"[188.0, 84.1], [188.0, 85.9], [177.8, 81.8], [174.0, 82.5], [177.8, 80.5],"},
			{line:"[171.4, 70.0], [185.4, 81.8], [185.4, 84.1], [188.0, 90.5], [188.0, 91.4],"},
			{line:"[182.9, 89.1], [176.5, 85.0], [175.3, 69.1], [175.3, 73.6], [188.0, 80.5],"},
			{line:"[188.0, 82.7], [175.3, 86.4], [170.5, 67.7], [179.1, 92.7], [177.8, 93.6],"},
			{line:"[175.3, 70.9], [182.9, 75.0], [170.8, 93.2], [188.0, 93.2], [180.3, 77.7],"},
			{line:"[177.8, 61.4], [185.4, 94.1], [168.9, 75.0], [185.4, 83.6], [180.3, 85.5],"},
			{line:"[174.0, 73.9], [167.6, 66.8], [182.9, 87.3], [160.0, 72.3], [180.3, 88.6],"},
			{line:"[167.6, 75.5], [186.7, 101.4], [175.3, 91.1], [175.3, 67.3], [175.9, 77.7],"},
			{line:"[175.3, 81.8], [179.1, 75.5], [181.6, 84.5], [177.8, 76.6], [182.9, 85.0],"},
			{line:"[177.8, 102.5], [184.2, 77.3], [179.1, 71.8], [176.5, 87.9], [188.0, 94.3],"},
			{line:"[174.0, 70.9], [167.6, 64.5], [170.2, 77.3], [167.6, 72.3], [188.0, 87.3],"},
			{line:"[174.0, 80.0], [176.5, 82.3], [180.3, 73.6], [167.6, 74.1], [188.0, 85.9],"},
			{line:"[180.3, 73.2], [167.6, 76.3], [183.0, 65.9], [183.0, 90.9], [179.1, 89.1],"},
			{line:"[170.2, 62.3], [177.8, 82.7], [179.1, 79.1], [190.5, 98.2], [177.8, 84.1],"},
			{line:"[180.3, 83.2], [180.3, 83.2]]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	];
	
	return data;
}

ClientMethod getDataSplineChart() [ Language = javascript ]
{
	var chart = 'splinechart';
	
	var data = {
		widgetname:'Spline Chart',
		description:'A line chart is a way of plotting data points on a line. Often, it is used to show trend data, and the comparison of two data sets.\r'
					+ 'A spline chart is simply a line chart where the line connecting the data curves to more accurately represent the space between two data points.',
		headercontent:'Using $' + chart,
		link:'Charts.js Spline Chart documentation',
		linkAddress:'http://api.highcharts.com/highcharts#plotOptions.spline'
	};
	
	data.sections = [
	{
		/* --- --- */
		header : this.dataHeader(chart),
		description : this.dataDescription(chart),

		dynamicCode:[
			{line:"{type:'$splinechart',key:'chart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"title: {"},
			{line:"text: 'Wind speed during two days'"},
			{line:"},"},
			{line:"subtitle: {"},
			{line:"text: 'October 6th and 7th 2009 at two locations in Vik i Sogn, Norway'"},
			{line:"},"},
			{line:"xAxis: {"},
			{line:"type: 'datetime'"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"title: {"},
			{line:"text: 'Wind speed (m/s)'"},
			{line:"},"},
			{line:"min: 0"},
			{line:"},"},
			{line:"tooltip: {"},
			{line:"valueSuffix: ' m/s'"},
			{line:"},"},
			{line:"plotOptions: {"},
			{line:"spline: {"},
			{line:"pointInterval: 3600000,"},
			{line:"pointStart: "+Date.UTC(2009, 9, 6, 0, 0, 0).toString()},
			{line:"}"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Hestavollane',"},
			{line:"data: [4.3, 5.1, 4.3, 5.2, 5.4, 4.7, 3.5, 4.1, 5.6, 7.4, 6.9, 7.1,"},
			{line:" 7.9, 7.9, 7.5, 6.7, 7.7, 7.7, 7.4, 7.0, 7.1, 5.8, 5.9, 7.4,"},
			{line:" 8.2, 8.5, 9.4, 8.1, 10.9, 10.4, 10.9, 12.4, 12.1, 9.5, 7.5,"},
			{line:" 7.1, 7.5, 8.1, 6.8, 3.4, 2.1, 1.9, 2.8, 2.9, 1.3, 4.4, 4.2,"},
			{line:" 3.0, 3.0]"},
			{line:"}, {"},
			{line:"name: 'Voll',"},
			{line:"data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.0, 0.3, 0.0,"},
			{line:" 0.0, 0.4, 0.0, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,"},
			{line:" 0.0, 0.6, 1.2, 1.7, 0.7, 2.9, 4.1, 2.6, 3.7, 3.9, 1.7, 2.3,"},
			{line:" 3.0, 3.3, 4.8, 5.0, 4.8, 5.0, 3.2, 2.0, 0.9, 0.4, 0.3, 0.5, 0.4]"},
			{line:"}]"},
			{line:"}"},
			{line:"}"},
		]
	},
	
	{
		/* --- --- */
		header : this.eventHeader,
		description : this.eventDescription(),
		
		dynamicCode:[
			{line:"{type:'$splinechart',key:'eventchart',options:'=[options]',width:'100%',height:'400px'}"},
		],
		dynamicData:[
			{line:"{"},
			{line:"options:{"},
			{line:"title: {"},
			{line:"text: 'Wind speed during two days'"},
			{line:"},"},
			{line:"subtitle: {"},
			{line:"text: 'October 6th and 7th 2009 at two locations in Vik i Sogn, Norway'"},
			{line:"},"},
			{line:"xAxis: {"},
			{line:"type: 'datetime',"},
			{line:"labels: {"},
			{line:"overflow: 'justify'"},
			{line:"}"},
			{line:"},"},
			{line:"yAxis: {"},
			{line:"title: {"},
			{line:"text: 'Wind speed (m/s)'"},
			{line:"},"},
			{line:"min: 0,"},
			{line:"minorGridLineWidth: 0,"},
			{line:"gridLineWidth: 0,"},
			{line:"alternateGridColor: null,"},
			{line:"plotBands: [{"},
			{line:"from: 0.3,"},
			{line:"to: 1.5,"},
			{line:"color: 'rgba(68, 170, 213, 0.1)',"},
			{line:"label: {"},
			{line:"text: 'Light air',"},
			{line:"style: {"},
			{line:"color: '#606060'"},
			{line:"}"},
			{line:"}"},
			{line:"}, {"},
			{line:"from: 1.5,"},
			{line:"to: 3.3,"},
			{line:"color: 'rgba(0, 0, 0, 0)',"},
			{line:"label: {"},
			{line:"text: 'Light breeze',"},
			{line:"style: {"},
			{line:"color: '#606060'"},
			{line:"}"},
			{line:"}"},
			{line:"}, {"},
			{line:"from: 3.3,"},
			{line:"to: 5.5,"},
			{line:"color: 'rgba(68, 170, 213, 0.1)',"},
			{line:"label: {"},
			{line:"text: 'Gentle breeze',"},
			{line:"style: {"},
			{line:"color: '#606060'"},
			{line:"}"},
			{line:"}"},
			{line:"}, {"},
			{line:"from: 5.5,"},
			{line:"to: 8,"},
			{line:"color: 'rgba(0, 0, 0, 0)',"},
			{line:"label: {"},
			{line:"text: 'Moderate breeze',"},
			{line:"style: {"},
			{line:"color: '#606060'"},
			{line:"}"},
			{line:"}"},
			{line:"}, {"},
			{line:"from: 8,"},
			{line:"to: 11,"},
			{line:"color: 'rgba(68, 170, 213, 0.1)',"},
			{line:"label: {"},
			{line:"text: 'Fresh breeze',"},
			{line:"style: {"},
			{line:"color: '#606060'"},
			{line:"}"},
			{line:"}"},
			{line:" }, {"},
			{line:"from: 11,"},
			{line:"to: 14,"},
			{line:"color: 'rgba(0, 0, 0, 0)',"},
			{line:"label: {"},
			{line:"text: 'Strong breeze',"},
			{line:"style: {"},
			{line:"color: '#606060'"},
			{line:"}"},
			{line:"}"},
			{line:"}, {"},
			{line:"from: 14,"},
			{line:"to: 15,"},
			{line:"color: 'rgba(68, 170, 213, 0.1)',"},
			{line:"label: {"},
			{line:"text: 'High wind',"},
			{line:"style: {"},
			{line:"color: '#606060'"},
			{line:"}"},
			{line:"}"},
			{line:"}]"},
			{line:"},"},
			{line:"tooltip: {"},
			{line:"valueSuffix: ' m/s'"},
			{line:"},"},
			{line:"plotOptions: {"},
			{line:"spline: {"},
			{line:"lineWidth: 4,"},
			{line:"states: {"},
			{line:"hover: {"},
			{line:"lineWidth: 5"},
			{line:"}"},
			{line:"},"},
			{line:"marker: {"},
			{line:"enabled: false"},
			{line:"},"},
			{line:"pointInterval: 3600000,"},
			{line:"pointStart: "+Date.UTC(2009, 9, 6, 0, 0, 0).toString()},
			{line:"}"},
			{line:"},"},
			{line:"series: [{"},
			{line:"name: 'Hestavollane',"},
			{line:"data: [4.3, 5.1, 4.3, 5.2, 5.4, 4.7, 3.5, 4.1, 5.6, 7.4, 6.9, 7.1,"},
			{line:" 7.9, 7.9, 7.5, 6.7, 7.7, 7.7, 7.4, 7.0, 7.1, 5.8, 5.9, 7.4,"},
			{line:" 8.2, 8.5, 9.4, 8.1, 10.9, 10.4, 10.9, 12.4, 12.1, 9.5, 7.5,"},
			{line:" 7.1, 7.5, 8.1, 6.8, 3.4, 2.1, 1.9, 2.8, 2.9, 1.3, 4.4, 4.2,"},
			{line:" 3.0, 3.0]"},
			{line:"}, {"},
			{line:"name: 'Voll',"},
			{line:"data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.0, 0.3, 0.0,"},
			{line:" 0.0, 0.4, 0.0, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,"},
			{line:" 0.0, 0.6, 1.2, 1.7, 0.7, 2.9, 4.1, 2.6, 3.7, 3.9, 1.7, 2.3,"},
			{line:" 3.0, 3.3, 4.8, 5.0, 4.8, 5.0, 3.2, 2.0, 0.9, 0.4, 0.3, 0.5, 0.4]"},
			{line:"}],"},
			{line:"navigation: {"},
			{line:"menuItemStyle: {"},
			{line:"fontSize: '10px'"},
			{line:"}"},
			{line:"}"},
			{line:"}"},
			{line:"}"},
		]
	},
	];
	
	return data;
}

}
