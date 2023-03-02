//
//  ChangeDeviceStatusAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 01/03/2023.
//

import Foundation

class ChangeDeviceStatusAPI: HttpEndpoint {
    var accessToken: String
    var deviceId: String
    var isOn: Bool

    init(accessToken: String, deviceId: String, isOn: Bool) {
        self.accessToken = accessToken
        self.deviceId = deviceId
        self.isOn = isOn
    }

    func path() -> String {
        return "api/device/action/\(self.deviceId)"
    }

    func method() -> HttpMethod {
        .put
    }

    func parameters() -> [String: Any]? {
        return [
            "isOn": self.isOn
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
            let response = try JSONDecoder().decode(CommonResponse<DeviceEntity>.self, from: data)
            return Device(entity: response.data)
        } catch {
            let response = try JSONDecoder().decode(ClientFailedResponse<String>.self, from: data)
            return response.message
        }
    }
}
