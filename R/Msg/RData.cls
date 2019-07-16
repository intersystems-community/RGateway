/// R data type embedded as message
Class R.Msg.RData Extends (%SerialObject, %XML.Adaptor)
{

/// Data class
Property Class As %String(VALUELIST = ",Vector,Matrix,Factor,List,DataFrame,Raw,Unknown");

/// Data type. Only applicable when Class is Vector or Matrix
Property Type As %String(VALUELIST = ",Double,String,Integer,Logical,Unknown");

/// Used when Class is Matrix or Factor
/// Matrix: Attributes(1) - number of rows; Attributes(2) - number of columns
/// Factor: Attributes(1) - index base; Attributes(1+) - level strings
Property Attributes As list Of %String(MAXLEN = "");

/// Flattened values of R data type
/// Matrix: col first flattened values (default setting for R)
/// Factor: integer values for levels
/// List: Name, Type, Length followed by values, then repeat for additional lists
/// DataFrame: Name, Type, Length followed by values, then repeat for additional lists
Property Values As list Of %String(MAXLEN = "");

/// Raw binary stream value when the class is "Raw"
Property RawValue As %Stream.GlobalBinary;

/// Set vector values basing on multidimensional array
/// v(1), v(2), ... are values
Method SetVector(ByRef v)
{
	Set k = $O(v(""))
	While k'="" {
		Do ..Values.Insert($G(v(k)))
		Set k = $O(v(k))
	}
}

/// Get vector values as multidimensional array
/// v = length
/// v(1), v(2), ... are values
Method GetVector(ByRef v)
{
	Set len = ..Values.Count()
	Set v = len
	For i=1:1:len {
		Set v(i) = ..Values.GetAt(i)
	}
}

/// Set a scalar value. A special case of vector (length=1)
Method SetScalar(v As %String)
{
	Do ..Values.Insert(v)
}

/// Get a scalar value. Special case of vector (length = 1)
Method AsScalar() As %String
{
	Quit ..Values.GetAt(1)
}

/// Set matrix attributes and values basing on multidimensional array matrix
/// matrix: row count; matrix(i): col count for row i
/// matrix(i,j): value of ith row and jth col
/// Note: R matrix is col first by default
Method SetMatrix(ByRef matrix)
{
	Set m = $G(matrix) // rows
	Set n = $G(matrix(1)) // cols
	Do ..Attributes.Insert(m), ..Attributes.Insert(n)
	For j=1:1:n {
		For i=1:1:m {
			Do ..Values.Insert($G(matrix(i,j)))
		}
	}
}

/// Get matrix values as multidimensional array matrix
/// matrix: row count; matrix(i): col count for row i
/// matrix(i,j): value of ith row and jth col
/// Note: R matrix is col first by default
Method GetMatrix(ByRef matrix)
{
	Set m = ..Attributes.GetAt(1) // rows
	Set n = ..Attributes.GetAt(2) // cols
	Set matrix = m
	Set k = 1
	For j=1:1:n {
		For i=1:1:m {
			Set matrix(i) = n
			Set matrix(i, j) = ..Values.GetAt(k)
			Set k = k+1
		}
	}
}

/// Set factor attributes and values basing on mutldimensional array
/// f(1), f(2), ...: level symbol values (strings)
Method SetFactor(ByRef f, indexbase As %Integer = 1)
{
	Do ..Attributes.Insert(indexbase)
	Set i = $O(f(""))
	While i'="" {
		Set l = $G(f(i))
		Set j = ..Attributes.Find(l)
		Set k = 0
		If j="" { // Not find
			Do ..Attributes.Insert(l)
			Set k = ..Attributes.Count() + indexbase - 2 // level integer
		}
		Else {
			Set k = j + indexbase - 2
		}
		Do ..Values.Insert(k)
		Set i = $O(f(i))
	}
}

/// Get factor attributes and values as multidimensional array
/// f: indexbase, level symbol 1, level symbol 2, ... (comma delimited string)
/// f(1), f(2), ...: level integer values
Method GetFactor(ByRef f)
{
	Set attr = ""
	Set len = ..Attributes.Count()
	For i=1:1:len {
		Set $LIST(attr,*+1) = ..Attributes.GetAt(i)
	}
	Set f = $LTS(attr, ",")
	
	Set len = ..Values.Count()
	For i=1:1:len {
		Set f(i) = ..Values.GetAt(i)
	}
}

/// Set list values basing on mutlidimensional array
/// l(name, "Type") = type
/// l(name, "Length") = length
/// l(name,1), df(name, 2), ... are values
Method SetList(ByRef l)
{
	Set name = $O(l(""))
	While name'="" {
		Set type = $G(l(name, "Type"))
		Set len = $G(l(name, "Length"))
		Do ..Values.Insert(name), ..Values.Insert(type), ..Values.Insert(len)
		// Values
		For i=1:1:len {
			Do ..Values.Insert($G(l(name,i)))
		}
		Set name = $O(l(name))
	}
}

/// Get list values as mutlidimensional array
/// l(name, "Type") = type
/// l(name, "Length") = length
/// l(name,1), df(name, 2), ... are values
Method GetList(ByRef l)
{
	Set size = ..Values.Count()
	Set i = 1
	Do {
		Set name = ..Values.GetAt(i), i = i+1
		Set type = ..Values.GetAt(i), i = i+1
		Set len = ..Values.GetAt(i), i = i+1
		Set l(name, "Type") = type, l(name, "Length") = len
		For j=1:1:len {
			Set l(name, j) = ..Values.GetAt(i)
			Set i = i+1
		}
	}
	While (i<size)
}

/// Set data frame values basing on multidimensional array df
/// This is a special case of List (column sizes are same)
/// df(name, "Type") = type
/// df(name, "Length") = length
/// df(name,1), df(name, 2), ... are values
Method SetDataFrame(ByRef df)
{
	Do ..SetList(.df)
}

/// Get data frame values as multidimensional array df
/// df(name, "Type") = type
/// df(name, "Length") = length
/// df(name,1), df(name, 2), ... are values
Method GetDataFrame(ByRef df)
{
	Do ..GetList(.df)
}

/// Convert ..Values to a RList
Method GetRList() As R.RList
{
	Set rlist = ##class(R.RList).%New()
	Set size = ..Values.Count()
	Set k = 1
	Do {
		Set name = ..Values.GetAt(k), k = k+1
		Set type = ..Values.GetAt(k), k = k+1
		Set len = ..Values.GetAt(k), k = k+1
		Set value = ##class(%ListOfDataTypes).%New()
		For i=1:1:len {
			Do value.Insert(..Values.GetAt(k))
			Set k = k+1
		}
		Do rlist.put(name, $CASE(type,
							"Double":##class(R.REXPDouble).%New(value),
							"String":##class(R.REXPString).%New(value),
							"Integer":##class(R.REXPInteger).%New(value),
							"Logical":##class(R.REXPLogical).%New(value),
							:""))
	}
	While (k<size)
	Quit rlist
}

/// Set Class and Attributes properties
Method SetClassAttributes(ByRef rexp As R.REXP)
{
	Set dim = rexp.dim()
	If dim="" { // Vector
		Set ..Class = "Vector"
	}
	Else { 
		Set len = dim.Count()
		If len=2  { // Matrix
			Set ..Class = "Matrix"
		}
		Else {
			Set ..Class = "Unknown"
		}
		For i=1:1:len {
			Do ..Attributes.Insert(dim.GetAt(i))
		}
	}
}

/// Convert internal RData to R.REXP
Method ToREXP(Output rexp As R.REXP) As %Status
{
	Set tSC = $$$OK
	Try {
		Set rexp = ""
		If ..Class="Vector" {
			Do ..GetVector(.v)
			Set rexp = ##class(R.REXP).createVector(.v, ..Type)
		}
		ElseIf ..Class="Matrix" {
			Do ..GetMatrix(.m)
			Set rexp = ##class(R.REXP).createMatrix(.m, ..Type)
		}
		ElseIf ..Class="Factor" {
			Do ..GetFactor(.f)
			Set l = $LFS($G(f), ",")
			Set indexbase = $LG(l, 1)
			Set levels = ##class(%ListOfDataTypes).%New()
			For i=2:1:$LL(l) {
				Do levels.Insert($LG(l,i))
			}
			Set ids = ##class(%ListOfDataTypes).%New()
			Set j = $O(f(""))
			While j'="" {
				Do ids.Insert($G(f(j)))
				Set j = $O(f(j))
			}
			Set rf = ##class(R.RFactor).%New(levels, indexbase,ids)
			Set rexp = ##class(R.REXPFactor).%New(rf)
		}
		ElseIf ..Class="List" {
			Set rlist = ..GetRList()
			Set rexp = ##class(R.REXPList).%New(rlist)
		}
		ElseIf ..Class="DataFrame" {
			Set rlist = ..GetRList()
			Set rexp = ##class(R.REXP).createDataFrame(rlist)
		}
		ElseIf ..Class="Raw" {
			Set rexp = ##class(R.REXPRaw).%New(..RawValue)
		}
		
		If rexp="" {
			Set tSC = $$$ERROR($$$GeneralError, "Unknown data class or type")
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Convert R.REXP to internal RData
Method FromREXP(rexp As R.REXP) As %Status
{
	Set tSC = $$$OK
	Try {
		If rexp.%IsA("R.REXPFactor") { // REXPFactor is also a REXPInteger, need a short circuit here
			Set ..Type = ""
			Set ..Class = "Factor"
			Set rf = rexp.asFactor()
			Do ..Attributes.Insert(rf.indexbase)
			For i=1:1:rf.levels.Count() {
				Do ..Attributes.Insert(rf.levels.GetAt(i))
			}
			For i=1:1:rf.ids.Count() {
				Do ..Values.Insert(rf.ids.GetAt(i))
			}
		}
		ElseIf rexp.%IsA("R.REXPDouble") {
			Set ..Type = "Double"
			Do ..SetClassAttributes(.rexp)
			Set ..Values = rexp.asDoubles()
		}
		ElseIf rexp.%IsA("R.REXPString") {
			Set ..Type = "String"
			Do ..SetClassAttributes(.rexp)
			Set ..Values = rexp.asStrings()
		}
		ElseIf rexp.%IsA("R.REXPInteger") {
			Set ..Type = "Integer"
			Do ..SetClassAttributes(.rexp)
			Set ..Values = rexp.asIntegers()
		}
		ElseIf rexp.%IsA("R.REXPLogical") {
			Set ..Type = "Logical"
			Do ..SetClassAttributes(.rexp)
			Set ..Values = rexp.asIntegers()
		}
		ElseIf rexp.%IsA("R.REXPList") {
			Set ..Class = "List"
			Set ..Type = ""
			Set rl = rexp.asList()
			Set size = rl.size()
			For i=1:1:size {
				Set name = rl.keyAt(i)
				Set r = rl.at(i) // REXP
				If r.isInteger() {
					Set type = "Integer"
				}
				ElseIf r.isString() {
					Set type = "String"
				}
				ElseIf r.isNumeric() {
					Set type = "Double"
				}
				ElseIf r.isLogical() {
					Set type = "Logical"
				}
				Else {
					Set type = "Unknown"
				}
				Do ..Values.Insert(name), ..Values.Insert(type)
				Set value = r.asStrings()
				Set len = value.Count()
				Do ..Values.Insert(len)
				For j=1:1:len {
					Do ..Values.Insert(value.GetAt(j))
				} // For j
			} // For i
		}
		ElseIf rexp.%IsA("R.REXPGenericVector") {
			If rexp.isList() && rexp.hasAttribute("names") { // Dataframe
				Set ..Class = "DataFrame"
				Set ..Type = ""
			    Set attr = rexp.attr.asList()
			    Set names = attr.atKey("names").asStrings()
				Set rl = rexp.asList()
				Set size = rl.size()
				For i=1:1:size {
					Set name = names.GetAt(i)
					Set r = rl.at(i) // REXP
					If r.isInteger() { // isInteger is also isNumeric
						Set type = "Integer"
					}
					ElseIf r.isString() {
						Set type = "String"
					}
					ElseIf r.isNumeric() {
						Set type = "Double"
					}
					ElseIf r.isLogical() {
						Set type = "Logical"
					}
					Else {
						Set type = "Unknown"
					}
					Do ..Values.Insert(name), ..Values.Insert(type)
					Set value = r.asStrings()
					Set len = value.Count()
					Do ..Values.Insert(len)
					For j=1:1:len {
						Do ..Values.Insert(value.GetAt(j))
					} // For j
				} // For i
			}
			Else {
				Set ..Class = "Unknown"
			}
		}
		ElseIf rexp.%IsA("R.REXPRaw") {
			Set ..Class = "Raw"
			Set ..Type = ""
			Set ..RawValue = rexp.asBytes()
		}
		Else {
			Set ..Class = "Unknown"
		}
	}
	Catch (ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

Storage Default
{
<Data name="RDataState">
<Value name="1">
<Value>Class</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Attributes</Value>
</Value>
<Value name="4">
<Value>Values</Value>
</Value>
<Value name="5">
<Value>RawValue</Value>
</Value>
</Data>
<State>RDataState</State>
<StreamLocation>^R.Msg.RDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

