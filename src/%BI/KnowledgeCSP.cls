Class %BI.KnowledgeCSP [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod PassValKnowCat(id, chk, xxx)
{
	d PassValKnowCat^%bi.SWrCE.KnowledgeBase(id,chk,xxx)
}

ClassMethod InitializeKB()
{
	d InitializeKB^%bi.SWrCE.KnowledgeBase()
}

ClassMethod DeleteCategories(parentID)
{
	d DeleteCategories^%bi.SWrCE.KnowledgeBase(parentID)
}

ClassMethod LoadAddCatForm()
{
	d LoadAddCatForm^%bi.SWrCE.KnowledgeBase()
}

ClassMethod LoadEditCatForm(catID)
{
	d LoadEditCatForm^%bi.SWrCE.KnowledgeBase(catID)
}

ClassMethod CheckRestrictions(currParentID, mode)
{
	d CheckRestrictions^%bi.SWrCE.KnowledgeBase(currParentID,mode)
}

ClassMethod LoadBrdCrmbs(childID)
{
	d LoadBrdCrmbs^%bi.SWrCE.KnowledgeBase(childID)
}

ClassMethod CheckExistence(currentUser, catID)
{
	d CheckExistence^%bi.SWrCE.KnowledgeBase(currentUser,catID)
}

ClassMethod LoadPagesIndex(parentID, catPerPage, selectedPage, slots)
{
	d LoadPagesIndex^%bi.SWrCE.KnowledgeBase(parentID,catPerPage,selectedPage, slots)
}

ClassMethod DispChildCatListings(catID, start, offset)
{
	d DispChildCatListings^%bi.SWrCE.KnowledgeBase(catID,start,offset)
}

ClassMethod AddCategory(parentID, catName, catCnsltant, catDscrption)
{
	d AddCategory^%bi.SWrCE.KnowledgeBase(parentID, catName, catCnsltant, catDscrption)
}

ClassMethod UpdateCategory(parentID, catName, catCnsltant, catDscrption)
{
	d UpdateCategory^%bi.SWrCE.KnowledgeBase(parentID, catName, catCnsltant, catDscrption)
}

ClassMethod CountSubCat(parentID As %String) As %String
{
 	d CountSubCat^%bi.SWrCE.KnowledgeBase(parentID)
}

ClassMethod DelPost(postID, threadID, currID)
{
	d DelPost^%bi.SWrCE.KnowledgeBase(postID, threadID, currID)
}

ClassMethod DispThread(catID, scrollLvl, offSet)
{
	d DispThread^%bi.SWrCE.KnowledgeBase(catID, scrollLvl, offSet)
}

/*ClassMethod DispCategory(id)
{
	d DispCategory^%bi.SWrCE.KnowledgeBase(id)
}

ClassMethod DispDownCategory(id)
{
	d DispDownCategory^%bi.SWrCE.KnowledgeBase(id)
}

ClassMethod DisplayUpCategory(currParentID, uplvl)
{
	d DisplayUpCategory^%bi.SWrCE.KnowledgeBase(currParentID, uplvl)
}

ClassMethod DivertToMain(currParentID, uplvl)
{
	d DivertToMain^%bi.SWrCE.KnowledgeBase(currParentID, uplvl)
}

ClassMethod SavePost(currID, threadID, postTitle, postMessage, spanArray)
{
	d SavePost^%bi.SWrCE.KnowledgeBase(currID, threadID, postTitle, postMessage, spanArray)
}*/
ClassMethod EditPost(postID, currID, threadID, postTitle, postMessage)
{
	d EditPost^%bi.SWrCE.KnowledgeBase(postID, currID, threadID, postTitle, postMessage)
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

}
