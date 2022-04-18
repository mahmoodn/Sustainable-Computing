#!/bin/bash

# Write the existing value in a file
sudo -u root bash << 'EOF'
FILE="default.txt"
if [ ! -e "$FILE" ]; then
    cat /sys/kernel/debug/sched/latency_ns >> $FILE
    chmod 444 $FILE
fi
EOF


gcc -O3 -fsplit-stack -fopenmp -o mm_double_omp mm_double_omp.c
THREADS=16            # Use lscpu to find max number of supported threads on CPU
STRESS_SECONDS=400s   # Use large value to cover all three commands
EVENTS="power/energy-pkg/,instructions,cycles,context-switches,cpu-migrations,page-faults"

echo "Baseline"
perf stat -o idle_baseline.txt -a -e $EVENTS -- ./mm_double_omp $THREADS

# Default is 24M
echo "Default"
stress --cpu $THREADS --timeout $STRESS_SECONDS &
perf stat -o cpu_busy_lat_df1.txt -a -e $EVENTS -- ./mm_double_omp $THREADS
perf stat -o cpu_busy_lat_df2.txt -a -e $EVENTS -- ./mm_double_omp $THREADS
perf stat -o cpu_busy_lat_df3.txt -a -e $EVENTS -- ./mm_double_omp $THREADS

# Use low value
echo "1M"
sudo -u root bash << 'EOF'
echo 1000000 > /sys/kernel/debug/sched/latency_ns
EOF
perf stat -o cpu_busy_lat_1M1.txt -a -e $EVENTS -- ./mm_double_omp $THREADS
perf stat -o cpu_busy_lat_1M2.txt -a -e $EVENTS -- ./mm_double_omp $THREADS
perf stat -o cpu_busy_lat_1M3.txt -a -e $EVENTS -- ./mm_double_omp $THREADS

# Use high value
echo "100M"
sudo -u root bash << 'EOF'
echo 100000000 > /sys/kernel/debug/sched/latency_ns
EOF
perf stat -o cpu_busy_lat_100M1.txt -a -e $EVENTS -- ./mm_double_omp $THREADS
perf stat -o cpu_busy_lat_100M2.txt -a -e $EVENTS -- ./mm_double_omp $THREADS
perf stat -o cpu_busy_lat_100M3.txt -a -e $EVENTS -- ./mm_double_omp $THREADS

# If stress is still running, terminate it
pkill stress

# Set the parameter to the default value
sudo -u root bash << 'EOF'
cat default.txt > /sys/kernel/debug/sched/latency_ns
EOF