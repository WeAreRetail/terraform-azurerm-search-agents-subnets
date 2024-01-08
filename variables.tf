# https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security?tabs=azure-portal#azure-storage-cross-region-service-endpoints
variable "disaster_recovery" {
  type        = bool
  description = "To return the resource in the correct region"
}
