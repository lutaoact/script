以下为不同环境的url，调用时，请使用对应环境的账号信息
# evm
BASE_URL1='https://keapi-dev.cloudappl.com'
BASE_URL2='http://hub.ingress-dev1.cloudappl.com'

# cs
BASE_URL1='https://keapi-cs.qiniu.io'
BASE_URL2='https://hub-cs.qiniu.io'

# prd
BASE_URL1='https://keapi.qiniu.com'
BASE_URL2='https://hub.qiniu.com'

1. 获取user token，name和password参数为七牛账号和密码，也可为ak/sk。
curl -v -H "Content-Type: application/json" -d '{"name":"K-vx0YimUIllEOmg2GCLO9BBGSWgUboCDpz4NqCs","password":"xA-zkSiQr9JRL1h70HuIEyHGm3lluS7TS4tn6Rz5"}' "$BASE_URL1/v1/usertoken" | python -mjson.tool

{
    "token": {
        "expires_at": "2017-12-28T08:44:43.000000Z",
        "id": "gAAAAABaQLp7UE04P5LgKkJqOy3YCroNGaRjP5SjzXyhUwgYVe1I8DOd4YnVPbJ5emBvPL3pAaII7f_zLF5zVn9kuOKVS-lRSJlfbF8Ns4PNH54YaFhVm12IV3SLpph1yDhzRFj7r6IozBQzC3qP72ZjBDf66dYZ5A", // <= 这就是user token
        "issued_at": "2017-12-25T08:44:43.000000Z"
    },
    "user": {
        "id": "3fc83ca357aa41fabde41a3e3447ef3d", // <= 这是user id
        "name": "1810637316"
    }
}

2. list project，即namespace。将上一步获取的user token，放入header X-Auth-Token
请求的路径为：/v1/users/:userid/projects
curl -v -H "X-Auth-Token: gAAAAABaQLp7UE04P5LgKkJqOy3YCroNGaRjP5SjzXyhUwgYVe1I8DOd4YnVPbJ5emBvPL3pAaII7f_zLF5zVn9kuOKVS-lRSJlfbF8Ns4PNH54YaFhVm12IV3SLpph1yDhzRFj7r6IozBQzC3qP72ZjBDf66dYZ5A" "$BASE_URL1/v1/users/3fc83ca357aa41fabde41a3e3447ef3d/projects" | python -mjson.tool

[
    {
        "description": "",
        "name": "lutaoact" // <= 这就是project name，也就是namespace, 你们可以把project和namespace理解成相同的可以互换的概念
    }
]

3. 根据project，获取project token，这里也需要设置X-Auth-Token，跟上一步用的是一样的。路径为：/v1/projects/:project/token
curl -v -H "X-Auth-Token: gAAAAABaQLp7UE04P5LgKkJqOy3YCroNGaRjP5SjzXyhUwgYVe1I8DOd4YnVPbJ5emBvPL3pAaII7f_zLF5zVn9kuOKVS-lRSJlfbF8Ns4PNH54YaFhVm12IV3SLpph1yDhzRFj7r6IozBQzC3qP72ZjBDf66dYZ5A" "$BASE_URL1/v1/projects/lutaoact/token" | python -mjson.tool

{
    "project": "lutaoact",
    "roles": [
        "member"
    ],
    "token": {
        "expires_at": "2017-12-28T08:44:43.000000Z",
        "id": "gAAAAABaQLtj3iFA0cnuGHxD3XLqZAtXrk9M8aQz3UTwbWScAlEcKcz7MALPVila3Jj3YKxXy--R1wCz5ZhshcytqzShwdjdbYYvG86WZ5A1YA1W244IFbmsPuvZq8fr9xS29WK01kpRA6csYpA7vtX57FxfmBRJYJKM8YUH9yfHavFjwv_Jcc8VLtvhU6I1sryPiYxq8m-q", // <= 这就是project token
        "issued_at": "2017-12-25T08:48:35.000000Z"
    },
    "user": {
        "id": "3fc83ca357aa41fabde41a3e3447ef3d",
        "name": "1810637316"
    }
}

4. 根据project token可以获取所有的repo。这里设置的X-Auth-Token是上一步获取到的project token，路径为：/v1/hub/namespaces/:namespace/repos?page=0&pageSize=20
可以根据需求传递分页信息

curl -v -H "X-Auth-Token: gAAAAABaQLtj3iFA0cnuGHxD3XLqZAtXrk9M8aQz3UTwbWScAlEcKcz7MALPVila3Jj3YKxXy--R1wCz5ZhshcytqzShwdjdbYYvG86WZ5A1YA1W244IFbmsPuvZq8fr9xS29WK01kpRA6csYpA7vtX57FxfmBRJYJKM8YUH9yfHavFjwv_Jcc8VLtvhU6I1sryPiYxq8m-q" "$BASE_URL2/v1/hub/namespaces/lutaoact/repos?page=0&pageSize=20" | python -mjson.tool

{
    "page": 1,
    "pageSize": 20,
    "repos": [
        {
            "codeSource": "",
            "createdAt": "2017-12-25T16:52:45.096+08:00",
            "description": "",
            "isCertified": false,
            "isPub": false,
            "labels": [
                "database"
            ],
            "logoUrl": "",
            "name": "xxxxxx",
            "namespace": "lutaoact",
            "origin": "qiniu",
            "pulls": 0,
            "stars": 0,
            "summary": "xxxxx",
            "tags": [],
            "updatedAt": "2017-12-25T16:52:45.096+08:00"
        }
    ],
    "total": 1
}

5. 根据repo获取相应的镜像，这里用的也是project token
可以根据需求传递分页信息
curl -v -H "X-Auth-Token: gAAAAABaQLtj3iFA0cnuGHxD3XLqZAtXrk9M8aQz3UTwbWScAlEcKcz7MALPVila3Jj3YKxXy--R1wCz5ZhshcytqzShwdjdbYYvG86WZ5A1YA1W244IFbmsPuvZq8fr9xS29WK01kpRA6csYpA7vtX57FxfmBRJYJKM8YUH9yfHavFjwv_Jcc8VLtvhU6I1sryPiYxq8m-q" "$BASE_URL2/v1/hub/namespaces/lutaoact/repos/xxxxxx/tags?page=1&pageSize=20&orderBy=-updatedAt" | python -mjson.tool

{
    "images": [
        {
            "createdAt": "2017-12-25T16:59:22.249+08:00",
            "hash": "sha256:9fa82f24cbb11b6b80d5c88e0e10c3306707d97ff862a3018f22f9b49cef303a",
            "namespace": "lutaoact",
            "repoName": "xxxxxx",
            "size": 2492,
            "tag": "1",
            "updatedAt": "2017-12-25T16:59:22.249+08:00"
        }
    ],
    "page": 1,
    "pageSize": 20,
    "total": 1
}
