Class R.REXPInteger Extends REXPVector
{

/** NA integer value as defined in R. Unlike its real equivalent this one can be used in comparisons, although {@link #isNA(int) } is provided for consistency. */
Parameter NA = -2147483648;

Property payload As %ListOfDataTypes;

ClassMethod IsNAN(value As %String) As %Boolean
{
	Quit (value = ..#NA)
}

/** create integer vector of the length 1 with the given value as its first (and only) element */
/// load As %ListOfDataTypes
/// attr As REXPList
Method %OnNew(load, attr = "") As %Status
{
	If $IsObject(load) { // Array of int
		Set ..payload = load
	}
	Else { // Single int
		Do:load'="" ..payload.Insert(load)
	}
	
	Quit ##super(attr)
}

Method asNativeObject() As %RegisteredObject
{
	Quit ..payload
}

Method length() As %Integer
{
 	Quit ..payload.Count()
}

Method isInteger() As %Boolean
{
 	Quit 1
}

Method isNumeric() As %Boolean
{
 	Quit 1
}

Method asIntegers() As %ListOfDataTypes
{
 	Quit ..payload
}

/** returns the contents of this vector as doubles */
Method asDoubles() As %ListOfDataTypes
{
	Quit ..payload
}

/** returns the contents of this vector as strings */
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
		Set b = $S(..payload.GetAt(i)=..#NA:1, 1:0)
		Do ..payload.Insert(b)
	}
	Quit a
}

Method toString() As %String
{
	set len = ..payload.Count()
	set sb = ##super()
	set sb = sb_"["
	for i=1:1:len {
		set sb = sb_..payload.GetAt(i)_$S(i<len:",",1:"")
	}
	set sb = sb_"]"
	quit sb
}

Method toJSON() As %DynamicObject
{
	Set d = ##class(%DynamicObject).%New()
	Set len = ..payload.Count()
	Set d.length = len
	Set a = ##class(%DynamicArray).%New()
	For i=1:1:len {
		Set v = ..payload.GetAt(i)
		If ..IsNAN(v) {
			Do a.%Push("NA", "string")
		}
		Else {
			Do a.%Push(v, "number")
		}
	}
	Set d.payload = a
	Quit d
}

}

