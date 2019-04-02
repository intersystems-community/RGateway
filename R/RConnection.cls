Class R.RConnection Extends REngine
{

/** This static variable specifies the character set used to encode string for transfer. 
Under normal circumstances there should be no reason for changing this variable. 
The default is UTF-8, which makes sure that 7-bit ASCII characters are sent in a backward-compatible fashion. 
Currently (Rserve 0.1-7) there is no further conversion on Rserve's side, i.e. the strings are passed to R without re-coding. 
If necessary the setting should be changed <u>before</u> connecting to the Rserve 
in case later Rserves will provide a possibility of setting the encoding during the handshake.
To install Rserve package: install.packages("Rserve",,"http://rforge.net")
To load Rserve library: library(Rserve)
To start Rserve: Rserve()
*/
Parameter transferCharset = "UTF-8";

/** authorization type: plain text */
Parameter ATplain = 0;

Parameter NewLine = {$CHAR(10)};

/** authorization type: unix crypt */
Parameter ATcrypt = 1;

/** last error string */
Property lastError As %String;

Property s As %IO.Socket;

Property connected As %Boolean [ InitialExpression = 0 ];

Property authReq As %Boolean [ InitialExpression = 0 ];

Property authType As %Integer [ InitialExpression = {..#ATplain} ];

Property Key As %String;

Property rt As RTalk;

Property host As %String;

Property port As %Integer;

/** version of the server (as reported in IDstring just after Rsrv) */
Property rsrvVersion As %Integer;

Method %OnNew(host As %String = "", port As %Integer = "", session As RSession = "") As %Status
{
	try {
    	if (..connected) do ..s.Close()
        set ..s = ""
    } catch (e) {
    	throw ##class(RserveException).%New($this, "Cannot close previous connection: "_e.Data, e)
    }
    
	if (session '= "") {
	    set ..host = session.host
	    set ..port = session.port
	}
    set ..connected = 0
	set ..host = $S(host="":"127.0.0.1",1:host)
	set ..port = $S(port="":6311,1:port)
    try {
    	set ss = ##class(%IO.Socket).%New()
    	do ss.Open(..host,..port,2,.tSC)
    	$$$ThrowOnError(tSC)
	    // disable Nagle's algorithm since we really want immediate replies
	    do ..initWithSocket(ss, session)
    } catch (sce) {
       	throw ##class(RserveException).%New($this, "Cannot connect: "_sce.Data, sce)
    }
    Quit $$$OK
}

Method initWithSocket(sock As %IO.Socket, session As RSession) [ Private ]
{
	set ..s = sock
    set ..rt = ##class(RTalk).%New(..s)
	if (session="") {
		set n=32
		set ids = ""
		try {
			set tTimeout = -1
			set ids = ..s.Read(.n, .tTimeout,.tSC) // Read 32 bytes
			$$$ThrowOnError(tSC) 
		} catch (sre) {
		    throw ##class(RserveException).%New($this, "Error while receiving data: "_sre.Data, sre)
		}
		try {
			if (n'=32) {
				throw ##class(RserveException).%New($this,"Handshake failed: expected 32 bytes header, got "_n)
			}
			if ($E(ids,1,4)'="Rsrv") {
				throw ##class(RserveException).%New($this, "Handshake failed: Rsrv signature expected, but received """_ids_""" instead.")
			}
			try {
				set ..rsrvVersion= $E(ids,5,8)
			} catch (px) {}
			// we support (knowingly) up to 103
			if (..rsrvVersion > 103) {
				throw ##class(RserveException).%New($this, "Handshake failed: The server uses more recent protocol than this client.")
			}
			if ($E(ids,9,12)'="QAP1") {
				throw ##class(RserveException).%New($this, "Handshake failed: unupported transfer protocol ("_$E(ids,9,12)_"), I talk only QAP1.")
			}
		} catch (innerX) {
			try { do ..s.close() } catch (ex01) {}
			set ..s=""
			throw innerX
		}
	} else { // we have a session to take care of
		try {
			do ..s.Write($E(session.key,1,32))
		} catch (sre) {
		    throw ##class(RserveException).%New($this, "Error while sending session key: "_sre.Data, sre)
		}
		set ..rsrvVersion = session.rsrvVersion
	}
	set ..connected=1
	set ..lastError="OK"
}

/** get server version as reported during the handshake.
        @return server version as integer (Rsrv0100 will return 100) */
Method getServerVersion() As %Integer
{
	return ..rsrvVersion
}

/** closes current connection */
Method close() As %Boolean
{
    try {
        if (s '= "") do ..s.Close()
        set ..connected = 0
		return 1
    } catch(e) { }
	return 0
}

/** evaluates the given command, but does not fetch the result (useful for assignment
	operations)
	@param cmd command/expression string */
Method voidEval(cmd As %String)
{
	if ('..connected || ..rt="") {
		throw ##class(RserveException).%New($this,"Not connected")
	}
	#dim rp as RPacket =..rt.requestString(##class(RTalk).#CMDvoidEval,cmd_..#NewLine)
	if (rp'="" && rp.isOk()) return
    throw ##class(RserveException).%New($this,"voidEval failed",rp)
}

/** evaluates the given command, detaches the session (see @link{detach()}) and closes connection while the command is being evaluted 
(requires Rserve 0.4+).
		Note that a session cannot be attached again until the commad was successfully processed. 
		Techincally the session is put into listening mode while the command is being evaluated 
		but accept is called only after the command was evaluated. One commonly used techique to monitor detached working sessions 
		is to use second connection to poll the status (e.g. create a temporary file and return the full path 
		before detaching thus allowing new connections to read it).
		@param cmd command/expression string
		@return session object that can be use to attach back to the session once the command completed */
Method voidEvalDetach(cmd As %String) As RSession
{
	if ('connected || rt="") {
		throw ##class(RserveException).%New($this,"Not connected")
	}
	#dim rp as RPacket = ..rt.requestString(##class(RTalk).#CMDdetachedVoidEval,cmd_..#NewLine)
	if (rp="" || 'rp.isOk()) {
		throw ##class(RserveException).%New($this,"detached void eval failed",rp)
	}
	set s = ##class(RSession).%New($this, rp)
	do ..close()
	return s
}

Method parseEvalResponse(rp As RPacket) As REXP
{
	set rxo=0
	set pc=rp.getCont()
	//w "Response stream:"
	//zzdump pc.Read() w !
	do pc.Rewind()
	set pc0 = $SC(pc.Read(1),"S1")
	if (..rsrvVersion>100) { /* since 0101 eval responds correctly by using DT_SEXP type/len header which is 4 bytes long */
		set rxo=4
		do pc.Read(3) // skip 3 bytes
		/* we should check parameter type (should be DT_SEXP) and fail if it's not */
		set lg = $ZB(##class(RTalk).#DTSEXP,##class(RTalk).#DTLARGE,7)
		if (pc0'=##class(RTalk).#DTSEXP) && (pc0'=lg) {
			throw ##class(RserveException).%New(##this,"Error while processing eval output: SEXP (type "_##class(RTalk).#DTSEXP_") expected but found result type "_pc0_".")
		}
		if (pc0=lg) {
			set rxo=8 // large data need skip of 8 bytes
			do pc.Read(4) // Skip 4 more bytes
		}
		/* warning: we are not checking or using the length - we assume that only the one SEXP is returned. 
		This is true for the current CMD_eval implementation, but may not be in the future. */
	}
	if (pc.SizeGet()>rxo) {
		try {
			set rx=##class(REXPFactory).%New()
			do rx.parseREXP(pc)
			return rx.getREXP()
		} catch (me) {
			//me.printStackTrace();
			throw ##class(RserveException).%New($this, "Error when parsing response: "_me.Data, me)
		}
	}
	return ""
}

/** evaluates the given command and retrieves the result
	@param cmd command/expression string
	@return R-xpression or <code>null</code> if an error occured */
Method evalCommand(cmd As %String) As REXP [ Private ]
{
	if ('..connected || ..rt="") {
        throw ##class(RserveException).%New($this,"Not connected")
	}
	#dim rp as RPacket = ..rt.requestString(##class(RTalk).#CMDeval,cmd_..#NewLine)
	if (rp'="" && rp.isOk()) {
		return ..parseEvalResponse(rp)
	}
    throw ##class(RserveException).%New($this,"eval failed",rp)
}

/** assign a string value to a symbol in R. The symbol is created if it doesn't exist already.
        @param sym symbol name. Currently assign uses CMD_setSEXP command of Rserve, i.e. the symbol value is NOT parsed. 
        It is the responsibility of the user to make sure that the symbol name is valid in R 
        (recall the difference between a symbol and an expression!). In fact R will always create the symbol, 
        but it may not be accessible (examples: "bar\nfoo" or "bar$foo").
        @param ct contents
        */
Method assignString(sym As %String, ct As %String)
{
	if ('..connected || ..rt="") {
        throw ##class(RserveException).%New(##this,"Not connected")
	}
    set sl=$L(sym)+1
    set cl=$L(ct)+1
    if ((sl#4)'=0) set sl=sl-(sl#4)+4 // make sure the symbol length is divisible by 4
    if ((cl#4)'=0) set cl=cl-(cl#4)+4 // make sure the content length is divisible by 4
    set rq=##class(%Stream.GlobalBinary).%New()
	do ##class(RTalk).setHdr(##class(RTalk).#DTSTRING,sl,rq) // 4-byte hdr
	do ##class(RTalk).setString(sym,rq)
	do ##class(RTalk).setHdr(##class(RTalk).#DTSTRING,cl,rq) // 4-byte hdr
	do ##class(RTalk).setString(ct,rq)
	#dim rp as RPacket = ..rt.request(##class(RTalk).#CMDsetSEXP,rq)
    if (rp'="" && rp.isOk()) return
    throw ##class(RserveException).%New($this,"assign failed",rp)
}

/** assign a content of a REXP to a symbol in R. The symbol is created if it doesn't exist already.
     * @param sym symbol name. Currently assign uses CMD_setSEXP command of Rserve, i.e. the symbol value is NOT parsed. 
     It is the responsibility of the user to make sure that the symbol name is valid in R 
     (recall the difference between a symbol and an expression!). In fact R will always create the symbol, 
     but it may not be accessible (examples: "bar\nfoo" or "bar$foo").
	 * @param rexp contents
	 */
Method assign(sym As %String, value As REXP, env As REXP = "")
{
	if (env'="") throw ##class(REngineException).%New($this, "Rserve doesn't support environments other than .GlobalEnv")
	
	if ('..connected || ..rt="") {
	    throw ##class(RserveException).%New($this,"Not connected")
	}
	try {
		set r = ##class(REXPFactory).%New(value)
		set rl=r.getBinaryLength()
		set sl=$L(sym)+1
		if ((sl#4)'=0) set sl=sl-(sl#4)+4 // make sure the symbol length is divisible by 4
		set rq=##class(%Stream.GlobalBinary).%New() // new byte[sl+rl+((rl>0xfffff0)?12:8)];
		//for(ic=0;ic<symn.length;ic++) rq[ic+4]=symn[ic];
		//while(ic<sl) { rq[ic+4]=0; ic++; }; // pad with 0
		do ##class(RTalk).setHdr(##class(RTalk).#DTSTRING,sl,rq)
		do ##class(RTalk).setString(sym,rq)
		do ##class(RTalk).setHdr(##class(RTalk).#DTSEXP,rl,rq)
		do r.getBinaryRepresentation(rq)
		#dim rp as RPacket = ..rt.request(##class(RTalk).#CMDsetSEXP,rq)
		if (rp'="" && rp.isOk()) return
		throw ##class(RserveException).%New($this,"assign failed",rp)
	} catch (me) {
	    throw ##class(RserveException).%New($this, "Error creating binary representation: "_me.Data, me)
	}
}

/** shutdown remote Rserve. Note that some Rserves cannot be shut down from the client side. */
Method shutdown()
{
	if ('..connected || ..rt="") {
		throw ##class(RserveException).%New($this,"Not connected")
	}

	#dim rp as RPacket = ..rt.requestCommand(##class(RTalk).#CMDshutdown)
	if (rp'="" && rp.isOk()) return
    throw ##class(RserveException).%New($this,"shutdown failed",rp)
}

/** Sets send buffer size of the Rserve (in bytes) for the current connection. All responses send by Rserve are stored 
in the send buffer before transmitting. This means that any objects you want to get from the Rserve need to fit into that buffer. 
By default the size of the send buffer is 2MB. If you need to receive larger objects from Rserve, 
you will need to use this function to enlarge the buffer. In order to save memory, you can also reduce the buffer size 
once it's not used anymore. Currently the buffer size is only limited by the memory available and/or 1GB (whichever is smaller). 
Current Rserve implementations won't go below buffer sizes of 32kb though. If the specified buffer size results in 'out of memory' on the server, 
the corresponding error is sent and the connection is terminated.<br>
        <i>Note:</i> This command may go away in future versions of Rserve which will use dynamic send buffer allocation.
        @param sbs send buffer size (in bytes) min=32k, max=1GB
     */
Method setSendBufferSize(sbs As %Integer)
{
    if ('..connected || ..rt="") {
		throw ##class(RserveException).%New($this,"Not connected")
    }

    #dim rp as RPacket = ..rt.requestInteger(##class(RTalk).#CMDsetBufferSize,sbs)
    if (rp'="" && rp.isOk()) return
    throw ##class(RserveException).%New($this,"setSendBufferSize failed",rp)
}

/** set string encoding for this session. It is strongly
     * recommended to make sure the encoding is always set to UTF-8
     * because that is the only encoding supported by this Java
     * client. It can be done either by uisng the
     * <code>encoding</code> option in the server or by calling
     * setStringEncoding("utf8") at the beginning of a session (but
     * after login).
     @param enc name of the encoding as defined by Rserve - as of
     Rserve version 0.5-3 valid values are "utf8", "latin1" and
     "native" (case-sensitive)
     @since Rserve 0.5-3
    */
Method setStringEncoding(enc As %String)
{
    if ('..connected || ..rt="") {
		throw ##class(RserveException).%New($this,"Not connected")
    }
	#dim rp as RPacket = ..rt.requestString(##class(RTalk).#CMDsetEncoding, enc)
	if (rp '= "" && rp.isOk()) return
	throw ##class(RserveException).%New($this,"setStringEncoding failed", rp)
}

/** detaches the session and closes the connection (requires Rserve 0.4+). The session can be only resumed by calling @link{RSession.attach} */
Method detach() As RSession
{
	if ('..connected || ..rt="") {
        throw ##class(RserveException).%New($this,"Not connected")
	}
	#dim rp as RPacket = ..rt.requestCommand(##class(RTalk).#CMDdetachSession)
	if (rp="" || 'rp.isOk())
		throw ##class(RserveException).%New($this,"Cannot detach",rp)
	set s = ##class(RSession).%New($this, rp)
	do ..close()
	return s
}

/** check connection state. Note that currently this state is not checked on-the-spot,
	that is if connection went down by an outside event this is not reflected by
	the flag
	@return <code>true</code> if this connection is alive */
Method isConnected() As %Boolean
{
 return ..connected
}

/** check authentication requirement sent by server
	@return <code>true</code> is server requires authentication. In such case first
	command after connecting must be {@link #login}. */
Method needLogin() As %Boolean
{
 return ..authReq
}

/** get last error string
	@return last error string */
Method getLastError() As %String
{
 return ..lastError
}

/** evaluates the given command in the master server process asynchronously (control command). 
Note that control commands are always asynchronous, i.e., the expression is enqueued for evaluation 
in the master process and the method returns before the expression is evaluated 
(in non-parallel builds the client has to close the connection before the expression can be evaluated). 
There is no way to check for errors and control commands should be sent with utmost care as they can abort the server process. 
The evaluation has no immediate effect on the client session.
     *  @param cmd command/expression string 
     *  @since Rserve 0.6-0 */
Method serverEval(cmd As %String)
{
	if ('..connected || ..rt = "") {
	    throw ##class(RserveException).%New($this, "Not connected")
	}
	#dim rp as RPacket  = ..rt.requestString(##class(RTalk).#CMDctrlEval, cmd_..#NewLine)
	if (rp '= "" && rp.isOk()) return
	throw ##class(RserveException).%New($this,"serverEval failed",rp)
}

/** sources the given file (the path must be local to the server!) in the master server process asynchronously (control command). 
See {@link #serverEval()} for details on control commands.
     *  @param serverFile path to a file on the server (it is recommended to always use full paths, 
     because the server process has a different working directory than the client child process!).
     *  @since Rserve 0.6-0 */
Method serverSource(serverFile As %String)
{
	if ('..connected || ..rt = "") {
	    throw ##class(RserveException).%New($this, "Not connected")
	}
	#dim rp as RPacket  = ..rt.requestString(##class(RTalk).#CMDctrlSource, serverFile)
	if (rp '= "" && rp.isOk()) return
	throw ##class(RserveException).%New($this,"serverSource failed",rp)
}

/** attempt to shut down the server process cleanly. Note that there is a fundamental difference between the {@link shutdown()} method 
and this method: <code>serverShutdown()</code> is a proper control command and thus fully authentication controllable, 
whereas {@link shutdown()} is a client-side command sent to the client child process and thus relying on 
the ability of the client to signal the server process which may be disabled. Therefore <code>serverShutdown()</code> is 
preferred and more reliable for Rserve 0.6-0 and higher.
     *  @since Rserve 0.6-0 */
Method serverShutdown()
{
	if ('..connected || ..rt = "") {
	    throw ##class(RserveException).%New($this, "Not connected")
	}
	#dim rp as RPacket = ..rt.requestCommand(##class(RTalk).#CMDctrlShutdown)
	if (rp '= "" && rp.isOk()) return
	throw ##class(RserveException).%New($this,"serverShutdown failed",rp)
}

// ========= REngine interface API

Method parse(text As %String, resolve As %Boolean) As REXP
{
	throw ##class(REngineException).%New($this, "Rserve doesn't support separate parsing step.")
}

Method eval(what As REXP, where As REXP = "", resolve As %Boolean = 1) As REXP
{
	// what is a cmd string
	if '$IsObject(what) return ..evalCommand(what)
	
	if ('..connected || ..rt="") {
		throw ##class(RserveException).%New($this, "Not connected")
	}
	if (where '= "") {
		throw ##class(REngineException).%New($this, "Rserve doesn't support environments other than .GlobalEnv")
	}
	try {
		set r = ##class(REXPFactory).%New(what)
		set rl = r.getBinaryLength()
		set rq = ##class(%Stream.GlobalBinary).%New()
		do ##class(RTalk).setHdr(##class(RTalk).#DTSEXP, rl, rq)
		do r.getBinaryRepresentation(rq)
		#dim rp as RPacket = ..rt.request($S(resolve : ##class(RTalk).#CMDeval, 1 : ##class(RTalk).#CMDvoidEval), rq)
		if (rp '= "" && rp.isOk()) {
			return ..parseEvalResponse(rp)
		}
		throw ##class(RserveException).%New($this,"eval failed", rp)
	} catch (me) {
		throw ##class(RserveException).%New($this, "Error creating binary representation: "_me.Data, me)
	}
}

Method parseAndEval(text As %String, where As REXP = "", resolve As %Boolean = 1) As REXP
{
	if (where'="") throw ##class(REngineException).%New($this, "Rserve doesn't support environments other than .GlobalEnv")
	try {
		return ..evalCommand(text)
	} catch (re) {
	    throw ##class(REngineException).%New($this, re.Data, re)
	}
}

/** assign into an environment
@param symbol symbol name
@param value value to assign
@param env environment to assign to
Method assign(symbol As %String, value As REXP, env As REXP)
{
	if (env'="") throw ##class(REngineException).%New($this, "Rserve doesn't support environments other than .GlobalEnv")
	try {
		do ..assign(symbol, value)
	} catch (re) {
	    throw ##class(REngineException).%New($this, re.Data, re)
	}
}
*/

/** get a value from an environment
@param symbol symbol name
@param env environment
@param resolve resolve the resulting REXP or just return a reference		
@return value */
Method get(symbol As %String, env As REXP = "", resolve As %Boolean = 1) As REXP
{
	if ('resolve) throw ##class(REngineException).%New($this, "Rserve doesn't support references")
	try {
		return ..eval(##class(REXPSymbol).%New(symbol), env, 1)
	} catch (re) {
		throw ##class(REngineException).%New($this, re.Data)
	}
}

/** fetch the contents of the given reference. The resulting REXP may never be REXPReference.
@param ref reference to resolve
@return resolved reference */
Method resolveReference(ref As REXP) As REXP
{
	throw ##class(REngineException).%New($this, "Rserve doesn't support references")
}

Method createReference(ref As REXP) As REXP
{
	throw ##class(REngineException).%New($this, "Rserve doesn't support references")
}

Method finalizeReference(ref As REXP)
{
	throw ##class(REngineException).%New($this, "Rserve doesn't support references")
}

Method getParentEnvironment(env As REXP, resolve As %Boolean) As REXP
{
	throw ##class(REngineException).%New($this, "Rserve doesn't support environments other than .GlobalEnv")
}

Method newEnvironment(parent As REXP, resolve As %Boolean) As REXP
{
	throw ##class(REngineException).%New($this, "Rserve doesn't support environments other than .GlobalEnv")
}

}

