Class R.Demo.ModelScoreProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="R.Demo.ModelScoreProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="EnsLib.RecordMap.Service.FileService" Category="" ClassName="EnsLib.RecordMap.Service.FileService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="R.Demo.ModelScoreBPL" Category="" ClassName="R.Demo.ModelScoreBPL" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="R.Demo.ScoreOperation" Category="" ClassName="R.Demo.ScoreOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}

