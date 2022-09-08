* @ValidationCode : MjotMTUyODg2MjI3OTpDcDEyNTI6MTY2MjI4ODg0MTc0ODp1c2VyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Sep 2022 16:54:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
SUBROUTINE CHID.V.FT.TT.DC.RESTRCT
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Developed by MD SHIBLI MOLLAH FDS -- on 04TH SEP 2022
* THIS ROUTINE VALIDATES THE CATEGOUNT NUMBER TO CHECK the category Description named “***Not Used***
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING ST.Config
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*********************
INIT:
********************

    FN.CATEG = "F.CATEGORY"
    F.CATEG = ""

RETURN

********************
OPENFILES:
    EB.DataAccess.Opf(FN.CATEG, F.CATEG)

RETURN

*****************
PROCESS:
*****************
    Y.ACC.NO = EB.SystemTables.getComi()
*
    Y.CATEGORY = Y.ACC.NO[4,5]
    
    EB.DataAccess.FRead(FN.CATEG, Y.CATEGORY, R.CATEG, F.CATEG, CATEG.ERR)
    Y.CATEG.DESC = R.CATEG<ST.Config.Category.EbCatDescription>
 
    IF Y.CATEG.DESC EQ "***Not Used***" THEN
        EB.SystemTables.setEtext("Enter a Valid Account Number")
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
END