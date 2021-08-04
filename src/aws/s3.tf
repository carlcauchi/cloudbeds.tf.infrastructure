module "s3_helmrepo" {

  #Calling s3_helmrepo module
  source = "./modules/s3_helmrepo"

  #Name of the bucket to be created
  name = "cloudbeds-helmrepo"
  #Optional: name of the logging bucket which is used to store access logs
  logging_bucket = "cloudbeds-helmrepo-logs"
  #Optional: logging directory prefix for the logging bucket used
  logging_bucket_prefix = "logs/"
  tags = {
    #AWS TAGs needed to be attached to the S3 Bucket
    "Company"     = "Cloudbeds"
    "Description" = "S3 Bucket to store Helm Charts"
  }

}