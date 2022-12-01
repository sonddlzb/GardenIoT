//
//  GetAllGardensAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 26/11/2022.
//

import Foundation

class GetAllGardensAPI: HttpEndpoint {
    var accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    func path() -> String {
        return "api/garden"
    }

    func method() -> HttpMethod {
        .get
    }

    func headers() -> [String: String]? {
        return ["Authorization": "Bearer \(accessToken)"]
    }

    func middleware() -> NetworkMiddleware {
        return SolarCatchErrorMiddleware()
    }

    func convertObject(data: Data) throws -> [Garden] {
        let response = try JSONDecoder().decode(CommonResponse<[GardenEntity]>.self, from: data)
        return (response.data.map({
            Garden(entity: $0)
        }))
    }
}
