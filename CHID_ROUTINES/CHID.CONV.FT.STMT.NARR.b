* @ValidationCode : MjoyMDA0NjM4MTg3OkNwMTI1MjoxNjYxOTQyMjY3MTcxOnVzZXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 Aug 2022 16:37:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : user
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0

SUBROUTINE CHID.CONV.FT.STMT.NARR
*---------------------------------------------------------------------------
*=============================================================================
* Subroutine type    : Subroutine
* Attached to        :
* Primary Purpose    : This Routine used to Fetch and show the Local Field data.
* Created by         : MD SHIBLI MOLLAH
* Change History     :
*=============================================================================

*-----------------------------------------------------------------------------
* Modification History 1 :
* 31/08/2022 -                            Retrofit   - MD. SHIBLI MOLLAH,
*                                                 FDS Bangladesh Limited
*------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $USING FT.Contract
   * $USING TT.Contract
    $USING DC.Contract
    
    $USING EB.SystemTables
    $USING EB.Reports
    $USING EB.Updates
    $USING EB.DataAccess
*-----------------------------------------------------------------------------
    Y.TR.ID = EB.Reports.getOData()
   
*-------READ LOCAL FIELDS------------------------
    APPLICATION.NAMES = 'FUNDS.TRANSFER':FM:'TELLER':FM:'DATA.CAPTURE'
    LOCAL.FIELDS = 'LT.NARRATIVE'
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.LT.FT.POS = FLD.POS<1,1>
    Y.LT.TT.POS = FLD.POS<2,1>
    Y.LT.DC.POS = FLD.POS<3,1>
   
*-------CHECK THE APPLICATION------*
    Y.TR.ID.CK = Y.TR.ID[1,2]
*------------FT CHECK-------------------------*
    IF Y.TR.ID.CK EQ 'FT' THEN
        Y.FT.ID = Y.TR.ID
        
        FN.FT = 'F.FUNDS.TRANSFER'
        F.FT = ''
        EB.DataAccess.Opf(FN.FT,F.FT)
        EB.DataAccess.FRead(FN.FT,Y.FT.ID,R.FT,F.FT,Y.FT.ERR)
        Y.NARR = R.FT<FT.Contract.FundsTransfer.LocalRef,Y.LT.FT.POS>
    END
        
*--------------TT CHECK----------------------*
*------NARRATIVE IS MULTIVALUED,SO, NO NEED TO ADD LT.NARRATIVE for TT------*
*    IF Y.TR.ID.CK EQ 'TT' THEN
*        Y.TT.ID = Y.TR.ID
*
*        FN.TT = 'F.TELLER'
*        F.TT = ''
*        EB.DataAccess.Opf(FN.TT,F.TT)
*        EB.DataAccess.FRead(FN.TT, Y.TT.ID, REC.TT, F.TT, ERR.TT)
*        Y.NARR = REC.TT<TT.Contract.Teller.TeLocalRef,Y.LT.TT.POS>
*    END
            
*--------------DC CHECK-----------------------*
*------NARRATIVE IS MULTIVALUED,SO, NO NEED TO ADD LT.NARRATIVE for DC------*
*    IF Y.TR.ID.CK EQ 'DC' THEN
*        Y.DC.ID = Y.TR.ID
*
*        FN.DC = 'F.DATA.CAPTURE'
*        F.DC = ''
*        EB.DataAccess.Opf(FN.DC,F.DC)
*        EB.DataAccess.FRead(FN.DC, Y.DC.ID, REC.DC, F.DC, ERR.DC)
*        Y.NARR = REC.DC<DC.Contract.DataCapture.DcLocalRef,Y.LT.DC.POS>
*    END
    
    EB.Reports.setOData(Y.NARR)
END


