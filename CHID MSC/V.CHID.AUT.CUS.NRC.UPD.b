* @ValidationCode : Mjo3Mjk5NzkwODY6Q3AxMjUyOjE1Mzg5Nzk3MTEzNTE6bGVlbGFwcmFzaGFudGgudjotMTotMTowOjA6ZmFsc2U6Ti9BOlIxN19TUDExLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Oct 2018 11:51:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : leelaprashanth.v
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_SP11.0
SUBROUTINE V.CHID.AUT.CUS.NRC.UPD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------------------
* Developer  :            SANDHYA N
* Attached As:            Authorisation Routine
* Attached To:            VERSION>CUSTOMER,CHD.INPUT AND CUSTOMER,CHD.CORP
*---------------------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CHID.CUS.NRC.NUM.UPDATE
*----------------------------------------------------------------------------------------------------

    IF V$FUNCTION EQ 'A' THEN
        GOSUB INITIALISE
    END
RETURN

INITIALISE:
*************
    SEL.CNT = ''
    SEL.LIST = ''
    SEL.CMD = ''
    Y.IND.POS = ''
    Y.CORP.POS = ''
    Y.LEGAL.DOC.NAME = ''
    Y.NAT.ID = 'NATIONAL.ID'
    Y.BUS.ID = 'BUS.LICENSE.NO'
    Y.ID.NEW = ID.NEW
    Y.LEGAL.ID = R.NEW(EB.CUS.LEGAL.ID)
    Y.LEGAL.DOC.NAME = R.NEW(EB.CUS.LEGAL.DOC.NAME)
    Y.SECTOR = R.NEW(EB.CUS.SECTOR)
    Y.REC.STATUS = R.NEW(EB.CUS.RECORD.STATUS)
    Y.CUR.NO = R.NEW(EB.CUS.CURR.NO)

    FN.CHID.CUS.NRC.NUM.UPDATE = 'F.CHID.CUS.NRC.NUM.UPDATE'
    F.CHID.CUS.NRC.NUM.UPDATE = ''
    CALL OPF(FN.CHID.CUS.NRC.NUM.UPDATE,F.CHID.CUS.NRC.NUM.UPDATE)
 
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
      
    LOCATE Y.NAT.ID IN Y.LEGAL.DOC.NAME<1,1> SETTING Y.IND.POS THEN
        Y.IND.LEG.ID = R.NEW(EB.CUS.LEGAL.ID)<1,Y.IND.POS>
    END
    LOCATE Y.BUS.ID IN Y.LEGAL.DOC.NAME<1,1> SETTING Y.CORP.POS THEN
        Y.CORP.LEG.ID = R.NEW(EB.CUS.LEGAL.ID)<1,Y.CORP.POS>
    END
        
    IF Y.SECTOR GE '1000' AND Y.SECTOR LE '1999' THEN
        Y.LEGAL.DOC.NAME = Y.NAT.ID
        Y.LEG.ID = Y.IND.LEG.ID
    END
    
    IF Y.SECTOR GE '2000' AND Y.SECTOR LE '9999' THEN
        Y.LEGAL.DOC.NAME = Y.BUS.ID
        Y.LEG.ID = Y.CORP.LEG.ID
    END
    CHANGE " " TO "" IN  Y.LEG.ID

*To check if customer LEGAL.ID is being overwritten, if yes then old LEGAL.ID record is deleted from template and new record is created
    IF (Y.CUR.NO EQ '1') THEN
        SEL.CMD = "SELECT ":FN.CHID.CUS.NRC.NUM.UPDATE:" WITH @ID EQ ":'"':Y.LEG.ID:'"':
        CALL EB.READLIST (SEL.CMD,SEL.LIST,'',SEL.CNT,RTN)
        CALL F.READ(FN.CHID.CUS.NRC.NUM.UPDATE,Y.LEG.ID,R.CHID.CUS.NRC.NUM.UPDATE,F.CHID.CUS.NRC.NUM.UPDATE,ERR)
        Y.CUS.ID = R.CHID.CUS.NRC.NUM.UPDATE<CHID.CUS.CUSTOMER.NO>
        IF SEL.CNT EQ '0' THEN
            IF R.CHID.CUS.NRC.NUM.UPDATE EQ '' THEN
                R.CHID.CUS.NRC.NUM.UPDATE<CHID.CUS.CUSTOMER.NO> = Y.ID.NEW
                R.CHID.CUS.NRC.NUM.UPDATE<CHID.CUS.CUSTOMER.DOC.NAME> = Y.LEGAL.DOC.NAME
                CALL F.WRITE(FN.CHID.CUS.NRC.NUM.UPDATE,Y.LEG.ID,R.CHID.CUS.NRC.NUM.UPDATE)
            END
        END
    END
    ELSE
* Checking whether currently used LEGAL.ID is being used by any other customer if not , then new record is created in template
        SEL.CMD = "SELECT ":FN.CHID.CUS.NRC.NUM.UPDATE:" WITH CUSTOMER.NO EQ ":Y.ID.NEW
        CALL EB.READLIST (SEL.CMD,SEL.LIST,'',SEL.CNT,RTN)
        IF (SEL.LIST NE Y.LEG.ID) THEN
            CALL F.READ(FN.CHID.CUS.NRC.NUM.UPDATE,Y.LEG.ID,R.CHID.CUS.NRC.NUM.UPDATE,F.CHID.CUS.NRC.NUM.UPDATE,ERR)
            R.CHID.CUS.NRC.NUM.UPDATE<CHID.CUS.CUSTOMER.NO> = Y.ID.NEW
            R.CHID.CUS.NRC.NUM.UPDATE<CHID.CUS.CUSTOMER.DOC.NAME> = Y.LEGAL.DOC.NAME
            CALL F.WRITE(FN.CHID.CUS.NRC.NUM.UPDATE,Y.LEG.ID,R.CHID.CUS.NRC.NUM.UPDATE)
            CALL F.DELETE(FN.CHID.CUS.NRC.NUM.UPDATE,SEL.LIST)
        END
        RETURN
    END
 
RETURN
*---------------------------------------------------------------------------------------------------------------

END