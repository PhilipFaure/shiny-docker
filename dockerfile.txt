# Base image with R and Shiny Server
FROM rocker/shiny:latest

# System libs if needed (for now, not installing extras)
# RUN apt-get update && apt-get install -y libcurl4-openssl-dev libssl-dev

# Copy Shiny app to the image
COPY app/ /srv/shiny-server/app/

# Change ownership (required by shiny-server)
RUN chown -R shiny:shiny /srv/shiny-server/

# Expose port
EXPOSE 3838

# Start Shiny Server (default CMD in rocker/shiny)
