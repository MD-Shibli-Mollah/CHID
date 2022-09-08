SUBROUTINE CONSUMER.DATA.EXTRACT.POST
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
    Y.HEADER = 'Customer ID,ID Number-1,ID Expiry Date-1,Date of Birth,Name 1 (English),Name 2 (English),Name 3 (English),Fathers Name 1 (English),Gender ,Marital Status ,Nationality Code ,Race (English),Street Number and Name (English)-1,City-1,Postal Code-1,Country-1,Unformatted address 1 (English),Email Address,Contact Number Type 1,Contact Number- Number 1,Contact Number- Unformatted 1,Contact Number Type 2,Industrial Sector-1,Business Type-1,Employer-1 Country,Employer-1 Unformatted address 1 (English),Occupation-1 (English),Currency-1,Monthly Basic Salary / Income-1 ,Account Number,Date Issued,Product Type,Currency,Product Limit / Original Amount / Opening Balance,Product Expiry Date,Close Date,Tenure,Loan Interest Rate,Last Payment Date,Last Amount Paid,Outstanding Balance,Overdue Amount,Total Principal, Total Interest, Next Payment Date,Days overdue,Loss Status,Loss Outstanding Balance,Collateral Type-1,Collateral Reference-1 (English),Collateral Market Value-1,Collateral Forced Sale Value-1'
    Y.ARR = ''
    
    FN.MMCB.CONSUMER.WRK= 'F.MMCB.CONSUMER.WRK'
    F.MMCB.CONSUMER.WRK=''
    EB.DataAccess.Opf(FN.MMCB.CONSUMER.WRK,F.MMCB.CONSUMER.WRK)

    SEL.CMD = "SELECT " : FN.MMCB.CONSUMER.WRK
    EB.DataAccess.Readlist(SEL.CMD, SEL.LIST,'', NO.OF.REC, RET.CODE)
    IF (SEL.LIST) THEN
        LOOP
            REMOVE Y.ID FROM SEL.LIST SETTING POS
        WHILE Y.ID : POS
            EB.DataAccess.FRead(FN.MMCB.CONSUMER.WRK,Y.ID,R.MMCB.CONSUMER.WRK,F.MMCB.CONSUMER.WRK,ERR)
            IF (R.MMCB.CONSUMER.WRK) THEN
                LOCATE R.MMCB.CONSUMER.WRK IN Y.ARR BY 'AL' SETTING POS ELSE
                    CRT "Inserting " : Y.ID : "to the array"
                    INS R.MMCB.CONSUMER.WRK BEFORE Y.ARR<POS>
                END
            END
        REPEAT
    END
    Y.ARR = Y.HEADER : @FM : Y.ARR
    CONVERT @FM TO Y.NEW.LINE IN Y.ARR

    FileName = 'CONSUMER.':EB.SystemTables.getToday():'.csv'
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
    DEL.CMD = 'CLEAR-FILE ': FN.MMCB.CONSUMER.WRK
    EXECUTE DEL.CMD
 
RETURN
END
