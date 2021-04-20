# Server

A demo of PerfectHTTP .

routes:
web: http://localhost:8181/
api: http://localhost:8181/api/v1/users/[uuid]
webroot: @../Build/Products/Debug/webroot
db: sqlite3 @../Build/Products/Debug/db

[GET] no uuid for all
[POST] [PATCH] [DELETE] uuid required

for
