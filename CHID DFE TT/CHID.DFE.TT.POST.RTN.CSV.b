* @ValidationCode : MjoxODkzNTg0ODE0OkNwMTI1MjoxNjQwMDAzNzAwNDIxOnVzZXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Dec 2021 18:35:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

SUBROUTINE CHID.DFE.TT.POST.RTN.CSV(Y.TT)

*------------------------------------------------------------------------
*------------------------------------------------------------------------
* Company Name        :
* Developer Name      : MD SHIBLI MOLLAH
* Subroutine Type     : POST Routine
* Attached as         :
* Incoming Parameters : Y.TT
* Outgoing Parameters : Y.TT
* Development Date    : 20-12-2021
*-------------------------------------------------------------------------
* Description         : Post Update Routine
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
    
    $USING TT.Contract
    $USING EB.DataAccess

    GOSUB OPEN.FILES
*
    GOSUB PROCESS
*
    IF Y.TR.CODE EQ '' THEN  Y.TR.CODE = SPACE(12)
    IF Y.TR.DATE EQ '' THEN  Y.TR.DATE = SPACE(12)
    IF Y.CCY EQ '' THEN  Y.CCY = SPACE(12)
    IF Y.ACC EQ '' THEN Y.ACC = SPACE(12)
    IF Y.AMT EQ '' THEN Y.AMT = SPACE(12)
    IF Y.INPUTTER EQ '' THEN Y.INPUTTER = SPACE(12)
    IF Y.AUTH EQ '' THEN Y.AUTH = SPACE(12)
    IF Y.REC.STATUS EQ '' THEN Y.REC.STATUS = SPACE(12)
    IF Y.CO.CODE EQ '' THEN Y.CO.CODE = SPACE(12)

    
    Y.DATA.TT = ''
    Y.DATA.TT = Y.TT.ID:',':Y.TR.CODE:',':Y.TR.DATE:',':Y.CCY:',':Y.ACC:',':Y.AMT:',':Y.INPUTTER:',':Y.AUTH:',':Y.REC.STATUS:',':Y.CO.CODE
    
* CHANGE ',' TO '_' IN Y.DATA.TT
* CHANGE '--' TO '' IN Y.DATA.TT
   
    CHANGE @VM TO '|' IN Y.DATA.TT
    Y.TT = Y.DATA.TT

RETURN

*-------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------

    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    EB.DataAccess.Opf(FN.TELLER.HIS, F.TELLER.HIS)

RETURN

PROCESS:
*-------------------------------------------------------------------------
    Y.TT.ID = ''
    Y.TT.ID = Y.TT
         
    EB.DataAccess.FRead(FN.TELLER.HIS, Y.TT.ID, REC.TT, F.TELLER.HIS, Er)
*
    Y.TR.CODE = REC.TT<TT.Contract.Teller.TeTransactionCode>
    Y.TR.DATE = REC.TT<TT.Contract.Teller.TeValueDateOne>
    Y.CCY = REC.TT<TT.Contract.Teller.TeCurrencyOne>
    Y.ACC = REC.TT<TT.Contract.Teller.TeAccountTwo>
    Y.AMT = REC.TT<TT.Contract.Teller.TeNetAmount>
* Y.AMT = FMT(Y.AMT,"R2#20")

************************************************************************
    Y.DATE = Y.TR.DATE
    Y.DATE = ICONV(Y.DATE, 'D4')
    Y.DATE = OCONV(Y.DATE, 'D')
    CRT "Processing... " : Y.TT : "  Of  ": Y.DATE
************************************************************************

    Y.INPUTTER = REC.TT<TT.Contract.Teller.TeInputter>
    Y.INPUTTER = FIELD(Y.INPUTTER,"_",2,1)
    
    Y.AUTH = REC.TT<TT.Contract.Teller.TeAuthoriser>
    Y.AUTH = FIELD(Y.AUTH,"_",2,1)
    
    Y.REC.STATUS = REC.TT<TT.Contract.Teller.TeRecordStatus>
    Y.CO.CODE = REC.TT<TT.Contract.Teller.TeCoCode>
    
RETURN

END
*************************************************************************************************************
