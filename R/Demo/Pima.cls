Class R.Demo.Pima Extends (%Persistent, %XML.Adaptor)
{

/// Number of times pregnant
Property Pregnant As %Integer [ SqlColumnNumber = 2 ];

/// Plasma glucose concentration a 2 hours in an oral glucose tolerance test
Property PlasmaGlucose As %Integer [ SqlColumnNumber = 3 ];

/// Diastolic blood pressure (mm Hg)
Property DiasBP As %Integer [ SqlColumnNumber = 4 ];

/// Triceps skin fold thickness (mm)
Property TricepsSkin As %Integer [ SqlColumnNumber = 5 ];

/// 2-Hour serum insulin (mu U/ml)
Property SerumInsulin As %Integer [ SqlColumnNumber = 6 ];

/// Body mass index (weight in kg/(height in m)^2)
Property BMI As %Numeric [ SqlColumnNumber = 7 ];

/// Diabetes pedigree function
Property DPF As %Numeric [ SqlColumnNumber = 8 ];

/// Age (years)
Property Age As %Integer [ SqlColumnNumber = 9 ];

/// Class variable (0 or 1)
Property Diabetes As %Integer [ SqlColumnNumber = 10 ];

/// Predicted probability
Property Prediction As %Numeric [ SqlColumnNumber = 11 ];

/// Create a R data frame from table data 
ClassMethod CreateDataFrame() As R.REXP
{
	Set df = ""
	Try {
		Set list = ##class(R.RList).%New()
		Set lpregnant = ##class(%ListOfDataTypes).%New()
		Set lplasma = ##class(%ListOfDataTypes).%New()
		Set ldias = ##class(%ListOfDataTypes).%New()
		Set ltriceps = ##class(%ListOfDataTypes).%New()
		Set lserum = ##class(%ListOfDataTypes).%New()
		Set lbmi = ##class(%ListOfDataTypes).%New()
		Set ldpf = ##class(%ListOfDataTypes).%New()
		Set lage = ##class(%ListOfDataTypes).%New()
		Set ldiabetes = ##class(%ListOfDataTypes).%New()
		
		Set sql = "SELECT * FROM R_Demo.Pima"
		#Dim tResultSet As %SQL.StatementResult = ##class(%SQL.Statement).%ExecDirect(,.sql)
 		While tResultSet.%Next() {
	 		Do lpregnant.Insert(tResultSet.%Get("Pregnant"))
	 		Do lplasma.Insert(tResultSet.%Get("PlasmaGlucose"))
	 		Do ldias.Insert(tResultSet.%Get("DiasBP"))
	 		Do ltriceps.Insert(tResultSet.%Get("TricepsSkin"))
	 		Do lserum.Insert(tResultSet.%Get("SerumInsulin"))
	 		Do lbmi.Insert(tResultSet.%Get("BMI"))
	 		Do ldpf.Insert(tResultSet.%Get("DPF"))
	 		Do lage.Insert(tResultSet.%Get("Age"))
	 		Do ldiabetes.Insert(tResultSet.%Get("Diabetes"))
	 		
	 		//Set i = $I(i)
	 		//Quit:i>=10
 		}
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
	}
	Catch (e)
	{
		W e.Data, !
	}
	Quit df
}

/// Logistic Regression
ClassMethod LogReg()
{
	Try {
		Set c = ##class(R.RConnection).%New()
		
		// assign dataframe
		W "Assign dataset...", !
		Set df = ..CreateDataFrame()
		Do c.assign("pima", df)
		Set p = c.get("pima")
		
		// set seed
		Do c.eval("set.seed(123)")
		// # of rows
		Set n = c.eval("n <- nrow(pima)")
		// training set
		Set train = c.eval("train <- sample(n, trunc(0.70*n))")
		Set ptrain = c.eval("pima_training <- pima[train, ]")
		// testing set
		Set ptest = c.eval("pima_testing <- pima[-train, ]")

		// Training The Model
		W "Train model...", !
		Set fm = c.eval("glm_fm <- glm(Diabetes ~., data = pima_training, family = binomial)")
		//summary(glm_fm1)

		// # Testing the Model
		W "Test model...", !
		Set probs = c.eval("glm_probs <- predict(glm_fm, newdata = pima_testing, type = 'response')")
		Set preds = c.eval("glm_pred <- ifelse(glm_probs > 0.5, 1, 0)")
		// Accuracy for logistic regression
		Set acc = c.eval("acc <- sum((glm_pred==pima_testing$Diabetes))/length(glm_pred)")
		W "Accuracy: ", acc.asDouble(), !
		
		// Save the model
		W "Save model...", !
		Do c.voidEval("saveRDS(glm_fm, 'diabetes_glm')")
	}
	Catch (e) {
		W e.Data, !
	}
	Do:c'="" c.close()
	Quit
}

/// Score a dataset and save the results
ClassMethod ScoreDataset()
{
	Try {
		Set c = ##class(R.RConnection).%New()
		
		// Load model
		Do c.voidEval("glm_fm <- readRDS('diabetes_glm')")
		
		Set sql = "SELECT ID FROM R_Demo.Pima"
		#Dim tResultSet As %SQL.StatementResult = ##class(%SQL.Statement).%ExecDirect(,.sql)
 		While tResultSet.%Next() {
	 		Set id = tResultSet.%Get("ID")
	 		Set po = ##class(R.Demo.Pima).%OpenId(id)
	 		
			Set list = ##class(R.RList).%New()
			Set lpregnant = ##class(%ListOfDataTypes).%New() Do lpregnant.Insert(po.Pregnant)
			Set lplasma = ##class(%ListOfDataTypes).%New() Do lplasma.Insert(po.PlasmaGlucose)
			Set ldias = ##class(%ListOfDataTypes).%New() Do ldias.Insert(po.DiasBP)
			Set ltriceps = ##class(%ListOfDataTypes).%New() Do ltriceps.Insert(po.TricepsSkin)
			Set lserum = ##class(%ListOfDataTypes).%New() Do lserum.Insert(po.SerumInsulin)
			Set lbmi = ##class(%ListOfDataTypes).%New() Do lbmi.Insert(po.BMI)
			Set ldpf = ##class(%ListOfDataTypes).%New() Do ldpf.Insert(po.DPF)
			Set lage = ##class(%ListOfDataTypes).%New() Do lage.Insert(po.Age)
			Set ldiabetes = ##class(%ListOfDataTypes).%New() Do ldiabetes.Insert(po.Diabetes)
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
	 		
	 		Do c.assign("x", df)
	 		Set pred = c.eval("pred <- predict(glm_fm, newdata = x, type = 'response')")
	 		Set prob = pred.asDouble()
	 		W "ID = ", id, " pred = ", prob, !
	 		
	 		Set po.Prediction = prob
	 		Set tSC = po.%Save()
	 		$$$ThrowOnError(tSC)
	 		
	 		//Set i = $I(i)
	 		//Quit:i>=10
 		}
	}
	Catch (e) {
		W e.Data, !
	}
	Do:c'="" c.close()
	Quit
}

ClassMethod Export()
{
	set xdata = ##class(%Dictionary.XDataDefinition).IDKEYOpen($classname(), "Data")
	
	#dim stream As %Stream.TmpCharacter 
	set stream = xdata.Data
	
	do stream.Clear()
	do stream.WriteLine("<xml>")
	
	for i=1:1:$g(^R.Demo.PimaD) {
		set obj = ..%OpenId(i)
		do obj.XMLExportToStream(.stream)
		do stream.WriteLine("")
	}
	do stream.WriteLine("</xml>")
	quit xdata.%Save()
}

ClassMethod Import()
{
	#dim sc As %Status = $$$OK
	set xdata = ##class(%Dictionary.XDataDefinition).IDKEYOpen($classname(), "Data")
	
	#dim stream As %Stream.TmpCharacter 
	set stream = xdata.Data
	
	set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(stream)
	quit:$$$ISERR(sc) sc
	do reader.Correlate("Pima", $classname())
	
	do ..%KillExtent()
	while reader.Next(.obj, .sc) {
		set sc = obj.%Save()
		quit:$$$ISERR(sc)
	}
	
	quit sc
}

Storage Default
{
<Data name="PimaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Pregnant</Value>
</Value>
<Value name="3">
<Value>PlasmaGlucose</Value>
</Value>
<Value name="4">
<Value>DiasBP</Value>
</Value>
<Value name="5">
<Value>TricepsSkin</Value>
</Value>
<Value name="6">
<Value>SerumInsulin</Value>
</Value>
<Value name="7">
<Value>BMI</Value>
</Value>
<Value name="8">
<Value>DPF</Value>
</Value>
<Value name="9">
<Value>Age</Value>
</Value>
<Value name="10">
<Value>Diabetes</Value>
</Value>
<Value name="11">
<Value>Prediction</Value>
</Value>
</Data>
<DataLocation>^R.Demo.PimaD</DataLocation>
<DefaultData>PimaDefaultData</DefaultData>
<IdLocation>^R.Demo.PimaD</IdLocation>
<IndexLocation>^R.Demo.PimaI</IndexLocation>
<StreamLocation>^R.Demo.PimaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

XData Data
{
}

}

