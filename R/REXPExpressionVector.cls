Class R.REXPExpressionVector Extends REXPGenericVector
{

Method %OnNew(list, attr = "") As %Status
{
	Quit ##super(list, attr)
}

Method isExpression() As %Boolean
{
	Quit 1
}

}

