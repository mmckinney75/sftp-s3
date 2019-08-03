import json
import boto3
from botocore.exceptions import ClientError

s3 = boto3.client('s3')

def copy_object(src_bucket, src_object, dst_bucket, dst_object):

    try:
        s3.copy_object(CopySource={'Bucket': src_bucket, 'Key': src_object}, Bucket=dst_bucket, Key=dst_object)
    except ClientError as e:
        print(e)
        return False
    return True

def lambda_handler(event, context):

    print(json.dumps(event, indent=4, sort_keys=True))

    partner_id = event['detail']['requestParameters']['key'].split('/')[0]
    object_name = event['detail']['requestParameters']['key']
    bucket_name = event['detail']['requestParameters']['bucketName']

    print(object_name)
    print(partner_id)
    print(bucket_name)

    copy_status = copy_object(bucket_name, object_name, 'mmckinney-' + partner_id, object_name.split('/', 1)[1])
