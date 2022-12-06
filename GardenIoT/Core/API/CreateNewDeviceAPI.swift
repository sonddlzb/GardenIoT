//
//  CreateNewDeviceAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 06/12/2022.
//

import Foundation

class CreateNewDeviceAPI: HttpEndpoint {
    var name: String
    var description: String
    var gardenId: String
    var accessToken: String

    init(name: String, description: String, gardenId: String, accessToken: String) {
        self.name = name
        self.description = description
        self.gardenId = gardenId
        self.accessToken = accessToken
    }

    func path() -> String {
        return "api/garden/\(self.gardenId)/device"
    }

    func method() -> HttpMethod {
        .post
    }

    func middleware() -> NetworkMiddleware {
        return SolarCatchErrorMiddleware()
    }

    func parameters() -> [String: Any]? {
        return [
            "name": self.name,
            "description": self.description
        ]
    }

    func headers() -> [String: String]? {
        return ["Authorization": "Bearer \(accessToken)"]
    }

    func convertObject(data: Data) throws -> Any {
        do {
            let response = try JSONDecoder().decode(CommonResponse<DeviceEntity>.self, from: data)
            return Device(entity: response.data)
        } catch {
            let response = try JSONDecoder().decode(ClientFailedResponse<String>.self, from: data)
            return response.message
        }
    }
}

