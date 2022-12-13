//
//  GetGardenByIdAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 07/12/2022.
//

import Foundation

class GetGardenByIdAPI: HttpEndpoint {
    var accessToken: String
    var gardenId: String

    init(accessToken: String, gardenId: String) {
        self.accessToken = accessToken
        self.gardenId = gardenId
    }

    func path() -> String {
        return "api/garden/\(self.gardenId)"
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

    func convertObject(data: Data) throws -> Garden {
        let response = try JSONDecoder().decode(CommonResponse<GardenEntity>.self, from: data)
        return Garden(entity: response.data)
    }
}
