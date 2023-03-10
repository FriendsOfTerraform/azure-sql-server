variable "azure" {
  type = object({
    resource_group_name = string
    location            = optional(string, null)
  })

  description = "Where the resources will be deployed on"
}

variable "name" {
  type        = string
  description = "The name of the SQL server"
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags for the SQL server"
  default     = {}
}

variable "additional_tags_all" {
  type        = map(string)
  description = "Additional tags for all resources in deployed with this module"
  default     = {}
}

variable "azure_ad_authentication" {
  type = object({
    object_id = string
    tenant_id = optional(string, null)
  })

  description = "Defines an Azure AD identity as administrator for this SQL server, can be used with SQL Authentication"
  default     = null
}

variable "connection_policy" {
  type        = string
  description = "Defines the connection policy this server will use. Valid values are: Default, Proxy, and Redirect"
  default     = "Default"
}

variable "databases" {
  type = map(object({
    additional_tags           = optional(map(string), {})
    backup_storage_redundancy = optional(string, "Geo")
    bring_your_own_license    = optional(bool, false)
    collation                 = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    create_mode               = optional(string, "Default")
    data_max_size             = optional(number, 2)

    dtu_model = optional(object({
      tier = string # Basic, Standard, Premium
      dtu  = optional(number, null)
    }))

    vcore_model = optional(object({
      tier                        = string # GeneralPurpose, Hyperscale, Serverless
      vcores                      = number
      auto_pause_delay_in_minutes = optional(number, -1)
      compute                     = optional(string, "Gen5")
      min_vcores                  = optional(number, 1)
    }))

    ledger_enabled         = optional(bool, false)
    read_scale_out_enabled = optional(bool, null)
    restore_point_in_time  = optional(string, null)
    source_database_id     = optional(string, null)
    zone_redundant         = optional(bool, false)
  }))

  description = "Defines multiple databases"
  default     = {}
}

variable "failover_groups" {
  type = map(object({
    databases                       = list(string)
    secondary_server_id             = string
    additional_tags                 = optional(map(string), {})
    read_write_failover_policy      = optional(string, "Automatic")
    read_write_grace_period_minutes = optional(number, 60)
  }))

  description = "Defines SQL server failover groups"
  default     = {}
}

variable "firewall" {
  type = object({
    rules                          = map(string)
    allow_access_to_azure_services = optional(bool, false)
  })

  description = "Defines firewall rules for the SQL server"
  default     = null
}

variable "minimum_tls_version" {
  type        = string
  description = "The minimum TLS version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 , 1.2 and Disabled"
  default     = "1.2"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed for this server"
  default     = true
}

variable "outbound_network_restriction_enabled" {
  type        = bool
  description = "Whether outbound network traffic is restricted for this server"
  default     = false
}

variable "sql_authentication" {
  type = object({
    admin_username = string
    admin_password = string
  })

  description = "Defines the administrator login credential for this SQL server, can be used with AD authentication"
  default     = null
}

variable "user_assigned_managed_identity_ids" {
  type        = list(string)
  description = "List of managed identity IDs used by the SQL server to manage Azure resources"
  default     = []
}

variable "server_version" {
  type        = string
  description = "The version for the SQL server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)"
  default     = "12.0"
}