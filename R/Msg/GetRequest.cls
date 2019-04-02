/// Request to assign variables with values
Class R.Msg.GetRequest Extends Ens.Request
{

Property Name As %String;

Storage Default
{
<Data name="GetRequestDefaultData">
<Subscript>"GetRequest"</Subscript>
<Value name="1">
<Value>Name</Value>
</Value>
</Data>
<DefaultData>GetRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

