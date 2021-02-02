import PerfectHTTP
import PerfectHTTPServer

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func handler(request: HTTPRequest, response: HTTPResponse) {
    // Respond with a simple message.
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
    // Ensure that response.completed() is called when your processing is done.
    response.completed()
}

createTable()

// Configure one server which:
//    * Serves the hello world message at <host>:<port>/
//    * Serves static files out of the "./webroot"
//        directory (which must be located in the current working directory).
//    * Performs content compression on outgoing data when appropriate.

do {
    var routes = Routes()
    routes.add(method: .get, uri: "/", handler: handler)
    routes.add(method: .get, uri: "/**",
               handler: StaticFileHandler(documentRoot: "./webroot", allowResponseFilters: true).handleRequest)
    try HTTPServer.launch(name: "localhost",
                          port: 8181,
                          routes: routes,
                          responseFilters: [
                            (PerfectHTTPServer.HTTPFilter.contentCompression(data: [:]), HTTPFilterPriority.high)])
} catch {
    fatalError("\(error)")
}
