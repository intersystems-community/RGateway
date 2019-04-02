Class R.Demo.PimaOperation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Property RCon As R.RConnection;

Property RHost As %String [ InitialExpression = "localhost" ];

Property RPort As %Integer [ InitialExpression = 6311 ];

Property ModelFileName As %String [ InitialExpression = "diabetes_glm" ];

Parameter SETTINGS = "RHost,RPort,ModelFileName";

Method Score(pRequest As R.Demo.PimaRecordMap.Record, Output pResponse As Ens.Response) As %Status
{
	Set tSC = $$$OK
	Try {
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
	 		
	 	Do ..RCon.assign("x", df)
	 	Set pred = ..RCon.eval("pred <- predict(glm_fm, newdata = x, type = 'response')")
	 	Set prob = pred.asDouble()
	 	$$$LOGINFO("Predicted Probability: "_prob)
	 	
	 	// Send an alert
	 	If prob > 0.5 { // High risk patient
	 		Set alert=##class(Ens.AlertRequest).%New()
 			Set alert.AlertText="High risk patient received with probability "_prob
	 		Set tSC = ..SendAlert(alert)
	 	}
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
		// Open connection
		Set ..RCon = ##class(R.RConnection).%New(..RHost,..RPort)
		
		// Load model
		Do ..RCon.voidEval("glm_fm <- readRDS('"_..ModelFileName_"')")
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// This user callback method is called from %OnClose()
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

XData MessageMap
{
<MapItems>
	<MapItem MessageType="R.Demo.PimaRecordMap.Record"> 
		<Method>Score</Method>
	</MapItem>
</MapItems>
}

}

