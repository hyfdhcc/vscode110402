/// <p>This class abstracts a Word Transformation, an operation that translates a given actual word (as
/// found in a document to be indexed) in some more "normalized" form. For example, stemming normalizes
/// verbs, nouns and other conjugated words by transforming them into their base form (= normalized form).
/// When a user then wants to search for a conjugated word, the search query will be processed by the same
/// transformation used at indexing time and any conjugated form that maps to the same base form will
/// be considered a match.</p>
/// <p>The transformation(s) to be applied at indexing time can be supplied through the TRANSFORMATIONSPEC
/// index parameter (see <class>%iFind.Index.Basic</class>). At search time, the search option argument
/// can be used to identify which transformation to apply to the search string. This can be either one
/// of these transformation specification strings defined in the index parameter, an asterisk (*) to
/// identify the default transformation of the index parameter or 0 to do an exact search on the non-
/// transformed string.</p>
/// <p>Custom transformations can be created by implementing this class and implementing the <method>Transform</method>
/// method. This class can then be referred in the TRANSFORMATIONSPEC index parameter as described above.
/// </p>
Class %iFind.Transformation.Abstract Extends %RegisteredObject [ Abstract, System = 4 ]
{

/// This method transforms <var>pString</var> into a "normalized" form <var>pTransformed</var>, based
/// on the language context <var>pLanguage</var>.<br />
/// Implementations of this class can optionally be parameterized through the <var>pArguments</var> string, which
/// can be supplied through the TRANSFORMATIONSPEC index parameter.
ClassMethod Transform(Output pTransformed As %String, ByRef pString As %String, pArguments As %String = "", pLanguage As %String = "") As %Status [ Abstract ]
{
}

}
