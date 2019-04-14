/// 
Class R.Test.Process Extends (Ens.BusinessProcessBPL, R.Ens.ProcessUtils) [ ClassType = persistent, DependsOn = R.Ens.ProcessUtils, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='Code' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='Name' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='Type' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='Values' type='%String' collection='list' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
</context>
<sequence xend='200' yend='1350' >
<code name='Assign to Context' xpos='200' ypos='250' >
<![CDATA[ Set context.Name = "x"
 Set context.Type = "Double"
 Do context.Values.Clear()
 Do context.Values.Insert(1)
 Do context.Values.Insert(2)
 Do context.Values.Insert(3) ]]>
</code>
<call name='Assign1' target='R.Ens.Operation' async='1' xpos='200' ypos='350' >
<request type='R.Msg.AssignRequest' >
<assign property="callrequest.Name" value="context.Name" action="set" />
<assign property="callrequest.Type" value="context.Type" action="set" />
<assign property="callrequest.Values" value="context.Values" action="set" />
</request>
<response type='Ens.Response' />
</call>
<call name='Assign2' target='R.Ens.Operation' async='1' xpos='200' ypos='450' >
<request type='R.Msg.AssignRequest' >
<assign property="callrequest.Name" value="&quot;y&quot;" action="set" />
<assign property="callrequest.Type" value="&quot;Double&quot;" action="set" />
<assign property="callrequest.Values" value="&quot;4&quot;" action="insert" key="&quot;1&quot;" />
<assign property="callrequest.Values" value="&quot;5&quot;" action="insert" key="&quot;2&quot;" />
<assign property="callrequest.Values" value="&quot;6&quot;" action="insert" key="&quot;3&quot;" />
</request>
<response type='Ens.Response' />
</call>
<sync name='Wait Assigns' calls='Assign1,Assign2' type='all' xpos='200' ypos='550' />
<call name='VoidEval' target='R.Ens.Operation' async='1' xpos='200' ypos='650' >
<annotation><![CDATA[z=x+y
z=sqrt(z)]]></annotation>
<request type='R.Msg.VoidEvalRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;VoidEval&quot;)" action="set" />
</request>
<response type='Ens.Response' />
</call>
<call name='Eval' target='R.Ens.Operation' async='1' xpos='200' ypos='750' >
<annotation><![CDATA[x-y]]></annotation>
<request type='R.Msg.EvalRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Eval&quot;)" action="set" />
</request>
<response type='R.Msg.EvalResponse' />
</call>
<code xpos='200' ypos='850' >
<![CDATA[ set x(1) = "z1=x-y"
 set x(2) = "z2=x/y"
 set x(3) = "z3=z1+z2"
 set context.Code = ##class(R.Utils).RCode(.x)
 
]]>
</code>
<call name='AnotherEval' target='R.Ens.Operation' async='1' xpos='200' ypos='950' >
<request type='R.Msg.EvalRequest' >
<assign property="callrequest.Code" value="context.Code" action="set" />
</request>
<response type='R.Msg.EvalResponse' />
</call>
<sync name='Wait Evals' calls='VoidEval,Eval,AnotherEval' type='all' xpos='200' ypos='1050' />
<call name='Get' target='R.Ens.Operation' async='1' xpos='200' ypos='1150' >
<request type='R.Msg.GetRequest' >
<assign property="callrequest.Name" value="&quot;z&quot;" action="set" />
</request>
<response type='R.Msg.GetResponse' >
<assign property="context.Name" value="callresponse.Name" action="set" />
<assign property="context.Type" value="callresponse.Type" action="set" />
<assign property="context.Values" value="callresponse.Values" action="set" />
</response>
</call>
<sync name='Wait Get' calls='Get' type='all' xpos='200' ypos='1250' />
</sequence>
</process>
}

}

