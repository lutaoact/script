data='{"namespace":"library","name":"nginx","logoUrl":"","summary":"this is a longgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg summary","description":"nginx is great and great and great.","origin":"docker","labels":["database","server"],"tags":["1.0","1.1"],"codeSource":"github","isPub":true,"createdAt":"0001-01-01T00:00:00Z","updatedAt":"0001-01-01T00:00:00Z","deletedAt":"0001-01-01T00:00:00Z"}'
data='{"namespace":"library","name":"nginx","logoUrl":"","summary":"this is a short summary","description":"nginx is great and great and great.","origin":"docker","labels":["database","server"],"tags":["1.0","1.1"],"codeSource":"github","isPub":true,"createdAt":"0001-01-01T00:00:00Z","updatedAt":"0001-01-01T00:00:00Z","deletedAt":"0001-01-01T00:00:00Z"}'

# 没有origin字段，测试自动添加
data='{"namespace":"library","name":"nginx","logoUrl":"","summary":"this is a short summary","description":"nginx is great and great and great.","labels":["web","server"],"tags":["1.0","1.1"],"codeSource":"github","isPub":true}'
data='{"namespace":"lutaoact","name":"nginx","logoUrl":"","summary":"this is a short summary","description":"nginx is great and great and great.","labels":["web","server"],"tags":["1.0","1.1"],"codeSource":"github","isPub":true}'

# repo
curl -v 'http://127.0.0.1:8086/v1/hub/namespaces/library/repos/nginx'

curl -v -H "Content-Type: application/json" -d "$data" 'http://localhost:8086/v1/hub/namespaces/library/repos'
curl -v -H "Content-Type: application/json" -d "$data" 'http://localhost:8086/v1/hub/namespaces/lutaoact/repos'
curl -v -H "Content-Type: application/json" -d "$data" 'http://localhost:8087/v1/hms/namespaces/library/repos'

# 不合法数据
illegalData='{"namespace":"library","name":"nginx..2","logoUrl":"","summary":"this is a short summary","description":"nginx is great and great and great.","origin":"docker","labels":["database","server"],"tags":["1.0","1.1"],"codeSource":"github","isPub":true,"createdAt":"0001-01-01T00:00:00Z","updatedAt":"0001-01-01T00:00:00Z","deletedAt":"0001-01-01T00:00:00Z"}'
curl -v -H "Content-Type: application/json" -d "$illegalData" 'http://localhost:8086/v1/hub/namespaces/library/repos'

# image
curl 'http://localhost:8087/v1/hms/namespaces/library/repos/nginx/tags'
curl 'http://localhost:8086/v1/hub/namespaces/library/repos/nginx/tags'

# 收藏
curl -v -X POST 'http://localhost:8087/v1/hms/namespaces/library/repos/nginx/star?star=2'
curl -v -X POST 'http://localhost:8086/v1/hub/namespaces/library/repos/nginx/star?star=2'
