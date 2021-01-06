variable "acl" {
    type = string
    default = "private"
}

variable "versioning" {
    type = bool
    default = true
}

variable "bucketName" {
    type = list(string)
    default = ["johnsterraformstatebucket1234"]
}