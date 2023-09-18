#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>


__global__ void rgbToGray(int *r, int *b, int *g, int * gray, int col_size)
{
	int id = threadIdx.x; 
	gray[id] = (r[id] + g[id] + b[id])/3; 
}


int main()
{
	int x, y;
	printf("Enter x dimension: ");
	scanf("%d", &x); 
	printf("Enter y dimension: "); 
	scanf("%d", &y); 
	int r_img[x][y], b_img[x][y], g_img[x][y], gray[x][y];
	printf("Enter image matrix for R channel: ");
	for(int i = 0; i < x; i++)
		for(int j = 0; j < y; j++)
			scanf("%d", &r_img[i][j]);  
	printf("Enter image matrix for G channel: ");
	for(int i = 0; i < x; i++)
		for(int j = 0; j < y; j++)
			scanf("%d", &g_img[i][j]); 
	printf("Enter image matrix for B channel: ");
	for(int i = 0; i < x; i++)
		for(int j = 0; j < y; j++)
			scanf("%d", &b_img[i][j]);   
	int *d_r_img, *d_b_img, *d_g_img, *d_gray; 
	int size = x*y*sizeof(int); 
	cudaMalloc((void**)&d_r_img, size);
	cudaMalloc((void**)&d_b_img, size);
	cudaMalloc((void**)&d_g_img, size);
	cudaMalloc((void**)&d_gray, size); 
	cudaMemcpy(d_r_img, r_img, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b_img, b_img, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_g_img, g_img, size, cudaMemcpyHostToDevice);
	rgbToGray<<<1, x*y>>>(d_r_img, d_b_img, d_g_img, d_gray, y);
	cudaMemcpy(gray, d_gray, size, cudaMemcpyDeviceToHost); 
	printf("The grayscaled version of the image is:\n"); 
	for(int i = 0; i < x; i++)
		{
			for(int j = 0; j < y; j++)
				printf("%d\t", gray[i][j]); 
			printf("\n"); 
		}
}

