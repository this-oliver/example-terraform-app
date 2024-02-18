terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx"
}

resource "docker_image" "app" {
  name         = var.app_image
}

resource "docker_network" "app_network" {
  name = "main_app_network"
}

resource "docker_container" "app" {
  image = docker_image.app.image_id
  name  = "app"
  
  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 3000
  }
}

resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.image_id
  
  networks_advanced {
    name = docker_network.app_network.name
  }
  
  ports {
    internal = 80
    external = 8080
  }
  
  volumes {
    container_path  = "/etc/nginx/conf.d/default.conf"
    host_path = var.nginx_config
    read_only = true
  }
}