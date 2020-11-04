Class %BI.WebBlog [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod DispCat(val)
{
	do DispCat^%bi.SWrCE.BlogPost(val)
}

ClassMethod FilterBlog(val)
{
	if (val = 0)
	{
		do genBlogPost^%bi.SWr.WebDList
	}
}

ClassMethod Init(blogID)
{
	k %session.Data("byType")
	k %session.Data(blogID,"filterIndex")
}

ClassMethod DispSubCat(cat)
{
	do DispSubCat^%bi.SWrCE.BlogPost(cat)
}

ClassMethod GetBlogTitle(id)
{
	do GetBlogTitle^%bi.SWrCE.Blog(id)
}

ClassMethod getBlogTitleJS(blogID)
{
	; to retrieve blog title
	s title = $$GetBlogTitleJS^%bi.SWrCE.Blog(blogID)
	q title
}

ClassMethod addBlogJS(title, folderID)
{
	; to create new blogs
	d AddBlogJS^%bi.SWrCE.Blog(title,folderID)
}

ClassMethod checkPostJS(blogID)
{
	; to check existing post within the blog
	; to reconfirm when user attempts to remove any blog
	;d CheckPostJS^%bi.SWrCE.Blog(blogID)
	s yesNo = $$CheckPostJS^%bi.SWrCE.Blog(blogID)
	q yesNo
}

ClassMethod removeBlogJS(blogID)
{
	; to remove blogs
	d RemoveBlogJS^%bi.SWrCE.Blog(blogID)
}

/* classmethod no longer accessed
ClassMethod displayBlogJS(blogID)
{
	; to display the blog properties selected
	d DisplayBlogJS^%bi.SWrCE.Blog(blogID)
}
*/

/* classmethod no longer accessed
ClassMethod displayPropJS(blogID)
{
	; for create users authorisation
	s blogProp = $$DisplayPropJS^%bi.SWrCE.Blog(blogID)
	q blogProp
}
*/
ClassMethod updateBlogJS(blogID, title, folderID)
{
	; to update blog properties
	d UpdateBlogJS^%bi.SWrCE.Blog(blogID,title,folderID)
}

ClassMethod checkAccessJS(blogID, source)
{
	;source
	;1 = from blogindex.csp
	;2 = from blogprop.csp
	
	; to check for users' access permission
	s authorised = $$CheckAccessJS^%bi.SWrCE.Blog(blogID)
	; authorised = 1, is authorised; authorised = 0, is not authorised
	i (authorised=1) { 
		w "authorisedUser=1;"
		i (source=1) { d DisplayBlogJS^%bi.SWrCE.Blog(blogID,authorised) }
		else {	
			i authorised=1 s blogProp = $$DisplayPropJS^%bi.SWrCE.Blog(blogID)
			e  q 0
			q blogProp
		}
	}
	else { w "authorisedUser=0;"}
}

ClassMethod remLastJS()
{
	;remove current user highlight
	w "LbName='"_%session.Get("LastName")_"';"
	w "LbId='"_%session.Get("LastID")_"';"
}

ClassMethod keepLastJS(bName, bID)
{
	;set current user highlight
	s %session.Data("LastName") = bName
	s %session.Data("LastID") = bID
}

ClassMethod readPostJS(postID)
{
	; displays the chosen post
	d ReadPostJS^%bi.SWrCE.BlogPost(postID)
}

ClassMethod addPostJS(cat, subCat, title, post)
{
	; to add new blog post
	d AddPostJS^%bi.SWrCE.BlogPost(cat,subCat,title,post)
}

ClassMethod deletePostJS(postID)
{
	; to delete existing blog
	d DeletePostJS^%bi.SWrCE.BlogPost(postID)
}

ClassMethod editPostJS(postID, cat, subCat, title, post)
{
	; to edit existing blog
	d EditPostJS^%bi.SWrCE.BlogPost(postID,cat,subCat,title,post)
}

ClassMethod addCommentJS(postID, msg)
{
	; for readers to add comments
	d AddCommentJS^%bi.SWrCE.BlogComment(postID,msg)
}

ClassMethod displayUserListJS()
{
	; for readers to add comments
	s userList = $$DisplayUserListJS^%bi.SWrCE.Blog()
	q userList
}

ClassMethod saveUsersJS(usrList)
{
	; to add members into blog group
	d SaveUsersJS^%bi.SWrCE.Blog(usrList)
}

ClassMethod setFilter(blogID, byType, val)
{
	; to filter blog post display
	; byType = '', to display all post of the selected blog 
	; byType = 1, filter by MONTH
	; byType = 2, filter by CATEGORY
	; val carries the selected value of the dropdownlist box
	
	i (byType '= "")
	{ 
		s %session.Data("byType") = byType
		s %session.Data(blogID,"filterIndex") = val
	}
	else 
	{ 
		k %session.Data(blogID,"filterIndex")
		k %session.Data("byType")
	}
}

ClassMethod genericFilter(blogID, byType, val, MixStr2, divId)
{
	if (byType'=""),(val'="") s %session.Data("byType")=byType,%session.Data(blogID,"filterIndex")=val
	else  k %session.Data("byType"),%session.Data(blogID,"filterIndex")
	s %session.Data("blogID")=blogID
	s:'$D(MixStr2) MixStr2=""
	s blog = ##class(%BI.Blog).%OpenId(blogID)
	q:blog=""
	w "document.getElementById('"_divId_"').innerHTML = """
	d genBottomPanelContent^%bi.SWr.WebDashboard4(1)
	w """;"
}

ClassMethod getSelectedVal(blogID)
{
	; to retrieve current selected filter value
	; to set the dropdownlist box value correctly after filtering
	s val = $G(%session.Data(blogID,"filterIndex"))
	q val
}

ClassMethod doOnLoad(blogID)
{
	; to automatically open and display the blog and the post list
	; used when a blog is opened from another window
	d doOnLoad^%bi.SWrCE.Blog(blogID)
	q
}

ClassMethod nGenList(id)
{
	do nGenList^%bi.SWr.WebDList(id)
}

}
