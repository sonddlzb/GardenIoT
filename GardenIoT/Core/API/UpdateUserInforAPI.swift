//
//  UpdateUserInforAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 23/11/2022.
//

import Foundation

class UpdateUserInforAPI: HttpEndpoint {
    var accessToken: String
    var userId: String
    var account: Account

    init(accessToken: String, userId: String, account: Account) {
        self.accessToken = accessToken
        self.userId = userId
        self.account = account
    }

    func path() -> String {
        return "api/user/\(self.userId)"
    }

    func method() -> HttpMethod {
        .patch
    }

    func parameters() -> [String: Any]? {
        return [
            "name": self.account.name,
            "address": self.account.address,
            "phoneNumber": self.account.phoneNumber
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
            let response = try JSONDecoder().decode(CommonResponse<AccountEntity>.self, from: data)
            return Account(entity: response.data)
        } catch {
            let response = try JSONDecoder().decode(ClientFailedResponse<String>.self, from: data)
            return response.message
        }
    }
}
