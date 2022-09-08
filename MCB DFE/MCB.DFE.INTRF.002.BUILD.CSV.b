*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MCB.DFE.INTRF.002.BUILD.CSV(Y.ARR)
*-----------------------------------------------------------------------------
*
*This is a Build routine
*------------------------------------------------------------------------
* Generic Comments    :
*------------------------------------------------------------------------
* Company Name        :
* Developer Name      : KALMANI
* Subroutine Type     : POST Routine
* Attached as         :
* Incoming Parameters : NA
* Outgoing Parameters : Y.ARR
* Development Date    : 03-01-2018
*-------------------------------------------------------------------------
* Description         : Build routine
*-------------------------------------------------------------------------
* Modification History:-
*------------------------
* Date              Who                    Reference                 Descr
*-------------------------------------------------------------------------
*
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_BATCH.FILES
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.ACCOUNT


    GOSUB OPENFILES
    GOSUB PROCESS

    RETURN

**********
OPENFILES:
**********
    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT.CLASS = "F.ACCOUNT.CLASS"
    F.ACCOUNT.CLASS = ''
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    RETURN

********
PROCESS:
********

    IF CONTROL.LIST = "" THEN
        CONTROL.LIST = "NOSTRO_VOSTRO":FM:"AA_ARRANGEMENT"

    END

    CURR.PROCESS =  CONTROL.LIST<1,1>['-',1,1]

    BEGIN CASE

        CASE CURR.PROCESS EQ 'NOSTRO_VOSTRO'
            Y.ID.LIST = 'NOSTRO':FM:'VOSTRO'
            LOOP
                REMOVE Y.CLASS.ID FROM Y.ID.LIST SETTING CLASS.POS
            WHILE Y.CLASS.ID:CLASS.POS

                CALL F.READ(FN.ACCOUNT.CLASS,Y.CLASS.ID,R.ACCT.CLASS,F.ACCOUNT.CLASS,CLASS.ERR)
                IF NOT(CLASS.ERR) THEN
                    Y.CATEG = R.ACCT.CLASS<AC.CLS.CATEGORY>

                END
                CATEG.ARRAY<-1> = Y.CATEG
                Y.CATEG = ''
            REPEAT
            CHANGE VM TO ' ' IN CATEG.ARRAY
            CHANGE FM TO ' ' IN CATEG.ARRAY
*	SEL.CMD.PL="SELECT ":FN.ACCOUNT:" WITH CATEGORY GE 50000 AND CATEGORY LT 70000"
*	SEL.LIST.PL=''
*	CALL EB.READLIST(SEL.CMD.PL,SEL.LIST.PL,'',NO.REC.PL,SEL.ERR.PL)
	 SEL.CMD.ACC="SELECT ":FN.ACCOUNT:" WITH CATEGORY GE 10000 AND CATEGORY LT 20000"
 	SEL.LIST.ACC=''
 	CALL EB.READLIST(SEL.CMD.ACC,SEL.LIST.ACC,'',NO.REC.ACC,SEL.ERR.ACC)
 
            SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH CATEGORY EQ ":CATEG.ARRAY
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.CNT,SEL.ERR)
	SEL.LIST=SEL.LIST:FM:SEL.LIST.ACC
        CASE CURR.PROCESS EQ 'AA_ARRANGEMENT'

            SEL.AA.ARR.ID = "SELECT ":FN.AA.ARRANGEMENT:" WITH ARR.STATUS EQ AUTH":" OR ARR.STATUS EQ CURRENT":" OR ARR.STATUS EQ EXPIRED"
            CALL EB.READLIST(SEL.AA.ARR.ID,SEL.LIST,'',SEL.CNT,SEL.ARR.ERR)

    END CASE

    Y.ARR = SEL.LIST

    RETURN

    END

