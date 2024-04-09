# --------------------------------
# EventBridge
# --------------------------------

# Create an EventBridge rule to trigger the CodeBuild project on a push to the repository
resource "aws_cloudwatch_event_rule" "codebuild_event_rule" {
  name        = "${var.project}-${var.environment}-codebuild-event-rule"
  description = "EventBridge rule to trigger CodeBuild project on push to repository"
  event_pattern = jsonencode({
    source      = ["aws.codecommit"],
    detail-type = ["CodeCommit Repository State Change"],
    detail = {
      "event"         = ["referenceCreated", "referenceUpdated"]
      "referenceType" = ["branch"]
      "referenceName" = ["${var.source_code_branch}"]
    }
  })
}

# Create a target for the EventBridge rule to trigger the CodeBuild project
resource "aws_cloudwatch_event_target" "codebuild_event_target" {
  rule     = aws_cloudwatch_event_rule.codebuild_event_rule.name
  arn      = aws_codepipeline.codepipeline.arn
  role_arn = aws_iam_role.eventbridge_role.arn

}