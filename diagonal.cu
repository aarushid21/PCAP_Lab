#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>


__global__ void diagonalModify(int *a, int col_size)
{
	int id = threadIdx.x; 
	int c_id = id%col_size; 
	int r_id = id/col_size; 
	if(c_id == r_id)
		a[id] = 0; 
	else if(r_id < c_id)
	{
		int fac = 1; 
		for(int i = 2; i <= a[id]; i++)
			fac = fac*i; 
		a[id] = fac; 
	}
	else if(r_id > c_id)
	{
		int sum = 0; 
		int temp = a[id]; 
		while(temp!= 0)
		{
			sum = sum + temp%10; 
			temp = temp/10;
		}
		a[id] = sum; 
	}
}

int main()
{
	int x, y; 
	printf("Enter number of rows: "); 
	scanf("%d", &x); 
	printf("Enter the number of columns: "); 
	scanf("%d", &y); 
	int a[x][y]; 
	printf("Enter elements in a: "); 
	for(int i = 0; i < x; i++)
		for(int j = 0; j < y; j++)
			scanf("%d", &a[i][j]);
	int *d_a; 
	int size = x*y*sizeof(int); 
	cudaMalloc((void**)&d_a, size); 
	cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice); 
	diagonalModify<<<1, x*y>>>(d_a, y);
	cudaMemcpy(a, d_a, size, cudaMemcpyDeviceToHost); 
	printf("The modified matrix is:\n"); 
	for(int i = 0; i < x; i++)
		{
			for(int j = 0; j < y; j++)
				printf("%d\t", b[i][j]); 
			printf("\n"); 
		}  
}