#!/bin/bash


# Default branch predictor
./sim-outorder -ptrace default.trc 10000:11000 \
  -fetch:ifqsize 1 -decode:width 1 -issue:width 1 -commit:width 1\
  ./SPEC2000/spec2000binaries/mcf00.peak.ev6 SPEC2000/spec2000args/mcf/mcf.lgred.in &&
./pipeview.pl default.trc >> default.result


# With always-not-taken branch predictor
./sim-outorder -ptrace bpred_not_taken.trc 10000:11000 \
  -fetch:ifqsize 1 -decode:width 1 -issue:width 1 -commit:width 1\
  -bpred nottaken \
  ./SPEC2000/spec2000binaries/mcf00.peak.ev6 SPEC2000/spec2000args/mcf/mcf.lgred.in &&
./pipeview.pl bpred_not_taken.trc >> bpred_not_taken.result
