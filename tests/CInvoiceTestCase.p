/*------------------------------------------------------------------------
    File        : CInvoiceTestCase.p 
    Syntax      : 
    Author(s)   : ftd
    Created     : Fri Mar 01 16:13:14 CST 2016
Total of several fields in a file, including fields not normally used in calculations, 
such as account number.
Recalculated and compared with the original at various stages in the processing        
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.Core.Assert.
BLOCK-LEVEL ON ERROR UNDO, THROW.

{proxy/datasets/tfcmessages.i }
{proxy/datasets/tcinvoicepostingciandmf.i }

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
/* Invoice not existing */
PROCEDURE TestApiGetCIAndMFPostingForExternal1:
    DEFINE VARIABLE cinvoiceId    AS INT64     NO-UNDO.
    DEFINE VARIABLE companyId     AS INT64     NO-UNDO.
    DEFINE VARIABLE companyCode   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE returnStatus AS INTEGER    NO-UNDO.
    
    EMPTY TEMP-TABLE tfcmessages.
    ASSIGN cinvoiceId = 12345.
    
    RUN invoke/InvokeApiGetCIAndMFPostingForExternal.p (INPUT cinvoiceId,
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
    
    RUN invoke/InvokeApiGetCIAndMFPostingForExternal.p (INPUT cinvoiceId,
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
    
    RUN invoke/InvokeApiGetCIAndMFPostingForExternal.p (INPUT cinvoiceId,
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
    
    RUN invoke/InvokeApiGetCIAndMFPostingForExternal.p (INPUT cinvoiceId,
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