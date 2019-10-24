       IDENTIFICATION DIVISION.
       PROGRAM-ID. TAPTODSK.
       AUTHOR. BILL BLASINGIM.
       REMARKS.
           Simple MVS COBOL program
           A simple tape to disk copy.

           Input tape file came from Linux and each record 
           although a fixed length still had a line feed at the end. 
           So this program outputs everything not including the end
           byte. The IBM utility IEBGENER can do this...
           but I didn't know it at the time.

           FYI: The input tape file is a virtual tape, but as far as 
           this program is concerned it's a real tape.

       DATE-WRITTEN. Oct. 13, 2019
       DATE-COMPILED.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IN-FILE ASSIGN TO UT-S-INTAPE.
           SELECT OUT-FILE ASSIGN TO DA-S-OUTDISK.

       DATA DIVISION.
       FILE SECTION.
       FD  IN-FILE
           BLOCK CONTAINS 100 RECORDS
           LABEL RECORDS STANDARD.
       01  IN-RECORD.
           05 IN-REC                        PIC X(163).
           05 FILLER                        PIC X(01).
       FD  OUT-FILE
           BLOCK CONTAINS 100 RECORDS
           LABEL RECORDS STANDARD.
       01  OUT-RECORD                       PIC X(163).

       WORKING-STORAGE SECTION.
       01  WORK-AREA.
           05  PAGE-CNT                     PIC S9(3) VALUE +0 COMP-3.
           05  LINE-CNT                     PIC S9(3) VALUE +0 COMP-3.
           05  REC-CNT                      PIC S9(7) VALUE +0 COMP-3.
           05  EOF-FLAG                     PIC X(01) VALUE 'N'.
               88  EOF                                VALUE 'Y'.

       PROCEDURE DIVISION.

      *    A COMMENT.

           OPEN INPUT IN-FILE.
           OPEN OUTPUT OUT-FILE.           

           PERFORM READ-RTN THRU READ-EXIT.
           PERFORM PROCESS-RTN THRU PROCESS-EXIT
               UNTIL EOF.

           CLOSE IN-FILE, OUT-FILE.

           STOP RUN.               

       READ-RTN.
      *    DISPLAY 'READ-RTN.'.
           READ IN-FILE AT END
               MOVE 'Y' TO EOF-FLAG
               GO TO READ-EXIT.
           ADD +1 TO REC-CNT.
       READ-EXIT.
           EXIT.

       PROCESS-RTN.
           MOVE IN-REC TO OUT-RECORD.
           WRITE OUT-RECORD.
           PERFORM READ-RTN THRU READ-EXIT.           
       PROCESS-EXIT.
           EXIT.
