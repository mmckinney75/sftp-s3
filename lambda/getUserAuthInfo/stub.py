import os
import json
import boto3
import base64
from botocore.exceptions import ClientError

accepted_password = 'xxmikexxlogin'
accepted_username = 'mmckinney75'

def lambda_handler(event, context):
    response_data = {}


    role_arn = 'arn:aws:iam::905570331231:role/sftp_user'
    scopedown_policy = '{     \"Version\": \"2012-10-17\",     \"Statement\": [         {             \"Sid\": \"AllowListingOfUserFolder\",             \"Action\": [                 \"s3:ListBucket\"             ],             \"Effect\": \"Allow\",             \"Resource\": [                 \"arn:aws:s3:::${Transfer:HomeBucket}\"             ],             \"Condition\": {                 \"StringLike\": {                     \"s3:prefix\": [                         \"${Transfer:UserName}/*\",                         \"${Transfer:UserName}\"                     ]                 }             }         },         {             \"Sid\": \"HomeDirObjectAccess\",             \"Effect\": \"Allow\",             \"Action\": [                 \"s3:PutObject\",                 \"s3:GetObject\",                 \"s3:DeleteObjectVersion\",                 \"s3:DeleteObject\",                 \"s3:GetObjectVersion\"             ],             \"Resource\": \"arn:aws:s3:::${Transfer:HomeDirectory}*\"         },         {             \"Sid\": \"DenyDirCreation\",             \"Effect\": \"Deny\",             \"Action\": [                 \"s3:PutObject\"             ],             \"Resource\": \"arn:aws:s3:::${Transfer:HomeDirectory}/*/\"         }     ] }'


    print(event)

    if 'username' not in event or 'serverId' not in event:
        print("Invalid Authentication Event: Username or serverId missing")
        return response_data

    if 'password' not in event:
        print("Unsupported Authentication Event: Password missing, Key Auth Unsupported at this time")
        return response_data

    server = event['serverId']
    input_username = event['username']
    input_password = event['password']

    # It is recommended to verify server ID against some value, this template does not verify server ID
    print("Username: {}, ServerId: {}".format(input_username, server));

    # Check userID and password
    valid_login = check_login(input_username, input_password)

    #If the login information is valid, creating appropriate response

    if valid_login == True:
        response_data['Role'] = role_arn
        response_data['Policy'] = scopedown_policy
        response_data['HomeDirectory'] = '/mmckinney-sftp/' + input_username
#        response_data['HomeDirectoryType'] = "LOGICAL"

        print("Response Data: " + json.dumps(response_data))

        return response_data
    else:
        return {}


def check_login(id, pwd):
    if id != accepted_username:
        print("Authentication Failed: Invalid UserID")
        return False
    elif pwd != accepted_password:
        print("Authentication Failed: Invalid Password")
        return False
    else:
        print("Authentication Success: UserID and Password accepted")
        return True
