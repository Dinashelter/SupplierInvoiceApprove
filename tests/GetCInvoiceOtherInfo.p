
/*------------------------------------------------------------------------
    File        : GetCInvoiceOtherInfo.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Tue Jan 05 11:02:40 CST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

{proxy/bcinvoice/apigetcinvoiceotherinfodef.i}

define input  parameter companyId as int64 no-undo.
define input  parameter companyCode as character no-undo.
define input  parameter cinvoicePostingYear as integer no-undo.
define input  parameter journalCode as character no-undo.
define input  parameter cinvoiceVoucher as integer no-undo.
define output parameter table for tCInvoiceOtherInfo.
define output parameter table for tCInvoiceBankNumber.

igCompanyId = companyId.
icCompanyCode = companyCode.
iiCInvoicePostingYear = cinvoicePostingYear.
icJournalCode = journalCode.
iiCInvoiceVoucher = cinvoiceVoucher.

{proxy/bcinvoice/apigetcinvoiceotherinforun.i}