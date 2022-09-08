    SUBROUTINE MCB.DFE.INTRF.002.HEADER(Y.HEADER)
*-----------------------------------------------------------------------------
* This is Header routine for MOB.DFE.INTRF.002
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
    Y.HEADER = 'ArrangementID':';':'Currency':';':'CustomerNo':';':'ACNo':';':'CustomerName':';':'CustomerAddress':';':'Joint01':';':'Joint02':';':'Joint03':';':'WorkingBalance':';':'AlternateAC':';':'OriginalContractdate':';':'LastRenewalDate':';'
    Y.HEADER := 'NextPaymentDate':';':'ACCrInterestRate':';':'ACDrInterestRate':';':'DepInterestRate':';':'LoanPrincipalInterestRate':';':'LoanPenalInterestRate':';':'AcCrAccrueAmount':';':'AcDrAccrueAmount':';':'DEPAccrueAmount':';':'LoanPrincpalAccrueAmount':';':'LoanPenalityAccrueAmount':';'
    Y.HEADER := 'DELACCOUNT':';':'DUEACCOUNT':';':'NABACCOUNT':';':'GRCACCOUNT':';':'UNCACCOUNT':';':'UNDACCOUNT':';':'STDACCOUNT':';':'SSTACCOUNT':';':'DBTACCOUNT':';':'WATACCOUNT':';':'LSSACCOUNT':';':'STDPRINICIPALINT':';':'SSTPRINICIPALINT':';':'DBTPRINICIPALINT':';':'WATPRINICIPALINT':';':'LSSPRINICIPALINT':';':'PayoutAC':';':'LoanContractNo':';':'Maturitydate':';':'UnuseAmountOverdraft':';':'Limit':';':'Category':';':'CategoryDescription ':';':'ProductLine':';':'ProductName':';':'COCODE':';':'TODAY':';'
    Y.HEADER := 'StartDate':';':'LoanCurrBalance':';':'AccruedInterest ':';':'OutstandingOverdueAmt':';':'SusDate':';':'TotalCommitmentAmt':';':'UnutilInterestAmt':';':'Revolving':';':'LoanCommitAmt':';':'LoanCommitStatus':';':'LimitEXPDate':';':'ReducingLimit':';':'LastWorkingDate':';'
    Y.HEADER := 'InsuranceNO':';':'InsuranceStartDate':';':'InsuranceExpDate':';':'LimitExces_Amt'
    RETURN
    END
