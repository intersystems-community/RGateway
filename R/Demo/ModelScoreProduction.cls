Class R.Demo.ModelScoreProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="R.Demo.ModelScoreProduction" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="EnsLib.RecordMap.Service.FileService" Category="" ClassName="EnsLib.RecordMap.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="WorkPath"></Setting>
    <Setting Target="Host" Name="RecordMap">R.Demo.PimaRecordMap</Setting>
    <Setting Target="Host" Name="TargetConfigNames">R.Demo.ModelScoreBPL</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\InterSystems\IRIS1811\Mgr\Temp\r\</Setting>
  </Item>
  <Item Name="R.Demo.ModelScoreBPL" Category="" ClassName="R.Demo.ModelScoreBPL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="R.Demo.ScoreOperation" Category="" ClassName="R.Demo.ScoreOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}

