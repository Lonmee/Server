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

func userHandler(request: HTTPRequest, response: HTTPResponse) {
    var data = [[String: Any]]();
    if let id = request.urlVariables["id"] {
        print("do \(request.method) \nto user: \(id) \ntoken: \(request.session!.token) create: \(request.session!.created)")
        data = contentArr
    } else {
        let crud = UserCRUD()
        crud.update()
        crud.read()
        let parentCRUD = ParentCRUD()
        do {
            try parentCRUD.test()
        } catch {
            print(error)
        }
    }
    data = contentArr
    
    response.setHeader(.contentType, value: "text/html")
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
    response.completed()
}

func storyHandler(request: HTTPRequest, response: HTTPResponse) {
    if let id = request.urlVariables["id"] {
        print("do \(request.method) to story:\(id)")
    } else {
        print("do \(request.method) to stories")
    }
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: """
<html>
    <title>PerfectHTTPServer</title>
    <body>
        \(request.method):\(String(describing: request.urlVariables["id"]))token: \(request.session!.token)
    </body>
</html>
""")
    response.completed()
}
