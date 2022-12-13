//
//  GetAllDevicesAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 07/12/2022.
//

import Foundation

class GetAllDevicesAPI: HttpEndpoint {
    var accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    func path() -> String {
        return "api/device"
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
