module "s3_helmrepo" {

  source = "./modules/s3_helmrepo"

  name = "cloudbeds-helmrepo"
  logging_bucket = "cloudbeds-helmrepo-logs"
  logging_bucket_prefix = "logs/"
  tags = {
      "Company" = "Cloudbeds"
      "Description" = "S3 Bucket to store Helm Charts"
  }

}

output "s3_bucket" {
  value = module.s3_helmrepo.s3_bucket
}