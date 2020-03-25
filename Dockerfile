FROM rocker/r-ver:3.6.1

WORKDIR /usr/local/app

# Install binary packages from apt
RUN apt-get update \
  && apt-get install -y zlib1g-dev libxml2-dev \
  && rm -rf /var/lib/apt/lists/*

# Copy over contents of directory
COPY . .

# Install dependencies using renv
RUN Rscript -e "renv::restore()"

# Build and train the models
RUN Rscript R/model.R && Rscript R/test_performance.R

# Expose port 8000 for api requests to the model
ENTRYPOINT ["Rscript", "/usr/local/app/R/run.R"]
EXPOSE 8000/tcp