# install paletteer pkg--------
#install_github("andreacirilloac/paletter")

library(paletter)
library(magick)
library(grid)
library(showtext)

if(!dir.exists("images")) dir.create("images")
if(!dir.exists("output")) dir.create("output")



#get one of Steph de silva's infographics--------
url <- "http://rex-analytics.com/wp-content/uploads/2018/03/Copy-of-Where-does-it-live.png"


png_file <- "images/Where-does-it-live.png"
    if(!file.exists(png_file)) {
    download.file(url,png_file)
}
#convert from png to jpg--------
#read in image-------
img <-  magick::image_read(png_file)
img

#crop a potion with the main colors--------

img <- magick::image_crop(img,"400X700+350+200")
# convert------
img_jpeg <-   magick::image_convert(img, format = "jpeg")
# new filename------
jpeg_file <- paste0(stringr::str_split(png_file,"\\.", simplify = TRUE)[1],
                    ".jpeg")
# write new file --------
magick::image_write(img_jpeg,jpeg_file)
# set seed in the hope the create_pa;ette algorithm generates same colours
#each time script is run
set.seed(42)
colours_vector <- create_palette(jpeg_file,
                                 type_of_variable = "categorical",
                                 optimize_palette = FALSE,
                                 number_of_colors = 6)
#examine palette and assign labels to each colour code----
names(colours_vector) <- c("stripes","background",
                           "subtitle","text",
                           "arrow","heading")

para1 <- paste("We use the word 'variable' to describe",
               "things that can change, or that could",
               "take multiple values. In Excel, typically",
               "this is a column with a heading giving ",
               "the variable name.", sep="\n")

para2 <- paste("In R, it might be a column in a data frame",
               "we access with a name or using subscripts.",
               "Or it might be a standalone object", sep = "\n")

 

# Store our text in a list ------------------------------------------------
info_text <- list(main_title = "WHAT'S A\nVARIABLE IN R?",
                  subtitle="IN R, A VARIABLE IS A TYPE OF 'OBJECT'\nBUT WHAT IS THAT AND HOW DOES IT WORK?",
                  subheadings=list(variables=list(row=4,text="VARIABLES"),
                                  using_variables=list(row=7,text="USING VARIABLES"),
                                  under_hood=list(row=9,text="BUT WHAT'S GOING ON UNDER THE HOOD?")
                                  ),
                  paragraphs=list(para1=list(row=5, text=para1),
                                  para2=list(row=6, text=para2))
                  )



## Loading Google fonts (http://www.google.com/fonts)
#font_add_google("Lato","lato")
#font_add_google("Rubik","rubik")
## Automatically use showtext to render text
## TRUE = on , FALSE = off
showtext_auto(FALSE)


#pdf----

pdf("output/r_variables.pdf", width = 10, height = 20)

#open a new graphics device because showtext doesn't work with Rstudio device
#only do this if the current device is the RStudio one
 #windows, linux might be X11()
#if(!is.na(dev.cur()["RStudioGD"])) quartz()


#grid-----
grid.newpage()
#basic layout of orignal infographic could be 12 rows x 2 columns
layout <- grid.layout(nrow = 12, ncol=2,
                      heights = unit(c(8,8,2, rep(1,9)),
                                     c("lines","lines","lines",rep("null",9))))
# grid.show.layout(layout)
vp_base <- viewport(layout = layout, name = "base")
pushViewport(vp_base)

grid.rect(gp =  gpar(fill=colours_vector["background"]))

#showtext_begin()

vp_title <- viewport(layout.pos.row = 1,
                     layout.pos.col = 1:2,
                     name="title")
pushViewport(vp_title)

grid.text(info_text$main_title ,
          #y=0.95,
         # vjust = 1,
          gp = gpar(cex=4,
                    fontface="bold",
                   # fontfamily="rubik",
                    fontfamily="Helvetica",
                    col=colours_vector["heading"]))

seekViewport("base")

vp_subtitle <- viewport(layout.pos.row = 2,
                     layout.pos.col = 1:2,
                     name="subtitle")
  pushViewport(vp_subtitle)

      grid.text(info_text$subtitle ,
                #y=0.95,
                #vjust = 1,
                gp = gpar(cex=2,
                          fontface="plain",
                         # fontfamily="rubik",
                          fontfamily="Helvetica",
                          col=colours_vector["subtitle"]))
seekViewport("base")

vp_stripes<- viewport(layout.pos.row = 3,
                        layout.pos.col = 1:2,
                        name="stripes")
  pushViewport(vp_stripes)

      angle <-88
      radians <- angle * pi / 180
      m <- tan( radians)
      
      
      x1 <- seq(-1,1, by = 0.03)
      x2  <- (1 + (x1 * m ))/m
      xs <- as.vector(mapply(function(x,y) c(x,y), x1, x2))
      
      
      grid.polyline(
        x=xs,
        y = rep(c(0,1),length(x1)),
        id=rep(1:length(x1),each=2),
        gp = gpar(lwd=1,
                  lex=10,
                  col=colours_vector["stripes"]),
        name = "stripes")

seekViewport("base")

#subheadings-------
#try to use purrr::iwalk() to iterate over list of subheadings,
#will the environment in the anonymous function still be able to reach the current device?
# using iwalk because i want access to the name of each item

purrr::iwalk(info_text$subheadings,function(subheading,name){
  #test iteration    
  # print(subheading$row)
  # print(subheading$text)
  # print(name)
  vp_subheading <- viewport(layout.pos.row=subheading$row,
                            layout.pos.col = 2,
                            name=paste("subheading",sep="_",name))
  
  pushViewport(vp_subheading)
  
  grid.text(subheading$text ,
                  x=unit(1,"npc") - unit(10,"mm"),
                  just="right",
                  name=paste("text",sep="_",name),
                  gp = gpar(cex=2,
                      fontface="bold",
                      # fontfamily="rubik",
                      fontfamily="Helvetica",
                      col=colours_vector["heading"]))
  seekViewport("base")
    
} ) 


#paragraphs-------
# use purrr::iwalk() to iterate over list of paragraphs,

# using iwalk because i want access to the name of each item

purrr::iwalk(info_text$paragraphs,function(paragraph,name){
  
  vp_paragraph <- viewport(layout.pos.row=paragraph$row,
                            layout.pos.col = 2,
                            name=paste("vp",sep="_",name))
  
  pushViewport(vp_paragraph)
  
  grid.text(paragraph$text ,
            x=0.02,
            y = 0.95,
            just=c("left","top"),
            name=paste("text",sep="_",name),
            gp = gpar(cex=1,
                      fontface="plain",
                      # fontfamily="rubik",
                      fontfamily="Helvetica",
                      col=colours_vector["text"]))
  seekViewport("base")
  
} ) 


      
#showtext_end()

if(!is.na(dev.cur()["pdf"]))  dev.off()






