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
    allow {}
  }

  rule {
    name     = "UAT-Rate-Limit"
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
    name     = "Login_Ratelimit"
    priority = 1

    action {
      captcha {}
    }
    statement {
      rate_based_statement {
        limit              = 100
        aggregate_key_type = "IP"
        scope_down_statement {
          or_statement {
            statement {
              byte_match_statement {
                search_string = "/auth/login/"
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 0
                  type = "NONE"
                }
                positional_constraint = "CONTAINS"
              }
            }
            statement {
              byte_match_statement {
                search_string = "/rest/v1/users/login/authenticate"
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 0
                  type = "NONE"
                }
                positional_constraint = "CONTAINS"
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Login_Ratelimit"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "Ratelimit_ForgetPassword"
    priority = 2

    action {
      captcha {}
    }
    statement {
      rate_based_statement {
        limit              = 100
        aggregate_key_type = "IP"
        scope_down_statement {
          or_statement {
            statement {
              byte_match_statement {
                search_string = "/auth/login/#forgotpassword"
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 0
                  type = "NONE"
                }
                positional_constraint = "CONTAINS"
              }
            }
            statement {
              byte_match_statement {
                search_string = "/rest/v1/users/forgotpassword"
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 0
                  type = "NONE"
                }
                positional_constraint = "CONTAINS"
              }
            }
            statement {
              byte_match_statement {
                search_string = "/auth/login/#forgotpassword#invalid"
                field_to_match {
                  uri_path {}
                }
                text_transformation {
                  priority = 0
                  type = "NONE"
                }
                positional_constraint = "CONTAINS"
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Ratelimit_ForgetPassword"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
    priority = 3
    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name = "AWSManagedRulesAdminProtectionRuleSet"
        rule_action_override {
          name = "AdminProtection_URIPATH"
          action_to_use {
            count {}
          }
          
        }
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
    priority = 4
    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name = "AWSManagedRulesAmazonIpReputationList"
        rule_action_override {
          name = "AWSManagedIPReputationList"
          action_to_use {
            count {}
          }
          
        }
        rule_action_override {
          name = "AWSManagedReconnaissanceList"
          action_to_use {
            count {}
          }
          
        }

        rule_action_override {
          name = "AWSManagedIPDDoSList"
          action_to_use {
            count {}
          }
          
        }
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
    priority = 5
    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name = "AWSManagedRulesAnonymousIpList"
        rule_action_override {
          name = "AnonymousIPList"
          action_to_use {
            count {}
          }
          
        }
        rule_action_override {
          name = "HostingProviderIPList"
          action_to_use {
            count {}
          }
          
        }

        rule_action_override {
          name = "AWSManagedIPDDoSList"
          action_to_use {
            count {}
          }
          
        }
      }
    }
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
    } 
  }

  rule {
    name     = "Fabric_SizeRestrictions_QUERYSTRING"
    priority = 6

    action {
      count {}
    }
    statement {
      size_constraint_statement {
        field_to_match {
          query_string {}
        }
        comparison_operator = "GE"
        size = 10000
        text_transformation {
          priority = 0
          type = "NONE"
        }
        
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Fabric_SizeRestrictions_QUERYSTRING"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "Fabric_SizeRestrictions_BODY"
    priority = 7

    action {
      count {}
    }
    statement {
      size_constraint_statement {
        field_to_match {
          body {
            oversize_handling = "MATCH"
          }
        }
        comparison_operator = "GT"
        size = 20000
        text_transformation {
          priority = 0
          type = "NONE"
        }
        
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Fabric_SizeRestrictions_BODY"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "Fabric_SizeRestrictions_URIPATH"
    priority = 8

    action {
      count {}
    }
    statement {
      size_constraint_statement {
        field_to_match {
          uri_path {}
        }
        comparison_operator = "GT"
        size = 2999
        text_transformation {
          priority = 0
          type = "NONE"
        }
        
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Fabric_SizeRestrictions_URIPATH"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "Fabric_SizeRestrictions_Cookie_HEADER"
    priority = 9

    action {
      count {}
    }
    statement {
      size_constraint_statement {
        field_to_match {
          cookies {
            match_pattern {
              all {}
            }
            match_scope = "ALL"
            oversize_handling = "MATCH"
          }
        }
        comparison_operator = "GT"
        size = 20000
        text_transformation {
          priority = 0
          type = "NONE"
        }
        
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Fabric_SizeRestrictions_Cookie_HEADER"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 10
    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name = "AWSManagedRulesCommonRuleSet"
        rule_action_override {
          name =  "CrossSiteScripting_URIPATH_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "CrossSiteScripting_BODY_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "CrossSiteScripting_QUERYARGUMENTS_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "CrossSiteScripting_COOKIE_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "GenericRFI_BODY_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "RestrictedExtensions_QUERYARGUMENTS_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "RestrictedExtensions_URIPATH_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "GenericLFI_BODY_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "EC2MetaDataSSRF_BODY_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "SizeRestrictions_BODY_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "UserAgent_BadBots_HEADER_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "NoUserAgent_HEADER_RC_COUNT"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "NoUserAgent_HEADER"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "UserAgent_BadBots_HEADER"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "SizeRestrictions_QUERYSTRING"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "SizeRestrictions_Cookie_HEADER"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "SizeRestrictions_BODY"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "SizeRestrictions_URIPATH"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "EC2MetaDataSSRF_BODY"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "EC2MetaDataSSRF_COOKIE"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "EC2MetaDataSSRF_URIPATH"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "EC2MetaDataSSRF_QUERYARGUMENTS"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "GenericLFI_QUERYARGUMENTS"
            action_to_use {
              count {}
            }
        }

        rule_action_override {
          name =  "GenericLFI_URIPATH"
            action_to_use {
              count {}
            }
        }

        rule_action_override {
          name =  "GenericLFI_BODY"
            action_to_use {
              count {}
            }
        }

        rule_action_override {
          name =  "RestrictedExtensions_URIPATH"
            action_to_use {
              count {}
            }
        }

        rule_action_override {
          name =  "RestrictedExtensions_QUERYARGUMENTS"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "GenericRFI_QUERYARGUMENTS"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "GenericRFI_BODY"
            action_to_use {
              count {}
            }
        }
        rule_action_override {
          name =  "GenericRFI_URIPATH"
            action_to_use {
              count {}
            }
        }

        rule_action_override {
          name =  "CrossSiteScripting_COOKIE"
            action_to_use {
              count {}
            }
        }

        rule_action_override {
          name =  "CrossSiteScripting_QUERYARGUMENTS"
            action_to_use {
              count {}
            }
        }

        rule_action_override {
          name =  "CrossSiteScripting_BODY"
            action_to_use {
              count {}
            }
        }

        rule_action_override {
          name =  "CrossSiteScripting_URIPATH"
            action_to_use {
              count {}
            }
        }
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

resource "aws_cloudwatch_log_group" "aws_waf_logs" {
  name = "aws-waf-logs-fabric"
  retention_in_days = 365

  tags = {
    Name        = "aws-waf-logs-fabric"
    Environment = var.environment
    Application = "waf"
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  log_destination_configs = [aws_cloudwatch_log_group.aws_waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.web_acl.arn
  redacted_fields {
    single_header {
      name = "user-agent"
    }
  }
}
