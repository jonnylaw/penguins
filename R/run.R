r <- plumber::plumb(here::here("multilabel_classification/api.R"))
r$run(port = 8000)

