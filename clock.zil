"CLOCK for SEASTALKER
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

"Interrupt table needs room for 33 3-word slots:
I-AIRLOCK-EMPTY
I-ALARM-RINGING
I-ANALYSIS
I-ANTRIM-REPORTS
I-ANTRIM-TO-SUB
I-AUTO-PILOT
I-BLY-PRIVATELY
I-BLY-SAYS
I-CHECK-POD
I-DOME-AIR
I-GREENUP-ESCAPE
I-LAMP-ON-SCOPE
I-LOWELL-REPORTS
I-POISON-JAB
I-PROMPT-1
I-PROMPT-2
I-SEND-SUB
I-SHARON
I-SHARON-GONE
I-SHARON-TO-HALLWAY
I-SHOW-SONAR
I-SIEGEL-REPORTS
I-SNARK-ATTACKS
I-SYNTHESIS
I-THORPE-APPEARS
I-THORPE-AWAKES
I-TIP-PRIVATELY
I-TIP-REPORTS
I-TIP-SAYS
I-TIP-SONAR-PLAN
I-UPDATE-FREIGHTER
I-UPDATE-SUB-POSITION
I-UPDATE-THORPE"

<CONSTANT C-TABLELEN 222>

<GLOBAL C-TABLE %<COND (<GASSIGNED? PREDGEN> '<ITABLE NONE 111>)
		       (T '<ITABLE NONE 222>)>>

;<GLOBAL C-DEMONS 111>

<GLOBAL C-INTS 222>

<CONSTANT C-INTLEN 6>

<CONSTANT C-ENABLED? 0>

<CONSTANT C-TICK 1>

<CONSTANT C-RTN 2>

;<ROUTINE DEMON (RTN TICK "AUX" CINT)
	 #DECL ((RTN) ATOM (TICK) FIX (CINT) <PRIMTYPE VECTOR>)
	 <PUT <SET CINT <INT .RTN T>> ,C-TICK .TICK>
	 .CINT>

<ROUTINE QUEUE (RTN TICK "AUX" CINT)
	 #DECL ((RTN) ATOM (TICK) FIX (CINT) <PRIMTYPE VECTOR>)
	 <PUT <SET CINT <INT .RTN>> ,C-TICK .TICK>
	 .CINT>

<ROUTINE INT (RTN "OPTIONAL" ;(DEMON <>) "AUX" E C INT)
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <REPEAT ()
		 <COND (<==? .C .E>
			<SETG C-INTS <- ,C-INTS ,C-INTLEN>>
			;<AND .DEMON <SETG C-DEMONS <- ,C-DEMONS ,C-INTLEN>>>
			<SET INT <REST ,C-TABLE ,C-INTS>>
			<PUT .INT ,C-RTN .RTN>
			<RETURN .INT>)
		       (<EQUAL? <GET .C ,C-RTN> .RTN> <RETURN .C>)>
		 <SET C <REST .C ,C-INTLEN>>>>

<GLOBAL CLOCK-WAIT <>>
;<GLOBAL PRESENT-TIME 0>

<ROUTINE CLOCKER ("AUX" C E TICK (FLG <>) VAL)
	 #DECL ((C E) <PRIMTYPE VECTOR> (TICK) FIX ;(FLG) ;<OR FALSE ATOM>)
	 <COND (,CLOCK-WAIT <SETG CLOCK-WAIT <>> <RFALSE>)>
	 <SET C <REST ,C-TABLE <COND (,P-WON ,C-INTS) ;(T ,C-DEMONS)>>>
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <REPEAT ()
		 <COND (<==? .C .E>
			<SETG MOVES <+ ,MOVES 1>>
			<RETURN .FLG>)
		       (<NOT <0? <GET .C ,C-ENABLED?>>>
			<SET TICK <GET .C ,C-TICK>>
			<COND (<0? .TICK>)
			      (T
			       <PUT .C ,C-TICK <- .TICK 1>>
			       <COND (<AND <NOT <G? .TICK 1>>
				           <SET VAL <APPLY <GET .C ,C-RTN>>>>
				      <COND (<OR <NOT .FLG>
						 <==? .VAL ,M-FATAL>>
					     <SET FLG .VAL>)>)>)>)>
		 <SET C <REST .C ,C-INTLEN>>>>
