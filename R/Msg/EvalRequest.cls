/// Request to assign variables with values
Class R.Msg.EvalRequest Extends Ens.Request
{

/// R code to execute
Property Code As %String(MAXLEN = "");

Storage Default
{
<Data name="EvalRequestDefaultData">
<Subscript>"EvalRequest"</Subscript>
<Value name="1">
<Value>Code</Value>
</Value>
</Data>
<DefaultData>EvalRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

