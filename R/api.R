library(plumber)
library(jsonlite)
library(readr)
library(recipes)
library(parsnip)
library(ranger) # Have to explicitly load ranger to get the predict method

#* Perform a prediction by submitting in the body of a POST request
#* @post /getprediction 
getprediction <- function(req) {
  example <- req$postBody
  parsed_example <- jsonlite::fromJSON(example)
  model <- readr::read_rds(path = here::here("models/random_forest.Rds"))
  rec <- readr::read_rds(path = here::here("models/recipe.Rds"))
  prediction <- predict(model, new_data = bake(rec, parsed_example))

  dplyr::bind_cols(parsed_example, prediction)
}

#* Get the performance on test data
#* @get /performance
performance <- function() {
  readr::read_rds("models/test_performance.Rds")
}
