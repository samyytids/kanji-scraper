locals {
  collections = toset([
    "kanji",
    "radicals",
    "words",
    "tags"
  ])
}

terraform {
  required_providers {
    mongodb = {
      source  = "FelGel/mongodb"
      version = "2.0.4"
    }
    mongodbadmin = {
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

provider "mongodbadmin" {
  host          = "localhost"
  port          = 27017
  username      = var.admin_user
  password      = var.admin_password
  auth_database = "admin"
}

resource "mongodb_database" "kanji" {
  provider = mongodbadmin
  name     = "kanji"
}

resource "mongodb_role" "app_writer" {
  provider  = mongodbadmin
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
  provider = mongodbadmin
  username = "scraper"
  password = var.scraper_password
  database = mongodb_database.kanji.name

  roles {
    role     = mongodb_role.app_writer.role_name
    database = mongodb_database.kanji.name
  }
}

resource "mongodb_user" "read_only" {
  provider = mongodbadmin
  username = "reader"
  password = var.reader_password
  database = mongodb_database.kanji.name

  roles {
    role     = "read"
    database = mongodb_database.kanji.name
  }
}

resource "mongodb_db_collection" "collection" {
  provider = mongodb

  for_each = local.collections
  db       = mongodb_database.kanji.name
  name     = each.value
}

