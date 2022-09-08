SUBROUTINE COMMERCIAL.DATA.EXTRACT.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_COMMERCIAL.DATA.EXTRACT.COMMON
    $USING EB.DataAccess
    
    Y.SERVICE.MODE = BATCH.DETAILS<3,1>
    IF NOT(Y.SERVICE.MODE) THEN
        Y.SERVICE.MODE = 'ALL'
    END
    CRT 'Y.SERVICE.MODE - ':Y.SERVICE.MODE

  
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
        SEL.CMD = 'SELECT FBNK.CUSTOMER WITH SECTOR EQ 2001'
    END

    EB.DataAccess.Readlist(SEL.CMD, SEL.LIST,'', NO.OF.REC, RET.CODE)

    CALL BATCH.BUILD.LIST('', SEL.LIST)
    
RETURN
END
