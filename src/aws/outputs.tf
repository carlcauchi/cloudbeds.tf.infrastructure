output "s3_bucket" {
  #Output the bucket name that was created by the module
  value = module.s3_helmrepo.s3_bucket
}