/// Response from R 
Class R.Msg.GetResponse Extends Ens.Response
{

Property Name As %String;

Property Type As %String(VALUELIST = ",Double,Integer,String") [ InitialExpression = "Double" ];

Property Values As list Of %String(MAXLEN = "");

Storage Default
{
<Data name="GetResponseDefaultData">
<Subscript>"GetResponse"</Subscript>
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
<DefaultData>GetResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

