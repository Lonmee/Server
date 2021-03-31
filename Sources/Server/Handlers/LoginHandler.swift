//
//  File.swift
//  
//
//  Created by Lonmee on 3/31/21.
//

import Foundation
import PerfectHTTP

func loginHandler(request: HTTPRequest, response: HTTPResponse) {
    do {
        if request.method == .post {
            
        } else {
            throw HTTPResponseError(status: .forbidden, description: "calling by post only")
        }
    } catch {
        completeResponseWithError(request: request, response: response, error: error)
    }
}

