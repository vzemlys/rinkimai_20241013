# stolen from: https://github.com/vainius/randomRscripts/blob/main/rezultatai-apylinkese.R?fbclid=IwY2xjawF4p5hleHRuA2FlbQIxMAABHS3Tdmlqd9kxAP8_VBdn2IGsJl7R6eAe5u9Dfa1m4Eb_KIxe6O9N59HSnQ_aem_qjYzxAp9sQQ34sMsSKJL4Q

urlToDataFrame <- function(url, subfield = NULL){
    response <- GET(url)
    data <- content(response, "text", encoding = "UTF-8") %>%
        fromJSON() %>%
        .[['data']]

    if (!is.null(subfield)) {
        data <- data[[subfield]]
    }

    as.data.frame(data)
}

# rinkimu metaduomenys
meta_dt <- urlToDataFrame("https://www.vrk.lt/statiniai/puslapiai/rinkimai/rt.json")

