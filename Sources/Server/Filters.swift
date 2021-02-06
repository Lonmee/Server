//
//  File.swift
//  
//
//  Created by Lonmee on 2/5/21.
//
import PerfectHTTP

struct Filter404: HTTPResponseFilter {
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
    
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        if case .notFound = response.status {
            response.setHeader(.contentLanguage, value: "zh-cn")
            response.setBody(string: "<html><head><meta charset='UTF-8'></head><body>文件 \(response.request.path) 不存在。</body></html>")
            response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
            callback(.done)
        } else {
            callback(.continue)
        }
    }
}
