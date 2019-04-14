Class R.REXPDouble Extends REXPVector
{

/** NA real value as defined in R. Note: it can NOT be used in comparisons, you must use {@link #isNA(double)} instead. */
/// 7ff00000000007a2L
Parameter NA = {$CHAR($ZHEX("a2"),$ZHEX("07"),$ZHEX("00"),$ZHEX("00"),$ZHEX("00"),$ZHEX("00"),$ZHEX("f0"),$ZHEX("7f"))};

/// A list of %Double
Property payload As %ListOfDataTypes;

/** checks whether a given double value is a NA representation in R. Note that NA is NaN but not all NaNs are NA. */
ClassMethod isNAN(value As %String) As %Boolean
{
		/* on OS X i386 the MSB of the fraction is set even though R doesn't set it.
		   Although this is technically a good idea (to make it a QNaN) it's not what R does and thus makes the comparison tricky */
		//return (Double.doubleToRawLongBits(value) & 0xfff7ffffffffffffL) == (NA_bits & 0xfff7ffffffffffffL);
	Quit ((value="NAN")||(value="NA"))
}

/** create real vector of the length 1 with the given value as its first (and only) element */
Method %OnNew(load, attr = "") As %Status
{
	If $IsObject(load) {
		Set ..payload = load // A double array
	}
	Else {
		Do ..payload.Insert(load) // A single double value
	}
	Quit ##super(attr)
}

Method length() As %Integer
{
 	Quit ..payload.Count()
}

Method asNativeObject() As %RegisteredObject
{
	Quit ..payload
}

/** return <code>true</code> */
Method isNumeric() As %Boolean
{
 	Quit 1
}

/** returns the values represented by this vector */
Method asDoubles() As %ListOfDataTypes
{
 	Quit ..payload
}

/** converts the values of this vector into integers by cast */
Method asIntegers() As %ListOfDataTypes
{
	Set a = ##class(%ListOfDataTypes).%New()
	For i=1:1:..payload.Count() {
		Set b = $NORMALIZE(..payload.GetAt(i),0) // Conver to integer
		Do a.Insert(b)
	}
	Quit a
}

/** converts the values of this vector into strings */
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

/** returns a boolean vector of the same length as this vector with <code>true</code> for NA values and <code>false</code> for any other values (including NaNs) */
Method isNA() As %ListOfDataTypes
{
	Set a= ##class(%ListOfDataTypes).%New()
	For i=1:1:..payload.Count() {
		Set b = $S((..isNAN(..payload.GetAt(i))):1,1:0)
		Do a.Insert(b)
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
		If ..isNAN(v) {
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

