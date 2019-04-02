Class R.REXPEnvironment Extends REXP
{

/** engine associated with this environment */
Property eng As REngine;

/** transparent handle that can be used by the engine to indentify the environment. It is not used by REngine API itself. */
Property handle As %RegisteredObject;

/** create a new environemnt reference - this constructor should never be used directly, use {@link REngine.newEnvironment()} instead.
	 *  @param eng engine responsible for this environment
	 *  @param handle handle used by the engine to identify this environment
	 */
Method %OnNew(eng, handle, attr = "") As %Status
{
	Set ..eng = eng
	Set ..handle = handle
	Quit ##super(attr)
}

Method isEnvironment() As %Boolean
{
	Quit 1
}

/** returns the handle used to identify this environemnt in the engine - for internal use by engine implementations only
	 *  @return handle of this environment */
Method getHandle() As %RegisteredObject
{
 	Quit ..handle
}

/** get a value from this environment
	 *  @param name name of the value
	 *  @param resolve if <code>false</code> returns a reference to the object, if <code>false</code> the reference is resolved
	 *  @return value corresponding to the symbol name or possibly <code>null</code> if the value is unbound (the latter is currently engine-specific) */
Method get(name As %String, resolve As %Boolean = 1) As REXP
{
	Quit ..eng.get(name, $this, resolve)
}

/** get a value from this environment - equavalent to <code>get(name, true)</code>.
	 *  @param name name of the value
	 *  @return value (see {@link #get(String,boolean)})
	public REXP get(String name) throws REngineException {
		return get(name, true);
	}
*/

/** assigns a value to a given symbol name
	 *  @param name symbol name
	 *  @param value value */
Method assign(name As %String, value As REXP)
{
	Do ..eng.assign(name, value, $this)
}

/** returns the parent environment or a reference to it
	 *  @param resolve if <code>true</code> returns the environemnt, otherwise a reference. 
	 *  @return parent environemnt (or a reference to it) */
Method parent(resolve As %Boolean = 1) As REXP
{
	Quit ..eng.getParentEnvironment($this, resolve)
}

/** returns the parent environment. This is equivalent to <code>parent(true)</code>.
	 *  @return parent environemnt 
	public REXPEnvironment parent() throws REngineException {
		return (REXPEnvironment) parent(true);
	}
*/
}

