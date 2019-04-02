Class R.REXPMismatchException Extends %Exception.AbstractException
{

Property sender As REXP;

Property access As %String;

/** primary constructor. The exception message will be formed as "attempt to access &lt;REXP-class&gt; as &lt;access-string&gt;"
	 * @param sender R object that triggered this exception (cannot be <code>null</code>!)
	 * @param access assumed type of the access that was requested. It should be a simple name of the assumed type (e.g. <tt>"vector"</tt>). The type name can be based on R semantics beyond basic types reflected by REXP classes. In cases where certain assertions were not satisfied, the string should be of the form <tt>"type (assertion)"</tt> (e.g. <tt>"data frame (must have dim>0)"</tt>). 
*/
Method %OnNew(sender, access) As %Status
{
	//pName As %String = "", pCode As %String = "", pLocation As %String = "", pData As %String = "", pInnerException As %Exception.AbstractException = {$$$NULLOREF}
	Set ..sender = sender
	Set ..access = access
	Quit ##super(,,,"attempt to access "_sender.%ClassName(1)_" as "_access,"")
}

/** retrieve the exception sender/origin
	 * @return REXP object that triggered the exception */
Method getSender() As REXP
{
	Quit ..sender
}

/** get the assumed access type that was violated by the sender.
	 * @return string describing the access type. See {@link #REXPMismatchException} for details. */
Method getAccess() As %String
{
	Quit ..access
}

}

