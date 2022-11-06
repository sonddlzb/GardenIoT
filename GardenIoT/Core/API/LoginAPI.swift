//
//  loginAPI.swift
//  GardenIoT
//
//  Created by đào sơn on 06/11/2022.
//

import Foundation

class LoginAPI: HttpEndpoint {
    var username: String
    var password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    func path() -> String {
        return "api/login"
    }

    func method() -> HttpMethod {
        .post
    }

    func middleware() -> NetworkMiddleware {
        return SolarCatchErrorMiddleware()
    }

    func parameters() -> [String : Any]? {
        return [
            "username": self.username,
            "password": self.password
        ]
    }

    func convertObject(data: Data) throws -> LoginResponse {
        let response = try JSONDecoder().decode(CommonResponse<LoginResponseEntity>.self, from: data)
        return LoginResponse(entity: response.data)
    }
}
