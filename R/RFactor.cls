Class R.RFactor Extends %RegisteredObject
{

Property ids As %ListOfDataTypes;

Property levels As %ListOfDataTypes;

Property indexbase As %Integer;

Method %OnNew(c As %ListOfDataTypes, indexbase As %Integer = 1, ids As %ListOfDataTypes = "") As %Status
{
	Set ..indexbase = indexbase
	If ids'="" {
		Set ..ids = ids
		// Interpret c as the levels
		Set:c'="" ..levels = c
	}
	Else {
		Set lv = ##class(%ListOfDataTypes).%New()
		Set len = c.Count()
		Set i = 1
		While (i<=len) {
			Set v = c.GetAt(i)
			Set ix = $S(v="":"",1:lv.Find(v))
			If (ix="") && (v'="") {
				Set ix = lv.Count()
				Do lv.Insert(v)
			}
			Do ..ids.Insert($S(ix="":##class(REXPInteger).#NA,1:(ix+indexbase)))
			Set i = $I(i)
		}
		
		Set len = lv.Count()
		Set i = 1
		While (i<=len) {
			Do ..levels.Insert(lv.GetAt(i))
			Set i = $I(i)
		}
	}
	Quit $$$OK
}

/** returns the level of a given case
		@param i case number
		@return name. may throw exception if out of range */
Method at(i As %Integer) As %String
{
	Set li = ..ids.GetAt(i) - ..indexbase
	Quit ..levels.GetAt(li)
}

/** returns <code>true</code> if the data contain the given level index */
Method contains(li As %Integer) As %Boolean
{
	Set i = 1
	Set c = 0
	While (i <= ..ids.Count()) {
		If (..ids.GetAt(i)=li) {
			Set c = 1
			Quit
		} 
		Set i = $I(i)
	}
	Quit c
}

/** return the index of a given level name or -1 if it doesn't exist */
Method levelIndex(name As %String) As %Integer
{
	Quit:(name="") ""
	Set i = 1
	Set idx = ""
	While (i <= ..levels.Count()) {
		If (..levels.GetAt(i)=name) {
			Set idx = i + ..indexbase
			Quit
		}
		Set i = $I(i)
	}
	Quit idx
}

/** return <code>true</code> if the factor contains the given level (it is NOT the same as levelIndex==-1!) */
Method containsName(name As %String) As %Boolean
{
	Set li = ..levelIndex(name)
	Quit:li="" 0
	Set i = 1
	Set c = 0
	While (i <= ..ids.Count()) {
		If (..ids.GetAt(i)=li) {
			Set c = 1
			Quit
		}
		Set i = $I(i)
	}
	Quit c
}

/** count the number of occurences of a given level index */
Method count(levelIndex As %Integer) As %Integer
{
	Set i = 1
	Set ct = 0
	While (i <= ..ids.Count()) {
		Set:(..ids.GetAt(i)=levelIndex) ct = $I(ct)
		Set i = $I(i)
	}
	Quit ct
}

/** count the number of occurences of a given level name */
Method countName(name As %String) As %Integer
{
	Quit ..count(..levelIndex(name))
}

/** return an array with level counts. */
Method counts() As %ListOfDataTypes
{
	Set c = ##class(%ListOfDataTypes).%New()
	For i=1:1:..levels.Count() {
		Do c.Insert(0)
	}
	
	Set i = 1
	While (i <= ..ids.Count()) {
	Set li = ..ids.GetAt(i) - ..indexbase
		If (li>=1) && (li<=..levels.Count()) {
			Set v = c.GetAt(li)
			Set v = $I(v)
			Do c.SetAt(li, v)
		}
		
		Set i = $I(i)
	}
	Quit c
}

/** return the list of levels (0-based, use {@link #indexBase} correction if you want to access it by level index) */
Method levels() As %ListOfDataTypes
{
	Quit ..levels
}

/** return the contents as integer indices (with the index base of this factor) 
Method asIntegers() As %ListOfDataTypes
{
	Quit ..ids
}
*/

/** return the contents as integer indices with a given index base */
Method asIntegers(desiredindexbase As %Integer = "") As %ListOfDataTypes
{
	Quit:desiredindexbase="" ..ids 
	Quit:(desiredindexbase=..indexbase) ..ids
	Set ix = ##class(%ListOfDataTypes).%New()
	Set j = 1
	While (j <= ..ids.Count()) { 
		Set ixj = ..ids.GetAt(j) - ..indexbase + desiredindexbase
		Set j = $I(j)
	 }
	Quit ix
}

/** return the level name for a given level index */
Method levelAtIndex(li As %Integer) As %String
{
	Set li = li - ..indexbase
	Quit ..levels.GetAt(li)
}

/** return the level index for a given case */
Method indexAt(i As %Integer) As %Integer
{
	Quit ..ids.GetAt(i)
}

/** return the factor as an array of strings */
Method asStrings() As %ListOfDataTypes
{
	Set s = ##class(%ListOfDataTypes).%New()
	Set i = 1
	While (i <= ..ids.Count()) {
		Do s.Insert(..at(i))
		Set i = $I(i)
	}
	Quit s
}

/** return the base of the levels index */
Method indexBase() As %Integer
{
	Quit ..indexbase
}

/** returns the number of cases */
Method size() As %Integer
{
 	Quit ..ids.Count()
}

Method toString() As %String
{
	Quit "[ids:"_..ids.Count()_",levels:"_..levels.Count()_",indexbase:"_..indexbase_"]"
}

Method toJSON() As %DynamicObject
{
	Set d = ##class(%DynamicObject).%New()
	Set d.classname = ..%ClassName(1)
	
	set ids = ##class(%DynamicArray).%New()
	set len = ..ids.Count()
	for i=1:1:len {
		do ids.%Push(..ids.GetAt(i), "number")
	}
	set d.ids = ids
	
	set levels = ##class(%DynamicArray).%New()
	set len = ..levels.Count()
	for i=1:1:len {
		do levels.%Push(..levels.GetAt(i), "string")
	}
	set d.levels = levels
	
	do d.%Set("indexbase", ..indexbase, "number")
	
	Quit d
}

}

