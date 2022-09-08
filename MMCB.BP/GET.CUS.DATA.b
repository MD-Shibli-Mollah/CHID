* @ValidationCode : MjotMTE3MDA0ODMwMzpDcDEyNTI6MTYyOTcxNDk1NTAwNTpBS0hUQVI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxOTEwLjE6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 Aug 2021 16:35:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : AKHTAR
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201910.1
SUBROUTINE GET.CUS.DATA (CUS.ID, CUS.REC)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_CONSUMER.DATA.EXTRACT.COMMON
    $USING EB.DataAccess
    $USING ST.Customer
    $USING ST.Config
    $USING EB.API
    $USING EB.SystemTables
    $USING EB.Foundation
    $USING EB.Updates
  
    IF NOT(CUS.ID) THEN
        RETURN
    END
     
    GOSUB INIT
    
    FLD.POS = ''
    APPLICATION.NAME = 'CUSTOMER'
    LOCAL.FIELDS = 'L.FATHER.NAME':@VM:'L.RACE'
    EB.Foundation.MapLocalFields(APPLICATION.NAME, LOCAL.FIELDS, FLD.POS)
    Y.LT.FATHER.NAME.POS = FLD.POS<1,1>
    Y.LT.RACE.POS = FLD.POS<1,2>

*-----------------------------------------------------------------------------
* Modification History : MD. FARID HOSSAIN
*-----------------------------------------------------------------------------

    Y.CUS.ID = CUS.ID
    EB.DataAccess.FRead(FN.CUS, Y.CUS.ID, REC.CUS, F.CUS, ERR.CUS)
        
    Y.LEGAL.ID = REC.CUS<ST.Customer.Customer.EbCusLegalId><1,1>
    Y.LEGAL.EXP.DT = REC.CUS<ST.Customer.Customer.EbCusLegalExpDate><1,1>
    Y.BIRTH.DT = REC.CUS<ST.Customer.Customer.EbCusDateOfBirth>
    Y.NAME1 = REC.CUS<ST.Customer.Customer.EbCusNameOne>
    Y.NAME2 = REC.CUS<ST.Customer.Customer.EbCusNameTwo>
    Y.SHORT.NM = REC.CUS<ST.Customer.Customer.EbCusShortName>
    Y.L.FATHER.NAME = REC.CUS<ST.Customer.Customer.EbCusLocalRef,Y.LT.FATHER.NAME.POS>
    Y.GENDER = REC.CUS<ST.Customer.Customer.EbCusGender>
    Y.MARITAL.STATUS = REC.CUS<ST.Customer.Customer.EbCusMaritalStatus>
    Y.NATIONALITY = REC.CUS<ST.Customer.Customer.EbCusNationality>
    Y.L.RACE = REC.CUS<ST.Customer.Customer.EbCusLocalRef,Y.LT.RACE.POS>
    Y.STREET = REC.CUS<ST.Customer.Customer.EbCusStreet><1,1>
    Y.TOWN.COUNTRY = REC.CUS<ST.Customer.Customer.EbCusTownCountry><1,1>
    Y.POST.CODE = REC.CUS<ST.Customer.Customer.EbCusPostCode><1,1>
    Y.COUNTRY = REC.CUS<ST.Customer.Customer.EbCusCountry><1,1>
    Y.ADDRESS = REC.CUS<ST.Customer.Customer.EbCusAddress><1,1>
    Y.EMAIL = REC.CUS<ST.Customer.Customer.EbCusEmailOne><1,1>

* As per bank request over skype we kept contact number type as blank
    Y.CONTACT.NO.TYPE = ''
* Contact Number Type 1
    Y.SMS = REC.CUS<ST.Customer.Customer.EbCusSmsOne><1,1>
* Contact Number - Unformatted 1
    Y.PHONE = REC.CUS<ST.Customer.Customer.EbCusPhoneOne><1,1>
* Contact Number Type 2
    Y.PHONE.OFF = REC.CUS<ST.Customer.Customer.EbCusOffPhone><1,1>
    
    Y.INDUSTRY.ID = REC.CUS<ST.Customer.Customer.EbCusIndustry>
    EB.DataAccess.FRead(FN.INDUSTRY, Y.INDUSTRY.ID, REC.INDUSTRY, F.INDUSTRY, ERR.INDUSTRY)
    Y.INDUSTRY = REC.INDUSTRY<ST.Config.Industry.EbIndDescription>
    
    Y.TARGET.ID = REC.CUS<ST.Customer.Customer.EbCusTarget>
    EB.DataAccess.FRead(FN.TARGET, Y.TARGET.ID, REC.TARGET, F.TARGET, ERR.TARGET)
    Y.TARGET = REC.TARGET<ST.Config.Target.EbTarShortName>
    
* RESIDENCE field value will be the Employer-Country field value also according to Bank
    Y.EMP.COUNTRY=REC.CUS<ST.Customer.Customer.EbCusResidence>
     
    Y.EMP.ADDRESS = REC.CUS<ST.Customer.Customer.EbCusEmployersAdd><1,1>
    Y.OCCUPATION = REC.CUS<ST.Customer.Customer.EbCusOccupation><1,1>
    Y.CUS.CURRENCY = REC.CUS<ST.Customer.Customer.EbCusCustomerCurrency><1,1>
    Y.NET.MONTHLY.IN = REC.CUS<ST.Customer.Customer.EbCusNetMonthlyIn>
    delim = '~'
    CUS.REC = ''
    CUS.REC = Y.CUS.ID:delim:Y.LEGAL.ID:delim:Y.LEGAL.EXP.DT:delim:Y.BIRTH.DT:delim:Y.NAME1:delim:Y.NAME2:delim:Y.SHORT.NM:delim:Y.L.FATHER.NAME:delim:Y.GENDER:delim:Y.MARITAL.STATUS:delim:Y.NATIONALITY:delim:Y.L.RACE:delim:Y.STREET:delim:Y.TOWN.COUNTRY:delim:Y.POST.CODE:delim:Y.COUNTRY:delim:Y.ADDRESS:delim:Y.EMAIL:delim:Y.CONTACT.NO.TYPE:delim:Y.SMS:delim:Y.PHONE:delim:Y.PHONE.OFF:delim:Y.INDUSTRY:delim:Y.TARGET:delim:Y.EMP.COUNTRY:delim:Y.EMP.ADDRESS:delim:Y.OCCUPATION:delim:Y.CUS.CURRENCY:delim:Y.NET.MONTHLY.IN

*-----------------------------------------------------------------------------
RETURN

INIT:
    Y.CUS.ID = ''
    Y.LEGAL.ID = ''
    Y.LEGAL.EXP.DT = ''
    Y.BIRTH.DT = ''
    Y.NAME1 = ''
    Y.NAME2 = ''
    Y.SHORT.NM = ''
    Y.L.FATHER.NAME = ''
    Y.GENDER = ''
    Y.MARITAL.STATUS = ''
    Y.NATIONALITY = ''
    Y.L.RACE = ''
    Y.STREET = ''
    Y.TOWN.COUNTRY = ''
    Y.POST.CODE = ''
    Y.COUNTRY = ''
    Y.ADDRESS = ''
    Y.EMAIL = ''
    Y.CONTACT.NO.TYPE = ''
    Y.SMS = ''
    Y.PHONE = ''
    Y.PHONE.OFF = ''
    Y.INDUSTRY = ''
    Y.TARGET = ''
    Y.EMP.COUNTRY = ''
    Y.EMP.ADDRESS = ''
    Y.OCCUPATION = ''
    Y.CUS.CURRENCY = ''
    Y.NET.MONTHLY.IN = ''
RETURN
END

