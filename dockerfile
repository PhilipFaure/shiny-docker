FROM rocker/shiny:latest

# Install required R packages
RUN install2.r --error \
    DT \
    shinyFiles \
    digest \
    htmltools \
    shinyjs

# Copy app files into the image
COPY app/ /srv/shiny-server/app/

# Ensure proper ownership
RUN chown -R shiny:shiny /srv/shiny-server/

# Expose the default Shiny port
EXPOSE 3838
