 
 /*------------------------------------------------------------------------
    File        : SupplierInvoiceApproveTestCase.p 
    Syntax      : 
    Author(s)   : d6l
    Created     : Fri Dec 25 16:13:14 CST 2015
    Notes       : Hash Total=Payment Amt + Supplier Bank No.+ No. of suppliers 
                             + No. of invoices in total
Total of several fields in a file, including fields not normally used in calculations, 
such as account number.
Recalculated and compared with the original at various stages in the processing        
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Lang.*.
USING OpenEdge.Core.Assert.
BLOCK-LEVEL ON ERROR UNDO, THROW.

{proxy/bcinvoice/apigetcinvoicesummaryinfodef.i}
{proxy/bcinvoice/apigetcinvoiceotherinfodef.i}
{proxy/bcinvoice/apigetciandmfpostingforexternaldef.i}

@Before.
PROCEDURE setUpBeforeProcedure:
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/

END PROCEDURE. 

@Setup.
PROCEDURE setUp:
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/

END PROCEDURE.  

@TearDown.
PROCEDURE tearDown:
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/

END PROCEDURE. 

@After.
PROCEDURE tearDownAfterProcedure: 
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/

END PROCEDURE. 

@Test.
PROCEDURE TestGetCInvoiceSummaryInfoForAll:
    empty temp-table tCInvoicePONbr.
    empty temp-table tCInvoiceSummaryInfo.
    run GetCInvoiceSummaryInfo.p(input "",
                                 input "",
                                 input "",
                                 input "",
                                 input "", 
                                 output table tCInvoicePONbr,
                                 output table tCInvoiceSummaryInfo).

    /*run disp.p(input buffer tCInvoicePONbr:handle).
    run disp.p(input buffer tCInvoiceSummaryInfo:handle). */        
    
END PROCEDURE.

@Test.
PROCEDURE TestGetCInvoiceSummaryInfoForSingleInvoice:
    empty temp-table tCInvoicePONbr.
    empty temp-table tCInvoiceSummaryInfo.
    run GetCInvoiceSummaryInfo.p(input 219435,
                                 input "10usaco",
                                 input 2016,
                                 input "SINV",
                                 input 441, 
                                 output table tCInvoicePONbr,
                                 output table tCInvoiceSummaryInfo).
      
    find first tCInvoiceSummaryInfo no-error.
    if available tCInvoiceSummaryInfo
    then do:
        Assert:Equals("Taylor & Fulton Fruit Co.", tCInvoiceSummaryInfo.tcBusinessRelationName1).
        Assert:Equals("ALLOCATION", tCInvoiceSummaryInfo.tcCInvoiceAllocationStatus).
        Assert:Equals("q123 10s1001", tCInvoiceSummaryInfo.tcCInvoiceDescription).
        Assert:Equals("q123", tCInvoiceSummaryInfo.tcCInvoiceReference).
        Assert:Equals("INVOICE", tCInvoiceSummaryInfo.tcCInvoiceType).
        Assert:Equals("", tCInvoiceSummaryInfo.tcCostCentreCode).
        Assert:Equals("10S1001", tCInvoiceSummaryInfo.tcCreditorCode).
        Assert:Equals("USD", tCInvoiceSummaryInfo.tcCurrencyCode).
        Assert:Equals("Gserv", tCInvoiceSummaryInfo.tcDivisionCode).
        Assert:Equals("SINV", tCInvoiceSummaryInfo.tcJournalCode).
        Assert:Equals("123", tCInvoiceSummaryInfo.tcReasonCode).
        Assert:Equals(2016, tCInvoiceSummaryInfo.tiCInvoicePostingYear).
        Assert:Equals(441, tCInvoiceSummaryInfo.tiCInvoiceVoucher).
        Assert:Equals("02/23/16", string(tCInvoiceSummaryInfo.ttCInvoiceDate)).
        Assert:Equals("03/24/16", string(tCInvoiceSummaryInfo.ttCInvoiceDueDate)).
        Assert:Equals("02/23/16", string(tCInvoiceSummaryInfo.ttCInvoicePostingDate)).
        Assert:Equals(1700, tCInvoiceSummaryInfo.tdCInvoiceAmountTC).
        Assert:Equals("CRED", tCInvoiceSummaryInfo.tcCInvoiceAmountCrDt).
        Assert:Equals(118.6, tCInvoiceSummaryInfo.tdCInvoiceVatAmountTC).
        Assert:Equals("DEB", tCInvoiceSummaryInfo.tcCInvoiceVatAmountCrDt).
    end.
    
    define variable poCnt as integer no-undo.
    poCnt = 0.
    for each tCInvoicePONbr:
        poCnt = poCnt + 1.
        if poCnt = 1 then
            Assert:Equals("PO10", tCInvoicePONbr.tcCInvoicePOPoNbr).
        if poCnt = 2 then 
            Assert:Equals("PO11", tCInvoicePONbr.tcCInvoicePOPoNbr).
    end.
    
END PROCEDURE.

@Test.
PROCEDURE TestGetCInvoiceSummaryInfoCrossCompany:
    empty temp-table tCInvoicePONbr.
    empty temp-table tCInvoiceSummaryInfo.
    run GetCInvoiceSummaryInfo.p(input "",
                                 input "11CANCO",
                                 input 2014,
                                 input "SINV",
                                 input 0, 
                                 output table tCInvoicePONbr,
                                 output table tCInvoiceSummaryInfo).
      
    find first tCInvoiceSummaryInfo no-error.
    if available tCInvoiceSummaryInfo
    then do:
        Assert:Equals("Chiro Foods Limited", tCInvoiceSummaryInfo.tcBusinessRelationName1).
        Assert:Equals("NOALLOCATION", tCInvoiceSummaryInfo.tcCInvoiceAllocationStatus).
        Assert:Equals("PO031407-11S1000", tCInvoiceSummaryInfo.tcCInvoiceDescription).
        Assert:Equals("PO031407", tCInvoiceSummaryInfo.tcCInvoiceReference).
        Assert:Equals("INVOICE", tCInvoiceSummaryInfo.tcCInvoiceType).
        Assert:Equals("", tCInvoiceSummaryInfo.tcCostCentreCode).
        Assert:Equals("11S1000", tCInvoiceSummaryInfo.tcCreditorCode).
        Assert:Equals("CAD", tCInvoiceSummaryInfo.tcCurrencyCode).
        Assert:Equals("Gserv", tCInvoiceSummaryInfo.tcDivisionCode).
        Assert:Equals("SINV", tCInvoiceSummaryInfo.tcJournalCode).
        Assert:Equals("RM-INIT", tCInvoiceSummaryInfo.tcReasonCode).
        Assert:Equals(2014, tCInvoiceSummaryInfo.tiCInvoicePostingYear).
        Assert:Equals(0, tCInvoiceSummaryInfo.tiCInvoiceVoucher).
        Assert:Equals("03/05/14", string(tCInvoiceSummaryInfo.ttCInvoiceDate)).
        Assert:Equals("06/30/14", string(tCInvoiceSummaryInfo.ttCInvoiceDueDate)).
        Assert:Equals("03/05/14", string(tCInvoiceSummaryInfo.ttCInvoicePostingDate)).
        Assert:Equals(.15, tCInvoiceSummaryInfo.tdCInvoiceAmountTC).
        Assert:Equals("CRED", tCInvoiceSummaryInfo.tcCInvoiceAmountCrDt).
        Assert:Equals(0, tCInvoiceSummaryInfo.tdCInvoiceVatAmountTC).
        Assert:Equals("", tCInvoiceSummaryInfo.tcCInvoiceVatAmountCrDt).
    end.
    
    define variable poCnt as integer no-undo.
    poCnt = 0.
    for each tCInvoicePONbr:
        poCnt = poCnt + 1.
        if poCnt = 1 then
            Assert:Equals("", tCInvoicePONbr.tcCInvoicePOPoNbr).
        if poCnt = 2 then 
            Assert:Equals("PO031407", tCInvoicePONbr.tcCInvoicePOPoNbr).
    end.
    
END PROCEDURE.

@Test.
PROCEDURE TestGetCInvoiceSummaryInfoGetApprovedInvoice:
    /* Approved Invoice Should not be found */
    empty temp-table tCInvoicePONbr.
    empty temp-table tCInvoiceSummaryInfo.
    run GetCInvoiceSummaryInfo.p(input 219435,
                                 input "10usaco",
                                 input 2016,
                                 input "SINV",
                                 input 436, 
                                 output table tCInvoicePONbr,
                                 output table tCInvoiceSummaryInfo).  
    find first tCInvoicePONbr no-error.
    if not available tCInvoicePONbr then
        Assert:Equals("true", "true").
    else
        Assert:Equals("false", "true").  
        
    find first tCInvoiceSummaryInfo no-error.
    if not available tCInvoiceSummaryInfo then
        Assert:Equals("true", "true").
    else
        Assert:Equals("false", "true").     
    
END PROCEDURE.

@Test.
PROCEDURE TestGetCInvoiceOtherInfoForAll:
    empty temp-table tCInvoiceOtherInfo.
    empty temp-table tCInvoiceBankNumber.
    run GetCInvoiceOtherInfo.p(input "",
                               input "",
                               input "",
                               input "",
                               input "", 
                               output table tCInvoiceOtherInfo,
                               output table tCInvoiceBankNumber).

    /*run disp.p(input buffer tCInvoiceOtherInfo:handle).
    run disp.p(input buffer tCInvoiceBankNumber:handle). */          
    
END PROCEDURE.

@Test.
PROCEDURE TestGetCInvoiceOtherInfoForSingleInvoice:
    empty temp-table tCInvoiceOtherInfo.
    empty temp-table tCInvoiceBankNumber.
    run GetCInvoiceOtherInfo.p(input 219435,
                               input "10usaco",
                               input 2016,
                               input "SINV",
                               input 441, 
                               output table tCInvoiceOtherInfo,
                               output table tCInvoiceBankNumber).                                   
      
    find first tCInvoiceOtherInfo no-error.
    if available tCInvoiceOtherInfo
    then do:
        Assert:Equals("30D", tCInvoiceOtherInfo.tcPaymentConditionCode).
        Assert:Equals("02/23/16", string(tCInvoiceOtherInfo.ttCInvoiceDiscountDueDate)).
        Assert:Equals(118.6, tCInvoiceOtherInfo.tdCInvoiceVatAmountTC).
        Assert:Equals("DEB", tCInvoiceOtherInfo.tcCInvoiceVatAmountCrDt).
        Assert:Equals(1581.4, tCInvoiceOtherInfo.tdCInvoiceVatBaseAmountTC).
        Assert:Equals("DEB", tCInvoiceOtherInfo.tcCInvoiceVatBaseAmountCrDt).
        Assert:Equals(0, tCInvoiceOtherInfo.tdCInvoiceWHTBaseAmtTC).
        Assert:Equals("", tCInvoiceOtherInfo.tcCInvoiceWHTBaseAmtCrDt).
        Assert:Equals(0, tCInvoiceOtherInfo.tdCInvoiceWHTTotAmtTC).
        Assert:Equals("", tCInvoiceOtherInfo.tcCInvoiceWHTTotAmtCrDt).
        Assert:Equals("", tCInvoiceOtherInfo.tcCInvoiceCommentNote).
    end.
    
    find first tCInvoiceBankNumber no-error.
    if available tCInvoiceBankNumber
    then do:
        Assert:Equals("AU556509", tCInvoiceBankNumber.tcCInvoiceBankNumber).
        Assert:Equals("55667342", string(tCInvoiceBankNumber.tcCInvoiceOwnBankNumber)).
    end.
    
END PROCEDURE.

@Test.
PROCEDURE TestGetCInvoiceOtherInfoCrossCompany:
    empty temp-table tCInvoiceOtherInfo.
    empty temp-table tCInvoiceBankNumber.
    run GetCInvoiceOtherInfo.p(input "",
                               input "11canco",
                               input 2014,
                               input "SINV",
                               input 0, 
                               output table tCInvoiceOtherInfo,
                               output table tCInvoiceBankNumber).                                                              
      
    find first tCInvoiceOtherInfo no-error.
    if available tCInvoiceOtherInfo
    then do:
        Assert:Equals("90D", tCInvoiceOtherInfo.tcPaymentConditionCode).
        Assert:Equals("03/05/14", string(tCInvoiceOtherInfo.ttCInvoiceDiscountDueDate)).
        Assert:Equals(0, tCInvoiceOtherInfo.tdCInvoiceVatAmountTC).
        Assert:Equals("", tCInvoiceOtherInfo.tcCInvoiceVatAmountCrDt).
        Assert:Equals(0, tCInvoiceOtherInfo.tdCInvoiceVatBaseAmountTC).
        Assert:Equals("", tCInvoiceOtherInfo.tcCInvoiceVatBaseAmountCrDt).
        Assert:Equals(0, tCInvoiceOtherInfo.tdCInvoiceWHTBaseAmtTC).
        Assert:Equals("", tCInvoiceOtherInfo.tcCInvoiceWHTBaseAmtCrDt).
        Assert:Equals(0, tCInvoiceOtherInfo.tdCInvoiceWHTTotAmtTC).
        Assert:Equals("", tCInvoiceOtherInfo.tcCInvoiceWHTTotAmtCrDt).
    end.
    
    find first tCInvoiceBankNumber no-error.
    if available tCInvoiceBankNumber
    then do:
        Assert:Equals("CA54645", tCInvoiceBankNumber.tcCInvoiceBankNumber).
        Assert:Equals("CA56777657", string(tCInvoiceBankNumber.tcCInvoiceOwnBankNumber)).
    end.
    
END PROCEDURE.

@Test.
PROCEDURE TestGetCInvoiceOtherInfoGetApprovedInvoice:
    /* Approved Invoice Should not be found */
    empty temp-table tCInvoiceOtherInfo.
    empty temp-table tCInvoiceBankNumber.
    run GetCInvoiceOtherInfo.p(input 219435,
                               input "10usaco",
                               input 2016,
                               input "SINV",
                               input 436, 
                               output table tCInvoiceOtherInfo,
                               output table tCInvoiceBankNumber).  
    find first tCInvoiceOtherInfo no-error.
    if not available tCInvoiceOtherInfo then
        Assert:Equals("true", "true").
    else
        Assert:Equals("false", "true").  
        
    find first tCInvoiceBankNumber no-error.
    if not available tCInvoiceBankNumber then
        Assert:Equals("true", "true").
    else
        Assert:Equals("false", "true").     
    
END PROCEDURE.

@Test.
PROCEDURE TestApprovalWorkFlowIsEnabledByCompanyId:
    define variable isApproveWorkFlowEnabled as logical no-undo.
    run GetApprovalWorkFlowIsEnabled.p(input 219435,
                                       input "",
                                       output isApproveWorkFlowEnabled).
    Assert:Equals("yes", string(isApproveWorkFlowEnabled)).
    
END PROCEDURE.

@Test.
PROCEDURE TestApprovalWorkFlowIsEnabledByCompanyCode:
    define variable isApproveWorkFlowEnabled as logical no-undo.
    run GetApprovalWorkFlowIsEnabled.p(input 0,
                                       input "80tstco",
                                       output isApproveWorkFlowEnabled).
    Assert:Equals("no", string(isApproveWorkFlowEnabled)).
    
END PROCEDURE.

@Test.
PROCEDURE TestApprovalWorkFlowIsEnabledWithOutInput:
    /* When input parameters are without company info, then return the current entity work flow */
    define variable isApproveWorkFlowEnabled as logical no-undo. 
    run GetApprovalWorkFlowIsEnabled.p(input 0,
                                       input "",
                                       output isApproveWorkFlowEnabled).
    Assert:Equals("yes", string(isApproveWorkFlowEnabled)).
    
END PROCEDURE.

@Test.
/* Invoice not existing */
PROCEDURE TestApiGetCIAndMFPostingForExternal1:
    DEFINE VARIABLE cinvoiceId    AS INT64     NO-UNDO.
    DEFINE VARIABLE companyId     AS INT64     NO-UNDO.
    DEFINE VARIABLE companyCode   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE returnStatus AS INTEGER    NO-UNDO.
    
    EMPTY TEMP-TABLE tfcmessages.
    ASSIGN cinvoiceId = 12345.
    
    RUN InvokeApiGetCIAndMFPostingForExternal.p (INPUT cinvoiceId,
                                                 INPUT companyId,
                                                 INPUT companyCode,
                                                 OUTPUT returnStatus,
                                                 OUTPUT table tcinvoicepostingciandmf,
                                                 OUTPUT table tfcmessages).
    Assert:Equals(-1, returnStatus).
    find first tfcmessages no-error.
    if available tfcmessages
    then Assert:Equals("Supplier Invoice (ID 12345) not found.", tfcmessages.tcFcMessage).   
END PROCEDURE.

@Test.
/* Invoice id cannot be blank */
PROCEDURE TestApiGetCIAndMFPostingForExternal2:
    DEFINE VARIABLE cinvoiceId    AS INT64     NO-UNDO.
    DEFINE VARIABLE companyId     AS INT64     NO-UNDO.
    DEFINE VARIABLE companyCode   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE returnStatus AS INTEGER    NO-UNDO.
    
    EMPTY TEMP-TABLE tfcmessages.
    ASSIGN cinvoiceId = ?.
    
    RUN InvokeApiGetCIAndMFPostingForExternal.p (INPUT cinvoiceId,
                                                 INPUT companyId,
                                                 INPUT companyCode,
                                                 OUTPUT returnStatus,
                                                 OUTPUT table tcinvoicepostingciandmf,
                                                 OUTPUT table tfcmessages).
    Assert:Equals(-1, returnStatus).
    find first tfcmessages no-error.
    if available tfcmessages
    then Assert:Equals("You must enter the supplier invoice identification.", tfcmessages.tcFcMessage).   
END PROCEDURE.

@Test.
/* Company code is not valid. */
PROCEDURE TestApiGetCIAndMFPostingForExternal3:
    DEFINE VARIABLE cinvoiceId    AS INT64     NO-UNDO.
    DEFINE VARIABLE companyId     AS INT64     NO-UNDO.
    DEFINE VARIABLE companyCode   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE returnStatus AS INTEGER    NO-UNDO.
    
    EMPTY TEMP-TABLE tfcmessages.
    ASSIGN cinvoiceId = 942078
           companyId  = ?
           companyCode = '10USAXX'.
    
    RUN InvokeApiGetCIAndMFPostingForExternal.p (INPUT cinvoiceId,
                                                 INPUT companyId,
                                                 INPUT companyCode,
                                                 OUTPUT returnStatus,
                                                 OUTPUT table tcinvoicepostingciandmf,
                                                 OUTPUT table tfcmessages).
    Assert:Equals(-1, returnStatus).
    find first tfcmessages no-error.
    if available tfcmessages
    then Assert:Equals("Company Code is not valid.", tfcmessages.tcFcMessage).   
END PROCEDURE.

@Test.
/* Supplier Invoice not found. */
PROCEDURE TestApiGetCIAndMFPostingForExternal4:
    DEFINE VARIABLE cinvoiceId    AS INT64     NO-UNDO.
    DEFINE VARIABLE companyId     AS INT64     NO-UNDO.
    DEFINE VARIABLE companyCode   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE returnStatus AS INTEGER    NO-UNDO.
    
    EMPTY TEMP-TABLE tfcmessages.
    ASSIGN cinvoiceId = 942078
           companyId  = 219463
           companyCode = '11CANCO'.
    
    RUN InvokeApiGetCIAndMFPostingForExternal.p (INPUT cinvoiceId,
                                                 INPUT companyId,
                                                 INPUT companyCode,
                                                 OUTPUT returnStatus,
                                                 OUTPUT table tcinvoicepostingciandmf,
                                                 OUTPUT table tfcmessages).
    Assert:Equals(-1, returnStatus).
    find first tfcmessages no-error.
    if available tfcmessages
    then Assert:Equals("Supplier Invoice (ID 942078) not found.", tfcmessages.tcFcMessage).   
END PROCEDURE.

@Test.
/* Correct case */
PROCEDURE TestApiGetCIAndMFPostingForExternal5:
    DEFINE VARIABLE cinvoiceId    AS INT64     NO-UNDO.
    DEFINE VARIABLE companyId     AS INT64     NO-UNDO.
    DEFINE VARIABLE companyCode   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE returnStatus AS INTEGER    NO-UNDO.
    DEFINE VARIABLE rowCount AS INTEGER NO-UNDO.
    
    EMPTY TEMP-TABLE tfcmessages.
    ASSIGN cinvoiceId  = 942078
           companyId   = 219435
           companyCode = '10USACO'
           rowCount    = 0.
    
    RUN InvokeApiGetCIAndMFPostingForExternal.p (INPUT cinvoiceId,
                                                 INPUT companyId,
                                                 INPUT companyCode,
                                                 OUTPUT returnStatus,
                                                 OUTPUT table tcinvoicepostingciandmf,
                                                 OUTPUT table tfcmessages).
    Assert:Equals(0, returnStatus).
    FOR EACH tcinvoicepostingciandmf:
        ASSIGN rowCount = rowCount + 1.
        
        if rowCount = 1
        then do:
            Assert:Equals("SINV", tcinvoicepostingciandmf.tcJournalCode).
            Assert:Equals("INIT", tcinvoicepostingciandmf.tcPostingType).
        end.
        else if rowCount = 2
        then do:
            Assert:Equals("SINV", tcinvoicepostingciandmf.tcJournalCode).
            Assert:Equals("INIT", tcinvoicepostingciandmf.tcPostingType).
        end.
        else if rowCount = 3
        then do:
            Assert:Equals("SIREC", tcinvoicepostingciandmf.tcJournalCode).
            Assert:Equals("ALLOC", tcinvoicepostingciandmf.tcPostingType).
        end.
        else if rowCount = 4
        then do:
            Assert:Equals("SIREC", tcinvoicepostingciandmf.tcJournalCode).
            Assert:Equals("ALLOC", tcinvoicepostingciandmf.tcPostingType).
        end.
    END.
    Assert:Equals(4, rowCount).
END PROCEDURE.


@Test.
/* No postings */
PROCEDURE TestApiGetCIAndMFPostingForExternal6:
    DEFINE VARIABLE cinvoiceId    AS INT64     NO-UNDO.
    DEFINE VARIABLE companyId     AS INT64     NO-UNDO.
    DEFINE VARIABLE companyCode   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE returnStatus AS INTEGER    NO-UNDO.
    DEFINE VARIABLE rowCount AS INTEGER NO-UNDO.
    
    EMPTY TEMP-TABLE tfcmessages.
    ASSIGN cinvoiceId  = 1127628025
           companyId   = 219463
           companyCode = '10USACO'
           rowCount    = 0.
    
    RUN InvokeApiGetCIAndMFPostingForExternal.p (INPUT cinvoiceId,
                                                 INPUT companyId,
                                                 INPUT companyCode,
                                                 OUTPUT returnStatus,
                                                 OUTPUT table tcinvoicepostingciandmf,
                                                 OUTPUT table tfcmessages).
    Assert:Equals(0, returnStatus).
    FOR EACH tcinvoicepostingciandmf:
        ASSIGN rowCount = rowCount + 1.
    END.
    Assert:Equals(0, rowCount).
    
    find first tfcmessages no-error.
    if available tfcmessages
    then do:
        Assert:Equals("No postings are available for the Supplier Invoice (ID:1127628025).", tfcmessages.tcFcMessage).
        Assert:Equals("W", tfcmessages.tcFcType).
    end.
END PROCEDURE.