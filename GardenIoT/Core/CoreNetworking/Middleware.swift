//
//  Middleware.swift
//  CoreNetworking
//
//  Created by Thanh Vu on 18/10/2021.
//

import Foundation
import RxSwift

public protocol NetworkMiddleware {
    func processData(data: Data) -> Observable<Data>
}

public class PassthroughMiddleware: NetworkMiddleware {
    public func processData(data: Data) -> Observable<Data> {
        return Observable.just(data)
    }
}

public class SolarCatchErrorMiddleware: NetworkMiddleware {
    private class Response: Codable {
        var message1: String?
    }

    public init() {
        // nothing
    }

    public func processData(data: Data) -> Observable<Data> {
        do {
            let response = try NetworkUtils.decodeAPIResponse(type: Response.self, data: data)
//            if response.errorCode != .success {
//                return Observable.error(response.errorCode)
//            }

            return Observable.just(data)
        } catch {
            return Observable.error(error)
        }
    }
}
