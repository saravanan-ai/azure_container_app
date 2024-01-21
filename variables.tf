variable "region" {
  description = "Azure infrastructure region"
  type    = string
  default = "westus"
}

variable "app" {
  description = "Application that we want to deploy"
  type    = string
  default = "testapp"
}

variable "env" {
  description = "Application environment to be created for the app"
  type    = string
  default = "staging"
}

variable "location" {
  description = "Location short name"
  type    = string
  default = "us"
}


variable "prefix" {
  description = "Setting the prefix "
  type    = string
  default = "pre"
}

