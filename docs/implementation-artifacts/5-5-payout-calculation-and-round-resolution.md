# Story 5.5: Payout Calculation and Round Resolution

Status: ready-for-dev

## Story

As a demo presenter (Kamal),
I want payout calculated after each round with win/loss/push logic updating the chip balance,
so that the complete betting cycle (bet → play → payout → updated balance) is visible and the business rules are demonstrably tangled in game flow.

## Acceptance Criteria

1. **Given** a round has concluded with an outcome (player win, dealer win, or push),
   **When** the payout is calculated,
   **Then** win pays 1:1 (bet amount added to WS-BAL).

2. **And** natural blackjack pays 3:2 (handled in Story 5.3 — no change needed here).

3. **And** push returns the bet to WS-BAL (no gain, no loss — WS-BAL unchanged).

4. **And** loss forfeits the bet (WS-BET subtracted from WS-BAL).

5. **And** the updated chip balance is displayed via BJACK-DISPL after payout.

6. **And** the payout logic is embedded in the outcome determination section of BJACK-MAIN (PROC-C / CALC-2 area) — not in a separate module.

7. **And** the game flow is: outcome → payout → display → check broke → play-again.

## Tasks / Subtasks

- [ ] Task 1: Add payout computation to PROC-C in BJACK-MAIN (AC: #1, #3, #4, #6)
  - [ ] After each WS-RC assignment in PROC-C, compute the payout immediately (inline)
  - [ ] WS-RC=1 (player win): `COMPUTE WS-BAL = WS-BAL + WS-BET`
  - [ ] WS-RC=2 (dealer win): `COMPUTE WS-BAL = WS-BAL - WS-BET`
  - [ ] WS-RC=3 (push): no change to WS-BAL
  - [ ] Keep PROC-C's GOTO structure intact

- [ ] Task 2: Ensure CALC-2 re-calls BJACK-DISPL after payout (AC: #5, #7)
  - [ ] Confirm CALC-2 calls BJACK-DISPL with WS-STAT=1 (already does — verify it still fires)
  - [ ] WS-BAL is updated before BJACK-DISPL is called in CALC-2 → updated balance displays

- [ ] Task 3: Verify broke check triggers correctly (AC: #7)
  - [ ] CHECK-X (from Story 5.1) checks WS-BAL = 0 before play-again prompt
  - [ ] After a losing round where WS-BAL drops to 0, "YOU ARE BROKE" should appear
  - [ ] No changes needed to CHECK-X — verify it works as implemented in Story 5.1

- [ ] Task 4: Full compile and test (AC: #1–#7)
  - [ ] Run `bash build.sh` — all modules compile without errors
  - [ ] Win a round: verify WS-BAL increases by WS-BET
  - [ ] Lose a round: verify WS-BAL decreases by WS-BET
  - [ ] Push: verify WS-BAL unchanged
  - [ ] Bet all remaining chips and lose: verify "YOU ARE BROKE" and STOP RUN
  - [ ] Win multiple rounds: verify WS-BAL accumulates correctly

## Dev Notes

### Prerequisite: Stories 5.1–5.4 Must Be Complete

This story requires:
- WS-BAL, WS-BET in WS-GAME.cpy (Story 5.1)
- STRT-1, BET-1, modified INIT-1, broke check in CHECK-X (Stories 5.1, 5.2)
- PROC-NB natural blackjack (Story 5.3)
- LOOP-A with 'D' double-down (Story 5.4)

### Current PROC-C Structure (After Stories 5.1–5.4)

```cobol
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
```

Outcome codes: WS-RC=1 (player win), WS-RC=2 (dealer win), WS-RC=3 (push)

### Payout Wired Into PROC-C

**Approach: Inline payout computation in each PROC-C branch, immediately after MOVE WS-RC.**

This is the "tangled in game flow" requirement from AC#6. The payout logic lives alongside the outcome determination — not cleanly separated, not in its own paragraph.

**New PROC-C with payout:**
```cobol
       PROC-C.
           IF WS-PT > 21
               MOVE 2 TO WS-RC
               COMPUTE WS-BAL = WS-BAL - WS-BET
               GO TO CALC-2
           END-IF
           IF WS-DT > 21
               MOVE 1 TO WS-RC
               COMPUTE WS-BAL = WS-BAL + WS-BET
               GO TO CALC-2
           END-IF
           IF WS-PT > WS-DT
               MOVE 1 TO WS-RC
               COMPUTE WS-BAL = WS-BAL + WS-BET
               GO TO CALC-2
           END-IF
           IF WS-DT > WS-PT
               MOVE 2 TO WS-RC
               COMPUTE WS-BAL = WS-BAL - WS-BET
               GO TO CALC-2
           END-IF
           MOVE 3 TO WS-RC
           GO TO CALC-2.
```

Push case (MOVE 3 TO WS-RC): no COMPUTE — WS-BAL is unchanged. Balance returned implicitly (WS-BET was never subtracted from WS-BAL in BET-1; WS-BAL just doesn't decrease).

### Why Payout Is in PROC-C, Not CALC-2

Architecture says: "payout logic is embedded in the outcome determination section of BJACK-MAIN (PROC-C / CALC-2 area)". Embedding it inside each IF branch of PROC-C is more tangled and demonstrably anti-pattern: the business logic (payout amounts) is interleaved with the game logic (outcome determination). This is the key demo moment.

CALC-2 then calls BJACK-DISPL which shows the updated WS-BAL. This is already handled by the existing CALC-2 — no changes needed there.

### Game Flow After This Story

Full round flow (updated from architecture Integration Points):
1. STRT-1: WS-BAL = 100 (once at session start)
2. INIT-1: reset per-round state (WS-BET=0, WS-FLG-A, etc.)
3. BET-1: prompt for bet, ACCEPT WS-BET
4. PROC-A: BJACK-DECK → BJACK-DEAL → BJACK-SCORE; check natural (→ PROC-NB if 21 on 2 cards)
5. BJACK-DISPL: show initial state
6. LOOP-A: ACCEPT WS-FLG-A
   - S: GO TO PROC-B (stand)
   - D: double WS-BET, one card, score, display → GO TO PROC-B (auto-stand)
   - H (or other): GO TO CALC-1 (hit → loop back)
7. PROC-B: BJACK-DEALER → BJACK-SCORE → GO TO PROC-C
8. PROC-C: determine outcome (WS-RC), compute payout (WS-BAL updated inline), GO TO CALC-2
9. CALC-2: WS-STAT=1, BJACK-DISPL (shows updated WS-BAL), CASINO-AUDIT-LOG, GO TO CHECK-X
10. CHECK-X: IF WS-BAL=0 → "YOU ARE BROKE" → STOP RUN; else play-again prompt

### CALC-2 Displays Updated WS-BAL

After PROC-C updates WS-BAL, execution falls to CALC-2:
```cobol
       CALC-2.
           MOVE 1 TO WS-STAT
           CALL 'BJACK-DISPL' USING BY REFERENCE WS-HND WS-GM
           CALL 'CASINO-AUDIT-LOG' USING BY REFERENCE WS-FLG-A WS-AM
           GO TO CHECK-X.
```

BJACK-DISPL with WS-STAT=1 shows the outcome message AND the updated WS-BAL (from CALC-7 in bjack-displ.cob which always shows WS-BAL). No changes to CALC-2 needed.

### Edge Cases

**WS-BAL Underflow:** If WS-BAL = 5 and WS-BET = 10 (impossible if bet validation is working from Story 5.2, but after Story 6.3 introduces the stale variable bug, this can happen). `COMPUTE WS-BAL = WS-BAL - WS-BET` with PIC 9(4) cannot go negative — it would wrap or truncate to 0 or produce unexpected behavior. For this story, bet validation (Story 5.2) prevents over-betting, so underflow should not occur. Document this assumption.

**WS-BAL Overflow:** WS-BAL is PIC 9(4), max 9999. Starting at 100 and winning bets, the balance could theoretically approach 9999. This is not a concern for demo purposes but is an implicit limitation.

**Double Down WS-BET:** If WS-BET was doubled in Story 5.4, PROC-C uses the doubled WS-BET for payout. Win: WS-BAL += doubled bet. Loss: WS-BAL -= doubled bet. This is correct and requires no special handling.

### Natural Blackjack Payout (Not This Story)

Story 5.3 already handles natural blackjack:
- PROC-NB: `COMPUTE WS-BAL = WS-BAL + WS-BET * 3 / 2`
- PROC-NB: GO TO CHECK-X directly (bypasses PROC-C entirely)

No conflict. PROC-C only fires for non-natural outcomes.

### Demo Talking Point

The payout calculation `COMPUTE WS-BAL = WS-BAL + WS-BET` / `COMPUTE WS-BAL = WS-BAL - WS-BET` is business logic (financial rules) embedded directly in the game flow paragraph (PROC-C). There is no separation between "determine outcome" and "apply financial consequence." This is the demo moment: "The business rules — how much the player wins or loses — are tangled right here with the game outcome logic. To change the payout structure, you'd have to surgically extract it from this spaghetti."

### Architecture Compliance

**MUST:**
- Payout logic inline in PROC-C (not a separate module, not a separate paragraph) ✓
- GOTO-driven flow (each branch GO TO CALC-2) ✓
- No return code checks after CALL in CALC-2 ✓
- No EVALUATE/WHEN ✓

**MUST NOT:**
- Create a CALC-PAY or PAYOUT-HANDLER paragraph
- Move payout to BJACK-DISPL or any other module
- Use EVALUATE for WS-RC routing

### Files Changing

- `src/bjack-main.cob` — modify PROC-C to add COMPUTE payout lines

No other files change.

### References

- FR37: Payout calculation 1:1 win, push, loss forfeits bet → [Source: docs/planning-artifacts/epics.md#Story 5.5]
- FR38: Chip balance persists across rounds → [Source: docs/planning-artifacts/epics.md#Story 5.1] (already implemented)
- FR39: Session ends at zero balance → [Source: docs/planning-artifacts/epics.md#Story 5.1] (CHECK-X already implemented)
- Architecture: Payout in PROC-C/CALC-2 area of BJACK-MAIN → [Source: docs/planning-artifacts/architecture.md#Integration Points step 12]
- Architecture: Business logic entanglement as key demo requirement → [Source: docs/planning-artifacts/architecture.md#Cross-Cutting Concerns]
- bjack-main.cob PROC-C current structure → [Source: src/bjack-main.cob]
- Story 5.1 CHECK-X broke check → [Source: docs/implementation-artifacts/5-1-copybook-extension-and-chip-balance-initialization.md#Dev Notes]
- Story 5.3 natural blackjack payout → [Source: docs/implementation-artifacts/5-3-natural-blackjack-detection-and-payout.md#Dev Notes]

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
