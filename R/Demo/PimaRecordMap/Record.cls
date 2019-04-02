/// RECORDMAP: Generated from RecordMap 'R.Demo.PimaRecordMap'
/// on 2019-03-22 at 15:54:19.213 [2019-03-22 20:54:19.213 UTC]
/// by user _SYSTEM
Class R.Demo.PimaRecordMap.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property PID As %String [ SqlColumnNumber = 2 ];

Property Pregnant As %Integer [ SqlColumnNumber = 3 ];

Property PlasmaGlucose As %Integer [ SqlColumnNumber = 4 ];

Property DiasBP As %Integer [ SqlColumnNumber = 5 ];

Property TricepsSkin As %Integer [ SqlColumnNumber = 6 ];

Property SerumInsulin As %Integer [ SqlColumnNumber = 7 ];

Property BMI As %Numeric [ SqlColumnNumber = 8 ];

Property DPF As %Numeric [ SqlColumnNumber = 9 ];

Property Age As %Integer [ SqlColumnNumber = 10 ];

Property Diabetes As %Integer [ SqlColumnNumber = 11 ];

Parameter RECORDMAPGENERATED = 1;

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PID</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>PlasmaGlucose</Value>
</Value>
<Value name="5">
<Value>DiasBP</Value>
</Value>
<Value name="6">
<Value>TricepsSkin</Value>
</Value>
<Value name="7">
<Value>SerumInsulin</Value>
</Value>
<Value name="8">
<Value>BMI</Value>
</Value>
<Value name="9">
<Value>DPF</Value>
</Value>
<Value name="10">
<Value>Age</Value>
</Value>
<Value name="11">
<Value>Diabetes</Value>
</Value>
<Value name="12">
<Value>Pregnant</Value>
</Value>
</Data>
<DataLocation>^R.Demo.PimaRecordMap.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^R.Demo.PimaRecordMap.RecordD</IdLocation>
<IndexLocation>^R.Demo.PimaRecordMap.RecordI</IndexLocation>
<StreamLocation>^R.Demo.PimaRecordMap.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

