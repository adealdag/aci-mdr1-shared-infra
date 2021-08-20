terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "cisco-dcn-ecosystem"

    workspaces {
      name = "adealdag_mdr1_lab"
    }
  }
}