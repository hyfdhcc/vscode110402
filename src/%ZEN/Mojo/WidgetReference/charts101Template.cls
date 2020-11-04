Class %ZEN.Mojo.WidgetReference.charts101Template Extends %ZEN.Mojo.WidgetReference.jQM132BaseTemplate
{

ClientMethod getData(key, criteria) [ Language = javascript ]
{
	
	var data = {};
	
	switch (key) {
	
		case 'home':
		
			data = {
				headerTitle:'Zen Mojo Widget Reference',
				referenceTitle:'Charts.js 1.0.1 Widget reference',
				referenceDescription:'Test drive every component in the library, and easily build pages by copying and pasting the markup configuration you need.',
				linkAddress:'http://www.chartjs.org/docs/',
				link:'Charts.js documentation',
				widgets:[
					{widgetname:'$barchart',widgetOriginalName:'Bar Chart',widgetvalue:'barChart'},
					{widgetname:'$doughnutchart',widgetOriginalName:'Doughnut & Pie Chart',widgetvalue:'pieChart'},
					{widgetname:'$linechart',widgetOriginalName:'Line Chart',widgetvalue:'lineChart'},
					{widgetname:'$piechart',widgetOriginalName:'Pie & Doughnut Chart',widgetvalue:'pieChart'},
					{widgetname:'$polarareachart',widgetOriginalName:'Polar Area Chart',widgetvalue:'polarAreaChart'},
					{widgetname:'$radarchart',widgetOriginalName:'Radar Chart',widgetvalue:'radarChart'},
				]};
	
			break;
			
		case 'barChart':
			data = this.getDataBarChart();
			break;
		case 'lineChart':
			data = this.getDataLineChart();
			break;
		case 'pieChart':
			data = this.getDataPieChart();
			break;
		case 'polarAreaChart':
			data = this.getDataPolarAreaChart();
			break;
		case 'radarChart':
			data = this.getDataRadarChart();
			break;
	}
	return data;
}

ClientMethod getDataBarChart() [ Language = javascript ]
{
	var data = {
		widgetname:'Bar Chart',
		description:'A bar chart is a way of showing data as bars. It is sometimes used to show trend data, and the comparison of multiple data sets side by side.',
		headercontent:'Using $barchart',
		link:'Charts.js Bar Chart documentation',
		linkAddress:'http://www.chartjs.org/docs/#bar-chart'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Standard Barchart',
			description : 'Define a '+this.addBoldTag('$barchart')+' layout object and set sizes accordingly. The chart is driven by the provided data object.',
			
			dynamicCode:[
				{line:"{type:'$barchart',key:'simple-bar-chart',data:'=[data]',width:'400px;',height:'400px;'"},
				{line:"}"},
			],
			dynamicData:[
				{line:"{"},
				{line:"data: {"},
				{line:"labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],"},
    			{line:"datasets: ["},
        		{line:"{"},
				{line:"label: 'My First dataset',"},
				{line:"data: [65, 59, 80, 81, 56, 55, 40]"},
				{line:"},"},
				{line:"{"},
				{line:"label: 'My Second dataset',"},
				{line:"data: [28, 48, 40, 19, 86, 27, 90]"},
				{line:"}"},
    			{line:"]"},
				{line:"}"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Barchart with custom colors',
			description : 'Use '+this.addBoldTag('fillColor')+', '+this.addBoldTag('strokeColor')+', '+this.addBoldTag('highlightFill')+' and '+this.addBoldTag('highlightStroke')+' to define the appearance of the bars.',
			
			dynamicCode:[
				{line:"{type:'$barchart',key:'bar-chart',data:'=[data]',width:'400px;',height:'400px;'"},
				{line:"}"},
			],
			dynamicData:[
				{line:"{"},
				{line:"data: {"},
				{line:"labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],"},
    			{line:"datasets: ["},
        		{line:"{"},
				{line:"label: 'My First dataset',"},
				{line:"fillColor: 'rgba(220, 220, 220, 0.5)',"},
				{line:"strokeColor: 'rgba(220, 220, 220, 0.8)',"},
				{line:"highlightFill: 'rgba(220, 220, 220, 0.75)',"},
				{line:"highlightStroke: 'rgba(220, 220, 220, 1)',"},
				{line:"data: [65, 59, 80, 81, 56, 55, 40]"},
				{line:"},"},
				{line:"{"},
				{line:"label: 'My Second dataset',"},
				{line:"fillColor: 'rgba(151, 187, 205 , 0.5)',"},
				{line:"strokeColor: 'rgba(151, 187, 205, 0.8)',"},
				{line:"highlightFill: 'rgba(151, 187, 205, 0.75)',"},
				{line:"highlightStroke: 'rgba(151, 187, 205, 1)',"},
				{line:"data: [28, 48, 40, 19, 86, 27, 90]"},
				{line:"}"},
    			{line:"]"},
				{line:"}"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Responsive Barchart',
			description : 'To make the chart responsive use the options object and set the '+this.addBoldTag('responsive')+' flag to true.',
			
			dynamicCode:[
				{line:"{type:'$barchart',key:'responsive-bar-chart',data:'=[data]',"},
				{line:"options:{responsive:true}"},
				{line:"}"},
			],
			dynamicData:[
				{line:"{"},
				{line:"data: {"},
				{line:"labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],"},
    			{line:"datasets: ["},
        		{line:"{"},
				{line:"label: 'My First dataset',"},
				{line:"fillColor: 'rgba(220, 220, 220, 0.5)',"},
				{line:"strokeColor: 'rgba(220, 220, 220, 0.8)',"},
				{line:"highlightFill: 'rgba(220, 220, 220, 0.75)',"},
				{line:"highlightStroke: 'rgba(220, 220, 220, 1)',"},
				{line:"data: [65, 59, 80, 81, 56, 55, 40]"},
				{line:"},"},
				{line:"{"},
				{line:"label: 'My Second dataset',"},
				{line:"fillColor: 'rgba(151, 187, 205 , 0.5)',"},
				{line:"strokeColor: 'rgba(151, 187, 205, 0.8)',"},
				{line:"highlightFill: 'rgba(151, 187, 205, 0.75)',"},
				{line:"highlightStroke: 'rgba(151, 187, 205, 1)',"},
				{line:"data: [28, 48, 40, 19, 86, 27, 90]"},
				{line:"}"},
    			{line:"]"},
				{line:"}"},
				{line:"}"},
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataLineChart() [ Language = javascript ]
{
	var data = {
		widgetname:'Line Chart',
		description:'A line chart is a way of plotting data points on a line. Often, it is used to show trend data, and the comparison of two data sets.',
		headercontent:'Using $linechart',
		link:'Charts.js Line Chart documentation',
		linkAddress:'http://www.chartjs.org/docs/#line-chart'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Standard Linechart',
			description : 'Define a '+this.addBoldTag('$linechart')+' layout object and set sizes accordingly. The chart is driven by the provided data object.',
			
			dynamicCode:[
				{line:"{type:'$linechart',key:'simple-line-chart',data:'=[data]',width:'400px;',height:'400px;'"},
				{line:"}"},
			],
			dynamicData:[
				{line:"{"},
				{line:"data: {"},
				{line:"labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],"},
    			{line:"datasets: ["},
        		{line:"{"},
				{line:"label: 'My First dataset',"},
				{line:"data: [65, 59, 80, 81, 56, 55, 40]"},
				{line:"},"},
				{line:"{"},
				{line:"label: 'My Second dataset',"},
				{line:"data: [28, 48, 40, 19, 86, 27, 90]"},
				{line:"}"},
    			{line:"]"},
				{line:"}"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Linechart with custom colors',
			description : 'Use '+this.addBoldTag('fillColor')+', '+this.addBoldTag('strokeColor')+', '+this.addBoldTag('pointColor')+', '+this.addBoldTag('pointStrokeColor')+', '+this.addBoldTag('pointHighlightFill')+' and '+this.addBoldTag('pointHighlightStroke')+' to define the appearance of the lines and points.',
			
			dynamicCode:[
				{line:"{type:'$linechart',key:'line-chart',data:'=[data]',width:'400px;',height:'400px;'"},
				{line:"}"},
			],
			dynamicData:[
				{line:"{"},
				{line:"data: {"},
				{line:"labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],"},
    			{line:"datasets: ["},
        		{line:"{"},
				{line:"label: 'My First dataset',"},
				{line:"fillColor: 'rgba(220, 220, 220, 0.2)',"},
				{line:"strokeColor: 'rgba(220, 220, 220, 1)',"},
				{line:"pointColor: 'rgba(220, 220, 220, 1)',"},
				{line:"pointStrokeColor: '#fff',"},
				{line:"pointHighlightFill: '#fff',"},
				{line:"pointHighlightStroke: 'rgba(220, 220, 220, 1)',"},
				{line:"data: [65, 59, 80, 81, 56, 55, 40]"},
				{line:"},"},
				{line:"{"},
				{line:"label: 'My Second dataset',"},
				{line:"fillColor: 'rgba(151, 187, 205 , 0.2)',"},
				{line:"strokeColor: 'rgba(151, 187, 205, 1)',"},
				{line:"pointColor: 'rgba(151, 187, 205 , 1)',"},
				{line:"pointStrokeColor: '#fff',"},
				{line:"pointHighlightFill: '#fff',"},
				{line:"pointHighlightStroke: 'rgba(151, 187, 205, 1)',"},
				{line:"data: [28, 48, 40, 19, 86, 27, 90]"},
				{line:"}"},
    			{line:"]"},
				{line:"}"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Responsive Linechart',
			description : 'To make the chart responsive use the options object and set the '+this.addBoldTag('responsive')+' flag to true.',
			
			dynamicCode:[
				{line:"{type:'$linechart',key:'responsive-line-chart',data:'=[data]',"},
				{line:"options:{responsive:true}"},
				{line:"}"},
			],
			dynamicData:[
				{line:"{"},
				{line:"data: {"},
				{line:"labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],"},
    			{line:"datasets: ["},
        		{line:"{"},
				{line:"label: 'My First dataset',"},
				{line:"fillColor: 'rgba(220, 220, 220, 0.2)',"},
				{line:"strokeColor: 'rgba(220, 220, 220, 1)',"},
				{line:"pointColor: 'rgba(220, 220, 220, 1)',"},
				{line:"pointStrokeColor: '#fff',"},
				{line:"pointHighlightFill: '#fff',"},
				{line:"pointHighlightStroke: 'rgba(220, 220, 220, 1)',"},
				{line:"data: [65, 59, 80, 81, 56, 55, 40]"},
				{line:"},"},
				{line:"{"},
				{line:"label: 'My Second dataset',"},
				{line:"fillColor: 'rgba(151, 187, 205 , 0.2)',"},
				{line:"strokeColor: 'rgba(151, 187, 205, 1)',"},
				{line:"pointColor: 'rgba(151, 187, 205 , 1)',"},
				{line:"pointStrokeColor: '#fff',"},
				{line:"pointHighlightFill: '#fff',"},
				{line:"pointHighlightStroke: 'rgba(151, 187, 205, 1)',"},
				{line:"data: [28, 48, 40, 19, 86, 27, 90]"},
				{line:"}"},
    			{line:"]"},
				{line:"}"},
				{line:"}"},
			]
		},
		
	];
	
	return data;
}

ClientMethod getDataPieChart() [ Language = javascript ]
{
	var data = {
		widgetname:'Doughnut & Pie Chart',
		description:'Pie and doughnut charts are probably the most commonly used chart there are. They are divided into segments, the arc of each segment shows a the proportional value of each piece of data. They are excellent at showing the relational proportions between data. Pie and doughnut charts in are effectively the same class in Chart.js, but have one different default value - their percentageInnerCutout. This equates what percentage of the inner should be cut out. This defaults to 0 for pie charts, and 50 for doughnuts.',
		headercontent:'Using $piechart and $doughnutchart',
		link:'Charts.js Doughnut & Pie Chart documentation',
		linkAddress:'http://www.chartjs.org/docs/#doughnut-pie-chart'
	};
	
	var chartData = [
			{line:"{"},
			{line:"data: ["},
			{line:"{"},
			{line:"value: 300,"},
			{line:"color: '#F7464A',"},
			{line:"highlight: '#FF5A5E',"},
			{line:"label: 'Red'"},
			{line:"},"},
			{line:"{"},
			{line:"value: 50,"},
			{line:"color: '#46BFBD',"},
			{line:"highlight: '#5AD3D1',"},
			{line:"label: 'Green'"},
			{line:"},"},
			{line:"{"},
			{line:"value: 100,"},
			{line:"color: '#FDB45C',"},
			{line:"highlight: '#FFC870',"},
			{line:"label: 'Yellow'"},
			{line:"}"},
			{line:"]"},
			{line:"}"},
		];
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Standard Piechart',
			description : 'Define a '+this.addBoldTag('$doughnutchart')+'/'+this.addBoldTag('$piechart')+' layout object and set sizes accordingly. The chart is driven by the provided data object. Use '+this.addBoldTag('color')+' and '+this.addBoldTag('highlight')+' to define the colors for each segment.',
			
			dynamicCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$piechart',key:'simple-pie-chart',data:'=[data]',width:'200px;',height:'200px;'},"},
				{line:"{type:'$doughnutchart',key:'simple-doughnut-chart',data:'=[data]',width:'200px;',height:'200px;'}"},
				{line:"]}"}
			],
			dynamicData: chartData
		},
		
		{
			/* --- --- */
			header : 'Responsive Doughnut- and Piechart',
			description : 'To make the chart responsive use the options object and set the '+this.addBoldTag('responsive')+' flag to true.',
			
			dynamicCode:[
				{line:"{type:'$div',children:["},
				{line:"{type:'$piechart',key:'responsive-pie-chart',data:'=[data]',width:'200px;',height:'200px;',"},
				{line:"options:{responsive:true}"},
				{line:"},"},
				{line:"{type:'$doughnutchart',key:'responsive-doughnut-chart',data:'=[data]',width:'200px;',height:'200px;',"},
				{line:"options:{responsive:true}"},
				{line:"}"},
				{line:"]}"},
			],
			dynamicData: chartData
		},
		
	];
	
	return data;
}

ClientMethod getDataPolarAreaChart() [ Language = javascript ]
{
	var data = {
		widgetname:'Polar Area Chart',
		description:'Polar area charts are similar to pie charts, but each segment has the same angle - the radius of the segment differs depending on the value. This type of chart is often useful when we want to show a comparison data similar to a pie chart, but also show a scale of values for context.',
		headercontent:'Using $polarareachart',
		link:'Charts.js Polar Area Chart documentation',
		linkAddress:'http://www.chartjs.org/docs/#polar-area-chart'
	};
	
	var chartData = [
			{line:"{"},
			{line:"data: ["},
			{line:"{"},
			{line:"value: 300,"},
			{line:"color: '#F7464A',"},
			{line:"highlight: '#FF5A5E',"},
			{line:"label: 'Red'"},
			{line:"},"},
			{line:"{"},
			{line:"value: 50,"},
			{line:"color: '#46BFBD',"},
			{line:"highlight: '#5AD3D1',"},
			{line:"label: 'Green'"},
			{line:"},"},
			{line:"{"},
			{line:"value: 100,"},
			{line:"color: '#FDB45C',"},
			{line:"highlight: '#FFC870',"},
			{line:"label: 'Yellow'"},
			{line:"},"},
			{line:"{"},
			{line:"value: 40,"},
			{line:"color: '#949FB1',"},
			{line:"highlight: '#A8B3C5',"},
			{line:"label: 'Grey'"},
			{line:"},"},
			{line:"{"},
			{line:"value: 120,"},
			{line:"color: '#4D5360',"},
			{line:"highlight: '#616774',"},
			{line:"label: 'Dark Grey'"},
			{line:"}"},
			{line:"]"},
			{line:"}"},
		];
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Standard Polar Area Chart',
			description : 'Define a '+this.addBoldTag('$polarareachart')+' layout object and set sizes accordingly. The chart is driven by the provided data object. Use '+this.addBoldTag('color')+' and '+this.addBoldTag('highlight')+' to define the colors for each segment.',
			
			dynamicCode:[
				{line:"{type:'$polarareachart',key:'simple-polar-area-chart',data:'=[data]',width:'200px;',height:'200px;'}"},
			],
			dynamicData: chartData
		},
		
		{
			/* --- --- */
			header : 'Responsive Polar Area Chart',
			description : 'To make the chart responsive use the options object and set the '+this.addBoldTag('responsive')+' flag to true.',
			
			dynamicCode:[
				{line:"{type:'$polarareachart',key:'responsive-polararea-chart',data:'=[data]',width:'200px;',height:'200px;',"},
				{line:"options:{responsive:true}"},
				{line:"}"},
			],
			dynamicData: chartData
		},
		
	];
	
	return data;
}

ClientMethod getDataRadarChart() [ Language = javascript ]
{
	var data = {
		widgetname:'Radar Chart',
		description:'A radar chart is a way of showing multiple data points and the variation between them. They are often useful for comparing the points of two or more different data sets.',
		headercontent:'Using $radarchart',
		link:'Charts.js Radar Chart documentation',
		linkAddress:'http://www.chartjs.org/docs/#radar-chart'
	};
	
	data.sections = [
		
		{
			/* --- --- */
			header : 'Standard Radarchart',
			description : 'Define a '+this.addBoldTag('$radarchart')+' layout object and set sizes accordingly. The chart is driven by the provided data object.',
			
			dynamicCode:[
				{line:"{type:'$radarchart',key:'simple-radar-chart',data:'=[data]',width:'400px;',height:'400px;'"},
				{line:"}"},
			],
			dynamicData:[
				{line:"{"},
				{line:"data: {"},
				{line:"labels: ['Eating', 'Drinking', 'Sleeping', 'Designing', 'Coding', 'Cycling', 'Running'],"},
    			{line:"datasets: ["},
        		{line:"{"},
				{line:"label: 'My First dataset',"},
				{line:"data: [65, 59, 90, 81, 56, 55, 40]"},
				{line:"},"},
				{line:"{"},
				{line:"label: 'My Second dataset',"},
				{line:"data: [28, 48, 40, 19, 96, 27, 100]"},
				{line:"}"},
    			{line:"]"},
				{line:"}"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Radar with custom colors',
			description : 'Use '+this.addBoldTag('fillColor')+', '+this.addBoldTag('strokeColor')+', '+this.addBoldTag('pointColor')+', '+this.addBoldTag('pointStrokeColor')+', '+this.addBoldTag('pointHighlightFill')+' and '+this.addBoldTag('pointHighlightStroke')+' to define the appearance of the lines and points.',
			
			dynamicCode:[
				{line:"{type:'$radarchart',key:'radar-chart',data:'=[data]',width:'400px;',height:'400px;'"},
				{line:"}"},
			],
			dynamicData:[
				{line:"{"},
				{line:"data: {"},
				{line:"labels: ['Eating', 'Drinking', 'Sleeping', 'Designing', 'Coding', 'Cycling', 'Running'],"},
    			{line:"datasets: ["},
        		{line:"{"},
				{line:"label: 'My First dataset',"},
				{line:"fillColor: 'rgba(220, 220, 220, 0.2)',"},
				{line:"strokeColor: 'rgba(220, 220, 220, 1)',"},
				{line:"pointColor: 'rgba(220, 220, 220, 1)',"},
				{line:"pointStrokeColor: '#fff',"},
				{line:"pointHighlightFill: '#fff',"},
				{line:"pointHighlightStroke: 'rgba(220, 220, 220, 1)',"},
				{line:"data: [65, 59, 90, 81, 56, 55, 40]"},
				{line:"},"},
				{line:"{"},
				{line:"label: 'My Second dataset',"},
				{line:"fillColor: 'rgba(151, 187, 205 , 0.2)',"},
				{line:"strokeColor: 'rgba(151, 187, 205, 1)',"},
				{line:"pointColor: 'rgba(151, 187, 205 , 1)',"},
				{line:"pointStrokeColor: '#fff',"},
				{line:"pointHighlightFill: '#fff',"},
				{line:"pointHighlightStroke: 'rgba(151, 187, 205, 1)',"},
				{line:"data: [28, 48, 40, 19, 96, 27, 100]"},
				{line:"}"},
    			{line:"]"},
				{line:"}"},
				{line:"}"},
			]
		},
		
		{
			/* --- --- */
			header : 'Responsive Radarchart',
			description : 'To make the chart responsive use the options object and set the '+this.addBoldTag('responsive')+' flag to true.',
			
			dynamicCode:[
				{line:"{type:'$radarchart',key:'responsive-radar-chart',data:'=[data]',"},
				{line:"options:{responsive:true}"},
				{line:"}"},
			],
			dynamicData:[
				{line:"{"},
				{line:"data: {"},
				{line:"labels: ['Eating', 'Drinking', 'Sleeping', 'Designing', 'Coding', 'Cycling', 'Running'],"},
    			{line:"datasets: ["},
        		{line:"{"},
				{line:"label: 'My First dataset',"},
				{line:"fillColor: 'rgba(220, 220, 220, 0.2)',"},
				{line:"strokeColor: 'rgba(220, 220, 220, 1)',"},
				{line:"pointColor: 'rgba(220, 220, 220, 1)',"},
				{line:"pointStrokeColor: '#fff',"},
				{line:"pointHighlightFill: '#fff',"},
				{line:"pointHighlightStroke: 'rgba(220, 220, 220, 1)',"},
				{line:"data: [65, 59, 90, 81, 56, 55, 40]"},
				{line:"},"},
				{line:"{"},
				{line:"label: 'My Second dataset',"},
				{line:"fillColor: 'rgba(151, 187, 205 , 0.2)',"},
				{line:"strokeColor: 'rgba(151, 187, 205, 1)',"},
				{line:"pointColor: 'rgba(151, 187, 205 , 1)',"},
				{line:"pointStrokeColor: '#fff',"},
				{line:"pointHighlightFill: '#fff',"},
				{line:"pointHighlightStroke: 'rgba(151, 187, 205, 1)',"},
				{line:"data: [28, 48, 40, 19, 96, 27, 100]"},
				{line:"}"},
    			{line:"]"},
				{line:"}"},
				{line:"}"},
			]
		},
		
	];
	
	return data;
}

}
