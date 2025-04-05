variable "client_id" {
  description = "Azure Client ID"
  type        = string
}

variable "client_secret" {
  description = "Azure Client Secret"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "jenkins-yagyesh-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "app_service_plan_name" {
  description = "App Service Plan name"
  type        = string
  default     = "jenkins-yagyesh-plan"
}

variable "app_service_name" {
  description = "App Service (Web App) name"
  type        = string
  default     = "jenkins-yagyesh-app123"
}
