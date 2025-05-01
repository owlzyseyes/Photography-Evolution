library(exifr)
library(magick)
library(dplyr)
library(lubridate)

# Read the image
img <- image_read("2022_photos/20221021_142227.jpg")

# Normalize to enhance contrast and colour separation
img <- image_normalize(img)

# Reduce to n dominant colors (3 is my arbitrary choice)
dominant_colors <- image_quantize(img, max = 3)
print(dominant_colors)

# Convert to raw data
raw_colors <- image_data(dominant_colors)

# Extract unique hex codes
hex_codes <- unique(apply(raw_colors, 2, function(rgb)
  {
  sprintf("#%02X%02X%02X", as.integer(rgb[1]), as.integer(rgb[2]), as.integer(rgb[3]))
}))
print(hex_codes)


# Get the image metadata
metadata <- read_exif("2022_photos/20221021_142227.jpg")
# Get the DateTimeOriginal 
datetime <- metadata$DateTimeOriginal
print(datetime)


colours <- list("#1A1E10","#4B4C2E","#BC794A") # 3 dominant colors

# TODO:
# Write function to load the images, extract colours and datetime metadata