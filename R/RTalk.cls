Class R.RTalk Extends %RegisteredObject
{

Parameter DTINT As %Integer = 1;

Parameter DTCHAR As %Integer = 2;

Parameter DTDOUBLE As %Integer = 3;

Parameter DTSTRING As %Integer = 4;

Parameter DTBYTESTREAM As %Integer = 5;

Parameter DTSEXP As %Integer = 10;

Parameter DTARRAY As %Integer = 11;

/** this is a flag saying that the contents is large (>fffff0) and hence uses 56-bit length field */
Parameter DTLARGE As %Integer = 64;

Parameter CMDlogin As %Integer = {$ZH("001")};

Parameter CMDvoidEval As %Integer = {$ZH("002")};

Parameter CMDeval As %Integer = {$ZH("003")};

Parameter CMDshutdown As %Integer = {$ZH("004")};

Parameter CMDopenFile As %Integer = {$ZH("010")};

Parameter CMDcreateFile As %Integer = {$ZH("011")};

Parameter CMDcloseFile As %Integer = {$ZH("012")};

Parameter CMDreadFile As %Integer = {$ZH("013")};

Parameter CMDwriteFile As %Integer = {$ZH("014")};

Parameter CMDremoveFile As %Integer = {$ZH("015")};

Parameter CMDsetSEXP As %Integer = {$ZH("020")};

Parameter CMDassignSEXP As %Integer = {$ZH("021")};

Parameter CMDsetBufferSize As %Integer = {$ZH("081")};

Parameter CMDsetEncoding As %Integer = {$ZH("082")};

Parameter CMDdetachSession As %Integer = {$ZH("030")};

Parameter CMDdetachedVoidEval As %Integer = {$ZH("031")};

Parameter CMDattachSession As %Integer = {$ZH("032")};

// control commands since 0.6-0

Parameter CMDctrlEval As %Integer = {$ZH("42")};

Parameter CMDctrlSource As %Integer = {$ZH("45")};

Parameter CMDctrlShutdown As %Integer = {$ZH("44")};

// errors as returned by Rserve

Parameter ERRauthfailed As %Integer = {$ZH("41")};

Parameter ERRconnbroken As %Integer = {$ZH("42")};

Parameter ERRinvcmd As %Integer = {$ZH("43")};

Parameter ERRinvpar As %Integer = {$ZH("44")};

Parameter ERRRerror As %Integer = {$ZH("45")};

Parameter ERRIOerror As %Integer = {$ZH("46")};

Parameter ERRnotopen As %Integer = {$ZH("47")};

Parameter ERRaccessdenied As %Integer = {$ZH("48")};

Parameter ERRunsupportedcmd As %Integer = {$ZH("49")};

Parameter ERRunknowncmd As %Integer = {$ZH("4a")};

Parameter ERRdataoverflow As %Integer = {$ZH("4b")};

Parameter ERRobjecttoobig As %Integer = {$ZH("4c")};

Parameter ERRoutofmem As %Integer = {$ZH("4d")};

Parameter ERRctrlclosed As %Integer = {$ZH("4e")};

Parameter ERRsessionbusy As %Integer = {$ZH("50")};

Parameter ERRdetachfailed As %Integer = {$ZH("51")};

Parameter LONGLEN = {$ZH("fffff0")};

Property s As %IO.Socket;

Method %OnNew(s As %IO.Socket) As %Status
{
	Set ..s = s
	Quit $$$OK
}

/** writes bit-wise int to a byte buffer at specified position in Intel-endian form
	@param v value to be written
	@param buf buffer
	@param o offset in the buffer to start at. An int takes always 4 bytes */
/// buf needs to done wrtiing before reading
/// After reading, buf writing will erase old content
ClassMethod setInt(v As %Integer, buf As %Stream.GlobalBinary)
{
	If (v="NA") || (v="NAN") {
		Do buf.Write($NC(##class(REXPInteger).#NA,"S4"))
	}
	Else {
		Do buf.Write($NC(v,"S4"))
	}
}

/** writes cmd/resp/type byte + 3/7 bytes len into a byte buffer at specified offset.
	@param ty type/cmd/resp byte
	@param len length
	@param buf buffer
	@param o offset
        @return offset in buf just after the header. Please note that since Rserve 0.3 the header can be either 4 or 8 bytes long, depending on the len parameter.
        */
/// Write 4 bytes (1 byte ty + 3 bytes length) or 8 bytes (1 byte ty + 4 bytes length + 3 bytes 0)        
ClassMethod setHdr(ty As %Integer, len As %Integer, buf As %Stream.GlobalBinary)
{
	Set i = $ZB(ty,255,1)
	Set j = $S(len>..#LONGLEN:..#DTLARGE,1:0)
	set t = $NC($ZB(i,j,7),"S4") // 4 bytes
	Do buf.Write($E(t,1)) // 1 byte (take the first byte of the integer)
	Set k = $NC(len,"S4")
	If len>..#LONGLEN {
		Do buf.Write(k) // 4 bytes
		Do buf.Write($CHAR(0,0,0)) // 3 zero bytes
	}
	Else {
		Do buf.Write($E(k,1,3)) // Only use the first 3 bytes
	}
}

/** creates a new header according to the type and length of the parameter
        @param ty type/cmd/resp byte
        @param len length */
ClassMethod newHdr(ty As %Integer, len As %Integer)
{
	Set hdr = ##class(%Stream.GlobalBinary).%New()
	Do ..setHdr(ty,len,hdr)
	Quit hdr
}

/** converts bit-wise stored int in Intel-endian form into Java int
	@param buf buffer containg the representation
	@param o offset where to start (4 bytes will be used)
	@return the int value. no bounds checking is done so you need to
	        make sure that the buffer is big enough */
ClassMethod getInt(buf As %Stream.GlobalBinary) As %Integer
{
	Quit $SC(buf.Read(4),"S4")
}

/** converts bit-wise stored length from a header. "long" format is supported up to 32-bit
	@param buf buffer
	@param o offset of the header (length is at o+1)
	@return length */
/// Read 4 bytes or 8 bytes (long length)	
/// Returning ty is the first byte
ClassMethod getLen(buf As %Stream.GlobalBinary, ByRef ty As %Integer) As %Integer
{
	Set ty = $SC(buf.Read(1)_$CHAR(0,0,0),"S4") // get as a 4-byte integer, otherwise it could be negative
	Set i = $ZB(ty,64,1)
	Set j= 0
	If i>0 { // "long" format; still - we support 32-bit only
		Set j = $SC(buf.Read(4),"S4") // Read 4 bytes
		Do buf.Read(3) // 3 bytes padding
	}
	Else {
		set x = buf.Read(3)
		set x = x_$CHAR(0) // pad the highest byte
		Set j = $SC(x,"S4") // Read 3 bytes
	}
	Quit j
}

/** converts bit-wise Intel-endian format into long
	@param buf buffer
	@param o offset (8 bytes will be used)
	@return long value */
ClassMethod getLong(buf As %Stream.GlobalBinary) As %Integer
{
	Quit $SC(buf.Read(8),"S8")
}

ClassMethod setLong(l As %Integer, buf As %Stream.GlobalBinary)
{
	Do buf.Write($NC(l,"S8"))
}

ClassMethod getBytes(n As %Integer, buf As %Stream.GlobalBinary) As %Stream.GlobalBinary
{
	set b = ##class(%Stream.GlobalBinary).%New()
	for i=1:1:n {
		do b.Write(buf.Read(1))
	}
	quit b
}

ClassMethod setBytes(ba As %Stream.GlobalBinary, buf As %Stream.GlobalBinary)
{
	set io = ba.SizeGet()
	do ..setInt(io, buf)
	for i=1:1:io {
		do buf.Write(ba.Read(1))
	}
	while (io#4)'=0 {
		do buf.Write($CHAR(0))
		set io=$I(io)
	}
}

ClassMethod getInts(n As %Integer, buf As %Stream.GlobalBinary) As %ListOfDataTypes
{
	Set ds = ##class(%ListOfDataTypes).%New()
	For i=1:1:n {
		Do ds.Insert(..getInt(buf))
	}
	Quit ds
}

ClassMethod setInts(ia As %ListOfDataTypes, buf As %Stream.GlobalBinary)
{
	For i=1:1:ia.Count() {
		Do ..setInt(ia.GetAt(i),buf)
	}
}

ClassMethod getDouble(buf As %Stream.GlobalBinary) As %Double
{
	Quit $SC(buf.Read(8),"F8")
}

ClassMethod setDouble(d As %Double, buf As %Stream.GlobalBinary)
{
	If (d="NAN") || (d="NA") {
		Do buf.Write(##class(REXPDouble).#NA)
	}
	Else {
		Do buf.Write($NC(d,"F8"))
	}
}

ClassMethod setDoubles(d As %ListOfDataTypes, buf As %Stream.GlobalBinary)
{
	for i=1:1:d.Count() {
		do ..setDouble(d.GetAt(i), buf)
	}
}

ClassMethod getDoubles(n As %Integer, buf As %Stream.GlobalBinary) As %ListOfDataTypes
{
	Set ds = ##class(%ListOfDataTypes).%New()
	For i=1:1:n {
		Do ds.Insert(..getDouble(buf))
	}
	Quit ds
}

ClassMethod getLogical(buf As %Stream.GlobalBinary) As %Integer
{
	Set i = $SC(buf.Read(1), "S1")
	If ((i'=0) && (i'=1)) Set i = ##class(REXPLogical).#NA
	Quit i
}

ClassMethod setLogical(i As %Integer, buf As %Stream.GlobalBinary)
{
	if (i="NA") || (i="NAN") || (i=##class(REXPLogical).#NA) {
		do buf.Write($CHAR(2))
	}
	elseif (i=0) {
		do buf.Write($CHAR(0))
	}
	else {
		do buf.Write($CHAR(1))
	}
}

ClassMethod getLogicals(n As %Integer, buf As %Stream.GlobalBinary) As %ListOfDataTypes
{
	Set ds = ##class(%ListOfDataTypes).%New()
	For i=1:1:n {
		Do ds.Insert(..getLogical(buf))
	}
	Quit ds
}

ClassMethod setLogicals(ba As %ListOfDataTypes, buf As %Stream.GlobalBinary)
{
	set io = ba.Count()
	do ..setInt(io, buf)
	for i=1:1:io {
		do ..setLogical(ba.GetAt(i), buf)
	}
	while ((io#4) '= 0) {
		do buf.Write($CHAR(3))
		set io=$I(io)
	}
}

ClassMethod getString(buf As %Stream.GlobalBinary, ByRef c As %Integer) As %String
{
	set c = 0
	set s = ""
	// Read until reach 0
	for {
		quit:buf.AtEnd
		set a = buf.Read(1)
		set c=$I(c)
		quit:$SC(a,"S1")=0
		set $E(s,*+1)=a	
	}
	quit s
}

/// eox: # of bytes to read
/// o : # of bytes actually read
ClassMethod getStrings(buf As %Stream.GlobalBinary, eox As %Integer, ByRef o As %Integer) As %ListOfDataTypes
{
	// 0 is the terminator of a string
	// number of 0's is number of strings
	set ss = ##class(%ListOfDataTypes).%New()
	set o=0, s=""
	while '(buf.AtEnd) && (o<eox) {
		set a = buf.Read(1)
		set o=$I(o)
		if $SC(a,"S1")=0 {  // reach the end of a string
			if ($E(s,1)=##class(REXP).#NAString) && ($L(s)>1) { // leading character
				set s = $E(s,2,*) // remove the leading -1
			}
			do ss.Insert(s)
			set s = ""
		}
		else { 
			set $E(s,*+1)=a // append the byte
		}
	}
	quit ss
}

ClassMethod setString(s As %String, buf As %Stream.GlobalBinary)
{
	do:s'="" buf.Write(s) // s="" does nothing
	do buf.Write($CHAR(0))
	set io = $L(s)+1
	while (io#4)'=0 {
		do buf.Write($CHAR(0)) // padding if necessary..
		set io=$I(io)
	}
}

ClassMethod setStrings(sa As %ListOfDataTypes, buf As %Stream.GlobalBinary)
{
	set i = 1, io = 0
	while (i <= sa.Count()) {
		set s = sa.GetAt(i)
		if (s '= "") {
			if ($L(s)>1) && ($E(s,1)=##class(REXP).#NAString) { /* if the first entry happens to be -1 then we need to double it so it doesn't get confused with NAs */
				do buf.Write(##class(REXP).#NAString)
				set io=$I(io)
			}
			do buf.Write(s)
			set io=io+$L(s)
		}
		do buf.Write($CHAR(0)) // sperator
		set io=$I(io)
		set i=$I(i)
	}
	while ((io#4) '= 0) { // padding if necessary..
		do buf.Write($CHAR(1))
		set io=$I(io)
	}
}

/** sends a request with attached parameters
        @param cmd command
        @param cont contents - parameters
        @return returned packet or <code>null</code> if something went wrong */
Method request(cmd As %Integer, cont As %Stream.GlobalBinary) As RPacket
{
	If cont'="" {
		Do cont.Rewind()
		Set contlen = cont.SizeGet()
	}
	Else {
		Set contlen = 0
	}
	
	Set hdr = ##class(%Stream.GlobalBinary).%New()
	Do ..setInt(cmd,hdr) // Wtire 4 bytes
	Do ..setInt(contlen,hdr) // Write 4 bytes
	Do hdr.Write($NC(0,"S8")) // Write 8 bytes paddings
	
	try {
		Do hdr.Rewind()
		If cmd'=-1 {
			Set len = 16
			Set hdrcont = hdr.Read(.len,.tSC)
			$$$ThrowOnError(tSC)
			Do ..s.Write(hdrcont,0,.tSC)
			$$$ThrowOnError(tSC)
			//w !, "Request stream:", !
			//zzdump hdrcont
		}
		
		If (contlen>0) {
			//zzdump cont.Read()
			//do cont.Rewind()
			// Write 30000 bytes a time
			Set rem = contlen
			Do {
				If rem<30000 {
					Set len = rem
					Set rem = 0
				}
				Else {
					Set len = 30000
					Set rem = rem - 30000
				}
				Set chuck = cont.Read(.len,.tSC)
				$$$ThrowOnError(tSC)
				Do ..s.Write(chuck,0,.tSC)
				$$$ThrowOnError(tSC)
			} While (rem>0)
		}
		Do ..s.Flush(.tSC)
		$$$ThrowOnError(tSC)
		
		// Read 16 bytes
		Set tTimeout = -1
		Set rpy = ..s.Read(16,.tTimeout,.tSC)
		$$$ThrowOnError(tSC)
		Set ih = ##class(%Stream.GlobalBinary).%New()
		Do ih.Write(rpy)
		Do ih.Rewind()
		Set rep = ..getInt(ih)
		Set rl = ..getInt(ih)
		If rl>0 {
			Set ct = ##class(%Stream.GlobalBinary).%New()
			// Read 30000 bytes a time
			Set rem = rl
			Do {
				Set tTimeout = -1
				If rem<30000 {
					Set len = rem
					Set rem = 0
				}
				Else {
					Set len = 30000
					Set rem = rem - 30000
				}
				Set chuck = ..s.Read(len,.tTimeout,.tSC)
				$$$ThrowOnError(tSC)
				Do ct.Write(chuck)
			} While (rem >0)
			Do ct.Rewind()
			Return ##class(RPacket).%New(rep,ct)
		}
		Return ##class(RPacket).%New(rep,"")
	}
	catch (e) {
		W e.Data, !
		Return ""
	}
	Return ""
}

/** sends a request with no attached parameters
	@param cmd command
	@return returned packet or <code>null</code> if something went wrong */
Method requestCommand(cmd As %Integer) As RPacket
{
	Set d = ##class(%Stream.GlobalBinary).%New()
	Quit ..request(cmd,d)
}

/** sends a request with one string parameter attached
	@param cmd command
	@param par parameter - length and DT_STRING will be prepended
	@return returned packet or <code>null</code> if something went wrong */
Method requestString(cmd As %Integer, par As %String) As RPacket
{
	Set len = $LENGTH(par)
	Set sl = len + 1
	Set:(sl#4)'=0 sl = sl-(sl#4)+4
	Set rq = ##class(%Stream.GlobalBinary).%New()
	Do ..setHdr(..#DTSTRING,sl,rq) // Write 4 bytes
	Do ..setString(par, rq)
	//Do rq.Write($CHAR(0)) // Write one more byte
	Quit ..request(cmd,rq)
}

/** sends a request with one string parameter attached
        @param cmd command
        @param par parameter of the type DT_INT
        @return returned packet or <code>null</code> if something went wrong */
Method requestInteger(cmd As %Integer, par As %Integer) As RPacket
{
	Set rq = ##class(%Stream.GlobalBinary).%New()
	Do ..setHdr(..#DTINT,4,.rq)
	Do ..setInt(par,.rq)
	Quit ..request(cmd,.rq)
}

}

