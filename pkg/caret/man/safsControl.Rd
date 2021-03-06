\name{safsControl}
\alias{safsControl}
\alias{gafsControl}
\title{Control parameters for GA and SA feature selection}
\description{
Control the computational nuances of the \code{\link{gafs}} and \code{\link{safs}} functions
}
\usage{
gafsControl(functions = NULL, 
            method = "repeatedcv", 
            metric = NULL, 
            maximize = NULL, 
            number = ifelse(grepl("cv", method), 10, 25),
            repeats = ifelse(grepl("cv", method), 1, 5),
            verbose = FALSE, 
            returnResamp = "final", 
            p = 0.75, 
            index = NULL, 
            indexOut = NULL,
            seeds = NULL, 
            holdout = 0, 
            genParallel = FALSE, 
            allowParallel = TRUE)

safsControl(functions = NULL, 
            method = "repeatedcv", 
            metric = NULL, 
            maximize = NULL, 
            number = ifelse(grepl("cv", method), 10, 25),
            repeats = ifelse(grepl("cv", method), 1, 5),
            verbose = FALSE, 
            returnResamp = "final", 
            p = 0.75, 
            index = NULL, 
            indexOut = NULL, 
            seeds = NULL, 
            holdout = 0, 
            improve = Inf, 
            allowParallel = TRUE)
}

\arguments{
  \item{functions}{a list of functions for model fitting, prediction etc (see Details below)}
  \item{method}{The resampling method: \code{boot}, \code{boot632}, \code{cv}, \code{repeatedcv},
    \code{LOOCV},  \code{LGOCV} (for repeated training/test splits)}
  \item{metric}{a two-element string that specifies what summary metric will be used to select the optimal number of iterations from the external fitness value and which metric should guide subset selection. If specified, this vector should have names \code{"internal"} and \code{"external"}. See \code{\link{gafs}} and/or \code{\link{safs}} for explanations of the difference.}         
  \item{maximize}{a two-element logical: should the metrics be maximized or minimized? Like the \code{metric} argument, this this vector should have names \code{"internal"} and \code{"external"}.}
  \item{number}{Either the number of folds or number of resampling iterations}
  \item{repeats}{For repeated k-fold cross-validation only: the number of complete sets of folds to compute}
  \item{verbose}{a logical for printing results}
  \item{returnResamp}{A character string indicating how much of the resampled summary metrics should be saved. Values can be ``all'' or ``none''}   
  \item{p}{For leave-group out cross-validation: the training percentage}
  \item{index}{a list with elements for each resampling iteration. Each list element is the sample rows used for training at that iteration.}   
  \item{indexOut}{a list (the same length as \code{index}) that dictates which sample are held-out for each resample. If \code{NULL}, then the unique set of samples not contained in \code{index} is used.} 
  \item{seeds}{a vector or integers that can be used to set the seed during each search. The number of seeds must be equal to the number of resamples plus one. }
  \item{holdout}{the proportion of data in [0, 1) to be held-back from \code{x} and \code{y} to calculate the internal fitness values}
  \item{improve}{the number of iterations without improvement before \code{\link{safs}} reverts back to the previous optimal subset}
  \item{genParallel}{if a parallel backend is loaded and available, should \code{\link{gafs}} use it tp parallelize the fitness calculations within a generation within a resample?}
  \item{allowParallel}{if a parallel backend is loaded and available, should the function use it?}
}
\details{
Many of these options are the same as those described for  \code{\link[caret]{trainControl}}. More extensive documentation and examples can be found on the \pkg{caret} website at \url{http://topepo.github.io/caret/GA.html#syntax} and \url{http://topepo.github.io/caret/SA.html#syntax}.

The \code{functions} component contains the information about how the model should be fit and summarized. It also contains the elements needed for the GA and SA modules (e.g. cross-over, etc). 

The elements of \code{functions} that are the same for GAs and SAs are:
\itemize{
  \item \code{fit}, with arguments \code{x}, \code{y}, \code{lev}, \code{last}, and \code{...}, is used to fit the classification or regression model 
  \item \code{pred}, with arguments  \code{object} and \code{x}, predicts new samples                 
  \item \code{fitness_intern}, with arguments  \code{object}, \code{x}, \code{y}, \code{maximize}, and \code{p}, summarizes performance for the internal estimates of fitness
  \item \code{fitness_extern}, with arguments  \code{data}, \code{lev}, and \code{model}, summarizes performance using the externally held-out samples
  \item \code{selectIter}, with arguments  \code{x}, \code{metric}, and \code{maximize}, determines the best search iteration for feature selection.  
  }

 The elements of \code{functions} specific to genetic algorithms are: 
\itemize{
  \item \code{initial}, with arguments \code{vars}, \code{popSize} and \code{...}, creates an initial population.
  \item \code{selection}, with arguments \code{population}, \code{fitness}, \code{r}, \code{q}, and \code{...}, conducts selection of individuals. 
  \item \code{crossover}, with arguments \code{population}, \code{fitness}, \code{parents} and \code{...}, control genetic reproduction.
  \item \code{mutation}, with arguments \code{population}, \code{parent} and \code{...}, adds mutations.
  }

 The elements of \code{functions} specific to simulated annealing are: 
\itemize{
  \item \code{initial}, with arguments \code{vars}, \code{prob}, and \code{...}, creates the initial subset.
  \item \code{perturb}, with arguments \code{x}, \code{vars}, and \code{number}, makes incremental changes to the subsets.
  \item \code{prob}, with arguments \code{old}, \code{new}, and \code{iteration}, computes the acceptance probabilities
}

The pages \url{http://topepo.github.io/caret/GA.html} and \url{http://topepo.github.io/caret/SA.html} have more details about each of these functions. 

\code{holdout} can be used to hold out samples for computing the internal fitness value. Note that this is independent of the external resampling step. Suppose 10-fold CV is being used. Within a resampling iteration, \code{holdout} can be used to sample an additional proportion of the 90\% resampled data to use for estimating fitness. This may not be a good idea unless you have a very large training set and want to avoid an internal resampling procedure to estimate fitness. 

The search algorithms can be parallelized in several places: 
\enumerate{
  \item each externally resampled GA or SA can be run independently (controlled by the \code{allowParallel} options)
  \item within a GA, the fitness calculations at a particular generation can be run in parallel over the current set of individuals (see the \code{genParallel})
  \item if inner resampling is used, these can be run in parallel (controls depend on the function used. See, for example, \code{\link[caret]{trainControl}})
  \item any parallelization of the individual model fits. This is also specific to the modeling function. 
    } 

It is probably best to pick one of these areas for parallelization and the first is likely to produces the largest decrease in run-time since it is the least likely to incur multiple re-starting of the worker processes. Keep in mind that if multiple levels of parallelization occur, this can effect the number of workers and the amount of memory required exponentially. 
}
\value{An echo of the parameters specified}
\author{Max Kuhn}
\references{\url{http://topepo.github.io/caret/GA.html},
\url{http://topepo.github.io/caret/SA.html}}

\seealso{\code{\link{safs}}, \code{\link{safs}}, , \code{\link{caretGA}}, \code{\link{rfGA}}, \code{\link{treebagGA}}, \code{\link{caretSA}}, \code{\link{rfSA}}, \code{\link{treebagSA}}}

\keyword{utilities}

