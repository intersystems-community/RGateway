Class R.RPacket Extends %RegisteredObject
{

Property cmd As %Integer;

Property cont As %Stream.GlobalBinary;

/** construct new packet
	@param Rcmd command
	@param Rcont content */
Method %OnNew(Rcmd As %Integer, Rcont As %Stream.GlobalBinary) As %Status
{
	Set ..cmd=Rcmd
	Set ..cont=Rcont
	Do ..cont.Rewind()
	Quit $$$OK
}

/** get command
        @return command */
Method getCmd() As %Integer
{
	Quit ..cmd
}

/** check last response for RESP_OK
	@return <code>true</code> if last response was OK */
Method isOk() As %Boolean
{
	Quit ($ZB(..cmd,15,1)=1)
}

/** check last response for RESP_ERR
	@return <code>true</code> if last response was ERROR */
Method isError() As %Boolean
{
	Quit ($ZB(..cmd,15,1)=2)
}

/** get status code of last response
	@return status code returned on last response */
Method getStat() As %Integer
{
	Quit $ZB(..cmd\16777216,127,1)
}

/** get content
	@return inner package content */
Method getCont() As %Stream.GlobalBinary
{
	Quit ..cont
}

Method toString() As %String
{
	Quit "RPacket[cmd="_..cmd_",len="_..cont.SizeGet()
}

}

