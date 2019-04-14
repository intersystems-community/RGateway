Class R.REXPSymbol Extends REXP
{

Property name As %String;

Method %OnNew(name, attr = "") As %Status
{
	Set ..name = name
	Quit ##super(attr)
}

Method isSymbol() As %Boolean
{
 	Quit 1
}

/** returns the name of the symbol
	 *  @return name of the symbol */
Method asString() As %String
{
 	Quit ..name
}

Method asStrings() As %ListOfDataTypes
{
	Set names = ##class(%ListOfDataTypes).%New()
	Do names.Insert(..name)
	Quit names
}

Method toString() As %String
{
	Quit ##super()_"['"_..name_"']"
}

Method asNativeObject() As %RegisteredObject
{
	Quit ..name
}

Method toJSON() As %DynamicObject
{
	Set d = ##class(%DynamicObject).%New()
	Set d.name = a
	Quit d
}

}

