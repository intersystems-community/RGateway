Class R.Demo.ScoreResponse Extends Ens.Response
{

Property PID As %String;

Property Score As %Double;

Storage Default
{
<Data name="ScoreResponseDefaultData">
<Subscript>"ScoreResponse"</Subscript>
<Value name="1">
<Value>PID</Value>
</Value>
<Value name="2">
<Value>Score</Value>
</Value>
</Data>
<DefaultData>ScoreResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

