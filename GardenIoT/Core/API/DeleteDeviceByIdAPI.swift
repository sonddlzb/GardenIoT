//
//  DeleteDeviceByIdAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 07/12/2022.
//

import Foundation

class DeleteDeviceByIdAPI: HttpEndpoint {
    var accessToken: String
    var gardenId: String
    var deviceId: String

    init(accessToken: String, gardenId: String, deviceId: String) {
        self.accessToken = accessToken
        self.gardenId = gardenId
        self.deviceId = deviceId
    }

    func path() -> String {
        return "api/garden/\(self.gardenId)/device/\(self.deviceId)"
    }

    func method() -> HttpMethod {
        .delete
    }

    func middleware() -> NetworkMiddleware {
        return SolarCatchErrorMiddleware()
    }

    func headers() -> [String: String]? {
        return ["Authorization": "Bearer \(accessToken)"]
    }

    func convertObject(data: Data) throws -> Any {
        do {
            let response = try JSONDecoder().decode(CommonResponse<DeleteResponseEntity>.self, from: data)
            return DeleteResponse(entity: response.data)
        } catch {
            let response = try JSONDecoder().decode(ClientFailedResponse<String>.self, from: data)
            return response.message
        }
    }
}
