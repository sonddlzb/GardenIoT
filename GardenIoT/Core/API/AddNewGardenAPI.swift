//
//  UpdateUserInforAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 23/11/2022.
//

import Foundation

class AddNewGardenAPI: HttpEndpoint {
    var accessToken: String
    var name: String
    var address: String

    init(accessToken: String, name: String, address: String) {
        self.accessToken = accessToken
        self.name = name
        self.address = address
    }

    func path() -> String {
        return "api/garden"
    }

    func method() -> HttpMethod {
        .post
    }

    func parameters() -> [String: Any]? {
        return [
            "name": self.name,
            "address": self.address
        ]
    }

    func headers() -> [String: String]? {
        return ["Authorization": "Bearer \(accessToken)"]
    }

    func middleware() -> NetworkMiddleware {
        return SolarCatchErrorMiddleware()
    }

    func convertObject(data: Data) throws -> Any {
        do {
            let response = try JSONDecoder().decode(CommonResponse<GardenEntity>.self, from: data)
            return Garden(entity: response.data)
        } catch {
            let response = try JSONDecoder().decode(ClientFailedResponse<String>.self, from: data)
            return response.message
        }
    }
}
