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
</MapItems>
}

Method Assign(request As R.Msg.AssignRequest, Output response As Ens.Response) As %Status
{
	Set tSC = $$$OK
	Try {
		#Dim value As R.REXP
		If request.Type="Double" {
			Set value = ##class(R.REXPDouble).%New(request.Values)
		}
		ElseIf request.Type="Integer" {
			Set value = ##class(R.REXPInteger).%New(request.Values)
		}
		ElseIf request.Type="String" {
			Set value = ##class(R.REXPString).%New(request.Values)
		}
		ElseIf request.Type="SQL" {
			Set value = ##class(R.REXP).createDataFrameFromSQL(request.Values.GetAt(1))
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError, "Unknown data type")
			Quit
		}
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
		If tValue.%IsA("R.REXPDouble") {
			Set response.Type = "Double"
			Set response.Values = tValue.asDoubles()
		}
		ElseIf tValue.%IsA("R.REXPInteger") {
			Set response.Type = "Integer"
			Set response.Values = tValue.asIntegers()
		}
		ElseIf tValue.%IsA("R.REXPString") {
			Set response.Type = "String"
			Set response.Values = tValue.asStrings()
		}
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
		Set response.Name = request.Name
		If value.%IsA("R.REXPDouble") {
			Set response.Type = "Double"
			Set response.Values = value.asDoubles()
		}
		ElseIf value.%IsA("R.REXPInteger") {
			Set response.Type = "Integer"
			Set response.Values = value.asIntegers()
		}
		ElseIf value.%IsA("R.REXPString") {
			Set response.Type = "String"
			Set response.Values = value.asStrings()
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

}

