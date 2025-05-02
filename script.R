library(exifr)
library(magick)
library(dplyr)
library(lubridate)

# Function to process a single image
process_image <- function(image_path) {
  # Load and normalize the image
  img <- image_read(image_path) %>%
    image_normalize()
  
  # Extract the single dominant color
  dominant_color <- image_quantize(img, max = 1)
  raw_color <- image_data(dominant_color)
  
  # Convert to a hex code
  hex_code <- sprintf("#%02X%02X%02X", as.integer(raw_color[1]), as.integer(raw_color[2]), as.integer(raw_color[3]))
  
  # Extract datetime metadata
  metadata <- read_exif(image_path)
  datetime <- metadata$CreateDate
  
  # Return a list with the image data
  list(
    image_id = basename(image_path),
    color = hex_code,
    datetime = datetime
  )
}

# Function to process all images in a directory
process_images_in_directory <- function(directory_path) {
  # Get a list of all .jpg image files
  image_files <- list.files(directory_path, full.names = TRUE, pattern = "\\.jpg$")
  
  # Process each image and combine results into a dataframe
  results <- lapply(image_files, process_image)
  df <- bind_rows(results)
  
  return(df)
}

# Function to process multiple directories
process_images_in_directories <- function(directories) {
  # Initialize an empty list to store results from all directories
  all_results <- list()
  
  # Loop through each directory and process images
  for (directory in directories) {
    cat("Processing directory:", directory, "\n")
    # Process images in the current directory
    results <- process_images_in_directory(directory)
    # Append the results to the list
    all_results <- append(all_results, list(results))
  }
  
  # Combine all results into a single dataframe
  df <- bind_rows(all_results)
  
  return(df)
}

# Directories to process
directories <- c("2020_photos", "2021_photos", "2022_photos", "2023_photos", "2024_photos", "2025_photos")

# Process all directories and create the dataframe
all_image_data <- process_images_in_directories(directories)

# Print the combined dataframe
print(all_image_data)

# Optionally, save the dataframe to a CSV file
write.csv(all_image_data, "image_data.csv", row.names = FALSE)
