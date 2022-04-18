#!/bin/bash

gcc -O3 -fsplit-stack -fopenmp -o mm_double_omp mm_double_omp.c
THREADS=16           # Use lscpu to find max number of supported threads on CPU
STRESS_SECONDS=400s  # Use large value to cover all three commands
EVENTS="power/energy-pkg/,instructions,cycles,context-switches,cpu-migrations,page-faults"

# OMP on idle system
perf stat -o idle_baseline.txt -a -e $EVENTS -- ./mm_double_omp $THREADS

# launch stress in background
stress --cpu $THREADS --timeout $STRESS_SECONDS &
perf stat -o cpu_busy.txt -a -e $EVENTS -- ./mm_double_omp $THREADS
perf stat -o cpu_busy_f1.txt -a -e $EVENTS -- sudo chrt -f 1 ./mm_double_omp $THREADS
perf stat -o cpu_busy_f50.txt -a -e $EVENTS -- sudo chrt -f 50 ./mm_double_omp $THREADS
perf stat -o cpu_busy_f99.txt -a -e $EVENTS -- sudo chrt -f 99 ./mm_double_omp $THREADS
perf stat -o cpu_busy_r1.txt -a -e $EVENTS -- sudo chrt -r 1 ./mm_double_omp $THREADS
perf stat -o cpu_busy_r50.txt -a -e $EVENTS -- sudo chrt -r 50 ./mm_double_omp $THREADS
perf stat -o cpu_busy_r99.txt -a -e $EVENTS -- sudo chrt -r 99 ./mm_double_omp $THREADS

# If stress is still running, terminate it
pkill stress