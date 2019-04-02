Class R.REXPNull Extends REXP
{

Method %OnNew(attr = "") As %Status
{
	Quit ##super(attr)
}

Method isNull() As %Boolean
{
 Quit 1
}

Method isList() As %Boolean
{
	// NULL is a list
 	Quit 1
}

Method asList() As RList
{
 	Quit ##class(RList).%New()
}

Method asNativeObject() As %RegisteredObject
{
 	Quit ""
}

}

