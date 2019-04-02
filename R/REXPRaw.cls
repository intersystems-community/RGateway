Class R.REXPRaw Extends REXP
{

Property payload As %Stream.GlobalBinary;

Method %OnNew(load, attr = "") As %Status
{
	Set:load'="" ..payload = load
	Do ..payload.Rewind()
	Quit ##super(attr)
}

Method length() As %Integer
{
 	Quit ..payload.SizeGet()
}

Method isRaw() As %Boolean
{
 	Quit 1
}

Method asBytes() As %Stream.GlobalBinary
{
 	Quit ..payload
}

Method asNativeObject() As %RegisteredObject
{
	Quit ..payload
}

Method toString() As %String
{
	set sb = ##super()_"["_..length()_"]"
	set sb = sb_"["_..binaryToHEX()_"]"
	quit sb
}

Method toJSON() As %ZEN.proxyObject
{
	Set d = ##class(%ZEN.proxyObject).%New()
	Set len = ..payload.SizeGet()
	Set d.length = len
	Set d.payload = ..binaryToHEX()
	Quit d
}

Method binaryToHEX() As %String
{
	Do ..payload.Rewind()
	set len = ..payload.SizeGet()
	set sb = ""
	for i=1:1:len {
		set hex = $ZHEX($SC(..payload.Read(1),"S1"))
		set:$L(hex)=1 hex = hex_"0" // set higher 4 bits to 0
		set sb = sb_hex
	}
	Do ..payload.Rewind()
	quit sb
}

}

