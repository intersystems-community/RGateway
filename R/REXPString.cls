Class R.REXPString Extends REXPVector
{

/// Array of %String
Property payload As %ListOfDataTypes;

Method %OnNew(load, attr = "") As %Status
{
	If $IsObject(load) { // An array of string
		Set ..payload = load
	}
	Else { // A single string
		Do:load'="" ..payload.Insert(load)
	}
	Quit ##super(attr)
}

Method length() As %Integer
{
	Quit ..payload.Count()
}

Method isString() As %Boolean
{
	Quit 1
}

Method asNativeObject() As %RegisteredObject
{
	Quit ..payload
}

Method asStrings() As %ListOfDataTypes
{
	Quit ..payload
}

Method asCArray(ByRef a)
{
	Set a = ..payload.Count()
	For i=1:1:a {
		Set a(i) = ..payload.GetAt(i)
	}
}

Method isNA() As %ListOfDataTypes
{
	Set a = ##class(%ListOfDataTypes).%New()
	For i=1:1:..payload.Count() {
		Set b = $S(..payload.GetAt(i)=##class(REXP).#NAString:1,1:0)
		Do a.Insert(b)
	}
	Quit a
}

Method toJSON() As %ZEN.proxyObject
{
	Set d = ##class(%ZEN.proxyObject).%New()
	Set len = ..payload.Count()
	Set d.length = len
	Set a = ##class(%ListOfDataTypes).%New()
	for i=1:1:len {
		Do a.Insert(..payload.GetAt(i))
	}
	Set d.payload = a
	Quit d
}

Method toString() As %String
{
	set len = ..payload.Count()
	set sb = ##super()
	set sb = sb_"["
	for i=1:1:len {
		set sb = sb_"'"_..payload.GetAt(i)_"'"_$S(i<len:",",1:"")
	}
	set sb = sb_"]"
	quit sb
}

/*
Method toDebugString() As %String
{
	Set sb = ##super()_"{"
	Set len = ..payload.Count()
	For i=1:1:len {
		Set sb = sb_"\"_..payload.GetAt(i)_"\"
		Set:i<len sb=sb_","
	}
	Set sb = sb_"}"
	Quit sb
}
*/
}

