Dataset: https://open.toronto.ca/dataset/daily-shelter-overnight-service-occupancy-capacity/
# Initialization

install.packages("gt")
install.packages("readr")
install.packages("webshot")
webshot::install_phantomjs()
library(gt)  
library(readr)
library(dplyr) 
library(ggplot2)
library(tidyr)

file_path <- "data/raw_data/raw_data.csv"
df <- read_csv(file_path)
head(df)

# to identify missing values if any
summary(df)
colnames(df)

# Data Cleaning

# 1. Replace missing values OCCUPIED_BEDS and UNOCCUPIED_BEDS with zeros
df_cleaned <- df %>%
  mutate(
    OCCUPIED_BEDS = ifelse(is.na(OCCUPIED_BEDS), 0, OCCUPIED_BEDS),
    UNOCCUPIED_BEDS = ifelse(is.na(UNOCCUPIED_BEDS), 0, UNOCCUPIED_BEDS),
    OCCUPIED_ROOMS = ifelse(is.na(OCCUPIED_ROOMS), 0, OCCUPIED_ROOMS),
    UNOCCUPIED_ROOMS = ifelse(is.na(UNOCCUPIED_ROOMS), 0, UNOCCUPIED_ROOMS)
  )

# 2. Remove records with missing critical information (such as program names or location)
# Verify that ORGANIZATION_NAME and LOCATION_NAME are the correct column names
df_cleaned <- df_cleaned %>%
  filter(!is.na(ORGANIZATION_NAME) & !is.na(LOCATION_NAME))

summary(df_cleaned)
head(df_cleaned)
colnames(df_cleaned)

# Graphs 

# Figure 1: Stacked bar plot

# Convert the OCCUPANCY_DATE column to Date type 
df_cleaned <- df_cleaned %>%
  mutate(OCCUPANCY_DATE = as.Date(OCCUPANCY_DATE, format = "%Y-%m-%d"))

# Reshape the data to long format for stacking beds and rooms
df_long <- df_cleaned %>%
  select(OCCUPANCY_DATE, OCCUPIED_BEDS, OCCUPIED_ROOMS) %>%
  pivot_longer(cols = c(OCCUPIED_BEDS, OCCUPIED_ROOMS), 
               names_to = "Occupancy_Type", 
               values_to = "Occupancy")

# Check the reshaped data
head(df_long)

# Create a stacked bar plot
ggplot(df_long, aes(x = OCCUPANCY_DATE, y = Occupancy, fill = Occupancy_Type)) +
  geom_bar(stat = "identity") +
  labs(title = "Daily Occupancy of Beds and Rooms Over Time",
       x = "Date",
       y = "Number of Occupied Beds/Rooms",
       fill = "Occupancy Type") +
  theme_minimal() +
  scale_fill_manual(values = c("OCCUPIED_BEDS" = "blue", "OCCUPIED_ROOMS" = "green")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Figure 2: Boxplot 

# Since occupancy rates are not directly available, calculate:
df_cleaned <- df_cleaned %>%
  mutate(OCCUPANCY_RATE_BEDS = OCCUPIED_BEDS / (OCCUPIED_BEDS + UNOCCUPIED_BEDS),
         OCCUPANCY_RATE_ROOMS = OCCUPIED_ROOMS / (OCCUPIED_ROOMS + UNOCCUPIED_ROOMS))

# Boxplot showing the distribution of occupancy rates across different shelter programs
ggplot(df_cleaned, aes(x = SHELTER_GROUP, y = OCCUPANCY_RATE_ROOMS)) +
  geom_boxplot(aes(fill = SHELTER_GROUP)) +
  labs(title = "Distribution of Room Occupancy Rates Across Shelter Programs",
       x = "Shelter Program",
       y = "Occupancy Rate (Rooms)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme(legend.position = "none")

# Figure 3: Summary Stats table

# Calculate summary statistics: average bed and room occupancy rates by shelter group
summary_stats <- df_cleaned %>%
  group_by(SHELTER_GROUP) %>%
  summarise(
    Avg_Occupancy_Rate_Beds = mean(OCCUPANCY_RATE_BEDS, na.rm = TRUE),
    Avg_Occupancy_Rate_Rooms = mean(OCCUPANCY_RATE_ROOMS, na.rm = TRUE)
  ) %>%
  arrange(desc(Avg_Occupancy_Rate_Beds))  # Sort by bed occupancy rate (descending)

# Display the summary statistics in a table format using gt
summary_stats %>%
  gt() %>%
  tab_header(
    title = "Summary of Bed and Room Occupancy Rates by Shelter Program"
  ) %>%
  fmt_percent(columns = c(Avg_Occupancy_Rate_Beds, Avg_Occupancy_Rate_Rooms), decimals = 1) %>%
  cols_label(
    Avg_Occupancy_Rate_Beds = "Average Bed Occupancy Rate",
    Avg_Occupancy_Rate_Rooms = "Average Room Occupancy Rate"
  )

# Save table 
summary_stats %>%
  gt() %>%
  gtsave("~/Desktop/summary_stats_table.html")
