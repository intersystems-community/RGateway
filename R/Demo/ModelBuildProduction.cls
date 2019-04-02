Class R.Demo.ModelBuildProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="R.Demo.ModelBuildProduction" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="R.Demo.ModelBuildBPL" Category="" ClassName="R.Demo.ModelBuildBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="R.Ens.Operation" Category="" ClassName="R.Ens.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
</Production>
}

}

