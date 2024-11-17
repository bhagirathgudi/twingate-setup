variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "twingate_token" {
  type      = string
  sensitive = true
}

variable "tg_network" {
  type = string
}

variable "remote_nw_id" {
  type = string
}

variable "subnet_range" {
  type = string
}

variable "subnet_name" {
  type = string
}