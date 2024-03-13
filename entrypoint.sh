#!/bin/bash

#Get the Github token and Giphy API key from Github Actions inputs
GITHUB_TOKEN=$1
GIPHY_API_KEY=$2

#Get the Pull Request number from the Github event payload to comment on that PR
pull_request_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
echo PR Number - $pull_request_number

#Use a Giphy API to get a random gif
giphy_response=&(curl -s https://api.giphy.com/v1/gifs/random?api_key=$GIPHY_API_KEY&tag=thank+you&rating=g)
echo Giphy Response - $giphy_response

#Extract GIF URL from the Giphy response
gif_url=$(echo "$giphy_response" | jq --raw-output .data.images.downsized.url)
echo GIPHY_URL - $gif_url

#Create a comment with the GiF on the Pull Request
comment_response=$(curl -sX POST -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    -d "{\"body\": \"### PR -#$pull_request_number. \n ### Thank you for this contribution! \n   ![GIF]($gif_url) \"}" \
    "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$pull_request_number/comments")

#Extract and print the comment URL
comment_url=$(echo "$comment_response" | jq --raw-output .html_url)