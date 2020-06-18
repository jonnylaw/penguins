library(dplyr)
library(tidyr)
library(recipes)
library(parsnip)
library(yardstick)
library(ranger)

## Read in the items created in model.R
training <- readr::read_rds(here::here("data/training.Rds"))
test <- readr::read_rds(here::here("data/testing.Rds"))
rec <- readr::read_rds(here::here("models/recipe.Rds"))
mod <- readr::read_rds(here::here("models/random_forest.Rds"))

## Perform predictions using the model
predicted <- predict(mod, new_data = bake(rec, test))

## Define a metric set
metrics <- metric_set(accuracy, precision, f_meas)

## Determine the performance of the algorithm metrics
performance <- metrics(data = bind_cols(predicted, test), truth = species, estimate = .pred_class)

## Write the performance 
readr::write_rds(performance, here::here("models/test_performance.Rds"))
