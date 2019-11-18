#ifndef _NEURON_H_INCLUDED_
#define _NEURON_H_INCLUDED_

#include <stdint.h>
#include <stdlib.h>
#include <math.h>

#define  Delta(o, y)   ((float)o - (float)y)
#define  ERR_MAX       (0.001f)
          
void Init(float *Weights, int N)
{
    int i;
    
    for (i = 0; i < N + 1; i++)
    {
        Weights[i] = ((float)rand() / (float)RAND_MAX); 
    }                           
}

float GetOutput(float *Inputs, float *Weights, int N)
{
    float y = 0.0;
    int i;
        
    for (i = 0; i < N + 1; i++)
    {
        y += Inputs[i] * Weights[i];
    }    

    // activation function    
    y = tanh(y);
    
    return y;
}

void NewWeights(float *Weights, float *Inputs, float ni, float delta, int N)
{
    int i;
    
    for (i = 0; i < N + 1; i++)
    {
        Weights[i] += ni * delta * Inputs[i];   
    }    
}

#endif