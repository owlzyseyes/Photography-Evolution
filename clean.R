library(tidyverse)

# Load the data
Fotos <- read.csv("image_data.csv", stringsAsFactors = FALSE)

# Trim extra spaces
Fotos$datetime <- str_trim(Fotos$datetime)

# Convert datetime into a consistent format
Fotos$datetime <- ymd_hms(Fotos$datetime, tz = "Africa/Nairobi")


# Extract date and time separately
Fotos <- Fotos %>%
  mutate(date = as.Date(datetime),
         time = format(datetime, "%H:%M:%S")) %>% 
  select(-datetime)

# Save the cleaned file
write.csv(Fotos, "cleaned_image_data.csv", row.names = FALSE)
