Class R.REXPVector Extends REXP [ Abstract ]
{

Method %OnNew(attr = "") As %Status
{
	Quit ##super(attr)
}

/** returns the length of the vector (i.e. the number of elements)
	 *  @return length of the vector */
Method length() As %Integer [ Abstract ]
{
}

Method isVector() As %Boolean
{
	Quit 1
}

/** returns a boolean vector of the same length as this vector with <code>true</code> for NA values and <code>false</code> for any other values
	 *  @return a boolean vector of the same length as this vector with <code>true</code> for NA values and <code>false</code> for any other values */
Method isNA() As %ListOfDataTypes
{
	Set a =  ##class(%ListOfDataTypes).%New()
	For i=1:1:..length() {
		#Dim b As %Boolean = 0
		Do a.Insert(b)
	}
	Quit a
}

Method toString() As %String
{
	Quit ##super()_"["_..length()_"]"
}

/*
Method toDebugString() As %String
{
	Quit ##super()_"["_..length()_"]"
}
*/
Storage Default
{
<Type>%Storage.Serial</Type>
}

}

