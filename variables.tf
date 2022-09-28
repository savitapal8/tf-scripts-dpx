#provider variables
variable "provider_project"{
    type = string
}
variable "provider_region"{
    type = string
}
variable "access_token"{
    type = string
    sensitive   = true
}
variable "labels"{
    type = map(object)
}
