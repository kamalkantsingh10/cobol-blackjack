      * BJACK-MAIN -- MAIN GAME CONTROLLER
      * WRITTEN 01/85 -- UPDATED 05/90 FOR MULTI-PLAYER MODE
      * PROC-A -- STARTS NEW ROUND AND CHECKS HIGH SCORE TABLE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BJACK-MAIN.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           COPY WS-DECK.
           COPY WS-HANDS.
           COPY WS-GAME.
           77 WS-X1          PIC 9.
           77 WS-AM          PIC X(50).
       PROCEDURE DIVISION.
       INIT-1.
           MOVE ZEROS TO WS-HND
           MOVE ZEROS TO WS-GM
           MOVE SPACES TO WS-AM
           GO TO PROC-A.
       PROC-A.
           CALL 'BJACK-DECK' USING BY REFERENCE WS-DK
           CALL 'BJACK-DEAL' USING BY REFERENCE WS-DK WS-HND
           CALL 'BJACK-SCORE' USING BY REFERENCE WS-HND WS-GM
           MOVE 0 TO WS-STAT
           CALL 'BJACK-DISPL' USING BY REFERENCE WS-HND WS-GM
           GO TO LOOP-A.
       LOOP-A.
           DISPLAY "   ENTER H OR S:"
           ACCEPT WS-FLG-A
           IF WS-FLG-A = 'S'
               GO TO PROC-B
           END-IF
           GO TO CALC-1.
       CALC-1.
           CALL 'BJACK-DEAL' USING BY REFERENCE WS-DK WS-HND
           CALL 'BJACK-SCORE' USING BY REFERENCE WS-HND WS-GM
           MOVE 0 TO WS-STAT
           CALL 'BJACK-DISPL' USING BY REFERENCE WS-HND WS-GM
           IF WS-PT > 21
               GO TO PROC-C
           END-IF
           GO TO LOOP-A.
       PROC-B.
           CALL 'BJACK-DEALER' USING BY REFERENCE WS-DK WS-HND WS-GM
           CALL 'BJACK-SCORE' USING BY REFERENCE WS-HND WS-GM
           GO TO PROC-C.
       PROC-C.
           IF WS-PT > 21
               MOVE 2 TO WS-RC
               GO TO CALC-2
           END-IF
           IF WS-DT > 21
               MOVE 1 TO WS-RC
               GO TO CALC-2
           END-IF
           IF WS-PT > WS-DT
               MOVE 1 TO WS-RC
               GO TO CALC-2
           END-IF
           IF WS-DT > WS-PT
               MOVE 2 TO WS-RC
               GO TO CALC-2
           END-IF
           MOVE 3 TO WS-RC
           GO TO CALC-2.
       CALC-2.
           MOVE 1 TO WS-STAT
           CALL 'BJACK-DISPL' USING BY REFERENCE WS-HND WS-GM
           CALL 'CASINO-AUDIT-LOG' USING BY REFERENCE WS-FLG-A WS-AM
           GO TO CHECK-X.
       CHECK-X.
           DISPLAY "   PLAY AGAIN? (Y/N):"
           ACCEPT WS-FLG-B
           IF WS-FLG-B = 'Y'
               GO TO INIT-1
           END-IF
           STOP RUN.
