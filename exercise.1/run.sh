#!/bin/bash
#EVENTS="power/energy-cores/,power/energy-pkg/,power/energy-ram/,instructions,cycles"   # Intel
EVENTS="power/energy-pkg/,instructions,cycles"   # AMD
echo "===== Running mm_int ====="
for i in {1..3}; do (perf stat -a -e $EVENTS ./mm_int); done
echo "===== Running mm_float ====="
for i in {1..3}; do (perf stat -a -e $EVENTS ./mm_float); done
echo "===== Running mm_double ====="
for i in {1..3}; do (perf stat -a -e $EVENTS ./mm_double); done
echo "===== Running mm_double_omp 2 ====="
for i in {1..3}; do (perf stat -a -e $EVENTS ./mm_double_omp 2); done
echo "===== Running mm_double_omp 4 ====="
for i in {1..3}; do (perf stat -a -e $EVENTS ./mm_double_omp 4); done
echo "===== Running mm_double_omp 6 ====="
for i in {1..3}; do (perf stat -a -e $EVENTS ./mm_double_omp 6); done
echo "===== Running mm_double_omp 8 ====="
for i in {1..3}; do (perf stat -a -e $EVENTS ./mm_double_omp 8); done
echo "===== Running mm_double_omp 12 ====="
for i in {1..3}; do (perf stat -a -e $EVENTS ./mm_double_omp 12); done
echo "===== Running mm_double_omp 16 ====="
for i in {1..3}; do (perf stat -a -e $EVENTS ./mm_double_omp 16); done
echo "===== Running mm_double_blas ====="
for i in {1..3}; do (perf stat -a -e $EVENTS ./mm_double_blas); done
echo "===== Running mm_py ====="
for i in {1..1}; do (perf stat -a -e $EVENTS python3 ./mm.py); done
echo "===== Running mm_np_py ====="
for i in {1..3}; do (perf stat -a -e $EVENTS python3 ./mm_np.py); done
