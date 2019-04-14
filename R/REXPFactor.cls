Class R.REXPFactor Extends REXPInteger
{

Property levels As %ListOfDataTypes;

Property factor As RFactor;

Method %OnNew(arg1, arg2 = "", arg3 = "") As %Status
{
	// factor, attr
	If arg1.%IsA("R.RFactor") {
		#Dim factor As RFactor = arg1
		Set ..factor = factor
		Set ..levels = factor.levels()
		If arg2="" {
			Set contents = ##class(%ListOfObjects).%New()
			Do contents.Insert(##class(REXPString).%New(..levels))
			Do contents.Insert(##class(REXPString).%New("factor"))
			
			Set names = ##class(%ListOfDataTypes).%New()
			Do names.Insert("levels"), names.Insert("class")
			
			Set attr = ##class(REXPList).%New(##class(RList).%New(contents,names))
		}
		Else {
			Set attr = arg2
		}
		
		Quit ##super(factor.asIntegers(1), attr)
	}
	
	// ids, levels, attr
	Set ids = arg1, levels = arg2
	Set ..levels = ids
	Set ..factor = ##class(RFactor).%New(levels,1,ids)
	If arg3="" {
		Set contents = ##class(%ListOfObjects).%New()
		Do contents.Insert(##class(REXPString).%New(levels))
		Do contents.Insert(##class(REXPString).%New("factor"))
			
		Set names = ##class(%ListOfDataTypes).%New()
		Do names.Insert("levels"), names.Insert("class")
			
		Set attr = ##class(REXPList).%New(##class(RList).%New(contents,names))
	}
	Else {
		Set attr = arg3
	}
	Quit ##super(ids,attr)
}

Method isFactor() As %Boolean
{
 	Quit 1
}

/** return the contents as a factor - the factor is guaranteed to have index base 1
	 *  @return the contents as a factor */
Method asFactor() As RFactor
{
	Quit ..factor
}

Method asStrings() As %ListOfDataTypes
{
	Quit ..factor.asStrings()
}

Method asNativeObject() As %RegisteredObject
{
	Quit ..asStrings()
}

Method toString() As %String
{
	Quit ##super()
}

Method toJSON() As %DynamicObject
{
	Set d = ##class(%DynamicObject).%New()
	Set a = ##class(%DynamicArray).%New()
	Set len = ..levels.Count()
	For i=1:1:len {
		Do a.%Push(..levels.GetAt(i), "number")
	}
	Set d.levels=a
	Set d.factor=..factor.toJSON()
	Quit d
}

}

