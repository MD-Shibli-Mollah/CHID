* @ValidationCode : MjoxNTU0MjI1MDUyOkNwMTI1MjoxNjI5Njk5MTk0NDExOkFLSFRBUjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE5MTAuMTotMTotMQ==
* @ValidationInfo : Timestamp         : 23 Aug 2021 12:13:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : AKHTAR
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201910.1

SUBROUTINE CONSUMER.DATA.EXTRACT (Y.ID)
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
    $INSERT I_DAS.AA.ARRANGEMENT
    
    $USING EB.DataAccess
    $USING ST.Customer
    $USING AC.AccountOpening
    $USING AA.Framework
    $USING AA.TermAmount
    $USING AA.Closure
    $USING AA.Account
    $USING AA.Interest
        
    IF NOT(Y.ID) THEN
        RETURN
    END
    CRT "Processing... " : Y.ID

    
    TEMP.ID = ''
    IF Y.ID[1,2] EQ 'AA' THEN
        Y.ARR.ID = Y.ID
        CALL GET.ARR.DATA(Y.ARR.ID, ARR.REC)

        EB.DataAccess.FRead(FN.ARR, Y.ARR.ID, R.ARR, F.ARR, ERR.ARR)
        CUS.IDS = R.ARR<AA.Framework.Arrangement.ArrCustomer>
        CusCnt = DCOUNT(CUS.IDS, @VM)
        FOR I=1 TO CusCnt
            CUS.ID = CUS.IDS<1,I>
            EB.DataAccess.FRead(FN.CUS, CUS.ID, R.CUS, F.CUS, ERR.CUS)
            IF R.CUS<ST.Customer.Customer.EbCusSector> NE 2001 THEN ;* select only individual customer
                CALL GET.CUS.DATA(CUS.ID, CUS.REC)
                Y.MERGE.FILE = CUS.REC:'~':ARR.REC
                TEMP.ID = Y.ARR.ID : '-' : CUS.ID
                GOSUB WRITE.FILE
                CUS.REC = ''
                Y.MERGE.FILE = ''
                TEMP.ID = ''
            END
        NEXT I
    END
    
    IF Y.ID[1,2] NE 'AA' THEN
        CUS.ID = Y.ID

        CALL GET.CUS.DATA(CUS.ID, CUS.REC)
*        SEL.ARR.ID = 'SELECT ':FN.ARR:' WITH CUSTOMER EQ ':CUS.ID
*        EB.DataAccess.Readlist(SEL.ARR.ID, SEL.ARR.ID.LIST,'', NO.OF.REC, RET.CODE)

*        SEL.ARR.ID.LIST = DAS.AA.ARRANGEMENT$CUSTOMER
*        CALL DAS('AA.ARRANGEMENT', SEL.ARR.ID.LIST, CUS.ID, "")
*
*        SEL.ARR.ID.LIST = 'SELECT ':FN.CUS.ARR:' WITH @ID EQ ':CUS.ID
*        EB.DataAccess.Readlist(SEL.ARR.ID, SEL.ARR.ID.LIST,'', NO.OF.REC, RET.CODE)

*        IF SEL.ARR.ID.LIST EQ '' THEN
*            Y.MERGE.FILE = CUS.REC
*            TEMP.ID = CUS.ID
*            GOSUB WRITE.FILE
*            Y.MERGE.FILE = ''
*            TEMP.ID = ''
*            RETURN
*        END
*        ELSE
*            LOOP
*                REMOVE Y.ARR.ID FROM SEL.ARR.ID.LIST SETTING PTR
*            WHILE Y.ARR.ID : PTR
*                CALL GET.ARR.DATA(Y.ARR.ID, ARR.REC)
*                Y.MERGE.FILE = CUS.REC:'~':ARR.REC
*                TEMP.ID = CUS.ID : '-' : Y.ARR.ID
*                GOSUB WRITE.FILE
*                ARR.REC = ''
*                Y.MERGE.FILE = ''
*                TEMP.ID = ''
*            REPEAT
*        END
        EB.DataAccess.FRead(FN.CUS.ARR, CUS.ID, R.CUS.ARR, F.CUS.ARR, Err.Cus.Arr)
        IF NOT(R.CUS.ARR) THEN
            Y.MERGE.FILE = CUS.REC
            TEMP.ID = CUS.ID
            GOSUB WRITE.FILE
            Y.MERGE.FILE = ''
            TEMP.ID = ''
            RETURN
        END
        ELSE
            ARR.IDS = R.CUS.ARR<AA.Framework.CustomerArrangement.CusarrArrangement>
            ArrVMCnt = DCOUNT(ARR.IDS, @VM)
            FOR ArrVCnt=1 TO ArrVMCnt
                ArrSMCnt = DCOUNT(ARR.IDS<1,ArrVCnt>,@SM)
                FOR ArrSCnt= 1 TO ArrSMCnt
                    Y.ARR.ID = ARR.IDS<1,ArrVCnt,ArrSCnt>
                    CALL GET.ARR.DATA(Y.ARR.ID, ARR.REC)
                    Y.MERGE.FILE = CUS.REC:'~':ARR.REC
                    TEMP.ID = CUS.ID : '-' : Y.ARR.ID
                    GOSUB WRITE.FILE
                    ARR.REC = ''
                    Y.MERGE.FILE = ''
                    TEMP.ID = ''
                NEXT ArrSCnt
            NEXT ArrVCnt
        END
    END
RETURN

WRITE.FILE:
**** Replace all the comma in data with space ********
    CONVERT ',' TO ' ' IN Y.MERGE.FILE
**** Replace temporary delimeter '*' to final delimeter ','********
    CONVERT '~' TO ',' IN Y.MERGE.FILE

    EB.DataAccess.FWrite(FN.MMCB.CONSUMER.WRK, TEMP.ID, Y.MERGE.FILE)
RETURN

END


