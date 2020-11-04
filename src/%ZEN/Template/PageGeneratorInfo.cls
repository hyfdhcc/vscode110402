/// This utility class is used to pass information to a <class>PageGenerator</class> class.
Class %ZEN.Template.PageGeneratorInfo Extends %RegisteredObject [ System = 4 ]
{

/// Full name of class being generated.
Property ClassName As %String(MAXLEN = 255);

/// Description of new class.
Property Description As %String(MAXLEN = 2000);

/// Page name for new class.
Property PageName As %String(MAXLEN = 255);

/// Page title for new class.
Property PageTitle As %String(MAXLEN = 255);

/// Array of additional data (name/value pairs) provided by Wizard.
Property %Data As %String [ MultiDimensional ];

}
