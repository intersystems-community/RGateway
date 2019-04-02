Class R.Demo.ScoreOperation Extends R.Ens.Operation
{

Parameter INVOCATION = "Queue";

Property ModelFileName As %String [ InitialExpression = "diabetes_glm" ];

Parameter SETTINGS = "ModelFileName";

Method Score(pRequest As R.Demo.PimaRecordMap.Record, Output pResponse As R.Demo.ScoreResponse) As %Status
{
	Set tSC = $$$OK
	Try {
		// Build dataframe
		Set list = ##class(R.RList).%New()
		Set lpregnant = ##class(%ListOfDataTypes).%New() Do lpregnant.Insert(pRequest.Pregnant)
		Set lplasma = ##class(%ListOfDataTypes).%New() Do lplasma.Insert(pRequest.PlasmaGlucose)
		Set ldias = ##class(%ListOfDataTypes).%New() Do ldias.Insert(pRequest.DiasBP)
		Set ltriceps = ##class(%ListOfDataTypes).%New() Do ltriceps.Insert(pRequest.TricepsSkin)
		Set lserum = ##class(%ListOfDataTypes).%New() Do lserum.Insert(pRequest.SerumInsulin)
		Set lbmi = ##class(%ListOfDataTypes).%New() Do lbmi.Insert(pRequest.BMI)
		Set ldpf = ##class(%ListOfDataTypes).%New() Do ldpf.Insert(pRequest.DPF)
		Set lage = ##class(%ListOfDataTypes).%New() Do lage.Insert(pRequest.Age)
		Set ldiabetes = ##class(%ListOfDataTypes).%New() Do ldiabetes.Insert(pRequest.Diabetes)
	 	Do list.put("Pregnant", ##class(R.REXPInteger).%New(lpregnant))
 		Do list.put("PlasmaGlucose", ##class(R.REXPInteger).%New(lplasma))
 		Do list.put("DiasBP", ##class(R.REXPInteger).%New(ldias))
 		Do list.put("TricepsSkin", ##class(R.REXPInteger).%New(ltriceps))
 		Do list.put("SerumInsulin", ##class(R.REXPInteger).%New(lserum))
 		Do list.put("BMI", ##class(R.REXPDouble).%New(lbmi))
 		Do list.put("DPF", ##class(R.REXPDouble).%New(ldpf))
 		Do list.put("Age", ##class(R.REXPInteger).%New(lage))
 		Do list.put("Diabetes", ##class(R.REXPInteger).%New(ldiabetes))
 		
 		Set df = ##class(R.REXP).createDataFrame(list)
	 	Do ..Adapter.Assign("x", df)
	 	Set pred = ..Adapter.Eval("pred <- predict(glm_fm, newdata = x, type = 'response')", .tSC)
	 	Quit:$$$ISERR(tSC)
	 	Set prob = pred.asDouble()
	 	$$$LOGINFO("Predicted Probability: "_prob)
	 
	 	Set pResponse = ##class(R.Demo.ScoreResponse).%New()
	 	Set pResponse.PID = pRequest.PID
	 	Set pResponse.Score = prob
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Method OnInit() As %Status
{
	Set tSC = $$$OK
	Try {
		// Load model
		Do ..Adapter.VoidEval("glm_fm <- readRDS('"_..ModelFileName_"')")
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// This user callback method is called from %OnClose()
Method OnTearDown() As %Status
{
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="R.Demo.PimaRecordMap.Record"> 
		<Method>Score</Method>
	</MapItem>
</MapItems>
}

}

