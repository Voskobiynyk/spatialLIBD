% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sig_genes_extract_all.R
\name{sig_genes_extract_all}
\alias{sig_genes_extract_all}
\title{Extract significant genes for all modeling results}
\usage{
sig_genes_extract_all(
  n = 10,
  modeling_results = fetch_data(type = "modeling_results"),
  sce_layer = fetch_data(type = "sce_layer")
)
}
\arguments{
\item{n}{The number of the top ranked genes to extract.}

\item{modeling_results}{Defaults to the output of
\code{fetch_data(type = 'modeling_results')}. This is a list of tables with the
columns \verb{f_stat_*} or \verb{t_stat_*} as well as \verb{p_value_*} and \verb{fdr_*} plus
\code{ensembl}. The column name is used to extract the statistic results, the
p-values, and the FDR adjusted p-values. Then the \code{ensembl} column is used
for matching in some cases. See \code{\link[=fetch_data]{fetch_data()}} for more details.}

\item{sce_layer}{Defaults to the output of
\code{fetch_data(type = 'sce_layer')}. This is a
\linkS4class{SingleCellExperiment}
object with the spot-level Visium data compressed via pseudo-bulking to the
layer-level (group-level) resolution. See \code{\link[=fetch_data]{fetch_data()}} for more details.}
}
\value{
A \link[S4Vectors:DataFrame-class]{DataFrame-class} with the extracted
statistics in long format. The specific columns are described further in
the vignette.
}
\description{
This function combines the output of \code{\link[=sig_genes_extract]{sig_genes_extract()}} from all the
layer-level (group-level) modeling results and builds the data required for
functions such as \code{\link[=layer_boxplot]{layer_boxplot()}}.
}
\examples{

## Obtain the necessary data
if (!exists("modeling_results")) {
      modeling_results <- fetch_data(type = "modeling_results")
  }
if (!exists("sce_layer")) sce_layer <- fetch_data(type = "sce_layer")

## top 10 genes for all models
sig_genes_extract_all(
    modeling_results = modeling_results,
    sce_layer = sce_layer
)
}
\seealso{
Other Layer modeling functions: 
\code{\link{layer_boxplot}()},
\code{\link{sig_genes_extract}()}
}
\concept{Layer modeling functions}
