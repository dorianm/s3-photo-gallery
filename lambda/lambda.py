import boto3
import os
from PIL import Image

S3 = boto3.client('s3')

THUMBNAIL_SIZE = 128, 128

THUMBNAIL_PREFIX = "thumb_"


def download_s3_file(bucket, key):
    filename = os.path.join("/tmp", key)
    S3.download_file(Bucket=bucket, Key=key, Filename=filename)
    return filename


def make_thumbnail(input_file):
    image = Image.open(input_file)
    image.thumbnail(THUMBNAIL_SIZE)
    output = os.path.join("/tmp", THUMBNAIL_PREFIX + os.path.basename(input_file))
    image.save(output)
    return output


def handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    if not key.startswith(THUMBNAIL_PREFIX):
        S3.upload_file(
            make_thumbnail(download_s3_file(bucket, key)),
            bucket,
            THUMBNAIL_PREFIX + key
        )
    else:
        print("{}: nothing to do".format(key))