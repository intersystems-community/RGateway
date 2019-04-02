Class R.REXPReference Extends REXP
{

Property eng As REngine;

Property handle As %RegisteredObject;

Property resolvedValue As REXP;

Method %OnNew(eng, handle, attr = "") As %Status
{
	Set ..resolvedValue = ""
	Set ..eng = eng
	Set ..handle = handle
	Quit ##super(attr)
}

/** resolve the external REXP reference into an actual REXP object. In addition, the value (if not <code>null</code>) will be cached for subsequent calls to <code>resolve</code> until <code>invalidate</code> is called. */
Method resolve() As REXP
{
	Quit:..resolvedValue'="" ..resolvedValue
	Set ..resolvedValue = ..eng.resolveReference($this)
	Quit ..resolvedValue
}

/** invalidates any cached representation of the reference */
Method invalidate()
{
	Set ..resolvedValue = ""
}

/** finalization that notifies the engine when a reference gets collected */
Method finalize()
{
	Do ..eng.finalizeReference($this)
}

// type checks

Method isString() As %Boolean
{
 Quit ..resolve().isString()
}

Method isNumeric() As %Boolean
{
 Quit ..resolve().isNumeric()
}

Method isInteger() As %Boolean
{
 Quit ..resolve().isInteger()
}

Method isNull() As %Boolean
{
 Quit ..resolve().isNull()
}

Method isFactor() As %Boolean
{
 Quit ..resolve().isFactor()
}

Method isList() As %Boolean
{
 Quit ..resolve().isList()
}

Method isLogical() As %Boolean
{
 Quit ..resolve().isLogical()
}

Method isEnvironment() As %Boolean
{
 Quit ..resolve().isEnvironment()
}

Method isLanguage() As %Boolean
{
 Quit ..resolve().isLanguage()
}

Method isSymbol() As %Boolean
{
 Quit ..resolve().isSymbol()
}

Method isVector() As %Boolean
{
 Quit ..resolve().isVector()
}

Method isRaw() As %Boolean
{
 Quit ..resolve().isRaw()
}

Method isComplex() As %Boolean
{
 Quit ..resolve().isComplex()
}

Method isRecursive() As %Boolean
{
 Quit ..resolve().isRecursive()
}

Method isReference() As %Boolean
{
 Quit 1
}

// basic accessor methods

Method asStrings() As %ListOfDataTypes
{
 Quit ..resolve().asStrings()
}

Method asIntegers() As %ListOfDataTypes
{
 Quit ..resolve().asIntegers()
}

Method asDoubles() As %ListOfDataTypes
{
 Quit ..resolve().asDoubles()
}

Method asList() As RList
{
 Quit ..resolve().asList()
}

Method asFactor() As RFactor
{
 Quit ..resolve().asFactor()
}

Method length() As %Integer
{
 Quit ..resolve().length()
}

Method attr()
{
 Quit ..resolve().attr()
}

Method getHandle() As %RegisteredObject
{
 Quit ..handle
}

Method getEngine() As REngine
{
 Quit ..eng
}

Method toString() As %String
{
 Quit ##super()_"{eng="_..eng.toString()_",h="_..handle_"}"
}

}

