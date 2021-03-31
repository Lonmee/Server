import PerfectHTTP
import PerfectHTTPServer
import PerfectSession

var routes = Routes()
// root
routes.add(method: .get, uri: "/", handler: rootHandler)
routes.add(method: .get, uri: "/**", handler: StaticFileHandler(documentRoot: "./webroot", allowResponseFilters: true).handleRequest)
// api
var apiRoutes = Routes(baseUri: "/api", handler: apiHandler)
// version
var verRoutes = Routes(baseUri: "/v1", handler: verHandler)
// users
verRoutes.add(uris: ["/users", "/users/{id}"], handler: userHandler)
// login
verRoutes.add(uris: ["/login/{id}"], handler: loginHandler)
apiRoutes.add(verRoutes)
routes.add(apiRoutes)

let sessionDriver = SessionMemoryDriver()

do {
    try HTTPServer.launch(name: "localhost",
                          port: 8181,
                          routes: routes,
                          requestFilters: [
                            sessionDriver.requestFilter,
                          ],
                          responseFilters: [
                            (PerfectHTTPServer.HTTPFilter.contentCompression(data: [:]), HTTPFilterPriority.medium),
                            (Filter404(), HTTPFilterPriority.high),
                            sessionDriver.responseFilter,
                          ])
} catch {
    fatalError("\(error)")
}
