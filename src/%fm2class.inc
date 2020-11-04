ROUTINE %fm2class [Type=INC]
	// VA -> SQL FILE MANAGER INTERFACE (Version 2.23)
	#;---------------------------------------------------------------------
	#; Description:   New Fileman to SQL Interface
	#; Author:        David Van De Griek
	#; Date:          July 2008
	#; Maintenance History: [ XXXnnn (MM/DD/YY) - Description ] 
	#;
	#;  DPV4053 (06/27/2012) - Remove BigTrigger logic (for 2011.1+ only) (2.11)
	#;  DPV4038 (05/30/2012) - Properly new 'wp' in BeforeInsert trigger (2.10)
	#;  DPV3996 (03/08/2012) - Map indexes where the filen does not match the index (from the parent) (2.09).  
	#;  DPV3958 (12/05/2011) - Corect field MAXLEN issue (2.07)
	#;  DPV3957 (12/05/2011) - Implement $$$variablePointerValueField setting
	#;                         Implement $$$expandPointers=3 setting
	#;  DPV3780 (02/04/2011) - Correct <COMMAND> error when datype is "" in table() (2.03)
	#;                         Correct getSettings call to only get system setting if local setting is not defined
	#;                         Correct setting of FDA() for field data in BigTrigger logic for INSERT of main files
	#;  DPV3765 (01/19/2011) - Correction for DPV3628, INSERT child table unlock, define U for all computed fields (2.02)
	#;  DPV3728 (10/19/2010) - Use TRUNCATE(x) collation for fields indexed as $E({Field},1,x) (2.00)
	#;  DPV3727 (10/19/2010) - Correct mapping of computed fields (1.22)
	#;  DPV3628 (05/05/2010) - Correct filing (insert) into Sub-File, allow FileMan to define IEN (1.21)
	#;  DPV3617 (04/16/2010) - Correct <UNDEFINED> error creating cross ref index during no recursion mapping (1.20)
	#;  DPV3612 (04/14/2010) - Correct NEW logic in filing triggers (1.19)
	#;  DPV3600 (03/18/2010) - Retain class enhancements (1.18)
	#;  DPV3579 (02/16/2010) - Define ability to have Required properties for required fields or required identifiers (1.17)
	#;                         Don't create fkeys for SOC tables added by v1.16
	#;                         Allow SC fields to be defined as String and not EnumString
	#;  DPV     (02/01/2010) - Allow SetOfCodes to be set up in a separate table and linked via a fkey (1.16)
	#;  DPV3567 (01/28/2010) - Define proper sequence number for class members (1.15)
	#;  DPV3487 (09/02/2009) - Only qualify map subscript field names if they are from another table (1.14)
	#;  DPV3432 (06/12/2009) - Correct index map subscripts (%fm2class version 1.12)
	#;  DPV3398 (04/23/2009) - Correct problem building classes with too many properties (1.11)
	#;  DPV3352 (01/28/2009) - Fix mapping of corrupt multiple pointer, fix FILEMANFILENAME parameter (1.10)
	#;  DPV3343 (01/15/2009) - Make %fm2class smaller (1.09)
	#;  DPV3339 (01/13/2009) - Qualify table name in ExpandedPointers computed field query (1.08)
	#;  DPV3317 (11/25/2008) - Use conditional index maps when $E({field},1,N) subscript expression is used (1.07)
	#;  DPV3305 (10/30/2008) - Enhancements to date/datetimedatatype mappings (1.06)
	#;                         Don't delete old classes if package changed
	#;  DPV3287 (10/08/2008) - Translate <FILENUMBER> "." to "_", not "d" (1.05)
	#;  DPV3235              - Implement new utility %fm2class
	#;---------------------------------------------------------------------

#define FM2SQLVersion "'2.24'"

	#;  $$$package              = Name of the package to create the classes in
	#;  $$$compile              = 1/0 1 means compile the classes, 0 means don't compile.
	#;  $$$wpIsList             = 1/0 1 means convert word-processing fields as list collections
	#;                                0 means convert word-processing fields as child tables
	#;  $$$readonly             = 1/0 1 means generate readonly classes, 0 means generate read/write classes
	#;  $$$tableNameFormat      = Format of the table name based on the file name and number
	#;  $$$childTableNameFormat = Format of the child table name based on the file name and number
	#;  $$$fieldNameFormat      = Format of the SQL Field name based on the file's field name (Exact,Upper,Lower,Pascal,Camel)
	#;  $$$extendedMapping      = A string to be inserted into the global name in the map definitions for extended
	#;                            mapping purposes.  For example, you might specify ["SD"] and your global will be 
	#;                            mapped as ^["SD"]LR(...) instead of ^LR(...).  This can be any valid string that can be
	#;                            used for extended global mapping, include the [...] or |...| brackets.
	#;  $$$expandPointers       = 1/0 flag.  1 means for each pointer field mapped we will also create a computed property
	#;                            that expands the pointer field and is equal to the NAME (.01) field in the referenced file
	#;                            0 means this field will not be created.
	#;  $$$expandSetOfCodes     = 1/0 flag.  1 means for field of type SET OF CODES the mapping utility will create a separate 
	#;                            class/table that contains fields CODE and MEANING for the codes this field can be set to.
	#;                            There is also a foreign key constraint defined in the table that references to SetOfCodes table for the field.
	#;			      The SetOfCodes field is not defined as a reference, it is still defined as a EnumString.
	#;                            0 means this SetOfCodes table will not be created.
	#;  $$$setOfCodesEnum	    = 1/0 flag.  1 means Set Of Codes type fields map to %Library.EnumString (default)
	#;			      0 means they map to %Library.String
	#;  $$$requiredType	    = 1/0 flag.  1 means FileMan fields marked as required are defined as required properties (default)
	#;			      0 means only FileMan fields defined as Required Identifiers are defined as required properties.
	#;  $$$compileQSpec         = Class compiler flags
	#;  $$$fmQueueCount           = Queue Count, value passed by reference, the number of classes queued for creation.
	#;  $$$owner                = Username to use as the owner of the classes created.  The default is $Username
	#;  $$$retainClass	       = 1/0 1 means that if the Caché class already exists we will not recreate the entire class, just the properties, storage, indexes, foreign keys, etc.
	#;                            0 means we delete and recreate the class, SQL privileges and any add-ons to the class will be lost
	#;  $$$ienFieldName	       = Name of the IEN field.  IEN is defualt.
	#;  $$$superClasses         = String with a comma list of super class(es) each mapped class should extend
	#;  $$$recursion            = 0/1/2 flag.  0 means no recursion will occur.  Only this file is converted, no Sub-Files or Pointers converted
	#;                                         1 means partial recursion.  Only one level of Sub-File and Pointers will be converted.
	#;                                         2 (default) means full recursion.  All Sub-Files and Pointers converted
	#;                            Calling the all entrypoint implys $$$recursion=2
	#;  $$$dateType             = Cache' Datatype to use for FileMan DATE fields
	#;  $$$datetimeType         = Cache' Datatype to use for FileMan DATETIME fields
	#;  $$$strictData	    = If $$$dateType is %Library.FilemanDate, defines if the STRICTDATA type parameter is 0 (default) or 1.
	#;                            If $$$dateType is %Library.FilemanTimeStamp, defines if the STRICTDATA type parameter is 0 (default) or 1.
	#;  $$$display              = 0/1/2 flag.  0 = No screen display, 1 = minimal screen display, 2 = full screen display
	#;  $$$logFile              = Name of a file to log optput of the %fm2class utility
	#;  $$$nameLength	    = Maximum length of property, trigger, and foreign key names in the generated class definition.
	#;                            The default is currently 180 characters.  The 180 character length was introduced with FM2Class 2.13.
	#;                            Prior to 2.13 the name length was 31.  If you prefer the name length to remain 31, set nameLength to 31.
	#;                            You may want the name length to remain 31 if you have application code that references the property names and do not want to have to update this code.

#define compile			%fm("compile")
#define childTableNameFormat	%fm("childTableNameFormat")
#define compileQSpec		%fm("compileQSpec")
#define dateType		%fm("dateType")
#define datetimeType		%fm("datetimeType")
#define deleteQSpec		%fm("deleteQSpec")
#define display			%fm("display")
#define expandPointers		%fm("expandPointers")
#define extendedMapping		%fm("extendedMapping")
#define fieldNameFormat		%fm("fieldNameFormat")
#define ienFieldName		%fm("ienFieldName")
#define logFile			%fm("logFile")
#define nameLength		%fm("nameLength")
#define owner			%fm("owner")
#define package			%fm("package")
#define readonly		%fm("readonly")
#define recursion		%fm("recursion")
#define requiredType		%fm("requiredType")
#define retainClass		%fm("retainClass")
#define setOfCodesEnum		%fm("setOfCodesEnum")
#define strictData		%fm("strictData")
#define superClasses		%fm("superClasses")
#define tableNameFormat		%fm("tableNameFormat")
#define variablePointerValueField %fm("variablePointerValueField")
#define wpIsList		%fm("wpIsList")
#define expandSetOfCodes	%fm("expandSetOfCodes")


#define output2(%str,%lf,%indent) do output^%fm2class(%str,%lf,%indent,$$$display=2)
#define output1(%str,%lf,%indent) do output^%fm2class(%str,%lf,%indent,$$$display)

#define normalize(%name) $tr(%name," !""#$%&'()*+-./:;<=>@[\]^_`{|}~,","")
#;	For Cache 5.0.x #define maxShortClassnameLength	25
#define maxShortClassnameLength	60

	#;  output3 is to log file only
#define output3(%str,%lf,%indent) do output^%fm2class(%str,%lf,%indent,0)
	#;  output2 is to log file and screen if $$$display=2
#define output2(%str,%lf,%indent) do output^%fm2class(%str,%lf,%indent,$$$display=2)
	#;  output1 is to log file and screen if $$$display
#define output1(%str,%lf,%indent) do output^%fm2class(%str,%lf,%indent,$$$display)

#define BigTrigger 16000

#define UPPER(%a) $zcvt(%a,"U")
#define ALPHAUP(%a) $zcvt($zstrip(%a,"*P",,",?"),"U")
 
