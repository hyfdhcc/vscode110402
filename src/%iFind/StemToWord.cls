/// <p>This class has been deprecated in favour of <class>%iFind.WordTransformation</class> as of 2016.1.</p>
Class %iFind.StemToWord [ ClassType = view, CompileAfter = %iFind.WordTransformation, DdlAllowed, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = StemToWord, ViewQuery = { SELECT TransformedWord As StemId, OriginalWord As WordId, Transformation FROM %iFind.WordTransformation WHERE Transformation->Type = '%iFind.Stemmer'} ]
{

}
