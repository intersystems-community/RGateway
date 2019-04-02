Class R.RserveException Extends REngineException
{

Property err As %String;

Property reqReturnCode As %Integer;

/// c:RConnection
/// msg:String
/// t:Throwable, int (code), RPacket
Method %OnNew(c, msg, t = "") As %Status
{
	set cause = ""
	if (t="") {
		 set ..reqReturnCode = -1
	}
	elseif $IsObject(t) {
		if t.%IsA("R.RPacket") {
			set code = t.getStat()
		}
		else { // cause
			set ..reqReturnCode = -1
			set cause = t
		} 
	}
	else { // code
		set ..reqReturnCode = t
	}
	set:c'="" c.lastError = $S(..reqReturnCode'=-1:..getRequestErrorMessage(..reqReturnCode),1:"")
	Quit ##super(c,msg,cause)
}

ClassMethod getRequestErrorMessage(code As %String) As %String
{
	Set desc = $Case(code,
        0:  "no error",
        2:  "R parser: input incomplete",
        3:  "R parser: syntax error",
        ##class(RTalk).#ERRauthfailed:  "authorization failed",
        ##class(RTalk).#ERRconnbroken:  "connection broken",
        ##class(RTalk).#ERRinvcmd:  "invalid command",
        ##class(RTalk).#ERRinvpar:  "invalid parameter",
        ##class(RTalk).#ERRIOerror:  "I/O error on the server",
        ##class(RTalk).#ERRnotopen:  "connection is not open",
        ##class(RTalk).#ERRaccessdenied:  "access denied (local to the server)",
        ##class(RTalk).#ERRunsupportedcmd:  "unsupported command",
        ##class(RTalk).#ERRunknowncmd:  "unknown command",
        ##class(RTalk).#ERRdataoverflow:  "data overflow, incoming data too big",
        ##class(RTalk).#ERRobjecttoobig:  "evaluation successful, but returned object is too big to transport",
        ##class(RTalk).#ERRoutofmem:  "FATAL: Rserve ran out of memory, closing connection",
		##class(RTalk).#ERRsessionbusy:  "session is busy",
		##class(RTalk).#ERRdetachfailed:  "session detach failed",
		##class(RTalk).#ERRctrlclosed:  "control pipe to master process is closed/broken",
		:"error code: "_code)
		
		Quit desc
}

Method getRequestErrorDescription() As %String
{
	Quit ..getRequestErrorMessage(..reqReturnCode)
}

Method getMessage() As %String
{
	Quit ..getRequestErrorDescription()
}

Method getRequestReturnCode() As %Integer
{
    return ..reqReturnCode
}

}

