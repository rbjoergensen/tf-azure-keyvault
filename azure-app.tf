resource "azuread_application" "main" {
  count = var.create_az_application == true ? 1 : 0

  display_name = local.application_name
}

resource "azuread_service_principal" "main" {
  count = var.create_az_application == true ? 1 : 0

  application_id               = azuread_application.main.0.application_id
  app_role_assignment_required = false
}

resource "azuread_application_certificate" "main" {
  count = var.create_az_application == true ? 1 : 0

  application_object_id = azuread_application.main.0.id
  type                  = "AsymmetricX509Cert"
  value                 = azurerm_key_vault_certificate.main.0.certificate_data_base64
  end_date              = "2032-02-01T00:00:00Z"
  #end_date              = timeadd(timestamp(), "87600h") # 10 years
}

resource "azurerm_key_vault_certificate" "main" {
  count = var.create_az_application == true ? 1 : 0

  name         = local.certificate_name
  key_vault_id = azurerm_key_vault.main.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=${local.certificate_name}"
      validity_in_months = 1200
    }
  }

  tags = {
    managed-by = "terraform"
  }
}