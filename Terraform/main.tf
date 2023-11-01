terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.9.1"
    }
  }
}

provider "azuredevops" {
  org_service_url       = var.azdo_org_service_url
  personal_access_token = var.azdo_pat
}

resource "azuredevops_project" "MyPortfolio" {
  name               = "MyPortfolio"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Scrum"
  description        = "Testing"
  features = {
    "boards"        = "enabled"
    "repositories"  = "enabled"
    "pipelines"     = "enabled"
    "testplans"     = "disabled"
    "artifacts"     = "enabled"
  }
}

resource "azuredevops_project_pipeline_settings" "MyPortfolio" {
  project_id = azuredevops_project.MyPortfolio.id

  enforce_job_scope = true
  enforce_referenced_repo_scoped_token = false
  enforce_settable_var = true
  publish_pipeline_metadata = false
  status_badges_are_private = true
}

resource "azuredevops_git_repository" "MyPortfolio" {
  project_id = azuredevops_project.MyPortfolio.id
  name = "MyPortfolio"

  initialization {
    init_type = "Clean"
  }
  lifecycle {
    ignore_changes = [initialization]
  }
}

data "azuredevops_git_repository" "MyPortfolio" {
  project_id = azuredevops_project.MyPortfolio.id
  name       = "MyPortfolio"
}

resource "azuredevops_agent_pool" "MyPortfolio" {
  name = "MyPortfolio-Pool"
}

resource "azuredevops_agent_queue" "MyPortfolio" {
  project_id    = azuredevops_project.MyPortfolio.id
  agent_pool_id = azuredevops_agent_pool.MyPortfolio.id
}

resource "azuredevops_pipeline_authorization" "MyPortfolio" {
  project_id  = azuredevops_project.MyPortfolio.id
  resource_id = azuredevops_agent_queue.MyPortfolio.id
  type        = "queue"
}

resource "azuredevops_serviceendpoint_runpipeline" "MyPortfolio" {
  project_id            = azuredevops_project.MyPortfolio.id
  service_endpoint_name = "Example Pipeline Runner"
  organization_name     = "Kyuudou"
  auth_personal {
    # Also can be set with AZDO_PERSONAL_ACCESS_TOKEN environment variable
    personal_access_token = var.azdo_pat
  }
  description = "Managed by Terraform"
}

resource "azuredevops_build_definition" "build_definition" {
  project_id = azuredevops_project.MyPortfolio.id
  name       = "My Awesome Build Pipeline"
  path       = "\\ExampleFolder"

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.MyPortfolio.id
    branch_name = azuredevops_git_repository.MyPortfolio.default_branch
    yml_path    = "./DevOps/azure-pipelines.yml"
  }
  //  variable_groups = [azuredevops_variable_group.vg.id]
}

// This section configures an Azure DevOps Variable Group
resource "azuredevops_variable_group" "vg" {
  project_id   = azuredevops_project.project.id
  name         = "Sample VG 1"
  description  = "A sample variable group."
  allow_access = true

  variable {
    name      = "key1"
    value     = "value1"
    is_secret = true
  }

  variable {
    name  = "key2"
    value = "value2"
  }

  variable {
    name = "key3"
  }
}
