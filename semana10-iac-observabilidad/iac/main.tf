terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "documentacion_infra" {
  filename = "${path.module}/infra-generada.txt"
  content  = "Infraestructura documentada como codigo para ADSO DevOps - Semana 10"
}

output "archivo_generado" {
  value = local_file.documentacion_infra.filename
}
