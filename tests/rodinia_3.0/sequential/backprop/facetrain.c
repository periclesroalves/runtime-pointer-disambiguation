#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "backprop.h"

extern char *strcpy();
extern void exit();

int layer_size = 0;

backprop_face()
{
  BPNN *net;
  int i;
  float out_err, hid_err;
  net = bpnn_create(layer_size, 16, 1); // (16, 1 can not be changed)
  load(net);
  //entering the training kernel, only one iteration
  bpnn_train_kernel(net, &out_err, &hid_err);
  bpnn_free(net);
}

int setup(argc, argv)
int argc;
char *argv[];
{
  if(argc!=2){
  fprintf(stderr, "usage: backprop <num of input elements>\n");
  exit(0);
  }

  layer_size = atoi(argv[1]);
  
  int seed;

  seed = 7;   
  bpnn_initialize(seed);
  backprop_face();

  exit(0);
}
