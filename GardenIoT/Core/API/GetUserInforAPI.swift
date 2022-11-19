//
//  GetUserInforAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 17/11/2022.
//

import Foundation

class GetUserInforAPI: HttpEndpoint {
    var accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    func path() -> String {
        return "api/user/user-info"
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

    func convertObject(data: Data) throws -> Account {
        let response = try JSONDecoder().decode(CommonResponse<AccountEntity>.self, from: data)
        return Account(entity: response.data)
    }
}
