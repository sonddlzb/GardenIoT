//
//  GetAllDevicesByGardenIdAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 08/12/2022.
//
import Foundation

class GetAllDevicesByGardenIdAPI: HttpEndpoint {
    var accessToken: String
    var gardenId: String

    init(accessToken: String, gardenId: String) {
        self.accessToken = accessToken
        self.gardenId = gardenId
    }

    func path() -> String {
        return "api/garden/\(self.gardenId)/device"
    }

    func method() -> HttpMethod {
        .get
    }

    func middleware() -> NetworkMiddleware {
        return SolarCatchErrorMiddleware()
    }

    func headers() -> [String: String]? {
        return ["Authorization": "Bearer \(accessToken)"]
    }

    func convertObject(data: Data) throws -> [Device] {
        let response = try JSONDecoder().decode(CommonResponse<[DeviceEntity]>.self, from: data)
        return response.data.map({
            Device(entity: $0)
        })
    }
}

