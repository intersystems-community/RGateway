/// 
Class R.Demo.ModelBuildBPL Extends (Ens.BusinessProcessBPL, R.Ens.ProcessUtils) [ ClassType = persistent, DependsOn = R.Ens.ProcessUtils, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='1250' >
<call name='AssignDataset' target='R.Ens.Operation' async='1' xpos='200' ypos='250' >
<request type='R.Msg.AssignRequest' >
<assign property="callrequest.Name" value="&quot;pima&quot;" action="set" />
<assign property="callrequest.Type" value="&quot;SQL&quot;" action="set" />
<assign property="callrequest.Values" value="&quot;SELECT Pregnant,PlasmaGlucose,DiasBP,TricepsSkin,SerumInsulin,BMI,DPF,Age,Diabetes FROM R_Demo.Pima&quot;" action="insert" key="&quot;1&quot;" />
</request>
<response type='Ens.Response' />
</call>
<sync calls='AssignDataset' type='all' xpos='200' ypos='350' />
<call name='TrainModel' target='R.Ens.Operation' async='1' xpos='200' ypos='450' >
<annotation><![CDATA[set.seed(123)
n <- nrow(pima)
train <- sample(n, trunc(0.70*n))
pima_training <- pima[train, ]
pima_testing <- pima
glm_fm <- glm(Diabetes ~., data = pima_training, family = binomial)]]></annotation>
<request type='R.Msg.VoidEvalRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;TrainModel&quot;)" action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync calls='TrainModel' type='all' xpos='200' ypos='550' />
<call name='TestModel' target='R.Ens.Operation' async='1' xpos='200' ypos='650' >
<annotation><![CDATA[glm_probs <- predict(glm_fm, newdata = pima_testing, type = 'response')
glm_pred <- ifelse(glm_probs > 0.5, 1, 0)
acc <- sum((glm_pred==pima_testing$Diabetes))/length(glm_pred)]]></annotation>
<request type='R.Msg.EvalRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;TestModel&quot;)" action="set" />
</request>
<response type='R.Msg.EvalResponse' />
</call>
<sync calls='TestModel' type='all' xpos='200' ypos='750' />
<call name='GetTestResult' target='R.Ens.Operation' async='1' xpos='200' ypos='850' >
<request type='R.Msg.GetRequest' >
<assign property="callrequest.Name" value="&quot;acc&quot;" action="set" />
</request>
<response type='R.Msg.GetResponse' />
</call>
<sync calls='GetTestResult' type='all' xpos='200' ypos='950' />
<call name='SaveModel' target='R.Ens.Operation' async='1' xpos='200' ypos='1050' >
<annotation><![CDATA[saveRDS(glm_fm, 'diabetes_glm')]]></annotation>
<request type='R.Msg.VoidEvalRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;SaveModel&quot;)" action="set" />
</request>
<response type='Ens.Response' />
</call>
<sync calls='SaveModel' type='all' xpos='200' ypos='1150' />
</sequence>
</process>
}

}

