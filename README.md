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
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean of the normal distribution 
of the population of trait values  
`sd`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Standard deviation of the 
normal distribution of the population of trait values
`MaydeuOlivares`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If TRUE, then compute the 
standard error originally described by Maydeu-Olivares and Coffman (2007). This 
computation does not use item parameters.

#### Returns
Returns some or all of the following objects:
`alpha`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Classical Cronbach's alpha 
coefficient  
`alpha.IRT`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IRT-based sample coefficient 
alpha  
`SE.IRT`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IRT-based standard error of
sample coefficient alpha
`SE.MaydeuOlivares`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Standard error originally 
described by Maydeu-Olivares and Coffman (2007)

#### References
Maydeu-Olivares, A. & Coffman, D. L. (2007). Asymptotically distribution-free 
(ADF) interval estimation of coefficient alpha. *Psychological Methods*, *12*(2), 
157–176. doi:10.1037/1082-989X.12.2.157
