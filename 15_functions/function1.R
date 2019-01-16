decimal <- function(x) { for (i in seq_along(x)) {    x[i] <- x[[i]] / 10  }; x}

