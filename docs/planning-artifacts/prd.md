---
stepsCompleted: [step-01-init, step-02-discovery, step-02b-vision, step-02c-executive-summary, step-03-success, step-04-journeys, step-05-domain, step-06-innovation, step-07-project-type, step-08-scoping, step-09-functional, step-10-nonfunctional, step-11-polish, step-12-complete]
workflowStatus: complete
inputDocuments:
  - docs/planning-artifacts/product-brief-cobol-blackjack-2026-02-26.md
documentCounts:
  briefs: 1
  research: 0
  brainstorming: 0
  projectDocs: 0
workflowType: 'prd'
classification:
  projectType: cli_tool
  domain: general
  complexity: low
  projectContext: greenfield
  notes: Mainframe terminal simulation running on GnuCOBOL/Ubuntu. Terminal experience must feel authentically mainframe to non-technical leaders who have never seen a mainframe.
---

# Product Requirements Document - cobol-blackjack

**Author:** Kamal
**Date:** 2026-02-26

## Executive Summary

cobol-blackjack is a legacy demo asset — a deliberately imperfect, multi-file COBOL Blackjack application running on a GnuCOBOL/Ubuntu mainframe sandbox. It is the "before" in a live before-and-after modernization showcase, built for a single user: Kamal, as demo presenter. The target audience is tech leaders and decision-makers who have never seen a mainframe — people who cannot connect with slide decks but need to viscerally understand what legacy systems look like, feel like, and why they need to change.

The problem is not technical — it is a sales and perception gap. Decision-makers delay or avoid modernization commitments because they cannot picture what is actually at stake. Abstract pitches do not create urgency. A live, running Blackjack game on a mainframe terminal does.

### What Makes This Special

Blackjack is a universal shortcut. Every leader in the room already knows the rules — they don't need to understand COBOL to follow the game. That familiarity eliminates the cognitive barrier between the audience and the demo. What they see is a terminal-based game running on what looks and feels like a real mainframe. What they are actually seeing is authentic 1980s-era code: cryptic naming, spaghetti logic, no structure, deliberate bugs, and decades of accumulated debt. The moment the modernized version is shown alongside it, the transformation is self-evident — no explanation required.

The core insight: **you can't sell what people can't picture.** This demo makes legacy reality tangible for any audience in minutes.

**Project Type:** CLI / Mainframe Terminal Application | **Domain:** Tech Demo / Sales Enablement | **Complexity:** Low | **Context:** Greenfield

## Success Criteria

### User Success

Kamal can walk into a client meeting, launch the application with a single command, and run a complete Blackjack game from start to finish without crashes, errors, or unexpected behavior. The terminal layout reads as authentically 1980s-era mainframe to an audience that has never seen one — the visual presentation alone signals "this is old." During the demo, Kamal can point to 4–5 distinct, visible examples of messiness in the codebase (cryptic names, spaghetti logic, dead code, deliberate bugs) without preparation.

### Business Success

Decision-makers who watch the demo leave the room understanding — viscerally, not abstractly — what a legacy mainframe system looks like and why modernization matters. The application anchors the modernization pitch as the credible "before," enabling the contrast with the modernized version to land without explanation.

### Technical Success

- Application compiles with zero errors on GnuCOBOL 3.1+ on Ubuntu
- Full game round (deal, hit/stand, dealer turn, outcome, play-again) completes without abnormal termination under all normal input paths
- All 6 deliberate bugs implemented and independently verifiable through targeted testing
- Launch-to-first-prompt under 5 seconds from single command
- Every source file contains authentic, identifiable technical debt
- Terminal visual presentation reads as 1980s mainframe to an untrained eye
- Minimum 4 distinct code messiness examples demonstrable without COBOL expertise

## Product Scope

### MVP — Minimum Viable Product

Complete delivery. No viable partial version exists — a game that crashes or looks polished defeats the purpose.

**Must-Have Capabilities:**
- Multi-file COBOL Blackjack application (8–14 source files) compiling on GnuCOBOL 3.1+/Ubuntu
- Full game loop: deal, hit/stand, dealer turn, outcome, play-again
- Authentic 1980s-era code style distributed across all files (cryptic naming, GOTO statements, no EVALUATE, sparse/incorrect comments, dead code)
- All 6 deliberate bugs implemented and verifiable
- Two proprietary middleware stubs (CASINO-AUDIT-LOG, LEGACY-RANDOM-GEN) compiling cleanly
- ASCII card display rendering in 80-column standard terminal
- Single `build.sh` script compiling and launching in one command
- README with compile/run instructions and known bugs list

**Resource Requirements:** Single developer with COBOL knowledge and GnuCOBOL/Ubuntu environment access.

### Phase 2 — Post-MVP

- Demo walkthrough guide (which bugs to highlight, which code sections to show, suggested narration)
- Side-by-side presentation materials pairing legacy with modernized version

### Phase 3 — Future Vision

- Modernized Java "after" application (separate project)
- Additional legacy application examples beyond Blackjack
- Documented modernization methodology

**Risk:** Terminal rendering consistency across machines — mitigated by targeting 80-column standard terminal only, no color dependency. Fallback: single-file COBOL Blackjack with basic tech debt is minimally viable for demo purposes.

## User Journeys

### Journey 1: Build and Verify (Kamal — Setup)

Kamal clones the repository onto a fresh Ubuntu machine. He runs the single build command. GnuCOBOL compiles all source files without errors. He launches the game, plays a full round — deal, hit, stand, dealer turn, outcome, play again — and everything runs cleanly. He walks the codebase, confirming all 6 deliberate bugs are present and locatable. The terminal layout looks right: the card display is clean, the prompts feel period-accurate, and nothing in the visual presentation breaks the 1980s mainframe illusion. The environment is ready to demo.

### Journey 2: Demo Day — Happy Path (Kamal — Presenting)

Kamal opens a terminal in front of a room of tech leaders. He types the launch command. The game appears in under 5 seconds — a text-based card table, cryptic prompts, exactly what a mainframe terminal looked like in 1983. He plays a round, narrating lightly. Then he pivots to the code: he pulls up 4–5 moments of deliberate messiness — a paragraph named PROC-A, a variable called WS-X1, a GOTO jump that goes nowhere obvious, a stub that silently does nothing. The room doesn't need to understand COBOL. They see chaos and they get it. The contrast with the modernized version, shown next, lands without a word of explanation.

### Journey 3: Demo Day — Edge Case (Kamal — Recovery)

Mid-demo, a leader asks Kamal to try something unexpected — enter a non-standard value at the hit/stand prompt, or play unusually fast. The no-input-validation bug means the game may behave oddly. Kamal uses it deliberately to demonstrate that bug. If the game reaches a broken state, he restarts with the single launch command in under 10 seconds. The demo continues without embarrassment.

### Journey 4: Audience Experience (Tech Leaders — Passive)

A CTO who has never touched a mainframe watches the demo. The terminal fills the screen. The text layout, prompts, and card rendering all read as old. She doesn't know what COBOL is, but she can follow the game. When Kamal points to the code and says "this variable is called WS-X1 and nobody on earth knows what it does," she laughs — because she's seen this pattern in her own organization. The problem becomes human. The modernization pitch clicks.

## Innovation & Novel Patterns

### Intentional Imperfection as a Design Principle

This project inverts the standard quality model: bugs are requirements, tech debt is a deliverable, and unmaintainability is a success criterion. Every design decision that would normally be a defect — cryptic naming, GOTO-driven flow, dead code, no input validation, biased algorithms — is a specified, verifiable feature. A developer who tried to "fix" this code would be breaking it.

Requirements are written to the anti-pattern, not away from it. Where conventional PRDs say "the system shall be maintainable," this PRD says "the system shall be demonstrably unmaintainable in specific, targeted ways."

### Validation Approach

The authenticity test is human, not automated. A non-technical observer should look at the running terminal and the code and immediately read "old, messy, hard to understand." If the messiness requires explanation to be visible, it has failed.

### Risk Mitigation

The primary risk is over-engineering the imperfection — bugs so subtle they're invisible, or code so cryptic it's unrunnable. Countermeasure: every bug must be independently verifiable, and the game loop must complete under normal input regardless of how messy the underlying code is.

## Terminal Application — Technical Context

cobol-blackjack is an interactive terminal application with a single entry point. Not scriptable, not configurable, not designed for automation. Its entire interface is the terminal session: text in, text out.

- **Command structure:** `build.sh` compiles and launches in sequence — one command, no manual steps between. Re-running recompiles from source each time for predictability.
- **Output:** All stdout via COBOL DISPLAY statements. ASCII card display (H/D/C/S suits), 80-column layout, no color dependency, readable on monochrome terminals.
- **Interaction:** Player responds to hit/stand prompts via keyboard (H/S). Input via COBOL ACCEPT. No mouse, no arrow keys, no special terminal sequences.
- **Dependencies:** GnuCOBOL 3.1+ standard libraries only. No external rendering libraries. Build script uses standard bash.

## Functional Requirements

### Game Engine

- **FR1:** The system can shuffle and deal from a standard 52-card deck
- **FR2:** The system can deal an initial two-card hand to the player and the dealer
- **FR3:** The player can choose to hit (receive an additional card) or stand (end their turn)
- **FR4:** The system can execute the dealer turn according to standard casino rules
- **FR5:** The system can calculate hand values with Ace counted as 1 or 11
- **FR6:** The system can determine and display the round outcome (player win, dealer win, push)
- **FR7:** The player can choose to play another round without restarting the application

### Build & Deployment

- **FR8:** Kamal can compile all source files with a single command on GnuCOBOL 3.1+/Ubuntu
- **FR9:** Kamal can launch the game immediately after compilation via the same single command
- **FR10:** The build process completes and the game reaches first player prompt within 5 seconds of command entry
- **FR11:** The build script runs without modification on a fresh Ubuntu installation with GnuCOBOL 3.1+ installed

### Terminal Display

- **FR12:** The system can display playing cards as ASCII representations in an 80-column terminal
- **FR13:** The system can display both player and dealer hands simultaneously during a round
- **FR14:** The system can display current hand values for player and dealer
- **FR15:** The system can display round outcome messages legible to a non-COBOL audience
- **FR16:** The system can prompt the player for hit/stand input in a manner consistent with 1980s terminal conventions

### Legacy Code Authenticity

- **FR17:** Each source file contains identifiable examples of 1980s-era code style (cryptic naming, GOTO statements, dead code, sparse/incorrect comments)
- **FR18:** The codebase contains a minimum of 4 distinct, pointable examples of messiness demonstrable during a live demo without COBOL expertise
- **FR19:** The overall project structure, file naming, and build process reflect 1980s mainframe development anti-patterns
- **FR20:** The running terminal output visually reads as an authentic 1980s mainframe application to a non-technical observer

### Deliberate Defects

- **FR21:** The deck management module contains a biased shuffle algorithm
- **FR22:** The dealer logic module contains a soft 17 rule violation
- **FR23:** The scoring module contains an Ace value recalculation failure when two Aces are held
- **FR24:** The main game module contains no input validation on the hit/stand prompt
- **FR25:** The deal module contains an off-by-one error in the deal array
- **FR26:** The deck module contains a dead code paragraph that is never called
- **FR27:** Each of the 6 deliberate bugs is independently verifiable through targeted testing without running the full game

### Middleware Stubs

- **FR28:** The system calls a CASINO-AUDIT-LOG stub that accepts parameters and performs no operation
- **FR29:** The system calls a LEGACY-RANDOM-GEN stub that returns a hardcoded value
- **FR30:** Both middleware stubs compile and link without errors as part of the standard build

### Documentation

- **FR31:** Kamal can read a README that provides step-by-step compile and run instructions
- **FR32:** Kamal can read a README that lists and describes all 6 known bugs with enough detail to locate them in the code

## Non-Functional Requirements

### Performance

- Application reaches first player prompt within 5 seconds of single launch command on standard Ubuntu machine
- Card display and game state render immediately upon each player action — no perceptible delay between input and output
- Play-again loop restarts a new round without recompilation or perceptible lag

### Reliability

- Game completes a full round (deal through play-again prompt) without abnormal termination under any normal input (H, S, or equivalent)
- FR24 (no input validation) defines the boundary of "normal input" — undefined behavior on unexpected input is a specified defect, not a reliability gap
- Application produces consistent, repeatable behavior across multiple consecutive runs on the same machine

### Compatibility

- All source files compile without errors or warnings on GnuCOBOL 3.1+ on Ubuntu 20.04 or later
- Terminal display renders correctly in any standard 80-column terminal emulator (gnome-terminal, xterm, tmux) without special configuration
- Build script requires no additional dependencies beyond GnuCOBOL and standard GNU utilities

### Intentional Un-maintainability

- Codebase scores "unmaintainable" against any standard code quality heuristic — cryptic naming, no modularity, non-linear flow, absent documentation
- Any code analysis tool (manual or automated) surfaces multiple, distinct quality issues on first inspection
- The quality bar is explicitly inverted: a clean, well-structured implementation constitutes a failure against this requirement
