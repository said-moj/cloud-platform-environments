terraform {
  backend "s3" {}
}

provider "aws" {
  region = "eu-west-1"
}

module "vv-ecr-cred" {
  source    = "github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials?ref=2.0"
  repo_name = "vv-k8s-deploy-test-app"
  team_name = "test-webops"
}

resource "kubernetes_secret" "ecr-repo" {
  metadata {
    name      = "ecr-repo-vv-myapp-dev"
    namespace = "vv-myapp-dev"
  }

  data {
    repo_url          = "${module.vv-ecr-cred.repo_url}"
    access_key_id     = "${module.vv-ecr-cred.access_key_id}"
    secret_access_key = "${module.vv-ecr-cred.secret_access_key}"
  }
}
