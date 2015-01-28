/**********************************************************************
*                                                                     *
*                                                                     *
*                          ALVINN Benchmark                           *
*                                                                     *
*                            written by                               *
*                          Dean Pomerleau                             *
*                                                                     *
*                          Aug. 28, 1989                              *
*                                                                     *
*                                                                     *
*                                                                     *
*                                                                     *
**********************************************************************/
              
#include <stdio.h>
#include <math.h>

#define NIU 1220
#define NHU 30
#define NOU 35
#define NUM_PATTERNS 30
#define NUM_EPOCHS   200
#define LRC 0.3
#define ALPHA 0.9

#define SIGMOID(arg)                (1.0 / (1.0 + exp((double)-arg)))

float	next_input[NUM_PATTERNS][(NIU + 1)]; 
float	next_output[NUM_PATTERNS][NOU]; 
float	i_h_weights[NHU][(NIU + 1)]; 
float   h_o_weights[NOU][NHU + 1]; 
float   h_o_w_ch_sum_array[NOU][(NHU + 1)]; 
float   i_h_w_ch_sum_array[NHU][(NIU + 1)]; 
float   hidden_delta[NHU+1]; 
float   i_h_lrc, h_o_lrc;

/**********************************************************
 initialize
**********************************************************/
initialize() {
   extern   float	i_h_weights[NHU][(NIU + 1)]; 
   extern   float	h_o_weights[NOU][(NHU + 1)]; 
   extern   float	i_h_w_ch_sum_array[NHU][(NIU + 1)]; 
   extern   float	h_o_w_ch_sum_array[NOU][(NHU + 1)]; 
   extern   float	next_input[NUM_PATTERNS][(NIU + 1)]; 
   extern   float	next_output[NUM_PATTERNS][NOU]; 
   int i, j, h, o, pattern; 
   FILE *fp, *fopen(); 

   fp = fopen("in_pats.txt", "r"); 

   for (pattern  =  0;  pattern  <  NUM_PATTERNS;  pattern++)
     for (i = 0; i < (NIU+1); i++) 
       fscanf(fp,"%f", &next_input[pattern][i]); 

   fp = fopen("out_pats.txt", "r"); 

   for (pattern = 0; pattern < NUM_PATTERNS; pattern++)
      for (o = 0; o < NOU; o++) 
        fscanf(fp,"%f", &next_output[pattern][o]); 

   fp = fopen("i_h_w.txt", "r"); 

   for (h = 0; h < NHU; h++)
      for (i = 0; i < (NIU+1); i++) 
        fscanf(fp,"%f", &i_h_weights[h][i]); 

   fp  =  fopen("h_o_w.txt", "r"); 

   for (h = 0; h < NOU; h++)
      for (i = 0; i < (NHU+1); i++) 
        fscanf(fp,"%f", &h_o_weights[h][i]); 

   for (i = 0; i < NHU; i++) 
     for (j = 0; j < (NIU+1); j++) 
       i_h_w_ch_sum_array[i][j] = 0.0; 

   for (i = 0; i < NOU; i++) 
     for (j = 0; j < (NHU+1); j++) 
       h_o_w_ch_sum_array[i][j] = 0.0; 

   i_h_lrc = LRC / NIU;
   h_o_lrc = LRC / NHU;
}



/**********************************************************
 input_hidden
**********************************************************/
input_hidden(input_act, hidden_act)
     float input_act[NIU + 1]; 
     float hidden_act[NHU + 1]; 
{
  extern float i_h_weights[NHU][(NIU + 1)]; 
  register float *receiver, *weight, *sender, *end_sender;
  float *end_receiver;
  
  receiver = &hidden_act[0];
  end_receiver = &hidden_act[NHU - 1];
  weight = &i_h_weights[0][0];
  
  for ( ; receiver <= end_receiver; ) {
    *receiver = 0.0;
    sender = &input_act[0];
    end_sender= &input_act[NIU];
    for (; sender <= end_sender; )
      *receiver += (*sender++) * (*weight++);
    *receiver = SIGMOID(*receiver);
    *receiver++;
  }
  hidden_act[NHU] = 1.0;
}


/**********************************************************
 hidden_output
**********************************************************/
hidden_output(hidden_act, output_act)
     float   output_act[NOU]; 
     float   hidden_act[NHU + 1]; 
{
  extern float h_o_weights[NOU][(NHU + 1)]; 
  register float *receiver, *weight, *sender, *end_sender;
  float *end_receiver;
  
  receiver = &output_act[0];
  end_receiver = &output_act[NOU - 1];
  weight = &h_o_weights[0][0];
  
  for ( ; receiver <= end_receiver; ) {
    *receiver = 0.0;
    sender = &hidden_act[0];
    end_sender= &hidden_act[NHU];
    for (; sender <= end_sender; )
      *receiver += (*sender++) * (*weight++);
    *receiver = SIGMOID(*receiver);
    *receiver++;
  }
}


/**********************************************************
 output_hidden
**********************************************************/
output_hidden(teach, output_act, hidden_act)
     float teach[NOU]; 
     float output_act[NOU]; 
     float hidden_act[NHU+1]; 
{
  extern float h_o_weights[NOU][(NHU + 1)]; 
  extern float h_o_w_ch_sum_array[NOU][(NHU + 1)]; 
  extern float hidden_delta[(NHU + 1)]; 
  register int hu, ou; 
  float delta[NOU], psum_array[NHU+1]; 

  for (hu = 0; hu < (NHU+1); hu++) 
    psum_array[hu] = 0.0; 
  for (ou = 0; ou < NOU; ou++) {
    delta[ou] = (teach[ou] - output_act[ou]) * output_act[ou] * (1.0 - output_act[ou]); 
    for (hu = 0; hu < (NHU+1); hu++) {
      psum_array[hu] += delta[ou] * h_o_weights[ou][hu]; 
      h_o_w_ch_sum_array[ou][hu] += delta[ou] * hidden_act[hu];
    }
  }
  for (hu = 0; hu < (NHU+1); hu++)
    hidden_delta[hu] = hidden_act[hu] * (1.0 - hidden_act[hu]) * psum_array[hu];
}


/**********************************************************
 hidden_input
**********************************************************/
hidden_input(input_act)
     float input_act[NIU+1]; 
{
  extern float i_h_weights[NHU][NIU+1]; 
  extern float h_o_w_ch_sum_array[NOU][(NHU + 1)]; 
  extern float hidden_delta[NHU+1]; 
  register float *w_ch, *delta, *sender, *end_sender;
  float *end_delta;

  delta = &hidden_delta[0];
  end_delta = &hidden_delta[NHU - 1];
  w_ch = &i_h_w_ch_sum_array[0][0];

  for ( ; delta <= end_delta; ) {
    sender = &input_act[0];
    end_sender = &input_act[NIU];
    for ( ; sender <= end_sender; )
      (*w_ch++) += (*delta) * (*sender++);
    delta++;
  }
}


/**********************************************************
 update_stats
**********************************************************/
update_stats(teach, output_act, error) 
   float teach[NOU], output_act[NOU];
   float *error;
{
   int ou;

   for (ou = 0; ou < NOU; ou++)
     *error += (teach[ou] - output_act[ou]) *
               (teach[ou] - output_act[ou]);
}


/**********************************************************
 update_weights
**********************************************************/
update_weights() {

   register int iu, hu;
   int ou;
   extern float i_h_weights[NHU][NIU+1]; 
   extern float i_h_w_ch_sum_array[NHU][NIU+1]; 
   extern float h_o_w_ch_sum_array[NOU][(NHU + 1)]; 
   extern float h_o_weights[NOU][(NHU + 1)]; 

   for (iu = 0; iu < NIU + 1; iu++)
     for (hu = 0; hu < NHU; hu++) {
       i_h_weights[hu][iu] += i_h_w_ch_sum_array[hu][iu] * i_h_lrc;
       i_h_w_ch_sum_array[hu][iu] *= ALPHA;
   }
   
     for (hu = 0; hu < NHU + 1; hu++)
       for (ou = 0; ou < NOU; ou++) {
         h_o_weights[ou][hu] += h_o_w_ch_sum_array[ou][hu] * h_o_lrc;
         h_o_w_ch_sum_array[ou][hu] *= ALPHA;
       }
}


     
/**********************************************************
 main
**********************************************************/
main() {
   extern float next_input[NUM_PATTERNS][(NIU + 1)]; 
   extern float next_output[NUM_PATTERNS][NOU]; 
   int i, hu, o, pattern, epoch; 
   float error;
   float hidden_act[NHU + 1], output_act[NOU]; 
   float result_array[NUM_PATTERNS][NOU]; 

   printf("initializing backprop parameters\n");
   initialize(); 

   printf("starting training\n");
   for (epoch = 0; epoch < NUM_EPOCHS; epoch++) {
     error = 0.0;
     for (pattern = 0; pattern < NUM_PATTERNS; pattern++) {
       input_hidden(next_input[pattern], hidden_act); 
       hidden_output(hidden_act, output_act);

       update_stats(next_output[pattern], output_act, &error);

       output_hidden(next_output[pattern], output_act, hidden_act); 
       hidden_input(next_input[pattern]); 
     }
     update_weights();

     printf("EPOCH NUMBER %d: ERROR = %.5f\n", epoch+1,
                                               error / (NUM_PATTERNS * NOU));
   }
}

