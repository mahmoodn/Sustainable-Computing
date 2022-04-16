#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cblas.h>
#include <omp.h>

#define N 8192

int main()
{
    static double *first = NULL;
    static double *second = NULL;
    static double *result = NULL;
    if ( first == NULL ) first = (double *)malloc( N*N*sizeof( double ) );
    if ( second == NULL ) second = (double *)malloc( N*N*sizeof( double ) );
    if ( result == NULL ) result = (double *)malloc( N*N*sizeof( double ) );
    int i;
    srand(time(NULL));
    double start1, start2, stop1, stop2, execution_time1, execution_time2;
    
    start1 = omp_get_wtime();
    for (i = 0; i < (N*N); i++) {
        first[i] = (double)(rand() % 10);
        second[i] = (double)(rand() % 10);
        result[i] = 0.0;
    }
    stop1 = omp_get_wtime();

    start2 = omp_get_wtime();
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, N,N,N, 1.0, first, N, second, N, 0.0, result, N);
    stop2 = omp_get_wtime();
    
    /*for (i = 0; i < (N*N); i++) {
        printf("%f ", first[i]);
    }
    printf("\n\n");
    for (i = 0; i < (N*N); i++) {
        printf("%f ", second[i]);
    }
    printf("\n\n");
    for (i = 0; i < (N*N); i++) {
        printf("%f ", result[i]);
    }
    printf("\n");*/
    execution_time1 = stop2 - start1;
    execution_time2 = stop2 - start2;
    printf("Total execution Time in seconds: %.10lf\n", execution_time1 );
	printf("MM execution Time in seconds: %.10lf\n", execution_time2 );
    
    free(first);
    free(second);
    free(result);
    return 0;
}

