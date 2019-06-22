Class R.Test.RData Extends %RegisteredObject
{

ClassMethod Vector(type = "Double")
{
	Set x = 6, x(1) = 1, x(2) = 2, x(3) = 3, x(4) = 4, x(5) = 5, x(6) = 6
	
	Set rd = ##class(R.Msg.RData).%New()
	Set rd.Class = "Vector", rd.Type = type
	Do rd.SetVector(.x)
	Do rd.XMLExportToString(.s)
	W s, !
	
	Set sc = rd.ToREXP(.re)
	W re.toDebugString(), !
	Set rd1 = ##class(R.Msg.RData).%New()
	Set sc = rd1.FromREXP(.re)
	Do rd1.XMLExportToString(.s)
	W s, !
}

ClassMethod Matrix(type = "Double")
{
	Set x = 3, x(1) = 2, x(2) = 2, x(3) = 2, x(1,1) = 1, x(1,2) = 2, x(2,1) = 3, x(2,2) = 4, x(3,1) = 5, x(3,2) = 6
	
	Set rd = ##class(R.Msg.RData).%New()
	Set rd.Class = "Matrix", rd.Type = type
	Do rd.SetMatrix(.x)
	Do rd.XMLExportToString(.s)
	W s, !
	
	Set sc = rd.ToREXP(.re)
	W re.toDebugString(), !
	Set rd1 = ##class(R.Msg.RData).%New()
	Set sc = rd1.FromREXP(.re)
	Do rd1.XMLExportToString(.s)
	W s, !
}

ClassMethod Factor()
{
	Set x(1) = "Male", x(2) = "Female", x(3) = "Male"
	Set rd = ##class(R.Msg.RData).%New()
	Set rd.Class = "Factor"
	Do rd.SetFactor(.x)
	Do rd.XMLExportToString(.s)
	W s, !
	Do rd.GetFactor(.x1)
	ZW x1
	
	Set sc = rd.ToREXP(.re)
	W re.toDebugString(), !
	Set rd1 = ##class(R.Msg.RData).%New()
	Set sc = rd1.FromREXP(.re)
	Do rd1.XMLExportToString(.s1)
	W s1, !
	Do rd1.GetFactor(.x2)
	ZW x2
}

ClassMethod List()
{
	Set x("Age", "Type") = "Integer", x("Age", "Length") = 3, x("Age",1)=10, x("Age",2)=20, x("Age",3)=30
	Set x("Name","Type")="String", x("Name","Length")=2, x("Name",1)="aaa", x("Name",2)="bbb"
	Set x("Salary","Type")="Double", x("Salary","Length")=1, x("Salary",1)=10000.99
	
	Set rd = ##class(R.Msg.RData).%New()
	Set rd.Class = "List"
	Do rd.SetList(.x)
	Do rd.XMLExportToString(.s)
	W s, !
	Do rd.GetList(.x1)
	ZW x1
	
	Set sc = rd.ToREXP(.re)
	W re.toDebugString(), !
	Set rd1 = ##class(R.Msg.RData).%New()
	Set sc = rd1.FromREXP(.re)
	Do rd1.XMLExportToString(.s1)
	W s1, !
	Do rd1.GetList(.x2)
	ZW x2
}

ClassMethod DataFrame()
{
	Set x("Age", "Type") = "Integer", x("Age", "Length") = 3, x("Age",1)=10, x("Age",2)=20, x("Age",3)=30
	Set x("Name","Type")="String", x("Name","Length")=3, x("Name",1)="aaa", x("Name",2)="bbb", x("Name",3)="ccc"
	Set x("Salary","Type")="Double", x("Salary","Length")=3, x("Salary",1)=10000.11, x("Salary",2)=20000.22, x("Salary",3)=30000.33
	
	Set rd = ##class(R.Msg.RData).%New()
	Set rd.Class = "DataFrame"
	Do rd.SetDataFrame(.x)
	Do rd.XMLExportToString(.s)
	W s, !
	Do rd.GetDataFrame(.x1)
	ZW x1
	
	Set sc = rd.ToREXP(.re)
	W re.toDebugString(), !
	W re.payload.names.GetAt(1), re.payload.names.GetAt(2), !
	W re.payload.size(), !
	Set rd1 = ##class(R.Msg.RData).%New()
	Set sc = rd1.FromREXP(.re)
	Do rd1.XMLExportToString(.s1)
	W s1, !
	Do rd1.GetList(.x2)
	ZW x2
}

ClassMethod Raw()
{
	Set rd = ##class(R.Msg.RData).%New()
	Set rd.Class = "Raw"
	D rd.RawValue.Write("abcdef")
	Do rd.XMLExportToString(.s)
	W s, !
	
	Set sc = rd.ToREXP(.re)
	W re.toDebugString(), !
	Set rd1 = ##class(R.Msg.RData).%New()
	Set sc = rd1.FromREXP(.re)
	Do rd1.XMLExportToString(.s1)
	W s1, !
}

}

