/// 
Class R.Demo.PimaCube Extends %DeepSee.CubeDefinition [ DependsOn = R.Demo.Pima, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="PimaCube" displayName="PimaCube" disabled="false" abstract="false" sourceClass="R.Demo.Pima" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="Age" disabled="false" hasAll="false" allCaption="All Age" allDisplayName="Age" sourceProperty="Age" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Age Group" disabled="false" sourceProperty="Age" timeFunction="Years" list="false" rangeExpression="[0,20):0 to 19;[20,40):20 to 39;[40,60):40 to 59;[60,80):60 to 79;[80,100):80 to 99;" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="BMI" disabled="false" hasAll="false" allCaption="All BMI" allDisplayName="BMI" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="BMI Range" disabled="false" sourceProperty="BMI" list="false" rangeExpression="[0,20):0 to 20;[20,40):20 to 40;[40,60):40 to 60;[60,):60+;" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DPF" disabled="false" hasAll="false" allCaption="All DPF" allDisplayName="DPF" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="DPF Range" disabled="false" sourceProperty="DPF" list="false" rangeExpression="[0,0.5):0 to 0.5;[0.5,1.0):0.5 to 1.0;[1.0,1.5):1.0 to 1.5;[1.5,2.0):1.5 to 2.0;[2.0,2.5):2.0 to 2.5;[2.5,):2.5+;" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Diabetes" disabled="false" hasAll="false" allCaption="All Diabetes" allDisplayName="Diabetes" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Diagnosis" disabled="false" sourceProperty="Diabetes" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DiasBP" disabled="false" hasAll="false" allCaption="All DiasBP" allDisplayName="DiasBP" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="DiasBP" disabled="false" sourceProperty="DiasBP" list="false" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PlasmaGlucose" disabled="false" hasAll="false" allCaption="All PlasmaGlucose" allDisplayName="PlasmaGlucose" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="PlasmaGlucose Range" disabled="false" sourceProperty="PlasmaGlucose" list="false" rangeExpression="[0,50):0 to 49;[50,100):50 to 99;[100,150):100 to 149;[150,200):150 to 199;[200,):200+;" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Prediction" disabled="false" hasAll="false" allCaption="All Prediction" allDisplayName="Prediction" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Prediction" disabled="false" sourceProperty="Prediction" list="false" rangeExpression="[0,0.5):Low Risk;[0.5,1]:High Risk;" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Pregnant" disabled="false" hasAll="false" allCaption="All Pregnant" allDisplayName="Pregnant" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Pregnant" disabled="false" sourceProperty="Pregnant" list="false" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="SerumInsulin" disabled="false" hasAll="false" allCaption="All SerumInsulin" allDisplayName="SerumInsulin" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="SerumInsulin Range" disabled="false" sourceProperty="SerumInsulin" list="false" rangeExpression="[0,200):0 to 199;[200,400):200 to 399;[400,600):400 to 599;[600,800):600 to 799;[800,):800+;" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TricepsSkin" disabled="false" hasAll="false" allCaption="All TricepsSkin" allDisplayName="TricepsSkin" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TricepsSkin Range" disabled="false" sourceProperty="TricepsSkin" list="false" rangeExpression="[0,20):0 to 19;[20,40):20 to 39;[40,60):40 to 59;[60,80):60 to 79;[80,100):80 to 99;[100,):100+;" useDisplayValue="true" sort="asc numeric" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <listing name="Default Listing" disabled="false" listingType="table" fieldList="Age,BMI,DPF,Diabetes,DiasBP,PlasmaGlucose,Prediction,Pregnant,SerumInsulin,TricepsSkin">
  </listing>
</cube>
}

Parameter DOMAIN;

}

