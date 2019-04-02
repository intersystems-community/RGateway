Class R.REXPList Extends REXPVector
{

Property payload As RList;

Method %OnNew(arg1, arg2 = "") As %Status
{
	If (arg1="") {
		Quit ##super()
	}
	ElseIf arg1.%IsA("R.RList") { // RList, REXPList
		Set list = arg1
		Set attr = arg2
		Set ..payload = list
		Quit ##super(attr)
	}
	Else { // value, name
		set value = arg1, name = arg2
		do ..payload.put(name,value)
		Quit ##super()
	}
}

Method length() As %Integer
{
	Quit ..payload.size()
}

Method isList() As %Boolean
{
 	Quit 1
}

Method isPairList() As %Boolean
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
	Quit ..payload.toString()
}

/*
Method toDebugString() As %String
{
	Set sb = ##super()_"{"
	For i=1:1:..payload.size() {
		Set name = ..payload.keyAt(i)
		Set:name'="" sb = sb_name_"="
		Set sb = sb_..payload.at(i).toDebugString()
	}
	Set sb = sb_"}"
	Quit sb
}
*/
Method toJSON() As %ZEN.proxyObject
{
	Set d = ##class(%ZEN.proxyObject).%New()
	Set d.classname = ..%ClassName(1)
	Set d.payload = ..payload.toJSON()
	Quit d
}

}

