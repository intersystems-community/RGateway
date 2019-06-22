/// R operation. Execute R code and return requested variables
Class R.Ens.Operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "R.Ens.OutboundAdapter";

XData MessageMap
{
<MapItems>
  <MapItem MessageType="R.Msg.AssignRequest">
    <Method>Assign</Method>
  </MapItem>
  <MapItem MessageType="R.Msg.EvalRequest">
    <Method>Eval</Method>
  </MapItem>
   <MapItem MessageType="R.Msg.VoidEvalRequest">
    <Method>VoidEval</Method>
  </MapItem>
  <MapItem MessageType="R.Msg.GetRequest">
    <Method>Get</Method>
  </MapItem>
  <MapItem MessageType="R.Msg.AssignSQLRequest">
    <Method>AssignSQL</Method>
  </MapItem>
</MapItems>
}

Method Assign(request As R.Msg.AssignRequest, Output response As Ens.Response) As %Status
{
	Set tSC = $$$OK
	Try {
		#Dim value As R.REXP
		Set tSC = request.Data.ToREXP(.value)
		Quit:$$$ISERR(tSC)
		
		Set tSC = ..Adapter.Assign(request.Name, value)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method Eval(request As R.Msg.EvalRequest, Output response As R.Msg.EvalResponse) As %Status
{
	Set tSC = $$$OK
	Try {
		Set response = ##class(R.Msg.EvalResponse).%New()
		Set tValue = ..Adapter.Eval(request.Code, .tSC)
		Quit:$$$ISERR(tSC)
		
		Set tSC = response.Data.FromREXP(tValue)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method VoidEval(request As R.Msg.VoidEvalRequest, Output response As Ens.Response) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tSC = ..Adapter.VoidEval(request.Code)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method Get(request As R.Msg.GetRequest, Output response As R.Msg.GetResponse) As %Status
{
	Set tSC = $$$OK
	Try {
		Set response = ##class(R.Msg.GetResponse).%New()
		Set value = ..Adapter.Get(request.Name, .tSC)
		Quit:$$$ISERR(tSC)
		
		Set tSC = response.Data.FromREXP(value)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method AssignSQL(request As R.Msg.AssignSQLRequest, Output response As Ens.Response)
{
	Set tSC = $$$OK
	Try {
		#Dim value As R.REXP = ##class(R.REXP).createDataFrameFromSQL(request.SQL)
		Set tSC = ..Adapter.Assign(request.Name, value)
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}

