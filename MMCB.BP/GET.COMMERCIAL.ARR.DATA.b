* @ValidationCode : Mjo4MDM0MzUzNDA6Q3AxMjUyOjE2MzgxMDI0NzQ4NjE6dXNlcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE3MTAuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Nov 2021 18:27:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

SUBROUTINE GET.COMMERCIAL.ARR.DATA (Y.ARR.ID, ARR.REC)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_COMMERCIAL.DATA.EXTRACT.COMMON
    $INSERT I_F.AA.SCHEDULED.ACTIVITY
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING AA.Framework
    $USING AA.ProductFramework
    $USING AA.TermAmount
    $USING AA.Account
    $USING AA.Interest
    $USING AA.PaymentSchedule
    $USING AA.Customer
    $USING EB.API
    

    IF NOT(Y.ARR.ID) THEN
        RETURN
    END
    
    GOSUB INIT
    
    EB.DataAccess.FRead(FN.ARR, Y.ARR.ID, REC.ARR, F.ARR, ERR.ARR)
    Y.ACCT.ID = REC.ARR<AA.Framework.Arrangement.ArrLinkedApplId>
    
******** Get Arrangement Start Date ************
    START.DATE = REC.ARR<AA.Framework.Arrangement.ArrStartDate>
    CONTRACT.DATE = REC.ARR<AA.Framework.Arrangement.ArrOrigContractDate>
    
    IF CONTRACT.DATE THEN  ;*For takeover arrangement, get start date from original contract date.
        Y.ORG.CON.DT = CONTRACT.DATE
    END ELSE
        Y.ORG.CON.DT = START.DATE  ;*For normal arrangement, get start date from arrangement start date.
    END
    
*************************************************************************
    
    Y.PRODUCT.LINE = REC.ARR<AA.Framework.Arrangement.ArrProductLine>
    Y.PRODUCT = REC.ARR<AA.Framework.Arrangement.ArrProduct>
    Y.ARR.CURRENCY = REC.ARR<AA.Framework.Arrangement.ArrCurrency>
    Y.ARR.STS = REC.ARR<AA.Framework.Arrangement.ArrArrStatus>
    
**************Get Arrangement Closure Date**********************************
*    Y.CLOSE.DT = ''
    IF Y.ARR.STS EQ 'CLOSE' THEN
        EB.DataAccess.FRead(FN.ACCOUNT, Y.ACCT.ID, REC.ACCOUNT, F.ACCOUNT, ERR.ACCOUNT)
        IF NOT(REC.ACCOUNT) THEN
            ACCT.HIS.ID = Y.ACCT.ID
            EB.DataAccess.FReadHistory(FN.ACCOUNT.HIS, ACCT.HIS.ID, REC.ACCOUNT.HIS, F.ACCOUNT.HIS, ERR.ACC.HIS)
            Y.CLOSE.DT = REC.ACCOUNT.HIS<AC.AccountOpening.Account.ClosureDate>
        END
        ELSE
            Y.CLOSE.DT = REC.ACCOUNT<AC.AccountOpening.Account.ClosureDate>
        END
    END

*******************************************************************************************************
    IF Y.PRODUCT.LINE NE 'ACCOUNTS' THEN    ;* for ACCOUNTS, all the below values will be blank
        R.AA.ACCOUNT.DETAILS = AA.PaymentSchedule.AccountDetails.Read(Y.ARR.ID, ERR.AA.DET)
        Y.PRODUCT.EXP.DT = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdMaturityDate>
        IF Y.PRODUCT.LINE EQ 'DEPOSITS' THEN ;* for DEPOSITS,rollover date
            Y.PRODUCT.ROLLOVER.DT = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdRenewalDate>
            IF NOT (Y.PRODUCT.EXP.DT) THEN
                Y.PRODUCT.EXP.DT = Y.PRODUCT.ROLLOVER.DT
            END
        END
        Y.ARR.AGE.STATUS = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdArrAgeStatus>

*******************Get Arrangement Commitment Amount & Term *****************************************
    
        PROP.CLASS = 'TERM.AMOUNT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID, PROP.CLASS, PROPERTY, '', RETURN.IDS, RETURN.VALUES, ERR.MSG)
        REC.TERM.AMT = RAISE(RETURN.VALUES)

        Y.TERM = REC.TERM.AMT<AA.TermAmount.TermAmount.AmtTerm>
        Y.COMMITMENT = REC.TERM.AMT<AA.TermAmount.TermAmount.AmtAmount>


******************Get Arrangement Interest Rate******************************************************

        PROP.CLASS = 'INTEREST'
        AA.Framework.GetArrangementConditions(Y.ARR.ID, PROP.CLASS, PROPERTY, '', RETURN.IDS, RETURN.VALUES, ERR.MSG)
        REC.INTEREST = RAISE(RETURN.VALUES)


        Y.LOAN.INT.RATES = REC.INTEREST<AA.Interest.Interest.IntEffectiveRate>
        NO.OF.REC = DCOUNT(Y.LOAN.INT.RATES,@VM)
        Y.LOAN.INT.RATE = Y.LOAN.INT.RATES<1,NO.OF.REC>

*******Get Arrangement Last Payment Date, Last Payment Amount, Overdue Amount, Overdue Days, Total Outstanding************
        CALL GET.PAYMENT.INFO(Y.ARR.STS, R.AA.ACCOUNT.DETAILS, Y.LAST.PAYMENT.DATE, Y.LAST.PAYMENT.AMT, Y.TOT.OVERDUE.AMT, Y.TOT.OVERDUE.PRINCIPAL, Y.TOT.OVERDUE.INTEREST, Y.TOT.DUE.DAYS)
        Y.LAST.PAY.DATE = Y.LAST.PAYMENT.DATE
        Y.LAST.PAY.AMT = Y.LAST.PAYMENT.AMT
        Y.OVR.DUE.AMT = Y.TOT.OVERDUE.AMT
        Y.OVR.DUE.PRIN = Y.TOT.OVERDUE.PRINCIPAL
        Y.OVR.DUE.INT = Y.TOT.OVERDUE.INTEREST
        Y.DAY.OVR.DUE = Y.TOT.DUE.DAYS
        
    
******** Total Outstanding***************
        BALANCE.TYPE = 'CURACCOUNT'
        AA.Framework.GetEcbBalanceAmount(Y.ACCT.ID,BALANCE.TYPE,REQUEST.DATE,BALANCE.AMOUNT,ECB.ERROR)
        Y.OUTSD.BAL = BALANCE.AMOUNT - Y.OVR.DUE.PRIN   ;* CURACCOUNT balance is in negative sign.
       
        Y.LOSS.BAL = ''
        IF Y.ARR.AGE.STATUS EQ 'LSS' THEN
            Y.LOSS.BAL = Y.OUTSD.BAL
        END
*********************Get Arrangement Next Payment Date*********************************************
* CALL GET.NEXT.PAYMENT.DATE(Y.ARR.ID, Y.PRODUCT.LINE, R.AA.ACCOUNT.DETAILS, NEXT.DT)
* Y.NXT.PAY.DATE = NEXT.DT
        IF Y.ARR.STS MATCHES "PENDING.CLOSURE":@VM:"CLOSE" THEN
            Y.NXT.PAY.DATE = ''
        END
        ELSE
            CALL GET.NEXT.PAYMENT.DATE(Y.ARR.ID, Y.PRODUCT.LINE, R.AA.ACCOUNT.DETAILS, NEXT.DT)
            Y.NXT.PAY.DATE = NEXT.DT
        END

    
***********COLLATERAL****************
        COLL.REC = ''
        AA.Customer.GetArrangementCustomer(Y.ARR.ID, EffectiveDate, RCustomer, ResArg1, LimitCustomer, GlCustomer, RetError)
        CALL GET.COLLATERAL.INFO(GlCustomer, Y.ARR.ID, COLL.REC)
        IF COLL.REC THEN
            Y.COLL.TYPE.1 = COLL.REC<1,1>
            Y.COLL.REF.1 = COLL.REC<1,2>
            Y.COLL.MARKET.VAL.1 = COLL.REC<1,3>
            Y.COLL.FORCED.SALE.VAL.1 = COLL.REC<1,4>
            Y.COLL.ADD.1 = COLL.REC<1,5>
            Y.COLL.TYPE.2 = COLL.REC<2,1>
            Y.COLL.REF.2 = COLL.REC<2,2>
            Y.COLL.MARKET.VAL.2 = COLL.REC<2,3>
            Y.COLL.FORCED.SALE.VAL.2 = COLL.REC<2,4>
            Y.COLL.ADD.2 = COLL.REC<2,5>
            Y.COLL.TYPE.3 = COLL.REC<3,1>
            Y.COLL.REF.3 = COLL.REC<3,2>
            Y.COLL.MARKET.VAL.3 = COLL.REC<3,3>
            Y.COLL.FORCED.SALE.VAL.3 = COLL.REC<3,4>
            Y.COLL.ADD.3 = COLL.REC<3,5>
        END
    END
    delim = '~'
    ARR.REC = ''
    ARR.REC = Y.PRODUCT.LINE:delim:Y.ACCT.ID:delim:Y.ORG.CON.DT:delim:Y.PRODUCT:delim:Y.ARR.CURRENCY:delim:Y.COMMITMENT:delim:Y.PRODUCT.EXP.DT:delim:Y.ARR.STS:delim:Y.CLOSE.DT:delim:Y.TERM:delim:Y.LOAN.INT.RATE:delim:Y.LAST.PAY.DATE:delim:Y.LAST.PAY.AMT:delim:Y.OUTSD.BAL:delim:Y.OVR.DUE.AMT:delim:Y.OVR.DUE.PRIN:delim:Y.OVR.DUE.INT:delim:Y.NXT.PAY.DATE:delim:Y.DAY.OVR.DUE:delim:Y.ARR.AGE.STATUS:delim:Y.LOSS.BAL:delim:Y.COLL.TYPE.1:delim:Y.COLL.MARKET.VAL.1:delim:Y.COLL.FORCED.SALE.VAL.1:delim:Y.COLL.REF.1:delim:Y.COLL.ADD.1:delim:Y.COLL.TYPE.2:delim:Y.COLL.MARKET.VAL.2:delim:Y.COLL.FORCED.SALE.VAL.2:delim:Y.COLL.REF.2:delim:Y.COLL.ADD.2:delim:Y.COLL.TYPE.3:delim:Y.COLL.MARKET.VAL.3:delim:Y.COLL.FORCED.SALE.VAL.3:delim:Y.COLL.REF.3:delim:Y.COLL.ADD.3
    
RETURN

INIT:
    Y.PRODUCT.LINE = ''
    Y.ACCT.ID = ''
    Y.ORG.CON.DT = ''
    Y.PRODUCT = ''
    Y.ARR.CURRENCY = ''
    Y.COMMITMENT = ''
    Y.PRODUCT.EXP.DT = ''
    Y.ARR.STS = ''
    Y.CLOSE.DT = ''
    Y.TERM = ''
    Y.LOAN.INT.RATE = ''
    Y.LAST.PAY.DATE = ''
    Y.LAST.PAY.AMT = ''
    Y.OUTSD.BAL = ''
    Y.OVR.DUE.AMT = ''
    Y.OVR.DUE.PRIN = ''
    Y.OVR.DUE.INT = ''
    Y.NXT.PAY.DATE = ''
    Y.DAY.OVR.DUE = ''
    Y.ARR.AGE.STATUS = ''
    Y.LOSS.BAL = ''
    Y.COLL.TYPE.1 = ''
    Y.COLL.MARKET.VAL.1 = ''
    Y.COLL.FORCED.SALE.VAL.1 = ''
    Y.COLL.REF.1 = ''
    Y.COLL.ADD.1 = ''
    Y.COLL.TYPE.2 = ''
    Y.COLL.MARKET.VAL.2 = ''
    Y.COLL.FORCED.SALE.VAL.2 = ''
    Y.COLL.REF.2 = ''
    Y.COLL.ADD.2 = ''
    Y.COLL.TYPE.3 = ''
    Y.COLL.MARKET.VAL.3 = ''
    Y.COLL.FORCED.SALE.VAL.3 = ''
    Y.COLL.REF.3 = ''
    Y.COLL.ADD.3 = ''
RETURN
END

