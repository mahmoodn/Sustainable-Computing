#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>
#include <sys/time.h>
#include <signal.h>
#include <unistd.h>
#include <sched.h>

#define N 3000

void multiplyMatrices(double first[][N], double second[][N], double result[][N]) 
{
    // Multiplying first and second matrices and storing it in result
    int i,j,k;
        #pragma omp parallel for 
        for (i = 0; i < N; ++i) {
          for (j = 0; j < N; ++j) {
             for (k = 0; k < N; ++k) {
                result[i][j] += first[i][k] * second[k][j];
             }
          }
        }
}

void fill_matrices(double first[][N], double second[][N], double result[][N]) 
{
    srand(time(NULL)); // randomize seed
    for (int i = 0; i < N; i++){
        for (int j = 0; j < N; j++){
            first[i][j] = rand() % 10;
            second[i][j] = rand() % 10;
            result[i][j] = 0;
        }
    }
}
void print(double first[][N], double second[][N], double result[][N]) 
{
    srand48(time(NULL)); // randomize seed
    printf("First:\n");
    for (int i = 0; i <  N; i++){
        printf("[ ");
        for (int j = 0; j < N; j++){
            printf("%f ", first[i][j]);
        }
        printf("]\n");
    }
    printf("\nSecond:\n");
    for (int i = 0; i <  N; i++){
        printf("[ ");
        for (int j = 0; j < N; j++){
            printf("%f ", second[i][j]);
        }
        printf("]\n");
    }
    printf("\nResult:\n");
    for (int i = 0; i <  N; i++){
        printf("[ ");
        for (int j = 0; j < N; j++){
            printf("%f ", result[i][j]);
        }
        printf("]\n");
    }	
}

int modify_policy()
{
    int pid_num = getpid();
    printf("PID = %d -> ", pid_num);
    int policy = sched_getscheduler(pid_num);
    switch(policy) {
        case SCHED_OTHER: printf("SCHED_OTHER -> "); break;
        case SCHED_RR:   printf("SCHED_RR -> "); break;
        case SCHED_FIFO:  printf("SCHED_FIFO -> "); break;
        default:   printf("Unknown... -> ");
    }
    struct sched_param sp = { .sched_priority = 99 };
    int ret = sched_setscheduler(pid_num, SCHED_RR, &sp);
    if (ret == -1) {
        printf("sched_setscheduler failed!\n");
        exit(1);
    }
    policy = sched_getscheduler(pid_num);
    switch(policy) {
        case SCHED_OTHER: printf("SCHED_OTHER\n"); break;
        case SCHED_RR:   printf("SCHED_RR\n"); break;
        case SCHED_FIFO:  printf("SCHED_FIFO\n"); break;
        default:   printf("Unknown...\n");
    }
}    
int main(int argc, char *argv[])
{
    int max_thread = omp_get_num_procs();
    int nthread;
    char *p;
    //char cmdbuf[256];
    //int m = modify_policy();
    //kill(pid_num, SIGSTOP);
    //snprintf(cmdbuf, sizeof(cmdbuf), "cp /proc/%d/status %s", pid_num, "start.txt" );
    //system(cmdbuf);
    if (argc == 1) {
        printf("No nthread, assumig %d threads\n", max_thread);
        nthread = max_thread;
    } else {
        nthread = strtol(argv[1], &p, 10);
        if (nthread > max_thread) {
            printf("Using %d threads\n", max_thread);
            nthread = max_thread;
        } else
            printf("Using %d threads\n", nthread);
    }        
    double start1, start2, stop1, stop2, execution_time1, execution_time2;
    omp_set_num_threads(nthread);
    static double first[N][N], second[N][N], result[N][N];
    
    start1 = omp_get_wtime();
    fill_matrices(first, second, result);
    stop1 = omp_get_wtime();


    start2 = omp_get_wtime();
    multiplyMatrices(first, second, result);
        stop2 = omp_get_wtime();

    execution_time1 = stop2 - start1;
    execution_time2 = stop2 - start2;
    //print(first, second, result);
    printf("Total execution Time in seconds: %.10lf\n", execution_time1 );
    printf("MM execution Time in seconds: %.10lf\n", execution_time2 );
    //snprintf(cmdbuf, sizeof(cmdbuf), "cp /proc/%d/status %s", pid_num, "finish.txt" );
    //system(cmdbuf);
    return 0;
}

