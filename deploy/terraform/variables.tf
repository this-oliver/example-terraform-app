variable "nginx_config" {
  description = "Path to the Nginx configuration file for the hilma container"
  type        = string
  default     = "/absolute/path/to/nginx/default.conf"
}

variable "app_image" {
  description = "Docker image for the application"
  type        = string
  default     = "thisoliver/example-terraform-app:latest"
}