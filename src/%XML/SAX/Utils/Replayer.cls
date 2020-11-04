/// This classes exposes a single class method which can replay a recording of an XML Parse
/// Use the %XML.SAX.Recorder content handler to record the sequence of calls and their parameters
/// made by the SAX parser. You can then substitute your own content handler witht the Replay method
/// below to simulate a parse by the SAX parser. This greatly aids in debugging as the debugger cannot
/// be activated during a regular CacheSAX callback.
Class %XML.SAX.Utils.Replayer Extends %RegisteredObject [ Not ProcedureBlock, System = 3 ]
{

/// Target is the key in CacheTemp into which %XML.SAX.Recorder has placed its data
/// Handler is your %XML.SAX.ContentHandler subclass
ClassMethod Replay(Target As %Integer, Handler As %XML.SAX.ContentHandler)
{
#;
#; Replay the XML Parse by sequentially processing Target and dispatching to the Handler
 New seq,type Set seq="" For   Set seq=$Order(^CacheTemp(Target,seq)) Quit:seq=""  Do
#;
#; Determine Type
 . Set type=^CacheTemp(Target,seq)
#;
#; characters
 . If type="characters" Do  Quit
 . . Do Handler.characters(^CacheTemp(Target,seq,"chars"),^CacheTemp(Target,seq,"length"))
#;
#; endDocument 
 . If type="endDocument" Do Handler.endDocument() Quit
#;
#; endElement
 . If type="endElement" Do  Quit
 . . Do Handler.endElement(^CacheTemp(Target,seq,"uri"),^CacheTemp(Target,seq,"localname"),^CacheTemp(Target,seq,"qname"))
#;
#; endPrefixMapping
 . If type="endPrefixMapping" Do Handler.endPrefixMapping(^CacheTemp(Target,seq,"prefix")) Quit
#;
#; error
 . If type="error" Do Handler.error(^CacheTemp(Target,seq,"error")) Quit
#;
#; fatalError
 . If type="fatalError" Do Handler.fatalError(^CacheTemp(Target,seq,"fatalError")) Quit
#;
#; ignorableWhitespace
 . If type="ignorableWhitespace" Do Handler.ignorableWhitespace(^CacheTemp(Target,seq,"chars"),^CacheTemp(Target,seq,"length")) Quit
#;
#; processingInstruction
 . If type="processingInstruction" Do Handler.processingInstruction(^CacheTemp(Target,seq,"target"),^CacheTemp(Target,seq,"data")) Quit
#;
#; skippedEntity
 . If type="skippedEntity" Do Handler.SkippedEntity(^CacheTemp(Target,seq,"name")) Quit
#;
#; startDocument
 . If type="startDocument" Do Handler.startDocument() Quit
#;
#; startElement
 . If type="startElement" Do  Quit
 . . Do Handler.startElement(^CacheTemp(Target,seq,"uri"),^CacheTemp(Target,seq,"localname"),^CacheTemp(Target,seq,"qname"),^CacheTemp(Target,seq,"attrs")) Quit
#;
#; startPrefixMapping
 . If type="startPrefixMapping" Do Handler.startPrefixMapping(^CacheTemp(Target,seq,"prefix"),^CacheTemp(Target,seq,"uri")) Quit
#;
#; warning
 . If type="warning" Do Handler.warning(^CacheTemp(Target,seq,"warning")) Quit
#;
#; comment
 . If type="comment" Do Handler.comment(^CacheTemp(Target,seq,"chars"),^CacheTemp(Target,seq,"length")) Quit
#;
#; endCDATA
 . If type="endCDATA" Do Handler.endCDATA() Quit
#;
#;
 . If type="endDTD" Do Handler.endDTD() Quit
#;
#; endEntity
 . If type="endEntity" Do Handler.endEntity(^CacheTemp(Target,seq,"name")) Quit
#;
#; startCDATA
 . If type="startCDATA" Do Handler.startCDATA() Quit
#;
#; startDTD
 . If type="startDTD" Do Handler.startDTD(^CacheTemp(Target,seq,"name"),^CacheTemp(Target,seq,"publicId"),^CacheTemp(Target,seq,"systemId")) Quit
#;
#; startEntity
 . If type="startEntity" Do Handler.startEntity(^CacheTemp(Target,seq,"name")) Quit
#;
#; Type unrecognized
 . ZT
}

}
