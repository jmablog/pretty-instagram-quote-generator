# setup =========================================================================

# library(tidyverse)
# library(magick)

# read in quotes file
quotes <- readr::read_delim("quotes.tsv")

# create_image  function ========================================================

create_image <- function(id, quote, src) {
  
  # create colours array -------------------------------------------------------
  
  # add or remove colours as desired here, just make sure they have a background (bg),
  # a text colour (text), and an optional border colour (border)
  colours <- list(red = list(bg = "#FCDEDE",
                             text = "#991511",
                             border = "#D1B2B2"),
                  blue = list(bg = "#E3EEFA",
                              text = "#254266",
                              border = "#BAC5D4"),
                  green = list(bg = "#E1FAE4",
                               text = "#1E6627",
                               border = "#B9D4BD"),
                  yellow = list(bg = "#FFFAEB",
                               text = "#4D4B43",
                               border = "#DED9C1"),
                  grey = list(bg = "#F5F7FA",
                              text = "#2F363D",
                              border = "#D7D9DB"),
                  purple = list(bg = "#FAE8FF",
                                text = "#6C22A8",
                                border = "#FAE8FF"))
  
  # picks a random colour from array above
  picked <- sample(names(colours), 1)
  
  # create base image  ------------------------------------------------------
  
  # read in base background for image size/shape
  bg <- magick::image_read("bgs/bg-white.png")
  
  # create draw object with read-in background
  img <- magick::image_draw(bg)
  
  # add elements  -----------------------------------------------------------
  
  # coloured and angled background slice
  polygon(x = c(0, 1080, 1080, 0),
          y = c(940, 890, 1080, 1080), # x and y coords of points of polygon, that get paired up in order (e.g. first point here at 0, 940)
          col = colours[[picked]][["bg"]],
          # border = colours[[picked]][["border"]], lwd = 5) # turn border on/off with
          border = NA)                                       # these two lines
  
  # MAIN QUOTE text
  text(100, 
       500, # x and y coords of text position on drawing
       labels = paste0('“', paste(strwrap(quote, width = 40), collapse = "\n"), '”'),
       cex = 3.7, # controls font size
       family = c("Sentient"), # font family, if using ragg in Rstudio preferences can pick any font on system
       adj = 0) # adj is for text alignment, 0 is left align, 1 is right, 0.5 is center
  
  # SOURCE text
  text((1050-length(src)), # this positions right aligned text according to string length
       1020, 
       labels = src,
       cex = 4,
       family = c("Inter"), 
       adj = 1,
       font = 2, # font controls font style, 1 is normal, 2 is bold, 3 italic, 4 bold italic
       col = colours[[picked]][["text"]]) # col sets font colour
  
  # READ MORE label
  text((1050-length("Read more at:")), 
       965,
       labels = "Read more at:",
       cex = 3, 
       family = c("Inter"),
       font = 2, 
       adj = 1,
       col = colours[[picked]][["text"]])
  
  # close draw object ------------------------------------------------------
  dev.off()
  
  # save created img to file -----------------------------------------------
  
  # set the directory you would like images saved into
  dir <- "out"
  
  if(!dir.exists(dir)) {
    dir.create(dir)
  }
  
  # change the format here if you would like gif, jpeg, or png
  format <- "png"
  
  magick::image_write(img, 
                      path = paste0(dir, "/", id, ".", format), 
                      format = format)
}

# generate ========================================================================

purrr::pmap(quotes, create_image)
