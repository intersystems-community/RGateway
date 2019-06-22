/// Request to assign variable with value
Class R.Msg.AssignSQLRequest Extends Ens.Request
{

Property Name As %String;

Property SQL As %String(MAXLEN = "");

Storage Default
{
<Data name="AssignSQLRequestDefaultData">
<Subscript>"AssignSQLRequest"</Subscript>
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>SQL</Value>
</Value>
</Data>
<DefaultData>AssignSQLRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

