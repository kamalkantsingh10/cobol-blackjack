#!/bin/bash
# EPIC 3 DEFECT VERIFICATION TEST SUITE
# Compiles each test harness against pre-built module objects and runs it.
# Run from project root: bash test/run-tests.sh
set -e

echo "--- COMPILING MODULES ---"
cobc -c -I copy/ src/bjack-deck.cob
cobc -c -I copy/ src/bjack-deal.cob
cobc -c -I copy/ src/bjack-score.cob
cobc -c -I copy/ src/bjack-dealer.cob
cobc -c -I copy/ src/legacy-random-gen.cob

echo ""
echo "=== T31: BIASED SHUFFLE VERIFICATION (STORY 3.1) ==="
cobc -x -I copy/ -o t31 test/t31-deck-bias.cob \
    bjack-deck.o legacy-random-gen.o
./t31

echo ""
echo "=== T32: OFF-BY-ONE DEAL VERIFICATION (STORY 3.2) ==="
cobc -x -I copy/ -o t32 test/t32-deal-obo.cob \
    bjack-deck.o bjack-deal.o legacy-random-gen.o
./t32

echo ""
echo "=== T33: ACE RECALCULATION FAILURE (STORY 3.3) ==="
cobc -x -I copy/ -o t33 test/t33-score-ace.cob \
    bjack-score.o
./t33

echo ""
echo "=== T34: SOFT 17 STAND BUG (STORY 3.4) ==="
cobc -x -I copy/ -o t34 test/t34-dealer-s17.cob \
    bjack-dealer.o
./t34

echo ""
echo "--- ALL DEFECT VERIFICATIONS COMPLETE ---"
