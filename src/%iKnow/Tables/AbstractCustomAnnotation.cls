Class %iKnow.Tables.AbstractCustomAnnotation Extends %Persistent [ Abstract, NoExtent, System = 4 ]
{

Property Parts As list Of %Integer;

/// Note that it is recommended to keep Code unique per Part ID!
Property Code As %String(MAXLEN = 10);

Property Value As %String(MAXLEN = 150);

Index PartIdx On Parts(ELEMENTS) [ Data = Code ];

}
