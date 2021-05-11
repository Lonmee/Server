//
//  File.swift
//  
//
//  Created by Lonmee on 2/6/21.
//

import Foundation
import PerfectHTTP

func rootHandler(request: HTTPRequest, response: HTTPResponse) {
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: """
<html>
    <head>
        <link rel="shortcut icon" href="favicon.ico">
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

func completeResponseWithError(request: HTTPRequest, response: HTTPResponse, error: Error) -> Void {
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
    response.completed()
}
