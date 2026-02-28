# Story 5.4: Double Down Action

Status: ready-for-dev

## Story

As a demo presenter (Kamal),
I want the player to be able to double down — doubling the bet and receiving exactly one card,
so that the game includes a strategic decision that adds business logic depth visible in the code.

## Acceptance Criteria

1. **Given** the player is at the action prompt during a round,
   **When** the player enters 'D' for double down,
   **Then** WS-BET is doubled.

2. **And** the player receives exactly one additional card via BJACK-DEAL.

3. **And** the player's turn ends immediately (auto-stand — no further hit/stand prompt).

4. **And** the dealer turn proceeds normally after auto-stand.

5. **And** the action prompt displays H/S/D options (e.g., `ENTER H, S, OR D:`).

6. **And** the double down logic is tangled in the main game loop — not cleanly separated into its own paragraph.

## Tasks / Subtasks

- [ ] Task 1: Update LOOP-A prompt in BJACK-MAIN to show H/S/D (AC: #5)
  - [ ] Change DISPLAY from `"   ENTER H OR S:"` to `"   ENTER H, S, OR D:"`
  - [ ] Update the wrong comment above LOOP-A to still be misleading (see notes)

- [ ] Task 2: Add 'D' handling inline in LOOP-A (AC: #1, #2, #3, #4, #6)
  - [ ] After `ACCEPT WS-FLG-A`, add IF WS-FLG-A = 'D' block
  - [ ] Inside the 'D' block: COMPUTE WS-BET = WS-BET * 2 (double the bet)
  - [ ] CALL 'BJACK-DEAL' for one card, CALL 'BJACK-SCORE', CALL 'BJACK-DISPL'
  - [ ] GO TO PROC-B (auto-stand — skip rest of LOOP-A, go straight to dealer turn)
  - [ ] Keep 'S' and fall-through-to-hit logic unchanged

- [ ] Task 3: Full compile and test (AC: #1–#6)
  - [ ] Run `bash build.sh` — all modules compile without errors
  - [ ] Enter 'H': normal hit behavior unchanged
  - [ ] Enter 'S': normal stand behavior unchanged
  - [ ] Enter 'D': WS-BET doubles, one card dealt, dealer turn fires, round concludes
  - [ ] Enter 'D' after already hitting: verify it still works (no card count check — this is the embedded bug for Story 6.2)

## Dev Notes

### Prerequisite: Stories 5.1, 5.2, 5.3 Must Be Complete

This story requires:
- WS-BAL, WS-BET in WS-GAME.cpy (Story 5.1)
- BET-1 prompt working (Story 5.2)
- Natural blackjack check in PROC-A (Story 5.3)

### Current LOOP-A (After Story 3.5)

```cobol
      * LOOP-A -- VALIDATES INPUT AND ROUTES TO HIT OR STAND
       LOOP-A.
           DISPLAY "   ENTER H OR S:"
           ACCEPT WS-FLG-A
           IF WS-FLG-A = 'S'
               GO TO PROC-B
           END-IF
           GO TO CALC-1.
```

### New LOOP-A After This Story

```cobol
      * LOOP-A -- VALIDATES INPUT AND ROUTES TO HIT OR STAND
       LOOP-A.
           DISPLAY "   ENTER H, S, OR D:"
           ACCEPT WS-FLG-A
           IF WS-FLG-A = 'S'
               GO TO PROC-B
           END-IF
           IF WS-FLG-A = 'D'
               COMPUTE WS-BET = WS-BET * 2
               CALL 'BJACK-DEAL' USING BY REFERENCE WS-DK WS-HND
               CALL 'BJACK-SCORE' USING BY REFERENCE WS-HND WS-GM
               MOVE 0 TO WS-STAT
               CALL 'BJACK-DISPL' USING BY REFERENCE WS-HND WS-GM
               GO TO PROC-B
           END-IF
           GO TO CALC-1.
```

Key points about this implementation:
- The wrong comment "VALIDATES INPUT AND ROUTES TO HIT OR STAND" stays — it still doesn't mention 'D', still falsely claims validation. It's now even more wrong (three options, none validated).
- The 'D' block is inline in LOOP-A (not a separate paragraph) — satisfies AC#6 "tangled in the main game loop"
- `GO TO PROC-B` after double down = auto-stand (PROC-B calls BJACK-DEALER and runs the dealer turn)
- `COMPUTE WS-BET = WS-BET * 2` doubles the bet — if bet was 10, it becomes 20
- After the 'D' block, normal 'H' falls through to `GO TO CALC-1` — unchanged behavior

### Why There Is No WS-PC = 2 Check (The Story 6.2 Bug)

Standard casino rules: double down is only allowed on the initial two-card hand. To enforce this, the code would check `WS-PC = 2` before allowing 'D'.

This check is intentionally absent. The LOOP-A paragraph accepts 'D' at any point in the player's turn — even after hitting (WS-PC = 3 or more). This is the double-down-anytime bug (FR44), which Story 6.2 will verify and document.

Do NOT add the WS-PC check. The missing validation IS the intended behavior.

### Auto-Stand Via GO TO PROC-B

After double down, the player's turn ends immediately. `GO TO PROC-B` in the current code runs:
```cobol
       PROC-B.
           CALL 'BJACK-DEALER' USING BY REFERENCE WS-DK WS-HND WS-GM
           CALL 'BJACK-SCORE' USING BY REFERENCE WS-HND WS-GM
           GO TO PROC-C.
```

This is exactly what we want: dealer takes their turn, then outcome is determined in PROC-C. No further player input is solicited (LOOP-A is bypassed).

### CALC-1 After PROC-B Decision

After the double down, `GO TO PROC-B` fires. The `GO TO CALC-1` at the end of LOOP-A is the fallthrough for non-S, non-D input (i.e., 'H' and anything else). This structure — three IFs then fallthrough — is consistent with the existing code pattern and authentic spaghetti style.

### Double-Down WS-BET Interaction with Payout (Story 5.5)

When double down fires:
- WS-BET is doubled (e.g., from 10 to 20)
- Story 5.5 will use WS-BET for payout calculation
- Win: WS-BAL += WS-BET (i.e., WS-BAL += 20 — double payoff)
- Loss: WS-BAL -= WS-BET (i.e., WS-BAL -= 20 — double loss)
- Push: WS-BAL unchanged

This is correct casino behavior for double-down outcomes. WS-BET doubling now flows through to Story 5.5's payout without any additional wiring.

### DISPLAY of WS-BET During Double Down

The inline CALL 'BJACK-DISPL' in the 'D' block will display the doubled WS-BET (since WS-BET is already computed before BJACK-DISPL is called). The player sees their doubled bet in the display — correct behavior.

### What BJACK-DISPL Displays During Double Down

After `COMPUTE WS-BET = WS-BET * 2` and CALL BJACK-DISPL:
- WS-BAL: unchanged (payout is Story 5.5)
- WS-BET: doubled value shown (e.g., 20 if original bet was 10)
- WS-STAT=0: in-play display (not outcome display)
- The new card received via BJACK-DEAL is shown in the hand

This gives the player a visual of "one card received, bet is now doubled, dealer takes over."

### Wrong Comment Strategy

The existing comment `* LOOP-A -- VALIDATES INPUT AND ROUTES TO HIT OR STAND` (from Story 3.5) remains as-is. It now describes 3 options but mentions none of them by name. Keep it — it's already wrong (claims validation which doesn't exist) and gets more wrong with D added.

If adding a second comment, examples:
```
      * UPDATED 07/89 -- ADDED SPLIT HAND SUPPORT
```
(No split hand support exists in this codebase.)

### Files Changing

- `src/bjack-main.cob` — modify LOOP-A (new prompt, add 'D' branch)

No other files change.

### Architecture Compliance

**MUST:**
- 'D' handling is inline in LOOP-A (not a separate paragraph) — per AC#6 ✓
- `GO TO PROC-B` for auto-stand ✓
- BY REFERENCE on CALL 'BJACK-DEAL' ✓
- No return code checks after CALLs ✓
- Wrong comment preserved ✓
- GOTO-driven flow (GO TO PROC-B, GO TO CALC-1) ✓

**MUST NOT:**
- Create a DOUBLE-DOWN-HANDLER paragraph (too clean)
- Add WS-PC = 2 validation (Story 6.2 bug — absent by design)
- Use EVALUATE/WHEN for H/S/D routing

### Regression Test Checklist

After this story:
- [ ] 'H' input → hit behavior unchanged → CALC-1 fires
- [ ] 'S' input → stand behavior unchanged → PROC-B fires
- [ ] 'D' input on first turn (WS-PC=2) → WS-BET doubles, one card, PROC-B fires
- [ ] 'D' input after hitting (WS-PC=3) → same as above (no guard check — expected)
- [ ] Any other input → falls through to CALC-1 (hit) — no change from existing behavior
- [ ] Natural blackjack still fires correctly (PROC-NB, from Story 5.3)
- [ ] WS-BAL unchanged after double down (payout Story 5.5 not yet implemented)
- [ ] No ABEND on any of the above

### References

- FR36: Double down — double bet, one card, auto-stand → [Source: docs/planning-artifacts/epics.md#Story 5.4]
- FR44: Double-down-anytime rule violation (no WS-PC check, by design) → [Source: docs/planning-artifacts/epics.md#Story 6.2]
- Architecture: Double down in BJACK-MAIN LOOP-A section → [Source: docs/planning-artifacts/architecture.md#Integration Points step 9]
- Architecture: BJACK-MAIN orchestrator — all CALL routing through main → [Source: docs/planning-artifacts/architecture.md#Architectural Boundaries]
- bjack-main.cob LOOP-A (current state after Story 3.5) → [Source: src/bjack-main.cob]
- Story 3.5 Dev Notes: confirmed LOOP-A structure → [Source: docs/implementation-artifacts/3-5-no-input-validation-on-hit-stand-prompt.md#Dev Notes]

## Dev Agent Record

### Agent Model Used

claude-sonnet-4-6

### Debug Log References

### Completion Notes List

### File List
