/// Meta-data object for a DeepSee cube.<br/>
Class %DeepSee.Model.cube Extends (node, %CSP.Portal.AbstractPortalModel) [ System = 3 ]
{

/// Optional. If true, this is the name of another, pre-existing, cube that this cube inherits from.<br/>
/// A cube can only inherit from one base cube; there is no possibility of multiple-inheritance.
Property inheritsFrom As %DeepSee.Datatype.entityName(XMLPROJECTION = "attribute");

/// Optional. If true, then this cube definition is an "abstract" cube. It can be used as
/// a base cube for other cubes, but it cannot be built (loaded with data) or queried against.
Property abstract As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

/// Name of class that provides the original data.<br/>
/// This should either be the name of persistent class or a subclass
/// of <class>%DeepSee.DataConnector</class>.<br/>
/// This is used to generate code that updates the cube from
/// the original data.<br/>
/// It is also used to enable drill-through.
Property sourceClass As %DeepSee.Datatype.className(XMLPROJECTION = "attribute") [ Required ];

/// If a version number is present, on compile this class will generate a new class represetning this version of the cube 
/// and compile that. This new version can be built while the previous version is still active. Once activated, a new version 
/// will be queried.
Property version As %Integer(XMLPROJECTION = "attribute");

/// Optional. Name of a DeepSee KPI class that provides Dashboard Actions for this cube.<br/>
/// If provided, then a dashboard based on this cube will be able to invoke the actions
/// defined within the given KPI class.
Property actionClass As %DeepSee.Datatype.className(XMLPROJECTION = "attribute");

/// Optional. The resource needed to view or edit this cube:<br/>
/// If defined and the current user holds the USE privilege on this resource, then
/// the user may view (run queries against) this item.<br/>
/// If defined and the current user holds the WRITE privilege on this resource, then
/// the user may modify this item.<br/>
Property resource As %String(MAXLEN = 255, XMLPROJECTION = "attribute");

/// This is the user name of the owner of this cube.<br/>
/// This is used for determining some privileges for this cube.
Property owner As %DeepSee.Datatype.string(MAXLEN = 250, XMLPROJECTION = "attribute");

/// Optional. If specified, this is the ORDER BY clause applied to the SQL statement
/// used when this cube is initially built (by %BuildCube). It must contain a valid
/// ORDER BY clause, e.g., "DateOfBirth"
/// <br/>
/// This makes it possible to apply an ordering to the initial facts loaded into a cube,
/// which may be useful in some cases.<br/>
/// This property is ignored by cubes that use data connectors.<br/>
/// If this property is defined, then BuildCube will not use parallel processing.
/// This ordering is not applied to incremental updates to the cube.
Property initialBuildOrder As %DeepSee.Datatype.string(MAXLEN = 2000, XMLPROJECTION = "attribute");

/// Optional. If specified, this is placed in the WHERE clause applied to the SQL statement
/// used when this cube is initially built (by %BuildCube). It must contain a valid
/// SQL expression, e.g., "State='WY'"
/// <br/>
/// This makes it possible to apply a restriction to the facts loaded into a cube,
/// which may be useful in some cases.<br/>
/// This property is also used in the SQL queries used to update cubes.
/// This property is ignored by cubes that use data connectors.<br/>
Property buildRestriction As %DeepSee.Datatype.string(MAXLEN = 2000, XMLPROJECTION = "attribute");

/// This is used as the caption text when utilities display this cube.
/// This overrides the displayName property, if it is used.
Property caption As %DeepSee.Datatype.string(MAXLEN = 250, XMLPROJECTION = "attribute");

/// Dimensions defined for this cube.
Relationship dimensions As %DeepSee.Model.dimension(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = cube ];

/// Measures defined for this cube.<br/>
Relationship measures As %DeepSee.Model.measure(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = cube ];

/// Relationships defined for this cube.
Relationship relationships As %DeepSee.Model.relationship(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = cube ];

/// Additional indices defined for this cube.<br/>
/// This provides a way to add extra indices to the fact table for the cube.
Relationship indices As %DeepSee.Model.index(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = cube ];

/// Additional expressions defined for this cube.<br/>
/// This provides a way to compute a value that can be used in one or more source expressions when building this cube.
Relationship expressions As %DeepSee.Model.expression(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = cube ];

/// Deprecated.
Property defaultMeasure As %DeepSee.Datatype.entityName(XMLPROJECTION = "attribute");

/// Deprecated.
Property defaultMember As %String(MAXLEN = 200, XMLPROJECTION = "attribute");

/// Optional. If defined, this is used as the display value for
/// any members of any level within this cube whose value is null (missing) and has
/// not has its local <property>nullReplacement</property> property set.
Property nullReplacement As %DeepSee.Datatype.string(XMLPROJECTION = "attribute");

/// Optional. If defined, this is used as the logical name for
/// the built-in %Count measure.
Property countMeasureName As %DeepSee.Datatype.string(XMLPROJECTION = "attribute") [ InitialExpression = "%COUNT" ];

/// Optional. If defined, this is used as the (localized) display value for
/// the built-in %Count measure.
Property countMeasureCaption As %DeepSee.Datatype.string(XMLPROJECTION = "attribute");

/// Calculated members defined for this cube.<br/>
Relationship calculatedMembers As %DeepSee.Model.calculatedMember(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = cube ];

/// Named sets defined for this cube.<br/>
Relationship namedSets As %DeepSee.Model.namedSet(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = cube ];

/// List of available cube time functions.
/// Available when cube is compiled.
Property %timeFunctions As %String(XMLPROJECTION = "none") [ Internal, MultiDimensional ];

/// Specifies the size of the caching buckets used for this cube.<br/>
/// The bucket size is a number of data blocks, each containing 64000 facts. These
/// are used to cache intermediate results by queries executed against this cube.
/// For example, setting this to 10 would creates caching buckets that each contain 640000 facts.<br/>
/// In some cases, you may want to increase this value if you expect to have a large number of facts
/// and do not expect many updates to older values within the cube.<br/>
/// If you change this value, you must be sure to delete all cached results for this cube.
/// You can do this using the %KillCache method of the cube definition class.<br/>
/// The default value is 8.
Property bucketSize As %Integer(MINVAL = 1, XMLPROJECTION = "attribute") [ InitialExpression = 8 ];

/// Defines how to build indices for this cube.<br/>
/// If true, DeepSee builds its indices using local memory which is a faster
/// means of doing this. For cubes with many indices (dimensions and measures) or dimensions with
/// a *large* number of members, the set of index values might not fit in local memory, leading
/// to a <STORE> error when the cube is built. If this occurs, set this property to false to 
/// use a slower, non-local-memory algorithm (the default).
Property bitmapChunkInMemory As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

/// Optional. If specified, this is the name of the listing
/// (in the <property>listing</property> list) that
/// is used as the default RETURN clause for DRILLTHROUGH
/// queries against this cube.
Property defaultListing As %String(MAXLEN = 255, XMLPROJECTION = "attribute");

/// Listings defined for this cube.<br/>
/// If no listings are defined, then the Show Listing feature of the Analyzer will be disabled.
Relationship listings As %DeepSee.Model.listing(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = cube ];

/// Listing fields defined for this cube.<br/>
Relationship listingFields As %DeepSee.Model.listingField(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = cube ];

/// Specify if certain aggregates and counts should be pre-computed when this cube is built.
/// If set to 0, then no precomputation is done. If set 1, counts and aggregates based on 1 level
/// are computed. If set to 2, then combinations of 2 levels are used.<br/>
/// For small cubes (less than 1 million facts) this does not have a very big impact. For larger
/// cubes this can help the initial performance of certain queries, though over time, the cell cache
/// will naturally build up the same set of values that would have been precomputed.<br/>
/// The default value is 0.
Property precompute As %Integer(MAXVAL = 2, MINVAL = 0, XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

/// If defined, this specifies the maximum number of facts that are initially loaded into this cube
/// by the %BuildCube method.<br/>
/// Note that this does exactly what it says; there may be <i>less</i> than this number loaded. For
/// example, the %OnProcessFact method may be used to skip some records.<br/> 
/// This is intended as a diagnostic aid when a cube is initially developed.
Property maxFacts As %Integer(MINVAL = 0, XMLPROJECTION = "attribute");

/// This setting controls whether the cube will accept the use of Listing Groups 
/// to define auxiliary listings.
Property disableListingGroups As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

// WAL172

Property additionalDescription As %DeepSee.Datatype.string;

/// Build the list of available time functions.
Method %ProcessFunctions() As %Status
{
	Do ##class(%DeepSee.Utils).%GetTimeLevelClasses(.list)
	Kill ..%timeFunctions
	Merge ..%timeFunctions = list
	Quit $$$OK
}

/// Validate this cube model for logical errors.
Method %Validate() As %Status
{
	Set tSC = $$$OK

	Try {
		If (..disabled) {
			Quit
		}

		If (..name = "") {
			Set tSC = $$$ERROR($$$GeneralError,"Cube must have a name")
			Quit
		}
		
		If (..actionClass'="") {
			// make sure Action class exists
			If ('$$$comClassDefined(..actionClass)) {
				Set tSC = $$$ERROR($$$GeneralError,"Cube actionClass does not exist: "_..actionClass)
				Quit
			}
		}

		// expressions
		Set tExprCount = ..expressions.Count()
		For e = 1:1:tExprCount {
			Set tExpr = ..expressions.GetAt(e)
			If (tExpr.disabled) {
				Continue
			}
			Set tName = $$$UPPER(tExpr.name)
			If (tName = "") {
				Set tSC = $$$ERROR($$$GeneralError,"Expression must have a name: " _ e)
				Quit
			}
			ElseIf ((tExpr.sourceProperty="")&&((tExpr.sourceExpression=""))) {
				Set tSC = $$$ERROR($$$GeneralError,"Expression must have a sourceProperty or sourceExpression attribute: " _ tExpr.name)
				Quit
			}
			// check if source property exists
			If ((tExpr.sourceProperty'="")&&((tExpr.sourceExpression=""))) {
				Set tType = ##Class(%DeepSee.Generator).%GetPropertyType(.tSC, .tParms, ..sourceClass,tExpr.sourceProperty,(tExpr.name))
				If ($$$ISERR(tSC)) {
					Set tSC = $$$ERROR($$$GeneralError,"Property referred to by expression sourceProperty not found: "_tExpr.name_":"_tExpr.sourceProperty)
					Quit
				}
			}

			If ($D(tExprNames(tName))) {
				Set tSC = $$$ERROR($$$GeneralError,"Expression with duplicate name: " _ tExpr.name)
			}
			Else {
				Set tExprNames(tName) = ""
			}
			If $$$ISERR(tSC) Quit

			Set tSC = tExpr.%Validate()
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit

		// dimensions
		Set tDimCount = ..dimensions.Count()
		For d = 1:1:tDimCount {
			Set tDim = ..dimensions.GetAt(d)
			If (tDim.disabled) {
				Continue
			}
			Set tName = $$$UPPER(tDim.name)
			If (tName = "") {
				Set tSC = $$$ERROR($$$GeneralError,"Dimension must have a name: " _ d)
			}
			ElseIf (tName = "MEASURES") {
				Set tSC = $$$ERROR($$$GeneralError,"Non-measure dimension cannot be called 'Measures': " _ d)
			}
			ElseIf (tName = "%QUALITYMEASURES") {
				Set tSC = $$$ERROR($$$GeneralError,"Dimension cannot be called '%QUALITYMEASURES': " _ d)
			}
			ElseIf ($E(tName,1,2) = "%%") {
				Set tSC = $$$ERROR($$$GeneralError,"Dimension name cannot start with '%%': " _ d)
			}
			ElseIf ($D(tDimNames(tName))) {
				Set tSC = $$$ERROR($$$GeneralError,"Dimension with duplicate name: " _ tDim.name)
			}
			Else {
				Set tDimNames(tName) = ""
			}
			If $$$ISERR(tSC) Quit

			Set tSC = tDim.%Validate()
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit

		// relationships
		Set tRelCount = ..relationships.Count()
		For r = 1:1:tRelCount {
			Set tRel = ..relationships.GetAt(r)

			Set tName = $$$UPPER(tRel.name)
			If (tName = "") {
				Set tSC = $$$ERROR($$$GeneralError,"Relationship must have a name: " _ r)
			}
			ElseIf (tName = "MEASURES") {
				Set tSC = $$$ERROR($$$GeneralError,"Relationship cannot be called 'Measures': " _ r)
			}
			ElseIf ($D(tDimNames(tName))) {
				Set tSC = $$$ERROR($$$GeneralError,"Relationship name must not be the same as another dimension or relationship: " _ tRel.name)
			}
			Else {
				Set tDimNames(tName) = ""
			}
			If $$$ISERR(tSC) Quit

			Set tSC = tRel.%Validate()
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit

		// listings
		Set tListingCount = ..listings.Count()
		For l = 1:1:tListingCount {
			Set tListing = ..listings.GetAt(l)
			If (tListing.disabled) {
				Continue
			}

			Set tName = $$$UPPER(tListing.name)
			If (tName = "") {
				Set tSC = $$$ERROR($$$GeneralError,"Listing must have a name: " _ l)
			}
			ElseIf ($D(tListingNames(tName))) {
				Set tSC = $$$ERROR($$$GeneralError,"Listing with duplicate name: " _ tListing.name)
			}
			Else {
				Set tListingNames(tName) = ""
			}
			If $$$ISERR(tSC) Quit

			Set tSC = tListing.%Validate()
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit

		// measures
		Set tMsrCount = ..measures.Count()
		For m = 1:1:tMsrCount {
			Set tMsr = ..measures.GetAt(m)
			If (tMsr.disabled) {
				Continue
			}
			Set tName = $$$UPPER(tMsr.name)
			If (tName = "") {
				Set tSC = $$$ERROR($$$GeneralError,"Measure must have a name: " _ m)
			}
			ElseIf ($D(tMsrNames(tName))) {
				Set tSC = $$$ERROR($$$GeneralError,"Measure with duplicate name: " _ tMsr.name)
			}
			Else {
				Set tMsrNames(tName) = ""
			}
			If $$$ISERR(tSC) Quit

			If ((tMsr.linkClass'="")&&(tMsr.linkProperty="")) {
				Set tSC = $$$ERROR($$$GeneralError,"Measure must define linkProperty if linkClass is defined: " _ tMsr.name)
				Quit
			}
			ElseIf ((tMsr.linkClass="")&&(tMsr.linkProperty'="")) {
				Set tSC = $$$ERROR($$$GeneralError,"Measure must define linkClass if linkProperty is defined: " _tMsr.name)
				Quit
			}
			ElseIf ((tMsr.linkClass'="")&&(tMsr.linkProperty'="")) {
				Set tType = ##Class(%DeepSee.Generator).%GetPropertyType(.tSC, .tParms, tMsr.linkClass,tMsr.linkProperty)
				If ($$$ISERR(tSC)) {
					Set tSC = $$$ERROR($$$GeneralError,"Class or property referred to by linkProperty not found: "_tMsr.name_":"_tMsr.linkClass_"."_tMsr.linkProperty)
					Quit
				}
			}

			Set tSC = tMsr.%Validate()
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit

		// indices
		Set tIdxCount = ..indices.Count()
		For i = 1:1:tIdxCount {
			Set tIndex = ..indices.GetAt(i)
			If (tIndex.disabled) {
				Continue
			}
			Set tName = $$$UPPER(tIndex.name)
			If (tName = "") {
				Set tSC = $$$ERROR($$$GeneralError,"Index must have a name: " _ i)
			}
			ElseIf ($D(tIdxNames(tName))) {
				Set tSC = $$$ERROR($$$GeneralError,"Index with duplicate name: " _ tIndex.name)
			}
			Else {
				Set tIdxNames(tName) = ""
			}
			If $$$ISERR(tSC) Quit

			Set tSC = tIndex.%Validate()
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit

		// calculated members
		// we do not check for duplicate names!
		Set tMbrCount = ..calculatedMembers.Count()
		For m = 1:1:tMbrCount {
			Set tMbr = ..calculatedMembers.GetAt(m)
			If (tMbr.disabled) {
				Continue
			}
			Set tName = $$$UPPER(tMbr.name)
			If (tName = "") {
				Set tSC = $$$ERROR($$$GeneralError,"Calculated member must have a name: " _ m)
			}
			If $$$ISERR(tSC) Quit

			Set tSC = tMbr.%Validate()
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit

		// named sets
		// we do not check for duplicate names!
		Set tMbrCount = ..namedSets.Count()
		For m = 1:1:tMbrCount {
			Set tMbr = ..namedSets.GetAt(m)
			If (tMbr.disabled) {
				Continue
			}
			Set tName = $$$UPPER(tMbr.name)
			If (tName = "") {
				Set tSC = $$$ERROR($$$GeneralError,"Named set must have a name: " _ m)
			}
			If $$$ISERR(tSC) Quit

			Set tSC = tMbr.%Validate()
			If $$$ISERR(tSC) Quit
		}
		If $$$ISERR(tSC) Quit

		// default measure for cube
		If (..defaultMeasure'="") {
			Set tName = $$$UPPER(..defaultMeasure)
			If ('$D(tMsrNames(tName))) {
				Set tSC = $$$ERROR($$$GeneralError,"Invalid default measure: " _ ..defaultMeasure)
				If $$$ISERR(tSC) Quit
			}
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}

	Quit tSC
}

/// Resolve inheritance for this cube; combine its model with that of its base cube, if present.
/// JSL4414 : Make this method not internal
Method %ResolveInheritance() As %Status
{
	Set tSC = $$$OK

	Try {
		If (..disabled || (..inheritsFrom="")) {
			Quit
		}
		Set tBaseClass = ##class(%DeepSee.Utils).%GetCubeClass(..inheritsFrom)
		If (tBaseClass="") {
			Set tSC = $$$ERROR($$$GeneralError,"Cube referred to by inheritsFrom does not exist: " _ ..inheritsFrom)
			Quit
		}
		Set tBaseCube = $ClassMethod(tBaseClass,"%GetModel")
		If ('$IsObject(tBaseCube)) {
			Set tSC = $$$ERROR($$$GeneralError,"Cube referred to by inheritsFrom is not compiled or has no definition: " _ ..inheritsFrom)
			Quit
		}

		#; resolve inheritance for base cube (if any)
		Set tSC = tBaseCube.%ResolveInheritance()
		If $$$ISERR(tSC) Quit

		// overide cube level properties
		#dim tBaseCube As %DeepSee.Model.cube
		// name is not inherited
		// caption is not inherited
		// inheritsFrom is not inherited
		// disabled is not inherited
		Set:..sourceClass="" ..sourceClass = tBaseCube.sourceClass 
		Set:..actionClass="" ..actionClass = tBaseCube.actionClass
		Set:..resource="" ..resource = tBaseCube.resource
		Set:..owner="" ..owner = tBaseCube.owner
		Set:..initialBuildOrder="" ..initialBuildOrder = tBaseCube.initialBuildOrder
		Set:..buildRestriction="" ..buildRestriction = tBaseCube.buildRestriction
		Set:..defaultMeasure="" ..defaultMeasure = tBaseCube.defaultMeasure
		Set:..defaultMember="" ..defaultMember = tBaseCube.defaultMember
		Set:..nullReplacement="" ..nullReplacement = tBaseCube.nullReplacement
		Set:..bucketSize=8 ..bucketSize = tBaseCube.bucketSize
		Set:..bitmapChunkInMemory=0 ..bitmapChunkInMemory = tBaseCube.bitmapChunkInMemory
		Set:..defaultListing="" ..defaultListing = tBaseCube.defaultListing
		Set:..maxFacts="" ..maxFacts = tBaseCube.maxFacts

		// JSL4414 let's get a few more things
		Set:..description="" ..description = tBaseCube.description
		Set:..disabled="" ..disabled = tBaseCube.disabled
		Set:..caption="" ..caption = tBaseCube.caption
		Set:..countMeasureCaption="" ..countMeasureCaption = tBaseCube.countMeasureCaption
		Set:..countMeasureName="" ..countMeasureName = tBaseCube.countMeasureName
		//end JSL4414 additions

		// for elements (dimensions etc.) we copy over the definitions from the base cube
		// unless the same top-level element exists in the sub cube. There is no inheritance
		// within an element--you get one definition or the other.

		// dimensions
		Set tDimCount = ..dimensions.Count()
		For d = 1:1:tDimCount {
			// note: if local item exists and is disabled, this overrides the base cube
			Set tDim = ..dimensions.GetAt(d)
			If ('tDim.disabled) {
				Set tName = $$$UPPER(tDim.name)
				Set:tName'="" tDimNames(tName) = ""
			}
		}
		Set tBaseDimCount = tBaseCube.dimensions.Count()
		For d = 1:1:tBaseDimCount {
			Set tBaseDim = tBaseCube.dimensions.GetAt(d)
			If ('tBaseDim.disabled) {
				Set tBaseName = $$$UPPER(tBaseDim.name)
				If ((tBaseName '= "")&&'$D(tDimNames(tBaseName))) {
					Do ..dimensions.Insert(tBaseDim)
				}
			}
		}

		// measures
		Set tMsrCount = ..measures.Count()
		For m = 1:1:tMsrCount {
			Set tMsr = ..measures.GetAt(m)
			If ('tMsr.disabled) {
				Set tName = $$$UPPER(tMsr.name)
				Set:tName'="" tMsrNames(tName) = ""
			}
		}
		Set tBaseMsrCount = tBaseCube.measures.Count()
		For m = 1:1:tBaseMsrCount {
			Set tBaseMsr = tBaseCube.measures.GetAt(m)
			If ('tBaseMsr.disabled) {
				Set tBaseName = $$$UPPER(tBaseMsr.name)
				If ((tBaseName '= "")&&'$D(tMsrNames(tBaseName))) {
					Do ..measures.Insert(tBaseMsr)
				}
			}
		}

		// expressions
		Set tExpCount = ..expressions.Count()
		For n = 1:1:tExpCount {
			Set tExp = ..expressions.GetAt(n)
			If ('tExp.disabled) {
				Set tName = $$$UPPER(tExp.name)
				Set:tName'="" tExpNames(tName) = ""
			}
		}
		Set tBaseExpCount = tBaseCube.expressions.Count()
		For n = 1:1:tBaseExpCount {
			Set tBaseExp = tBaseCube.expressions.GetAt(n)
			If ('tBaseExp.disabled) {
				Set tBaseName = $$$UPPER(tBaseExp.name)
				If ((tBaseName '= "")&&'$D(tExpNames(tBaseName))) {
					Do ..expressions.Insert(tBaseExp)
				}
			}
		}

		// relationships
		Set tRelCount = ..relationships.Count()
		For n = 1:1:tRelCount {
			Set tRel = ..relationships.GetAt(n)
			If ('tRel.disabled) {
				Set tName = $$$UPPER(tRel.name)
				Set:tName'="" tRelNames(tName) = ""
			}
		}
		Set tBaseRelCount = tBaseCube.relationships.Count()
		For n = 1:1:tBaseRelCount {
			Set tBaseRel = tBaseCube.relationships.GetAt(n)
			If ('tBaseRel.disabled) {
				Set tBaseName = $$$UPPER(tBaseRel.name)
				If ((tBaseName '= "")&&'$D(tRelNames(tBaseName))) {
					Do ..relationships.Insert(tBaseRel)
				}
			}
		}

		// indices
		Set tIdxCount = ..indices.Count()
		For n = 1:1:tIdxCount {
			Set tIdx = ..indices.GetAt(n)
			If ('tIdx.disabled) {
				Set tName = $$$UPPER(tIdx.name)
				Set:tName'="" tIdxNames(tName) = ""
			}
		}
		Set tBaseIdxCount = tBaseCube.indices.Count()
		For n = 1:1:tBaseIdxCount {
			Set tBaseIdx = tBaseCube.indices.GetAt(n)
			If ('tBaseIdx.disabled) {
				Set tBaseName = $$$UPPER(tBaseIdx.name)
				If ((tBaseName '= "")&&'$D(tIdxNames(tBaseName))) {
					Do ..indices.Insert(tBaseIdx)
				}
			}
		}

		// listings
		Set tLstCount = ..listings.Count()
		For n = 1:1:tLstCount {
			Set tLst = ..listings.GetAt(n)
			If ('tLst.disabled) {
				Set tName = $$$UPPER(tLst.name)
				Set:tName'="" tLstNames(tName) = ""
			}
		}
		Set tBaseLstCount = tBaseCube.listings.Count()
		For n = 1:1:tBaseLstCount {
			Set tBaseLst = tBaseCube.listings.GetAt(n)
			If ('tBaseLst.disabled) {
				Set tBaseName = $$$UPPER(tBaseLst.name)
				If ((tBaseName '= "")&&'$D(tLstNames(tBaseName))) {
					Do ..listings.Insert(tBaseLst)
				}
			}
		}

		// listing fields
		Set tLstCount = ..listingFields.Count()
		For n = 1:1:tLstCount {
			Set tLst = ..listingFields.GetAt(n)
			If ('tLst.disabled) {
				Set tName = $$$UPPER(tLst.name)
				Set:tName'="" tLstFldNames(tName) = ""
			}
		}
		Set tBaseLstCount = tBaseCube.listingFields.Count()
		For n = 1:1:tBaseLstCount {
			Set tBaseLst = tBaseCube.listingFields.GetAt(n)
			If ('tBaseLst.disabled) {
				Set tBaseName = $$$UPPER(tBaseLst.name)
				If ((tBaseName '= "")&&'$D(tLstFldNames(tBaseName))) {
					Do ..listingFields.Insert(tBaseLst)
				}
			}
		}

		// named sets
		Set tNstCount = ..namedSets.Count()
		For n = 1:1:tNstCount {
			Set tNst = ..namedSets.GetAt(n)
			If ('tNst.disabled) {
				Set tName = $$$UPPER(tNst.name)
				Set:tName'="" tNstNames(tName) = ""
			}
		}
		Set tBaseNstCount = tBaseCube.namedSets.Count()
		For n = 1:1:tBaseNstCount {
			Set tBaseNst = tBaseCube.namedSets.GetAt(n)
			If ('tBaseNst.disabled) {
				Set tBaseName = $$$UPPER(tBaseNst.name)
				If ((tBaseName '= "")&&'$D(tNstNames(tBaseName))) {
					Do ..namedSets.Insert(tBaseNst)
				}
			}
		}

		// calc mbrs
		Set tCmbrCount = ..calculatedMembers.Count()
		For n = 1:1:tCmbrCount {
			Set tCmbr = ..calculatedMembers.GetAt(n)
			If ('tCmbr.disabled) {
				Set tName = $$$UPPER(tCmbr.name)
				Set:tName'="" tCmbrNames(tName) = ""
			}
		}
		Set tBaseCmbrCount = tBaseCube.calculatedMembers.Count()
		For n = 1:1:tBaseCmbrCount {
			Set tBaseCmbr = tBaseCube.calculatedMembers.GetAt(n)
			If ('tBaseCmbr.disabled) {
				Set tBaseName = $$$UPPER(tBaseCmbr.name)
				If ((tBaseName '= "")&&'$D(tCmbrNames(tBaseName))) {
					Do ..calculatedMembers.Insert(tBaseCmbr)
				}
			}
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Resolve any shared dimensions within this cube.
/// Look for shared dimensions and merge their definition into this cube's.
/// There can be no local override of a shared dimension.<br/>
/// Return a list of shared dimensions organized by target cube.
Method %ResolveSharedDimensions(Output pConnections) As %Status [ Internal ]
{
	Set tSC = $$$OK

	Try {
		Kill pConnections
		If (..disabled) {
			Quit
		}

		// overide cube level properties
		#dim tBaseCube As %DeepSee.Model.cube

		// look for shared dimensions
		Set tDimCount = ..dimensions.Count()
		For d = 1:1:tDimCount {
			Set tDim = ..dimensions.GetAt(d)
			If (tDim.disabled) Continue
			If (tDim.sharesFrom'="") {
				// for a shared dimension, it is possible to override sourceProperty
				// or sourceExpression. Everything else is taken from the shared dimension.

				Set tBaseClass = ##class(%DeepSee.Utils).%GetCubeClass(tDim.sharesFrom)
				If (tBaseClass="") {
					Set tSC = $$$ERROR($$$GeneralError,"Cube referred to by sharesFrom does not exist: " _ tDim.name _ "."_ tDim.sharesFrom)
					Quit
				}
				Set tBaseCube = $ClassMethod(tBaseClass,"%GetModel")
				If ('$IsObject(tBaseCube)) {
					Set tSC = $$$ERROR($$$GeneralError,"Cube referred to by sharesFrom is not compiled or has no definition: " _ tDim.name _ "."_ tDim.sharesFrom)
					Quit
				}

				// find corresponding dimension in the base cube
				Set tFound = 0
				Set tBaseDimCount = tBaseCube.dimensions.Count()
				For bd = 1:1:tBaseDimCount {
					Set tBaseDim = tBaseCube.dimensions.GetAt(bd)
					If ($$$UPPER(tBaseDim.name)=$$$UPPER(tDim.name)) {
						Set tFound = 1
						Set tBaseDim.sharesFrom = tDim.sharesFrom
						Do ..dimensions.SetAt(tBaseDim,d)
						Quit
					}
				}

				If ('tFound) {
					Set tSC = $$$ERROR($$$GeneralError,"Dimension referred to by sharesFrom not found in referenced cube. Dimension: " _ tDim.name _ ", referenced cube: "_ tDim.sharesFrom)
					Quit
				}

				// look for local overrides
				// first build list of levels with overrides
				Kill tLocalInfo
				If ((tDim.sourceExpression'="")||(tDim.sourceProperty'="")) {
					Set tLocalInfo = tDim
				}

				For h=1:1:tDim.hierarchies.Count() {
					Set tHier = tDim.hierarchies.GetAt(h)
					If (tHier.disabled) Continue
					For l=1:1:tHier.levels.Count() {
						Set tLevel = tHier.levels.GetAt(l)
						If (tLevel.disabled) Continue
						If ((tLevel.sourceExpression'="")||(tLevel.sourceProperty'="")) {
							Set tLocalInfo($$$UPPER(tHier.name),$$$UPPER(tLevel.name)) = tLevel
						}

						For p=1:1:tLevel.properties.Count() {
							Set tProp = tLevel.properties.GetAt(p)
							If (tProp.disabled) Continue
							If ((tProp.sourceExpression'="")||(tProp.sourceProperty'="")) {
								Set tLocalInfo($$$UPPER(tHier.name),$$$UPPER(tLevel.name),$$$UPPER(tProp.name)) = tProp
							}
						}
					}
				}

				// apply overrides
				If $D(tLocalInfo) {
					Set tLocalDim = $G(tLocalInfo)
					If $IsObject(tLocalDim) {
						Set tBaseDim.localSourceProperty = tLocalDim.sourceProperty
						Set tBaseDim.localSourceExpression = tLocalDim.sourceExpression
					}
					For h=1:1:tBaseDim.hierarchies.Count() {
						Set tHier = tBaseDim.hierarchies.GetAt(h)
						For l=1:1:tHier.levels.Count() {
							Set tLevel = tHier.levels.GetAt(l)
							Set tLocalLevel = $G(tLocalInfo($$$UPPER(tHier.name),$$$UPPER(tLevel.name)))
							If $IsObject(tLocalLevel) {
								Set tLevel.localSourceProperty = tLocalLevel.sourceProperty
								Set tLevel.localSourceExpression = tLocalLevel.sourceExpression
							}

							For p=1:1:tLevel.properties.Count() {
								Set tProp = tLevel.properties.GetAt(p)
								Set tLocalProp = $G(tLocalInfo($$$UPPER(tHier.name),$$$UPPER(tLevel.name),$$$UPPER(tProp.name)))
								If $IsObject(tLocalProp) {
									Set tProp.localSourceProperty = tLocalProp.sourceProperty
									Set tProp.localSourceExpression = tLocalProp.sourceExpression
								}
							}
						}
					}
				}

				// add to shared list
				Set pConnections($$$UPPER(tDim.sharesFrom),$$$UPPER(tDim.name)) = ""
			}
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// JSL4414 -- new method
/// Not supported for direct use by customers.
Method %ApplyOverridesForDocumatic()
{
	//This method contains no logic for <member>, <expression>, or <index>, which are not currently shown
	//in Documatic anyway.
	set cubename=$$$UPPER(..name)

	//get overrides for <cube> attributes; go through these in alphabetical order

	set override=$D(^DeepSee.Overrides(cubename,"ABSTRACT"))
	set:override ..abstract=^DeepSee.Overrides(cubename,"ABSTRACT")

	set override=$D(^DeepSee.Overrides(cubename,"ACTIONCLASS"))
	set:override ..actionClass=^DeepSee.Overrides(cubename,"ACTIONCLASS")

	set override=$D(^DeepSee.Overrides(cubename,"BITMAPCHUNKINMEMORY"))
	set:override ..bitmapChunkInMemory=^DeepSee.Overrides(cubename,"BITMAPCHUNKINMEMORY")

	set override=$D(^DeepSee.Overrides(cubename,"BUCKETSIZE"))
	set:override ..bucketSize=^DeepSee.Overrides(cubename,"BUCKETSIZE")

	set override=$D(^DeepSee.Overrides(cubename,"BUILDRESTRICTION"))
	set:override ..buildRestriction=^DeepSee.Overrides(cubename,"BUILDRESTRICTION")

	set override=$D(^DeepSee.Overrides(cubename,"CAPTION"))
	set:override ..caption=^DeepSee.Overrides(cubename,"CAPTION")

	set override=$D(^DeepSee.Overrides(cubename,"COUNTMEASURECAPTION"))
	set:override ..countMeasureCaption=^DeepSee.Overrides(cubename,"COUNTMEASURECAPTION")

	set override=$D(^DeepSee.Overrides(cubename,"COUNTMEASURENAME"))
	set:override ..countMeasureName=^DeepSee.Overrides(cubename,"COUNTMEASURENAME")

	set override=$D(^DeepSee.Overrides(cubename,"DEFAULTLISTING"))
	set:override ..defaultListing=^DeepSee.Overrides(cubename,"DEFAULTLISTING")

	set override=$D(^DeepSee.Overrides(cubename,"DEFAULTMEASURE"))
	set:override ..defaultMeasure=^DeepSee.Overrides(cubename,"DEFAULTMEASURE")

	set override=$D(^DeepSee.Overrides(cubename,"DEFAULTMEMBER"))
	set:override ..defaultMember=^DeepSee.Overrides(cubename,"DEFAULTMEMBER")

	set override=$D(^DeepSee.Overrides(cubename,"DESCRIPTION"))
	set:override ..description=^DeepSee.Overrides(cubename,"DESCRIPTION")

	set override=$D(^DeepSee.Overrides(cubename,"DISABLED"))
	set:override ..disabled=^DeepSee.Overrides(cubename,"DISABLED")

	set override=$D(^DeepSee.Overrides(cubename,"DISPLAYNAME"))
	set:override ..displayName=^DeepSee.Overrides(cubename,"DISPLAYNAME")

	set override=$D(^DeepSee.Overrides(cubename,"INHERITSFROM"))
	set:override ..inheritsFrom=^DeepSee.Overrides(cubename,"INHERITSFROM")

	set override=$D(^DeepSee.Overrides(cubename,"INITIALBUILDORDER"))
	set:override ..initialBuildOrder=^DeepSee.Overrides(cubename,"INITIALBUILDORDER")

	set override=$D(^DeepSee.Overrides(cubename,"MAXFACTS"))
	set:override ..maxFacts=^DeepSee.Overrides(cubename,"MAXFACTS")

	set override=$D(^DeepSee.Overrides(cubename,"NULLREPLACEMENT"))
	set:override ..nullReplacement=^DeepSee.Overrides(cubename,"NULLREPLACEMENT")

	set override=$D(^DeepSee.Overrides(cubename,"OWNER"))
	set:override ..owner=^DeepSee.Overrides(cubename,"OWNER")

	set override=$D(^DeepSee.Overrides(cubename,"PRECOMPUTE"))
	set:override ..precompute=^DeepSee.Overrides(cubename,"PRECOMPUTE")

	set override=$D(^DeepSee.Overrides(cubename,"RESOURCE"))
	set:override ..resource=^DeepSee.Overrides(cubename,"RESOURCE")

	set override=$D(^DeepSee.Overrides(cubename,"SOURCECLASS"))
	set:override ..sourceClass=^DeepSee.Overrides(cubename,"SOURCECLASS")

	//go through measures
	for i=1:1:..measures.Count() {
    	set measurename=$$$UPPER(..measures.GetAt(i).name)
	    if $D(^DeepSee.Overrides(cubename,"MEASURES",measurename)) {
		    //if there are overrides for this measure, apply them, in alphabetical order
		    //ignore scale, units (not implemented)
	    	set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"AGGREGATE"))
		    set:override ..measures.GetAt(i).aggregate=
		    ^DeepSee.Overrides(cubename,"MEASURES",measurename,"AGGREGATE")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"DESCRIPTION"))
		    set:override ..measures.GetAt(i).description=
		    ^DeepSee.Overrides(cubename,"MEASURES",measurename,"DESCRIPTION")

	    	set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"DISABLED"))
		    set:override ..measures.GetAt(i).disabled=
		    ^DeepSee.Overrides(cubename,"MEASURES",measurename,"DISABLED")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"DISPLAYNAME"))
		    set:override ..measures.GetAt(i).displayName=
		    ^DeepSee.Overrides(cubename,"MEASURES",measurename,"DISPLAYNAME")

	    	set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"FACTNAME"))
		    set:override ..measures.GetAt(i).factName=
		    ^DeepSee.Overrides(cubename,"MEASURES",measurename,"FACTNAME")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"FACTSELECTIVITY"))
		    set:override ..measures.GetAt(i).factSelectivity=
		    ^DeepSee.Overrides(cubename,"MEASURES",measurename,"FACTSELECTIVITY")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"FORMATSTRING"))
	    	set:override ..measures.GetAt(i).formatString=
	    	^DeepSee.Overrides(cubename,"MEASURES",measurename,"FORMATSTRING")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"HIDDEN"))
		    set:override ..measures.GetAt(i).hidden=
		    ^DeepSee.Overrides(cubename,"MEASURES",measurename,"HIDDEN")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"IKNOWDICTIONARIES"))
	    	set:override ..measures.GetAt(i).iKnowDictionaries=
	    	^DeepSee.Overrides(cubename,"MEASURES",measurename,"IKNOWDICTIONARIES")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"IKNOWDOMAIN"))
		    set:override ..measures.GetAt(i).iKnowDomain=
		    ^DeepSee.Overrides(cubename,"MEASURES",measurename,"IKNOWDOMAIN")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"IKNOWPARAMETERS"))
	    	set:override ..measures.GetAt(i).iKnowParameters=
	    	^DeepSee.Overrides(cubename,"MEASURES",measurename,"IKNOWPARAMETERS")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"IKNOWSOURCE"))
		    set:override ..measures.GetAt(i).iKnowSource=
		    ^DeepSee.Overrides(cubename,"MEASURES",measurename,"IKNOWSOURCE")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"SEARCHABLE"))
	    	set:override ..measures.GetAt(i).searchable=
	    	^DeepSee.Overrides(cubename,"MEASURES",measurename,"SEARCHABLE")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"SOURCEEXPRESSION"))
		    set:override ..measures.GetAt(i).sourceExpression=
		    ^DeepSee.Overrides(cubename,"MEASURES",measurename,"SOURCEEXPRESSION")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"SOURCEPROPERTY"))
	    	set:override ..measures.GetAt(i).sourceProperty=
	    	^DeepSee.Overrides(cubename,"MEASURES",measurename,"SOURCEPROPERTY")

		    set override=$D(^DeepSee.Overrides(cubename,"MEASURES",measurename,"TYPE"))
		    set:override ..measures.GetAt(i).type=
		    ^DeepSee.Overrides(cubename,"MEASURES",measurename,"TYPE")

		}
	}
	

	//go through dimensions
	for dimno=1:1:..dimensions.Count() {
    	set dimname=$$$UPPER(..dimensions.GetAt(dimno).name)
	    if $D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname)) {
		    //if there are overrides for this dimension, apply them, in alphabetical order

		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"ALLCAPTION"))
		    set:override ..dimensions.GetAt(dimno).allCaption=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"ALLCAPTION")

		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"ALLDISPLAYNAME"))
		    set:override ..dimensions.GetAt(dimno).allDisplayName=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"ALLDISPLAYNAME")
	    
		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"DESCRIPTION"))
		    set:override ..dimensions.GetAt(dimno).description=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"DESCRIPTION")
	    
		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"DISABLED"))
		    set:override ..dimensions.GetAt(dimno).disabled=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"DISABLED")
	    
		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"DISPLAYNAME"))
		    set:override ..dimensions.GetAt(dimno).displayName=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"DISPLAYNAME")
	    
		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HASALL"))
		    set:override ..dimensions.GetAt(dimno).hasAll=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HASALL")
	    
		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIDDEN"))
		    set:override ..dimensions.GetAt(dimno).hidden=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIDDEN")
	    
		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"IKNOWMEASURE"))
		    set:override ..dimensions.GetAt(dimno).iKnowMeasure=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"IKNOWMEASURE")
	    
		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"IKNOWTYPE"))
		    set:override ..dimensions.GetAt(dimno).iKnowType=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"IKNOWTYPE")
	    
		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"SHARESFROM"))
		    set:override ..dimensions.GetAt(dimno).sharesFrom=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"SHARESFROM")
	    
		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"SHOWHIERARCHIES"))
		    set:override ..dimensions.GetAt(dimno).showHierarchies=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"SHOWHIERARCHIES")
	    
		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"SOURCEEXPRESSION"))
		    set:override ..dimensions.GetAt(dimno).sourceExpression=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"SOURCEEXPRESSION")
	    
		    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"SOURCEPROPERTY"))
		    set:override ..dimensions.GetAt(dimno).sourceProperty=
		    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"SOURCEPROPERTY")
		    
		    //go through hierarchies of this dimension
			for hierno=1:1:..dimensions.GetAt(dimno).hierarchies.Count() {
		    	set hiername=$$$UPPER(..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).name)
			    if $D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername)) {
				    //if there are overrides for this hierarchy, apply them, in alphabetical order

				    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"DESCRIPTION"))
				    set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).description=
				    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"DESCRIPTION")

				    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"DISABLED"))
				    set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).disabled=
				    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"DISABLED")

				    set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"DISPLAYNAME"))
				    set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).displayName=
				    ^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"DISPLAYNAME")
				    
				    
				    //go through levels of this hierarchy
				    for levno=1:1:..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.Count() {
				        set levname=$$$UPPER(..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).name)
				        if $D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname)) {
					    	//if there are overrides for this level, apply them

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"DEPENDSON"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).dependsOn=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"DEPENDSON")

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"DESCRIPTION"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).description=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"DESCRIPTION")
					    	
					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"DISABLED"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).disabled=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"DISABLED")
					        
					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"DISPLAYNAME"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).displayName=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"DISPLAYNAME")

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"FACTNAME"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).factName=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"FACTNAME")

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"FACTSELECTIVITY"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).factSelectivity=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"FACTSELECTIVITY")

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"LIST"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).list=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"LIST")

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"LISTDELIMITER"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).listDelimiter=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"LISTDELIMITER")

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"NULLREPLACEMENT"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).nullReplacement=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"NULLREPLACEMENT")

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"RANGEEXPRESSIONS"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).rangeExpression=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"RANGEEXPRESSIONS")

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"SORT"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).sort=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"SORT")

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"SOURCEEXPRESSION"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).sourceExpression=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"SOURCEEXPRESSION")

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"SOURCEPROPERTY"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).sourceProperty=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"SOURCEPROPERTY")

					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"USEASFILTER"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).useAsFilter=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"USEASFILTER")
					    						    }
					    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"USEASDISPLAYVALUE"))
					    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).useDisplayValue=
					    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"USEASDISPLAYVALUE")
					    	
					    	for propno=1:1:..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.Count() {
						        set propname=$$$UPPER(..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).name)
						        if $D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname)) {
							    	//if there are overrides for this property, apply them
							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"DISPLAYNAME"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).displayName=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"DISPLAYNAME")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"DESCRIPTION"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).description=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"DESCRIPTION")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"DISABLED"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).disabled=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"DISABLED")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"FACTNAME"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).factName=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"FACTNAME")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"FACTSELECTIVITY"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).factSelectivity=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"FACTSELECTIVITY")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"FORMATSTRING"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).formatString=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"FORMATSTRING")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"HIDDEN"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).hidden=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"HIDDEN")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"ISDESCRIPTION"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).isDescription=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"ISDESCRIPTION")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"ISNAME"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).isName=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"ISNAME")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"ISREFERENCE"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).isReference=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"ISREFERENCE")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"LINKCLASS"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).linkClass=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"LINKCLASS")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"LINKPROPERTY"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).linkProperty=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"LINKPROPERTY")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"SORT"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).sort=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"SORT")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"SOURCEEXPRESSION"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).sourceExpression=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"SOURCEEXPRESSION")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"SOURCEPROPERTY"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).sourceProperty=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"SOURCEPROPERTY")

							    	set override=$D(^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"USEDISPLAYVALUE"))
							    	set:override ..dimensions.GetAt(dimno).hierarchies.GetAt(hierno).levels.GetAt(levno).properties.GetAt(propno).useDisplayValue=
							    	^DeepSee.Overrides(cubename,"DIMENSIONS",dimname,"HIERARCHIES",hiername,"LEVELS",levname,"PROPERTIES",propname,"USEDISPLAYVALUE")
						        }
					    	
					    	}
					    	//get members here if Documatic ever displays members!!!
				    }

		    	}
		    }

	    }
	}
	//go through relationships
	for relno=1:1:..relationships.Count() {
		set relname=$$$UPPER(..relationships.GetAt(relno).name)
		if $D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname)) {
		    //if there are overrides for this relationship, apply them, in alphabetical order
			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"CARDINALITY"))
			set:override ..relationships.GetAt(relno).cardinality=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"CARDINALITY")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"DESCRIPTION"))
			set:override ..relationships.GetAt(relno).description=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"DESCRIPTION")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"DISABLED"))
			set:override ..relationships.GetAt(relno).disabled=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"DISABLED")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"DISPLAYNAME"))
			set:override ..relationships.GetAt(relno).displayName=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"DISPLAYNAME")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"DEPENDSON"))
			set:override ..relationships.GetAt(relno).dependsOn=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"DEPENDSON")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"FACTNAME"))
			set:override ..relationships.GetAt(relno).factName=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"FACTNAME")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"FACTSELECTIVITY"))
			set:override ..relationships.GetAt(relno).factSelectivity=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"FACTSELECTIVITY")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"INVERSE"))
			set:override ..relationships.GetAt(relno).inverse=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"INVERSE")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"LINKCLASS"))
			set:override ..relationships.GetAt(relno).linkClass=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"LINKCLASS")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"LINKPROPERTY"))
			set:override ..relationships.GetAt(relno).linkProperty=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"LINKPROPERTY")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"NULLREPLACEMENT"))
			set:override ..relationships.GetAt(relno).nullReplacement=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"NULLREPLACEMENT")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"RELATEDCUBE"))
			set:override ..relationships.GetAt(relno).relatedCube=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"RELATEDCUBE")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"SOURCEEXPRESSION"))
			set:override ..relationships.GetAt(relno).sourceExpression=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"SOURCEEXPRESSION")

			set override=$D(^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"SOURCEPROPERTY"))
			set:override ..relationships.GetAt(relno).sourceProperty=
			^DeepSee.Overrides(cubename,"RELATIONSHIPS",relname,"SOURCEPROPERTY")

			}

	}

	//go through listings
	for listno=1:1:..listings.Count() {
    	set listingname=$$$UPPER(..listings.GetAt(listno).name)
	    if $D(^DeepSee.Overrides(cubename,"LISTINGS",listingname)) {
		    //if there are overrides for this listing, apply them, in alphabetical order

		    set override=$D(^DeepSee.Overrides(cubename,"LISTINGS",listingname,"DISPLAYNAME"))
		    set:override ..listings.GetAt(listno).displayName=
		    ^DeepSee.Overrides(cubename,"LISTINGS",listingname,"DISPLAYNAME")

		    set override=$D(^DeepSee.Overrides(cubename,"LISTINGS",listingname,"FIELDLIST"))
		    set:override ..listings.GetAt(listno).fieldList=
		    ^DeepSee.Overrides(cubename,"LISTINGS",listingname,"FIELDLIST")

		    set override=$D(^DeepSee.Overrides(cubename,"LISTINGS",listingname,"FORMATLIST"))
		    set:override ..listings.GetAt(listno).formatList=
		    ^DeepSee.Overrides(cubename,"LISTINGS",listingname,"FORMATLIST")

		    set override=$D(^DeepSee.Overrides(cubename,"LISTINGS",listingname,"LISTINGTYPE"))
		    set:override ..listings.GetAt(listno).listingType=
		    ^DeepSee.Overrides(cubename,"LISTINGS",listingname,"LISTINGTYPE")

		    set override=$D(^DeepSee.Overrides(cubename,"LISTINGS",listingname,"ORDERBY"))
		    set:override ..listings.GetAt(listno).orderBy=
		    ^DeepSee.Overrides(cubename,"LISTINGS",listingname,"ORDERBY")

	    }
	 }

	//go through listing fields
	for fieldno=1:1:..listingFields.Count(){
		set fieldname=$$$UPPER(..listingFields.GetAt(fieldno).name)
		if $D(^DeepSee.Overrides(cubename,"LISTINGFIELDS",fieldname)) {
		    //if there are overrides for this listing field, apply them, in alphabetical order
			set override=$D(^DeepSee.Overrides(cubename,"LISTINGFIELDS",fieldname,"DESCRIPTION"))
			set:override ..listingFields.GetAt(fieldno).description=
			^DeepSee.Overrides(cubename,"LISTINGFIELDS",fieldname,"DESCRIPTION")

			set override=$D(^DeepSee.Overrides(cubename,"LISTINGFIELDS",fieldname,"DISABLED"))
			set:override ..listingFields.GetAt(fieldno).disabled=
			^DeepSee.Overrides(cubename,"LISTINGFIELDS",fieldname,"DISABLED")

			set override=$D(^DeepSee.Overrides(cubename,"LISTINGFIELDS",fieldname,"DISPLAYNAME"))
			set:override ..listingFields.GetAt(fieldno).displayName=
			^DeepSee.Overrides(cubename,"LISTINGFIELDS",fieldname,"DISPLAYNAME")

			set override=$D(^DeepSee.Overrides(cubename,"LISTINGFIELDS",fieldname,"FIELDEXPRESSION"))
			set:override ..listingFields.GetAt(fieldno).fieldExpression=
			^DeepSee.Overrides(cubename,"LISTINGFIELDS",fieldname,"FIELDEXPRESSION")

		}
	}
	
	//go through calculated members
	for calcmemno=1:1:..calculatedMembers.Count() {
		set calcmemname=$$$UPPER(..calculatedMembers.GetAt(calcmemno).name)
		if $D(^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname)) {
		    //if there are overrides for this namedset, apply them, in alphabetical order

			set override=$D(^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"DESCRIPTION"))
			set:override ..calculatedMembers.GetAt(calcmemno).description=
			^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"DESCRIPTION")

			set override=$D(^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"DIMENSION"))
			set:override ..calculatedMembers.GetAt(calcmemno).dimension=
			^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"DIMENSION")

			set override=$D(^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"DISABLED"))
			set:override ..calculatedMembers.GetAt(calcmemno).disabled=
			^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"DISABLED")

			set override=$D(^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"DISPLAYNAME"))
			set:override ..calculatedMembers.GetAt(calcmemno).displayName=
			^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"DISPLAYNAME")

			set override=$D(^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"FORMATSTRING"))
			set:override ..calculatedMembers.GetAt(calcmemno).formatString=
			^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"FORMATSTRING")

			set override=$D(^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"HIDDEN"))
			set:override ..calculatedMembers.GetAt(calcmemno).hidden=
			^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"HIDDEN")

			set override=$D(^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"VALUEEXPRESSION"))
			set:override ..calculatedMembers.GetAt(calcmemno).valueExpression=
			^DeepSee.Overrides(cubename,"CALCULATEDMEMBERS",calcmemname,"VALUEEXPRESSION")

		}

	//go through named sets
	for setno=1:1:..namedSets.Count() {
		set setname=$$$UPPER(..namedSets.GetAt(setno).name)
		if $D(^DeepSee.Overrides(cubename,"NAMEDSETS",setname)) {
		    //if there are overrides for this namedset, apply them, in alphabetical order
			set override=$D(^DeepSee.Overrides(cubename,"NAMEDSETS",setname,"DESCRIPTION"))
			set:override ..namedSets.GetAt(setno).description=
			^DeepSee.Overrides(cubename,"NAMEDSETS",setname,"DESCRIPTION")

			set override=$D(^DeepSee.Overrides(cubename,"NAMEDSETS",setname,"DISABLED"))
			set:override ..namedSets.GetAt(setno).disabled=
			^DeepSee.Overrides(cubename,"NAMEDSETS",setname,"DISABLED")

			set override=$D(^DeepSee.Overrides(cubename,"NAMEDSETS",setname,"DISPLAYNAME"))
			set:override ..namedSets.GetAt(setno).displayName=
			^DeepSee.Overrides(cubename,"NAMEDSETS",setname,"DISPLAYNAME")

			set override=$D(^DeepSee.Overrides(cubename,"NAMEDSETS",setname,"SETEXPRESSION"))
			set:override ..namedSets.GetAt(setno).setExpression=
			^DeepSee.Overrides(cubename,"NAMEDSETS",setname,"SETEXPRESSION")
			}
		}

	}
}

}
