Class %iKnow.Model.nodeWithParameters Extends %iKnow.Model.node [ Abstract, System = 3 ]
{

Relationship parameters As array Of %iKnow.Model.parameter(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = parent ];

}
