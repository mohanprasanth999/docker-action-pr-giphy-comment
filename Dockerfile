# Container image that runs your code
FROM alpine:3.10

#Install necessary packages #Installing curl for making calls to REST API and jq for passing json and extracting url of images
RUN apk update && \
    apk add --no-cache curl jq  

#This file contains the logic for making acall to giphy API, filtering the response and posting a comment to Github
COPY entrypoint.sh /entrypoint.sh

#Make script executable
RUN chmod +x /entrypoint.sh

#Code file execute when docker container start
ENTRYPOINT ["entrypoint.sh"]


