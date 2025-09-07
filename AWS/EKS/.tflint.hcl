config {    
 module = true    
 force = false    
 disabled_by_default = false 
}
plugin "aws" {
    enabled = true
    version = "0.22.1"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "aws_resource_missing_tags" {
  enabled = true
  tags = ["Name", "Environment", "Cost"]
}


# Enforces naming conventions
rule "terraform_naming_convention" {
    enabled = true
    
    #Require specific naming structure
    variable {
        format = "snake_case"
    }
    
    locals {
        format = "snake_case"
    }
    
    output {
        format = "snake_case"
    }
    
    #Allow any format
    resource {
        format = "none"
    }
    
    module {
        format = "none"
    }
    
    data {
        format = "none"
    }
}