resource "azurerm_resource_group" "new" {
  name     = "${local.name}-rg-${var.env}"
  location = var.location

  tags = merge(var.common_tags, {

  })
}

module "ctags" {
  #checkov:skip=CKV_TF_1
  #checkov:skip=CKV_TF_2
  source       = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment  = var.env
  product      = var.product
  builtFrom    = var.builtFrom
  expiresAfter = var.expiresAfter
}
