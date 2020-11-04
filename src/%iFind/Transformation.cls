Include %IFInclude

/// This table contains all transformations currently in use by iFind indices with namespace-shared
/// storage. (cf IFINDSHAREDSTORAGELOCATION parameter in <class>%iFind.Index.Basic</class>)
Class %iFind.Transformation Extends %Persistent [ Final, StorageStrategy = iFindStorage, System = 4 ]
{

Parameter READONLY = 1;

/// Specification uniquely describing this transformation.
Property Specification As %String(COLLATION = "EXACT", MAXLEN = 150);

/// General type of transformation
Property Type As %String [ Calculated, SqlComputeCode = { set {*} = $piece({Specification},":",1)}, SqlComputed ];

Index SpecificationIdx On Specification [ Type = collatedkey, Unique ];

/// Applies this transformation to <var>pString</var>
Method Transform(pString As %String, pLanguage As %String = "") As %String
{
	do ##class(%iFind.Utils).ApplyTransformation(.tTransformed, pString, ..Specification, pLanguage)
	if $d(tTransformed)>1 {
		set tComposite = ""
		for i = 1:1:tTransformed { set tComposite = tComposite_$s(i=1:"",1:" ")_tTransformed(i) }
		quit tComposite
	} else {
		quit tTransformed
	}
}

Storage iFindStorage
{
<Data name="TransformationDefaultData">
<Attribute>Specification</Attribute>
<Structure>node</Structure>
</Data>
<DataLocation>^ISC.IF.TransfoD</DataLocation>
<IdLocation>^ISC.IF.TransfoD</IdLocation>
<Index name="SpecificationIdx">
<Location>^ISC.IF.TransfoI</Location>
</Index>
<IndexLocation>^ISC.IF.TransfoI</IndexLocation>
<StreamLocation>^ISC.IF.TransfoS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
