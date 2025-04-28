output "firehose_stream_name" {
  value = aws_kinesis_firehose_delivery_stream.cw_to_s3.name
}
