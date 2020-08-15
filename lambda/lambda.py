import boto3

from PIL import Image

s3 = boto3.client('s3')


def handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    print("Image: {}".format(Image))
    print("Bucket {}".format(bucket))
    print("Key {}".format(key))
