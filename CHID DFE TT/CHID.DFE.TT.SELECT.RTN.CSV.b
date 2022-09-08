* @ValidationCode : MjoyNDkxNzE5NzM6Q3AxMjUyOjE2NDAwNjEzNzQyMjU6dXNlcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE3MTAuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Dec 2021 10:36:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

SUBROUTINE CHID.DFE.TT.SELECT.RTN.CSV(Y.TT)

*This is a Selection routine
*------------------------------------------------------------------------
* Generic Comments    :
*------------------------------------------------------------------------
* Company Name        :
* Developer Name      : MD SHIBLI MOLLAH
* Subroutine Type     : DFE FILE SELECTION Routine
* Attached as         :
* Incoming Parameters : NA
* Outgoing Parameters : Y.TT
* Development Date    : 20-12-2021
*-------------------------------------------------------------------------
* Description         : Select routine
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
    
    GOSUB OPENFILES
*
    GOSUB PROCESS
*

RETURN

**********
OPENFILES:
**********
    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    EB.DataAccess.Opf(FN.TELLER.HIS, F.TELLER.HIS)

RETURN

********
PROCESS:
********
*
    SEL.CMD = 'SELECT ':FN.TELLER.HIS:' WITH VALUE.DATE.1 GE 20190101 AND VALUE.DATE.1 LE 20210101'
    SEL.LIST = ''
    EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, '', NO.OF.REC, SystemReturnCode)

    Y.TT = SEL.LIST

RETURN

END