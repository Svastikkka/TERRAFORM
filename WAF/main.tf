resource "aws_wafv2_web_acl" "web_acl" {
  name        = var.web_acl_name
  description = "Testing WAF"
  scope       = var.web_acl_scope
  tags = {
    Cost             = "${var.cost_tag}"
    Environment      = "${var.environment}"
    VantaUserData    = var.vanta_user_data
    VantaOwner       = "${var.vanta_owner_email}"
    VantaNonProd     = var.vanta_non_prod
    VantaDescription = "Web Application Firewall Rules for Testing"
  }

  default_action {
    block {}
  }

  rule {
    name     = var.rule_name1
    priority = 0

    action {
      block {}
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
            search_string         = "Testing search sting 1"
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
            search_string         = "Testing search sting 2"
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
    name     = var.auth_rule_name
    priority = 2
    action {
      allow {}
    }

    statement {
      byte_match_statement {
        search_string         = "/auth"
        positional_constraint = "STARTS_WITH"
        text_transformation {
          priority = 0
          type     = "NONE"
        }
        field_to_match {
          uri_path {}
        }
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "Auth-testing-allowed-paths"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "testing-WAF-metric"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_ip_set" "vpn_ipsets" {
  name               = var.vpn_ipsets_name
  description        = "ip set for testing"
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

data "aws_lb" "auth_alb" {
  name = var.auth_alb
}

resource "aws_wafv2_web_acl_association" "auth_resources" {
  resource_arn = data.aws_lb.auth_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}
