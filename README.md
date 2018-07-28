alphaIRT
========

Predicts coefficient alpha from a set of IRT parameters

#### Description
Predicts coefficient alpha from a set of IRT parameters. If a data set `X` is provided, then an estimate of the standard error of sample coefficient alpha is also computed. For now, only the dichotomous three-parameter logistic model (3PLM) of IRT parameters, and the normal distribution with supplied mean and sd values, are supported.

#### Usage
`alphaIRT(pars, X = NULL, mean = 0, sd = 1, MaydeuOlivares = FALSE)`

#### Arguments
| Argument         | Description                                                                     |
| ---------------- |-------------------------------------------------------------------------------- |
| `pars`           | 𝑘 × 3 matrix of item parameters for the 3PLM                                    |
| `X`              | 𝑁 × 𝑘 matrix of binary responses of 𝑁 examinees to 𝑘 items                     |
| `mean`           | Mean of the normal distribution of the population of trait values               |
| `sd`             | Standard deviation of the normal distribution of the population of trait values |
| `MaydeuOlivares` | If `TRUE`, then compute the standard error originally described by Maydeu-Olivares and Coffman (2007). This computation does not use item parameters. |

#### Value
Returns a list containing some or all of the following objects:
* `alpha` — Classical Cronbach's alpha coefficient
* `alpha.IRT` — IRT-based sample coefficient alpha
* `SE.IRT` — IRT-based standard error of sample coefficient alpha
* `SE.MaydeuOlivares` — Standard error originally described by Maydeu-Olivares and Coffman (2007)

#### References
Maydeu-Olivares, A. & Coffman, D. L. (2007). Asymptotically distribution-free (ADF) interval estimation of coefficient alpha. *Psychological Methods*, *12*(2), 157–176. doi:10.1037/1082-989X.12.2.157
