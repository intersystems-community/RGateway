/// Response from R 
Class R.Msg.EvalResponse Extends Ens.Response
{

Property Data As RData;

Storage Default
{
<Data name="EvalResponseDefaultData">
<Subscript>"EvalResponse"</Subscript>
<Value name="1">
<Value>Data</Value>
</Value>
</Data>
<DefaultData>EvalResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

