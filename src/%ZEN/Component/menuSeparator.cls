/// Simple separator that can be placed within a <class>menu</class>
/// to provide separation between menu items.
Class %ZEN.Component.menuSeparator Extends component [ System = 3 ]
{

/// defines style sheet used by this component
XData Style
{
<style type="text/css">
/* @doc="Style for menu separator (hr)." */
.menuSeparator {
}
</style>
}

Method %DrawHTML()
{
	Set tVertical = 1

	// figure out what kind of separator to draw
	If ($IsObject(..parent) && ..parent.%IsA("%ZEN.Component.menu")) {
		Set tVertical = (..parent.layout = "vertical")
	}

	If (tVertical) {
		&html<<hr class="menuSeparator"/>>
	}
	Else {
		&html<|>
	}
}

}
