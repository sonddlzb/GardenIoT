//
//  UpdateGardenAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 13/12/2022.
//

import Foundation

class UpdateGardenAPI: HttpEndpoint {
    var name: String
    var address: String
    var gardenId: String
    var accessToken: String

    init(name: String, address: String, gardenId: String, accessToken: String) {
        self.name = name
        self.address = address
        self.gardenId = gardenId
        self.accessToken = accessToken
    }

    func path() -> String {
        return "api/garden/\(self.gardenId)"
    }

    func method() -> HttpMethod {
        .patch
    }

    func middleware() -> NetworkMiddleware {
        return SolarCatchErrorMiddleware()
    }

    func parameters() -> [String: Any]? {
        return [
            "name": self.name,
            "address": self.address,
        ]
    }

    func headers() -> [String: String]? {
        return ["Authorization": "Bearer \(accessToken)"]
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

