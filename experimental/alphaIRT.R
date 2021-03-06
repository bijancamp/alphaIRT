alphaIRT <- function(pars, sample.size = 100, X = NULL, mean = 0, sd = 1, Maydeu.Olivares = FALSE) {
  #---------------------------------------------------------------#
  # alphaIRT
  # Bijan D. Camp
  # March 04, 2014
  #
  # Description:          : Predicts coefficient alpha from a set of
  #                         IRT parameters. If a data set X is
  #                         provided, then an estimate of the standard
  #                         error of sample coefficient alpha is also
  #                         computed. For now, only the dichotomous
  #                         three-parameter logistic model (3PLM) of
  #                         IRT parameters, and the normal
  #                         distribution with supplied mean and sd
  #                         values, are supported.
  #
  # Arguments:
  #       pars            : k x 3 matrix of item parameters for the
  #                         3PLM
  #       sample.size     : Number of examinees to simulate binary
  #                         responses for. Used in computing the
  #                         IRT-based standard error. Should be
  #                         at least 100.
  #       reps            : Number of coefficient alphas to generate (FINISH later)
  #       X               : N x k matrix of binary responses of N
  #                         examinees to k items
  #       mean            : Mean of the normal distribution of the
  #                         population of trait values
  #       sd              : Standard deviation of the normal
  #                         distribution of the population of trait
  #                         values
  #       Maydeu.Olivares : If TRUE, then compute the standard error
  #                         originally described by Maydeu-Olivares
  #                         and Coffman (2007). This computation
  #                         does not use IRT parameters.
  #
  # Returns:
  #       alpha           : Classical Cronbach's alpha coefficient
  #       alpha.IRT       : IRT-based sample coefficient alpha
  #       SE.IRT          : IRT-based standard error of sample
  #                         coefficient alpha
  #
  # References:
  #       Maydeu-Olivares, A. & Coffman, D. L. (2007).
  #             Asymptotically distribution-free (ADF) interval
  #             estimation of coefficient alpha. Psychological
  #             Methods, 12(2), 157–176.
  #             doi:10.1037/1082-989X.12.2.157
  #---------------------------------------------------------------#

    ## Test length
    num.items <- nrow(pars)

    ## Simulated response data
    X <- responses(pars, sample.size, num.items, mean, sd)

    ## Expected item scores in the population
    EX.item.scores <- apply(pars, 1, FUN = pItem, mean, sd)
    
    ## Vector of products of each combination of expected item scores for later use in
    ## computing the covariances between items
    EX.product.scores <- outer(EX.item.scores, EX.item.scores)
    
    ## Compute a symmetric matrix of expected joint item scores in the population
    A <- apply(expand.grid.unique(1:num.items, 1:num.items), 1, FUN = pItemJoint, pars, mean, sd)
    EX.joint.scores <- matrix(0, nrow = num.items, ncol = num.items)
    EX.joint.scores[upper.tri(EX.joint.scores)] <- A
    EX.joint.scores <- EX.joint.scores + t(EX.joint.scores)
    
    ## Compute the sample covariance matrix between items in the population
    S.IRT <- EX.joint.scores - EX.product.scores
    item.variances <- EX.item.scores * (1 - EX.item.scores)
    diag(S.IRT) <- item.variances
    item.sds <- (sqrt(item.variances) %*% t(sqrt(item.variances)))^(-1)
    R.IRT <- item.sds * S.IRT

    s <- lower.tri(S.IRT, diag = TRUE)
    
    ## IRT-based coefficient alpha
    alpha.IRT <- num.items/(num.items - 1) * (1 - sum(diag(S.IRT))/sum(S.IRT))
    
    if(!is.null(X)) {
        ## The means of the item scores across examinees
        item.means <- colMeans(X)

        ## Derivative of alpha with respect to the unique covariances
        Delta.IRT <- matrix(apply(expand.grid(1:num.items, 1:num.items), 1, FUN = alphaDerivative, pars, S.IRT), nrow = num.items, ncol = num.items)
        Delta.IRT <- Delta.IRT[row(Delta.IRT) >= col(Delta.IRT)]
        
        ## The squares used to compute the final standard error
        squares.IRT <- apply(X, 1, FUN = computeSquares, item.means, Delta.IRT, S.IRT)

        ## The IRT-based standard error of coefficient alpha
        SE.IRT <- sqrt(1/(nrow(X)*(nrow(X) - 1)) * sum(squares.IRT))

        ## Covariance matrix of covariances between item scores in the data set
        S.classical <- cov(X)
        
        ## Cronbach's alpha
        alpha <- num.items/(num.items - 1) * (1 - sum(diag(S.classical))/sum(S.classical))

        ## Also compute "better" squares without appeal to a data set
        ## better.squares <- betterSquares(Delta.IRT, S.IRT)
        ## better.squares <- (t(Delta.IRT) %*% (vech(R.IRT) - vech(S.IRT)))^2
        ## better.SE.IRT <- sqrt(1/(nrow(X)*(nrow(X) - 1)) * sum(better.squares))

        cov.S.IRT <- cov(vech(S.IRT), vech(S.IRT))

        better.SE.IRT <- 1/200 * Delta.IRT %*% cov

        ## If indicated, compute the classical counterparts to the IRT-based
        ## quantities using the formulas provided by Maydeu-Olivares and Coffman
        ## (2007).
        if (isTRUE(Maydeu.Olivares)) {
            Delta.Maydeu.Olivares <- matrix(apply(expand.grid(1:num.items, 1:num.items), 1, FUN = alphaDerivative, pars, S.classical), nrow = num.items, ncol = num.items)
            Delta.Maydeu.Olivares <- Delta.Maydeu.Olivares[row(Delta.Maydeu.Olivares) >= col(Delta.Maydeu.Olivares)]

            squares.Maydeu.Olivares <- apply(X, 1, FUN = computeSquares, item.means, Delta.Maydeu.Olivares, S.classical)

            SE.Maydeu.Olivares <- sqrt(1/(nrow(X)*(nrow(X) - 1)) * sum(squares.Maydeu.Olivares))
        }
    }

    ## Output
    if(is.null(X)) {
        list(alpha.IRT = signif(alpha.IRT, 3))
    } else if (!isTRUE(Maydeu.Olivares)) {
        list(alpha = signif(alpha, 3), alpha.IRT = signif(alpha.IRT, 3), SE.IRT = signif(SE.IRT, 3))
    } else {
        ## list(alpha = signif(alpha, 3), alpha.IRT = signif(alpha.IRT, 3), SE.IRT = signif(SE.IRT, 3), SE.Maydeu.Olivares = signif(SE.Maydeu.Olivares, 3))
        list(alpha = signif(alpha, 3), alpha.IRT = signif(alpha.IRT, 3), SE.IRT = signif(SE.IRT, 3), better.SE.IRT = signif(better.SE.IRT, 3), SE.Maydeu.Olivares = signif(SE.Maydeu.Olivares, 3))
    }
}

##~~~~~~~~~~~~~~~~~~~~~~Internal Functions~~~~~~~~~~~~~~~~~~~~~~##

## Integrand used to compute the expected item scores
integrandItem <- function(x, a, b, c, mean, sd) {
    (c + (1 - c)/(1 + exp(-1.7*a*(x - b)))) * 1/(sqrt(2*pi)*sd) * exp(-(x - mean)^2/(2*sd^2))
}

## Integrand used to compute the expected joint item scores
integrandItemJoint <- function(x, a, b, c, d, e, f, mean, sd) {
    (c + (1 - c)/(1 + exp(-1.7*a*(x - b)))) * (f + (1 - f)/(1 + exp(-1.7*d*(x - e)))) * 1/(sqrt(2*pi)*sd) * exp(-(x - mean)^2/(2*sd^2))
}

## Given parameters x = (a, b, c) of an item under a 3PLM, compute the expected
## proportion of correct responses to the item for a normal population
pItem <- function(x, mean, sd) {
    a <- x[1]
    b <- x[2]
    c <- x[3]
    
    integrate(integrandItem, lower = Inf, upper = Inf, a, b, c, mean, sd)$value
}

## Given two sets of parameters (a, b, c) and (e, d, f) of two items under a 3PLM,
## compute the expected joint proportion of correct responses to the two items for a
## normal population
pItemJoint <- function(x, pars, mean, sd) {
    ## Parameters of first item
    a <- pars[x[1], 1]
    b <- pars[x[1], 2]
    c <- pars[x[1], 3]

    ## Parameters of second item
    d <- pars[x[2], 1]
    e <- pars[x[2], 2]
    f <- pars[x[2], 3]

    integrate(integrandItemJoint, lower = Inf, upper = Inf, a, b, c, d, e, f, mean, sd)$value
}

## Cartesian product of two sets without duplicate pairs or pairs with equal
## coordinates
expand.grid.unique <- function(x, y, include.equals = FALSE) {
    x <- unique(x)
    y <- unique(y)

    g <- function(i) {
        z <- setdiff(y, x[seq_len(i - include.equals)])

        if(length(z)) cbind(x[i], z, deparse.level = 0)
    }

    do.call(rbind, lapply(seq_along(x), g))
}

## The derivative vector of alpha with respect to the unique covariances between items
alphaDerivative <- function(x, pars, S) {
    num.items <- nrow(pars)
    
    if (x[1] == x[2]) {
        (-num.items)/(num.items - 1) * (sum(S) - sum(diag(S)))/(sum(S))^2
    } else {
        (2 * num.items)/(num.items - 1) * sum(diag(S))/(sum(S))^2
    }
}

## Computes the squares needed for the final computation of the standard error
computeSquares <- function(x, item.means, Delta, S) {
    cross.products <- (x - item.means) %*% t(x - item.means)
    cross.products <- cross.products[row(cross.products) >= col(cross.products)]
    (t(Delta) %*% (cross.products - vech(S)))^2
}

## Computes the squares needed for the final computation of the standard error
betterSquares <- function(Delta, S) {
    ## cross.products <- (x - item.means) %*% t(x - item.means)
    ## cross.products <- cross.products[row(cross.products) >= col(cross.products)]
    (t(Delta) %*% (vech(sqrt(S)) - vech(S)))^2
}

## Generates response matrix to compute the IRT-based standard error of alpha
responses <- function(pars, sample.size, num.items, mean, sd) {
    true.theta <- rnorm(sample.size, mean = mean, sd = sd)
    
    ghost <- matrix(0, nrow = sample.size, ncol = nrow(pars))

    for(i in 1:num.items){
        ghost[, i] <- pars[i, 3] + (1 - pars[i, 3])/(1 + exp(-1.7*pars[i, 1]*(true.theta - pars[i, 2])))
    }
    
    ifelse(ghost > runif(sample.size * num.items), 1, 0)
}
