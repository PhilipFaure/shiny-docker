# Shiny-docker Example:

This is an example to build a Shiny app and wrap it in a Docker image.
The repo can be cloned and the shiny app adapted as necessary.

### Build docker image:
docker build -t shiny-docker-image .

### Run Shiny app:
```{bash}
docker run -p 3838:3838 shiny-docker-image
```
Now visit: http://localhost:3838/app


### Share Image:

### Option 1 - export and send
```{bash}
docker save shiny-docker-image > shiny-docker-image.tar
```
Now send tar file to someone

### Then load with:
```{bash}
docker load < shiny-docker-image.tar
```

### Option 2 - Push to Docker Hub
### Tag and push (requires Docker Hub account)
```{bash}
docker tag shiny-docker-image yourusername/shiny-docker-image
docker push yourusername/shiny-docker-image
```

### The run with:
```{bash}
docker run -p 3838:3838 yourusername/shiny-docker-image
```