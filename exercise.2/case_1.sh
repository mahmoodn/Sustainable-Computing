#!/bin/bash
gcc -O3 -fsplit-stack -fopenmp -o mm_double_omp mm_double_omp.c
THREADS=16            # Use lscpu to find max number of supported threads on CPU
STRESS_SECONDS=700s   # Use large value to cover all three commands
EVENTS="power/energy-pkg/,instructions,cycles,context-switches,cpu-migrations,page-faults"

# OMP on idle system
perf stat -o idle_baseline.txt -a -e $EVENTS -- ./mm_double_omp $THREADS

# launch stress in background
stress --cpu $THREADS --timeout $STRESS_SECONDS &

# Run OMP with three different priority values
perf stat -o cpu_busy_omp_df_priority.txt -a -e $EVENTS -- ./mm_double_omp $THREADS
perf stat -o cpu_busy_omp_lo_priority.txt -a -e $EVENTS -- nice -19 ./mm_double_omp $THREADS
perf stat -o cpu_busy_omp_hi_priority.txt -a -e $EVENTS -- sudo nice --20 ./mm_double_omp $THREADS

# If stress is still running, terminate it
pkill stress