//
//  UpdateDeviceAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 06/12/2022.
//

import Foundation

class UpdateDeviceAPI: HttpEndpoint {
    var name: String
    var description: String
    var gardenId: String
    var accessToken: String
    var deviceType: String
    var deviceId: String

    init(name: String, description: String, gardenId: String, accessToken: String, deviceType: String, deviceId: String) {
        self.name = name
        self.description = description
        self.gardenId = gardenId
        self.accessToken = accessToken
        self.deviceType = deviceType
        self.deviceId = deviceId
    }

    func path() -> String {
        return "api/garden/\(self.gardenId)/device/\(self.deviceId)"
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
            "description": self.description,
            "type": self.deviceType
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
