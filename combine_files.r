library(tidyverse)
library(lubridate)

data_path <- "data"   # path to the data
files <- dir(data_path, pattern = "\\.csv$", full.names = TRUE)

READ <- function(FILE) {
  read_csv(FILE,
           trim_ws = TRUE,
           guess_max = nrow(read_csv(FILE)) -12,
           n_max = nrow(read_csv(FILE)) -12,
           # col_types = cols(
           #   `Inception \nDate` = col_date("%m/%d/%Y"),
           #   `Listing \nDate`= col_date("%m/%d/%Y")
           # )
        ) %>%
    mutate(filename = basename(FILE)) %>%
    rename_all(make.names)
}

data <- files %>%
  map(READ) %>%    # read in all the files individually, using
  # the function READ from above
  reduce(full_join, by=)        # reduce with full_join into one dataframe

warnings <- warnings(data)

write_csv(data, "data_combined.csv")
