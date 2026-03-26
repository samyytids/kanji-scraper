terraform {
  backend "local" {
    prefix = "/opt/terraform-state/kanji-scraper/terraform.tfstate"
  }
}
