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
    response.setHeader(.contentType, value: "text/html")
    do {
        switch request.method {
        case .post:
            let json = request.param(name: "content")!.data(using: .utf8)!
            let decoder = JSONDecoder()
            let users = try decoder.decode([User].self, from: json)
            data = try userCrud.create(users)
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
