Class R.REXPFactory Extends %RegisteredObject
{

/** xpression type: NULL */
Parameter XTNULL = 0;

/** xpression type: integer */
Parameter XTINT = 1;

/** xpression type: double */
Parameter XTDOUBLE = 2;

/** xpression type: String */
Parameter XTSTR = 3;

/** xpression type: language construct (currently content is same as list) */
Parameter XTLANG = 4;

/** xpression type: symbol (content is symbol name: String) */
Parameter XTSYM = 5;

/** xpression type: RBool */
Parameter XTBOOL = 6;

/** xpression type: S4 object
	@since Rserve 0.5 */
Parameter XTS4 = 7;

/** xpression type: generic vector (RList) */
Parameter XTVECTOR = 16;

/** xpression type: dotted-pair list (RList) */
Parameter XTLIST = 17;

/** xpression type: closure (there is no java class for that type (yet?). currently the body of the closure is stored in the content part of the REXP. Please note that this may change in the future!) */
Parameter XTCLOS = 18;

/** xpression type: symbol name
	@since Rserve 0.5 */
Parameter XTSYMNAME = 19;

/** xpression type: dotted-pair list (w/o tags)
	@since Rserve 0.5 */
Parameter XTLISTNOTAG = 20;

/** xpression type: dotted-pair list (w tags)
	@since Rserve 0.5 */
Parameter XTLISTTAG = 21;

/** xpression type: language list (w/o tags)
	@since Rserve 0.5 */
Parameter XTLANGNOTAG = 22;

/** xpression type: language list (w tags)
	@since Rserve 0.5 */
Parameter XTLANGTAG = 23;

/** xpression type: expression vector */
Parameter XTVECTOREXP = 26;

/** xpression type: string vector */
Parameter XTVECTORSTR = 27;

/** xpression type: int[] */
Parameter XTARRAYINT = 32;

/** xpression type: double[] */
Parameter XTARRAYDOUBLE = 33;

/** xpression type: String[] (currently not used, Vector is used instead) */
Parameter XTARRAYSTR = 34;

/** internal use only! this constant should never appear in a REXP */
Parameter XTARRAYBOOLUA = 35;

/** xpression type: RBool[] */
Parameter XTARRAYBOOL = 36;

/** xpression type: raw (byte[])
	@since Rserve 0.4-? */
Parameter XTRAW = 37;

/** xpression type: Complex[]
	@since Rserve 0.5 */
Parameter XTARRAYCPLX = 38;

/** xpression type: unknown; no assumptions can be made about the content */
Parameter XTUNKNOWN = 48;

/** xpression type: RFactor; this XT is internally generated (ergo is does not come from Rsrv.h) to support RFactor class which is built from XTARRAYINT */
Parameter XTFACTOR = 127;

/** used for transport only - has attribute */
Parameter XTHASATTR = 128;

Property type As %Integer;

Property attr As REXPFactory;

Property cont As REXP;

Property rootList As RList;

Method getREXP() As REXP
{
 	return ..cont
}

Method getAttr() As REXPList
{
 	return $S(..attr="":"",1:..attr.cont)
}

Method %OnNew(args...) As %Status
{
	if $G(args,0)=0 {
		set ..attr="", ..cont="", ..rootList=""
		quit $$$OK
	}
	
	set r=$G(args(1))
	if (r="") set r=##class(REXPNull).%New()
	#dim a as REXPList = r.attr
	set ..cont = r
	if (a '= "") set ..attr = ##class(REXPFactory).%New(a)
	if (r.%IsA("R.REXPNull")) {
		set ..type=..#XTNULL
	} 
	elseif (r.%IsA("R.REXPList")) {
		#dim l As RList = r.asList()
		set ..type = $S(l.isNamed():..#XTLISTTAG,1:..#XTLISTNOTAG)
		if (r.%IsA("R.REXPLanguage")) set ..type = $S((..type=..#XTLISTTAG):..#XTLANGTAG,1:..#XTLANGNOTAG)
	} 
	elseif (r.%IsA("R.REXPGenericVector")) {
		set ..type = ..#XTVECTOR // FIXME: may have to adjust names attr
	} 
	elseif (r.%IsA("R.REXPS4")) {
		set ..type = ..#XTS4
	} 
	elseif (r.%IsA("R.REXPInteger")) { // this includes factor - FIXME: do we need speacial handling?
		set ..type = ..#XTARRAYINT
	} 
	elseif (r.%IsA("R.REXPDouble")) {
		set ..type = ..#XTARRAYDOUBLE
	} 
	elseif (r.%IsA("R.REXPString")) {
		set ..type = ..#XTARRAYSTR
	} 
	elseif (r.%IsA("R.REXPSymbol")) {
		set ..type = ..#XTSYMNAME
	} 
	elseif (r.%IsA("R.REXPRaw")) {
		set ..type = ..#XTRAW
	} 
	elseif (r.%IsA("R.REXPLogical")) {
		set ..type = ..#XTARRAYBOOL
	} 
	else {
		// throw new REXPMismatchException(r, "decode");
		W "*** REXPFactory unable to interpret "_r.toString(), !
	}
	quit $$$OK
}

/** returns human-readable name of the xpression type as string. Arrays are denoted by a trailing asterisk (*).
	@param xt xpression type
	@return name of the xpression type */
ClassMethod xtName(xt As %Integer) As %String
{
	if (xt=..#XTNULL) return "NULL"
	if (xt=..#XTINT) return "INT"
	if (xt=..#XTSTR) return "STRING"
	if (xt=..#XTDOUBLE) return "REAL"
	if (xt=..#XTBOOL) return "BOOL"
	if (xt=..#XTARRAYINT) return "INT*"
	if (xt=..#XTARRAYSTR) return "STRING*"
	if (xt=..#XTARRAYDOUBLE) return "REAL*"
	if (xt=..#XTARRAYBOOL) return "BOOL*"
	if (xt=..#XTARRAYCPLX) return "COMPLEX*"
	if (xt=..#XTSYM) return "SYMBOL"
	if (xt=..#XTSYMNAME) return "SYMNAME"
	if (xt=..#XTLANG) return "LANG"
	if (xt=..#XTLIST) return "LIST"
	if (xt=..#XTLISTTAG) return "LIST+T"
	if (xt=..#XTLISTNOTAG) return "LIST/T"
	if (xt=..#XTLANGTAG) return "LANG+T"
	if (xt=..#XTLANGNOTAG) return "LANG/T"
	if (xt=..#XTCLOS) return "CLOS"
	if (xt=..#XTRAW) return "RAW"
	if (xt=..#XTS4) return "S4"
	if (xt=..#XTVECTOR) return "VECTOR"
	if (xt=..#XTVECTORSTR) return "STRING[]"
	if (xt=..#XTVECTOREXP) return "EXPR[]"
	if (xt=..#XTFACTOR) return "FACTOR"
	if (xt=..#XTUNKNOWN) return "UNKNOWN"
	return "<unknown "_xt_">"
}

/** parses byte buffer for binary representation of xpressions - read one xpression slot (descends recursively for aggregated xpressions such as lists, vectors etc.)
		@param buf buffer containing the binary representation
		@param o offset in the buffer to start at
        @return position just behind the parsed xpression. Can be use for successive calls to {@link #parseREXP} if more than one expression is stored in the binary array. */
Method parseREXP(buf As %Stream.GlobalBinary) As %Integer
{
	set o = 0 // count bytes read
	set xl = ##class(RTalk).getLen(buf,.ty) // Read 4 bytes or 8 bytes (isLong)
	set hasAtt = ($ZB(ty,128,1)'=0)
    set isLong = ($ZB(ty,64,1)'=0)
	set xt = $ZB(ty,63,1)
    //System.out.println("parseREXP: type="+xt+", len="+xl+", hasAtt="+hasAtt+", isLong="+isLong);
  	if (isLong) set o = o+4
  	set o = o+4
  	set eox = o+xl
  	
	set ..type=xt, ..attr=##class(REXPFactory).%New(), ..cont=""
	if (hasAtt) set o = o+..attr.parseREXP(buf)
	if (xt=..#XTNULL) {
		set ..cont = ##class(REXPNull).%New(..getAttr())
		return o
	}
	if (xt=..#XTDOUBLE) {
		set d = ##class(RTalk).GetDouble(buf)
		set o = o+8
		if (o'=eox) {
			w "Warning: double SEXP size mismatch", !
			do buf.Read(eox-o) set o = eox
		}
		set ..cont = ##class(REXPDouble).%New(d, ..getAttr())
		return o
	}
	if (xt=..#XTARRAYDOUBLE) {
		set as=(eox-o)/8
		set d = ##class(%ListOfDataTypes).%New()
		while (o<eox) {
			do d.Insert(##class(RTalk).getDouble(buf))
			set o = o+8
		}
		if (o'=eox) {
			w "Warning: double array SEXP size mismatch", !
			do buf.Read(eox-o) set o = eox
		}
		set ..cont = ##class(REXPDouble).%New(d, ..getAttr())
		return o
	}
	if (xt=..#XTBOOL) {
		set b = ##class(RTalk).getLogical(buf)
		set o=o+1
		set ..cont = ##class(REXPLogical).%New(b, ..getAttr())
		if (o'=eox) {
        	if (eox'=(o+3)) { // o+3 could happen if the result was aligned (1 byte data + 3 bytes padding)
            	w "Warning: bool SEXP size mismatch", !
        	}
			do buf.Read(eox-o) set o=eox
		}
		return o
	}
	if (xt=..#XTARRAYBOOLUA) {
		set as=(eox-o)
		set ..cont = ##class(REXPLogical).%New(##class(RTalk).getLogicals(as,buf), ..getAttr())
		set o=o+as
		do buf.Read(eox-o) set o = eox
		return o
	}
    if (xt=..#XTARRAYBOOL) {
        set as=##class(RTalk).getInt(buf)
        set o = (o+4)
      	set ..cont = ##class(REXPLogical).%New(##class(RTalk).getLogicals(as,buf), ..getAttr())
      	set o=o+as
      	do buf.Read(eox-o) set o=eox    	
		return o
    }
    if (xt=..#XTINT) {
	    set i = ##class(RTalk).getInt(buf)
	    set o = o+4
		set ..cont = ##class(REXPInteger).%New(i, ..getAttr())
		if (o'=eox) {
			w "Warning: int SEXP size mismatch", !
			do buf.Read(eox-o) set o=eox
		}
		return o
	}
	if (xt=..#XTARRAYINT) {
		set as=(eox-o)/4
		set d = ##class(%ListOfDataTypes).%New()
		while (o<eox) {
			do d.Insert(##class(RTalk).getInt(buf))
			set o = o+4
		}
		if (o'=eox) {
			w "Warning: int array SEXP size mismatch", !
			do buf.Read(eox-o) set o=eox
		}
		set ..cont = ""
		// hack for lists - special lists attached to int are factors
		try {
		    if (..getAttr()'="") {
				#dim ca as REXP = ..getAttr().asList().atKey("class")
				#dim ls as REXP = ..getAttr().asList().atKey("levels")
				if (ca '= "") && (ls '= "") && (ca.asString()="factor") {
					// R uses 1-based index, Java uses 0-based one
					set ..cont = ##class(REXPFactor).%New(d, ls.asStrings(), ..getAttr())
					set xt = ..#XTFACTOR
				}
		    }
		} catch (e) {}
		if (..cont = "") set ..cont = ##class(REXPInteger).%New(d, ..getAttr())
		return o
	}
    if (xt=..#XTRAW) {
        set as=##class(RTalk).getInt(buf)
        set o = o+4
        set d = ##class(RTalk).getBytes(as,buf)
        set o=o+as
        do buf.Read(eox-o) set o = eox
		set ..cont = ##class(REXPRaw).%New(d, ..getAttr())
        return o
    }
	if (xt=..#XTLISTNOTAG) || (xt=..#XTLISTTAG) ||
		(xt=..#XTLANGNOTAG) || (xt=..#XTLANGTAG) {
		set lc = ##class(REXPFactory).%New()
		set nf = ##class(REXPFactory).%New()
		set l = ##class(RList).%New()
		while (o<eox) {
			set name = ""
			set o =o+lc.parseREXP(buf)
			if (xt=..#XTLISTTAG) || (xt=..#XTLANGTAG) {
				set o=o+nf.parseREXP(buf)
				if (nf.cont.isSymbol()) || (nf.cont.isString()) set name = nf.cont.asString()
			}
			if (name="") { do l.add(lc.cont) }
			else { do l.put(name, lc.cont) }
		}
		set ..cont = $S(((xt=..#XTLANGNOTAG) || (xt=..#XTLANGTAG)):##class(REXPLanguage).%New(l, ..getAttr()),
			1:##class(REXPList).%New(l, ..getAttr()))
		if (o'=eox) {
			w "Warning: int list SEXP size mismatch", !
			do buf.Read(eox-o) set o=eox
		}
		return o
	} 
	if (xt=..#XTLIST) || (xt=..#XTLANG) { //old-style lists, for comaptibility with older Rserve versions - rather inefficient since we have to convert the recusively stored structures into a flat structure
		set isRoot = 0
		if (..rootList = "") {
			set ..rootList = ##class(RList).%New()
			set isRoot = 1
		}
		set headf = ##class(REXPFactory).%New()
		set tagf = ##class(REXPFactory).%New()
		set o=o+headf.parseREXP(buf)
		set elIndex = rootList.size()
		do ..rootList.add(headf.cont)
		//System.out.println("HEAD="+headf.cont);
		set o=o+..parseREXP(buf) // we use ourselves recursively for the body
		if (o<eox) {
			set o=o+tagf.parseREXP(buf)
			//System.out.println("TAG="+tagf.cont);
			if (tagf.cont '= "") && (tagf.cont.isString() || tagf.cont.isSymbol()) {
				do ..rootList.setKeyAt(elIndex, tagf.cont.asString())
			}
		}
		if (isRoot) {
			set ..cont = $S((xt=..#XTLIST):##class(REXPList).%New(rootList, ..getAttr()),
			1:##class(REXPLanguage).%New(rootList, ..getAttr()))
			set ..rootList = ""
			//System.out.println("result="+cont);
		}
		return o
	}
	if (xt=..#XTVECTOR) || (xt=..#XTVECTOREXP) {
		set v=##class(%ListOfObjects).%New() //FIXME: could we use RList?
		while(o<eox) {
			set xx=##class(REXPFactory).%New()
			set o=o+xx.parseREXP(buf)
			do v.Insert(xx.cont)
		}
		if (o'=eox) {
			w "Warning: int vector SEXP size mismatch", !
			do buf.Read(eox-o) set o=eox
		}
			
		// fixup for lists since they're stored as attributes of vectors
		if (..getAttr()'="") && (..getAttr().asList().at("names") '= "") {
			#dim nam as REXP = ..getAttr().asList().at("names")
			set names = ""
			if (nam.isString()) {
				set names = nam.asStrings()
			}
			elseif (nam.isVector()) { // names could be a vector if supplied by old Rserve
				#dim ll as RList = nam.asList()
				set names = ##class(%ListOfDataTypes).%New()
				for i=1:1:ll.Count() {
					#dim re as REXP = ll.GetAt(i)
					do names.Insert(re.asString()) 
				}
			}
			set l = ##class(RList).%New(v, names)
			set ..cont = $S((xt=..#XTVECTOREXP):##class(REXPExpressionVector).%New(l, ..getAttr()), 
				1:##class(REXPGenericVector).%New(l, ..getAttr()))
		}
		else {
			set ..cont = $S((xt=..#XTVECTOREXP):##class(REXPExpressionVector).%New(##class(RList).%New(v), ..getAttr()),
				1:##class(REXPGenericVector).%New(##class(RList).%New(v),..getAttr()))
		}
		return o
	}
	if (xt=..#XTARRAYSTR) {
		set s = ##class(RTalk).getStrings(buf, xl, .c)
		set o=o+c
		set ..cont = ##class(REXPString).%New(s, ..getAttr())
		do buf.Read(eox-o) set o=eox
		return o
	}
	if (xt=..#XTVECTORSTR) {
		set v=##class(%ListOfObjects).%New()
		while(o<eox) {
			set xx=##class(REXPFactory).%New()
			set o=o+xx.parseREXP(buf)
			do v.Insert(xx.cont.asString())
		}
		if (o'=eox) {
			w "Warning: int vector SEXP size mismatch", !
			do buf.Read(eox-o) set o=eox
		}
		set ..cont = ##class(REXPString).%New(v, ..getAttr())
		return o
	}
	if (xt=..#XTSTR) || (xt=..#XTSYMNAME) {
		try {
			if (xt=..#XTSTR) {
				set ..cont = ##class(REXPString).%New(##class(RTalk).getString(buf, .c),..getAttr())
			}
			else {
				set ..cont = ##class(REXPSymbol).%New(##class(RTalk).getString(buf, .c),..getAttr())
			}
			set o=o+c
		}
		catch (e) {
			w "unable to convert string", !
			set ..cont=""
		}
		do buf.Read(eox-o) set o=eox
		return o
	}
	if (xt=..#XTSYM) {
		set sym = ##class(REXPFactory).%New()
		set o=o+sym.parseREXP(buf) // PRINTNAME that's all we will use
		set ..cont = ##class(REXPSymbol).%New(sym.getREXP().asString()) // content of a symbol is its printname string (so far)
		do buf.Read(eox-o) set o=eox
		return o
	}
	
	if (xt=..#XTCLOS) {
		/*
		REXP form=new REXP();
		REXP body=new REXP();
		o=parseREXP(form,buf,o);
		o=parseREXP(body,buf,o);
		if (o!=eox) {
			System.err.println("Warning: closure SEXP size mismatch\n");
			o=eox;
		}
		x.cont=body;
		 */
		do buf.Read(eox-o) set o=eox
		return o
	}
	
	if (xt=..#XTUNKNOWN) {
		set ..cont = ##class(REXPUnknown).%New(##class(RTalk).getInt(buf), ..getAttr())
		set o=o+4
		do buf.Read(eox-o) set o=eox
		return o
	}
	
	if (xt=..#XTS4) {
		set ..cont = ##class(REXPS4).%New(..getAttr())
		do buf.Read(eox-o) set o=eox
		return o
	}
	
	set ..cont = ""
	do buf.Read(eox-o) set o=eox
	w "unhandled type: "_xt, !
	return o
}

/** Calculates the length of the binary representation of the REXP including all headers. This is the amount of memory necessary to store the REXP via {@link #getBinaryRepresentation}.
        <p>Please note that currently only XT_[ARRAY_]INT, XT_[ARRAY_]DOUBLE and XT_[ARRAY_]STR are supported! All other types will return 4 which is the size of the header.
        @return length of the REXP including headers (4 or 8 bytes)*/
Method getBinaryLength() As %Integer
{
	set l=0
	set rxt = ..type
	if (..type=..#XTLIST) || (..type=..#XTLISTTAG) || (..type=..#XTLISTNOTAG) {
		set rxt=$S(((..cont.asList()'="") && (..cont.asList().isNamed())):..#XTLISTTAG,1:..#XTLISTNOTAG)
	}
	//System.out.print("len["+xtName(type)+"/"+xtName(rxt)+"] ");
	if (..type=..#XTVECTORSTR) set rxt=..#XTARRAYSTR // VECTOR_STR is broken right now
	
	/*
	if (type==XT_VECTOR && cont.asList()!=null && cont.asList().isNamed())
		setAttribute("names",new REXPString(cont.asList().keys()));
	 */
	
	set hasAttr = 0
	#dim a as REXPList = ..getAttr()
	#dim al as RList = ""
	if (a'="") set al = a.asList()
	if (al '= "") && (al.size()>0) set hasAttr=1
	if (hasAttr) {
		set l=l+..attr.getBinaryLength()
	}
	if (rxt=..#XTNULL) || 
	   (rxt=..#XTS4) {
		// Do nothing
	}	
	elseif rxt=..#XTINT {
		set l=l+4
	}
	elseif rxt=..#XTDOUBLE {
		set l=l+8
	}
	elseif rxt=..#XTRAW { // hdr + 4(bytes len) + length + paddings
		set l=l+4 + ..cont.asBytes().SizeGet()
		set:(l#4)'=0 l=l-(l#4)+4
	}
	elseif (rxt=..#XTSTR) || (rxt=..#XTSYMNAME) { // hdr + length + 1($CHAR(0)) + paddings
		set l=l+$S((..cont=""):1,1:($L(..cont.asString())+1))
		set:(l#4)'=0 l=l-(l#4)+4
	}
	elseif rxt=..#XTARRAYINT {
		set l=l+(..cont.length()*4)
	}
	elseif rxt=..#XTARRAYDOUBLE {
		set l=l+(..cont.length()*8)
		
	}
	elseif rxt=..#XTARRAYCPLX {
		set l=l+(..cont.asDoubles().Count()*8)
	}
	elseif rxt=..#XTARRAYBOOL { // hdr + 4(bytes len) + length + paddings
		set l=l+..cont.length() + 4
		set:(l#4)'=0 l = l - (l#4) + 4
	}
	elseif (rxt=..#XTLISTTAG) ||
		   	(rxt=..#XTLISTNOTAG) ||
		   	(rxt=..#XTLANGTAG) ||
			(rxt=..#XTLANGNOTAG) ||
			(rxt=..#XTLIST) ||
			(rxt=..#XTVECTOR) {
		#dim lst as RList = ..cont.asList()
		set i=1
		while (i<=lst.size()) {
			#dim x as REXP = lst.at(i)
			set l = l+ $S((x=""):4,1:##class(REXPFactory).%New(x).getBinaryLength())
			if (rxt=..#XTLISTTAG) {
				set pl=l
				set s = lst.keyAt(i)
				set l=l+4 // header for a symbol
				set l=l+$S((s=""):1,1:($L(s)+1))
				set:(l#4)'=0 l=l-(l#4)+4
				// System.out.println("TAG length: "+(l-pl));
			}
			set i = $I(i)
		}
		set:(l#4)'=0 l=l-(l#4)+4
	}
  	elseif rxt=..#XTARRAYSTR {
		#dim sa as %ListOfDataTypes = ..cont.asStrings()
		set i=1
		while (i <= sa.Count()) {
			set s = sa.GetAt(i)
			if (s '= "") {
				if $SC($E(s,1),"S1")=-1 set l=$I(l)
				set l=l+$L(s)
				
			} 
			else {
				set l = $I(l) // NA = -1
			}
			set l = $I(l) // padding 0
			set i = $I(i)
		}
		set:(l#4)'=0 l=l-(l#4)+4
	}
	if (l>##class(RTalk).#LONGLEN) set l=l+4 // large data need 4 more bytes

	// System.out.println("len:"+(l+4)+" "+xtName(rxt)+"/"+xtName(type)+" "+cont);
	return l+4 // add the header
}

/** Stores the REXP in its binary (ready-to-send) representation including header into a buffer and returns the index of the byte behind the REXP.
        <p>Please note that currently only XT_[ARRAY_]INT, XT_[ARRAY_]DOUBLE and XT_[ARRAY_]STR are supported! All other types will be stored as SEXP of the length 0 without any contents.
        @param buf buffer to store the REXP binary into
        @param off offset of the first byte where to store the REXP
        @return the offset of the first byte behind the stored REXP */
Method getBinaryRepresentation(buf As %Stream.GlobalBinary)
{
	set myl=..getBinaryLength() // include hdr length
    set isLarge=(myl>##class(RTalk).#LONGLEN)
	set hasAttr = 0
	#dim a as REXPList = ..getAttr()
	#dim al as RList = ""
	if (a '= "") set al = a.asList()
	if (al '= "") && (al.size()>0) set hasAttr=1
	set rxt=..type
	if (..type=..#XTVECTORSTR) set rxt=..#XTARRAYSTR // VECTOR_STR is broken right now
	if (..type=..#XTLIST ) || (..type=..#XTLISTTAG) || (..type=..#XTLISTNOTAG) {
		set rxt=$S(((..cont.asList()'="") && (..cont.asList().isNamed())):..#XTLISTTAG,1:..#XTLISTNOTAG)
	}
	// System.out.println("@"+off+": "+xtName(rxt)+"/"+xtName(type)+" "+cont+" ("+myl+"/"+buf.length+") att="+hasAttr);
    do ##class(RTalk).setHdr($ZB(rxt, $S(hasAttr:..#XTHASATTR,1:0), 7), myl-$S(isLarge:8,1:4),buf)
	if (hasAttr) do ..attr.getBinaryRepresentation(buf)

	if (rxt=..#XTNULL) || (rxt=..#XTS4) {
			// Do nothing
	}
	elseif rxt=..#XTINT { 
		do ##class(RTalk).setInt(..cont.asInteger(),buf) 
	}
	elseif rxt=..#XTDOUBLE { 
		do ##class(RTalk).seDouble(..cont.asDouble(),buf) 
	}
	elseif rxt=..#XTARRAYINT {
		set ia=..cont.asIntegers()
		do ##class(RTalk).setInts(ia,buf)	
	}
	elseif rxt=..#XTARRAYBOOL {
		set ba = ..cont.asIntegers()
		do ##class(RTalk).setLogicals(ba, buf)
	}
	elseif rxt=..#XTARRAYDOUBLE {
		set da=..cont.asDoubles()
		do ##class(RTalk).setDoubles(da,buf)
	}
	elseif rxt=..#XTRAW {
		set ba = ..cont.asBytes()
		do ##class(RTalk).setBytes(ba, buf)
	}
	elseif rxt=..#XTARRAYSTR {
		set sa = ..cont.asStrings()
		do ##class(RTalk).setStrings(sa, buf)
	}
	elseif (rxt=..#XTLISTTAG) ||
			(rxt=..#XTLISTNOTAG) ||
			(rxt=..#XTLANGTAG) ||
			(rxt=..#XTLANGNOTAG) ||
			(rxt=..#XTLIST) ||
			(rxt=..#XTVECTOR) ||
			(rxt=..#XTVECTOREXP) {
		#dim lst as RList = ..cont.asList()
		if (lst '= "") {
			set i=1
			while (i<=lst.size()) {
				#dim x as REXP = lst.at(i)
				if (x = "") set x=##class(REXPNull).%New()
				do ##class(REXPFactory).%New(x).getBinaryRepresentation(buf)
				if (rxt = ..#XTLISTTAG) || (rxt = ..#XTLANGTAG) {
					do ##class(REXPFactory).%New(##class(REXPSymbol).%New(lst.keyAt(i))).getBinaryRepresentation(buf)
				}
				set i=$I(i)
			}
		}
	}
	elseif (rxt=..#XTSYMNAME) || (rxt=..#XTSTR) {
		do ##class(RTalk).setString(..cont.asString(), buf)
		//do ..getStringBinaryRepresentation(buf, ..cont.asString())
	}
}

/// String is terminated with 0 and padded with 0 to make the total length divisible by 4
ClassMethod getStringBinaryRepresentation(buf As %Stream.GlobalBinary, s As %String)
{
	do buf.Write(s) // s="" does nothing
	do buf.Write($CHAR(0))
	set io = $L(s)+1
	while (io#4)'=0 {
		do buf.Write($CHAR(0)) // padding if necessary..
		set io=$I(io)
	}
}

}

