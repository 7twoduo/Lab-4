#                            Output Blocks

#####################################################################################################################
#                                           Outputs
#####################################################################################################################

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.main[0].id : null
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.main[0].domain_name : null
}

output "unshielded_url" {
  description = "Clickable apex/root domain URL."
  value       = "https://${var.root_domain_name}"
}

output "www_unshielded_url" {
  description = "Clickable www domain URL."
  value       = "https://www.${var.root_domain_name}"
}

output "vpc_cidr" {
  value = var.vpc_cidr
}
#                  Output Blocks
output "region" {
  value = data.aws_region.current.region
}
output "ami" {
  value = data.aws_ami.amazon_linux.id
}

