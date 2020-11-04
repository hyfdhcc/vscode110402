/// Class to represent MIME charsets within Cache and map these charsets
/// to Cache locales.
Class %Net.Charset [ System = 3 ]
{

/// Test if the translate table name for the input charset name is loaded.
ClassMethod TranslateTableExists(charset As %String) As %Boolean
{
	set $ZTRAP="NoTT"
	set table=$$MapCharset^%SYS.NLS(charset)
	if table="" quit 0
	set x=$zcvt("","O",table)
	quit 1
NoTT Set $ZTRAP=""
	quit 0
}

/// Return the Cache translate table name for the input charset name.
ClassMethod GetTranslateTable(ByRef charset As %String) As %String
{
	if charset="" set charset=..GetDefaultCharset()
	Quit $$MapCharset^%SYS.NLS(charset)
}

/// Return default charset for the current Cache locale.
ClassMethod GetDefaultCharset() As %String
{
	if ..IsLocaleUnicode() {
		#; On unicode default CharSet is UTF-8 always
		quit "UTF-8"
	} else {
		#; For 8-bit system ask for locale default charset.
		quit $$MapExtCharset^%SYS.NLS($$GetCharset^%SYS.NLS())
	}
}

ClassMethod IsLocaleUnicode() As %Integer [ CodeMode = expression ]
{
$zbitget($zversion(0),1)
}

}
