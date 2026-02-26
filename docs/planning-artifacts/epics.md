---
stepsCompleted: [step-01-validate-prerequisites, step-02-design-epics, step-03-create-stories, step-04-final-validation]
workflowStatus: complete
inputDocuments:
  - docs/planning-artifacts/prd.md
  - docs/planning-artifacts/architecture.md
---

# cobol-blackjack - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for cobol-blackjack, decomposing the requirements from the PRD and Architecture into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: The system can shuffle and deal from a standard 52-card deck
FR2: The system can deal an initial two-card hand to the player and the dealer
FR3: The player can choose to hit (receive an additional card) or stand (end their turn)
FR4: The system can execute the dealer turn according to standard casino rules
FR5: The system can calculate hand values with Ace counted as 1 or 11
FR6: The system can determine and display the round outcome (player win, dealer win, push)
FR7: The player can choose to play another round without restarting the application
FR8: Kamal can compile all source files with a single command on GnuCOBOL 3.1+/Ubuntu
FR9: Kamal can launch the game immediately after compilation via the same single command
FR10: The build process completes and the game reaches first player prompt within 5 seconds of command entry
FR11: The build script runs without modification on a fresh Ubuntu installation with GnuCOBOL 3.1+ installed
FR12: The system can display playing cards as ASCII representations in an 80-column terminal
FR13: The system can display both player and dealer hands simultaneously during a round
FR14: The system can display current hand values for player and dealer
FR15: The system can display round outcome messages legible to a non-COBOL audience
FR16: The system can prompt the player for hit/stand input in a manner consistent with 1980s terminal conventions
FR17: Each source file contains identifiable examples of 1980s-era code style (cryptic naming, GOTO statements, dead code, sparse/incorrect comments)
FR18: The codebase contains a minimum of 4 distinct, pointable examples of messiness demonstrable during a live demo without COBOL expertise
FR19: The overall project structure, file naming, and build process reflect 1980s mainframe development anti-patterns
FR20: The running terminal output visually reads as an authentic 1980s mainframe application to a non-technical observer
FR21: The deck management module contains a biased shuffle algorithm
FR22: The dealer logic module contains a soft 17 rule violation
FR23: The scoring module contains an Ace value recalculation failure when two Aces are held
FR24: The main game module contains no input validation on the hit/stand prompt
FR25: The deal module contains an off-by-one error in the deal array
FR26: The deck module contains a dead code paragraph that is never called
FR27: Each of the 6 deliberate bugs is independently verifiable through targeted testing without running the full game
FR28: The system calls a CASINO-AUDIT-LOG stub that accepts parameters and performs no operation
FR29: The system calls a LEGACY-RANDOM-GEN stub that returns a hardcoded value
FR30: Both middleware stubs compile and link without errors as part of the standard build
FR31: Kamal can read a README that provides step-by-step compile and run instructions
FR32: Kamal can read a README that lists and describes all 6 known bugs with enough detail to locate them in the code

### NonFunctional Requirements

NFR1: Application reaches first player prompt within 5 seconds of single launch command on standard Ubuntu machine
NFR2: Card display and game state render immediately upon each player action — no perceptible delay between input and output
NFR3: Play-again loop restarts a new round without recompilation or perceptible lag
NFR4: Game completes a full round without abnormal termination under any normal input (H, S, or equivalent)
NFR5: Application produces consistent, repeatable behavior across multiple consecutive runs on the same machine
NFR6: All source files compile without errors or warnings on GnuCOBOL 3.1+ on Ubuntu 20.04 or later
NFR7: Terminal display renders correctly in any standard 80-column terminal emulator (gnome-terminal, xterm, tmux) without special configuration
NFR8: Build script requires no additional dependencies beyond GnuCOBOL and standard GNU utilities
NFR9: Codebase scores "unmaintainable" against any standard code quality heuristic — cryptic naming, no modularity, non-linear flow, absent documentation
NFR10: Any code analysis tool surfaces multiple, distinct quality issues on first inspection

### Additional Requirements

- No starter template exists for COBOL — manual project scaffolding required. First story creates directory structure and empty source file stubs
- Complete 14-file project structure: 8 .cob source files + 3 .cpy copybooks + build.sh + README
- Directory structure: src/ (8 .cob files) + copy/ (3 .cpy files) at project root
- All modules use COBOL 74-era style: no EVALUATE, GOTO-driven flow, flat paragraph structure, nested IF trees
- Calling convention: BY REFERENCE on every CALL, zero return code checks after any CALL
- Copybook field names must be locked in the first implementation story — they are the architectural contract for all 8 modules. No module story should begin before copybooks are finalized
- Module decomposition defined: BJACK-MAIN (orchestrator), BJACK-DECK, BJACK-DEAL, BJACK-DEALER, BJACK-SCORE, BJACK-DISPL, CASINO-AUDIT-LOG, LEGACY-RANDOM-GEN
- BJACK-MAIN is the sole orchestrator — all cross-module calls route through it; modules do not call each other directly
- Implementation sequence from architecture: copybooks → BJACK-DECK/BJACK-DEAL → BJACK-SCORE/BJACK-DISPL → BJACK-DEALER → BJACK-MAIN → middleware stubs → build.sh
- All AI agents must enforce naming patterns: WS-CT1/WS-FLG-A/WS-X1 style variables, PROC-A/CALC-1/CHECK-X paragraph names, minimum one GOTO per module, wrong or outdated comments

### FR Coverage Map

FR1: Epic 2 — Shuffle and deal from 52-card deck (BJACK-DECK)
FR2: Epic 2 — Initial two-card deal (BJACK-DEAL)
FR3: Epic 2 — Hit/stand player choice (BJACK-MAIN)
FR4: Epic 2 — Dealer turn logic (BJACK-DEALER)
FR5: Epic 2 — Hand value + Ace calculation (BJACK-SCORE)
FR6: Epic 2 — Round outcome determination (BJACK-MAIN)
FR7: Epic 2 — Play-again loop (BJACK-MAIN)
FR8: Epic 2 — Single-command compile via build.sh
FR9: Epic 2 — Immediate launch after compilation
FR10: Epic 2 — <5s launch to first player prompt
FR11: Epic 2 — Runs on fresh Ubuntu with GnuCOBOL 3.1+
FR12: Epic 2 — ASCII card display in 80-column terminal (BJACK-DISPL)
FR13: Epic 2 — Simultaneous player/dealer hand display (BJACK-DISPL)
FR14: Epic 2 — Current hand values display (BJACK-DISPL)
FR15: Epic 2 — Round outcome messages (BJACK-DISPL)
FR16: Epic 2 — Period-accurate hit/stand prompt (BJACK-MAIN)
FR17: Epic 1+2 — 1980s code style in every source file (all modules)
FR18: Epic 2 — 4+ pointable messiness examples demonstrable without COBOL expertise
FR19: Epic 1 — Project structure and naming reflects 1980s mainframe anti-patterns
FR20: Epic 2 — Terminal reads as authentic 1980s mainframe to non-technical observer
FR21: Epic 3 — Biased shuffle algorithm (BJACK-DECK)
FR22: Epic 3 — Soft 17 rule violation (BJACK-DEALER)
FR23: Epic 3 — Ace recalculation failure when two Aces held (BJACK-SCORE)
FR24: Epic 3 — No input validation on hit/stand prompt (BJACK-MAIN)
FR25: Epic 3 — Off-by-one error in deal array (BJACK-DEAL)
FR26: Epic 3 — Dead code paragraph never called (BJACK-DECK)
FR27: Epic 3 — All 6 bugs independently verifiable through targeted testing
FR28: Epic 1 — CASINO-AUDIT-LOG stub accepts parameters, performs no operation
FR29: Epic 1 — LEGACY-RANDOM-GEN stub returns hardcoded value
FR30: Epic 1 — Both middleware stubs compile and link without errors
FR31: Epic 4 — README with step-by-step compile and run instructions
FR32: Epic 4 — README lists and describes all 6 known bugs with location detail

## Epic List

### Epic 1: Working Project Skeleton
Kamal has a compilable project skeleton — the full directory structure is in place, shared data contracts (copybooks with locked field names) are defined, both middleware stubs are implemented, and `./build.sh` produces a clean compile on a fresh Ubuntu machine. All foundational architectural decisions are locked before any game module work begins.
**FRs covered:** FR17 (partial — stubs carry anti-patterns), FR19, FR28, FR29, FR30

### Epic 2: Playable Blackjack with Authentic Terminal Presentation
Kamal can run `./build.sh` and play a complete round of Blackjack — deal, hit/stand, dealer turn, outcome, play-again — in an 80-column terminal that reads as authentic 1980s mainframe, with legacy code style throughout every module.
**FRs covered:** FR1–FR18, FR20

### Epic 3: Deliberate Defects
All 6 deliberate bugs are embedded in their specified modules, each independently verifiable through targeted testing, and the game continues to complete normally on valid input (H or S).
**FRs covered:** FR21–FR27

### Epic 4: Demo Documentation
Kamal has a README with step-by-step compile/run instructions and a known bugs list describing all 6 bugs with enough detail to locate them in the code without COBOL expertise.
**FRs covered:** FR31, FR32

---

## Epic 1: Working Project Skeleton

Kamal has a compilable project skeleton — the full directory structure is in place, shared data contracts (copybooks with locked field names) are defined, both middleware stubs are implemented, and `./build.sh` produces a clean compile on a fresh Ubuntu machine. All foundational architectural decisions are locked before any game module work begins.

### Story 1.1: Project Scaffold and Shared Data Structures

As a developer,
I want the project directory structure created and all three shared COBOL copybooks implemented with canonical field names,
So that all subsequent module work has a stable, shared data contract to build against.

**Acceptance Criteria:**

**Given** a fresh Ubuntu machine with GnuCOBOL 3.1+ installed and the repo cloned
**When** the directory structure is inspected
**Then** the layout matches: root (`build.sh`, `README`), `src/` (8 `.cob` stub files), `copy/` (3 `.cpy` files)
**And** `WS-DECK.cpy` defines a 52-element card array, card structure (suit, rank, face value), and deck index — all with cryptic WS-XX field names (e.g. WS-CT1, WS-X1 — no descriptive names)
**And** `WS-HANDS.cpy` defines player hand array, dealer hand array, and card counts per hand — all with cryptic field names
**And** `WS-GAME.cpy` defines game state flags, round outcome code, and play-again flag — all with cryptic field names
**And** all 8 `.cob` stub files exist in `src/` with valid IDENTIFICATION, ENVIRONMENT, DATA, and PROCEDURE DIVISIONs (minimal stubs that compile)
**And** no copybook field name is descriptive — any name that would pass a readability heuristic constitutes a failure

### Story 1.2: Middleware Stubs and Build Pipeline Validation

As a developer,
I want both middleware stubs fully implemented and `./build.sh` compiling and linking the full 8-module project,
So that the build pipeline is end-to-end validated before any game logic is written.

**Acceptance Criteria:**

**Given** the scaffold and copybooks from Story 1.1 are in place
**When** `./build.sh` is executed
**Then** all 8 `.cob` files compile without errors using `cobc -c -I copy/`
**And** all object files link into a single executable without errors using `cobc -x`
**And** `casino-audit-log.cob` accepts parameters via LINKAGE SECTION and performs no operation in PROCEDURE DIVISION (pure no-op)
**And** `legacy-random-gen.cob` accepts a parameter via LINKAGE SECTION and sets it to a hardcoded value (no actual randomness)
**And** both stub modules contain: at least one GOTO statement, cryptic WS-XX variable names, at least one wrong or outdated comment, and zero return-code checks
**And** `build.sh` contains no error checking between compile/link steps (authentic 1980s practice — `set -e` or similar is forbidden)
**And** the project structure itself — file names, directory names, build script style — reads as 1980s mainframe convention (FR19)

---

## Epic 2: Playable Blackjack with Authentic Terminal Presentation

Kamal can run `./build.sh` and play a complete round of Blackjack — deal, hit/stand, dealer turn, outcome, play-again — in an 80-column terminal that reads as authentic 1980s mainframe, with legacy code style throughout every module.

### Story 2.1: Deck Module — Initialization and Shuffle

As a developer,
I want `bjack-deck.cob` implemented with deck initialization and shuffle logic,
So that a shuffled 52-card deck is available in shared memory for all other modules to use.

**Acceptance Criteria:**

**Given** copybooks from Story 1.1 are in place
**When** BJACK-DECK is called
**Then** WS-DECK is populated with all 52 cards (4 suits × 13 ranks) with correct face values
**And** the deck is shuffled (order is non-sequential after initialization)
**And** the deck index is reset to 0
**And** BJACK-DECK calls `LEGACY-RANDOM-GEN` via `CALL 'LEGACY-RANDOM-GEN' USING BY REFERENCE` for its shuffle logic
**And** the module contains: GOTO-driven flow, cryptic WS-XX variable names, vague paragraph names (PROC-A / CALC-1 pattern), at least one wrong or outdated comment, zero return-code checks after CALL
**And** the module does NOT use EVALUATE/WHEN constructs

### Story 2.2: Deal Module — Initial Hand Distribution

As a developer,
I want `bjack-deal.cob` implemented to distribute cards from the deck into player and dealer hands,
So that a two-card starting hand is dealt to both player and dealer at the start of each round and additional cards can be dealt on a hit.

**Acceptance Criteria:**

**Given** WS-DECK is populated and shuffled (Story 2.1), WS-HANDS copybook is in place
**When** BJACK-DEAL is called for the initial deal
**Then** the player receives exactly 2 cards drawn sequentially from WS-DECK
**And** the dealer receives exactly 2 cards drawn sequentially from WS-DECK
**And** card counts in WS-HANDS are updated correctly
**When** BJACK-DEAL is called for a hit
**Then** one additional card is drawn from WS-DECK and added to the player's hand
**And** the module contains: GOTO-driven flow, cryptic WS-XX variable names, vague paragraph names, at least one wrong or outdated comment, zero return-code checks
**And** the module does NOT use EVALUATE/WHEN

### Story 2.3: Scoring Module — Hand Value Calculation

As a developer,
I want `bjack-score.cob` implemented to calculate hand values with Ace as 1 or 11,
So that the current point total for both hands is always available for display and game logic decisions.

**Acceptance Criteria:**

**Given** WS-HANDS is populated with cards
**When** BJACK-SCORE is called
**Then** it calculates the correct point total for the player hand (Ace = 11 unless total > 21, then Ace = 1)
**And** it calculates the correct point total for the dealer hand using the same Ace logic
**And** totals are written back into WS-GAME fields
**And** the module contains: GOTO-driven flow, cryptic WS-XX variable names, vague paragraph names (CALC-1 / CHECK-X pattern), at least one wrong or outdated comment, zero return-code checks
**And** the module does NOT use EVALUATE/WHEN

### Story 2.4: Display Module — Terminal Rendering

As a developer,
I want `bjack-displ.cob` implemented to render the full game state in an 80-column terminal,
So that Kamal sees an authentic 1980s-era mainframe display showing both hands, card values, and round outcomes.

**Acceptance Criteria:**

**Given** WS-HANDS and WS-DECK are populated
**When** BJACK-DISPL is called with appropriate display-mode flags
**Then** both player and dealer hands are displayed simultaneously using ASCII card representations (H/D/C/S suits)
**And** current hand values for both player and dealer are displayed
**And** round outcome messages (player win / dealer win / push) are legible to a non-COBOL audience
**And** all output fits within 80 columns using hardcoded leading spaces (no dynamic column computation)
**And** the overall visual presentation reads as an authentic 1980s mainframe terminal to a non-technical observer
**And** the module contains: GOTO-driven rendering logic, cryptic WS-XX variable names, hardcoded column positions, at least one wrong or outdated comment, zero return-code checks
**And** the module does NOT use EVALUATE/WHEN

### Story 2.5: Dealer Module — Dealer Turn Logic

As a developer,
I want `bjack-dealer.cob` implemented to execute the dealer's turn according to standard casino rules,
So that the dealer draws to 17 or higher and stands, enabling round outcome determination.

**Acceptance Criteria:**

**Given** WS-HANDS contains the dealer's initial two-card hand and BJACK-SCORE is available
**When** BJACK-DEALER is called
**Then** the dealer draws cards until the hand value reaches 17 or higher
**And** the dealer stands at 17 or higher (does not draw another card)
**And** each draw updates WS-HANDS and triggers a score recalculation
**And** the module contains: GOTO-driven loop logic, cryptic WS-XX variable names, vague paragraph names, at least one wrong or outdated comment, zero return-code checks after any CALL
**And** the module does NOT use EVALUATE/WHEN

### Story 2.6: Main Game Loop — Full Playable Round

As a demo presenter (Kamal),
I want `bjack-main.cob` implemented as the game orchestrator and `./build.sh` fully wired to compile and launch the complete application,
So that I can run a complete Blackjack round — deal, hit/stand, dealer turn, outcome, play-again — from a single command.

**Acceptance Criteria:**

**Given** all 5 game modules from Stories 2.1–2.5 are implemented and copybooks are locked
**When** `./build.sh` is executed on a fresh Ubuntu machine with GnuCOBOL 3.1+
**Then** all 8 modules compile and link without errors and the game launches within 5 seconds of command entry
**When** the game is running
**Then** BJACK-MAIN calls modules in sequence: BJACK-DECK (init/shuffle) → BJACK-DEAL (initial deal) → BJACK-SCORE → BJACK-DISPL → player hit/stand loop → BJACK-DEALER → BJACK-DISPL (outcome) → CASINO-AUDIT-LOG → play-again prompt
**And** the player hit/stand prompt uses period-accurate 1980s terminal conventions (e.g. `ENTER H OR S:`)
**And** ACCEPT for hit/stand input is in BJACK-MAIN only — no other module uses ACCEPT
**And** all CALL statements use `BY REFERENCE` — no exceptions
**And** no return-code checks appear after any CALL in any module
**And** the play-again loop restarts a new round without recompilation or perceptible lag
**And** a complete round (deal through play-again prompt) completes without abnormal termination on input H or S
**And** the codebase as a whole contains a minimum of 4 distinct, pointable examples of messiness demonstrable without COBOL expertise (cryptic names, GOTO jumps, dead structure, incorrect comments)
**And** terminal output renders correctly in gnome-terminal, xterm, and tmux without special configuration

---

## Epic 3: Deliberate Defects

All 6 deliberate bugs are embedded in their specified modules, each independently verifiable through targeted testing, and the game continues to complete normally on valid input (H or S).

### Story 3.1: Biased Shuffle and Dead Code (bjack-deck.cob)

As a developer,
I want `bjack-deck.cob` modified to contain a biased shuffle algorithm and an unreachable dead code paragraph,
So that the shuffle is demonstrably non-random and a clearly visible dead code block exists for demo narration.

**Acceptance Criteria:**

**Given** `bjack-deck.cob` from Story 2.1 is implemented
**When** the shuffle runs
**Then** the shuffle algorithm is biased — it does not produce a uniform random distribution (the hardcoded return from LEGACY-RANDOM-GEN causes cards to cluster predictably)
**And** the bias is observable: multiple runs produce non-random patterns detectable without COBOL expertise
**And** a dead code paragraph exists in the module (a named paragraph with logic that is never PERFORMed or GOTOed — unreachable by any code path)
**And** the game still completes a full round without abnormal termination on normal input (H or S)
**When** the bug is tested in isolation (bjack-deck.cob compiled standalone with a minimal test harness)
**Then** the biased shuffle is independently verifiable without running the full game

### Story 3.2: Off-By-One in Deal Array (bjack-deal.cob)

As a developer,
I want `bjack-deal.cob` modified to contain an off-by-one error in the deal array index,
So that the deal loop has a subtle but verifiable indexing defect.

**Acceptance Criteria:**

**Given** `bjack-deal.cob` from Story 2.2 is implemented
**When** BJACK-DEAL is called
**Then** the deal loop contains an off-by-one error in the array index (e.g. loop starts at 0 instead of 1, or ends one position early/late)
**And** the error is present in the code and verifiable on inspection without running the full game
**And** the game still completes a full round without abnormal termination on normal input — the off-by-one does not cause an ABEND under standard deal conditions
**When** the bug is tested in isolation
**Then** the off-by-one is independently verifiable through targeted testing of the deal module alone

### Story 3.3: Ace Recalculation Failure (bjack-score.cob)

As a developer,
I want `bjack-score.cob` modified so that the Ace recalculation logic fails when two Aces are held,
So that the scoring module has a demonstrable calculation defect in a specific hand scenario.

**Acceptance Criteria:**

**Given** `bjack-score.cob` from Story 2.3 is implemented
**When** a hand contains two Aces
**Then** the recalculation logic fails to correctly adjust both Aces (e.g. only the first Ace is recalculated from 11 to 1, producing an incorrect total of 12 instead of 2)
**And** the defect is present in the Ace-adjust paragraph and verifiable by inspecting the code
**And** the game still completes a full round without abnormal termination on normal input
**When** the bug is tested in isolation with a crafted two-Ace hand
**Then** the incorrect total is independently verifiable without running the full game loop

### Story 3.4: Soft 17 Rule Violation (bjack-dealer.cob)

As a developer,
I want `bjack-dealer.cob` modified so that the dealer incorrectly handles a soft 17 (Ace + 6),
So that the dealer logic violates standard casino rules in a verifiable way.

**Acceptance Criteria:**

**Given** `bjack-dealer.cob` from Story 2.5 is implemented
**When** the dealer holds a soft 17 (Ace counted as 11, total = 17)
**Then** the dealer either stands when it should hit, or hits when it should stand — violating standard casino soft 17 rules
**And** the violation is in the dealer hit/stand decision paragraph and verifiable by code inspection
**And** the game still completes a full round without abnormal termination on normal input
**When** the bug is tested in isolation with a crafted soft 17 dealer hand
**Then** the rule violation is independently verifiable without running the full game loop

### Story 3.5: No Input Validation on Hit/Stand Prompt (bjack-main.cob)

As a developer,
I want `bjack-main.cob` to have no input validation on the hit/stand ACCEPT prompt,
So that unexpected input produces undefined, demonstrable behavior — a specified defect that can be shown live.

**Acceptance Criteria:**

**Given** `bjack-main.cob` from Story 2.6 is implemented
**When** a value other than H or S is entered at the hit/stand prompt
**Then** the game does not validate the input — it proceeds with undefined behavior (no IF/error branch exists to catch invalid input)
**And** the absence of validation is visible in the code at the ACCEPT paragraph — a non-COBOL reader can see there is no check
**And** when H or S is entered, the game still completes a full round without abnormal termination (normal input path unaffected)
**And** the defect is independently verifiable by inspecting the ACCEPT paragraph in bjack-main.cob

---

## Epic 4: Demo Documentation

Kamal has a README with step-by-step compile/run instructions and a known bugs list describing all 6 bugs with enough detail to locate them in the code without COBOL expertise.

### Story 4.1: README — Launch Instructions and Known Bugs List

As a demo presenter (Kamal),
I want a README at the project root with step-by-step compile/run instructions and a complete known bugs list,
So that I can set up the demo on any fresh machine and know exactly which code locations to highlight for each of the 6 deliberate defects.

**Acceptance Criteria:**

**Given** the completed application from Epics 1–3
**When** Kamal reads the README
**Then** the compile/run section provides step-by-step instructions sufficient to get from a fresh Ubuntu install with GnuCOBOL 3.1+ to a running game — no assumed knowledge
**And** the known bugs section lists all 6 bugs with: the bug name, the module/file it lives in, the paragraph or line where it appears, and a plain-English description of what it does wrong
**And** each bug entry contains enough detail for Kamal to locate it in the code during a live demo without searching
**And** the README itself follows 1980s mainframe conventions — plain text format, no markdown rendering, terse style, no decorative formatting
**And** the README does NOT accurately describe all code behavior — at least one statement should be outdated or incorrect (consistent with the project's authenticity requirements)
