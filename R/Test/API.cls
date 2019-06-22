Class R.Test.API Extends %RegisteredObject
{

ClassMethod Connection()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
	}
	catch (e) {
		w e.Data, !
		s sc = e.AsStatus()
		do $system.Status.DisplayError(sc)
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Eval()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		#dim r as R.REXP = c.eval("R.version.string")
		w r.asString(), !
		w r.toString(), !
		w r.toDebugString(), !
		d r.print()
		
		// string array
		set r = c.eval("x<-c(""hello"",""world"")")
		w r.toString(), !
		w r.toDebugString(), !
		set r = c.get("x")
		w r.toString(), !
		w r.toDebugString(), !
		d r.print()
		
		// int array
		set r = c.eval("x<-as.integer(c(1,2, NA))")
		w r.toString(), !
		w r.toDebugString(), !
		set r = c.get("x")
		w r.toString(), !
		w r.toDebugString(), !
		
		// double array
		set r = c.eval("x<-c(1,2, NA)")
		w r.toString(), !
		w r.toDebugString(), !
		set r = c.get("x")
		w r.toString(), !
		w r.toDebugString(), !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Assign()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		do c.assignString("x", "abc")
		set r = c.get("x")
		w r.toString(), !
		w r.toDebugString(), !
		
		set s = ##class(%ListOfDataTypes).%New()
		do s.Insert("abc"), s.Insert("defgh")
		do c.assign("x", ##class(R.REXPString).%New(s))
		set r = c.get("x")
		w r.toString(), !
		w r.toDebugString(), !
		
		set s = ##class(%ListOfDataTypes).%New()
		do s.Insert(1), s.Insert(2), s.Insert(3)
		do c.assign("x", ##class(R.REXPInteger).%New(s))
		set r = c.get("x")
		w r.toString(), !
		w r.toDebugString(), !
		
		set s = ##class(%ListOfDataTypes).%New()
		do s.Insert(1), s.Insert(2), s.Insert("NAN")
		do c.assign("x", ##class(R.REXPDouble).%New(s))
		set r = c.get("x")
		w r.toString(), !
		w r.toDebugString(), !
		
		set s = ##class(%ListOfDataTypes).%New()
		do s.Insert(1), s.Insert(0), s.Insert(-128)
		do c.assign("x", ##class(R.REXPLogical).%New(s))
		set r = c.get("x")
		w r.toString(), !
		w r.toDebugString(), !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Matrix()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		
		#dim r as REXP = c.parseAndEval("x=matrix(c(1,2,3,4,5,6),2,3)")
		w r.toString(), !
		w r.toDebugString(), !
		w "isVector = ", r.isVector(), !
		do r.asMatrix(.m)
		//zw m
		
		#dim d as R.REXP = ##class(R.REXP).createMatrix(.m)
		w d.toString(), !
		w d.toDebugString(), !
		do c.assign("x", d)
		set r = c.get("x")
		w r.toString(), !
		w r.toDebugString(), !
		w "dim = ", r.dim().Count(), !
		
		set r  = c.parseAndEval("x=matrix(as.integer(c(1,2,3,4,5,6)),2,3)")
		w r.toString(), !
		w r.toDebugString(), !
		
		do r.asMatrix(.m)
		zw m
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Factor()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		
		set s = ##class(%ListOfDataTypes).%New()
        do s.Insert("foo"), s.Insert("bar"), s.Insert("foo"), s.Insert("foo"), s.Insert(""), s.Insert("bar")
        set rf = ##class(R.RFactor).%New(s)
        set f = ##class(R.REXPFactor).%New(rf)
        w f.toString(), !
        w "isVector = ", f.isVector(), !
		do c.assign("f", f)
		set f = c.parseAndEval("f")
		w f.toString(), !
		w f.toDebugString(), !
		
		// factors
        w !, "* Test support of factors", !
        set f = c.parseAndEval("factor(paste('F',as.integer(runif(20)*5),sep=''))")
		w "  f=", f.toString(), !
        w "  isFactor: ", f.isFactor(), !
        w "  asFactor: ", f.asFactor().toString(), !
        if ('f.isFactor()) || (f.asFactor() = "") w "factor test failed", !
        w "  singe-level factor used to degenerate:", !
        set f = c.parseAndEval("factor('foo')")
        w "  isFactor: ", f.isFactor(), !
        w "  asFactor: ", f.asFactor().toString(), !
        w "  test factors with null elements contents:", !
        set s = ##class(%ListOfDataTypes).%New()
        do s.Insert("foo"), s.Insert("bar"), s.Insert("foo"), s.Insert("foo"), s.Insert("bar"), s.Insert("bar")
		do c.assign("f", ##class(R.REXPFactor).%New(##class(R.RFactor).%New(s)))
		set f = c.parseAndEval("f")
		w f.toString(), !
		w "  f = ", f.asFactor().toString(), !
		set f = c.parseAndEval("as.factor(c(1,'a','b',1,'b'))")
		w "  f = ", f.toString(), !
		w "PASSED", !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Dataframe()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		
   		#dim r as R.REXP = c.eval("x<-data.frame(id=c(1:3),name=c('Rick','Dan','Michelle'),salary=c(623.3,515.2,611.0))")
   		w r.toDebugString(), !
		
		w !, "* Testing pass-though capability for data.frames ...", !
		set df = c.parseAndEval("{data(iris); iris}")
		w df.toString(), !
		do c.assign("df", df)
		set x = c.eval("identical(df, iris)")
		w "  identical(df, iris) = ", x.toString(), !
		w "PASSED", !

	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod StringList()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		
   		w "* Test string and list retrieval", !
		#dim r as REXP = c.eval("{d=data.frame(""huhu"",c(11:20)); lapply(d,as.character)}")
		w r.toString(), !
		w "PASSED", !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod NAN()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		
		w !, "* Test NA/NaN support in double vectors...", !
		set RNA = $SC(##class(R.REXPDouble).#NA, "F8")
		set x(1)=1.0, x(2)=0.5, x(3)=RNA, x(4)="NA", x(5)=3.5
		do c.assignDoubles("x",.x)
		set x = c.get("x")
		w x.toString(), !
		set nas = c.eval("paste(capture.output(print(x)),collapse='\"_$CHAR(10)_"')").asString()
		w "nas=", nas, !
		#dim rx as REXP = c.eval("c(2.2, NA_real_, NaN)")
		w rx.toString(), !
		set nal = rx.isNA()
		w "isNA: "
		for i=1:1:nal.Count() {
			w nal.GetAt(i), "    "
		}
		w !
		set x = rx.asDoubles()  
		w "PASSED", !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod List()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		
		w !, "* Test assigning of lists and vectors ...", !
		#dim l as R.RList = ##class(R.RList).%New()
		set a = ##class(%ListOfDataTypes).%New()
		do a.Insert(0), a.Insert(1), a.Insert(2), a.Insert(3)
		set b = ##class(%ListOfDataTypes).%New()
		do b.Insert(0.5), b.Insert(1.2), b.Insert(2.3), b.Insert(3.0)
		do l.put("a",##class(R.REXPInteger).%New(a))
		do l.put("b",##class(R.REXPDouble).%New(b))
		w "  assign x=pairlist", !
		do c.assign("x", ##class(R.REXPList).%New(l))
		w "  assign y=vector", !
		do c.assign("y", ##class(R.REXPGenericVector).%New(l))
		w "  assign z=data.frame", !
		do c.assign("z", ##class(R.REXP).createDataFrame(l))
		w "  pull all three back to Cache", !
		set x = c.parseAndEval("x")
		w "x = ", x.toString(), !
		w "isVector = ", x.isVector(), !
		w "isList = ", x.isList(), !
		set x = c.eval("y")
		w "y = ", x.toString(), !
		w "isVector = ", x.isVector(), !
		w "isList = ", x.isList(), !
		set x = c.eval("z")
		w "z = ", x.toString(), !
		w "isVector = ", x.isVector(), !
		w "isList = ", x.isList(), !
		w x.toDebugString(), !
		w "hasAttribute = ", x.hasAttribute("names"), !
		w "PASSED", !
			
		w !, "* Testing functionality of assembled S3 objects ...", !
		// we have already assigned the data.frame in previous test, so we jsut re-use it
		//set x = c.parseAndEval("z[2,2]")
		//w "  z[2,2] = ", x.toString(), !
		w "PASSED", !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Logical()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		
		w !, "* Test support for logicals ... ", !
		w "  assign b={true,false,true}", !
		set b = ##class(%ListOfDataTypes).%New()
		do b.Insert(1), b.Insert(0), b.Insert(1)
		do c.assign("b", ##class(R.REXPLogical).%New(b))
		set x = c.parseAndEval("b")
		w "b= ", x.toString(), !
		set q = x.isTRUE()
		if (q.GetAt(1)'= 1) || (q.GetAt(2)'=0) || (q.GetAt(3)'=1) {
			w "boolean array assign+retrieve test failed (value mismatch)", !
		}
		w "  get c(TRUE,FLASE,NA)", !
		set x = c.parseAndEval("c(TRUE,FALSE,NA)")
		w x.toString(), !
		set q1 = x.isTRUE()
		set q2 = x.isFALSE()
		set q3 = x.isNA()
		if (q1.GetAt(1) '= 1) || (q1.GetAt(2) '= 0) || (q1.GetAt(3) '= 0) ||
			(q2.GetAt(1) '= 0) || (q2.GetAt(2) '= 1) || (q2.GetAt(3) '= 0) ||
			(q3.GetAt(1) '= 0) || (q3.GetAt(2) '= 0) || (q3.GetAt(3) '= 1) {
			w "boolean array NA test failed (value mismatch)", !
		}
		w "PASSED", !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Lowess()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		
		w !, "* Lowess test", !
		do c.eval("rnorm(3)").asCArray(.x)
		do c.eval("rnorm(3)").asCArray(.y)
		do c.assignDoubles("x", .x)
		do c.assignDoubles("y", .y)
		set z = c.parseAndEval("lowess(x,y)")
		w "z= ", z.toDebugString(), !
		set l = z.asList()
		w "l= ", l.toString(), !
		set x = l.atKey("x")
		w "x= ", x.toString(), !
		set y = l.atKey("y")
		w "y= ", y.toString(), !
		w "PASSED", !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Multiline()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		
		// multi-line expressions
		w !, "* Test multi-line expressions", !
		set x = c.eval("{ a=1:10"_##class(R.RConnection).#NewLine_" b=11:20"_##class(R.RConnection).#NewLine_"mean(b-a) }"_##class(R.RConnection).#NewLine)
		w x.toString(), !
		set i = x.asInteger()
		w "i= ", i, !
		w "PASSED", !
			
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Raw()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		
		w !, "* Test serialization and raw vectors", !
		do c.voidEval("x=1")
		set x = c.get("x")
		w x.toString(), !
		set x = c.eval("serialize(ls, NULL, ascii=FALSE)")
		w x.toString(), !
		set b = x.asBytes()
		w "  serialized ls is "_b.SizeGet()_" bytes long", !
		do c.assign("r", ##class(R.REXPRaw).%New(b))
		set r = c.get("r")
		w r.toString(), !
		set s = c.eval("unserialize(r)()")
		w s.toString(), !
		w "  we have "_s.length()_" items in the workspace"
		w "PASSED", !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Strings()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()

		/* NAs in character vectors are mapped to $CHAR(255) references in String[] and vice versa. Only Rserve 0.6-2 and later support NAa in character vectors. */
		/* repression test: assigning empty string '' has failed in previous versions of RserveEngine */
		w "* Test handling of NAs in character vectors ('foo', '', NA, 'NA')", !
		w "  push String[] with NAs: ", !
		set s = 4, s(1)="foo", s(2)="", s(3)=##class(R.REXP).#NAString, s(4)="NA"
		do c.assignStrings("s", .s)
		set nas = c.parseAndEval("is.na(s)")
		w "is.na(s) = ", nas.toString(), !
		w "  pull String[] with NAs: ", !
		set s = c.parseAndEval("c('foo', '', NA, 'NA')")
		w s.toString(), !
		w "  compare pushed and constructed strings: ", !
		set iden = c.parseAndEval("identical(s, c('foo', '', NA, 'NA'))")
		w iden.toString(), !
		w "  check isNA() for REXPString:", !
		set na = c.parseAndEval("s").isNA()
		for i=1:1:na.Count() w " ", na.GetAt(i)
		
		w !, "PASSED", !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Encode()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Control()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		
		// test control commands (works only when enabled and in Rserve 0.6-0 and higher only) - must be the last test since it closes the connection and shuts down the server
		w "* Test control commands (this will fail if control commands are disabled) ...", !
		w "  server eval", !
		set key = "rn"_$random(10) // generate a random number to prevent contamination from previous tests
		w "key = ", key, !
		do c.serverEval("xXx<-'"_key_"'")
		do c.close()
		set c = ##class(R.RConnection).%New()
		#dim x As R.REXP = c.eval("xXx")
		w x.toString(), !
		do c.serverEval("rm(xXx)") // remove the test variable to not pollute the global workspace
		w "  server shutdown", !
		do c.serverShutdown()
		w "PASSED", !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Session1()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()
		do c.eval("x=333")
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Session2()
{
	#dim c as R.RConnection = ""
	try {
		set c = ##class(R.RConnection).%New()

		// At least on windows machine, one R session corresponds to one connection.
		// Even the connection is closed, the R session still lives
		// After reconnection, it remembers the session and all its data 
		// However, after Rserve is killed, the session data is lost
		// On Windows, a second connection cannot be created in the same process even the previous one is closed
		set x = c.get("x")
		w x.toString(), !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod Session()
{
	#dim c as R.RConnection = ""
	try {
		// It seems it cannot detach and attach on Windows.
		// Need to test it on Linux
		set c = ##class(R.RConnection).%New()
		
		do c.eval("x=333")
		#dim s as R.RSession = c.detach()
		
		set c = s.attach()
		set x = c.get("x")
		w x.toString(), !
	}
	catch (e) {
		w e.Data, !
	}
	do:c'="" c.close()
	
	Quit
}

ClassMethod ZEN()
{
	set p = ##class(%ZEN.proxyObject).%New()
	set p.x = "123"
	set y = ##class(%ListOfObjects).%New()
	set p1 = ##class(%ZEN.proxyObject).%New(), p1.xx = "123", p1.yy = "345"
	set p2 = ##class(%ZEN.proxyObject).%New(), p2.xxx = "123", p2.yyy = "345"
	do y.Insert(p1), y.Insert(p2)
	set p.y = y
	W p.%ToJSON()
}

}

