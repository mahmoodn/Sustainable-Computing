#!/bin/bash
su
echo "min_granularity_ns" > defaults.txt
cat /sys/kernel/debug/sched/min_granularity_ns >> defaults.txt
echo "wakeup_granularity_ns" >> defaults.txt
cat /sys/kernel/debug/sched/wakeup_granularity_ns >> defaults.txt
echo "latency_ns" >> defaults.txt
cat /sys/kernel/debug/sched/latency_ns >> defaults.txt
uname -r >> defaults.txt
chmod 444 defaults.txt
exit


gcc -O3 -fsplit-stack -fopenmp -o mm_double_omp mm_double_omp.c
THREADS=16
STRESS_SECONDS=150s
EVENTS="power/energy-pkg/,instructions,cycles,context-switches,cpu-migrations,page-faults"

perf stat -o idle_baseline.txt -a -e $EVENTS -- ./mm_double_omp $THREADS

stress --cpu $THREADS --timeout $STRESS_SECONDS &
perf stat -o cpu_busy.txt -a -e $EVENTS -- ./mm_double_omp $THREADS
perf stat -o cpu_busy_f1.txt -a -e $EVENTS -- sudo chrt -f 1 ./mm_double_omp $THREADS
perf stat -o cpu_busy_f50.txt -a -e $EVENTS -- sudo chrt -f 50 ./mm_double_omp $THREADS
perf stat -o cpu_busy_f99.txt -a -e $EVENTS -- sudo chrt -f 99 ./mm_double_omp $THREADS
perf stat -o cpu_busy_r1.txt -a -e $EVENTS -- sudo chrt -r 1 ./mm_double_omp $THREADS
perf stat -o cpu_busy_r50.txt -a -e $EVENTS -- sudo chrt -r 50 ./mm_double_omp $THREADS
perf stat -o cpu_busy_r99.txt -a -e $EVENTS -- sudo chrt -r 99 ./mm_double_omp $THREADS
