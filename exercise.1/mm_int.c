#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 2096
void multiplyMatrices(int first[][N], int second[][N], int result[][N]) 
{
   // Multiplying first and second matrices and storing it in result
   for (int i = 0; i < N; ++i) {
      for (int j = 0; j < N; ++j) {
         for (int k = 0; k < N; ++k) {
            result[i][j] += first[i][k] * second[k][j];
         }
      }
   }
}

void fill_matrices(int first[][N], int second[][N], int result[][N]) 
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
void print(int first[][N], int second[][N], int result[][N]) 
{
	srand48(time(NULL)); // randomize seed
	printf("First:\n");
	for (int i = 0; i <  N; i++){
		printf("[ ");
		for (int j = 0; j < N; j++){
			printf("%d ", first[i][j]);
		}
		printf("]\n");
	}
	printf("\nSecond:\n");
	for (int i = 0; i <  N; i++){
		printf("[ ");
		for (int j = 0; j < N; j++){
			printf("%d ", second[i][j]);
		}
		printf("]\n");
	}
	printf("\nResult:\n");
	for (int i = 0; i <  N; i++){
		printf("[ ");
		for (int j = 0; j < N; j++){
			printf("%d ", result[i][j]);
		}
		printf("]\n");
	}	
}

int main()
{
	clock_t start1, start2, stop1, stop2; // declaration of ftype
	double execution_time1,execution_time2;

	static int first[N][N], second[N][N], result[N][N];
	
	start1 = clock();
	fill_matrices(first, second, result);
	stop1 = clock();
	
	
	start2 = clock();
	multiplyMatrices(first, second, result);
	stop2 = clock();

	execution_time2 = ((double) (stop2 - start2)) / CLOCKS_PER_SEC;
	execution_time1 = ((double) (stop2 - start1)) / CLOCKS_PER_SEC;
	//print(first, second, result);
	printf("Total execution Time in seconds: %.10lf\n", execution_time1 );
	printf("MM execution Time in seconds: %.10lf\n", execution_time2 );
	return 0;
}
