#!/bin/bash
gcc -O3 -fsplit-stack -fopenmp -o mm_double_omp mm_double_omp.c
#./mm_double_omp 12
#PID=`pidof mm_double_omp`
#echo $PID
#chrt -p $PID
#sudo chrt -f -p 1 $PID
#chrt -p $PID
EVENTS="power/energy-cores/,power/energy-pkg/,power/energy-ram/,instructions,cycles,context-switches,cpu-migrations,page-faults"
#kill -SIGCONT $PID
perf stat -a -e $EVENTS -- sudo ./mm_double_omp 12

