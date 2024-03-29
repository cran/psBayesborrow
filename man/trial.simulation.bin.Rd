% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trial.simulation.bin.R
\name{trial.simulation.bin}
\alias{trial.simulation.bin}
\title{Simulating binary data for current trial and external control}
\usage{
trial.simulation.bin(
 n.CT, n.CC, n.ECp,
 out.prob.CT, out.prob.CC, driftOR,
 cov.C, cov.cor.C, cov.EC, cov.cor.EC, cov.effect,
 seed=sample.int(.Machine$integer.max,1))
}
\arguments{
\item{n.CT}{Number of patients in treatment group in the current trial.}

\item{n.CC}{Number of patients in concurrent control group in the current
trial.}

\item{n.ECp}{Number of patients in external control pool.}

\item{out.prob.CT}{True rate of outcome in treatment group in the current
trial.}

\item{out.prob.CC}{True rate of outcome in concurrent control group in the
current trial.}

\item{driftOR}{Odds ratio between concurrent and external control
for which the bias should be plotted (odds in external control divided by
odds in concurrent control).}

\item{cov.C}{List of covariate distributions for treatment and concurrent
control group in the current trial. Continuous and binary covariate are
applicable. The continuous covariate is assumed to follow a normal
distribution; for example, specified as
\code{list(dist="norm", mean=0, sd=1, lab="cov1")}. The binary covariate is
assumed to follow a binomial distribution; for example, specified as
\code{list(dist="binom", prob=0.4, lab="cov2")}. \code{lab} is the column
name of the covariate in the data frame generated.}

\item{cov.cor.C}{Matrix of correlation coefficients for each pair of
covariate for treatment and concurrent control in the current trial,
specified as Gaussian copula parameter.}

\item{cov.EC}{List of covariate distributions for external control. The
continuous covariate is assumed to follow a normal distribution; for example,
specified as \code{list(dist="norm", mean=0, sd=1, lab="cov1")}. The binary
covariate is assumed to follow a binomial distribution; for example,
specified as \code{list(dist="binom", prob=0.4, lab="cov2")}. \code{lab} is
the column name of the covariate in the data frame generated, which must be
consistent with those used for \code{cov.C}.}

\item{cov.cor.EC}{Matrix of correlation coefficients for each pair of
covariate for external control, specified as Gaussian copula parameter.}

\item{cov.effect}{Vector of covariate effects on the outcome, specified as
odds ratio per one unit increase in continuous covariates or as odds ratio
between categories for binary covariates.}

\item{seed}{Setting a seed.}
}
\value{
The \code{trial.simulation.bin} returns a data frame containing the
following variables:
\item{study}{Study indicator (0 for external control, and 1 for current
trial)}
\item{treat}{Treatment indicator (0 for concurrent and external control, and
1 for treatment)}
\item{y}{Binary outcome}
\item{column name specified}{Covariate of interest}
}
\description{
A two-arm randomized clinical trial with a binary outcome, which is
augmented by external control data, is simulated.
}
\details{
The binary outcome is assumed to follow a binomial distribution.
Given more than one covariates with their effects on the outcome, a logistic
regression model is constructed for data generation. The data frame
generated include the binary outcome data and covariates for \code{n.CT}
and \code{n.CC} patients in treatment and concurrent control group in the
current trial respectively, and \code{n.ECp} patients in external control
pool. One record per patient. More than one covariates must be specified.
}
\examples{
n.CT  <- 100
n.CC  <- 50
n.ECp <- 1000

out.prob.CT <- 0.2
out.prob.CC <- 0.2
driftOR     <- 1.0

cov.C <- list(list(dist="norm",mean=0,sd=1,lab="cov1"),
              list(dist="binom",prob=0.4,lab="cov2"))

cov.cor.C <- rbind(c(  1,0.1),
                   c(0.1,  1))

cov.EC <- list(list(dist="norm",mean=0,sd=1,lab="cov1"),
               list(dist="binom",prob=0.4,lab="cov2"))

cov.cor.EC <- rbind(c(  1,0.1),
                    c(0.1,  1))

cov.effect <- c(0.8,0.8)

trial.simulation.bin(
   n.CT=n.CT, n.CC=n.CC, n.ECp=n.ECp,
   out.prob.CT=out.prob.CT, out.prob.CC=out.prob.CC, driftOR=driftOR,
   cov.C=cov.C, cov.cor.C=cov.cor.C,
   cov.EC=cov.EC, cov.cor.EC=cov.cor.EC, cov.effect=cov.effect, seed=100)
}
