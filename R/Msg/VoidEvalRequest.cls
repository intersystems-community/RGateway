/// Request to assign variables with values
Class R.Msg.VoidEvalRequest Extends Ens.Request
{

/// R code to execute
Property Code As %String(MAXLEN = "");

Storage Default
{
<Data name="VoidEvalRequestDefaultData">
<Subscript>"VoidEvalRequest"</Subscript>
<Value name="1">
<Value>Code</Value>
</Value>
</Data>
<DefaultData>VoidEvalRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

