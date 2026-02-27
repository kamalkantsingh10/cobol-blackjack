      * BJACK-DEAL -- CARD DISTRIBUTION MODULE
      * WRITTEN 04/84 -- UPDATED 08/88 FOR MULTI-DECK SUPPORT
      * HANDLES SPLIT HANDS PER CASINO RULES
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BJACK-DEAL.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           77 WS-X1          PIC 9.
       LINKAGE SECTION.
           COPY WS-DECK.
           COPY WS-HANDS.
       PROCEDURE DIVISION USING WS-DK WS-HND.
       INIT-1.
           MOVE 0 TO WS-X1
           GO TO PROC-A.
       PROC-A.
           IF WS-PC = 0
               GO TO CALC-1
           END-IF
           GO TO CALC-3.
       CALC-1.
           MOVE WS-S1(WS-CT1)  TO WS-PS1(1)
           MOVE WS-RK(WS-CT1)  TO WS-PRK(1)
           MOVE WS-FV(WS-CT1)  TO WS-PFV(1)
           ADD 1 TO WS-CT1
           GO TO CALC-2.
       CALC-2.
           MOVE WS-S1(WS-CT1)  TO WS-PS1(2)
           MOVE WS-RK(WS-CT1)  TO WS-PRK(2)
           MOVE WS-FV(WS-CT1)  TO WS-PFV(2)
           MOVE 2 TO WS-PC
           ADD 1 TO WS-CT1
           GO TO CALC-4.
       CALC-3.
           ADD 1 TO WS-PC
           MOVE WS-S1(WS-CT1)  TO WS-PS1(WS-PC)
           MOVE WS-RK(WS-CT1)  TO WS-PRK(WS-PC)
           MOVE WS-FV(WS-CT1)  TO WS-PFV(WS-PC)
           ADD 1 TO WS-CT1
           GO TO CHECK-X.
       CALC-4.
           MOVE WS-S1(WS-CT1)  TO WS-DS1(1)
           MOVE WS-RK(WS-CT1)  TO WS-DRK(1)
           MOVE WS-FV(WS-CT1)  TO WS-DFV(1)
           ADD 1 TO WS-CT1
           GO TO CALC-5.
       CALC-5.
           MOVE WS-S1(WS-CT1)  TO WS-DS1(2)
           MOVE WS-RK(WS-CT1)  TO WS-DRK(2)
           MOVE WS-FV(WS-CT1)  TO WS-DFV(2)
           MOVE 2 TO WS-DC
           ADD 1 TO WS-CT1
           GO TO CHECK-X.
       CHECK-X.
           GOBACK.
