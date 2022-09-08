* @ValidationCode : MjotMzgzNTExNDIwOkNwMTI1MjoxNjM5OTEyMTE2MTU5OnVzZXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2021 17:08:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

SUBROUTINE CHID.NOF.TT.HIS.ALL(Y.DATA)
    
*Subroutine Description: This is a nofile enquiry routine where All all TT transaction 2020 JAN to 2021 JAN from T24 will be EXTRACTED.
*Subroutine Type : NOFILE ENQUIRY ROUTINE
*Attached To :
*Attached As : ROUTINE
*Developed by : MD Shibli Mollah
*Designation : Software Engineer
*Email : smollah@fortress-global.com
*Incoming Parameters : Y.START.DATE, Y.END.DATE
*Outgoing Parameters : Y.TT.ID, Y.TR.CODE, Y.TR.DATE, Y.ACC, Y.AMT, Y.CO.CODE
*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Date :
* Modification Description :
* Modified By :
*
*-----------------------------------------------------------------------------
     
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING TT.Contract
    $USING EB.API
    $USING EB.Reports
    $USING ST.CompanyCreation
    
    GOSUB INIT
*
    GOSUB OPENFILES
*
    GOSUB PROCESS
RETURN
 
INIT:
*
*   ST.CompanyCreation.LoadCompany('BNK')
    Y.COMP = EB.SystemTables.getIdCompany()
    Y.TODAY = EB.SystemTables.getToday()
    
    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
     
RETURN

OPENFILES:
    EB.DataAccess.Opf(FN.TELLER.HIS, F.TELLER.HIS)

RETURN

PROCESS:
*
    
    LOCATE "Y.START.DATE" IN EB.Reports.getEnqSelection()<2,1> SETTING SDATE.POS THEN
        Y.ST.DT = EB.Reports.getEnqSelection()<4, SDATE.POS>
    END
    
    LOCATE "Y.END.DATE" IN EB.Reports.getEnqSelection()<2,1> SETTING EDATE.POS THEN
        Y.END.DT = EB.Reports.getEnqSelection()<4, EDATE.POS>
    END

    SEL.CMD = 'SELECT ':FN.TELLER.HIS:' WITH VALUE.DATE.1 GE ':Y.ST.DT:' AND VALUE.DATE.1 LE ':Y.END.DT
*
    EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, '', NO.OF.REC, SystemReturnCode)
*
    LOOP
        REMOVE Y.TT.ID FROM SEL.LIST SETTING POS
    WHILE Y.TT.ID:POS
        EB.DataAccess.FRead(FN.TELLER.HIS, Y.TT.ID, REC.TT, F.TELLER.HIS, Er)
*
        Y.TR.CODE = REC.TT<TT.Contract.Teller.TeTransactionCode>
        Y.TR.DATE = REC.TT<TT.Contract.Teller.TeValueDateOne>
        Y.ACC = REC.TT<TT.Contract.Teller.TeAccountTwo>
        Y.AMT = REC.TT<TT.Contract.Teller.TeNetAmount>
        Y.CO.CODE = REC.TT<TT.Contract.Teller.TeCoCode>

        Y.DATA<-1> = Y.TT.ID:'*':Y.TR.CODE:'*':Y.TR.DATE:'*':Y.ACC:'*':Y.AMT:'*':Y.CO.CODE
* :'*':Y.ACC.VALUE.DATE:'*':Y.AD.MATURITY.INS:'*':Y.INTEREST.RATE:'*':Y.ROLLLOVER.TERM:'*':Y.CO.CODE
        Y.DATA = SORT(Y.DATA)
    REPEAT
*
RETURN
END
