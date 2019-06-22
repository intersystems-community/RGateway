/// Request to assign variable with value
Class R.Msg.AssignRequest Extends Ens.Request
{

Property Name As %String;

Property Data As RData;

Storage Default
{
<Data name="AssignRequestDefaultData">
<Subscript>"AssignRequest"</Subscript>
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
</Data>
<DefaultData>AssignRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

