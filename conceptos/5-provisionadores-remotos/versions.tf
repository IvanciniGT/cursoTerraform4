terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "3.0.2"
        }
        null = {
          source = "hashicorp/null"
          version = "3.2.2"
        }
    }
}

provider "null" {
  # Configuration options
}
provider "docker" {
}
