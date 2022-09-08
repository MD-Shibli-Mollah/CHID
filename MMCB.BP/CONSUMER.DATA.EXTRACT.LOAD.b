* @ValidationCode : Mjo1NjgxNTQ4Mzc6Q3AxMjUyOjE2Mjk3MDgwMjYzMDY6QUtIVEFSOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTkxMC4xOi0xOi0x
* @ValidationInfo : Timestamp         : 23 Aug 2021 14:40:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : AKHTAR
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201910.1

SUBROUTINE CONSUMER.DATA.EXTRACT.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.DataAccess
    $USING EB.SystemTables
    $INSERT I_CONSUMER.DATA.EXTRACT.COMMON

    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    
    FN.ARR = 'F.AA.ARRANGEMENT'
    F.ARR = ''
    EB.DataAccess.Opf(FN.ARR, F.ARR)
    
    FN.AA.ACC.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACC.DETAILS = ''
    EB.DataAccess.Opf(FN.AA.ACC.DETAILS, F.AA.ACC.DETAILS)
    
    FN.INDUSTRY = 'F.INDUSTRY'
    F.INDUSTRY = ''
    EB.DataAccess.Opf(FN.INDUSTRY, F.INDUSTRY)
    
    FN.TARGET = 'F.TARGET'
    F.TARGET = ''
    EB.DataAccess.Opf(FN.TARGET, F.TARGET)
    
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS = ''
    EB.DataAccess.Opf(FN.ACCOUNT.HIS, F.ACCOUNT.HIS)
    
    FN.CUS.ARR = 'F.AA.CUSTOMER.ARRANGEMENT'
    F.CUS.ARR = ''
    EB.DataAccess.Opf(FN.CUS.ARR, F.CUS.ARR)
    
    FN.MMCB.CONSUMER.WRK= 'F.MMCB.CONSUMER.WRK'
    F.MMCB.CONSUMER.WRK=''
    EB.DataAccess.Opf(FN.MMCB.CONSUMER.WRK,F.MMCB.CONSUMER.WRK)
    
    Y.TODAY = EB.SystemTables.getToday()
*    Y.CUS.ID = ''
*    Y.LEGAL.ID = ''
*    Y.LEGAL.EXP.DT = ''
*    Y.BIRTH.DT = ''
*    Y.NAME1 = ''
*    Y.NAME2 = ''
*    Y.SHORT.NM = ''
*    Y.L.FATHER.NAME = ''
*    Y.GENDER = ''
*    Y.MARITAL.STATUS = ''
*    Y.NATIONALITY = ''
*    Y.L.RACE = ''
*    Y.STREET = ''
*    Y.TOWN.COUNTRY = ''
*    Y.POST.CODE = ''
*    Y.COUNTRY = ''
*    Y.ADDRESS = ''
*    Y.EMAIL = ''
*    Y.CONTACT.NO.TYPE = ''
*    Y.SMS = ''
*    Y.PHONE = ''
*    Y.PHONE.OFF = ''
*    Y.INDUSTRY = ''
*    Y.TARGET = ''
*    Y.EMP.COUNTRY = ''
*    Y.EMP.ADDRESS = ''
*    Y.OCCUPATION = ''
*    Y.CUS.CURRENCY = ''
*    Y.NET.MONTHLY.IN = ''
*    Y.ACCT.ID = ''
*    Y.ORG.CON.DT = ''
*    Y.PRODUCT = ''
*    Y.ARR.CURRENCY = ''
*    Y.COMMITMENT = ''
*    Y.PRODUCT.EXP.DT = ''
*    Y.CLOSE.DT = ''
*    Y.TERM = ''
*    Y.LOAN.INT.RATE = ''
*    Y.LAST.PAY.DATE = ''
*    Y.LAST.PAY.AMT = ''
*    Y.OUTSD.BAL = ''
*    Y.OVR.DUE.AMT = ''
*    Y.NXT.PAY.DATE = ''
*    Y.DAY.OVR.DUE = ''
*    Y.ARR.AGE.STATUS = ''
*    Y.LOSS.BAL = ''
*    Y.COLL.TYPE = ''
*    Y.COLL.REF = ''
*    Y.COLL.MARKET.VAL = ''
*    Y.COLL.FORCED.SALE.VAL = ''
RETURN
END
