import Foundation

import Alamofire
import RxSwift
import TLLogging

public protocol NetworkClient {
    func request(endpoint: HttpEndpointParams) -> Observable<Data>
    func upload(url: String, data: Data) -> Observable<Data?>
}

public enum CoreNetworkingError: Error, Equatable {
    case noInternet
    case timeout
    case internalServerError
    case notfound
    case codableError(Error)
    case cancelled
    case badURL
    case serverCertificateHasBadDate
    case clientError
    case unknowError
    case responseJSONError

    public static func == (lhs: CoreNetworkingError, rhs: CoreNetworkingError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

class AlamofireClient: NetworkClient {
    static var sharedSessionManager: Session?
    lazy var sessionManager: Session = {
        guard let sharedManager = AlamofireClient.sharedSessionManager else {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 30
            config.timeoutIntervalForResource = 30
            let manager = Session(configuration: config)
            AlamofireClient.sharedSessionManager = manager
            return manager
        }

        return sharedManager
    }()

    func request(endpoint: HttpEndpointParams) -> Observable<Data> {
        let url = "\(endpoint.baseURL())/\(endpoint.path())"
        return Observable<Data>.create { observer in
            self.sessionManager.request(url,
                                        method: HTTPMethod(rawValue: endpoint.method().rawValue),
                                        parameters: endpoint.parameters(),
                                        encoding: endpoint.encoding() == .jsonEncoding ? JSONEncoding.default : URLEncoding.default,
                                        headers: HTTPHeaders(endpoint.headers() ?? [:]))
                .responseData { (response) in
                    if let data = response.value {
                        TLLogging.log("📬 Received response from request: \n\(response.request!.cURL)")
                        observer.onNext(data)
                        return
                    }

                    if let error = self.errorFromResponse(response) {
                        TLLogging.log("📬 Received error \(error) from request: \n\(response.request!.cURL)")
                        observer.onError(error)
                    }
                }

            return Disposables.create()
        }.take(1)
    }

    func upload(url: String, data: Data) -> Observable<Data?> {
        return Observable<Data?>.create { observer in
            self.sessionManager.upload(data, to: url, method: .put, headers: nil).responseData { response in
                if let error = self.errorFromResponse(response) {
                    TLLogging.log("[NetworkClient] upload file url \(url), error: \(error)")
                    observer.onError(error)
                    return
                }

                TLLogging.log("[NetworkClient] uploaded file url \(url)")
                observer.onNext(response.data)
            }

            return Disposables.create()
        }
    }

    // MARK: - Helper
    private func errorFromResponse(_ response: AFDataResponse<Data>) -> Error? {
        if let statusCode = response.response?.statusCode,
            let statusCodeError = errorFrom(statusCode: statusCode) {
            return statusCodeError
        }

        if let error = response.error?.underlyingError {
            if let urlError = response.error?.underlyingError as? URLError {
                switch urlError {
                case URLError.Code.notConnectedToInternet,
                     URLError.Code.cannotFindHost,
                     URLError.Code.cannotConnectToHost,
                     URLError.Code.dataNotAllowed:
                    return CoreNetworkingError.noInternet
                case URLError.Code.timedOut:
                    return CoreNetworkingError.timeout
                case URLError.Code.cancelled:
                    return CoreNetworkingError.cancelled
                case URLError.Code.badURL:
                    return CoreNetworkingError.badURL
                case URLError.Code.serverCertificateHasBadDate:
                    return CoreNetworkingError.serverCertificateHasBadDate
                default:
                    return urlError
                }
            } else {
                return error
            }
        }

        return nil
    }

    private func errorFrom(statusCode: Int) -> Error? {
        switch statusCode {
        case 200...299:
            return nil
        case 400...499:
            return CoreNetworkingError.clientError
        case 500...599:
            return CoreNetworkingError.internalServerError
        default:
            return CoreNetworkingError.unknowError
        }
    }
}
