variable "packet_token" {
    type = string
}

variable "packet_ssh_key" {
    type = string
}

variable "github_user" {
    default = "RuRuTiaSaMa"
}

variable "github_token" {
    type = string
}

variable "github_build_repo" {
    default = "RuRuTiaSaMa/maou-clang-build"
}

variable "github_release_repo" {
    default = "RuRuTiaSaMa/maou-clang"
}

variable "github_run_id" {
    default = ""
}

variable "git_author_name" {
    type = string
}

variable "git_author_email" {
    type = string
}

variable "telegram_chat_id" {
    default = ""
}

variable "telegram_token" {
    default = ""
}

variable "project_id" {
    default = "f4d3fade-a524-4536-8fe8-a710fbba9929"
}

variable "hostname" {
    default = "maou-clang-builder-01"
}
