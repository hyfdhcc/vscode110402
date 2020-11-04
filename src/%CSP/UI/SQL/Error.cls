/// This class is used internally by Cach&eacute;. You should not make direct use of it within your applications. There is no guarantee made about either the behavior or future operation of this class.
/// <p>Super class for common Error related methods.
Class %CSP.UI.SQL.Error [ Abstract, System = 4 ]
{

/// Draws error box for object error message. 
ClassMethod DrawErrorBox(tObj)
{
	&html<<div class="ErrorBox">#(..EscapeHTML($System.Status.GetErrorText(tObj)))#</div>>
}

}
