#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>

__global__ void matrixmul(int *a, int *b, int *c, int r1, int c1, int c2)
{
	int c_id = threadIdx.x%r1; 
	for(int i = 0; i < r1; i++)
	{
		for(int j = 0; j < c1; j++)
			c[i*c2 + c_id] = c[i*c2 + c_id] + a[i*c1 + j]*b[j*c2 + i];
	}
}

int main()
{
	int r1, c1, c2; 
	printf("Enter row dim of A: ");
	scanf("%d", &r1); 
	printf("Enter col dim of A/row dim of B: "); 
	scanf("%d", &c1); 
	printf("Enter col dim of second matrix: "); 
	scanf("%d", &c2); 
	int a[r1][c1], b[c1][c2], c[r1][c2]; 
	printf("Enter elements in A: "); 
	for(int i = 0; i < r1; i++)
		for(int j = 0; j < c1; j++)
			scanf("%d", &a[i][j]);  
	printf("Enter elements in B: "); 
	for(int i = 0; i < c1; i++)
		for(int j = 0; j < c2; j++)
			scanf("%d", &b[i][j]); 
	int *d_a, *d_b, *d_c; 
	cudaMalloc((void**)&d_a, sizeof(int)*r1*c1);
	cudaMalloc((void**)&d_b, sizeof(int)*c1*c2);
	cudaMalloc((void**)&d_c, sizeof(int)*r1*c2); 
 	cudaMemcpy(d_a, a, sizeof(int)*r1*c1, cudaMemcpyHostToDevice);
 	cudaMemcpy(d_b, b, sizeof(int)*c1*c2, cudaMemcpyHostToDevice);
 	matrixmul<<<1, c2>>>(d_a, d_b, d_c, r1, c1, c2); 
 	cudaMemcpy(c, d_c, sizeof(int)*r1*c2, cudaMemcpyDeviceToHost);
 	printf("The modified matrix is:\n"); 
	for(int i = 0; i < r1; i++)
		{
			for(int j = 0; j < c2; j++)
				printf("%d\t", c[i][j]); 
			printf("\n"); 
		}  

}