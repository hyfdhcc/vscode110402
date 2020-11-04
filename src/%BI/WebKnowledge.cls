Class %BI.WebKnowledge [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod InitializeKB()
{
	d InitializeKB^%bi.SWrCE.KnowledgeBase()
}

ClassMethod DeleteCategories(parentID, selectedPage)
{
	d DeleteCategories^%bi.SWrCE.KnowledgeCategory(parentID,selectedPage)
}

ClassMethod LoadAddCatForm()
{
	d LoadAddCatForm^%bi.SWrCE.KnowledgeCategory()
}

ClassMethod LoadEditCatForm(catID)
{
	d LoadEditCatForm^%bi.SWrCE.KnowledgeCategory(catID)
}

ClassMethod CheckRestrictions(currParentID, mode)
{
	d CheckRestrictions^%bi.SWrCE.KnowledgeCategory(currParentID,mode)
}

ClassMethod LoadBrdCrmbs(childID)
{
	d LoadBrdCrmbs^%bi.SWrCE.KnowledgeCategory(childID)
}

ClassMethod CheckExistence(currentUser, catID)
{
	d CheckExistence^%bi.SWrCE.KnowledgeCategory(currentUser,catID)
}

ClassMethod LoadPagesIndex(parentID, catPerPage, selectedPage, slots)
{
	d LoadPagesIndex^%bi.SWrCE.KnowledgeCategory(parentID,catPerPage,selectedPage, slots)
}

ClassMethod DispChildCatListings(catID, start, offset)
{
	d DispChildCatListings^%bi.SWrCE.KnowledgeCategory(catID,start,offset)
}

ClassMethod AddCategory(parentID, catName, catCnsltant, catDscrption, thrOrder, pstOrder, thrOrderBy, helpdesk, postTitle, viewers, module, preModule)
{
	//added sub cat later  (thrOrder, pstOrder, thrOrderBy)\
	d AddCategory^%bi.SWrCE.KnowledgeBase(parentID, catName, catCnsltant, catDscrption,thrOrder,pstOrder,thrOrderBy,helpdesk,postTitle,viewers,module ,preModule)
}

ClassMethod UpdateCategory(parentID, catName, catCnsltant, catDscrption, thrOrder, pstOrder, thrOrderBy, helpdesk, postTitle, viewers, module, preModule)
{
	d UpdateCategory^%bi.SWrCE.KnowledgeBase(parentID, catName, catCnsltant, catDscrption, thrOrder, pstOrder, thrOrderBy,helpdesk,postTitle ,viewers, module, preModule)
}

ClassMethod CountSubCat(parentID As %String) As %String
{
 	d CountSubCat^%bi.SWrCE.KnowledgeBase(parentID)
}

ClassMethod DelPost(postID, threadID, currID)
{
	d DelPost^%bi.SWrCE.KnowledgeBase(postID, threadID, currID)
}

ClassMethod DispThread(catID, scrollLvl, offSet, S1, P1, P2, T1)
{

	d DispThread^%bi.SWrCE.KnowledgeBase(catID, scrollLvl, offSet,S1,P1,P2,T1)
}

ClassMethod DisplayUpCategory(currID)
{
	d DisplayUpCategory^%bi.SWrCE.KnowledgeBase(currID)
}

ClassMethod EditPost(postID, currID, threadID, postTitle, postMessage, status, priority, typePost, module, type)
{
	d EditPost^%bi.SWrCE.KnowledgeBase(postID, currID, threadID, postTitle, postMessage,status,priority, typePost, module, type)
}

ClassMethod RefreshThread(postID, threadID, currID)
{
	d RefreshThread^%bi.SWrCE.KnowledgeBase(postID,threadID, currID)
}

ClassMethod RetrieveCategoryName(CategoryId)
{
	d RetrieveCategoryName^%bi.SWrCE.KnowledgeBase(CategoryId)
}

ClassMethod SortThread(sortID As %String)
{
	d SortThread^%bi.SWrCE.KnowledgeBase(sortID)
}

ClassMethod GenBrdCrumbThread(catID, down, offSet)
{
	d GenBrdCrumbThread^%bi.SWrCE.KnowledgeBase(catID,down,offSet)
}

/// This method will add a pivot created by the user as a cat in the Knowledge Base Category : Pivot
ClassMethod AddPivotAsKBCat(pivID)
{
	d AddPivotAsKBCat^%bi.SWrCE.KnowledgeCategory(pivID)
}

ClassMethod ViewPivotCat(pivID)
{
	d ViewPivotCat^%bi.SWrCE.KnowledgeCategory(pivID)
}

ClassMethod loadListType(type, id)
{
	//added by jacob to support priority and status called from StatPrioEditor.csp
	d loadListType^%bi.SWrCE.KnowledgeBase(type,id)
}

ClassMethod SaveListType(type, id, first, second, third)
{
	d SaveListType^%bi.SWrCE.KnowledgeBase(type,id,first,second,third)
}

ClassMethod CheckPermission(currID)
{
	q $$CheckPermission^%bi.SWrCE.KnowledgeBase(currID)
}

ClassMethod SaveEditArea(currID, threadID, text)
{
	d SaveEditArea^%bi.SWrCE.KnowledgeBase(currID,threadID,text)
}

ClassMethod DelListType(type, id)
{
	k ^BI.KnowledgeThreadC(type,id)
}

ClassMethod preModule(value)
{
	d preModule^%bi.SWrCE.KnowledgeBase(value)
}

ClassMethod saveMailThread(value)
{
	s userid = $P(%session.Get("currUserID"),$C(6),1)
	d saveMailThread^%bi.SWrCE.KnowledgeCategory(value,userid)
}

ClassMethod subscribe(value)
{
	s userid = $P(%session.Get("currUserID"),$C(6),1)
	d subscribe^%bi.SWrCE.KnowledgeCategory(value,userid)
}

ClassMethod unsubscribe(value)
{
	s userid = $P(%session.Get("currUserID"),$C(6),1)
	d unsubscribe^%bi.SWrCE.KnowledgeCategory(value,userid)
}

ClassMethod checkIfUnsubscribe(threadId)
{
	d checkIfUnsubscribe^%bi.SWrCE.KnowledgeCategory(threadId)
}

ClassMethod changePerson(selID, val, threadID, catID, sequent)
{
	d changePerson^%bi.SWrCE.KnowledgeCategory(selID,val,threadID,catID, sequent)
}

// KnowledgeBaseLogin.csp

ClassMethod loadUserDetail()
{
	d loadUserDetail^%bi.SWrCE.KnowledgeBaseLogin
}

ClassMethod checkPass(oldPass, newPass, confirmPass)
{
	d checkPass^%bi.SWrCE.KnowledgeBaseLogin(oldPass,newPass,confirmPass)
}

ClassMethod checkUsername(username)
{
	d checkUsername^%bi.SWrCE.KnowledgeBaseLogin(username)
}

ClassMethod saveUserDetail(username, newPass, emailAddr)
{
	d saveUserDetail^%bi.SWrCE.KnowledgeBaseLogin(username,newPass,emailAddr)
}

}
