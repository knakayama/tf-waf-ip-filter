resource "aws_cloudformation_stack" "waf_ip_filter" {
  name = "${var.stack_name}"

  template_body = <<EOT
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "MyIPWhilteList": {
      "Type": "AWS::WAF::IPSet",
      "Properties": {
        "Name": "${var.ip_set["name"]}",
        "IPSetDescriptors": [
          {
            "Type" : "${var.ip_set["type"]}",
            "Value" : "${var.ip_set["value"]}"
          }
        ]
      }
    },
    "MyIPSetRule" : {
      "Type": "AWS::WAF::Rule",
      "Properties": {
        "Name": "MyIPSetRule",
        "MetricName" : "MyIPSetRule",
        "Predicates": [
          {
            "DataId" : { "Ref" : "MyIPWhilteList" },
            "Negated" : false,
            "Type" : "IPMatch"
          }
        ]
      }
    },
    "MyWebACL": {
      "Type": "AWS::WAF::WebACL",
      "Properties": {
        "Name": "My web acl",
        "DefaultAction": {
          "Type": "BLOCK"
        },
        "MetricName" : "MyWebACL",
        "Rules": [
          {
            "Action" : {
              "Type" : "ALLOW"
            },
            "Priority" : 1,
            "RuleId" : { "Ref" : "MyIPSetRule" }
          }
        ]
      }
    }
  },
  "Outputs": {
    "WebAclId": {
      "Value": { "Ref": "MyWebACL" }
    }
  }
}
EOT
}
