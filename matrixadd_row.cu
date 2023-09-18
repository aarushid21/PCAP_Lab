#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

__global__ void add(int *a, int *b, int*c, int cols)
{
	int id = threadIdx.x; 
	for(int i = id*cols; i < id*cols + cols; i++)
		c[i] = a[i] + b[i]; 
}

int main()
{
	int x, y; 
	printf("Enter number of rows: "); 
	scanf("%d", &x); 
	printf("Enter the number of columns: "); 
	scanf("%d", &y); 
	int a[x][y], b[x][y], c[x][y]; 
	printf("Enter elements in a: "); 
	for(int i = 0; i < x; i++)
		for(int j = 0; j < y; j++)
			scanf("%d", &a[i][j]);
	printf("Enter elements in b: "); 
	for(int i = 0; i < x; i++)
		for(int j = 0; j < y; j++)
			scanf("%d", &b[i][j]);
	int *d_a, *d_b, *d_c; 
	int size = x*y*sizeof(int); 
	cudaMalloc((void**)&d_a, size); 
	cudaMalloc((void**)&d_b, size); 
	cudaMalloc((void**)&d_c, size); 
	cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice); 
	cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice); 
	add<<<1, x>>>(d_a, d_b, d_c, y);
	cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost); 
	printf("The modified matrix is:\n"); 
	for(int i = 0; i < x; i++)
		{
			for(int j = 0; j < y; j++)
				printf("%d\t", c[i][j]); 
			printf("\n"); 
		}  
}