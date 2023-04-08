#!/bin/bash

read -p 'enter the target domain name (example.com): ' domain
echo ''
echo ''

read -p 'enter the name of file to save the output in: ' output


# Send a GET request to DNSDumpster to retrieve the page content and obtain the csrfmiddlewaretoken value
csrf_token=$(curl -s -X GET "https://dnsdumpster.com/" | grep -oP 'name="csrfmiddlewaretoken" value="\K.*?(?=")')

# Set the POST data with the target domain and csrfmiddlewaretoken value
data="csrfmiddlewaretoken=$csrf_token&targetip=$domain&user=free"

# Set the headers with the CSRF token and referer information
headers="Referer: https://dnsdumpster.com/"
cookies="csrftoken=$csrf_token"

# Send a POST request to DNSDumpster with the target domain and csrfmiddlewaretoken value
response=$(curl -isL -X POST -H "$headers" -H "Cookie: $cookies" -d "$data" "https://dnsdumpster.com/")

# Print the response content
echo "$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}|([a-zA-Z0-9]+\.){1,}[a-zA-Z]{2,}' <<< $response | awk '{ if ($0 ~ /^[0-9]/) { ip=$0; } else { printf("%-30s %s\n", $0, ip); } }' | grep -v -E "xlsx|png|html|css|js|hackertarget\.com|HackerTarget\.com|api\.hackertarget\.com")"


# save output

echo "$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}|([a-zA-Z0-9]+\.){1,}[a-zA-Z]{2,}' <<< $response | awk '{ if ($0 ~ /^[0-9]/) { ip=$0; } else { printf("%-30s %s\n", $0, ip); } }' | grep -v -E "xlsx|png|html|css|js|hackertarget\.com|HackerTarget\.com|api\.hackertarget\.com")" > "$output"
