Class R.Demo.ModelBuildProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="R.Demo.ModelBuild" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="R.Demo.ModelBuildBPL" Category="" ClassName="R.Demo.ModelBuildBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="R.Ens.Operation" Category="" ClassName="R.Ens.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}

