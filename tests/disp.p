/*Test Data Preparation*/
/*DEFINE TEMP-TABLE tPaySel
   FIELD ElementType  AS CHARACTER FORMAT "X(20)"
   Field ElementID    as INTEGER FORMAT 9999999999
   FIELD ElementLogic AS LOGICAL
   FIELD ElementDESC  AS CHARACTER.

Create tPaySel.
assign ElementType = "t124"
elementID = 1
elementlogic = YES
elementdesc = "desc".

Create tPaySel.
assign ElementType = "t2"
elementID = 22
elementlogic = NO
elementdesc = "desc222".

DEFINE VARIABLE ih_temptable AS HANDLE NO-UNDO.
ih_temptable = BUFFER tPaySel:HANDLE.*/
define input parameter ih_temptable AS HANDLE no-undo.



define stream strout.
/*Call the procedure*/
RUN Factorial(INPUT ih_temptable). 

/* Procedure */
PROCEDURE Factorial:
    
    /* Variables */
    DEFINE VARIABLE tcFilePath AS CHARACTER NO-UNDO.
    
    DEFINE INPUT PARAMETER hBuffer AS HANDLE no-undo.
    
    DEFINE VARIABLE vhQuery AS HANDLE NO-UNDO.
    DEFINE VARIABLE vhQuery2 AS HANDLE NO-UNDO.
    DEFINE VARIABLE iField AS INTEGER NO-UNDO.
    DEFINE VARIABLE cField AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFieldName AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iFieldLengthArray AS INTEGER EXTENT 300 NO-UNDO.
    DEFINE VARIABLE cCutLine AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFieldData AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iIndex AS INTEGER NO-UNDO.
    DEFINE VARIABLE cSpace AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cOutputString AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFieldFormat AS CHARACTER.
    define variable iFields as integer.
    

    /* Log path */
    ASSIGN tcFilePath = "d:\DEVELOP\ft493\ft493_02\Debug_d6l.txt".
    output stream strout to value(tcFilePath) APPEND.
    /* Title */
    put stream strout UNFORMATTED "TimeStamp." TODAY "."  TIME "~r".
    ASSIGN cOutputString = "****** " + "" + hBuffer:NAME + " ******" + "~r".
    put stream strout UNFORMATTED cOutputString.
    ASSIGN cOutputString = "".


    /*Get field length*/
    create query vhQuery.
    vhQuery:set-buffers(hbuffer).
    vhQuery:query-prepare("for each " + hBuffer:NAME).
    vhQuery:query-open().
    vhQuery:get-first().
    DO WHILE NOT vhQuery:QUERY-OFF-END:
        DO iFields = 1 TO hBuffer:NUM-FIELDS:
            IF iFieldLengthArray[iFields] = 0 OR iFieldLengthArray[iFields] = ?
            THEN DO:
                ASSIGN iFieldLengthArray[iFields] = LENGTH(hBuffer:BUFFER-FIELD(iFields):NAME).
            END.

            IF index(hBuffer:BUFFER-FIELD(iFields):NAME, "CustomDate0") > 0 THEN
                MESSAGE length(hBuffer:BUFFER-FIELD(iFields):buffer-value).

            IF iFieldLengthArray[iFields] < LENGTH(STRING(hBuffer:BUFFER-FIELD(iFields):buffer-value))
            THEN ASSIGN iFieldLengthArray[iFields] = LENGTH(STRING(hBuffer:BUFFER-FIELD(iFields):buffer-value)).
        END.

        vhQuery:GET-NEXT().
    END.

    /* Output Field name*/
    DO iFields = 1 TO hBuffer:NUM-FIELDS:
        ASSIGN cField = hBuffer:BUFFER-FIELD(iFields):NAME.

        if cField begins "Custom" or cField begins "QAD" then
        next.
        
        DO iIndex = 1 TO (iFieldLengthArray[iFields] - LENGTH(cField)):
            ASSIGN cSpace = cSpace + " ".
        END.
        ASSIGN cFieldName = cFieldName + "  " + cSpace + cField + " |".

        ASSIGN cSpace = "".
    end.
    ASSIGN cFieldName = cFieldName + "~r".
    put stream strout unformatted cFieldName.
    
    /* Drawing cut line */
    DO iFields = 1 TO hBuffer:NUM-FIELDS:
      
        if  hBuffer:BUFFER-FIELD(iFields):NAME begins "Custom" or cField begins "QAD" then
        next.
      
        DO iIndex = 1 TO iFieldLengthArray[iFields]:
            ASSIGN cCutLine = cCutLine + "_".
        END.
        ASSIGN cOutputString = cOutputString + "  " + cCutLine + "  "
               cCutLine = "".
    END.
    ASSIGN cOutputString = cOutputString + "~r".
    put stream strout unformatted cOutputString.
    ASSIGN cOutputString = "".
    
    /*Fetch and output data*/
    create query vhQuery2.
    vhQuery2:set-buffers(hbuffer).
    vhQuery2:query-prepare("for each " + hBuffer:NAME).
    vhQuery2:query-open().
    vhQuery2:get-first().

    DO WHILE NOT vhQuery2:QUERY-OFF-END:
        DO iFields = 1 TO hBuffer:NUM-FIELDS:
          
                  if  hBuffer:BUFFER-FIELD(iFields):NAME begins "Custom" or cField begins "QAD" then
        next.
          
            IF hBuffer:BUFFER-FIELD(iFields):BUFFER-VALUE = ?
            THEN ASSIGN cFieldData = "".
            ELSE ASSIGN cFieldData = string(hBuffer:BUFFER-FIELD(iFields):buffer-value).

            DO iIndex = 1 TO (iFieldLengthArray[iFields] - LENGTH(cFieldData)):
                ASSIGN cSpace = cSpace + " ".
            END.

            ASSIGN cFieldData = "  " + cSpace + cFieldData + " |"
                   cSpace     = "".
            put stream strout unformatted cFieldData.
        END.
        ASSIGN cFieldData = "~r".
        put stream strout unformatted cFieldData.
        ASSIGN cFieldData = "".
        vhQuery2:GET-NEXT().
    END.
    
    /* Ending */
    ASSIGN cOutputString = "****** End ******" + "~r" + "~n".
    put stream strout unformatted cOutputString.
    
    output close.

END PROCEDURE.
