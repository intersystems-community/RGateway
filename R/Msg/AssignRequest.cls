/// Request to assign variable with value
Class R.Msg.AssignRequest Extends Ens.Request
{

Property Name As %String;

Property Type As %String(VALUELIST = ",Double,Integer,String,SQL") [ InitialExpression = "Double" ];

Property Values As list Of %String(MAXLEN = "");

Storage Default
{
<Data name="AssignRequestDefaultData">
<Subscript>"AssignRequest"</Subscript>
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Values</Value>
</Value>
</Data>
<DefaultData>AssignRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

