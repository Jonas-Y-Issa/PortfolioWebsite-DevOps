variable "azdo_pat" {
  description = "Azure DevOps Personal Access Token"
  type        = string
  default     = "24ukw2owmpqfj25gze2nxjuhuxgerxs537z4ehfpl7ud2z6z74ra"
  sensitive   = true
}

variable "azdo_org_service_url" {
  description = "Azure DevOps Service Url"
  type        = string
  default     = "https://dev.azure.com/Kyuudou"
}