* @ValidationCode : MjotMTQxNjIwMTEwMzpDcDEyNTI6MTY0NTYwNjAxOTY5OTp1c2VyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 Feb 2022 14:46:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE CHDB.I.FORMAT.NRC
*-----------------------------------------------------------------------------
* Modification History 1 : Comment out from 110 - 114
* 23/02/2022 -                            Retrofit   - MD. SHIBLI MOLLAH,
*                                                 FDS Bangladesh Limited
*------------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COMPANY

*-----------------------------------------------------------------------------
*IF OFS$OPERATION EQ 'PROCESS' THEN
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

INITIALISE:

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)
 
    Y.APP = 'CUSTOMER'
    Y.FLD = 'L.REGION':VM:'L.TOWNSHIP':VM:'L.NATIONAL':VM:'L.NRC.SER.NO':VM:'L.OLD.NRC.NO'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD,Y.POS)
 
    Y.REG.POS = Y.POS<1,1>
    Y.TOWNSHIP.POS = Y.POS<1,2>
    Y.NAT.POS = Y.POS<1,3>
    Y.SERIAL.POS = Y.POS<1,4>
    Y.OLD.NRC.POS = Y.POS<1,5>
 
RETURN
 
PROCESS:

    Y.CUS.ID = ID.NEW
    Y.COMPANY = ID.COMPANY
    CALL F.READ(FN.COMPANY,Y.COMPANY,R.COMP,F.COMPANY,COM.ERR)
    Y.LOCAL.COUNTRY = R.COMP<EB.COM.LOCAL.COUNTRY>

    Y.NATIONALITY = R.NEW(EB.CUS.NATIONALITY)
    Y.DOB = R.NEW(EB.CUS.DATE.OF.BIRTH)
    Y.NRC.REG = R.NEW(EB.CUS.LOCAL.REF)<1,Y.REG.POS>
    Y.NRC.TOWNSHIP = R.NEW(EB.CUS.LOCAL.REF)<1,Y.TOWNSHIP.POS>
    Y.NRC.NATIONAL = R.NEW(EB.CUS.LOCAL.REF)<1,Y.NAT.POS>
    Y.NRC.SERIAL.NO = R.NEW(EB.CUS.LOCAL.REF)<1,Y.SERIAL.POS>
    Y.OLD.NRC.NO = R.NEW(EB.CUS.LOCAL.REF)<1,Y.OLD.NRC.POS>
 
    IF Y.LOCAL.COUNTRY NE Y.NATIONALITY THEN
        RETURN
    END

    AGE = ''
    CALL APPL.CALC.AGE(AGE,TODAY,Y.DOB)
    IF AGE LT "18" THEN
        RETURN
    END
    IF (Y.NRC.SERIAL.NO NE '') THEN
 
        Y.FORMAT.NRC = Y.NRC.REG:'/':Y.NRC.TOWNSHIP:'(':Y.NRC.NATIONAL:')':Y.NRC.SERIAL.NO
    END
    IF (Y.OLD.NRC.NO NE '') AND (Y.NRC.SERIAL.NO EQ '') THEN
 
        Y.FORMAT.NRC = Y.OLD.NRC.NO
    END
    IF (Y.NRC.SERIAL.NO EQ '') AND (Y.OLD.NRC.NO EQ '') THEN
        E = "EB-MAND.INPUT.NRC.NO"
        AF = Y.NRC.SERIAL.NO
        CALL STORE.END.ERROR
        RETURN

    END
    IF (Y.NRC.SERIAL.NO NE '') AND (Y.OLD.NRC.NO NE '') THEN
        E = "EB-ANYONE.NRC.NO.ALLOWED"
        CALL STORE.END.ERROR
    END
 
    R.NEW(EB.CUS.LEGAL.ID)<1,1> = Y.FORMAT.NRC
    Y.NRC = 1
    Y.NRC.TEMP = R.NEW(EB.CUS.LEGAL.ID)
    AF = EB.CUS.LEGAL.ID
    AV = Y.NRC
    CALL DUP
    R.NEW(EB.CUS.LEGAL.DOC.NAME)<1,1>= 'NATIONAL.ID'

****COMMENT OUT BY FDS *****
* IF R.OLD(EB.CUS.LEGAL.ISS.DATE)<1,1> EQ '' THEN
*
* R.NEW(EB.CUS.LEGAL.ISS.DATE)<1,1> = TODAY
*END

RETURN

END
