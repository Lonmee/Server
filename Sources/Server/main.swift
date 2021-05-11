import PerfectHTTP
import PerfectHTTPServer
import PerfectSession

// MARK: routes config
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

// MARK: session config
let sessionDriver = SessionMemoryDriver()
// 总开关；默认为关闭。
SessionConfig.CORS.enabled = true

// 允许进行跨来源资源共享的主机清单。
// 如果希望不限制任何主机访问，则只需要保留一个通配符元素“*”即可。
//SessionConfig.CORS.acceptableHostnames = ["*"]

// 否则如果需要追加特定域名
//SessionConfig.CORS.acceptableHostnames.append("http://www.test-cors.org")

// 在域名中的开始和结束可以使用通配符
//SessionConfig.CORS.acceptableHostnames.append("*.example.com")
//SessionConfig.CORS.acceptableHostnames.append("http://www.domain.*")
SessionConfig.CORS.acceptableHostnames.append("http://localhost:*")

// 允许使用的方法列表
public var methods: [HTTPMethod] = [.get, .post, .put, .delete]

// 允许的自定义头数据
public var customHeaders = [String]()

// Access-Control-Allow-Credentials 是否允许访问机密信息
// 默认情况下标准 CORS 请求不会发送或者设置任何cookies。
// 如果希望允许在跨域请求中使用cookies，则请将此处设置为真。
public var withCredentials = false

// 内容缓冲时限，单位时秒
// 默认为0，也就是关闭内容缓冲
public var maxAge = 3600

// MARK: launch server
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
