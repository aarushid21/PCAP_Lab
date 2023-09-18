#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

__global__ void matrixModify(int *a, int *b, int col_size)
{
	int id = threadIdx.x; 
	if(id%2 == 0)
	{
		int replace = 0; 
		for(int i = 0; i < blockDim.x; i++)
		{
			if(i%col_size == id%col_size)
				replace = replace + a[i]; 
		}
		b[id] = replace; 
	}
	else 
	{
		int row = id/col_size; 
		int replace = 0; 
		for(int i = row*col_size; i <row*col_size + col_size; i++)
			replace = replace + a[i]; 
		b[id] = replace; 
	}
}

int main()
{
	int x, y; 
	printf("Enter number of rows: "); 
	scanf("%d", &x); 
	printf("Enter the number of columns: "); 
	scanf("%d", &y); 
	int a[x][y], b[x][y]; 
	printf("Enter elements in a: "); 
	for(int i = 0; i < x; i++)
		for(int j = 0; j < y; j++)
			scanf("%d", &a[i][j]);
	int *d_a, *d_b; 
	int size = x*y*sizeof(int); 
	cudaMalloc((void**)&d_a, size); 
	cudaMalloc((void**)&d_b, size); 
	cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice); 
	matrixModify<<<1, x*y>>>(d_a, d_b, y);
	cudaMemcpy(b, d_b, size, cudaMemcpyDeviceToHost); 
	printf("The modified matrix is:\n"); 
	for(int i = 0; i < x; i++)
		{
			for(int j = 0; j < y; j++)
				printf("%d\t", b[i][j]); 
			printf("\n"); 
		}  
}