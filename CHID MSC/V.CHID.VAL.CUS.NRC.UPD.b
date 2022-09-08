* @ValidationCode : MjoxMjc4NjQzODE3OkNwMTI1MjoxNTM4OTc5ODQzODMzOmxlZWxhcHJhc2hhbnRoLnY6LTE6LTE6MDowOmZhbHNlOk4vQTpSMTdfU1AxMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 08 Oct 2018 11:54:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : leelaprashanth.v
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_SP11.0
SUBROUTINE V.CHID.VAL.CUS.NRC.UPD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------------------
* Developer  :            SANDHYA N
* Attached As:            INPUT Routine
* Attached To:            VERSION>CUSTOMER,CHD.INPUT AND CUSTOMER,CHD.CORP
*---------------------------------------------------------------------------------------------------
* Modification History :
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CHID.CUS.NRC.NUM.UPDATE
    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
******
    SEL.CNT = ''
    SEL.LIST = ''
    SEL.CMD = ''
    POS = ''
    Y.LEGAL.DOC.NAME = ''
    Y.ID.NEW = ID.NEW
    Y.SECTOR = R.NEW(EB.CUS.SECTOR)
    Y.NAT.ID = 'NATIONAL.ID'
    Y.BUS.ID = 'BUS.LICENSE.NO'
    FN.CHID.CUS.NRC.NUM.UPDATE = 'F.CHID.CUS.NRC.NUM.UPDATE'
    F.CHID.CUS.NRC.NUM.UPDATE = ''
    CALL OPF(FN.CHID.CUS.NRC.NUM.UPDATE,F.CHID.CUS.NRC.NUM.UPDATE)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CUSTOMER$NAU = 'F.CUSTOMER$NAU'
    F.CUSTOMER$NAU = ''
    CALL OPF(FN.CUSTOMER$NAU,F.CUSTOMER$NAU)
    
    Y.LEGAL.ID = R.NEW(EB.CUS.LEGAL.ID)
    Y.LEGAL.DOC.NAME = R.NEW(EB.CUS.LEGAL.DOC.NAME)

    LOCATE Y.NAT.ID IN Y.LEGAL.DOC.NAME<1,1> SETTING POS THEN
        Y.IND.LEG.ID = R.NEW(EB.CUS.LEGAL.ID)<1,POS>
    END
    LOCATE Y.BUS.ID IN Y.LEGAL.DOC.NAME<1,1> SETTING POS THEN
        Y.CORP.LEG.ID = R.NEW(EB.CUS.LEGAL.ID)<1,POS>
    END
    

RETURN
*-------
PROCESS:
*-------
   
    IF Y.SECTOR GE '1000' AND Y.SECTOR LE '1999' THEN
        Y.LEGAL.DOC.NAME = Y.NAT.ID
        Y.LEG.ID = Y.IND.LEG.ID
    END
    IF Y.SECTOR GE '2000' AND Y.SECTOR LE '9999' THEN
        Y.LEGAL.DOC.NAME = Y.BUS.ID
        Y.LEG.ID = Y.CORP.LEG.ID
    END
    CHANGE ' ' TO '' IN Y.LEG.ID
    
    IF Y.LEG.ID EQ '' THEN
        RETURN
    END
    
    IF (Y.IND.LEG.ID NE '') AND (Y.CORP.LEG.ID NE '') THEN
        TEXT = "EB-NRC.BLN.NOT.VALID"
        CALL STORE.OVERRIDE('')
    END
    
*To check whether we are Overwriting LEGAL.ID of the customer
    SEL.CMD = "SELECT ":FN.CHID.CUS.NRC.NUM.UPDATE:" WITH CUSTOMER.NO EQ ":Y.ID.NEW
    CALL EB.READLIST (SEL.CMD,SEL.LIST,'',SEL.CNT,RTN)
    IF (SEL.LIST NE '') AND (SEL.LIST NE Y.LEG.ID) THEN
        TEXT="EB-OVERWRITE.LEG.ID":FM:SEL.LIST:VM:Y.LEG.ID
        CALL STORE.OVERRIDE('')
    END
    
*To check whether currently used LEGAL.ID is being used by any other customer which is not authorised
    SEL.CMD1 = "SELECT ":FN.CUSTOMER$NAU:" WITH LEGAL.ID EQ ":'"':Y.LEG.ID:'"':
    CALL EB.READLIST (SEL.CMD1,SEL.LIST1,'',SEL.CNT1,RTN)
    IF (SEL.CNT1 NE '0') AND (SEL.LIST1 NE Y.ID.NEW) THEN
        AF = EB.CUS.LEGAL.ID
        ETEXT="EB-NRC.BLN.MATCH.NAU":FM:SEL.LIST1
        CALL STORE.END.ERROR
    END
    
*To check whether currently being used LEGAL.ID is used by any customer which are already authorised

    SEL.CMD2 = "SELECT ":FN.CHID.CUS.NRC.NUM.UPDATE:" WITH @ID EQ ":'"':Y.LEG.ID:'"':
    CALL EB.READLIST (SEL.CMD2,SEL.LIST2,'',SEL.CNT2,RTN)
    CALL F.READ(FN.CHID.CUS.NRC.NUM.UPDATE,Y.LEG.ID,R.CHID.CUS.NRC.NUM.UPDATE,F.CHID.CUS.NRC.NUM.UPDATE,ERR)
    Y.CUS.ID = R.CHID.CUS.NRC.NUM.UPDATE<CHID.CUS.CUSTOMER.NO>
    IF (SEL.CNT2 NE '0') AND (Y.CUS.ID NE Y.ID.NEW) THEN
        AF = EB.CUS.LEGAL.ID
        ETEXT = 'EB-DUP.NRC.BLN':FM:Y.CUS.ID
        CALL STORE.END.ERROR
    END
        
    AF = EB.CUS.LEGAL.DOC.NAME
    CALL DUP

RETURN
*--------------------------------------------------------------------------------------------------------

END

