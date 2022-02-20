#!/bin/bash

echo "::notice:: kuboard deploy action start running..."

DEPLOY_USER=$1
DEPLOY_ACCESS_KEY=$2
DEPLOY_KIND=$3
DEPLOY_NAMESPACE=$4
DEPLOY_SERVER_NAME=$5
DEPLOY_IMAGE=$6
DEPLOY_API_URL=$7

IMAGE_ARR=(${DEPLOY_IMAGE/:/ })
echo "::notice:: deploy user={${DEPLOY_USER}},kind={${DEPLOY_KIND}},namespace={${DEPLOY_NAMESPACE}},server_name={${DEPLOY_SERVER_NAME}} "

DEPLOY_IMAGE_NAME=${IMAGE_ARR[0]}
DEPLOY_VERSION=${IMAGE_ARR[1]}
# version empty , use latest
if [ "x${DEPLOY_VERSION}" == "x" ]; then
  echo "::notice:: image tag is null, use latest"
    DEPLOY_VERSION=latest
fi
echo "::notice:: deploy image={${DEPLOY_IMAGE_NAME}:${DEPLOY_VERSION}}"

# build param json
HEADER_CONTENT="Cookie: KuboardUsername=${DEPLOY_USER}; KuboardAccessKey=${DEPLOY_ACCESS_KEY}"
PARAM_CONTENT='{"kind":"'${DEPLOY_KIND}'","namespace":"'${DEPLOY_NAMESPACE}'","name":"'${DEPLOY_SERVER_NAME}'","images":{"'${DEPLOY_IMAGE_NAME}'":"'${DEPLOY_IMAGE_NAME}':'${DEPLOY_VERSION}'"}}'
echo "curl -sS -X PUT \
    -w %{http_code} \
    -o .__deploy_response.json \
    -H \"content-type: application/json\" \
    -H \"${HEADER_CONTENT}\" \
    -d '${PARAM_CONTENT}' \
    ${DEPLOY_API_URL}"
# request deploy api

echo $PARAM_CONTENT > .__deploy_param.json
cat .__deploy_param.json
HTTP_CODE=$(curl -sS  -X PUT \
    -w %{http_code} \
    -o ".__deploy_response.json" \
    -H "content-type: application/json" \
    -H "${HEADER_CONTENT}" \
    -d '@.__deploy_param.json' \
    ${DEPLOY_API_URL})

RESPONSE_CONTENT=`cat .__deploy_response.json`
rm -rf .__deploy_param.json
rm -rf .__deploy_response.json
if [ $HTTP_CODE -ge 200 ] && [ $HTTP_CODE -lt 400 ]; then
  echo "::notice:: request deploy api response http_code is ${HTTP_CODE}"
  echo "::notice:: kuboard deploy request success!"
  exit 0
fi

echo "::error:: request deploy api response http_code is {${HTTP_CODE}}"
echo "::group::request_result"
echo $RESPONSE_CONTENT | jq .
echo "::endgroup::"
echo "::notice:: kuboard deploy action end"
exit 1