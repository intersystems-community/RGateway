Class R.Utils Extends %RegisteredObject
{

/// R terminal simulator
/// do ##class(R.Utils).RTerminal()
ClassMethod RTerminal(host As %String = "127.0.0.1", port As %Integer = 6311, c As R.RConnection = "")
{
	try {		
		set:c="" c = ##class(RConnection).%New(host,port)
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

