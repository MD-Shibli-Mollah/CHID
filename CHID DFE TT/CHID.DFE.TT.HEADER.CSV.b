* @ValidationCode : MjoxNjk3NTg2OTpDcDEyNTI6MTYzOTk5NjQ0ODM3Nzp1c2VyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Dec 2021 16:34:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

SUBROUTINE CHID.DFE.TT.HEADER.CSV(Y.HEADER)

*-----------------------------------------------------------------------------
* This is a Header routine for CHID DFE Teller
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
    Y.HEADER = 'Transaction.Reference':',':'Transaction.Code':',':'Date':',':'Currency':',':'ACNo':',':'Amount':',':'Inputter':',':'Authorizer':',':'Record.Status':',':'Co.code'
RETURN
END