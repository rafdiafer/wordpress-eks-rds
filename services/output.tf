output "dynamodb_tf_state_lock" {
  value = aws_dynamodb_table.dynamodb_tf_state_lock.id
}

output "s3_tf_state" {
  value = aws_s3_bucket.s3_tf_state.id
}