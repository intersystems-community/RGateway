Class R.REXPGenericVector Extends REXPVector
{

Property payload As RList;

Method %OnNew(list, attr = "") As %Status
{
	Set:list'="" ..payload = list
	If attr="" {
		If ..payload.isNamed() {
			Set contents = ##class(%ListOfObjects).%New()
			Do contents.Insert(##class(REXPString).%New("", ..payload.keys()))
			
			Set names = ##class(%ListOfDataTypes).%New()
			Do names.Insert("names")
			
			Set attr = ##class(REXPList).%New("", ##class(RList).%New(contents, names))
		}
	}
	Quit ##super(attr)
}

Method asNativeObject() As %RegisteredObject
{
	Quit ..payload
}

Method length() As %Integer
{
 	Quit ..payload.size()
}

Method isList() As %Boolean
{
 	Quit 1
}

Method isRecursive() As %Boolean
{
 	Quit 1
}

Method asList() As RList
{
 	Quit ..payload
}

Method toString() As %String
{
	Quit ##super()_..payload.toString()
}

Method toJSON() As %DynamicObject
{
	Set d = ##class(%DynamicObject).%New()
	Set d.payload = ..payload.toJSON()
	Quit d
}

}

