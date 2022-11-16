//
//  RegisterAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 08/11/2022.
//

import Foundation

class RegisterAPI: HttpEndpoint {
    var username: String
    var password: String
    var name: String
    var address: String
    var phoneNumber: String

    init(username: String, password: String, name: String, address: String, phoneNumber: String) {
        self.username = username
        self.password = password
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
    }

    func path() -> String {
        return "api/auth/register"
    }

    func method() -> HttpMethod {
        .post
    }

    func middleware() -> NetworkMiddleware {
        return SolarCatchErrorMiddleware()
    }

    func parameters() -> [String: Any]? {
        return [
            "username": self.username,
            "password": self.password,
            "role": "TC-users",
            "name": self.name,
            "phoneNumber": self.phoneNumber,
            "address": self.address
        ]
    }

    func convertObject(data: Data) throws -> LoginResponse {
        let response = try JSONDecoder().decode(CommonResponse<LoginResponseEntity>.self, from: data)
        return LoginResponse(entity: response.data)
    }
}
