
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

{proxy/bcinvoice/apigetapprovalworkflowisenableddef.i}

define input  parameter companyId as int64 no-undo.
define input  parameter companyCode as character no-undo.
define output parameter isApproveWorkFlowEnabled as logical no-undo.

igCompanyId = companyId.
icCompanyCode = companyCode.

{proxy/bcinvoice/apigetapprovalworkflowisenabledrun.i}
isApproveWorkFlowEnabled = olIsApproveWorkFlowEnabled.