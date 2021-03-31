//
//  File.swift
//  
//
//  Created by Lonmee on 3/31/21.
//

import Foundation
import PerfectHTTP

var userCrud = UserCRUD()
func userHandler(request: HTTPRequest, response: HTTPResponse) {
    var data = [User]()
    // request.session!.token
    do {
        switch request.method {
        case .post:
            let json = request.param(name: "content")!.data(using: .utf8)!
            let decoder = JSONDecoder()
            let users = try decoder.decode([User].self, from: json)
            data = try userCrud.create(users)
        case .get:
            let id = request.urlVariables["id"]
            let name = request.param(name: "name", defaultValue: "")
            data = name!.isEmpty ? try userCrud.retrieve(id) : try userCrud.retrieve(name: name)
        case .patch:
            let json = request.param(name: "content")!.data(using: .utf8)!
            let decoder = JSONDecoder()
            let users = try decoder.decode([User].self, from: json)
            data = try userCrud.update(users)
        case .delete:
            if let id = request.urlVariables["id"] {
                data = try userCrud.delete(id)
            }
        default:
            print(request.method)
        }
        try response.setBody(json: data, encoder: JSONEncoder())
        response.completed()
    } catch {
        completeResponseWithError(request: request, response: response, error: error)
    }
}
