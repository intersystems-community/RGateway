Class R.REXPLogical Extends REXPVector
{

/** NA integer value as defined in R. Unlike its real equivalent this one can be used in comparisons, 
although {@link #isNA(int) } is provided for consistency. */
Parameter NAinternal = -2147483648;

/** NA boolean value as used in REXPLogical implementation. 
This differs from the value used in R since R uses int data type and we use byte. 
Unlike its real equivalent this one can be used in comparisons, although {@link #isNA(byte) } is provided for consistency. */
Parameter NA = -128;

/// A list of %Integer
Property payload As %ListOfDataTypes;

ClassMethod isNAN(value As %String) As %Boolean
{
	Quit (value=..#NA)
}

Method %OnNew(load, attr = "") As %Status
{
	If $IsObject(load) { // An array
		Set ..payload = load
	}
	Else {
		Do:load'="" ..payload.Insert(load)
	}
	Quit ##super(attr)
}

Method length() As %Integer
{
	Quit ..payload.Count()
}

Method isLogical() As %Boolean
{
 	Quit 1
}

Method asNativeObject() As %RegisteredObject
{
	Quit ..payload
}

Method asIntegers() As %ListOfDataTypes
{
	Quit ..payload
}

Method asBytes() As %Stream.GlobalBinary
{
	Set b = ##class(%Stream.GlobalBinary).%New()
	Set len = ..payload.Count()
	For i=1:1:len {
		do b.Write($NC(..payload.GetAt(i),"S1"))
	}
	DO b.Rewind()
 	Quit b
}

/** returns the contents of this vector as strings */
Method asStrings() As %ListOfDataTypes
{
	Set s = ##class(%ListOfDataTypes).%New()
	Set len = ..payload.Count()
	For i=1:1:len {
		// map bytes to integers including NA representation
		Set v = $CASE(..payload.GetAt(i), ..#NA:"NA", 0:"FALSE", :"TRUE")
		Do s.Insert(v)		
	}
	Quit s
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
	Set len = ..payload.Count()
	For i=1:1:len {
		Set b = $S(..payload.GetAt(i)=..#NA:1,1:0)
		Do a.Insert(b)
	}
	Quit a
}

/** returns a boolean array of the same langth as the receiver with <code>true</code> for <code>TRUE</code> values and <code>false</code> for <code>FALSE</code> and <code>NA</code> values.
	 @return boolean array */
Method isTRUE() As %ListOfDataTypes
{
	Set a = ##class(%ListOfDataTypes).%New()
	Set len = ..payload.Count()
	For i=1:1:len {
		Set v = ..payload.GetAt(i)
		Set b = $S('(v=..#NA)&&'(v=0):1,1:0)
		Do a.Insert(b)
	}
	Quit a
}

/** returns a boolean array of the same langth as the receiver with <code>true</code> for <code>FALSE</code> values and <code>false</code> for <code>TRUE</code> and <code>NA</code> values.
	 @return boolean array */
Method isFALSE() As %ListOfDataTypes
{
	Set a = ##class(%ListOfDataTypes).%New()
	Set len = ..payload.Count()
	For i=1:1:len {
		Set v = ..payload.GetAt(i)
		Set b = $S(v=0:1,1:0)
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
		set sb = sb_..payload.GetAt(i)_$S(i<len:",",1:"")
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
		Set sb=sb_$CASE(..payload.GetAt(i),..#NA:"NA",0:"FALSE",:"TRUE")
		Set:i<len sb=sb_","
	}
	Set sb = sb_"}"
	Quit sb
}
*/
}

