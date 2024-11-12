# Load the plumber, googleAuthR, googleCloudStorageR, and logger packages
library(plumber)
library(googleAuthR)
library(googleCloudStorageR)
library(logger)

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

  output_path <- "/mnt/my-volume-r/output.txt"
  # Return the result
  return(list(sum = result))
}
