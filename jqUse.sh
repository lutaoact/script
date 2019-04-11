#!/bin/bash -xv

admin_email="a@email.com"
admin_password="xxx"
jsonStr='{ "auth": { "identity": { "methods": [ "password" ], "password": { "user": { "name": "$admin_email", "domain": { "name": "Default" }, "password": "$admin_password" } } }, "scope": { "project": {"domain": {"id": "default"}, "name": "guard" } } } }'
jq -c '.' <<<"$jsonStr"

#jq -c 'del(.key3)' <<<"$jsonStr"
#jq -c '.auth.identity.password.user.password = $newVal' --arg newVal "$admin_password" <<< "$jsonStr"
#jq -c '.auth.identity.password.user.password = $newVal' --arg newVal "$admin_password" <<< "$jsonStr"
#jq -c '.auth.identity.password.user.name = $newVal,.auth.identity.password.user.password = $newVal2' --arg newVal "$admin_email" --arg newVal2 "$admin_password"<<< "$jsonStr"
tmp=$(jq -c '.auth.identity.password.user.name = $admin_email' --arg admin_email "$admin_email" <<< "$jsonStr")
post_body=$(jq -c '.auth.identity.password.user.password = $admin_password' --arg admin_password "$admin_password" <<< "$tmp")
