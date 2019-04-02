Class R.REngine Extends %RegisteredObject [ Abstract ]
{

/** parse a string into an expression vector
		@param text string to parse
		@param resolve resolve the resulting REXP (<code>true</code>) or just return a reference (<code>false</code>)
	    @return parsed expression */
Method parse(text As %String, resolve As %Boolean) As REXP [ Abstract ]
{
}

/** evaluate an expression vector
		@param what an expression (or vector of such) to evaluate
		@param where environment to evaluate in (use <code>null</code> for the global environemnt and/or if environments are not supported by the engine)
		@param resolve resolve the resulting REXP or just return a reference
		@return the result of the evaluation of the last expression */
Method eval(what As REXP, where As REXP, resolve As %Boolean) As REXP [ Abstract ]
{
}

/** assign into an environment
		@param symbol symbol name
		@param value value to assign
		@param env environment to assign to (use <code>null</code> for the global environemnt and/or if environments are not supported by the engine) */
Method assign(symbol As %String, value As REXP, env As REXP = "") [ Abstract ]
{
}

/** get a value from an environment
		@param symbol symbol name
		@param env environment (use <code>null</code> for the global environemnt and/or if environments are not supported by the engine)
		@param resolve resolve the resulting REXP or just return a reference		
		@return value */
Method get(symbol As %String, env As REXP, resolve As %Boolean) As REXP [ Abstract ]
{
}

/** fetch the contents of the given reference. The resulting REXP may never be REXPReference. The engine should raise a {@link #REngineException} exception if {@link #supportsReferences()} returns <code>false</code>.
		@param ref reference to resolve
		@return resolved reference */
Method resolveReference(ref As REXP) As REXP [ Abstract ]
{
}

/** create a reference by pushing local data to R and returning a reference to the data. If ref is a reference it is returned as-is. The engine should raise a {@link #REngineException} exception if {@link #supportsReferences()} returns <code>false</code>.
	 @param value to create reference to
	 @return reference to the value */
Method createReference(value As REXP) As REXP [ Abstract ]
{
}

/** removes reference from the R side. This method is called automatically by the finalizer of <code>REXPReference</code> and should never be called directly.
	 @param ref reference to finalize */
Method finalizeReference(ref As REXP) [ Abstract ]
{
}

/** get the parent environemnt of an environemnt
	 @param env environment to query
	 @param resolve whether to resolve the resulting environment reference
	 @return parent environemnt of env */
Method getParentEnvironment(env As REXP, resolve As %Boolean) As REXP [ Abstract ]
{
}

/** create a new environemnt
	 @param parent parent environment
	 @param resolve whether to resolve the reference to the environemnt (usually <code>false</code> since the returned environment will be empty)
	 @return resulting environment */
Method newEnvironment(parent As REXP, resolve As %Boolean) As REXP [ Abstract ]
{
}

/** convenince method equivalent to <code>eval(parse(text, false), where, resolve);</code>
	 @param text to parse (see {@link #parse})
	 @param where environment to evaluate in (see {@link #eval})
	 @param resolve whether to resolve the resulting reference or not (see {@link #eval})
	 @return result */
Method parseAndEval(text As %String, where As REXP = "", resolve As %Boolean = 1) As REXP
{
	#Dim p As REXP = ..parse(text, 0)
	Quit ..eval(p, .where, resolve)
}

/** convenince method equivalent to <code>eval(parse(cmd, false), null, true);</code>
	 @param cmd expression to parse (see {@link #parse})
	 @return result */

// public REXP parseAndEval(String cmd) throws REngineException, REXPMismatchException { return parseAndEval(cmd, null, true);};

/** performs a close operation on engines that support it. The engine may not be used after <code>close()</code> returned <code>true</code>. This operation is optional and will always return <code>false</code> if not implemented.
	 @return <code>true</code> if the close opetaion was successful, <code>false</code> otherwise. */
Method close() As %Boolean
{
 Quit 0
}

// --- capabilities ---

/** check whether this engine supports references to R objects
	 @return <code>true</code> if this engine supports references, <code>false/code> otherwise */
Method supportsReferences() As %Boolean
{
 Quit 0
}

/** check whether this engine supports handing of environments (if not, {@link #eval} and {@link #assign} only support the global environment denoted by <code>null</code>).
	 @return <code>true</code> if this engine supports environments, <code>false/code> otherwise */
Method supportsEnvironments() As %Boolean
{
 Quit 0
}

/** check whether this engine supports REPL (Read-Evaluate-Print-Loop) and corresponding callbacks.
	 @return <code>true</code> if this engine supports REPL, <code>false/code> otherwise */
Method supportsREPL() As %Boolean
{
 Quit 0
}

/** check whether this engine supports locking ({@link #lock}, {@link #tryLock} and {@link #unlock}).
	 @return <code>true</code> if this engine supports REPL, <code>false/code> otherwise */
Method supportsLocking() As %Boolean
{
 Quit 0
}

// --- convenience methods --- (the REXPMismatchException catches should be no-ops since the value type is guaranteed in the call to assign)

/** convenience method equivalent to <code>assign(symbol, new REXPDouble(d), null)</code> (see {@link #assign(String, REXP, REXP)})
	 @param symbol symbol name to assign to
	 @param d values to assign */
/// d: double array
Method assignDoubles(symbol As %String, ByRef d)
{
	 #Dim e As REXPMismatchException
	 Try { 
	 	Set v = ##class(%ListOfDataTypes).%New()
	 	Set i=$O(d(""))
	 	While i'="" {
		 	Do v.Insert($G(d(i)))
		 	Set i=$O(d(i))
	 	}
	 	Do ..assign(symbol, ##class(REXPDouble).%New(v), "")
	 } Catch (e) { 
	 	Throw ##class(REngineException).%New($this, "REXPMismatchException in assign(,double[]): "_e.Data)
	 }
}

/** convenience method equivalent to <code>assign(symbol, new REXPInteger(d), null)</code> (see {@link #assign(String, REXP, REXP)})
	 @param symbol symbol name to assign to
	 @param d values to assign */
Method assignIntegers(symbol As %String, ByRef d)
{
	Try {
		Set v = ##class(%ListOfDataTypes).%New()
	 	Set i=$O(d(""))
	 	While i'="" {
		 	Do v.Insert($G(d(i)))
		 	Set i=$O(d(i))
	 	}
		Do ..assign(symbol, ##class(REXPInteger).%New(v), "")
	 } 
	Catch (e) {
		 Throw ##class(REngineException).%New($this, "REXPMismatchException in assign(,int[]): "_e.Data) 
	 }
}

/** convenience method equivalent to <code>assign(symbol, new REXPString(d), null)</code> (see {@link #assign(String, REXP, REXP)})
	 @param symbol symbol name to assign to
	 @param d values to assign */
Method assignStrings(symbol As %String, ByRef d)
{
	try {
		Set v = ##class(%ListOfDataTypes).%New()
	 	Set i=$O(d(""))
	 	While i'="" {
		 	Do v.Insert($G(d(i)))
		 	Set i=$O(d(i))
	 	}
		Do ..assign(symbol, ##class(REXPString).%New(v), "")
	} 
	catch (e) { 
		throw ##class(REngineException).%New($this, "REXPMismatchException in assign(,String[]): "_e.Data) 
	}
}

Method assignString(symbol As %String, d As %String)
{
	try { 
		Do ..assign(symbol, ##class(REXPString).%New(d), "")
	} 
	catch (e) { 
		throw ##class(REngineException).%New($this, "REXPMismatchException in assign(,String): "_e.Data) 
	}
}

/** convenience method equivalent to <code>assign(symbol, new REXPRaw(d), null)</code> (see {@link #assign(String, REXP, REXP)})
	 @param symbol symbol name to assign to
	 @param d values to assign */
Method assignBytes(symbol As %String, d As %Stream.GlobalBinary)
{
 	try 
	{ 
	 	Do ..assign(symbol, ##class(REXPRaw).%New(d), "") 
	} 
	catch (e) { 
	 	throw ##class(REngineException).%New($this, "REXPMismatchException in assign(,byte[]): "_e.Data)
	}
}

Method assignLogicals(symbol As %String, ByRef d)
{
	try {
		Set v = ##class(%ListOfDataTypes).%New()
	 	Set i=$O(d(""))
	 	While i'="" {
		 	Do v.Insert($G(d(i)))
		 	Set i=$O(d(i))
	 	} 
	 	Do ..assign(symbol, ##class(REXPLogical).%New(v), "") 
	} 
	catch (e) { 
	 	throw ##class(REngineException).%New($this, "REXPMismatchException in assign(,logical[]): "_e.Data)
	}
}

/** convenience method equivalent to <code>assign(symbol, new REXPString(d), null)</code> (see {@link #assign(String, REXP, REXP)})
	 @param symbol symbol name to assign to
	 @param d value to assign */

// public void assign(String symbol, String d) throws REngineException { try { assign(symbol, new REXPString(d), null); } catch (REXPMismatchException e) { throw(new REngineException(this, "REXPMismatchException in assign(,String[]): "+e)); } }

/** convenience method equivalent to <code>assign(symbol, value, null)</code> (see {@link #assign(String, REXP, REXP)})
	 @param symbol symbol name to assign to
	 @param value values to assign */

// public void assign(String symbol, REXP value) throws REngineException, REXPMismatchException { assign(symbol, value, null); }

// --- locking API ---

/** attempts to obtain a lock for this R engine synchronously (without waiting for it).
	    <br>Note: check for {@link #supportsLocking()} before relying on this capability. If not implemented, always returns 0.
	 @return 0 if the lock could not be obtained (R engine is busy) and some other value otherwise -- the returned value must be used in a matching call to {@link #unlock(int)}. */
Method tryLock() As %Integer
{
 Quit 0
}

/** obtains a lock for this R engine, waiting until it becomes available.
	 <br>Note: check for {@link #supportsLocking()} before relying on this capability. If not implemented, always returns 0.
	 @return value that must be passed to {@link #unlock} in order to release the lock */
Method lock() As %Integer
{
 Quit 0
}

/** releases a lock previously obtained by {@link #lock()} or {@link #tryLock()}.
	 <br>Note: check for {@link #supportsLocking()} before relying on this capability.  If not implemented, has no effect.
	 @param lockValue value returned by {@link #lock()} or {@link #tryLock()}. */
Method unlock(lockValue As %Integer)
{
}

Method toString() As %String
{
	Quit ""
}

Method wrap(o As %RegisteredObject) As REXP
{
	Quit REXPWrapper.wrap(o)
}

}

