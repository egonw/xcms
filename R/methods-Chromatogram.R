#' @include DataClasses.R do_findChromPeaks-functions.R

#' @title centWave-based peak detection in purely chromatographic data
#'
#' @description
#'
#' `findChromPeaks` on a [Chromatogram] or [Chromatograms] object with a
#' [CentWaveParam] parameter object performs centWave-based peak detection
#' on purely chromatographic data. See [centWave] for details on the method
#' and [CentWaveParam] for details on the parameter class.
#' Note that not all settings from the `CentWaveParam` will be used.
#' See [peaksWithCentWave()] for the arguments used for peak detection
#' on purely chromatographic data.
#'
#' @param object a [Chromatogram] or [Chromatograms] object.
#'
#' @param param a [CentWaveParam] object specifying the settings for the
#'     peak detection. See [peaksWithCentWave()] for the description of
#'     arguments used for peak detection.
#'
#' @param BPPARAM a parameter class specifying if and how parallel processing
#'     should be performed (only for `XChromatograms` objects). It defaults to
#'     `bpparam()`. See [bpparam()] for more information.
#'
#' @param ... currently ignored.
#'
#' @return
#'
#' If called on a `Chromatogram` object, the method returns an [XChromatogram]
#' object with the identified peaks. See [peaksWithCentWave()] for details on
#' the peak matrix content.
#'
#' @seealso [peaksWithCentWave()] for the downstream function and [centWave]
#'     for details on the method.
#'
#' @author Johannes Rainer
#'
#' @rdname findChromPeaks-Chromatogram-CentWaveParam
#'
#' @md
#'
#' @examples
#'
#' od <- readMSData(system.file("cdf/KO/ko15.CDF", package = "faahKO"),
#'     mode = "onDisk")
#'
#' ## Extract chromatographic data for a small m/z range
#' chr <- chromatogram(od, mz = c(272.1, 272.3))[1, 1]
#'
#' ## Identify peaks with default settings
#' xchr <- findChromPeaks(chr, CentWaveParam())
#' xchr
#'
#' ## Plot data and identified peaks.
#' plot(xchr)
#'
#' ## Modify the settings
#' cwp <- CentWaveParam(snthresh = 5, peakwidth = c(10, 60))
#' xchr <- findChromPeaks(chr, cwp)
#' xchr
#'
#' plot(xchr)
setMethod("findChromPeaks", signature(object = "Chromatogram",
                                      param = "CentWaveParam"),
          function(object, param, ...) {
              res <- do.call("peaksWithCentWave",
                             args = c(list(int = intensity(object),
                                           rt = rtime(object)),
                                      as(param, "list")))
              object <- as(object, "XChromatogram")
              chromPeaks(object) <- res
              object
          })

#' @title matchedFilter-based peak detection in purely chromatographic data
#'
#' @description
#'
#' `findChromPeaks` on a [Chromatogram] or [Chromatograms] object with a
#' [MatchedFilterParam] parameter object performs matchedFilter-based peak
#' detection on purely chromatographic data. See [matchedFilter] for details
#' on the method and [MatchedFilterParam] for details on the parameter class.
#' Note that not all settings from the `MatchedFilterParam` will be used.
#' See [peaksWithMatchedFilter()] for the arguments used for peak detection
#' on purely chromatographic data.
#'
#' @param object a [Chromatogram] or [Chromatograms] object.
#'
#' @param param a [MatchedFilterParam] object specifying the settings for the
#'     peak detection. See [peaksWithMatchedFilter()] for the description of
#'     arguments used for peak detection.
#'
#' @param ... currently ignored.
#'
#' @return
#'
#' If called on a `Chromatogram` object, the method returns a `matrix` with
#' the identified peaks. See [peaksWithMatchedFilter()] for details on the
#' matrix content.
#'
#' @seealso [peaksWithMatchedFilter()] for the downstream function and
#'     [matchedFilter] for details on the method.
#'
#' @author Johannes Rainer
#'
#' @rdname findChromPeaks-Chromatogram-MatchedFilter
#'
#' @md
#'
#' @examples
#'
#' od <- readMSData(system.file("cdf/KO/ko15.CDF", package = "faahKO"),
#'     mode = "onDisk")
#'
#' ## Extract chromatographic data for a small m/z range
#' chr <- chromatogram(od, mz = c(272.1, 272.3))[1, 1]
#'
#' ## Identify peaks with default settings
#' xchr <- findChromPeaks(chr, MatchedFilterParam())
#'
#' ## Plot the identified peaks
#' plot(xchr)
#'
#' ## Modify the settings
#' mfp <- MatchedFilterParam(fwhm = 60)
#' xchr <- findChromPeaks(chr, mfp)
#'
#' plot(xchr)
setMethod("findChromPeaks", signature(object = "Chromatogram",
                                      param = "MatchedFilterParam"),
          function(object, param, ...) {
              res <- do.call("peaksWithMatchedFilter",
                             args = c(list(int = intensity(object),
                                           rt = rtime(object)),
                                      as(param, "list")))
              object <- as(object, "XChromatogram")
              chromPeaks(object) <- res
              object
          })
