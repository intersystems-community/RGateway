/// 
Class R.Demo.ModelScoreBPL Extends Ens.BusinessProcessBPL [ ClassType = persistent, DependsOn = R.Ens.ProcessUtils, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='R.Demo.PimaRecordMap.Record' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='PID' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='Score' type='%Double' instantiate='0' />
</context>
<sequence xend='200' yend='800' >
<call name='Score' target='R.Demo.ScoreOperation' async='1' xpos='200' ypos='250' >
<request type='R.Demo.PimaRecordMap.Record' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='R.Demo.ScoreResponse' >
<assign property="context.Score" value="callresponse.Score" action="set" />
<assign property="context.PID" value="callresponse.PID" action="set" />
</response>
</call>
<sync calls='Score' type='all' xpos='200' ypos='350' />
<if condition='context.Score&gt;0.5' xpos='200' ypos='450' xend='200' yend='600' >
<true/>
</if>
<alert value='"High risk patient "_context.PID_"  with probability "_context.Score' xpos='200' ypos='700' />
</sequence>
</process>
}

}

