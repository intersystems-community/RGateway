Include %occErrors

Class R.REngineException Extends %Exception.AbstractException
{

Property engine As REngine;

Method %OnNew(engine, msg, cause = "") As %Status
{
	// pName As %String = "", pCode As %String = "", pLocation As %String = "", pData As %String = "", pInnerException As %Exception.AbstractException = {$$$NULLOREF}
	Set ..engine = engine
	Quit ##super(,$$$GeneralError,,msg,cause)
}

Method getEngine() As REngine
{
	Quit ..engine
}

}

