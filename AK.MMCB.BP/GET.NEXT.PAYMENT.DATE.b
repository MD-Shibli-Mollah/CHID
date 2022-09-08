SUBROUTINE GET.NEXT.PAYMENT.DATE (Y.ARR.ID,Y.PRODUCT.LINE,R.AA.ACCOUNT.DETAILS,NEXT.DT)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.SCHEDULED.ACTIVITY
    $USING AA.PaymentSchedule
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    CurrentDay = EB.SystemTables.getToday()
    NEXT.DT = ''
    IF Y.ARR.ID EQ '' OR Y.PRODUCT.LINE EQ '' OR R.AA.ACCOUNT.DETAILS EQ '' THEN
        RETURN
    END
    
    CALL F.READ('F.AA.SCHEDULED.ACTIVITY', Y.ARR.ID, R.SCH, F.AA.SCH, RET.ERR)
    ARR.INFO = Y.ARR.ID:@FM:'':@FM:'':@FM:'':@FM:'':@FM:''
    CALL AA.GET.ARRANGEMENT.PROPERTIES(ARR.INFO, CurrentDay, R.ARR, PROPERTY.LIST)
    CALL AA.GET.PROPERTY.CLASS(PROPERTY.LIST,PROP.CLS.LIST)
    LOCATE "PAYMENT.SCHEDULE" IN PROP.CLS.LIST<1,1>  SETTING CLS.POS THEN
        PS.PROP = PROPERTY.LIST<1,CLS.POS>
    END
    CMP.ACTIVITY = Y.PRODUCT.LINE:'-MAKEDUE-':PS.PROP
    PROCESS.END = ''
    LAST.DT = ''
    NEXT.DT = ''
    ACT.CNT = DCOUNT(R.SCH<AA.SCH.ACTIVITY.NAME>,@VM)
    
    FOR CNT.SCH = 1 TO ACT.CNT UNTIL PROCESS.END
        IF R.SCH<AA.SCH.ACTIVITY.NAME,CNT.SCH> = CMP.ACTIVITY THEN
            LAST.DT = R.SCH<AA.SCH.LAST.DATE,CNT.SCH>
            NEXT.DT = R.SCH<AA.SCH.NEXT.DATE,CNT.SCH>
            PROCESS.END = 1
        END
    NEXT CNT.SCH

    IF LAST.DT EQ CurrentDay THEN         ;*Check for any due
        LOCATE CurrentDay IN R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdPaymentDate,1> SETTING DT.POS THEN
            GOSUB CHECK.STATUS
        END
    END
    
RETURN

CHECK.STATUS:
***************
    PROCESS.END = ''
    FOR LOOP.CNT = 1 TO DCOUNT(R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillStatus,DT.POS>,@SM) UNTIL PROCESS.END
        IF R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillStatus,DT.POS,LOOP.CNT> NE 'SETTLED' AND R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdRepayReference,DT.POS,LOOP.CNT> NE 'PAYOFF' THEN
            NEXT.DT = CurrentDay
        END
    NEXT LOOP.CNT
RETURN

END
