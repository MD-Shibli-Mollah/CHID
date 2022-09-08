SUBROUTINE GET.PAYMENT.INFO(Y.ARR.STS, R.AA.ACCOUNT.DETAILS, Y.LAST.PAYMENT.DATE,Y.LAST.PAYMENT.AMT,Y.TOT.OVERDUE.AMT, Y.TOT.OVERDUE.PRINCIPAL,Y.TOT.OVERDUE.INTEREST,Y.TOT.DUE.DAYS)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $USING AA.Framework
    $USING AA.PaymentSchedule
    $USING AA.ProductFramework
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.API

*-----------------------------------------------------------------------------
    CurrentDay = EB.SystemTables.getToday()
    Y.LAST.PAYMENT.DATE = ''
    Y.LAST.PAYMENT.AMT = ''
    Y.TOT.OVERDUE.AMT = ''
    Y.TOT.OVERDUE.PRINCIPAL = ''
    Y.TOT.OVERDUE.INTEREST = ''
    Y.TOT.DUE.DAYS = ''
    
    IF Y.ARR.STS EQ '' OR R.AA.ACCOUNT.DETAILS EQ '' THEN
        RETURN
    END
    
    SETTLED.BILLS = ''
    OVERDUE.BILLS = ''
    IF NOT(Y.ARR.STS MATCHES "CLOSE":@VM"PENDING.CLOSURE") THEN
        
        Y.BILL.STATUS = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillStatus>
        Y.BILL.IDS = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillId>
        Y.BILL.TYPE = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillType>
        Y.SET.STATUS = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdSetStatus>
        Y.BILL.DATE = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillPayDate>

        Y.BILL.CNT = DCOUNT(Y.BILL.IDS,@VM)
    
        FOR I=1 TO Y.BILL.CNT
        
            Y.SM.CNT = DCOUNT(Y.BILL.IDS<1,I>,@SM)
            FOR K=1 TO Y.SM.CNT
                Y.BILL.ID = Y.BILL.IDS<1,I,K>
    
                IF Y.BILL.STATUS<1,I,K> EQ 'SETTLED' THEN
                    SETTLED.BILLS<-1> = Y.BILL.ID
                END
                IF Y.BILL.STATUS<1,I,K> EQ 'AGING' OR (Y.BILL.STATUS<1,I,K> EQ 'DUE' AND Y.BILL.TYPE<1,I,K> EQ 'ACT.CHARGE' AND Y.SET.STATUS<1,I,K> EQ 'UNPAID' AND Y.BILL.DATE<1,I,K> LT CurrentDay) THEN
                    OVERDUE.BILLS<-1> = Y.BILL.ID
                END
            NEXT K
        NEXT I

        GOSUB PROCESS.OVERDUE.BILLS
        GOSUB GET.LAST.PAYMENT.INFO
    END
RETURN

PROCESS.OVERDUE.BILLS:
    OVERDUE.BILL.CNT = DCOUNT(OVERDUE.BILLS,@FM)
    FOR J=1 TO OVERDUE.BILL.CNT
        Y.PRIN = ""
        Y.INT = ""
        Y.PEN = ""
        Y.OTH = ""
        Y.DUE.AMT = ""
        R.OVERDUE.BILL.DETAILS = AA.PaymentSchedule.BillDetails.Read(OVERDUE.BILLS<J>, ERR.BILL)
        Y.PROPERTY = R.OVERDUE.BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdProperty>
        Y.PROP.CNT = DCOUNT(Y.PROPERTY,@VM)
        FOR M=1 TO Y.PROP.CNT
            R.AA.PROPERTY = AA.ProductFramework.Property.CacheRead(Y.PROPERTY<1,M>, ERR.PROP)
            Y.CLASS = R.AA.PROPERTY<AA.ProductFramework.Property.PropPropertyClass>
            IF Y.CLASS EQ "ACCOUNT" THEN
                Y.PRIN = R.OVERDUE.BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdOsPropAmount,M>
            END
            IF Y.CLASS EQ "INTEREST" THEN
                Y.INT += R.OVERDUE.BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdOsPropAmount,M>
            END
            IF Y.CLASS NE "ACCOUNT" AND Y.CLASS NE "INTEREST" THEN
                Y.OTH += R.OVERDUE.BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdOsPropAmount,M>
            END
            Y.CLASS = ""
        NEXT M
        Y.DUE.AMT = Y.PRIN + Y.INT + Y.PEN + Y.OTH
        Y.DUE.INT = Y.INT + Y.PEN
        Y.TOT.OVERDUE.AMT += Y.DUE.AMT
        Y.TOT.OVERDUE.PRINCIPAL += Y.PRIN
        Y.TOT.OVERDUE.INTEREST += Y.DUE.INT

        Y.DUE.DATE = R.OVERDUE.BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdPaymentDate>
        NO.OF.DAYS = "C"
        
        EB.API.Cdd("",Y.DUE.DATE,CurrentDay,NO.OF.DAYS)
        IF NO.OF.DAYS GT Y.TOT.DUE.DAYS THEN
            Y.TOT.DUE.DAYS = NO.OF.DAYS
        END
    NEXT J
RETURN

GET.LAST.PAYMENT.INFO:
    SETTLED.BILL.CNT = DCOUNT(SETTLED.BILLS,@FM)
    LAST.PAYMENT.BILL.ID = SETTLED.BILLS<SETTLED.BILL.CNT>
    R.LAST.PAYMENT.BILL= AA.PaymentSchedule.BillDetails.Read(LAST.PAYMENT.BILL.ID, ERR.LAST.PAY.BILL)
    IF R.LAST.PAYMENT.BILL THEN
        Y.LAST.PAYMENT.DATE = R.LAST.PAYMENT.BILL<AA.PaymentSchedule.BillDetails.BdBillStChgDt><1,1>
        Y.LAST.PAYMENT.AMT = R.LAST.PAYMENT.BILL<AA.PaymentSchedule.BillDetails.BdOrTotalAmount>
    END
RETURN

END
