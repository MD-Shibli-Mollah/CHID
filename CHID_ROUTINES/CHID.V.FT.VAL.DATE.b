* @ValidationCode : MjoyNTQxNzk1MjA6Q3AxMjUyOjE2NjI2MjAzMDcxNTk6dXNlcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE3MTAuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Sep 2022 12:58:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
SUBROUTINE CHID.V.FT.VAL.DATE
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Developed by MD SHIBLI MOLLAH FDS -- on 04TH SEP 2022
* THIS ROUTINE VALIDATES THE VALUE DATE TO CHECK EITHER it's forward Dated or Back Dated
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING FT.Contract
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*********************
INIT:
********************

*    FN.FT = "F.FUNDS.TRANSFER"
*    F.FT = ""

RETURN

********************
OPENFILES:
* EB.DataAccess.Opf(FN.FT, F.FT)

RETURN

*****************
PROCESS:
*****************
    Y.TODAY = EB.SystemTables.getToday()
* Y.USER = EB.SystemTables.getRUser()
*-----------------ATTRIBUTES------------------------*
    Y.USER.ATTR = EB.SystemTables.getRUser()<54,1>

    Y.VAL.DATE = EB.SystemTables.getComi()
       
*    EB.DataAccess.FRead(FN.FT, Y.FTORY, R.FT, F.FT, FT.ERR)
*    Y.FT.DESC = R.FT<ST.Config.FTory.EbCatDescription>

    IF Y.USER.ATTR EQ 'SUPER.USER' THEN
        RETURN
    END
 
    IF Y.VAL.DATE NE Y.TODAY THEN
        EB.SystemTables.setEtext("(Back-Date or Forward-Date is not allowed) Enter Today's Current Date.")
        EB.ErrorProcessing.StoreEndError()
    END
    
*******-------------------------- TRACER ------------------------------------------------------------------------------
    WriteData = ' TODAY Date: ':Y.TODAY:" Value Date-Comi : ":Y.VAL.DATE:" Usr Attribute : ":Y.USER.ATTR
    FileName = 'CHID_VAL_TEST_8_Sep_2022.txt'
    FilePath = 'DL.BP'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteData APPEND TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput

*******-------------------------- TRACER -END--------------------------------------------------------*********************
    
RETURN
END