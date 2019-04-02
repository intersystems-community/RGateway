Class R.RSession Extends %SerialObject
{

Parameter serialVersionUID = -7048099825974875604;

Property host As %String;

Property port As %Integer;

Property key As %String;

Property attachPacket As RPacket [ Transient ];

/// response on session attach
Property rsrvVersion As %Integer;

Method %OnNew(c As RConnection, p As RPacket) As %Status
{
	set ..host=c.host
	set ..rsrvVersion=c.rsrvVersion
	set ct = p.getCont()
	if (ct="" || ct.SizeGet()'=(32+3*4))
	    throw ##class(RserveException).%New(c, "Invalid response to session detach request.")
	set ..port = ##class(RTalk).getInt(ct, 4)
	set ..key=""
	do ct.Read(8) // skip 8 bytes
	set ..key = ct.Read(32)
}

/** attach/resume this session */
Method attach() As RConnection
{
	set c = ##class(RConnection).%New($this)
	set ..attachPacket = c.rt.request(-1)
	return c
}

Storage Default
{
<Data name="RSessionState">
<Value name="1">
<Value>host</Value>
</Value>
<Value name="2">
<Value>port</Value>
</Value>
<Value name="3">
<Value>key</Value>
</Value>
<Value name="4">
<Value>rsrvVersion</Value>
</Value>
</Data>
<State>RSessionState</State>
<StreamLocation>^R.RSessionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

