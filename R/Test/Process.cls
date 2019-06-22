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
<process language='objectscript' request='Ens.Request' response='Ens.Response' height='2200' width='2420' >
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
<property name='Class' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='Type' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='Attributes' type='%String' collection='list' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='Values' type='%String' collection='list' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='RawValue' type='%Stream.GlobalBinary' instantiate='0' />
</context>
<sequence xend='200' yend='1950' >
<code name='Init Context' xpos='200' ypos='250' >
<![CDATA[ Set context.Class = "Matrix"
 Set context.Type = "Integer"
 Do context.Attributes.Clear()
 Do context.Attributes.Insert(2)
 Do context.Attributes.Insert(2)
 Do context.Values.Clear()
 Do context.Values.Insert(1)
 Do context.Values.Insert(2)
 Do context.Values.Insert(3)
 Do context.Values.Insert(4)
 Do context.RawValue.Write("abcdef")]]>
</code>
<flow xpos='200' ypos='350' xend='200' yend='600' >
<sequence >
<call name='Assign Vector' target='R.Ens.Operation' async='1' xpos='200' ypos='500' >
<request type='R.Msg.AssignRequest' >
<assign property="callrequest.Data.Class" value="&quot;Vector&quot;" action="set" />
<assign property="callrequest.Name" value="&quot;x1&quot;" action="set" />
<assign property="callrequest.Data.Type" value="&quot;Double&quot;" action="set" />
<assign property="callrequest.Data.Values" value="1.1" action="append" />
<assign property="callrequest.Data.Values" value="2.2" action="append" />
<assign property="callrequest.Data.Values" value="3.3" action="append" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
<sequence >
<call name='Assign Matrix' target='R.Ens.Operation' async='1' xpos='470' ypos='500' >
<request type='R.Msg.AssignRequest' >
<assign property="callrequest.Data.Class" value="&quot;Matrix&quot;" action="set" />
<assign property="callrequest.Name" value="&quot;x2&quot;" action="set" />
<assign property="callrequest.Data.Type" value="&quot;Integer&quot;" action="set" />
<assign property="callrequest.Data.Attributes" value="2" action="append" />
<assign property="callrequest.Data.Attributes" value="2" action="append" />
<assign property="callrequest.Data.Values" value="1" action="append" />
<assign property="callrequest.Data.Values" value="2" action="append" />
<assign property="callrequest.Data.Values" value="3" action="append" />
<assign property="callrequest.Data.Values" value="4" action="append" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
<sequence >
<call name='Assign Factor' target='R.Ens.Operation' async='1' xpos='740' ypos='500' >
<request type='R.Msg.AssignRequest' >
<assign property="callrequest.Data.Class" value="&quot;Factor&quot;" action="set" />
<assign property="callrequest.Name" value="&quot;x3&quot;" action="set" />
<assign property="callrequest.Data.Attributes" value="1" action="append" />
<assign property="callrequest.Data.Attributes" value="&quot;Male&quot;" action="append" />
<assign property="callrequest.Data.Attributes" value="&quot;Female&quot;" action="append" />
<assign property="callrequest.Data.Values" value="1" action="append" />
<assign property="callrequest.Data.Values" value="2" action="append" />
<assign property="callrequest.Data.Values" value="1" action="append" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
<sequence >
<call name='Assign List' target='R.Ens.Operation' async='1' xpos='1010' ypos='500' >
<request type='R.Msg.AssignRequest' >
<assign property="callrequest.Data.Class" value="&quot;List&quot;" action="set" />
<assign property="callrequest.Name" value="&quot;x4&quot;" action="set" />
<assign property="callrequest.Data.Values" value="&quot;Age&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;Integer&quot;" action="append" />
<assign property="callrequest.Data.Values" value="2" action="append" />
<assign property="callrequest.Data.Values" value="10" action="append" />
<assign property="callrequest.Data.Values" value="20" action="append" />
<assign property="callrequest.Data.Values" value="&quot;Name&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;String&quot;" action="append" />
<assign property="callrequest.Data.Values" value="3" action="append" />
<assign property="callrequest.Data.Values" value="&quot;aaa&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;bbb&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;ccc&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;Salary&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;Double&quot;" action="append" />
<assign property="callrequest.Data.Values" value="1" action="append" />
<assign property="callrequest.Data.Values" value="10000.11" action="append" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
<sequence >
<call name='Assign DataFrame' target='R.Ens.Operation' async='1' xpos='1280' ypos='500' >
<request type='R.Msg.AssignRequest' >
<assign property="callrequest.Data.Class" value="&quot;DataFrame&quot;" action="set" />
<assign property="callrequest.Name" value="&quot;x5&quot;" action="set" />
<assign property="callrequest.Data.Values" value="&quot;Age&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;Integer&quot;" action="append" />
<assign property="callrequest.Data.Values" value="3" action="append" />
<assign property="callrequest.Data.Values" value="10" action="append" />
<assign property="callrequest.Data.Values" value="20" action="append" />
<assign property="callrequest.Data.Values" value="30" action="append" />
<assign property="callrequest.Data.Values" value="&quot;Name&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;String&quot;" action="append" />
<assign property="callrequest.Data.Values" value="3" action="append" />
<assign property="callrequest.Data.Values" value="&quot;aaa&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;bbb&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;ccc&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;Salary&quot;" action="append" />
<assign property="callrequest.Data.Values" value="&quot;Double&quot;" action="append" />
<assign property="callrequest.Data.Values" value="3" action="append" />
<assign property="callrequest.Data.Values" value="10000.11" action="append" />
<assign property="callrequest.Data.Values" value="20000.22" action="append" />
<assign property="callrequest.Data.Values" value="30000.33" action="append" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
<sequence >
<call name='Assign Context' target='R.Ens.Operation' async='1' xpos='1550' ypos='500' >
<request type='R.Msg.AssignRequest' >
<assign property="callrequest.Name" value="&quot;x0&quot;" action="set" />
<assign property="callrequest.Data.Class" value="context.Class" action="set" />
<assign property="callrequest.Data.Type" value="context.Type" action="set" />
<assign property="callrequest.Data.Attributes" value="context.Attributes" action="set" />
<assign property="callrequest.Data.Values" value="context.Values" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
<sequence >
<call name='Assign Raw' target='R.Ens.Operation' async='1' xpos='1820' ypos='500' >
<request type='R.Msg.AssignRequest' >
<assign property="callrequest.Data.Class" value="&quot;Raw&quot;" action="set" />
<assign property="callrequest.Name" value="&quot;x6&quot;" action="set" />
<assign property="callrequest.Data.RawValue" value="context.RawValue" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</flow>
<sync name='Wait Assigns' calls='Assign Vector,Assign Matrix,Assign Factor,Assign List,Assign DataFrame,Assign Context,Assign Raw' type='all' xpos='200' ypos='700' />
<flow xpos='200' ypos='800' xend='200' yend='1050' >
<sequence >
<call name='Get Context' target='R.Ens.Operation' async='1' xpos='200' ypos='950' >
<request type='R.Msg.GetRequest' >
<assign property="callrequest.Name" value="&quot;x0&quot;" action="set" />
</request>
<response type='R.Msg.GetResponse' />
</call>
</sequence>
<sequence >
<call name='Get Vector' target='R.Ens.Operation' async='1' xpos='470' ypos='950' >
<request type='R.Msg.GetRequest' >
<assign property="callrequest.Name" value="&quot;x1&quot;" action="set" />
</request>
<response type='R.Msg.GetResponse' />
</call>
</sequence>
<sequence >
<call name='Get Matrix' target='R.Ens.Operation' async='1' xpos='740' ypos='950' >
<request type='R.Msg.GetRequest' >
<assign property="callrequest.Name" value="&quot;x2&quot;" action="set" />
</request>
<response type='R.Msg.GetResponse' />
</call>
</sequence>
<sequence >
<call name='Get Factor' target='R.Ens.Operation' async='1' xpos='1010' ypos='950' >
<request type='R.Msg.GetRequest' >
<assign property="callrequest.Name" value="&quot;x3&quot;" action="set" />
</request>
<response type='R.Msg.GetResponse' />
</call>
</sequence>
<sequence >
<call name='Get List' target='R.Ens.Operation' async='1' xpos='1280' ypos='950' >
<request type='R.Msg.GetRequest' >
<assign property="callrequest.Name" value="&quot;x4&quot;" action="set" />
</request>
<response type='R.Msg.GetResponse' />
</call>
</sequence>
<sequence >
<call name='Get DataFrame' target='R.Ens.Operation' async='1' xpos='1550' ypos='950' >
<request type='R.Msg.GetRequest' >
<assign property="callrequest.Name" value="&quot;x5&quot;" action="set" />
</request>
<response type='R.Msg.GetResponse' />
</call>
</sequence>
<sequence >
<call name='Get Raw' target='R.Ens.Operation' async='1' xpos='1849' ypos='956' >
<request type='R.Msg.GetRequest' >
<assign property="callrequest.Name" value="&quot;x6&quot;" action="set" />
</request>
<response type='R.Msg.GetResponse' />
</call>
</sequence>
</flow>
<sync name='Wait Gets' calls='Get Context,Get Vector,Get Matrix,Get Factor,Get List,Get DataFrame,Get Raw' type='all' xpos='200' ypos='1150' />
<call name='VoidEval' target='R.Ens.Operation' async='1' xpos='200' ypos='1250' >
<annotation><![CDATA[z=x0+x2
z=sqrt(z)]]></annotation>
<request type='R.Msg.VoidEvalRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;VoidEval&quot;)" action="set" />
</request>
<response type='Ens.Response' />
</call>
<call name='Eval' target='R.Ens.Operation' async='1' xpos='200' ypos='1350' >
<annotation><![CDATA[x0-x0]]></annotation>
<request type='R.Msg.EvalRequest' >
<assign property="callrequest.Code" value="process.GetAnnotation(&quot;Eval&quot;)" action="set" />
</request>
<response type='R.Msg.EvalResponse' />
</call>
<code name='R Code' xpos='200' ypos='1450' >
<![CDATA[ set x(1) = "z1=x0-x2"
 set x(2) = "z2=x0/2"
 set x(3) = "z3=z1+z2"
 set context.Code = ##class(R.Utils).RCode(.x)
 
]]>
</code>
<call name='AnotherEval' target='R.Ens.Operation' async='1' xpos='200' ypos='1550' >
<request type='R.Msg.EvalRequest' >
<assign property="callrequest.Code" value="context.Code" action="set" />
</request>
<response type='R.Msg.EvalResponse' />
</call>
<sync name='Wait Evals' calls='VoidEval,Eval,AnotherEval' type='all' xpos='200' ypos='1650' />
<call name='Get z' target='R.Ens.Operation' async='1' xpos='200' ypos='1750' >
<request type='R.Msg.GetRequest' >
<assign property="callrequest.Name" value="&quot;z&quot;" action="set" />
</request>
<response type='R.Msg.GetResponse' >
<assign property="context.Class" value="callresponse.Data.Class" action="set" />
<assign property="context.Type" value="callresponse.Data.Type" action="set" />
<assign property="context.Attributes" value="callresponse.Data.Attributes" action="set" />
<assign property="context.Values" value="callresponse.Data.Values" action="set" />
</response>
</call>
<sync name='Wait Get z' calls='Get z' type='all' xpos='200' ypos='1850' />
</sequence>
</process>
}

}

