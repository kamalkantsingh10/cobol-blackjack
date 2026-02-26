---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
inputDocuments:
  - docs/planning-artifacts/prd.md
  - docs/planning-artifacts/product-brief-cobol-blackjack-2026-02-26.md
workflowType: 'architecture'
project_name: 'cobol-blackjack'
user_name: 'Kamal'
date: '2026-02-26'
lastStep: 8
status: 'complete'
completedAt: '2026-02-26'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements (32 total):**

- **Game Engine (FR1–FR7):** Standard Blackjack loop — shuffle, deal, hit/stand, dealer
  turn, Ace valuation, outcome display, play-again. All standard casino rules except
  where deliberately violated by the 6 specified bugs.
- **Build & Deployment (FR8–FR11):** Single `build.sh` command compiles and launches on
  GnuCOBOL 3.1+/Ubuntu. Launch-to-first-prompt under 5 seconds. No manual steps.
- **Terminal Display (FR12–FR16):** ASCII card rendering in 80-column terminal.
  Simultaneous player/dealer hand display. Period-accurate prompts. No color dependency.
- **Legacy Code Authenticity (FR17–FR20):** Every source file carries identifiable
  1980s-era anti-patterns. 4+ pointable examples demonstrable without COBOL expertise.
  Project structure and naming reflect 1980s mainframe development practices.
- **Deliberate Defects (FR21–FR27):** 6 specific bugs with module assignments:
  biased shuffle (BJACK-DECK), soft 17 violation (BJACK-DEALER), Ace recalculation
  failure (BJACK-SCORE), no input validation (BJACK-MAIN), off-by-one in deal array
  (BJACK-DEAL), dead code paragraph (BJACK-DECK). Each independently verifiable.
- **Middleware Stubs (FR28–FR30):** CASINO-AUDIT-LOG (accepts params, no-op) and
  LEGACY-RANDOM-GEN (returns hardcoded value). Both compile and link cleanly.
- **Documentation (FR31–FR32):** README with compile/run instructions and known bugs list.

**Non-Functional Requirements:**

- **Performance:** <5 second launch; immediate render on each player action; play-again
  loop requires no recompilation.
- **Reliability:** Full game round (deal through play-again) completes without abnormal
  termination on normal input (H/S). Undefined behavior on unexpected input is a
  specified defect (FR24), not a reliability gap.
- **Compatibility:** GnuCOBOL 3.1+, Ubuntu 20.04+, any standard 80-column terminal
  emulator (gnome-terminal, xterm, tmux). No macOS requirement.
- **Intentional Un-maintainability:** Codebase must score "unmaintainable" against any
  standard quality heuristic. A clean implementation constitutes a failure.

**Scale & Complexity:**

- Primary domain: CLI / Mainframe Terminal Application
- Complexity level: Low
- Estimated architectural components: 8–14 COBOL source files, 1–3 copybooks,
  2 middleware stub programs, 1 build script, 1 README

### Technical Constraints & Dependencies

- **Runtime:** GnuCOBOL 3.1+ on Ubuntu 20.04+ only
- **I/O:** COBOL DISPLAY/ACCEPT only — no CICS, no BMS, no external rendering libraries
- **Terminal:** 80-column standard terminal, no color, no special sequences
- **Build:** Standard bash + GnuCOBOL compiler (`cobc`) + GNU utilities only
- **Style:** COBOL 74-era patterns — no EVALUATE, no structured programming from COBOL 85
- **Module count:** 8–14 source files; module names partially specified in PRD

### Cross-Cutting Concerns Identified

- **Tech debt distribution:** Anti-patterns must appear in every source file — no file
  is clean. This is an architectural constraint on all module decisions.
- **Bug-reliability tension:** Game must run cleanly on normal input while 6 bugs are
  present and independently verifiable. Each bug must be subtle enough to be invisible
  during casual play.
- **Build reproducibility:** Compilation order and COPY dependencies must be stable
  across fresh Ubuntu installs. Build script is a deliverable, not a convenience.
- **Terminal authenticity:** Visual output must read as 1980s mainframe to a non-
  technical observer without explanation — layout, prompt style, and spacing are
  architectural decisions.

## Starter Template Evaluation

### Primary Technology Domain

COBOL CLI / Mainframe Terminal Application. No starter template exists for this
technology domain — project scaffolding is manual. This is architecturally consistent
with the 1980s-era authenticity goal: real legacy projects had no scaffolding tooling.

### Starter Options Considered

No viable COBOL starter templates exist in the modern sense. The foundational setup
decisions that a starter would normally provide must instead be made explicitly here.

### Selected Approach: Manual Project Scaffolding

**Rationale:**
No starter template applies. All foundational decisions are made explicitly in this
architecture document. This is consistent with the project's authenticity requirements.

**Initialization Command:**

```bash
mkdir -p cobol-blackjack/src
touch cobol-blackjack/build.sh && chmod +x cobol-blackjack/build.sh
```

**Architectural Decisions Provided by Baseline Setup:**

**Language & Runtime:**
- GnuCOBOL 3.2 (latest stable, released July 2023); compatible with 3.1+
- COBOL dialect: default GnuCOBOL (COBOL 74/85 style enforced by coding standards)
- Target platform: Ubuntu 20.04+ only

**Build Tooling:**
- Compiler: `cobc` (GnuCOBOL compiler)
- Execution: `cobcrun` or compiled native executable via `cobc -x`
- Build script: single `build.sh` — compiles all modules in dependency order,
  then launches the main program. No Makefile, no CMake, no external build system.

**Project Structure:**
- Flat or shallow source tree (1980s mainframe projects had no deep directory nesting)
- All `.cob` source files in root or single `src/` directory
- Copybooks (`.cpy`) alongside source files or in a `copy/` subdirectory
- No package manager, no lock files, no dependency manifests

**Testing Infrastructure:**
- No automated test framework (consistent with 1980s authenticity)
- Bug verification is manual: targeted isolation runs per bug
- Test approach documented in README alongside the bugs list

**Code Organization:**
- Module decomposition defined by PRD: BJACK-MAIN, BJACK-DECK, BJACK-DEAL,
  BJACK-DEALER, BJACK-SCORE, CASINO-AUDIT-LOG, LEGACY-RANDOM-GEN
- Shared data structures via COBOL COPY statements (copybooks)
- No structured programming — GOTO-driven, nested IF, spaghetti flow throughout

**Development Experience:**
- Editor: any text editor (no IDE requirements, no language server)
- No linting, no formatting, no static analysis (by design)
- `build.sh` is the single development workflow entry point

**Note:** The first implementation story should create the project skeleton:
directory structure, empty source file stubs, and the initial `build.sh` framework.

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**
- Module decomposition: 8 .cob files defined
- Shared data via functional copybook split
- Separate compile + link with BY REFERENCE conventions
- Directory structure: src/ + copy/

**Deferred Decisions (Post-MVP):**
- None — all decisions required for implementation are resolved

---

### Data Architecture

**Shared Copybooks — Functional Split (3 files):**

- `copy/WS-DECK.cpy` — Card structure (suit, rank, face value), 52-element deck
  array, current deck index/pointer
- `copy/WS-HANDS.cpy` — Player hand array, dealer hand array, card count per
  hand (max cards per hand)
- `copy/WS-GAME.cpy` — Game state flags, round outcome code, play-again flag,
  running score totals

**Rationale:** Functional split mirrors how real mainframe shops organized
separate "copy libraries" owned by different teams. Each copybook is an
independent surface for tech debt and cryptic naming. Copybooks do not require
separate compilation — they are resolved at compile time via `COPY` statement
with `-I copy/` include path.

---

### Inter-Module Communication

**Separate Compile + Link:**
- Each `.cob` source file compiled independently: `cobc -c -I copy/ src/module.cob`
- All object files linked into single executable: `cobc -x -o bjack *.o`
- Produces authentic separate compilation artifacts; `build.sh` mirrors
  how mainframe JCL handled compile and link steps as distinct job steps

**Calling Convention — BY REFERENCE everywhere:**
- All `CALL` parameters passed `BY REFERENCE` (passes memory address, not copy)
- Subprograms can and do modify caller's data — a source of subtle, hard-to-trace
  bugs consistent with 1980s COBOL practice
- No defensive `BY CONTENT` usage — that was a later, disciplined practice

---

### Terminal Display Architecture

**BJACK-DISPL — Dedicated Display Module:**
- All ASCII card rendering and game state display consolidated in `src/bjack-displ.cob`
- Called from BJACK-MAIN via `CALL 'BJACK-DISPL' USING BY REFERENCE ...`
- Receives hand data and display-mode flags; outputs via DISPLAY statements
- Internally: its own share of cryptic naming, hardcoded column positions,
  GOTO-driven rendering logic, and incorrect comments

---

### Infrastructure & Deployment

**Directory Structure:**
```
cobol-blackjack/
├── build.sh          ← single compile + link + launch script
├── README            ← compile/run instructions + known bugs list
├── src/              ← all 8 .cob source files
│   ├── bjack-main.cob
│   ├── bjack-deck.cob
│   ├── bjack-deal.cob
│   ├── bjack-dealer.cob
│   ├── bjack-score.cob
│   ├── bjack-displ.cob
│   ├── casino-audit-log.cob
│   └── legacy-random-gen.cob
└── copy/             ← 3 shared copybooks
    ├── WS-DECK.cpy
    ├── WS-HANDS.cpy
    └── WS-GAME.cpy
```

**build.sh Strategy:**
1. Compile each module separately with `cobc -c -I copy/`
2. Link all `.o` files into single executable with `cobc -x`
3. Launch executable immediately — no pause between build and run
4. No error checking in build script (consistent with 1980s practice)

---

### Decision Impact Analysis

**Implementation Sequence:**
1. Create directory structure and empty file stubs
2. Define all three copybooks (shared data structures first)
3. Implement BJACK-DECK and BJACK-DEAL (no dependencies on other modules)
4. Implement BJACK-SCORE and BJACK-DISPL (depend on WS-HANDS, WS-DECK)
5. Implement BJACK-DEALER (depends on BJACK-SCORE via shared WS-HANDS)
6. Implement BJACK-MAIN (orchestrator, depends on all modules)
7. Implement middleware stubs CASINO-AUDIT-LOG and LEGACY-RANDOM-GEN
8. Write build.sh and validate full compile + link + launch

**Cross-Component Dependencies:**
- All modules share data via copybooks — copybook changes affect all files
- BY REFERENCE convention means module A calling module B can have its
  WORKING-STORAGE mutated — a deliberate risk surface for subtle bugs
- BJACK-DISPL depends on WS-HANDS.cpy and WS-DECK.cpy structures
- Build order in build.sh must compile all modules before final link step

## Implementation Patterns & Consistency Rules

**Critical Conflict Points Identified:**
8 areas where AI agents could make incompatible choices

---

### Naming Patterns

**WORKING-STORAGE Variable Naming:**

Agents default to descriptive names. This project requires cryptic names.

Rule: All WORKING-STORAGE variables use a short, opaque prefix pattern.
Copybook-sourced fields follow whatever the copybook defines.

Pattern:
- Local counters: WS-CT1, WS-CT2 (not WS-CARD-COUNT)
- Local flags: WS-FLG-A, WS-FLG-B (not WS-ACE-FOUND)
- Local work areas: WS-X1, WS-X2, WS-PHT (not WS-TEMP-VALUE)
- Return/status fields: WS-RC, WS-STAT (not WS-RETURN-CODE)

Anti-pattern: WS-CARD-COUNT, WS-ACE-FLAG, WS-DEALER-TOTAL — too readable.

**Paragraph / Section Naming:**

Agents default to descriptive paragraph names. This project requires vague ones.

Rule: Paragraph names use abbreviated, non-descriptive labels that hint at
function but don't explain it.

Pattern:
- PROC-A, PROC-B, PROC-C (main processing blocks)
- CALC-1, CALC-2 (calculation routines)
- CHECK-X, CHECK-Y (validation/comparison blocks)
- INIT-1 (initialization — but what is being initialized?)
- LOOP-A, LOOP-B (iteration blocks)
- ERR-1 (error path — what error? doesn't say)

Anti-pattern: SHUFFLE-DECK, CALCULATE-HAND-VALUE, CHECK-FOR-BLACKJACK — too descriptive.

**Module/Program Naming:**

Already established. BJACK-XXXX for game modules, exact names from architecture.
No deviation. CALL statements must reference the exact program name as defined.

---

### Structure Patterns

**COPY Statement Placement:**

Rule: COPY statements appear in the WORKING-STORAGE SECTION of the DATA DIVISION.
Each module copies only what it needs:
- BJACK-DECK: COPY WS-DECK
- BJACK-DEAL: COPY WS-DECK, COPY WS-HANDS
- BJACK-DEALER: COPY WS-HANDS, COPY WS-GAME
- BJACK-SCORE: COPY WS-HANDS, COPY WS-GAME
- BJACK-DISPL: COPY WS-HANDS, COPY WS-DECK
- BJACK-MAIN: COPY WS-DECK, COPY WS-HANDS, COPY WS-GAME (all three)
- Middleware stubs: no COPY statements needed

**PROCEDURE DIVISION Structure:**

Rule: No SECTIONS within PROCEDURE DIVISION. Flat paragraph structure only.
Paragraphs called via PERFORM or jumped to via GOTO — mixed usage within the
same module is encouraged (inconsistency is authentic).

Anti-pattern: Using SECTIONS (INITIALIZATION SECTION, MAIN-LOGIC SECTION) —
too organized.

**DIVISIONS Ordering:**

Mandatory COBOL order — agents must not deviate:
IDENTIFICATION DIVISION → ENVIRONMENT DIVISION → DATA DIVISION → PROCEDURE DIVISION

---

### Format Patterns

**DISPLAY Output Format:**

Rule: All terminal output uses hardcoded column positions via DISPLAY with
leading spaces counted manually. No MOVE TO COLUMN constructs.
80-column layout maintained by character counting, not terminal control.

Pattern:
  DISPLAY "  PLAYER HAND:"
  DISPLAY "  " WS-CARD-1 "  " WS-CARD-2

Anti-pattern: Dynamically computed column positions, MOVE SPACES TO output-line.

**CALL Statement Format:**

Rule: Every CALL uses BY REFERENCE. No exceptions.

Pattern:
  CALL 'BJACK-DECK' USING BY REFERENCE WS-DECK-DATA
  CALL 'CASINO-AUDIT-LOG' USING BY REFERENCE WS-AUD-CODE WS-AUD-MSG

Anti-pattern: CALL 'BJACK-DECK' USING BY CONTENT WS-DECK-DATA

---

### Communication Patterns

**Error and Return Handling:**

Rule: No return code checking after CALL statements in any module.
No IF RETURN-CODE NOT = 0 constructs anywhere in the codebase.
Errors are silent. This is a specified anti-pattern, not an oversight.

Anti-pattern:
  CALL 'BJACK-DECK' USING BY REFERENCE WS-DECK-DATA
  IF RETURN-CODE NOT = 0
    DISPLAY "ERROR IN DECK MODULE"   ← DO NOT DO THIS

**Game State Transitions:**

Rule: BJACK-MAIN owns game flow. Other modules do not call each other directly —
all cross-module orchestration goes through BJACK-MAIN. Modules are leaves,
not coordinators.

---

### Process Patterns

**Control Flow:**

Rule: GOTO statements must appear in every module. Minimum one GOTO per module.
GOTO targets must be within the same module. Forward and backward GOTOs both
permitted. Nested IF trees preferred over EVALUATE/WHEN.

Pattern:
  IF WS-FLG-A = 1
    IF WS-CT1 > 21
      GO TO ERR-1
    END-IF
  END-IF

Anti-pattern: EVALUATE WS-FLG-A / WHEN 1 — DO NOT USE EVALUATE.

**Comment Style:**

Rule: Comments must be sparse, outdated, or factually wrong. Each module
should have 2–4 comments total. At least one comment should describe something
the code no longer does, or describe it incorrectly.

Pattern:
  * INITIALIZE DECK VALUES
  * (this paragraph also handles the audit log -- note: it doesn't)
  * UPDATED 03/15/89 -- FIXED SHUFFLE BUG (the bug is still there)

Anti-pattern: Accurate, helpful inline comments explaining what the code does.

**Bug Implementation Rules:**

Rule: Each of the 6 bugs must satisfy two constraints simultaneously:
1. The game completes a full round without ABEND under normal input (H or S)
2. The bug is independently verifiable through targeted testing

Agents implementing bug modules must verify both constraints. A bug that
crashes the game on normal input is a defect in the demo asset. A bug that
requires deep COBOL knowledge to observe fails the demo purpose.

---

### Enforcement Guidelines

**All AI Agents MUST:**
- Use cryptic WS-XX-Y naming for all local WORKING-STORAGE variables
- Use vague paragraph names (PROC-A, CALC-1, CHECK-X pattern)
- Include at least one GOTO statement per module
- Use BY REFERENCE on every CALL
- Write zero return code checks after any CALL
- Include at least one wrong or outdated comment per module
- Verify: game completes full round under normal input after their changes

**All AI Agents MUST NOT:**
- Use EVALUATE/WHEN constructs
- Use descriptive variable or paragraph names
- Add error checking after CALL statements
- Write accurate, helpful comments
- Use SECTIONS in the PROCEDURE DIVISION
- Call modules from modules (all cross-module calls route through BJACK-MAIN)

## Project Structure & Boundaries

### Complete Project Directory Structure

```
cobol-blackjack/
├── build.sh                   ← compile + link + launch (FR8–FR11)
├── README                     ← compile/run instructions + known bugs (FR31–FR32)
├── src/
│   ├── bjack-main.cob         ← game loop orchestrator (FR3, FR6, FR7, FR24)
│   ├── bjack-deck.cob         ← deck init + shuffle (FR1, FR21, FR26)
│   ├── bjack-deal.cob         ← initial deal logic (FR2, FR25)
│   ├── bjack-dealer.cob       ← dealer turn logic (FR4, FR22)
│   ├── bjack-score.cob        ← hand value calculation (FR5, FR23)
│   ├── bjack-displ.cob        ← all terminal rendering (FR12–FR16, FR20)
│   ├── casino-audit-log.cob   ← middleware stub, no-op (FR28, FR30)
│   └── legacy-random-gen.cob  ← middleware stub, hardcoded return (FR29, FR30)
└── copy/
    ├── WS-DECK.cpy            ← card structure, 52-element deck array, deck index
    ├── WS-HANDS.cpy           ← player/dealer hand arrays, card counts per hand
    └── WS-GAME.cpy            ← game state flags, round outcome, play-again flag
```

### Architectural Boundaries

**Orchestration Boundary:**
BJACK-MAIN is the sole orchestrator. No module calls another module directly.
All cross-module coordination routes through BJACK-MAIN.

```
BJACK-MAIN
  ├── CALL 'BJACK-DECK'          ← deck init and shuffle
  ├── CALL 'BJACK-DEAL'          ← deal initial hands
  ├── CALL 'BJACK-DISPL'         ← render game state
  ├── CALL 'BJACK-SCORE'         ← calculate hand values
  ├── CALL 'BJACK-DEALER'        ← run dealer turn
  ├── CALL 'CASINO-AUDIT-LOG'    ← audit stub (no-op)
  └── BJACK-DECK
        └── CALL 'LEGACY-RANDOM-GEN'  ← random stub (hardcoded value)
```

**Data Boundary:**
All shared game state lives exclusively in copybooks. No module maintains
its own private copy of shared data. Modules read and write shared state
via BY REFERENCE parameters backed by the copybook structures.

**I/O Boundary:**
- All DISPLAY output routes through BJACK-DISPL (display module)
- All ACCEPT input (player hit/stand prompt) lives in BJACK-MAIN only
- No other module uses ACCEPT

**Build Boundary:**
build.sh is the only entry point. No module is compiled or run independently
in normal operation. Bug verification is the sole exception — targeted
isolation runs compile individual modules with test harnesses outside build.sh.

---

### Requirements to Structure Mapping

**Game Engine (FR1–FR7):**
- FR1 shuffle/deal from deck → bjack-deck.cob
- FR2 initial two-card deal → bjack-deal.cob
- FR3 hit/stand player choice → bjack-main.cob (ACCEPT + CALL orchestration)
- FR4 dealer turn logic → bjack-dealer.cob
- FR5 hand value + Ace calculation → bjack-score.cob
- FR6 round outcome determination → bjack-main.cob (reads WS-GAME result)
- FR7 play-again loop → bjack-main.cob (WS-GAME play-again flag)

**Build & Deployment (FR8–FR11):**
- FR8–FR11 single-command compile + launch → build.sh

**Terminal Display (FR12–FR16, FR20):**
- FR12 ASCII card display → bjack-displ.cob
- FR13 simultaneous player/dealer hands → bjack-displ.cob
- FR14 current hand values display → bjack-displ.cob
- FR15 round outcome messages → bjack-displ.cob
- FR16 period-accurate hit/stand prompt → bjack-main.cob
- FR20 terminal reads as 1980s mainframe → bjack-displ.cob + bjack-main.cob

**Legacy Code Authenticity (FR17–FR19):**
- Cross-cutting — enforced in every .cob and .cpy file per implementation patterns

**Deliberate Defects (FR21–FR27):**
- FR21 biased shuffle → bjack-deck.cob (shuffle paragraph)
- FR22 soft 17 violation → bjack-dealer.cob (dealer hit/stand decision paragraph)
- FR23 Ace recalculation failure → bjack-score.cob (Ace adjust paragraph)
- FR24 no input validation → bjack-main.cob (hit/stand ACCEPT paragraph)
- FR25 off-by-one in deal array → bjack-deal.cob (deal loop paragraph)
- FR26 dead code paragraph → bjack-deck.cob (unreachable paragraph, never PERFORMed)
- FR27 independent verifiability → each bug module can be compiled and tested in isolation

**Middleware Stubs (FR28–FR30):**
- FR28 CASINO-AUDIT-LOG → casino-audit-log.cob (LINKAGE SECTION, PROCEDURE does nothing)
- FR29 LEGACY-RANDOM-GEN → legacy-random-gen.cob (returns hardcoded value via LINKAGE)
- FR30 both compile cleanly → validated by build.sh completing without errors

**Documentation (FR31–FR32):**
- FR31 compile/run instructions → README
- FR32 known bugs list → README

---

### Integration Points

**Internal Data Flow (one game round):**
1. build.sh: `cobc -c -I copy/` each src/*.cob → link → launch bjack
2. bjack starts → BJACK-MAIN: CALL BJACK-DECK (init + shuffle deck in WS-DECK)
3. BJACK-MAIN: CALL BJACK-DEAL (populate WS-HANDS with initial 4 cards)
4. BJACK-MAIN: CALL BJACK-SCORE (calculate initial values into WS-GAME)
5. BJACK-MAIN: CALL BJACK-DISPL (render both hands)
6. BJACK-MAIN: ACCEPT WS-FLG-A (player hit/stand — no validation per FR24)
7. Loop: CALL BJACK-DEAL (hit) → CALL BJACK-SCORE → CALL BJACK-DISPL → repeat
8. BJACK-MAIN: CALL BJACK-DEALER (dealer turn — reads/writes WS-HANDS, WS-GAME)
9. BJACK-MAIN: CALL BJACK-DISPL (show final state + outcome)
10. BJACK-MAIN: CALL CASINO-AUDIT-LOG (no-op)
11. BJACK-MAIN: ACCEPT WS-FLG-B (play again? — no validation)
12. Loop back to step 3 or STOP RUN

**BJACK-DECK internal call:**
BJACK-DECK: CALL LEGACY-RANDOM-GEN to get "random" number (returns hardcoded
value) — the hook that makes the shuffle biased (FR21 + FR29)

**External Integrations:** None.

---

### Development Workflow

**Build Process:**
```bash
# build.sh (no error checking — authentic)
cobc -c -I copy/ src/bjack-deck.cob
cobc -c -I copy/ src/bjack-deal.cob
cobc -c -I copy/ src/bjack-dealer.cob
cobc -c -I copy/ src/bjack-score.cob
cobc -c -I copy/ src/bjack-displ.cob
cobc -c -I copy/ src/casino-audit-log.cob
cobc -c -I copy/ src/legacy-random-gen.cob
cobc -c -I copy/ src/bjack-main.cob
cobc -x -o bjack bjack-main.o bjack-deck.o bjack-deal.o bjack-dealer.o \
    bjack-score.o bjack-displ.o casino-audit-log.o legacy-random-gen.o
./bjack
```

**Bug Verification (outside build.sh):**
Each bug module can be isolated by writing a minimal test harness .cob file
that CALLs only the target module with crafted input, compiles it standalone,
and inspects output or WS state. No test framework required.

## Architecture Validation Results

### Coherence Validation ✅

**Decision Compatibility:** All technology choices are compatible.
GnuCOBOL 3.2 + Ubuntu 20.04+ is a stable, well-tested combination.
COBOL 74-era style (no EVALUATE, GOTO-driven, nested IF) is internally coherent
and historically accurate. BY REFERENCE calling + shared copybooks is the standard
1980s COBOL inter-program communication pattern. No version conflicts identified.

**Pattern Consistency:** Implementation patterns are mutually reinforcing.
Cryptic naming, vague paragraph names, and inaccurate comments compound each other
to produce authentic unmaintainability. The BJACK-MAIN orchestrator + leaf module
pattern eliminates circular dependencies. build.sh compilation flags align with
the src/ + copy/ directory split.

**Structure Alignment:** Project structure fully supports all architectural decisions.
All 8 .cob files have explicit FR ownership. All 3 copybooks serve distinct data
domains. Build process is explicit and sequenced with no ambiguity.

### Requirements Coverage Validation ✅

**Functional Requirements:** All 32 FRs mapped to specific modules.
See Requirements to Structure Mapping in Project Structure section.

**Non-Functional Requirements:**
- Performance (<5s launch): GnuCOBOL single-executable, no heavy runtime startup ✅
- Reliability (no ABEND on normal input): enforced by bug implementation rules ✅
- Compatibility (GnuCOBOL 3.1+, Ubuntu 20.04+, 80-column): fully specified ✅
- Intentional un-maintainability: enforced by 8-rule MUST/MUST NOT pattern set ✅

### Implementation Readiness Validation ✅

**Decision Completeness:** All critical decisions documented. Runtime, build tooling,
module decomposition, calling conventions, directory structure, and data architecture
are all fully specified. No blocking ambiguities remain.

**Structure Completeness:** Complete 14-file project tree defined (8 .cob, 3 .cpy,
build.sh, README). All integration points and module boundaries established.

**Pattern Completeness:** 8 conflict points addressed with concrete MUST/MUST NOT
rules and code-level examples. All major anti-pattern categories covered.

### Gap Analysis Results

**Important Gap — Copybook Field Naming (not blocking, but must be resolved in Story 1):**
The architecture defines what data lives in each copybook but not the specific
COBOL field names (01-level, 05-level entries). Because all 8 modules share these
structures via COPY, field names are an architectural contract.

Resolution: Story 1 (copybook implementation) must define and lock canonical field
names for WS-DECK.cpy, WS-HANDS.cpy, and WS-GAME.cpy. All subsequent module
stories treat these names as immutable. No module story should begin before
Story 1 is complete and its copybook field names are documented.

**Nice-to-Have Gaps:**
- Bug algorithmic details: fully specified in PRD (source of truth, not duplicated here)
- CI/CD pipeline: not applicable for single-developer demo asset

### Architecture Completeness Checklist

**✅ Requirements Analysis**
- [x] Project context thoroughly analyzed
- [x] Scale and complexity assessed (Low — 8 modules, 3 copybooks, 1 build script)
- [x] Technical constraints identified (GnuCOBOL, Ubuntu, 80-column, COBOL 74-era)
- [x] Cross-cutting concerns mapped (tech debt distribution, bug-reliability tension)

**✅ Architectural Decisions**
- [x] Runtime and toolchain fully specified (GnuCOBOL 3.2, cobc, build.sh)
- [x] Module decomposition complete (8 named .cob files with FR ownership)
- [x] Data architecture defined (3 functional copybooks, BY REFERENCE calling)
- [x] Build strategy specified (separate compile + link, no error checking)

**✅ Implementation Patterns**
- [x] Naming conventions established (WS-XX-Y variables, PROC-A paragraphs)
- [x] Structure patterns defined (no SECTIONS, GOTO required, flat paragraphs)
- [x] Communication patterns specified (BY REFERENCE, no return code checks)
- [x] Process patterns documented (GOTO, nested IF, wrong comments, bug rules)

**✅ Project Structure**
- [x] Complete directory structure defined (src/, copy/, root files)
- [x] Component boundaries established (orchestrator + leaf model)
- [x] Integration points mapped (data flow through one game round)
- [x] All 32 FRs mapped to specific files

### Architecture Readiness Assessment

**Overall Status:** READY FOR IMPLEMENTATION

**Confidence Level:** High

**Key Strengths:**
- Every FR has a named home — no implementation ambiguity about where code lives
- Inverted quality model is explicitly enforced — agents cannot accidentally write clean code
- Bug-reliability tension is explicitly addressed — bugs that crash the game are failures
- Copybook boundary is the only remaining gap, and its resolution is the natural first story

**Areas for Future Enhancement:**
- Demo walkthrough guide (Phase 2 per PRD) — which bugs to highlight, suggested narration
- Side-by-side presentation materials pairing legacy with modernized version (Phase 2)

### Implementation Handoff

**AI Agent Guidelines:**
- Follow all architectural decisions exactly as documented
- Use implementation patterns consistently — the MUST/MUST NOT rules are binding
- Do not begin any module story before Story 1 (copybooks) is complete
- Refer to this document for all architectural questions before making decisions

**First Implementation Priority:**
```bash
mkdir -p cobol-blackjack/src cobol-blackjack/copy
touch cobol-blackjack/build.sh && chmod +x cobol-blackjack/build.sh
# Then: implement WS-DECK.cpy, WS-HANDS.cpy, WS-GAME.cpy with canonical field names
# Lock those field names before any .cob module work begins
```
