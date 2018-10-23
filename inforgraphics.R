# install paletteer pkg
install_github("andreacirilloac/paletter")

library(paletter)
library(magick)
library(grid)
library(showtext)
dir.create("images")
dir.create("output")

# get one og Steph de silva's inforgraphics
url <- "http://rex-analytics.com/wp-content/uploads/2018/03/Copy-of-Where-does-it-live.png"

png_file <- "images/Where-does-it-live.png"
download.file(url,png_file)

#convert from png to jpg
    # read in image
img <-  magick::image_read(png_file)
img

    #crop a potion with the main colors

img <- magick::image_crop(img,"400X700+350+200")
    # convert
img_jpeg <-   magick::image_convert(img, format = "jpeg")
  # new filename
jpeg_file <- paste0(stringr::str_split(image_file,"\\.", simplify = TRUE)[1],
                    ".jpeg")
  # write new file
magick::image_write(img_jpeg,jpeg_file)


colours_vector <- create_palette(jpeg_file,
                                 type_of_variable = "categorical",
                                 optimize_palette = FALSE,
                                 number_of_colors = 6)

names(colours_vector) <- c("subheading","stripes","background",
                           "arrow","text","heading")



## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Lato","lato")
font_add_google("Rubik","rubik")
## Automatically use showtext to render text
## TRUE = on , FALSE = off
showtext_auto(FALSE)
#open a new graphics device because showtext doesn't work with Rstudio device
quartz() #windows, linux might be X11()

#pdf

pdf("output/r_variables.pdf", width = 10, height = 20)

grid.newpage()
layout <- grid.layout(3,2)
vp_base <- viewport(layout = layout, name = "base")
pushViewport(vp_base)

grid.rect(gp =  gpar(fill=colours_vector["background"]))

showtext.begin()
grid.text("WHAT'S A\nVARIABLE IN R?" ,
          y=0.95,
          vjust = 1,
          gp = gpar(cex=4,
                    fontface="bold",
                    fontfamily="rubik",
                    #fontfamily="Helvetica",
                    col=colours_vector["heading"]))

showtext.end()
dev.off()


