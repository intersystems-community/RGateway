Class R.REXPUnknown Extends REXP
{

/** type of the unterlying obejct */
Property type As %Integer;

Method %OnNew(type, attr = "") As %Status
{
	Set ..type = type
	Quit ##super(attr)
}

/** returns the internal R type of this unknown obejct
	 *  @return type code */
Method getType() As %Integer
{
 	Quit ..type
}

Method toString() As %String
{
	Quit ##super()_"[type:"_..type_"]"
}

}

