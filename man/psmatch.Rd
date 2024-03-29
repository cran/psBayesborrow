% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/psmatch.R
\name{psmatch}
\alias{psmatch}
\title{Propensity score matching}
\usage{
psmatch(
  formula, data, n.EC,
  method.psest="glm", method.pslink="logit",
  method.whomatch, method.matching, method.psorder, n.boot=100)
}
\arguments{
\item{formula}{Object of class \code{formula}, which is a symbolic
description of the propensity score model to be fitted. The dependent
variable must be named \code{study}. The explanatory variables only include
covariates of interest, which must be specified in the form of linear
combination.}

\item{data}{Data frame, which must contain variables named \code{study} for
study indicator (0 for external control, and 1 for current trial) and
\code{treat} for treatment indicator (0 for concurrent and external control,
and 1 for treatment).}

\item{n.EC}{Number of patients in external control to be selected, which must
be smaller than the number of patients in external control pool.}

\item{method.psest}{Method of estimating the propensity score. Allowable
options include, for example, \code{"glm"} for generalized linear model
(e.g., logistic regression); \code{"gam"} for generalized additive model;
\code{"gbm"} for generalized boosted model; \code{"lasso"} for lasso
regression; \code{"rpart"} for classification tree. The default value is
\code{method.psest="glm"}.}

\item{method.pslink}{Link function used in estimating the propensity score.
Allowable options depend on the specific \code{method.psest} value specified.
The default value is \code{method.pslink="logit"}, which, along with
\code{method.psest="glm"}, identifies the default method as logistic
regression.}

\item{method.whomatch}{Options of who to match. Allowable options include
\code{conc.contl} for matching concurrent control to external control pool;
\code{conc.treat} for matching treatment to external control pool;
\code{conc.all} for matching treatment plus concurrent control to external
control pool; \code{treat2contl} for matching treatment to concurrent control
plus external control pool.}

\item{method.matching}{Propensity score matching method. Allowable options include
\code{"optimal"} for optimal matching; \code{"nearest"} for nearest neighbor
matching without replacement; \code{"med.optimal"} for equally splitting
patients in the current trial and taking the median of each subset, followed
by 1:1 optimal matching; \code{"med.nearest"} for equally splitting
patients in the current trial and taking the median of each subset, followed
by 1:1 nearest neighbor matching without replacement; \code{"km.optimal"} for
k-means clustering of patients in the current trial, followed by 1:1 optimal
matching; \code{"km.nearest"} for k-means clustering of patients in the
current trial, followed by 1:1 nearest neighbor matching without replacement;
\code{"cm.optimal"} for fuzzy c-means clustering of patients in the current
trial, followed by 1:1 optimal matching; \code{"cm.nearest"} for fuzzy
c-means of patients in the current trial, followed by 1:1 nearest neighbor
matching without replacement; \code{"boot.optimal"} for bootstrap sampling
from patients in the current trial, followed by 1:1 optimal matching;
\code{"boot.nearest"} for bootstrap sampling from patient in the current
trial, followed by 1:1 nearest neighbor matching without replacement.}

\item{method.psorder}{Order that the matching takes place when a nearest
neighbor matching is used. Allowable options include \code{"largest"},
where matching takes place in descending order of propensity score;
\code{"smallest"}, where matching takes place in ascending order of
propensity score; \code{"random"}, where matching takes place in a random
order; \code{"data"}, where matching takes place based on the order of units
in the data. The matching order must be specified when using the nearest
neighbor matching.}

\item{n.boot}{Number of bootstrap sampling, which must be specified when
\code{method.matching="boot.optimal"} or
\code{method.matching="boot.nearest"}. The default value is \code{n.boot=100}.}
}
\value{
The \code{psmatch} returns a list containing the following objects:
\item{subjid.EC}{Vector of subject ID of external control.}
\item{data.ps}{Data frame with estimated propensity score.}
}
\description{
Propensity score matching is implemented to select external controls who are
more relevant to patients in the current trial with respect to covariates
of interest.
}
\details{
The propensity score is defined as the conditional probability of
having been included in the current trial given observed covariates. There
are four options applicable for to whom the patients in external control
pool are matched, including (i) concurrent control versus external control
pool (\code{"conc.contl"}), (ii) treatment versus external control pool
(\code{"conc.treat"}), (iii) treatment plus concurrent control versus
external control pool (\code{"conc.all"}), and (iv) treatment versus
concurrent control plus external control pool (\code{"treat2contl"}).
Along with \code{method.whomatch="conc.contl"}, two 1:1 matching methods are
applicable: (1) optimal matching (\code{"optimal"}), and (2) nearest neighbor
matching without caliper (\code{"nearest"}). Along with
\code{method.whomatch="conc.treat"} or \code{method.whomatch="conc.all"},
ten matching methods are applicable: (1) optimal matching, where 1:1
matching is first done, followed by random sampling (\code{"optimal"}),
(2) nearest neighbor matching, where caliper is tuned iteratively
to obtain the fixed number of external controls (\code{"nearest"}), (3)
equally splitting patients in the current trial and taking the median of
each subset, followed by 1:1 optimal matching (\code{"medm.optimal"}), (4)
equally splitting patients in the current trial and taking the median of
each subset, followed by 1:1 nearest neighbor matching matching
(\code{"med.nearest"}), (5) k-means clustering of patients in the current
trial, followed by 1:1 optimal matching (\code{"km.optimal"}), (6) k-means
clustering of patients in the current trial, followed by 1:1 nearest neighbor
matching (\code{"km.nearest"}), (7) fuzzy c-means clustering of patients in
the current trial, followed by 1:1 optimal matching (\code{"cm.optimal"}),
(8) fuzzy c-means of patients in the current trial, followed by 1:1 nearest
neighbor matching (\code{"cm.nearest"}), (9) bootstrap sampling from patients
in the current trial, followed by 1:1 optimal matching
(\code{"boot.nearest"}), and (10) bootstrap sampling from patient in the
current trial, followed by 1:1 nearest neighbor matching
(\code{"boot.nearest"}). Along with \code{method.whomatch="treat2contl"},
two matching methods are applicable: (1) optimal matching, followed by
random sampling (\code{"optimal"}), and (2) nearest neighbor matching, where
caliper is tuned iteratively to obtain the fixed number of external controls
(\code{"nearest"}).
}
\examples{
n.CT       <- 100
n.CC       <- 50
nevent.C   <- 100
n.ECp      <- 1000
nevent.ECp <- 800
accrual    <- 16

out.mevent.CT <- 6
out.mevent.CC <- 6
driftHR       <- 1

cov.C <- list(list(dist="norm",mean=0,sd=1,lab="cov1"),
              list(dist="binom",prob=0.4,lab="cov2"))

cov.cor.C <- rbind(c(  1,0.1),
                   c(0.1,  1))

cov.EC <- list(list(dist="norm",mean=0,sd=1,lab="cov1"),
               list(dist="binom",prob=0.4,lab="cov2"))

cov.cor.EC <- rbind(c(  1,0.1),
                    c(0.1,  1))

cov.effect <- c(0.1,0.1)

indata <- trial.simulation.t2e(
  n.CT=n.CT, n.CC=n.CC, nevent.C=nevent.C,
  n.ECp=n.ECp, nevent.ECp=nevent.ECp, accrual=accrual,
  out.mevent.CT, out.mevent.CC, driftHR,
  cov.C=cov.C, cov.cor.C=cov.cor.C,
  cov.EC=cov.EC, cov.cor.EC=cov.cor.EC, cov.effect=cov.effect)

n.EC <- 50

method.whomatch <- "conc.treat"
method.matching <- "optimal"
method.psorder  <- NULL

psmatch(
  study~cov1+cov2, data=indata, n.EC=n.EC,
  method.whomatch=method.whomatch, method.matching=method.matching,
  method.psorder=method.psorder)
}
\references{
Austin PC. A comparison of 12 algorithms for matching on the propensity
score. \emph{Statistics in Medicine} 2014; 33:1057-1069.

Lin J, Gamalo-Siebers M, Tiwari R. Propensity score matched augmented
controls in randomized clinical trials: A case study.
\emph{Pharmaceutical Statistics} 2018; 17:629-647.

Lin J, Gamalo-Siebers M, Tiwari R. Propensity-score-based priors for
Bayesian augmented control design. \emph{Pharmaceutical Statistics} 2019;
18:223-238.

Rosenbaum PR. Optimal matching for observational studies.
\emph{Journal of the American Statistical Association} 1989; 84:1024-1032.

Sawamoto R, Oba K, Matsuyama Y. Bayesian adaptive randomization design
incorporating propensity score-matched historical controls.
\emph{Pharmaceutical Statistics} 2022; 21:1074-1089.
}
