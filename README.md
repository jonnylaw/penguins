
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Classifying Iris Data

This is an example project which classifys the type of Iris flower from
the Iris dataset. The model is fit using the
[tidymodels](https://github.com/tidymodels/tidymodels) metapackage. The
file `R/model.R` contains the modelling code required. The rough steps
are

  - Split the data into training and test sets
  - Define pre-processing steps using
    [recipes](https://tidymodels.github.io/recipes/)
  - Create a random forest model using
    [parsnip](https://tidymodels.github.io/parsnip/)
  - Combine the model and recipe into a
    [workflow](https://tidymodels.github.io/workflows/)
  - Perform hyper-parameter tuning using cross validation on the
    training using [tune](https://tidymodels.github.io/tune/)
  - Select the best model
  - Fit the best model to the training data
  - Save the best model

## Deployment

The application is deployed using Docker, see the Dockerfile for
details. The base image is from
[rocker](https://hub.docker.com/u/rocker). Dependencies are managed
using [renv](https://rstudio.github.io/renv/).

``` bash
docker build . --file Dockerfile
```

## Querying the API

The model is served using [plumber](https://www.rplumber.io/). To
predict the type of flower given petal and sepal features, submit a JSON
file using POST. An example using curl is
below.

``` bash
curl localhost:8000/getprediction --header "Content-Type: application/json" \
  --request POST \
  --data @data/example.json
```

## Model Performance

The data is split into a training and test set, the model is then fit on
the training set. The performance measures are calculated using the test
set.

| .metric   | .estimator | .estimate |
| :-------- | :--------- | --------: |
| accuracy  | multiclass |      0.89 |
| precision | macro      |      0.89 |
| f\_meas   | macro      |      0.89 |
