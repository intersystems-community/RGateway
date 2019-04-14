Class R.Utils Extends %RegisteredObject
{

/// R terminal simulator
ClassMethod RTerminal(host As %String = "127.0.0.1", port As %Integer = 6311)
{
	#dim c as RConnection = ""
	try {
		set c = ##class(RConnection).%New(host,port)
		for {
			write "R>"
			read cmd, !
			quit:cmd="q"
			try {
				if cmd="" {
					quit
				}
				else { // a R command
					set out = c.parseAndEval(cmd)
					write:out'="" out.toString(), !
				}
			}
			catch (ie) {
				write ie.Data, !
			}
		}
	}
	catch (e) {
		write e.Data, !
	}
	do:c'="" c.close()
}

/// Convert multiline strings to a single code string seperated by new line character
ClassMethod RCode(ByRef ml) As %String
{
	set code = ""
	set key = $O(ml(""))
	while key'="" {
		set code = code_$G(ml(key))_$CHAR(10)
		set key = $O(ml(key))
	}
	quit code
}

}

