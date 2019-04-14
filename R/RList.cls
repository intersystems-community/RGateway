Class R.RList Extends %ListOfObjects
{

Property names As %ListOfDataTypes;

// Property contents As %ListOfObjects;

Method %OnNew(contents = "", names = "") As %Status
{
	Set tSC = ##super()
	
	If contents'="" {
		For i=1:1:contents.Count() {
			Do ..Insert(contents.GetAt(i))
		}
	}
	If names'="" {
		For i=1:1:names.Count() {
			Do ..names.Insert(names.GetAt(i))
		}
	}
	Quit tSC
}

/** checks whether this list is named or unnamed
	 * @return <code>true</code> if this list is named, <code>false</code> otherwise */
Method isNamed() As %Boolean
{
	Quit (..names.Count()>0)
}

/** get xpression given a key
	@param v key
	@return value which corresponds to the given key or
	        <code>null</code> if the list is unnamed or key not found */
Method atKey(v As %String) As REXP
{
	Set i = ..names.Find(v)
	Quit ..GetAt(i)
}

/** get element at the specified position
	@param i index
	@return value at the index or <code>null</code> if the index is out of bounds */
Method at(i As %Integer) As REXP
{
	Quit ..GetAt(i)
}

/** return the key (name) at a given index
	 @param i index
	 @return ket at the index - can be <code>null</code> is the list is unnamed or the index is out of range */
Method keyAt(i As %Integer) As %String
{
	Quit ..names.GetAt(i)
}

/** set key at the given index. Using this method automatically makes the list a named one even if the key is <code>null</code>. Out of range operations are undefined (currently no-ops)
	 @param i index
	 @param value key name */
Method setKeyAt(i As %Integer, value As %String)
{
	If (..names.Count()=0) {
		For k=1:1:..Count() {
			Do ..names.Insert("")
		}
	}
	Do ..names.SetAt(i, value)
}

/** returns all keys of the list
	 * @return array containing all keys or <code>null</code> if list unnamed */
Method keys() As %ListOfDataTypes
{
	Quit ..names
}

Method addAt(index As %Integer, element As %RegisteredObject)
{
	 Do ..InsertAt(index, element)
	 Do:..names.Count()>0 ..names.InsertAt(index, "")
}

Method add(element As %RegisteredObject) As %Boolean
{
	Do ..Insert(element)
	Do:..names.Count()>0 ..names.Insert("")
	Quit 1
}

Method clearAll()
{
	Do ..Clear()
	Do ..names.Clear()
}

Method removeIndex(index As %Integer) As %RegisteredObject
{
	Set o = ..RemoveAt(index)
	Do:..names.Count()>0 ..names.RemoveAt(index)
	Quit o
}

Method remove(elem As %RegisteredObject) As %Boolean
{
	Set i = ..Find(elem)
	Do ..RemoveAt(i)
	Do:..names.Count()>0 ..names.RemoveAt(i)
	Quit 1
}

Method size() As %Integer
{
	Quit ..Count()
}

Method put(key As %String, value As %RegisteredObject)
{
	if (key = "") {
		Do ..Insert(value)
		return
	}
	if (..names.Count()>0) {
		set p = ..names.Find(key)
		if (p '= "") {  // find the key and set
			do ..SetAt(p, value)
			return
		}
	}
	
	if (..names.Count()=0) {
		set size = ..size()
		for i=1:1:size {
			do ..names.Insert("")
		}
	}
	do ..Insert(value)
	do ..names.Insert(key)
	return
}

Method removeByKey(key As %String) As %RegisteredObject
{
	if (..names.Count()=0) return ""
	set i = ..names.Find(key)
	if (i="") return ""
	set o = ..GetAt(i)
	do ..RemoveAt(i)
	do ..names.RemoveAt(i)
	return o
}

// other

Method toString() As %String
{
	set len = ..Count()
	set sb = "RList["_len_"]{"
	for i=1:1:len {
		set sb = sb_..names.GetAt(i)_":"_..GetAt(i).toString()_$S(i<len:",",1:"")
	}
	set sb = sb_"}"
	quit sb
}

Method toJSON() As %DynamicObject
{
	Set d = ##class(%DynamicObject).%New()
	Set d.classname = ..%ClassName(1)
	Set len = ..Count()
	Set d.length = len
	
	Set na = ##class(%DynamicArray).%New()
	for i=1:1:..names.Count() {
		Do na.%Push(..names.GetAt(i), "string")
	}
	Set d.names = na
	
	Set con = ##class(%DynamicArray).%New()
	for i=1:1:..Count() {
		Do con.%Push(..GetAt(i).toJSON())
	}
	Set d.contents = con
	
	Quit d
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}

