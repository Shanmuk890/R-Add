# Load the plumber, googleAuthR, googleCloudStorageR, and logger packages
library(plumber)
library(googleAuthR)
library(googleCloudStorageR)
library(logger)

# Set the name of your Cloud Storage bucket
bucket_name <- "bucketcloudr"

#* @get /sum
#* @param a First number
#* @param b Second number
#* @response 200 Returns the sum of two numbers
function(a, b) {
  # Convert input to numeric and sum them
  a <- as.numeric(a)
  b <- as.numeric(b)
  
  if (is.na(a) | is.na(b)) {
    return(list(error = "Both a and b must be valid numbers"))
  }
  
  # Sum the numbers
  result <- a + b
  # Create the output text
  output_text <- paste("Sum of", a, "and", b, "is", result)
  
  # Authenticate with Google Cloud (this is handled automatically on Cloud Run)
  gcs_auth()
  
  # Upload the result to Cloud Storage (bucketcloudr)
  gcs_upload(textConnection(output_text), bucket = bucket_name, name = "output.txt")
  
  # Return the result
  return(list(sum = result, message = "Result uploaded to GCS"))
}
