#' Sample spatial gene visualization workhorse function
#'
#' This function visualizes the gene expression stored in `assays(sce)` or any
#' continuous variable stored in `colData(sce)` for one given sample at the
#' spot-level using (by default) the histology information on the background.
#' This is the function that does all the plotting behind [sce_image_gene()].
#' To visualize clusters (or any discrete variable) use [sce_image_clus_p()].
#'
#' @param d A data.frame with the sample-level information. This is typically
#' obtained using `as.data.frame(colData(sce))`. The data.frame has to contain
#' a column with the continuous variable data to plot stored under `d$COUNT`.
#' @inheritParams sce_image_clus_p
#' @inheritParams sce_image_gene
#'
#' @return A [ggplot2][ggplot2::ggplot] object.
#' @export
#' @importFrom S4Vectors metadata
#' @family Spatial gene visualization functions
#'
#' @examples
#'
#' if (enough_ram()) {
#'     ## Obtain the necessary data
#'     if (!exists("sce")) sce <- fetch_data("sce")
#'
#'     ## Prepare the data for the plotting function
#'     sce_sub <- sce[, sce$sample_name == "151673"]
#'     df <- as.data.frame(colData(sce_sub))
#'     df$COUNT <- df$expr_chrM_ratio
#'
#'     ## Use the manual color palette by Lukas M Weber
#'     ## Don't plot the histology information
#'     sce_image_gene_p(
#'         sce = sce_sub,
#'         d = df,
#'         sampleid = "151673",
#'         title = "151673 chrM expr ratio",
#'         spatial = FALSE
#'     )
#'
#'     ## Clean up
#'     rm(sce_sub)
#' }
sce_image_gene_p <-
    function(sce,
    d,
    sampleid,
    spatial,
    title,
    viridis = TRUE) {

        ## Some variables
        imagecol <- imagerow <- key <- COUNT <- NULL

        p <-
            ggplot(
                d,
                aes(
                    x = imagecol,
                    y = imagerow,
                    fill = COUNT,
                    color = COUNT,
                    key = key
                )
            )

        if (spatial) {
            p <-
                p + geom_spatial(
                    data = subset(metadata(sce)$image, sample == sampleid),
                    aes(grob = grob),
                    x = 0.5,
                    y = 0.5
                )
        }

        ## From https://github.com/LieberInstitute/HumanPilot/blob/master/Analysis/Layer_Guesses/layer_marker_genes_plots.R
        # add.alpha('black', 0.175)
        # black
        # "#0000002D"

        p <- p +
            geom_point(
                shape = 21,
                size = 1.25,
                stroke = 0.25
            ) +
            coord_cartesian(expand = FALSE)

        if (viridis) {
            p <- p + scale_fill_gradientn(
                colors = viridis(21),
                na.value = c("black" = "#0000002D")
            ) +
                scale_color_gradientn(
                    colors = viridis(21),
                    na.value = c("black" = "#0000002D")
                )
        } else {
            p <- p + scale_fill_gradientn(
                colors = c("aquamarine4", "springgreen", "goldenrod", "red"),
                na.value = c("black" = "#0000002D")
            ) + scale_color_gradientn(
                colors = c("aquamarine4", "springgreen", "goldenrod", "red"),
                na.value = c("black" = "#0000002D")
            )
        }

        p <- p +
            xlim(0, max(sce$width)) +
            ylim(max(sce$height), 0) +
            xlab("") + ylab("") +
            labs(fill = NULL, color = NULL) +
            ggtitle(title) +
            theme_set(theme_bw(base_size = 20)) +
            theme(
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.background = element_blank(),
                axis.line = element_blank(),
                axis.text = element_blank(),
                axis.ticks = element_blank(),
                legend.position = c(0.95, 0.10)
            )
        return(p)
    }
