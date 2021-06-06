import json
import boto3
import os
from PIL import Image

S3 = boto3.client('s3')

# Size of generated thumbnail
THUMBNAIL_SIZE = 400, 400

# Thumbnail prefix on S3 bucket
THUMBNAIL_PREFIX = "thumb_"

# Content file path (store S3 Bucket files list)
CONTENT_FILE_KEY = "content.json"


def download_s3_file(bucket, key):
    """
    Download S3 file to /tmp folder
    :param bucket: S3 Bucket
    :param key: S3 Key
    :return: Downloaded file path
    """
    filename = os.path.join("/tmp", key)
    S3.download_file(Bucket=bucket, Key=key, Filename=filename)
    return filename


def make_thumbnail(input_file):
    """
    Make the thumbnail
    :param input_file: Input file
    :return: Thumbnail path
    """
    image = Image.open(input_file)
    image.thumbnail(THUMBNAIL_SIZE)
    thumbnail = os.path.join("/tmp", THUMBNAIL_PREFIX + os.path.basename(input_file))
    image.save(thumbnail)
    return thumbnail


def should_create_thumbnail(s3_key):
    """
    Return true if this lambda should create a thumbnail
    :param s3_key: S3 Key
    :return: True if this lambda should create a thumbnail
    """
    return not s3_key.startswith(THUMBNAIL_PREFIX)


def update_content_file(s3_bucket, s3_key):
    """
    Update content file (file listing)
    :param s3_bucket: S3 bucket name
    :param s3_key: S3 Key
    """
    content = json.loads(S3.get_object(Bucket=s3_bucket, Key=CONTENT_FILE_KEY)['Body'].read().decode('utf-8'))
    content.insert(0, {"filename": s3_key, "thumbnail": THUMBNAIL_PREFIX + s3_key})
    S3.put_object(Body=json.dumps(content), Bucket=s3_bucket, Key=CONTENT_FILE_KEY, ContentType="application/json")


def handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    if should_create_thumbnail(key):
        s3_file = download_s3_file(bucket, key)
        thumbnail_file = make_thumbnail(s3_file)
        S3.upload_file(
            Filename=thumbnail_file,
            Bucket=bucket,
            Key=THUMBNAIL_PREFIX + key
        )
        update_content_file(bucket, key)
