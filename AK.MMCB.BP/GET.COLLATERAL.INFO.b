SUBROUTINE GET.COLLATERAL.INFO (CUS.ID, Y.ARR.ID, COLL.ARR)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_CONSUMER.DATA.EXTRACT.COMMON

    $USING AC.API
    $USING RE.ConBalanceUpdates
    $USING AA.Framework
    $USING CO.Contract
    $USING CO.Config
    $USING AA.Limit
    $USING AL.ModelBank
    $USING LI.Config
    $USING AA.ModelBank
    $USING EB.DataAccess
*-----------------------------------------------------------------------------

    IF CUS.ID EQ '' OR Y.ARR.ID EQ '' THEN
        RETURN
    END
    
    COLL.ARR = ''
    
    FN.LIMIT = 'F.LIMIT'
    F.LIMIT =''
    EB.DataAccess.Opf(FN.LIMIT,F.LIMIT)
    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL=''
    EB.DataAccess.Opf(FN.COLLATERAL,F.COLLATERAL)

    FN.COLLATERAL.TYPE= 'F.COLLATERAL.TYPE'
    F.COLLATERAL.TYPE=''
    EB.DataAccess.Opf(FN.COLLATERAL.TYPE,F.COLLATERAL.TYPE)
    
    PROP.CLASS = 'LIMIT'
    AA.Framework.GetArrangementConditions(Y.ARR.ID, PROP.CLASS, PROPERTY, '', RETURN.IDS, RETURN.VALUES, ERR.MSG)
    R.ARR.LIMIT = RAISE(RETURN.VALUES)
    Y.LIMIT.REF = R.ARR.LIMIT<AA.Limit.Limit.LimLimitReference>
    IF NOT(Y.LIMIT.REF) THEN
        RETURN
    END
*    IF LEN(Y.LIMIT.REF) EQ 3 THEN
*        Y.LIMIT.REF='0000':Y.LIMIT.REF
*    END
*    IF LEN(Y.LIMIT.REF) EQ 4 THEN
*        Y.LIMIT.REF='000':Y.LIMIT.REF
*    END

    Y.LIMIT.REF = FMT(Y.LIMIT.REF,"R%7")

    Y.LIMIT.SL.NO = R.ARR.LIMIT<AA.Limit.Limit.LimLimitSerial>
    Y.LIMIT.ID = CUS.ID:'.':Y.LIMIT.REF:'.':Y.LIMIT.SL.NO
 
    EB.DataAccess.FRead(FN.LIMIT, Y.LIMIT.ID, R.LIMIT, F.LIMIT , LIMIT.ERR)

    COLL.RIGHTS = R.LIMIT<LI.Config.Limit.CollatRight>
   
	Y.COLL.RIGHT.CNT = DCOUNT(COLL.RIGHTS,@VM)

    FOR I= 1 TO Y.COLL.RIGHT.CNT
		Y.SM.CNT = DCOUNT(COLL.RIGHTS<1,I>,@SM)
        FOR J= 1 TO Y.SM.CNT
            COLL.RIGHT.ID = COLL.RIGHTS<1,I,J>
*CRT "COLL.RIGHT.ID : " : COLL.RIGHT.ID
            GOSUB GET.COLLATERAL.INFO
       
        NEXT J
    NEXT I
RETURN

GET.COLLATERAL.INFO:
    SEL.CMD = "SELECT " : FN.COLLATERAL : " WITH @ID LIKE " : COLL.RIGHT.ID :'...'
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    LOOP
        REMOVE Y.COLL.ID FROM SEL.LIST SETTING Y.COLL.POS
    WHILE Y.COLL.ID:Y.COLL.POS
        EB.DataAccess.FRead(FN.COLLATERAL,Y.COLL.ID,R.COLLATERAL,F.COLLATERAL,COLL.ERR)
        COLL.TYPE.ID = R.COLLATERAL<CO.Contract.Collateral.CollCollateralType>
        EB.DataAccess.FRead(FN.COLLATERAL.TYPE,COLL.TYPE.ID,R.COLLATERAL.TYPE,F.COLLATERAL.TYPE,COLL.TYPE.ERR)
        COLL.REF = R.COLLATERAL.TYPE<CO.Config.CollateralType.CollTypeDescription>
        COLL.MARKET.VAL = R.COLLATERAL<CO.Contract.Collateral.CollNominalValue>
        COLL.FORCED.SALE.VAL = R.COLLATERAL<CO.Contract.Collateral.CollExecutionValue>
        COLL.ADDR = R.COLLATERAL<CO.Contract.Collateral.CollAddress>
        COLL.ARR<-1> = COLL.TYPE.ID :@VM:COLL.REF:@VM:COLL.MARKET.VAL:@VM:COLL.FORCED.SALE.VAL:@VM:COLL.ADDR
        COLL.TYPE.ID=''
        COLL.REF=''
        COLL.MARKET.VAL=''
        COLL.FORCED.SALE.VAL=''
        COLL.ADDR=''
    REPEAT
RETURN
END
