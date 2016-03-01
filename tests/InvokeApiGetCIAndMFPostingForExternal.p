/*------------------------------------------------------------------------
    File        : GetCIAndMfPostingForExternal.p
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

USING OpenEdge.Core.Assert.
{proxy/datasets/tcinvoicepostingciandmf.i }
{proxy/datasets/tfcmessages.i }

define input  parameter cinvoiceId       as int64   no-undo.
define input  parameter companyId        as int64   no-undo.
define input  parameter companyCode      as character   no-undo.
define output parameter returnStatus     as integer no-undo.
define output parameter table for tcinvoicepostingciandmf.
define output parameter table for tFcMessages.

{proxy/bcinvoice/apigetciandmfpostingforexternaldef.i}
assign igCInvoiceId  = cinvoiceId
       igCompanyId   = companyId
       icCompanyCode = companyCode.

{proxy/bcinvoice/apigetciandmfpostingforexternalrun.i}
assign returnStatus = oiReturnStatus.
/*
run ref/disp.p(input buffer tFcMessages:handle).
run ref/disp.p(input buffer tcinvoicepostingciandmf:handle).*/