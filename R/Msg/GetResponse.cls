/// Response from R 
Class R.Msg.GetResponse Extends Ens.Response
{

Property Data As R.Msg.RData;

Storage Default
{
<Data name="GetResponseDefaultData">
<Subscript>"GetResponse"</Subscript>
<Value name="1">
<Value>Data</Value>
</Value>
</Data>
<DefaultData>GetResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

