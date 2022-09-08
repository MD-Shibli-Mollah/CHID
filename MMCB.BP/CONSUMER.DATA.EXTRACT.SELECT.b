* @ValidationCode : MjotMjA5NDkwMzk0OTpDcDEyNTI6MTYyOTY5OTIxNTgwNDpBS0hUQVI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxOTEwLjE6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 Aug 2021 12:13:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : AKHTAR
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201910.1

SUBROUTINE CONSUMER.DATA.EXTRACT.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_CONSUMER.DATA.EXTRACT.COMMON
    $USING EB.DataAccess
    
    Y.SERVICE.MODE = BATCH.DETAILS<3,1>
*    IF NOT(Y.SERVICE.MODE) THEN
*        Y.SERVICE.MODE = 'ALL'
*    END
    CRT 'Y.SERVICE.MODE - ':Y.SERVICE.MODE

    SEL.CMD = ''
   
    IF Y.SERVICE.MODE EQ 'ACCOUNTS' THEN
        SEL.CMD = 'SELECT FBNK.AA.ARRANGEMENT WITH PRODUCT.LINE EQ ACCOUNTS'
    END
    ELSE IF Y.SERVICE.MODE EQ 'DEPOSITS' THEN
        SEL.CMD = 'SELECT FBNK.AA.ARRANGEMENT WITH PRODUCT.LINE EQ DEPOSITS'
    END
    ELSE IF Y.SERVICE.MODE EQ 'LENDING' THEN
        SEL.CMD = 'SELECT FBNK.AA.ARRANGEMENT WITH PRODUCT.LINE EQ LENDING'
    END
    ELSE
        SEL.CMD = 'SELECT FBNK.CUSTOMER WITH SECTOR NE 2001'
    END

    EB.DataAccess.Readlist(SEL.CMD, SEL.LIST,'', NO.OF.REC, RET.CODE)
    
   *SEL.LIST = '100010':@VM:'100024':@VM:'100035':@VM:'100063':@VM:'100110':@VM:'100522':@VM:'100867':@VM:'100893':@VM:'101163':@VM:'102089'
    CALL BATCH.BUILD.LIST('', SEL.LIST)
    
RETURN

END
