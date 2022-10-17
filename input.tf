variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  type    = string
  default = "Basic"
  validation {
    condition     = contains(["Basic", "Premium", "Developer"], var.sku)
    error_message = "Only the Developer & Premium tier support the Private Endpoint for the Landing Zone."
  }
}

variable "capacity" {
  type    = number
  default = 1
  # validation {
  #   condition     = var.sku == "Premium" && contains(["1", "2"], format("%d", var.capacity)) || var.sku == "Developer" && contains(["1"], format("%d", var.capacity))
  #   error_message = "Based on the sku the the number of deployed units must my allowed integer number."
  # }
}

variable "publisher_name" {
  type = string
}

variable "publisher_email" {
  type = string
}

variable "additional_tags" {
  default = {}
  type    = map(string)
}

variable "private_dns_info" {
  type = object({
    zone_name           = string
    resource_group_name = string
  })
  default = {
    resource_group_name = null
    zone_name           = null
  }
}

variable "virtual_network_type" {
  type    = string
  default = "None"
  validation {
    condition     = contains(["None", "External", "Internal"], var.virtual_network_type)
    error_message = "Only one of these values None, External, Internal is allowed."
  }
}

variable "subnet_id" {
  type = string
}

variable "key_vault_id" {
  type    = string
  default = null
}

variable "secret_id" {
  type    = string
  default = null
}

#-------------------------------------------------------
# For monitoring solution
#-------------------------------------------------------
variable "elk_eventhub_name" {
  type    = string
  default = null
}

variable "elk_eventhub_namespace_auth_rule_id" {
  type    = string
  default = null
}

variable "log_analytics_workspace_id" {
  type    = string
  default = null
}
