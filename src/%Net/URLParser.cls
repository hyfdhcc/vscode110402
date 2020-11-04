/// Parses a url into component parts
Class %Net.URLParser Extends %Library.RegisteredObject [ Not ProcedureBlock, System = 3 ]
{

/// Parses an url into its constituent components.
/// <P>
/// The output parameter 'Components' will contain an array subscripted by the name of the component
/// part with the parsed value as the data. E.G. for a URL such as 
/// <P>
/// http://www.intersystems.com
/// <P>
/// the 
/// Components array will contain the scheme in this form:- Components("scheme")="http"
/// <BR>
/// URLs are described briefly below, please see RFC1738 for a full description
/// <P>
/// A URL contains the name of the scheme being used (&lt;scheme&gt;) followed by a colon and then a string 
/// (the &lt;scheme-specific-part&gt;) whose interpretation depends on the scheme.
/// <P>
/// Scheme names consist of a sequence of characters. The lower case letters "a"--"z", digits, and the 
/// characters plus ("+"), period ("."), and hyphen ("-") are allowed. For resiliency, programs interpreting 
/// URLs should treat upper case letters as equivalent to lower case in scheme names
/// (e.g., allow "HTTP" as well as "http").
/// <P>
/// While the syntax for the rest of the URL may vary depending on the particular scheme selected, URL schemes 
/// that involve the direct use of an IP-based protocol to a specified host on the Internet use a common syntax 
/// for the scheme-specific data:
/// <BR>
/// //&lt;user&gt;:&lt;password&gt;@&lt;host&gt;:&lt;port&gt;/&lt;url-path&gt;
/// <P>
/// Some or all of the parts "&lt;user&gt;:&lt;password&gt;@",
/// ":&lt;password&gt;",
/// ":&lt;port&gt;", and "/&lt;url-path&gt;" may be excluded.
/// <P>
/// The scheme specific data start with a double slash "//" to indicate that it complies with the common Internet 
/// scheme syntax. The different components obey the following rules: 
/// <UL>
/// <LI>user
/// <BR>
/// An optional user name. Some schemes (e.g., ftp) allow the specification of a user name.</LI>
/// <P>
/// <LI>password
/// <BR>
/// An optional password. If present, it follows the user name separated from it by a colon. 
/// The user name (and password), if present, are followed by a commercial at-sign "@". Within the user and password 
/// field, any ":", "@", or "/" must be encoded.
/// <P>
/// Note that an empty user name or password is different than no user name or password; there is no way to specify 
/// a password without specifying a user name. E.g., &lt;URL:ftp://@host.com/&gt; has an empty user name and no password,
/// &lt;URL:ftp://host.com/&gt; has no user name, while &lt;URL:ftp://foo:@host.com/&gt; has a user name of "foo" and an empty
/// password.</LI>
/// <P>
/// <LI>host
/// <BR>
/// The fully qualified domain name of a network host, or its IP address as a set of four decimal digit groups 
/// separated by ".". Fully qualified domain names take the form as described in Section 3.5 of RFC 1034 [13] and 
/// Section 2.1 of RFC 1123 [5]: a sequence of domain labels separated by ".", each domain label starting and ending with an alphanumerical character and possibly also containing "-" characters. The rightmost domain label will never start with a digit, though, which 
/// syntactically distinguishes all domain names from the IP addresses.</LI>
/// <P>
/// <LI>port
/// <BR>
/// The port number to connect to. Most schemes designate protocols that have a default port number. Another port number
/// may optionally be supplied, in decimal, separated from the host by a colon. If the port is omitted, the colon is as 
/// well.</LI>
/// <P>
/// <LI>path<BR>
/// The rest of the locator consists of data specific to the scheme, and is known as the "path". It supplies the 
/// details of how the specified resource can be accessed. Note that the "/" between the host (or port) and the path 
/// is NOT part of the path. 
/// The path syntax depends on the scheme being used, as does the manner in which it is interpreted.</LI>
/// </UL>
ClassMethod Parse(Url As %Library.String, ByRef Components As %Library.String) [ Final ]
{
#;
#; Parse Url returning Components according to RFC 1808
#;
#; Pick out fragment
 If Url["#" {
 Set Components("fragment")=$Piece(Url,"#",2,$Length(Url,"#")),Url=$Piece(Url,"#")
 } else {
 Set Components("fragment")=""
 }
#;
#; Pick out scheme
 New c,i,p
 For i=1:1:$Length(Url) Set c=$Extract(Url,i) If (c'?1AN)!("+-."[c) Quit
 Set p=$Find($Extract(Url,1,i),":",2) 
 If p>2 {
 Set Components("scheme")=$Extract(Url,1,p-2)
 Set Url=$Extract(Url,p,$Length(Url))
 } else {
 Set Components("scheme")=""
 }
#;
#; Pick out the netloc
 If $Extract(Url,1,2)="//" {
 New tNetloc Set tNetloc=$Piece($Piece(Url,"//",2),"/")
 If tNetloc["?" Set tNetloc=$Piece(tNetloc,"?")
 Set Components("netloc")=tNetloc
 If tNetloc'="" {
 Set Url=$Piece(Url,tNetloc,2,$Length(Url,tNetloc))
 } else {
	Set Url=$Piece(Url,"///",2,$Length(Url,"///"))
 }
 New tLen Set tLen=$Length(tNetloc,":")
 If tLen=1 {
	 	Do ..ParseHost(tNetloc,.Components)
 } elseif tLen=2 {
	 	If $Piece(tNetloc,":",2)?1N.N {
		 	Set Components("port")=$Piece(tNetloc,":",2)
		 	Do ..ParseHost($Piece(tNetloc,":"),.Components)
	 	} else {
		 	Set Components("username")=$Piece(tNetloc,":")
		 	Do ..ParseHost($Piece(tNetloc,":",2),.Components)
	 	}
 } elseif tLen=3 {
	 	Set Components("username")=$Piece(tNetloc,":"),Components("port")=$Piece(tNetloc,":",3)
	 	Do ..ParseHost($Piece(tNetloc,":",2),.Components) 
 }
 } else {
 Set Components("netloc")=""
 }
#;
#; Pick out the query
 If Url["?" {
 Set Components("query")=$Piece(Url,"?",2,$Length(Url,"?"))
 Set Url=$Extract(Url,1,$Find(Url,"?")-2)
 } else {
 Set Components("query")=""
 }
#;
#; Pick out the params
 If Url[";" {
 Set Components("params")=$Piece(Url,";",2,$Length(Url,";"))
 Set Url=$Extract(Url,1,$Find(Url,";")-2)
 } else {
 Set Components("params")=""
 }
#;
#; Pick out the path
 Set Components("path")=Url
#;
#; All done
 Quit
}

ClassMethod ParseHost(pHost As %String, ByRef Components As %Library.String) [ Private ]
{
 If pHost["@" {
 Set Components("password")=$Piece(pHost,"@"),Components("host")=$Piece(pHost,"@",2)
 } else {
 Set Components("host")=$piece(pHost,"?")
 }
}

}
