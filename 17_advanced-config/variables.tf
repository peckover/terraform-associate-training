variable "capgemini_email" {
  description = "The email address used to tag the resources created for this lab"
  type        = string
}

variable "expiration_date" {
  description = "The expiration date used to tag the resources created for this lab"
  type        = string
}

variable "local_network_cidr" {
  type = list
}

variable "sg_ingress_rules" {
  type = list(map(string))
}

variable "shopping_list" {
  type = map(string)
}
