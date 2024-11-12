# Load the plumber, googleAuthR, googleCloudStorageR, and logger packages
library(plumber)
library(googleAuthR)
library(googleCloudStorageR)
library(logger)

# Authenticate with Google Cloud (if not already authenticated)
# This requires environment variables for authentication (or credentials setup in the Cloud Run service)

# Set your Google Cloud project and storage bucket
gcs_bucket <- "your-bucket-name"  # replace with your actual bucket name

# Initialize logging
log_file <- "/tmp/plumber_api.log"
log_appender(appender_file(log_file))

# Create the function that sums two numbers
# This function will be exposed as an API endpoint
# The numbers will be passed as query parameters

#* @get /sum
#* @param a First number
#* @param b Second number
#* @response 200 Returns the sum of two numbers
function(a, b) {
  # Convert input to numeric and sum them
  a <- as.numeric(a)
  b <- as.numeric(b)
  
  if (is.na(a) | is.na(b)) {
    log_error("Invalid input: a = %s, b = %s", a, b)
    return(list(error = "Both a and b must be valid numbers"))
  }
  
  # Sum the numbers
  result <- a + b
  log_info("Sum calculated: %s + %s = %s", a, b, result)
  
  # Upload logs to Cloud Storage
  gs_upload(log_file, bucket = gcs_bucket, name = paste0("logs/", Sys.time(), "-sum-log.txt"))
  
  return(list(sum = result))
}
