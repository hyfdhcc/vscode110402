/// For these examples, streams are derived from XDATA blocks within this class. In
/// a real-world scenario streams (or files) would come from an external source
Class XSLT2.Examples Extends %RegisteredObject
{

/// This demonstrates a transformation by simply sorting the elements within the XML
ClassMethod Example1()
{
    #dim tSC As %Status = $$$OK
    
    #dim e As %Exception.AbstractException
    #dim tOutput As %Stream
    
    try {
        #; Get a stream of XML from the ExampleXML block contained in this class
        Set tSource=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||ExampleXML").Data
        If '$IsObject(tSource) Set tSC=%objlasterror Quit
        
        #; Get a stream of XSL from the ExampleXSL block contained in this class
        Set tXSL=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||Example1XSL").Data
        If '$IsObject(tXSL) Set tSC=%objlasterror Quit
        
        #; Transform the source according to the XSL
        Set tSC=##class(%XML.XSLT2.Transformer).TransformStream(tSource,tXSL,.tOutput)
        If $$$ISERR(tSC) Quit
        
        #; Output the result to the screen
        Set tSC=tOutput.OutputToDevice()
        
    } catch (e) {
        Set tSC=e.AsStatus()
    }
       
    If $$$ISERR(tSC) Do $System.Status.DisplayError(tSC)
}

/// This demonstrates a passing top level parameters to a style sheet
ClassMethod Example2()
{
    #dim tSC As %Status = $$$OK
    
    #dim e As %Exception.AbstractException
    #dim tOutput As %Stream
    
    try {
        #; Get a stream of XML from the ExampleXML block contained in this class
        Set tSource=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||ExampleXML").Data
        If '$IsObject(tSource) Set tSC=%objlasterror Quit
        
        #; Get a stream of XSL from the ExampleXSL block contained in this class
        Set tXSL=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||Example2XSL").Data
        If '$IsObject(tXSL) Set tSC=%objlasterror Quit
        
        #; Transform the source according to the XSL
        Set tParameters("title")="Results Sorted By Continent And City"
       
        #; Transform the source according to the XSL
        Set tSC=##class(%XML.XSLT2.Transformer).TransformStream(tSource,tXSL,.tOutput,,.tParameters)
        If $$$ISERR(tSC) Quit
        
        #; Output the result to the screen
        Set tSC=tOutput.OutputToDevice()
        
    } catch (e) {
        Set tSC=e.AsStatus()
    }
       
    If $$$ISERR(tSC) Do $System.Status.DisplayError(tSC)
}

/// This demonstrates calling cache via the isc:evaluate() function, the title is transformed
/// from a reversed string to the readable representation by calling into cache
ClassMethod Example3()
{
    #dim tSC As %Status = $$$OK
    
    #dim e As %Exception.AbstractException
    #dim tOutput As %Stream
    #dim tParameters As %String
    
    try {
        #; Get a stream of XML from the ExampleXML block contained in this class
        Set tSource=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||ExampleXML").Data
        If '$IsObject(tSource) Set tSC=%objlasterror Quit
        
        #; Get a stream of XSL from the ExampleXSL block contained in this class
        Set tXSL=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||Example3XSL").Data
        If '$IsObject(tXSL) Set tSC=%objlasterror Quit
        
        #; Get a Callback handler to handle the extension calls to cache-evaluate()
        Set tCallbackHandler=##Class(%XML.XSLT.CallbackHandler).%New()
        If '$IsObject(tCallbackHandler) Set tSC=%objlasterror Quit
        
        #; Set a parameter
        Set tParameters("title")="YTIC dnA tnenitnoC yB detroS stluseR"
        
        #; Transform the source according to the XSL
        Set tSC=##class(%XML.XSLT2.Transformer).TransformStream(tSource,tXSL,.tOutput,,.tParameters,tCallbackHandler)
        If $$$ISERR(tSC) Quit
        
        #; Output the result to the screen
        Set tSC=tOutput.OutputToDevice()
        
    } catch (e) {
        Set tSC=e.AsStatus()
    }
       
    If $$$ISERR(tSC) Do $System.Status.DisplayError(tSC)
}

/// Example 4, Transform a stream. For this example, streams are derived from XDATA blocks within this class. In
/// a real-world scenario streams would come from an external source
ClassMethod Example4()
{
	#dim tSC As %Status = $$$OK
	#dim tOutput
	
	do {
		#; Get a stream of XML from the ExampleXML block contained in this class
		Set tSource=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||Example4XML").Data
		If '$IsObject(tSource) Set tSC=%objlasterror Quit
		
		#; Get a stream of XSL from the ExampleXSL block contained in this class
		Set tXSL=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||Example4XSL").Data
		If '$IsObject(tXSL) Set tSC=%objlasterror Quit
		
		#; Transform the source according to the XSL
		Set tSC=##class(%XML.XSLT2.Transformer).TransformStream(tSource,tXSL,.tOutput)
		If $$$ISERR(tSC) Quit
		
		#; Output the result to the screen
		Set tSC=tOutput.OutputToDevice()
	} while (0)
	
	If $$$ISERR(tSC) {
		Do $system.Status.DisplayError(tSC)
	}
}

/// Example 5, Transform a stream. For this example, streams are derived from XDATA blocks within this class. In
/// a real-world scenario streams would come from an external source. The XSL specification is first compiled
/// and then is used to transform the source. This is useful for when the same stylesheet needs to be applied
/// to many different xml sources as it can result in considerable performance improvements.
ClassMethod Example5()
{
	#dim tSC As %Status = $$$OK
	#dim tCompiledStyleSheet As %XML.XSLT2.CompiledStyleSheet
	#dim tOutput
	
	do {
		#; Get a stream of XSL from the ExampleXSL block contained in this class
		Set tXSL=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||Example4XSL").Data
		If '$IsObject(tXSL) Set tSC=%objlasterror Quit
		
		Set tSC=##class(%XML.XSLT2.CompiledStyleSheet).CreateFromStream(tXSL,.tCompiledStyleSheet)
		If $$$ISERR(tSC) Quit
		
		#; Get a stream of XML from the ExampleXML block contained in this class
		Set tSource=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||Example4XML").Data
		If '$IsObject(tSource) Set tSC=%objlasterror Quit
	
		#; Transform the source according to the XSL
		Set tSC=##class(%XML.XSLT2.Transformer).TransformStreamWithCompiledXSL(tSource,tCompiledStyleSheet,.tOutput)
		If $$$ISERR(tSC) Quit
		
		Do tCompiledStyleSheet.%Close()
		
		#; Output the result to the screen
		Set tSC=tOutput.OutputToDevice()
		
	} while (0)
	
	If $$$ISERR(tSC) {
		Do $system.Status.DisplayError(tSC)
	}
}

/// Example6, Transform a stream. For this example, streams are derived from XDATA blocks within this class. In
/// a real-world scenario streams would come from an external source. Here we install the default Callback Handler
ClassMethod Example6()
{
	#dim tSC As %Status = $$$OK
	#dim tOutput,tParameters
	
	do {
		#; Get a stream of XML from the ExampleXML block contained in this class
		Set tSource=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||Example4XML").Data
		If '$IsObject(tSource) Set tSC=%objlasterror Quit
		
		#; Get a stream of XSL from the ExampleXSL block contained in this class
		Set tXSL=##class(%Dictionary.CompiledXData).%OpenId($classname()_"||Example6XSL").Data
		If '$IsObject(tXSL) Set tSC=%objlasterror Quit
		
		#; Get a Callback handler to handle the extension calls to cache-evaluate()
		Set tCallbackHandler=##Class(%XML.XSLT.CallbackHandler).%New()
		If '$IsObject(tCallbackHandler) Set tSC=%objlasterror Quit
		
		Set tParameters("madrid")="spain"
		Set tParameters("rome")="italy"

		#; Transform the source according to the XSL
		Set tSC=##class(%XML.XSLT2.Transformer).TransformStream(tSource,tXSL,.tOutput,,.tParameters,tCallbackHandler)
		If $$$ISERR(tSC) Quit
		
		#; Output the result to the screen
		Set tSC=tOutput.OutputToDevice()
	} while (0)
	
	If $$$ISERR(tSC) {
		Do $system.Status.DisplayError(tSC)
	}
}

XData ExampleXML
{
<?xml version="1.0" encoding="UTF-8"?>
<world>
<country name="Canada" continent="North America">
<city>Toronto</city>
<city>Vancouver</city>
</country>
<country name="Jamaica" continent="North America">
<city>Kingston</city>
<city>Ocho Rios</city>
</country>
<country name="United States" continent="North America">
<city>Boston</city>
<city>Baltimore</city>
</country>
<country name="United Kingdom" continent="Europe">
<city>London</city>
<city>Glasgow</city>
</country>
<country name="France" continent="Europe">
<city>Paris</city>
<city>Nice</city>
</country>
<country name="Japan" continent="Asia">
<city>Tokyo</city>
<city>Osaka</city>
</country>
</world>
}

XData Example1XSL
{
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"  exclude-result-prefixes="fo xs xdt fn" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
<xsl:template match="/">
<xsl:element name="world">
<xsl:for-each-group select="//country" group-by="@continent">
<xsl:sort select="@continent" data-type="text" order="ascending"/>
<xsl:variable name="continent" select="@continent"/>
<xsl:apply-templates select="//country[@continent = $continent]" mode="group">
<xsl:sort select="@name" data-type="text" order="ascending"/>
</xsl:apply-templates>
</xsl:for-each-group>
</xsl:element>
</xsl:template>
<xsl:template match="*" mode="group">
<xsl:copy-of select="."/>
</xsl:template>
</xsl:stylesheet>
}

XData Example2XSL
{
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="fo xs xdt fn" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
<xsl:param name="title"/>
<xsl:template match="/">
<title>
<xsl:value-of select="$title"/>
</title>
<xsl:element name="world">
<xsl:for-each-group select="//country" group-by="@continent">
<xsl:sort select="@continent" data-type="text" order="ascending"/>
<xsl:variable name="continent" select="@continent"/>
<xsl:apply-templates select="//country[@continent = $continent]" mode="group">
<xsl:sort select="@name" data-type="text" order="ascending"/>
</xsl:apply-templates>
</xsl:for-each-group>
</xsl:element>
</xsl:template>
<xsl:template match="*" mode="group">
<xsl:copy-of select="."/>
</xsl:template>
</xsl:stylesheet>
}

XData Example3XSL
{
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="isc java fo xs xdt fn" xmlns:isc="com.intersys.xsltgateway.XSLTGateway" xmlns:java="java" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
<xsl:param name="title"/>
<xsl:template match="/">
<title>
<xsl:value-of select="isc:evaluate($title)"/>
</title>
<xsl:element name="world">
<xsl:for-each-group select="//country" group-by="@continent">
<xsl:sort select="@continent" data-type="text" order="ascending"/>
<xsl:variable name="continent" select="@continent"/>
<xsl:apply-templates select="//country[@continent = $continent]" mode="group">
<xsl:sort select="@name" data-type="text" order="ascending"/>
</xsl:apply-templates>
</xsl:for-each-group>
</xsl:element>
</xsl:template>
<xsl:template match="*" mode="group">
<xsl:copy-of select="."/>
</xsl:template>
</xsl:stylesheet>
}

XData Example4XML
{
<?xml version="1.0" ?>
<s1 title="s1 title attr">
  <s2 title="s2 title attr">
    <s3 title="s3 title attr">Content</s3>
  </s2>
</s1>
}

XData Example4XSL
{
<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

<xsl:output method="xml" indent="yes"/>
 
<xsl:template match="//@* | //node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
}

XData Example5XSL
{
<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:isc="com.intersys.xsltgateway.XSLTGateway">

<xsl:output method="xml" indent="yes"/>
 
<xsl:template match="//@* | //node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template> 

</xsl:stylesheet>
}

XData Example6XSL
{
<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version ="2.0" xmlns:isc="com.intersys.xsltgateway.XSLTGateway" xmlns:java="java">
  <xsl:param name ="madrid"/>
  <xsl:template match="/">
    <abc>
      <xsl:value-of select="$madrid"/>
      <xsl:value-of select="isc:evaluate(.)"/>
    </abc>
    </xsl:template>
</xsl:stylesheet>
}

}
