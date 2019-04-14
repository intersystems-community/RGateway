Class R.REXP Extends %RegisteredObject
{

/// Carriage return
Parameter CR = {$CHAR(10,13)};

/// NA string
Parameter NAString = {$CHAR(255)};

/** specifies how many items of a vector or list will be displayed in {@link #toDebugString} */
Parameter maxDebugItems As %Integer = 32;

/** attribute list. This attribute should never be accessed directly. */
Property attr As REXPList;

/// attr As REXPList
Method %OnNew(attr = "") As %Status
{
	Set ..attr = attr
	Quit $$$OK
}

// type checks

/** check whether the <code>REXP</code> object is a character vector (string)
	 @return <code>true</code> if the receiver is a character vector, <code>false</code> otherwise */
Method isString() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a numeric vector
	 @return <code>true</code> if the receiver is a numeric vector, <code>false</code> otherwise */
Method isNumeric() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is an integer vector
	 @return <code>true</code> if the receiver is an integer vector, <code>false</code> otherwise */
Method isInteger() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is NULL
	 @return <code>true</code> if the receiver is NULL, <code>false</code> otherwise */
Method isNull() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a factor
	 @return <code>true</code> if the receiver is a factor, <code>false</code> otherwise */
Method isFactor() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a list (either generic vector or a pairlist - i.e. {@link #asList() As %Boolean} will succeed)
	 @return <code>true</code> if the receiver is a generic vector or a pair-list, <code>false</code> otherwise */
Method isList() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a pair-list
	 @return <code>true</code> if the receiver is a pair-list, <code>false</code> otherwise */
Method isPairList() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a logical vector
	 @return <code>true</code> if the receiver is a logical vector, <code>false</code> otherwise */
Method isLogical() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is an environment
	 @return <code>true</code> if the receiver is an environment, <code>false</code> otherwise */
Method isEnvironment() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a language object
	 @return <code>true</code> if the receiver is a language object, <code>false</code> otherwise */
Method isLanguage() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is an expression vector
	 @return <code>true</code> if the receiver is an expression vector, <code>false</code> otherwise */
Method isExpression() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a symbol
	 @return <code>true</code> if the receiver is a symbol, <code>false</code> otherwise */
Method isSymbol() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a vector
	 @return <code>true</code> if the receiver is a vector, <code>false</code> otherwise */
Method isVector() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a raw vector
	 @return <code>true</code> if the receiver is a raw vector, <code>false</code> otherwise */
Method isRaw() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a complex vector
	 @return <code>true</code> if the receiver is a complex vector, <code>false</code> otherwise */
Method isComplex() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a recursive obejct
	 @return <code>true</code> if the receiver is a recursive object, <code>false</code> otherwise */
Method isRecursive() As %Boolean
{
 	Quit 0
}

/** check whether the <code>REXP</code> object is a reference to an R object
	 @return <code>true</code> if the receiver is a reference, <code>false</code> otherwise */
Method isReference() As %Boolean
{
	Quit 0
}

Method toJSON() As %DynamicObject
{
	Quit ""
}

Method getJSON() As %DynamicObject
{
	Set d = ##class(%DynamicObject).%New()
	Set d.classname = ..%ClassName(1)
	Set d.attr = $S(..attr="":"",1:..attr.toJSON())
	Set d.data = ..toJSON()
	Quit d
}

Method toString() As %String
{
	Quit ..%ClassName(0)_$S(..attr="":"",1:"<"_..attr.toString()_">")
}

Method toDebugString() As %String
{
	Set d = ..getJSON()
	Quit d.%ToJSON()
}

Method print(level As %Integer = 0, json As %DynamicAbstractObject = "")
{
	Set:json="" json = ..getJSON()
	Set iter = json.%GetIterator()
	While iter.%GetNext(.key, .value) {
		Write ?(level*4),key,": "
		Set type = json.%GetTypeOf(key)
		If "string"=type {
			Write """", value, """"
		}
		ElseIf ("boolean"=type) || ("number"=type) {
			Write value
		}
		ElseIf "null"=type {
			Write "''"
		}
		ElseIf "object"=type {
			Write !
			Do ..print(level+1, value)
		}
		ElseIf "array"=type {
			Write !
			Write "["
			Do ..print(level+1, value)
			Write "]"
		}
		ElseIf "oref"=type {
			Write value
		}
		Else {
			Write "'unassigned'"
		}
		Write !
	}
}

// basic accessor methods

/** returns the contents as an array of Strings (if supported by the represented object) */
Method asStrings() As %ListOfDataTypes
{
 	Throw ##class(REXPMismatchException).%New($this,"String")
}

/** returns the contents as an array of integers (if supported by the represented object) */
Method asIntegers() As %ListOfDataTypes
{
 	Throw ##class(REXPMismatchException).%New($this, "int")
}

/** returns the contents as an array of doubles (if supported by the represented object) */
Method asDoubles() As %ListOfDataTypes
{
 	Throw ##class(REXPMismatchException).%New($this, "double")
}

/** returns the contents as an array of bytes (if supported by the represented object) */
Method asBytes() As %Stream.GlobalBinary
{
 	Throw ##class(REXPMismatchException).%New($this, "byte")
}

/** returns the contents as a (named) list (if supported by the represented object) */
Method asList() As RList
{
 	Throw ##class(REXPMismatchException).%New($this, "list")
}

/** returns the contents as a factor (if supported by the represented object) */
Method asFactor() As RFactor
{
 	Throw ##class(REXPMismatchException).%New($this, "factor")
}

/** attempt to represent the REXP by a native Java object and return it. Note that this may lead to loss of information (e.g., factors may be returned as a string array) and attributes are ignored. Not all R types can be converted to native Java objects. Also note that R has no concept of scalars, so vectors of length 1 will always be returned as an arrays (i.e., <code>int[1]</code> and not <code>Integer</code>). */
Method asNativeObject() As %RegisteredObject
{
 	Throw ##class(REXPMismatchException).%New($this, "native Object")
}

/// set the contents as a Cache array
/// a = length
/// data: a(1), a(2), ...
Method asCArray(ByRef a)
{
	Throw ##class(REXPMismatchException).%New($this, "global")
}

/** returns the length of a vector object. Note that we use R semantics here, i.e. a matrix will have a length of <i>m * n</i> since it is represented by a single vector (see {@link #dim} for retrieving matrix and multidimentional-array dimensions).
	 * @return length (number of elements) in a vector object
	 * @throws REXPMismatchException if this is not a vector object */
Method length() As %Integer
{
	Throw ##class(REXPMismatchException).%New($this, "vector")
}

/** returns a boolean vector of the same length as this vector with <code>true</code> for NA values and <code>false</code> for any other values
	 *  @return a boolean vector of the same length as this vector with <code>true</code> for NA values and <code>false</code> for any other values
	 * @throws REXPMismatchException if this is not a vector object */
Method isNA() As %ListOfDataTypes
{
	Throw ##class(REXPMismatchException).%New($this, "vector")
}

// convenience accessor methods

/** convenience method corresponding to <code>asIntegers()[0]</code>
	 @return first entry returned by {@link #asInteger} */
Method asInteger() As %Integer
{
	Set i = ..asIntegers()
	Quit i.GetAt(1)
}

/** convenience method corresponding to <code>asDoubles()[0]</code>
	 @return first entry returned by {@link #asDoubles} */
Method asDouble() As %Double
{
	Set d = ..asDoubles()
	Quit d.GetAt(1)
}

/** convenience method corresponding to <code>asStrings()[0]</code>
	 @return first entry returned by {@link #asStrings} */
Method asString() As %String
{
	Set s = ..asStrings()
	Quit s.GetAt(1)
}

// methods common to all REXPs

/** retrieve an attribute of the given name from this object
	 * @param name attribute name
	 * @return attribute value or <code>null</code> if the attribute does not exist */
Method getAttribute(name As %String) As REXP
{
	#Dim a AS REXPList = ..attr
	If (a="") || ('a.isList()) Quit ""
	Quit a.asList().atKey(name)
}

/** checks whether this obejct has a given attribute
	 * @param name attribute name
	 * @return <code>true</code> if the attribute exists, <code>false</code> otherwise */
Method hasAttribute(name As %String) As %Boolean
{
	#Dim a AS REXPList = ..attr
	Quit (a'="") && a.isList() && (a.asList().atKey(name)'="")
}

// helper methods common to all REXPs

/** returns dimensions of the object (as determined by the "<code>dim</code>" attribute)
	 * @return an array of integers with corresponding dimensions or <code>null</code> if the object has no dimension attribute */
Method dim() As %ListOfDataTypes
{
	Try {
		If ..hasAttribute("dim") {
			Return ..attr().asList().atKey("dim").asIntegers()
		}
		Else {
			Return "" 
		}
	}
	Catch (e) {}
	Return ""
}

/** determines whether this object inherits from a given class in the same fashion as the <code>inherits()</code> function in R does (i.e. ignoring S4 inheritance)
	 * @param klass class name
	 * @return <code>true</code> if this object is of the class <code>klass</code>, <code>false</code> otherwise */
Method inherits(klass As %String) As %Boolean
{
	If ('..hasAttribute("class")) Return 0
	Try {
		#Dim c As %ListOfDataTypes = ..getAttribute("class").asStrings()
		For i=1:1:c.Count()
		{
			Set v = c.GetAt(i)
			If (v'="" && v=klass) Return 1
		}
	}
	Catch (e) {}
	Return 0
}

// ======= complex convenience methods

/** returns the content of the REXP as a matrix of doubles (2D-array: m[rows][cols]). This is the same form as used by popular math packages for Java, such as JAMA. This means that following leads to desired results:<br>
	 <code>Matrix m=new Matrix(c.eval("matrix(c(1,2,3,4,5,6),2,3)").asDoubleMatrix());</code><br>
	 @return 2D array of doubles in the form double[rows][cols] or <code>null</code> if the contents is no 2-dimensional matrix of doubles */
/// matrix: row count; mat(i): col count for row i
/// matrix(i,j): value of ith row and jth col
Method asDoubleMatrix(Output matrix)
{
	Set ct = ..asDoubles()
	Set dim = ..getAttribute("dim")
	If (dim = "") Throw ##class(REXPMismatchException).%New($this, "matrix (dim attribute missing)")
	Set ds = dim.asIntegers()
	If (ds.Count()'= 2) Throw ##class(REXPMismatchException).%New($this, "matrix (wrong dimensionality)")
	Set m = ds.GetAt(1), n = ds.GetAt(2)
		
	// R stores matrices as matrix(c(1,2,3,4),2,2) = col1:(1,2), col2:(3,4)
	// It is always by col
	// we need to copy everything, since we create 2d array from 1d array
	Set matrix = m
	For i=1:1:m { set matrix(i) = n }
	Set k = 1
	For j = 1:1:n {
		For i=1:1:m {
			set matrix(i,j) = ct.GetAt(k)
			Set k = $I(k)
		}
	}
}

/** creates a REXP that represents a double matrix in R based on matrix of doubles (2D-array: m[rows][cols]). This is the same form as used by popular math packages for Java, such as JAMA. The result of this function can be used in {@link REngine.assign} to store a matrix in R.
	 @param matrix array <code>double[rows][colums]</code> containing the matrix to convert into a REXP. If <code>matrix</code> is <code>null</code> or either of the dimensions is 0 then the resulting matrix will have the dimensions <code>0 x 0</code> (Note: Java cannot represent <code>0 x n</code> matrices for <code>n &gt; 0</code>, so special matrices with one dimension of 0 can only be created by setting dimensions directly).
	 @return <code>REXPDouble</code> with "dim" attribute which constitutes a matrix in R */
/// matrix: row count; mat(i): col count for row i
/// matrix(i,j): value of ith row and jth col	 
ClassMethod createDoubleMatrix(ByRef matrix) As REXP
{
	Set a = ##class(%ListOfDataTypes).%New() // double array
	Set m = $G(matrix)
	Set n =$G(matrix(1)) // cols
	For j=1:1:n {
		For i=1:1:m {
			Do a.Insert($G(matrix(i,j)))
		}
	}
	
	Set ia = ##class(%ListOfDataTypes).%New() // int array
	Do ia.Insert(m), ia.Insert(n)
	
	Set dim = ##class(%ListOfDataTypes).%New() // dim array
	Do dim.Insert("dim")
	
	Set contents = ##class(%ListOfObjects).%New()
	Do contents.Insert(##class(REXPInteger).%New(ia))
	
	Set attr = ##class(REXPList).%New(##class(RList).%New(contents,dim))
	
	Quit ##class(REXPDouble).%New(a,attr)
}

// ======= tools

/** creates a data frame object from a list object using integer row names
	 *  @param l a (named) list of vectors ({@link REXPVector} subclasses), each element corresponds to a column 
	 and all elements must have the same length
	 *  @return a data frame object
	 *  @throws REXPMismatchException if the list is empty or any of the elements is not a vector */
ClassMethod createDataFrame(l As RList) As REXP
{
	If (l="") || (l.size() < 1) Throw ##class(REXPMismatchException).%New(##class(REXPList).%New(l),"data frame (must have dim>0)")
	If '(l.at(1).%IsA("R.REXPVector")) Throw ##class(REXPMismatchException).%New(##class(REXPList).%New(l),"data frame (contents must be vectors)")

	#Dim fe As REXPVector = l.at(1)
	
	Set ia = ##class(%ListOfDataTypes).%New()
	Do ia.Insert(##class(REXPInteger).#NA), ia.Insert(-fe.length())
	
	Set contents = ##class(%ListOfObjects).%New()
	Do contents.Insert(##class(REXPString).%New("data.frame"))
	Do contents.Insert(##class(REXPString).%New(l.keys()))
	Do contents.Insert(##class(REXPInteger).%New(ia))
	
	Set names = ##class(%ListOfDataTypes).%New()
	Do names.Insert("class"), names.Insert("names"), names.Insert("row.names")
	
	Set attr = ##class(REXPList).%New(##class(RList).%New(contents,names))
	
	Quit ##class(REXPGenericVector).%New(l,attr)
}

ClassMethod asCall(what As REXP, args As %ListOfObjects) As REXP
{
	Set l = ##class(RList).%New()
	Do l.add(what)
	For i=1:1:args.Count() {
		Do l.add(args.GetAt(i))
	}
	Quit ##class(REXPLanguage).%New(l)
}

ClassMethod asCall1(what As REXP, arg1 As REXP) As REXP
{
	Set contents = ##class(%ListOfObjects).%New()
	Do contents.Insert(what)
	Do contents.Insert(arg1)
	Quit ##class(REXPLanguage).%New(##class(RList).%New(contents))
}

ClassMethod asCall2(what As REXP, arg1 As REXP, arg2 As REXP) As REXP
{
	Set contents = ##class(%ListOfObjects).%New()
	Do contents.Insert(what)
	Do contents.Insert(arg1), contents.Insert(arg2)
	Quit ##class(REXPLanguage).%New(##class(RList).%New(contents))
}

ClassMethod asCall3(what As REXP, arg1 As REXP, arg2 As REXP, arg3 As REXP) As REXP
{
	Set contents = ##class(%ListOfObjects).%New()
	Do contents.Insert(what)
	Do contents.Insert(arg1), contents.Insert(arg2), contents.Insert(arg3)
	Quit ##class(REXPLanguage).%New(##class(RList).%New(contents))
}

ClassMethod asCallString(name As %String, args As %ListOfObjects) As REXP
{
	Quit ..asCall(##class(REXPSymbol).%New(name),args)
}

ClassMethod asCallString1(name As %String, arg1 As REXP) As REXP
{
	Set contents = ##class(%ListOfObjects).%New()
	Do contents.Insert(##class(REXPSymbol).%New(name))
	Do contents.Insert(arg1)
	Quit ##class(REXPLanguage).%New(##class(RList).%New(contents))
}

ClassMethod asCallString2(name As %String, arg1 As REXP, arg2 As REXP) As REXP
{
	Set contents = ##class(%ListOfObjects).%New()
	Do contents.Insert(##class(REXPSymbol).%New(name))
	Do contents.Insert(arg1), contents.Insert(arg2)
	Quit ##class(REXPLanguage).%New(##class(RList).%New(contents))
}

ClassMethod asCallString3(name As %String, arg1 As REXP, arg2 As REXP, arg3 As REXP) As REXP
{
	Set contents = ##class(%ListOfObjects).%New()
	Do contents.Insert(##class(REXPSymbol).%New(name))
	Do contents.Insert(arg1), contents.Insert(arg2), contents.Insert(arg3)
	Quit ##class(REXPLanguage).%New(##class(RList).%New(contents))
}

/// d: one dimension array
/// d = length, d(1), d(2) ... = values 
ClassMethod createDouble(ByRef d) As REXPDouble
{
	set payload = ##class(%ListOfDataTypes).%New()
	for i=1:1:$G(d) {
		do payload.Insert($G(d(i)))
	}
	quit ##class(REXPDouble).%New(payload)
}

ClassMethod createDataFrameFromSQL(sql As %String, Output pSC) As REXP
{
	Set df = ""
	Try {
		#Dim tResultSet As %SQL.StatementResult = ##class(%SQL.Statement).%ExecDirect(,.sql)
		#Dim tMeta As %SQL.StatementMetadata = tResultSet.%GetMetadata()
		Set list = ##class(%ListOfObjects).%New()
		Set tCount = tMeta.columns.Count()
		For i=1:1:tCount {
			Set tColumn = tMeta.columns.GetAt(i)
			Set tName = tColumn.colName
			Set tType = tColumn.ODBCType
			W !, tName, tType
			Do list.Insert(##class(%ListOfDataTypes).%New())
		}
		
		// Populate list
 		While tResultSet.%Next() {
	 		For i=1:1:tCount {
		 		Set tColumn = tMeta.columns.GetAt(i)
				Set tName = tColumn.colName
		 		Do list.GetAt(i).Insert(tResultSet.%Get(tName))
	 		}
 		}
 		
 		// Populate RList
 		Set rlist = ##class(R.RList).%New()
 		For i=1:1:tCount {
			Set tColumn = tMeta.columns.GetAt(i)
			Set tType = tColumn.ODBCType
			Set tName = tColumn.colName
			If (tType=4) || (tType=5) || (tType=-6) || (tType=-5){
				Do rlist.put(tName, ##class(R.REXPInteger).%New(list.GetAt(i)))
			}
			ElseIf (tType=2) || (tType=3) || (tType=6) || (tType=7) || (tType=8) {
				Do rlist.put(tName, ##class(R.REXPDouble).%New(list.GetAt(i)))
			}
			Else {
				Do rlist.put(tName, ##class(R.REXPString).%New(list.GetAt(i)))
			}
		}
 		
 		Set df = ##class(R.REXP).createDataFrame(rlist)
	}
	Catch (ex)
	{
		Set pSC = ex.AsStatus()
		Set df = ""
	}
	Quit df
}

}

