import Foundation
import RxSwift

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum ParamEncoding {
    case urlEncoding
    case jsonEncoding
}

public protocol HttpEndpointParams {
    func path() -> String
    func baseURL() -> String
    func method() -> HttpMethod
    func headers() -> [String: String]?
    func parameters() -> [String: Any]?
    func middleware() -> NetworkMiddleware
    func encoding() -> ParamEncoding
}

public protocol HttpEndpoint: HttpEndpointParams {
    associatedtype ResponseType

    func convertObject(data: Data) throws -> ResponseType
    func execute() -> Observable<ResponseType>
}

public extension HttpEndpoint {
    func method() -> HttpMethod {
        return .get
    }

    func headers() -> [String: String]? {
        return defaultHeader()
    }

    func defaultHeader() -> [String: String] {
        let appInfo = NSDictionary(contentsOf: Bundle.main.url(forResource: "Info", withExtension: "plist")!)
        let appVersion = (appInfo?[kCFBundleVersionKey as String] as? String) ?? "Unknowned"
        return [
            "os": "ios",
            "os_version": UIDevice.current.systemVersion,
            "app_version": appVersion
        ]
    }

    func parameters() -> [String: Any]? {
        return nil
    }

    func baseURL() -> String {
        return StaticConfig.apiBaseURLString
    }

    func middleware() -> NetworkMiddleware {
        return PassthroughMiddleware()
    }

    func encoding() -> ParamEncoding {
        return .jsonEncoding
    }

    func execute() -> Observable<ResponseType> {
        let client = getNetworkClient()
        return Observable<ResponseType>.create { observer in
            return client.request(endpoint: self)
                .flatMapLatest({ data in
                    return self.middleware().processData(data: data)
                })
                .subscribe { data in
                    let result = Result { try self.convertObject(data: data) }
                    switch result {
                    case .success(let response):
                        observer.onNext(response)
                    case .failure(let error):
                        observer.onError(error)
                    }
                } onError: { error in
                    observer.onError(error)
                } onCompleted: {
                    observer.onCompleted()
                }
        }
    }
}
