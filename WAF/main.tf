resource "aws_wafv2_web_acl" "web_acl" {
  name        = var.web_acl_name
  description = "Fabric WAF statement"
  scope       = var.web_acl_scope
  tags = {
    Cost             = var.cost_tag
    Environment      = var.environment
    VantaUserData    = var.vanta_user_data
    VantaOwner       = var.vanta_owner_email
    VantaNonProd     = var.vanta_non_prod
    VantaDescription = "Web Application Firewall Rules for Fabric"
  }

  default_action {
    block {}
  }

  rule {
    name     = var.rule_name1
    priority = 0

    action {
      count {}
    }

    statement {
      rate_based_statement {
        limit              = var.waf_rate_limit
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Blocked-rule-metric"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = var.rule_name2
    priority = 1

    action {
      allow {}
    }

    statement {
      or_statement {
        statement {
          byte_match_statement {
            search_string         = "Apache-HttpClient/4.5.5 (Java/1.8.0_212)"
            positional_constraint = "EXACTLY"
            text_transformation {
              priority = 0
              type     = "NONE"
            }
            field_to_match {
              single_header {
                name = "user-agent"
              }
            }
          }
        }
        statement {
          byte_match_statement {
            search_string         = "Atlassian Webhook HTTP Client"
            positional_constraint = "EXACTLY"
            text_transformation {
              priority = 0
              type     = "NONE"
            }
            field_to_match {
              single_header {
                name = "user-agent"
              }
            }
          }
        }
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.vpn_ipsets.arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Allowed-rule-metric"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
    priority = 2
    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name = "AWSManagedRulesAdminProtectionRuleSet"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAdminProtectionRuleSet"
    } 
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 3
    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name = "AWSManagedRulesAmazonIpReputationList"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
    } 
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 4
    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name = "AWSManagedRulesAnonymousIpList"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
    } 
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 5
    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name = "AWSManagedRulesCommonRuleSet"
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
    } 
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "Fabric-WAF-metric"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_ip_set" "vpn_ipsets" {
  name               = var.vpn_ipsets_name
  description        = "ip set for fabric"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.vpn_ipsets
}

data "aws_lb" "alb" {
  name = var.alb
}

resource "aws_wafv2_web_acl_association" "resources" {
  resource_arn = data.aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}

resource "aws_cloudwatch_log_group" "aws_waf_logs_fabric_dev" {
  name = "aws-waf-logs-fabric-dev"
  retention_in_days = 365

  tags = {
    Name        = "aws-waf-logs-fabric-dev"
    Environment = var.environment
    Application = "waf"
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  log_destination_configs = [aws_cloudwatch_log_group.aws_waf_logs_fabric_dev.arn]
  resource_arn            = aws_wafv2_web_acl.web_acl.arn
  redacted_fields {
    single_header {
      name = "user-agent"
    }
  }
}
