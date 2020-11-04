/// 
Class %ZEN.Report.Display.textNode Extends contentNode [ Abstract, System = 4 ]
{

Property field As %ZEN.Datatype.string;

/// expression that will be evaluated and put in output if "if" condition is true
Property expression As %ZEN.Datatype.string;

/// if expression that controls output of expression
Property if As %ZEN.Datatype.string [ InitialExpression = "1" ];

/// When set, the bidi-override is applied to the text
Property bidiOverrideDirection As %ZEN.Datatype.string(VALUELIST = ",rtl,ltr", XMLNAME = "bidi-override-direction");

}
