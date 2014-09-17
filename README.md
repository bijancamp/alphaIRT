alphaIRT
========

R program for predicting coefficient alpha from a set of IRT parameters

#### Description
Predicts coefficient alpha from a set of IRT parameters. If a data set X is 
provided, then an estimate of the standard error of sample coefficient alpha is 
also computed. For now, only the dichotomous three-parameter logistic model 
(3PLM) of IRT parameters, and the normal distribution with supplied mean and sd 
values, are supported.

#### Usage
`alphaIRT(pars, X = NULL, mean = 0, sd = 1, MaydeuOlivares = FALSE)`

#### Arguments
`pars`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;k x 3 matrix of item parameters 
for the 3PLM  
`X`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N x k matrix of binary 
responses of N examinees to k items  
`mean`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mean of the normal distribution 
of the population of trait values  
`sd`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;standard deviation of the 
normal distribution of the population of trait values
`MaydeuOlivares`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If TRUE, then compute the 
standard error originally described by Maydeu-Olivares  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;and Coffman (2007). This 
computation does not use item parameters.

#### Value
Returns a list containing some or all of the following objects:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`alpha`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;classical Cronbach's alpha coefficient  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`alpha.IRT`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;IRT-based sample coefficient alpha  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`SE.IRT`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;IRT-based standard error of sample coefficient alpha  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`SE.MaydeuOlivares`  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;standard error originally described by Maydeu-Olivares and 
Coffman (2007)

#### References
Maydeu-Olivares, A. & Coffman, D. L. (2007). Asymptotically distribution-free 
(ADF) interval  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;estimation of coefficient alpha. *Psychological 
Methods*, *12*(2), 157–176.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;doi:10.1037/1082-989X.12.2.157
