//
//  NetworkUtils.swift
//  CoreNetworking
//
//  Created by Thanh Vu on 18/10/2021.
//

import Foundation

public struct NetworkUtils {
    public static func commonJSONDecoder() -> JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

        return jsonDecoder
    }

    public static func decodeAPIResponse<ResponseType: Codable>(type: ResponseType.Type, data: Data) throws -> ResponseType {
        let jsonDecoder = commonJSONDecoder()

        do {
            let response = try jsonDecoder.decode(type, from: data)
            return response
        } catch {
            throw CoreNetworkingError.codableError(error)
        }
    }

    public static func decodeAPIResponseToDictionary<T>(data: Data) throws -> T? {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? T else {
            return nil
        }

        return json
    }

    public static func getAPIBody(fromData data: Data) throws -> Data {
        guard let responseJSON: [String: Any]? = try NetworkUtils.decodeAPIResponseToDictionary(data: data),
              let dataJSON = responseJSON?["data"] as? [String: Any] else {
            throw CoreNetworkingError.responseJSONError
        }

        return try JSONSerialization.data(withJSONObject: dataJSON, options: [])
    }
}
