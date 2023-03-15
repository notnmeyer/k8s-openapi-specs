#!/usr/bin/env bash
set -eu

v2="$1"
dir="$(dirname $v2)"
file="$(basename $v2)"
v3="${dir}/v3__${file}"
v3_tmp="${v3}.tmp"

if ! which api-spec-converter &>/dev/null
then
  npm install -g api-spec-converter
fi


api-spec-converter --from=swagger_2 --to=openapi_3 \
  --syntax=json --order=alpha \
  "$v2" > "$v3"

# ensure the file is pretty printed
jq . "$v3" > "${v3_tmp}"
mv "$v3_tmp" "$v3"

# insert x-optic-url
x_optic_url="https://app.useoptic.com/organizations/d0b86192-cbfb-43b7-bf64-f2fc7b6b5504/apis/BqFmcyhiv6PjRqssIZIJg"
additional_json="{\"openapi\":\"3.0.0\",\"x-optic-url\": \"${x_optic_url}\"}"

cat "$v3" | jq ". + ${additional_json}" > "$v3_tmp"
mv "$v3_tmp" "$v3"