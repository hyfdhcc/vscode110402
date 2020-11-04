ROUTINE %PVA [Type=INC]
#;
#; Definitions for Packed Vectors (PV) and Packed Vector Arrays (PVA)
#;
#; Define the types of PV as found in the header of the PV
#;
#; PV is an array
#define	PVTYPEARRAY	     157         
#; PV is an object (with its own keymap)
#define PVTYPEOBJECT         158         
#;
#; Define the types of values found inside a PV as returned by $gettypeof()
#;
#; String is null
#define PVVALUENULL          0
#; String is true
#define PVVALUETRUE          1
#; String is false
#define PVVALUEFALSE         2
#; 32-bit positive integer
#define PVVALUEINTEGERPOS    3
#; 32-bit negative integer
#define PVVALUEINTEGERNEG    4
#; Unused code
#define PVVALUEUNUSED1       5
#; This is meta-data for an array
#define PVVALUEARRAY         6
#; This is meta-data for an object
#define PVVALUEOBJECT        7
#; Normal text string
#define PVVALUETEXT          8
#; Numeric number
#define PVVALUENUMBER       9
#; Text overflow 
#define	PVVALUEOVERFLOW	     10
#; Cache floating point, 64 bit mantissa, 8 bits for sign and exponent
#define PVVALUECACHENUMERIC  11
#; An embedded Cache object, maybe another %Object or %Array
#define PVVALUEOREF          12
#; The value is unassigned
#define	PVVALUEUNASSIGNED    13
#; Long 64 bit, positive
#define PVVALUELONGPOS       14
#; Long 64 bit, negative
#define PVVALUELONGNEG       15
#; A byte[] array.
#define PVVALUEBYTE           16
#; Date/Time object
#define PVVALUEDATETIME       17
#; Double precision floating point in binary
#define PVVALUEDOUBLE         18
#; Single precision floating point in binary
#define PVVALUESINGLE         19
#; UTF-8 Bytes, in serialised format only
#define PVVALUEUTF8           20
#; Nested array or object, in serialised format only
#define PVVALUENESTED         21
#; End of data during $getNext()
#define	PVVALUEEOF	     31
#;
#;
#; These are the error codes that can be returned with $fromJSON()
#;
#; Parsing okay
#define JSONERROROKAY					1
#; Source wasn't a string
#define JSONERRORNOSTRING				2
#; General parsing error on JSON string
#define JSONERRORPARSEFAIL				3
#; Internal error
#define JSONERRORINTERNALERROR			4
#; Memory allocation failure
#define JSONERRORNOMEMORY				5
#; Invalid hex in \uXXXX string
#define JSONERRORINVALIDHEX				6
#; Hex in \uXXXX string too big for 8-bit systems
#define JSONERROROVERFLOWHEX			7
#; Invalid escape sequence \X
#define JSONERRORINVALIDESCAPE			8
#; Number is too large
#define JSONERRORMAXNUMBERC				9
#; Read error from input stream
#define JSONERRORREADERROR				10
#; Exceeded the maximum depth
#define JSONERRORMAXDEPTH				11
#; EOF seen prematurely
#define JSONERRORUNEXPECTEDEOF			12
#; A duplicate key was seen in an object
#define JSONERRORDUPLICATEKEY			13
#; An error was thrown by Cache
#define JSONERRORCACHEKERNEL			14
#; The metadata is missing or illegal
#define JSONERRORMETADATA				15
#; The internal structure is corrupt
#define JSONERRORCORRUPTSTRUCTURE		16
#; Invalid arguments passed to the $zu(210)
#define JSONERRORINVALIDZUARGS			17
#; Output variable exceeded maximum size
#define JSONERRORMAXSIZE				18