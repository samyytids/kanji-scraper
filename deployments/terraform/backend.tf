terraform {
  backend "local" {
    path = "/opt/terraform-state/kanji-scraper/terraform.tfstate"
  }
}
