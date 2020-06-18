library(dplyr) # General data manipulation and the %>% (pronounced pipe)
library(recipes) # Pre-process data in a principled way by applying step_* to the training and test data
library(parsnip) # Consistent API for multiple R machine learning models
library(rsample) # Used to create training and test sets, cross validation etc.
library(workflows) # Combine a recipe and a model
library(tune) # Find the best hyper-parameters for a model
library(palmerpenguins)

# Load the penguins data
data("penguins")

## Split the penguins data into training and test data and write it to the data folder
set.seed(1)
split <- rsample::initial_split(penguins[complete.cases(penguins),], strata = species)
train <- rsample::training(split)
test <- rsample::testing(split)

readr::write_rds(train, here::here("data/training.Rds"))
readr::write_rds(test, here::here("data/testing.Rds"))

## pre-process the data
rec <- recipe(species ~ ., data = train) %>% 
  step_naomit(all_predictors()) %>%
  step_naomit(all_outcomes())

## save the prepped recipe
readr::write_rds(prep(rec, train), here::here("models/recipe.Rds"))

## Specify a model
model <- rand_forest("classification") %>% 
  set_engine("ranger") %>% 
  set_args(mtry = tune(), trees = tune())

## Combine the recipe and the model into a workflow
wf <- workflow() %>% 
  add_recipe(rec) %>% 
  add_model(model)

## Use cross validation on the training data
cv <- rsample::vfold_cv(train, strata = species)

# Use grid search to find some good hyper-parameters.
hyper_parameters <- tune::tune_grid(wf, resamples = cv)

# We can view the metrics for a selection of the hyper-parameters
# collect_metrics(hyper_parameters)

# Select the best parameters, then fit the model using these parameters
best_hp <- select_best(hyper_parameters, metric = "roc_auc")

# Set the arguments for the random forest model
best_rf <- model %>% 
  set_args(mtry = 1, trees = 1965)

## Fit the model to the training data
fitted_model <- fit(best_rf, species ~ ., data = juice(prep(rec, train)))

## Save the model
readr::write_rds(fitted_model, here::here("models/random_forest.Rds"))
