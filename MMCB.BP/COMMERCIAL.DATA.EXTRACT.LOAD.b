* @ValidationCode : Mjo3NTMwMDg3Njc6Q3AxMjUyOjE2Mzg0MjE3ODAzMTk6dXNlcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE3MTAuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Dec 2021 11:09:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

SUBROUTINE COMMERCIAL.DATA.EXTRACT.LOAD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.DataAccess
    $USING EB.SystemTables
    $INSERT I_COMMERCIAL.DATA.EXTRACT.COMMON

    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    
    FN.CUS.ARR = 'F.AA.CUSTOMER.ARRANGEMENT'
    F.CUS.ARR = ''
    EB.DataAccess.Opf(FN.CUS.ARR, F.CUS.ARR)
    
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
    
*    FN.LIMIT = 'F.LIMIT'
*    F.LIMIT =''
*    EB.DataAccess.Opf(FN.LIMIT,F.LIMIT)
*
*    FN.COLLATERAL = 'F.COLLATERAL'
*    F.COLLATERAL=''
*    EB.DataAccess.Opf(FN.COLLATERAL,F.COLLATERAL)
*
*    FN.COLLATERAL.TYPE= 'F.COLLATERAL.TYPE'
*    F.COLLATERAL.TYPE=''
*    EB.DataAccess.Opf(FN.COLLATERAL.TYPE,F.COLLATERAL.TYPE)
    
    FN.MMCB.COMMERCIAL.WRK= 'F.MMCB.COMMERCIAL.WRK'
    F.MMCB.COMMERCIAL.WRK=''
    EB.DataAccess.Opf(FN.MMCB.COMMERCIAL.WRK,F.MMCB.COMMERCIAL.WRK)
    
    Y.TODAY = EB.SystemTables.getToday()
*    Y.CUS.ID = ''
*    Y.LEGAL.ID = ''
*    Y.LEGAL.ISSUE.DT = ''
*    Y.NAME1 = ''
*    Y.SHORT.NM = ''
*    Y.ORG.STATUS = ''
*    Y.ORG.STATUS.EFF.DT = ''
*    Y.TARGET = ''
*    Y.TOWN.COUNTRY = ''
*    Y.STREET = ''
*    Y.CITY = ''
*    Y.POST.CODE = ''
*    Y.COUNTRY = ''
*    Y.ADDRESS = ''
*    Y.EMAIL.1 = ''
*    Y.EMAIL.2 = ''
*    Y.SMS = ''
*    Y.PHONE.OFF = ''
*    Y.PHONE = ''
*    Y.PRODUCT.LINE = ''
*    Y.ACCT.ID = ''
*    Y.ORG.CON.DT = ''
*    Y.PRODUCT = ''
*    Y.ARR.CURRENCY = ''
*    Y.COMMITMENT = ''
*    Y.PRODUCT.EXP.DT = ''
*    Y.ARR.STS = ''
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
*    Y.COLL.TYPE.1 = ''
*    Y.COLL.MARKET.VAL.1 = ''
*    Y.COLL.FORCED.SALE.VAL.1 = ''
*    Y.COLL.REF.1 = ''
*    Y.COLL.ADD.1 = ''
*    Y.COLL.TYPE.2 = ''
*    Y.COLL.MARKET.VAL.2 = ''
*    Y.COLL.FORCED.SALE.VAL.2 = ''
*    Y.COLL.REF.2 = ''
*    Y.COLL.ADD.2 = ''
*    Y.COLL.TYPE.3 = ''
*    Y.COLL.MARKET.VAL.3 = ''
*    Y.COLL.FORCED.SALE.VAL.3 = ''
*    Y.COLL.REF.3 = ''
*    Y.COLL.ADD.3 = ''
RETURN
END
