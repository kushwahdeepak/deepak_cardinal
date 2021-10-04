echo start

set -x
STAGE=https://ch-job-marketplace-stage.herokuapp.com/incoming_mails
PROD=https://www.cardinaltalent.ai/incoming_mails
LOCAL=http://localhost:3000/incoming_mails
URL=$LOCAL
PDF=4700b92148cb0edf.raw


echo "posting to $URL"

curl \
-H 'connection: close' \
-H 'user-agent: CloudMailin Server' \
-H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' \
-H 'accept-encoding: gzip, compressed' \
-H 'x-request-id: 8044e8ec-42fb-414c-9ef5-887bf511268b' \
-H 'x-forwarded-for: 34.228.54.220' \
-H 'x-forwarded-proto: https' \
-H 'x-forwarded-port: 443' \
-H 'via: 1.1 vegur' \
-H 'connect-time: 0' \
-H 'x-request-start: 1595455362838' \
-H 'total-route-time: 0' \
-H 'content-length: 59954' --data-binary @4700b92148cb0edf.raw --request POST $URL

echo done posting

#open $(URL)

set +x

