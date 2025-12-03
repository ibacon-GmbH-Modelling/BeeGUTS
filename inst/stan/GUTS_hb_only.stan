/* Code adapted from Virgile Baudrot
https://github.com/virgile-baudrot/gutsRstan */

#include /include/license.stan

functions {

#include /include/common_stan_functions.stan
}
data {

int <lower=1> nDatasets;

// Number of groups
int<lower=1> nGroup; // Number of groups (one group is combination of one dataset and one treatment)
array[nGroup] int groupDataset; // Corresponding dataset for each group

// Survivors
int<lower=1> nData_Nsurv; // number of group: 4
array[nData_Nsurv] int Nsurv;
array[nData_Nsurv] int Nprec;
array[nData_Nsurv] real tNsurv; // time of Nbr survival

array[nGroup] int<lower=1> idS_lw; // e.g. 1 6 12 18
array[nGroup] int<lower=1> idS_up; // e.g. 6 12 18 24

// PRIORS
real hbMean_log10;
real hbSD_log10;
}
transformed data{

//  array[nData_Nsurv] real tNsurv_ode; // time of Nbr survival to include in the ode !
//  for(gr in 1:nGroup){
//    tNsurv_ode[idS_lw[gr]:idS_up[gr]] = tNsurv[idS_lw[gr]:idS_up[gr]];
//    tNsurv_ode[idS_lw[gr]] = tNsurv[idS_lw[gr]] + 1e-9 ; // to start ode integrator at 0
//  }

}
parameters {

  array[nDatasets] real sigma;

}
transformed parameters{

  array[nDatasets] real hb_log10;
  real<lower=0> param; //

  vector<lower=0, upper=1>[nData_Nsurv] Psurv_hat;
  vector<lower=0, upper=1>[nData_Nsurv] Conditional_Psurv_hat;

  for(i in  1:nDatasets){
    hb_log10[i]  = hbMean_log10 + hbSD_log10 * sigma[i];
  }

  for(gr in 1:nGroup){
      param = 10.0^hb_log10[groupDataset[gr]]; // hb
      print(param);
      print(tNsurv[idS_lw[gr]:idS_up[gr]]);
      Psurv_hat[idS_lw[gr]:idS_up[gr]] = exp( - param * to_vector(tNsurv[idS_lw[gr]:idS_up[gr]]));
      //Psurv_hat[idS_lw[gr]:idS_up[gr]] = to_vector(tNsurv_ode[idS_lw[gr]:idS_up[gr]]); //exp( - param * tNsurv_ode[idS_lw[gr]:idS_up[gr]]);

      for(i in idS_lw[gr]:idS_up[gr]){
        Conditional_Psurv_hat[i] =  i == idS_lw[gr] ? Psurv_hat[i] : Psurv_hat[i] / Psurv_hat[i-1] ;
      }
  }
}
model {

  target += normal_lpdf(sigma | 0, 1);

    for(gr in 1:nGroup){

    target += binomial_lpmf(Nsurv[idS_lw[gr]:idS_up[gr]] | Nprec[idS_lw[gr]:idS_up[gr]], Conditional_Psurv_hat[idS_lw[gr]:idS_up[gr]]);

    // Nsurv[idS_lw[gr]:idS_up[gr]] ~ binomial( Nprec[idS_lw[gr]:idS_up[gr]], Conditional_Psurv_hat[idS_lw[gr]:idS_up[gr]]);

  }
}
generated quantities {

#include /include/gen_quantities_guts.stan
}

