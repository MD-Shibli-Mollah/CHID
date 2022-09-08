SUBROUTINE COMMERCIAL.DATA.EXTRACT.POST
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.DataAccess
    $USING EB.SystemTables

    Y.NEW.LINE = CHARX(10)
    Y.HEADER = 'Customer Number,Organisation Registration Number,Organisation Registration Date,Organisation Registered Name (English),Organisation Trading Name (English),Organisation Status,Organisation Status Effective Date,Organisation Industrial Sector,Town-1,Street Number and Name (English)-1,City-1,Postal Code-1,Country-1,Unformatted address 1 (English),Email Address-1,Email Address-3,Contact Number - Number 1,Contact Number - Number 2,Contact Number - Unformatted 1,Account Type,Account Number,Date Issued,Product Type,Currency,Product Limit / Original Amount / Opening Balance,Product Expiry Date,Product Status,Close Date,Tenure,Loan Interest Rate,Last Payment Date,Last Amount Paid,Outstanding Balance,Overdue Amount,Total Principal, Total Interest, Next Payment Date,Days Overdue,Loss Status,Loss Outstanding Balance,Collateral Type-1,Collateral Market Value-1,Collateral Forced Sale Value-1,Collateral Description-1 (English),Collateral Address-1 (English),Collateral Type-2,Collateral Market Value-2,Collateral Forced Sale Value-2,Collateral Description-2 (English),Collateral Address-2 (English),Collateral Type-3,Collateral Market Value-3,Collateral Forced Sale Value-3,Collateral Description-3 (English),Collateral Address-3 (English)'
    Y.ARR = ''
    
    FN.MMCB.COMMERCIAL.WRK= 'F.MMCB.COMMERCIAL.WRK'
    F.MMCB.COMMERCIAL.WRK=''
    EB.DataAccess.Opf(FN.MMCB.COMMERCIAL.WRK,F.MMCB.COMMERCIAL.WRK)
  
    SEL.CMD = "SELECT " : FN.MMCB.COMMERCIAL.WRK
    EB.DataAccess.Readlist(SEL.CMD, SEL.LIST,'', NO.OF.REC, RET.CODE)
    IF (SEL.LIST) THEN
        LOOP
            REMOVE Y.ID FROM SEL.LIST SETTING POS
        WHILE Y.ID : POS
            EB.DataAccess.FRead(FN.MMCB.COMMERCIAL.WRK,Y.ID,R.MMCB.COMMERCIAL.WRK,F.MMCB.COMMERCIAL.WRK,ERR)
            IF (R.MMCB.COMMERCIAL.WRK) THEN
                LOCATE R.MMCB.COMMERCIAL.WRK IN Y.ARR BY 'AL' SETTING POS ELSE
                    INS R.MMCB.COMMERCIAL.WRK BEFORE Y.ARR<POS>
                END
            END
        REPEAT
    END
    Y.ARR = Y.HEADER : @FM : Y.ARR
    CONVERT @FM TO Y.NEW.LINE IN Y.ARR
    
    FileName = 'COMMERCIAL.':EB.SystemTables.getToday():'.csv'
    FilePath =  '/Temenos/T24Enterprise/CLIENT_BUILD/UD/MMCB.DATA'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ Y.ARR TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
    
*********Clear records from temporary work file***********
    DEL.CMD = 'CLEAR-FILE ': FN.MMCB.COMMERCIAL.WRK
    EXECUTE DEL.CMD
    
RETURN

END
