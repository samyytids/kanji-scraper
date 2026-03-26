terraform {
  required_providers {
    mongodb = {
      source  = "therealkaban9/mongodb"
      version = "~> 1.0"
    }
  }
}

provider "mongodb" {
  host          = "localhost"
  port          = 27017
  username      = var.admin_user
  password      = var.admin_password
  auth_database = "admin"
}

resource "mongodb_database" "kanji" {
  name = "kanji"
}

resource "mongodb_role" "app_writer" {
  role_name = "applicationWriter"
  database  = mongodb_database.kanji.name
  privileges {
    resource {
      database   = mongodb_database.kanji.name
      collection = ""
    }
    actions = [
      "find",
      "insert",
      "update"
    ]
  }
}

resource "mongodb_user" "scraper" {
  username = "scraper"
  password = var.scraper_password
  database = mongodb_database.kanji.name
  roles {
    role     = mongodb_role.app_writer.role_name
    database = mongodb_database.kanji.name
  }
}

resource "mongodb_user" "read_only" {
  username = "reader"
  password = var.reader_password
  database = mongodb_database.kanji.name
  roles {
    role = "read"
    database = mongodb_database.kanji.name
  }
}
