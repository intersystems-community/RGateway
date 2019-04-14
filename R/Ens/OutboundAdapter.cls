Class R.Ens.OutboundAdapter Extends Ens.OutboundAdapter
{

Property RHost As %String [ InitialExpression = "localhost" ];

Property RPort As %Integer [ InitialExpression = 6311 ];

Property RCon As R.RConnection;

Parameter SETTINGS = "RHost,RPort";

/// Open RConnection
Method OnInit() As %Status
{
	Set tSC = $$$OK
	Try {
		Set ..RCon = ##class(R.RConnection).%New(..RHost, ..RPort)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Close RConnection
Method OnTearDown() As %Status
{
	Set tSC = $$$OK
	Try {
		Do:..RCon'="" ..RCon.close()
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Assign value to a R variable
Method Assign(variable As %String, value As R.REXP) As %Status
{
	Set tSC = $$$OK
	Try {
		Do ..RCon.assign(variable, value)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Execute R scripts
Method VoidEval(code As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Do ..RCon.voidEval(code)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Execute R scripts
Method Eval(code As %String, Output pSC As %Status) As R.REXP
{
	Set pSC = $$$OK
	Set tValue = ""
	Try {
		Set tValue = ..RCon.eval(code)
	}
	Catch (ex) {
		Set pSC = ex.AsStatus()
	}
	Quit tValue
}

/// Get value of a R variable
Method Get(variable As %String, Output sc As %Status) As R.REXP
{
	Set tValue = ""
	Set sc = $$$OK
	Try {
		Set tValue = ..RCon.get(variable)
	}
	Catch (ex) {
		Set sc = ex.AsStatus()
	}
	Quit tValue
}

}

