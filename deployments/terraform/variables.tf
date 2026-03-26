variable "scraper_password" {
  type        = string
  description = "The password for the scraper microservice's user"
  nullable    = false
}

variable "reader_password" {
  type        = string
  description = "The password for the reader microservice's user"
  nullable    = false
}

variable "admin_password" {
  type        = string
  description = "The password for the admin user"
  nullable    = false
}

variable "admin_user" {
  type        = string
  description = "The username for the admin user"
  nullable    = false
}
