Class R.REngineEvalException Extends REngineException
{

/**
	 * Value returned by the rniEval native method when the input passed to eval
	 * is invalid
	 */
Parameter INVALIDINPUT = -1;

/**
	 * Value returned by the rniEval native method when an error occured during 
	 * eval (stop, ...)
	 */
Parameter ERROR = -2;

/**
	 * Type of eval error
	 */
Property type As %Integer;

Method %OnNew(engine, message, type = "") As %Status
{
	Set ..type = $S(type="":..#ERROR,1:type)
	Quit ##super(engine,message)
}

/**
	 * @return the type of error (ERROR or INVALID_INPUT)
	 */
Method getType() As %Integer
{
	Quit ..type
}

}

