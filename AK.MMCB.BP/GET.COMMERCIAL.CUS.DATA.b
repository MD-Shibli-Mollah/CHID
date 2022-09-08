SUBROUTINE GET.COMMERCIAL.CUS.DATA(CUS.ID, CUS.REC)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_COMMERCIAL.DATA.EXTRACT.COMMON
    $USING EB.DataAccess
    $USING ST.Customer
    $USING ST.Config
    $USING EB.API
    $USING EB.SystemTables
    $USING EB.Foundation
    
    IF NOT(CUS.ID) THEN
        RETURN
    END
    
    GOSUB INIT
    
    Y.CUS.ID = CUS.ID
    
    EB.DataAccess.FRead(FN.CUS, Y.CUS.ID, REC.CUS, F.CUS, ERR.CUS)
    Y.LEGAL.ID = REC.CUS<ST.Customer.Customer.EbCusLegalId><1,1>
    Y.LEGAL.ISSUE.DT = REC.CUS<ST.Customer.Customer.EbCusLegalIssDate><1,1>
    Y.NAME1 = REC.CUS<ST.Customer.Customer.EbCusNameOne>
    Y.SHORT.NM = REC.CUS<ST.Customer.Customer.EbCusShortName>
    Y.ORG.STATUS = ''
    Y.ORG.STATUS.EFF.DT = ''
    Y.TARGET.ID = REC.CUS<ST.Customer.Customer.EbCusTarget>
    EB.DataAccess.FRead(FN.TARGET, Y.TARGET.ID, REC.TARGET, F.TARGET, ERR.TARGET)
    Y.TARGET = REC.TARGET<ST.Config.Target.EbTarShortName>
    Y.TOWN.COUNTRY = REC.CUS<ST.Customer.Customer.EbCusTownCountry><1,1>
    Y.STREET = REC.CUS<ST.Customer.Customer.EbCusStreet><1,1>
    Y.CITY = Y.TOWN.COUNTRY
    Y.POST.CODE = REC.CUS<ST.Customer.Customer.EbCusPostCode><1,1>
    Y.COUNTRY = REC.CUS<ST.Customer.Customer.EbCusCountry><1,1>
    Y.ADDRESS = REC.CUS<ST.Customer.Customer.EbCusAddress><1,1>
    Y.EMAIL.1 = REC.CUS<ST.Customer.Customer.EbCusEmailOne><1,1>
    Y.EMAIL.2 = REC.CUS<ST.Customer.Customer.EbCusEmailOne><1,2>
    Y.SMS = REC.CUS<ST.Customer.Customer.EbCusSmsOne><1,1>
    Y.PHONE.OFF = REC.CUS<ST.Customer.Customer.EbCusOffPhone><1,1>
    Y.PHONE = REC.CUS<ST.Customer.Customer.EbCusPhoneOne><1,1>
    delim = '~'
    CUS.REC = ''
    CUS.REC = Y.CUS.ID:delim:Y.LEGAL.ID:delim:Y.LEGAL.ISSUE.DT:delim:Y.NAME1:delim:Y.SHORT.NM:delim:Y.ORG.STATUS:delim:Y.ORG.STATUS.EFF.DT:delim:Y.TARGET:delim:Y.TOWN.COUNTRY:delim:Y.STREET:delim:Y.CITY:delim:Y.POST.CODE:delim:Y.COUNTRY:delim:Y.ADDRESS:delim:Y.EMAIL.1:delim:Y.EMAIL.2:delim:Y.SMS:delim:Y.PHONE.OFF:delim:Y.PHONE
RETURN
 
INIT:
    Y.CUS.ID = ''
    Y.LEGAL.ID = ''
    Y.LEGAL.ISSUE.DT = ''
    Y.NAME1 = ''
    Y.SHORT.NM = ''
    Y.ORG.STATUS = ''
    Y.ORG.STATUS.EFF.DT = ''
    Y.TARGET = ''
    Y.TOWN.COUNTRY = ''
    Y.STREET = ''
    Y.CITY = ''
    Y.POST.CODE = ''
    Y.COUNTRY = ''
    Y.ADDRESS = ''
    Y.EMAIL.1 = ''
    Y.EMAIL.2 = ''
    Y.SMS = ''
    Y.PHONE.OFF = ''
    Y.PHONE = ''
RETURN
END
