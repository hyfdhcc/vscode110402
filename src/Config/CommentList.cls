Include %syConfig

/// This class is a datatype class defining what a valid comment can be in the CPf file.
Class Config.CommentList Extends %Library.String [ System = 4 ]
{

/// Validate a comment list in the form $lb(property,Comment,Comment1,Comment2,...,CommentX).<br>
ClassMethod IsValid(%Val As %CacheString) As %Status [ Internal ]
{
 s $zt="Error"
 s Status=$$$OK
 s Name=$li(%Val)
 s Comment=$li(%Val,2)
 i Comment'="" {
 	q:Comment>$$$CPFMaxCommentLength $$$ERROR($$$CPFCommentTooLong,$$$CPFMaxCommentLength)
	f i=1:1:$l($$$CommentDelim,",") {
		s Delim=$p($$$CommentDelim,",",i)
		i Delim=$e($zstrip(Comment,"<W"),1,$l(Delim)) {
			s Found=1
			q
		}
 	}
 	i '$d(Found) s Status=$$$ADDSC(Status,$$$ERROR($$$CPFCommentMustStart,$replace($$$CommentDelim,",","  ")))
 }
 s Status=$$$OK
 s CommentDelim=$$$CommentDelim_","_$$$CommentContinuationChar_","_$$$CommentNextSectionChar
 f i=3:1:$ll(%Val) {
	s Comment=$li(%Val,i)
	s:$l(Comment)>$$$CPFMaxCommentLength Status=$$$ADDSC(Status,$$$ERROR($$$CPFCommentTooLong,$$$CPFMaxCommentLength))
	f j=1:1:$l(CommentDelim,",") {
		s Delim=$p(CommentDelim,",",j)
		i Delim=$e($zstrip(Comment,"<W"),1,$l(Delim)) {
			s Found=1
			q
		}
 	}
 	i '$d(Found) s Status=$$$ADDSC(Status,$$$ERROR($$$CPFCommentMustStart,$replace($$$CommentDelim,",","  ")))
 }
 q Status
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

}
