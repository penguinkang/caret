\name{icr.formula}
\alias{icr.formula}
\alias{icr.default}
\alias{icr}
\alias{predict.icr}


\title{
Independent Component Regression
}
\description{
Fit a linear regression model using independent components
}
\usage{
\method{icr}{formula}(formula, data, weights, ..., subset, na.action, contrasts = NULL)
\method{icr}{default}(x, y, ...)

\method{predict}{icr}(object, newdata, ...)
}
\arguments{
\item{formula}{
A formula of the form \code{class ~ x1 + x2 + \dots}
}
\item{data}{
Data frame from which variables specified in  \code{formula} are
preferentially to be taken.
}
\item{weights}{
(case) weights for each example -- if missing defaults to 1.
}
\item{subset}{
An index vector specifying the cases to be used in the training
sample.  (NOTE: If given, this argument must be named.)
}
\item{na.action}{
A function to specify the action to be taken if \code{NA}s are found.
The default action is for the procedure to fail.  An alternative is
na.omit, which leads to rejection of cases with missing values on
any required variable.  (NOTE: If given, this argument must be named.)
}
\item{contrasts}{
a list of contrasts to be used for some or all  of
the  factors  appearing as variables in the model formula.
}
\item{\dots}{
arguments passed to \code{\link[fastICA]{fastICA}}
}
\item{x}{
matrix or data frame of \code{x} values for examples.
}
\item{y}{
matrix or data frame of target values for examples.
}


\item{object}{
an object of class \code{icr} as  returned by \code{icr}.
}
\item{newdata}{
matrix or data frame of test examples.
}

}
\details{
This produces a model analogous to Principal Components Regression (PCR) but uses Independent Component Analysis (ICA) to produce the scores. The user must specify a value of \code{n.comp} to pass to \code{\link[fastICA]{fastICA}}.

The function \code{\link{preProcess}} to produce the ICA scores for the original data and for \code{newdata}.

}
\value{
For \code{icr}, a list with elements
  \item{model }{the results of \code{\link[stats]{lm}} after the ICA transformation}
  \item{ica }{pre-processing information}
  \item{n.comp }{number of ICA components}
  \item{names }{column names of the original data}

}

\author{
Max Kuhn}


\seealso{
\code{\link[fastICA]{fastICA}}, \code{\link{preProcess}},  \code{\link[stats]{lm}}
}
\examples{
data(BloodBrain)

icrFit <- icr(bbbDescr, logBBB, n.comp = 5)

icrFit

predict(icrFit, bbbDescr[1:5,])



}
\keyword{multivariate }

