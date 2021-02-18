//
//  File.swift
//  
//
//  Created by Lonmee on 2/6/21.
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectSession
import OAuth2
import Foundation

func rootHandler(request: HTTPRequest, response: HTTPResponse) {
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: """
<html>
    <head>
        <link rel="shortcut icon" href="favicon.ico" >
    </head>
    <title>PerfectHTTP</title>
    <body>Hello, PerfectHTTP!</body>
</html>
""")
    response.completed()
}

func apiHandler(request: HTTPRequest, response: HTTPResponse) {
    if authorized(request) {
        response.next()
    } else {
        response.completed()
    }
}

func authorized(_: HTTPRequest) -> Bool {
    return true
}

func verHandler(request: HTTPRequest, response: HTTPResponse) {
    response.next()
}

// Users
var userCrud = UserCRUD()
func userHandler(request: HTTPRequest, response: HTTPResponse) {
    var data = [User]()
    let id = request.urlVariables["id"]
    // request.session!.token
    let uuid1 = UUID()
    let uuid2 = UUID()
    let users = [User(id: uuid1, name: "Lonmee", sex: true, age: 33, contact: [Contact(uid: uuid1, phone: "1234", email: "1234", qq: "1234", wechat: "1234"),
                                                                               Contact(uid: uuid1, phone: "5678", email: "1234", qq: "1234", wechat: "1234")]),
                 User(id: uuid2, name: "Lunar", sex: false, age: 33, contact: [Contact(uid: uuid2, phone: "1234", email: "1234", qq: "1234", wechat: "1234")])]
    response.setHeader(.contentType, value: "text/html")
    do {
        switch request.method {
        case .post:
            try data = userCrud.create(users)
        case .get:
            data = userCrud.retrieve(id)
        case .patch:
            data = userCrud.update(id)
        case .delete:
            data = userCrud.delete(id)
        default:
            print(request.method)
        }
        response.appendBody(string: """
    <html>
        <title>PerfectHTTPServer</title>
        <body>
            method: \(request.method)
            <br>id: \(String(describing: request.urlVariables["id"]))
            <br>token: \(request.session!.token)
            <br>data: \(data)
        </body>
    </html>
    """)
    } catch {
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: """
    <html>
        <title>PerfectHTTPServer</title>
        <body>
            method: \(request.method)
            <br>id: \(String(describing: request.urlVariables["id"]))
            <br>token: \(request.session!.token)
            <br>error: \(error)
        </body>
    </html>
    """)
    }
    response.completed()
}

/// GET方法向特定路由发出请求，其中从客户端发向服务器的所有参数包含在URL字符串中。使用GET方法发出的请求只能接收数据，不能由其它作用。使用GET请求来删除数据库的一条记录是可行的，但是不推荐这么做。
/// POST方法通常用于向数据库内发送创建一条新记录的表单，比如在一个网站上填写好一个表单后提交给服务器。每个表单中都有成对出现的字段名和字段值，便于API服务器读取这些变量信息。
/// PATCH方法整体上来说和POST差不多，但是用于更新记录，而不是新建记录。
/// PUT方法主要用于上传文件，一个典型的PUT请求通常会在其消息体内部包含一个即将发给服务器的文件。
/// DELETE请求用于通知API服务器删除特定资源。通常在其URL中会包含一个唯一的标识信息。
